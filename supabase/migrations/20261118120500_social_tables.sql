-- Sosyal tablolar (docs/DB_SCHEMA.md §5). Aşama 4B'de kullanılacak; şema ve görünürlük şimdiden.
-- Bu aşamada: okuma politikaları + kendi satırına yazılan tablolar. Başkasını ilgilendiren yazmalar
-- (davet kullanma, arkadaşlık, partner, sohbet, mesaj, katılımcı) 4B'de security definer RPC olarak gelir.
-- Misafir (anonim) kullanıcı hiçbir sosyal tabloya yazamaz.

create or replace function public.is_anonymous()
returns boolean
language sql
stable
set search_path = ''
as $$ select coalesce((auth.jwt() ->> 'is_anonymous')::boolean, false) $$;

create or replace function public.gen_invite_code()
returns text
language sql
volatile
set search_path = ''
as $$
  -- Birbirine benzemeyen 31 karakter (0/O, 1/I/L yok); kriptografik rastgele baytlar.
  select string_agg(substr('ABCDEFGHJKMNPQRSTUVWXYZ23456789', (get_byte(b, i) % 31) + 1, 1), '' order by i)
  from (select extensions.gen_random_bytes(10) as b) r, generate_series(0, 9) i
$$;

create table public.friendships (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  friend_id uuid not null references auth.users (id) on delete cascade,
  status text not null default 'pending' check (status in ('pending', 'accepted')),
  is_partner boolean not null default false,
  partner_requested_by uuid references auth.users (id) on delete set null,
  check (friend_id <> user_id)
);
create unique index friendships_pair on public.friendships
  (least(user_id, friend_id), greatest(user_id, friend_id)) where deleted_at is null;

create table public.invites (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  code text not null unique default public.gen_invite_code(),
  kind text not null default 'friend' check (kind in ('friend', 'partner')),
  expires_at timestamptz not null default now() + interval '7 days',
  max_uses smallint not null default 1 check (max_uses > 0),
  use_count smallint not null default 0 check (use_count >= 0 and use_count <= max_uses),
  revoked_at timestamptz
);

create table public.blocks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  blocked_user_id uuid not null references auth.users (id) on delete cascade,
  check (blocked_user_id <> user_id)
);
create unique index blocks_pair on public.blocks (user_id, blocked_user_id) where deleted_at is null;

create table public.visibility_settings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  viewer_id uuid references auth.users (id) on delete cascade,
  audience text check (audience in ('friends', 'partner')),
  category_id uuid,
  root_category_key text references public.root_categories (key),
  level text not null check (level in ('full', 'title_time', 'busy', 'hidden')),
  foreign key (user_id, category_id) references public.user_categories (user_id, id),
  check ((viewer_id is null) <> (audience is null)),
  check (category_id is null or root_category_key is null)
);

create table public.shared_activities (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  title text not null check (char_length(title) between 1 and 200),
  notes text check (char_length(notes) <= 2000),
  start_at timestamptz,
  end_at timestamptz,
  root_category_key text references public.root_categories (key),
  status text not null default 'proposed' check (status in ('proposed', 'confirmed', 'cancelled')),
  check (end_at >= start_at)
);

create table public.shared_activity_participants (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  shared_activity_id uuid not null references public.shared_activities (id) on delete cascade,
  status text not null default 'invited' check (status in ('invited', 'accepted', 'declined')),
  unique (shared_activity_id, user_id)
);

create table public.cofocus_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  mode text not null check (mode in ('free', 'pomodoro', 'deep')),
  settings jsonb check (settings is null or jsonb_typeof(settings) = 'object'),
  planned_start_at timestamptz,
  started_at timestamptz,
  ended_at timestamptz,
  -- Ses kaydedilmez, sesle ilgili veri tutulmaz (SOCIAL-3); room_id yalnız sağlayıcı oda kimliği.
  voice_enabled boolean not null default false,
  room_id text check (char_length(room_id) <= 200),
  status text not null default 'scheduled' check (status in ('scheduled', 'live', 'ended')),
  check (ended_at >= started_at)
);

create table public.cofocus_participants (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  cofocus_session_id uuid not null references public.cofocus_sessions (id) on delete cascade,
  joined_at timestamptz,
  left_at timestamptz,
  -- Beyne katkı katılımcının kendi oturumundan gelir.
  focus_session_id uuid,
  unique (cofocus_session_id, user_id),
  foreign key (user_id, focus_session_id) references public.focus_sessions (user_id, id)
);

create table public.conversations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  -- Grup sohbeti açık konu (SOCIAL-6).
  kind text not null default 'direct' check (kind = 'direct'),
  direct_key text unique
);

create table public.conversation_members (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  last_read_at timestamptz,
  muted boolean not null default false,
  unique (conversation_id, user_id)
);

create table public.messages (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  conversation_id uuid not null references public.conversations (id) on delete cascade,
  body text not null check (char_length(body) between 1 and 2000),
  reply_to_id uuid references public.messages (id) on delete set null,
  edited_at timestamptz
);
create index messages_conversation on public.messages (conversation_id, created_at);

create table public.reactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  message_id uuid not null references public.messages (id) on delete cascade,
  emoji text not null check (emoji in ('👍', '❤️', '😂', '🎉', '🔥', '💪')),
  unique (message_id, user_id, emoji)
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  -- Şikâyet edilen hesap silinse de kayıt moderasyon için kalır.
  reported_user_id uuid references auth.users (id) on delete set null,
  target_type text not null check (target_type in ('user', 'message', 'shared_activity', 'cofocus_session')),
  target_id uuid,
  reason text not null check (reason in ('spam', 'harassment', 'inappropriate', 'child_safety', 'other')),
  details text check (char_length(details) <= 2000),
  status text not null default 'open' check (status in ('open', 'reviewing', 'resolved'))
);

create table public.leaderboard_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  period text not null check (period in ('week', 'month')),
  period_start date not null,
  score integer not null,
  engine_version integer not null check (engine_version > 0),
  computed_at timestamptz not null default now(),
  unique (user_id, period, period_start)
);

-- Yardımcılar: security definer (RLS özyinelemesine girmeden kontrol eder).
create or replace function public.is_blocked(a uuid, b uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.blocks k
    where k.deleted_at is null
      and ((k.user_id = a and k.blocked_user_id = b) or (k.user_id = b and k.blocked_user_id = a))
  )
$$;

create or replace function public.is_friend(a uuid, b uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.friendships f
    where f.deleted_at is null and f.status = 'accepted'
      and ((f.user_id = a and f.friend_id = b) or (f.user_id = b and f.friend_id = a))
  ) and not public.is_blocked(a, b)
$$;

create or replace function public.is_partner(a uuid, b uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.friendships f
    where f.deleted_at is null and f.status = 'accepted' and f.is_partner
      and ((f.user_id = a and f.friend_id = b) or (f.user_id = b and f.friend_id = a))
  ) and not public.is_blocked(a, b)
$$;

create or replace function public.is_member(p_conversation uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.conversation_members m
    where m.conversation_id = p_conversation and m.user_id = auth.uid() and m.deleted_at is null
  )
$$;

-- Görünürlük düzeyi (DB_SCHEMA §5): en özel kural kazanır, kural yoksa "hidden".
-- Sıra: kişi + kategori > kişi > kitle (partner > arkadaşlar) + kategori > kitle; alt kategori en yakın ataya düşer.
create or replace function public.visibility_level(p_owner uuid, p_viewer uuid, p_category uuid, p_root text)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  with recursive ancestors(id, parent_id, depth) as (
    select c.id, c.parent_id, 0 from public.user_categories c
    where c.id = p_category and c.user_id = p_owner
    union all
    select c.id, c.parent_id, a.depth + 1
    from public.user_categories c join ancestors a on c.id = a.parent_id
    where a.depth < 1000
  )
  select case
    when p_owner = p_viewer then 'full'
    when not public.is_friend(p_owner, p_viewer) then 'hidden'
    else coalesce((
      select v.level
      from public.visibility_settings v
      left join ancestors a on a.id = v.category_id
      where v.user_id = p_owner and v.deleted_at is null
        and (v.viewer_id = p_viewer
             or v.audience = 'friends'
             or (v.audience = 'partner' and public.is_partner(p_owner, p_viewer)))
        and ((v.category_id is null and v.root_category_key is null)
             or v.root_category_key = p_root
             or a.id is not null)
      order by
        case when v.viewer_id is not null then 0 when v.audience = 'partner' then 1 else 2 end,
        case when a.id is not null then a.depth when v.root_category_key is not null then 1000 else 2000 end
      limit 1
    ), 'hidden')
  end
$$;

-- Arkadaşın takvimi, görünürlük düzeyi veritabanında uygulanmış olarak.
-- busy: yalnız zaman · title_time: + başlık · full: + kök kategori ve not · hidden: dönmez.
create or replace function public.friend_calendar(p_friend uuid, p_from timestamptz, p_to timestamptz)
returns table (
  instance_id uuid,
  start_at timestamptz,
  end_at timestamptz,
  level text,
  title text,
  root_category_key text,
  notes text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null or not public.is_friend(auth.uid(), p_friend) then
    raise exception 'yalnız arkadaşın takvimi görülebilir' using errcode = '42501';
  end if;
  if p_to <= p_from or p_to - p_from > interval '62 days' then
    raise exception 'aralık 0–62 gün olmalı' using errcode = '22023';
  end if;
  return query
  select x.id, x.start_at, x.end_at, x.lvl,
         case when x.lvl in ('title_time', 'full') then x.title end,
         case when x.lvl = 'full' then x.root_category_key end,
         case when x.lvl = 'full' then x.notes end
  from (
    select i.id, i.start_at, i.end_at, a.title, a.root_category_key, a.notes,
           public.visibility_level(p_friend, auth.uid(), a.category_id, a.root_category_key) as lvl
    from public.plan_instances i
    join public.activities a on a.id = i.activity_id
    where i.user_id = p_friend and i.deleted_at is null and a.deleted_at is null
      and i.status in ('planned', 'done')
      and i.start_at < p_to and i.end_at > p_from
  ) x
  where x.lvl <> 'hidden'
  order by x.start_at, x.id;
end
$$;

revoke execute on function public.friend_calendar(uuid, timestamptz, timestamptz) from public, anon;
grant execute on function public.friend_calendar(uuid, timestamptz, timestamptz) to authenticated;

-- Ortak: eşitleme tetikleyicisi (sürüm + updated_at) ve RLS.
do $$
declare t text;
begin
  foreach t in array array[
    'friendships', 'invites', 'blocks', 'visibility_settings', 'shared_activities',
    'shared_activity_participants', 'cofocus_sessions', 'cofocus_participants',
    'conversations', 'conversation_members', 'messages', 'reactions', 'reports', 'leaderboard_entries'
  ] loop
    execute format('create trigger aa_sync before insert or update on public.%I for each row execute function public.sync_before_write()', t);
    execute format('alter table public.%I enable row level security', t);
  end loop;

  -- Kendi satırına yazılan tablolar (misafir hariç).
  foreach t in array array['invites', 'blocks', 'visibility_settings', 'shared_activities', 'cofocus_sessions', 'reports'] loop
    execute format('create policy %I on public.%I for insert to authenticated with check (user_id = (select auth.uid()) and not public.is_anonymous())', t || '_insert_own', t);
  end loop;
  foreach t in array array['invites', 'blocks', 'visibility_settings', 'shared_activities', 'cofocus_sessions'] loop
    execute format('create policy %I on public.%I for update to authenticated using (user_id = (select auth.uid()) and not public.is_anonymous()) with check (user_id = (select auth.uid()))', t || '_update_own', t);
  end loop;
  foreach t in array array['invites', 'blocks', 'visibility_settings', 'reports'] loop
    execute format('create policy %I on public.%I for select to authenticated using (user_id = (select auth.uid()))', t || '_select_own', t);
  end loop;
end
$$;

create policy friendships_select_party on public.friendships for select to authenticated
  using ((select auth.uid()) in (user_id, friend_id));

-- Düzenleyen ya da katılımcı mı (iki tablo birbirine bakar; definer fonksiyon RLS özyinelemesini önler).
create or replace function public.is_shared_activity_party(p_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (select 1 from public.shared_activities s where s.id = p_id and s.user_id = auth.uid())
      or exists (select 1 from public.shared_activity_participants p
                 where p.shared_activity_id = p_id and p.user_id = auth.uid() and p.deleted_at is null)
$$;

create or replace function public.is_cofocus_party(p_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (select 1 from public.cofocus_sessions s where s.id = p_id and s.user_id = auth.uid())
      or exists (select 1 from public.cofocus_participants p
                 where p.cofocus_session_id = p_id and p.user_id = auth.uid() and p.deleted_at is null)
$$;

create policy shared_activities_select on public.shared_activities for select to authenticated
  using (public.is_shared_activity_party(id));
create policy shared_activity_participants_select on public.shared_activity_participants for select to authenticated
  using (public.is_shared_activity_party(shared_activity_id));
create policy cofocus_sessions_select on public.cofocus_sessions for select to authenticated
  using (public.is_cofocus_party(id));
create policy cofocus_participants_select on public.cofocus_participants for select to authenticated
  using (public.is_cofocus_party(cofocus_session_id));

create policy conversations_select_member on public.conversations for select to authenticated
  using (public.is_member(id));
create policy conversation_members_select on public.conversation_members for select to authenticated
  using (public.is_member(conversation_id));
create policy messages_select_member on public.messages for select to authenticated
  using (public.is_member(conversation_id));
create policy reactions_select_member on public.reactions for select to authenticated
  using (exists (select 1 from public.messages m where m.id = message_id and public.is_member(m.conversation_id)));

-- Sıralama yalnız kabul edilmiş arkadaşlar arasında (SOCIAL-7).
create policy leaderboard_select on public.leaderboard_entries for select to authenticated
  using (user_id = (select auth.uid()) or public.is_friend(user_id, (select auth.uid())));
