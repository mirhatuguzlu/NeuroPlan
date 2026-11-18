-- Odak, beyin ve abonelik tabloları (docs/DB_SCHEMA.md §4).

create table public.focus_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  plan_instance_id uuid,
  activity_id uuid,
  -- Oturum anındaki kopya: kategori sonradan taşınsa da geçmiş değişmez (CAT-4).
  category_id uuid,
  root_category_key text references public.root_categories (key),
  -- Beyne yalnız sayaçlı oturumlar katkı verir (D20); sayaçsız kayıt modu yok.
  mode text not null check (mode in ('free', 'pomodoro', 'deep')),
  settings jsonb check (settings is null or jsonb_typeof(settings) = 'object'),
  planned_minutes integer check (planned_minutes > 0),
  started_at timestamptz not null,
  ended_at timestamptz,
  focused_seconds integer not null default 0 check (focused_seconds >= 0),
  segments jsonb not null default '[]'::jsonb check (jsonb_typeof(segments) = 'array'),
  outcome text not null default 'in_progress' check (outcome in ('in_progress', 'completed', 'broken')),
  focus_rating smallint check (focus_rating between 1 and 5),
  fatigue_rating smallint check (fatigue_rating between 1 and 5),
  note text check (char_length(note) <= 2000),
  unique (user_id, id),
  foreign key (user_id, plan_instance_id) references public.plan_instances (user_id, id),
  foreign key (user_id, activity_id) references public.activities (user_id, id),
  foreign key (user_id, category_id) references public.user_categories (user_id, id),
  check (ended_at >= started_at),
  check ((outcome = 'in_progress') = (ended_at is null)),
  check (ended_at is null or focused_seconds <= extract(epoch from ended_at - started_at) + 1)
);

create table public.focus_interruptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  session_id uuid not null,
  left_at timestamptz not null,
  away_ms integer not null check (away_ms >= 0),
  reason text not null check (reason in ('app_left', 'notification_shade', 'screen_off', 'phone_call', 'alarm', 'other')),
  recovered boolean not null,
  counted boolean not null,
  unique (user_id, id),
  foreign key (user_id, session_id) references public.focus_sessions (user_id, id)
);

create table public.brain_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  type text not null check (type in ('neuron_gain', 'connection_gain', 'fade', 'penalty')),
  region_key text references public.brain_regions (key),
  region_b_key text references public.brain_regions (key),
  amount integer not null,
  occurred_at timestamptz not null,
  session_id uuid,
  dedupe_key text not null check (char_length(dedupe_key) between 1 and 200),
  engine_version integer not null check (engine_version > 0),
  unique (user_id, id),
  -- İki cihaz ya da sunucu aynı olayı üretirse tek satır kalır.
  unique (user_id, dedupe_key),
  foreign key (user_id, session_id) references public.focus_sessions (user_id, id),
  check ((type = 'connection_gain') = (region_b_key is not null))
);

-- Sunucunun hesapladığı anlık görüntü (sıralama, arkadaş karşılaştırma); istemci yalnız okur.
create table public.brain_snapshots (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  engine_version integer not null check (engine_version > 0),
  as_of timestamptz not null,
  events_hash text not null,
  state jsonb not null check (jsonb_typeof(state) = 'object'),
  unique (user_id, engine_version)
);

-- Aşama 6'da satın alma doğrulayan Edge Function doldurur; satır yoksa plan "free".
create table public.entitlements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null unique references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  plan text not null default 'free' check (plan in ('free', 'premium')),
  status text not null default 'active' check (status in ('active', 'grace', 'expired', 'revoked')),
  store text check (store in ('play', 'app_store', 'promo')),
  product_id text,
  purchase_token_hash text,
  expires_at timestamptz
);

-- Biten oturum değişmez; beyin bu kayıttan türetilir. Yalnız puan, not ve silme değişebilir.
create or replace function public.focus_sessions_guard()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  v_mutable text[] := array['focus_rating', 'fatigue_rating', 'note', 'deleted_at',
                            'updated_at', 'version', 'field_versions'];
begin
  if old.outcome <> 'in_progress' and (to_jsonb(new) - v_mutable) <> (to_jsonb(old) - v_mutable) then
    raise exception 'biten odak oturumu değiştirilemez' using errcode = '23514';
  end if;
  return new;
end
$$;

create or replace function public.append_only_guard()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  raise exception '% yalnız eklenir', tg_table_name using errcode = '23514';
end
$$;

create trigger bb_guard before update on public.focus_sessions
  for each row execute function public.focus_sessions_guard();
create trigger bb_append_only before update on public.focus_interruptions
  for each row execute function public.append_only_guard();
create trigger bb_append_only before update on public.brain_events
  for each row execute function public.append_only_guard();

do $$
declare t text;
begin
  -- İstemcinin yazdığı tablolar.
  foreach t in array array['focus_sessions', 'focus_interruptions', 'brain_events'] loop
    execute format('create trigger aa_sync before insert or update on public.%I for each row execute function public.sync_before_write()', t);
    execute format('alter table public.%I enable row level security', t);
    execute format('create policy %I on public.%I for select to authenticated using (user_id = (select auth.uid()))', t || '_select_own', t);
    execute format('create policy %I on public.%I for insert to authenticated with check (user_id = (select auth.uid()))', t || '_insert_own', t);
    execute format('create policy %I on public.%I for update to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()))', t || '_update_own', t);
    execute format('create index %I on public.%I (user_id, version)', t || '_user_version', t);
  end loop;
  -- Yalnız sunucunun yazdığı tablolar: istemciye yalnız okuma.
  foreach t in array array['brain_snapshots', 'entitlements'] loop
    execute format('create trigger aa_sync before insert or update on public.%I for each row execute function public.sync_before_write()', t);
    execute format('alter table public.%I enable row level security', t);
    execute format('create policy %I on public.%I for select to authenticated using (user_id = (select auth.uid()))', t || '_select_own', t);
  end loop;
end
$$;
