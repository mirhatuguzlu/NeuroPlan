-- Plan tabloları (docs/DB_SCHEMA.md §3).
-- Ortak sütunlar: id, user_id, created_at, updated_at, deleted_at, version, field_versions.
-- Yabancı anahtarlar (user_id, <ref>_id) çifti: satır yalnız aynı kullanıcının satırına bağlanır.

-- jsonb doğrulayıcıları: packages/neuroplan_core Recurrence / Timing ile aynı kurallar.
create or replace function public.is_iso_date(t text)
returns boolean
language plpgsql
immutable
set search_path = ''
as $$
begin
  if t is null or t !~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' then
    return false;
  end if;
  return to_char(t::date, 'YYYY-MM-DD') = t;
exception when others then
  return false;
end
$$;

create or replace function public.is_valid_recurrence(r jsonb)
returns boolean
language plpgsql
immutable
set search_path = ''
as $$
declare
  v_len int;
  v_prev int := -1;
  v_day int;
  v_rule text := r ->> 'rrule';
begin
  if jsonb_typeof(r) is distinct from 'object' then
    return false;
  end if;
  case r ->> 'type'
    when 'once' then
      return public.is_iso_date(r ->> 'date');
    when 'rrule' then
      -- Desen: core/lib/src/model/recurrence.dart rrulePattern ile aynı.
      return public.is_iso_date(r ->> 'dtstart')
        and coalesce(v_rule ~ ('^(FREQ=(DAILY|WEEKLY|MONTHLY|YEARLY)|(INTERVAL|COUNT)=[1-9][0-9]{0,3}'
            || '|BYDAY=[+-]?[0-9]{0,2}(MO|TU|WE|TH|FR|SA|SU)(,[+-]?[0-9]{0,2}(MO|TU|WE|TH|FR|SA|SU))*'
            || '|(BYMONTHDAY|BYMONTH|BYSETPOS)=[+-]?[0-9]{1,3}(,[+-]?[0-9]{1,3})*'
            || '|UNTIL=[0-9]{8}(T[0-9]{6}Z?)?|WKST=(MO|TU|WE|TH|FR|SA|SU))'
            || '(;(FREQ=(DAILY|WEEKLY|MONTHLY|YEARLY)|(INTERVAL|COUNT)=[1-9][0-9]{0,3}'
            || '|BYDAY=[+-]?[0-9]{0,2}(MO|TU|WE|TH|FR|SA|SU)(,[+-]?[0-9]{0,2}(MO|TU|WE|TH|FR|SA|SU))*'
            || '|(BYMONTHDAY|BYMONTH|BYSETPOS)=[+-]?[0-9]{1,3}(,[+-]?[0-9]{1,3})*'
            || '|UNTIL=[0-9]{8}(T[0-9]{6}Z?)?|WKST=(MO|TU|WE|TH|FR|SA|SU)))*$'), false)
        and length(v_rule) - length(replace(v_rule, 'FREQ=', '')) = 5;
    when 'cycle' then
      if not public.is_iso_date(r ->> 'anchor')
         or jsonb_typeof(r -> 'on_days') is distinct from 'array'
         or jsonb_array_length(r -> 'on_days') = 0 then
        return false;
      end if;
      v_len := (r ->> 'length_days')::int;
      if v_len is null or v_len < 1 or v_len > 366 then
        return false;
      end if;
      for v_day in select (value #>> '{}')::int from jsonb_array_elements(r -> 'on_days') loop
        if v_day is null or v_day <= v_prev or v_day >= v_len then
          return false;
        end if;
        v_prev := v_day;
      end loop;
      return true;
    when 'dates' then
      return jsonb_typeof(r -> 'dates') = 'array'
        and jsonb_array_length(r -> 'dates') between 1 and 366
        and not exists (
          select 1 from jsonb_array_elements(r -> 'dates') d
          where jsonb_typeof(d) <> 'string' or not public.is_iso_date(d #>> '{}')
        );
    when 'per_period' then
      return coalesce((r ->> 'count') ~ '^[0-9]{1,2}$', false)
        and (r ->> 'count')::int between 1 and 31
        and coalesce(r ->> 'unit' in ('day', 'week', 'month'), false);
    when 'follow' then
      return true;
    else
      return false;
  end case;
exception when others then
  return false;
end
$$;

create or replace function public.is_valid_timing(t jsonb)
returns boolean
language plpgsql
immutable
set search_path = ''
as $$
declare
  v_side text;
  v_c jsonb;
  v_ref jsonb;
  v_at int;
begin
  if jsonb_typeof(t) is distinct from 'object'
     or exists (select 1 from jsonb_object_keys(t) k where k not in ('start', 'end')) then
    return false;
  end if;
  foreach v_side in array array['start', 'end'] loop
    continue when t -> v_side is null;
    if jsonb_typeof(t -> v_side) <> 'array' then
      return false;
    end if;
    v_at := 0;
    for v_c in select value from jsonb_array_elements(t -> v_side) loop
      v_ref := v_c -> 'ref';
      if jsonb_typeof(v_c) <> 'object'
         or (v_c ->> 'op' in ('at', 'not_before', 'not_after')) is not true
         or (v_c ? 'offset_minutes' and ((v_c ->> 'offset_minutes') ~ '^-?[0-9]{1,4}$') is not true)
         or abs(coalesce((v_c ->> 'offset_minutes')::int, 0)) > 1440
         or jsonb_typeof(v_ref) is distinct from 'object' then
        return false;
      end if;
      if v_c ->> 'op' = 'at' then
        v_at := v_at + 1;
      end if;
      if v_ref ? 'clock' or v_ref ? 'astro' then
        if (v_ref ->> 'clock' ~ '^([01][0-9]|2[0-3]):[0-5][0-9]$'
            or v_ref ->> 'astro' in ('sunrise', 'sunset', 'fajr', 'dhuhr', 'asr', 'maghrib', 'isha')) is not true
           or (v_ref ? 'day_offset' and (v_ref ->> 'day_offset' in ('-1', '0', '1')) is not true) then
          return false;
        end if;
      elsif v_ref ? 'activity_id' then
        if (v_ref ->> 'activity_id' ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$') is not true
           or (v_ref ->> 'edge' in ('start', 'end')) is not true then
          return false;
        end if;
      else
        return false;
      end if;
    end loop;
    if v_at > 1 then
      return false;
    end if;
  end loop;
  return true;
exception when others then
  return false;
end
$$;

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  user_id uuid not null unique references auth.users (id) on delete cascade check (user_id = id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  display_name text check (char_length(display_name) <= 60),
  locale text check (locale in ('tr', 'en')),
  theme text check (char_length(theme) <= 40),
  theme_mode text not null default 'system' check (theme_mode in ('system', 'light', 'dark')),
  timezone text not null check (char_length(timezone) between 1 and 64),
  sleep_goal_minutes integer check (sleep_goal_minutes between 60 and 1080),
  birth_year smallint check (birth_year between 1900 and 2100),
  onboarding_completed_at timestamptz,
  location_lat numeric(4, 1) check (location_lat between -90 and 90),
  location_lon numeric(4, 1) check (location_lon between -180 and 180),
  location_label text check (char_length(location_label) <= 100),
  prayer_method text check (char_length(prayer_method) <= 40),
  prayer_madhab text check (prayer_madhab in ('shafi', 'hanafi')),
  min_chunk_minutes integer check (min_chunk_minutes > 0),
  chunk_buffer_minutes integer check (chunk_buffer_minutes >= 0),
  daily_focus_cap_minutes integer check (daily_focus_cap_minutes > 0),
  haptics_enabled boolean not null default true
);

create table public.user_categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  parent_id uuid,
  root_category_key text not null references public.root_categories (key),
  name text not null check (char_length(name) between 1 and 100),
  color text check (color ~ '^#[0-9A-Fa-f]{6}$'),
  icon text check (char_length(icon) <= 64),
  requires_focus boolean,
  default_focus_mode text check (default_focus_mode in ('free', 'pomodoro', 'deep')),
  sort_order integer not null default 0,
  unique (user_id, id),
  foreign key (user_id, parent_id) references public.user_categories (user_id, id),
  check (parent_id is distinct from id)
);

create table public.activities (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  kind text not null check (kind in ('routine', 'one_off', 'task', 'project', 'free_time', 'travel_prep')),
  title text not null check (char_length(title) between 1 and 200),
  notes text check (char_length(notes) <= 5000),
  category_id uuid,
  root_category_key text references public.root_categories (key),
  parent_activity_id uuid,
  variant_id uuid,
  estimated_minutes integer check (estimated_minutes > 0),
  priority smallint check (priority between 1 and 3),
  requires_focus boolean,
  focus_mode text check (focus_mode in ('free', 'pomodoro', 'deep')),
  sort_order integer not null default 0,
  unique (user_id, id),
  foreign key (user_id, category_id) references public.user_categories (user_id, id),
  foreign key (user_id, parent_activity_id) references public.activities (user_id, id),
  check (parent_activity_id is distinct from id)
);

create table public.variant_groups (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  activity_id uuid not null,
  name text check (char_length(name) <= 100),
  applies_on jsonb check (applies_on is null or public.is_valid_recurrence(applies_on)),
  default_variant_id uuid,
  unique (user_id, id),
  foreign key (user_id, activity_id) references public.activities (user_id, id)
);
-- v1: aktivite başına tek varyant grubu (DB_SCHEMA §9).
create unique index variant_groups_one_per_activity on public.variant_groups (activity_id)
  where deleted_at is null;

create table public.variants (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  group_id uuid not null,
  name text not null check (char_length(name) between 1 and 100),
  sort_order integer not null default 0,
  timing jsonb check (timing is null or public.is_valid_timing(timing)),
  duration_min_minutes integer check (duration_min_minutes > 0),
  duration_max_minutes integer check (duration_max_minutes > 0),
  cancels_occurrence boolean not null default false,
  unique (user_id, id),
  foreign key (user_id, group_id) references public.variant_groups (user_id, id),
  check (duration_max_minutes >= duration_min_minutes)
);

alter table public.variant_groups
  add foreign key (user_id, default_variant_id) references public.variants (user_id, id);
alter table public.activities
  add foreign key (user_id, variant_id) references public.variants (user_id, id);

create table public.schedule_rules (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  activity_id uuid not null,
  recurrence jsonb not null check (public.is_valid_recurrence(recurrence)),
  timing jsonb not null default '{}'::jsonb check (public.is_valid_timing(timing)),
  duration_min_minutes integer check (duration_min_minutes > 0),
  duration_max_minutes integer check (duration_max_minutes > 0),
  flexibility text not null default 'fixed' check (flexibility in ('fixed', 'shiftable', 'optional')),
  valid_from date,
  valid_until date,
  exception_dates date[] not null default '{}',
  unique (user_id, id),
  foreign key (user_id, activity_id) references public.activities (user_id, id),
  check (duration_max_minutes >= duration_min_minutes),
  check (valid_until >= valid_from),
  -- follow: zaman kısıtında en az bir aktivite çapası olmalı.
  check (recurrence ->> 'type' <> 'follow' or jsonb_path_exists(timing, '$.*[*].ref.activity_id'))
);

create table public.projects (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  activity_id uuid not null,
  total_minutes integer check (total_minutes > 0),
  deadline_at timestamptz,
  split_mode text not null default 'auto' check (split_mode in ('auto', 'manual')),
  min_chunk_minutes integer check (min_chunk_minutes > 0),
  max_chunk_minutes integer check (max_chunk_minutes > 0),
  daily_cap_minutes integer check (daily_cap_minutes > 0),
  preferred_windows jsonb check (preferred_windows is null or jsonb_typeof(preferred_windows) = 'array'),
  safety_margin_minutes integer check (safety_margin_minutes >= 0),
  unique (user_id, id),
  foreign key (user_id, activity_id) references public.activities (user_id, id),
  check (max_chunk_minutes >= min_chunk_minutes)
);
create unique index projects_one_per_activity on public.projects (activity_id) where deleted_at is null;

create table public.day_overrides (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  date date,
  recurrence jsonb check (recurrence is null or public.is_valid_recurrence(recurrence)),
  valid_from date,
  valid_until date,
  keep text not null default 'all' check (keep in ('all', 'fixed_only', 'none')),
  auto_placement boolean not null default false,
  label text check (char_length(label) <= 100),
  unique (user_id, id),
  check ((date is null) <> (recurrence is null)),
  check (valid_until >= valid_from)
);

create table public.plan_instances (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  version bigint not null default 0,
  field_versions jsonb not null default '{}'::jsonb,
  activity_id uuid not null,
  rule_id uuid,
  occurrence_date date not null,
  start_at timestamptz,
  end_at timestamptz,
  status text not null default 'planned' check (status in ('planned', 'done', 'skipped', 'moved', 'failed')),
  source text not null check (source in ('rule', 'auto', 'manual')),
  variant_id uuid,
  parent_instance_id uuid,
  moved_from_id uuid,
  is_manual boolean not null default false,
  engine_version integer check (engine_version > 0),
  unique (user_id, id),
  foreign key (user_id, activity_id) references public.activities (user_id, id),
  foreign key (user_id, rule_id) references public.schedule_rules (user_id, id),
  foreign key (user_id, variant_id) references public.variants (user_id, id),
  foreign key (user_id, parent_instance_id) references public.plan_instances (user_id, id),
  foreign key (user_id, moved_from_id) references public.plan_instances (user_id, id),
  check (end_at >= start_at)
);
create index plan_instances_user_date on public.plan_instances (user_id, occurrence_date);

-- Kategori ağacı: çocuğun kökü ebeveyninkiyle aynı; döngü yok (DB_SCHEMA §3.2).
create or replace function public.user_categories_guard()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  v_parent_root text;
begin
  if new.parent_id is not null then
    select root_category_key into v_parent_root
    from public.user_categories where id = new.parent_id and user_id = new.user_id;
    if v_parent_root is distinct from new.root_category_key then
      raise exception 'alt kategorinin kökü ebeveyniyle aynı olmalı' using errcode = '23514';
    end if;
    if exists (
      with recursive up(id, parent_id, depth) as (
        select c.id, c.parent_id, 1 from public.user_categories c where c.id = new.parent_id
        union all
        select c.id, c.parent_id, up.depth + 1
        from public.user_categories c join up on c.id = up.parent_id
        where up.depth < 1000
      )
      select 1 from up where up.id = new.id
    ) then
      raise exception 'kategori ağacında döngü' using errcode = '23514';
    end if;
  end if;
  return new;
end
$$;

-- Aktivitenin kökü kategorisinden türetilir (DB_SCHEMA §3.3).
create or replace function public.activities_derive_root()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.category_id is not null then
    select root_category_key into new.root_category_key
    from public.user_categories where id = new.category_id and user_id = new.user_id;
  end if;
  return new;
end
$$;

create trigger bb_guard before insert or update on public.user_categories
  for each row execute function public.user_categories_guard();
create trigger bb_derive_root before insert or update on public.activities
  for each row execute function public.activities_derive_root();

-- Ortak: eşitleme tetikleyicisi, RLS (yalnız sahip; DELETE politikası yok = kalıcı silme yok), imleç indeksi.
do $$
declare t text;
begin
  foreach t in array array[
    'profiles', 'user_categories', 'activities', 'variant_groups', 'variants',
    'schedule_rules', 'projects', 'day_overrides', 'plan_instances'
  ] loop
    execute format('create trigger aa_sync before insert or update on public.%I for each row execute function public.sync_before_write()', t);
    execute format('alter table public.%I enable row level security', t);
    execute format('create policy %I on public.%I for select to authenticated using (user_id = (select auth.uid()))', t || '_select_own', t);
    execute format('create policy %I on public.%I for insert to authenticated with check (user_id = (select auth.uid()))', t || '_insert_own', t);
    execute format('create policy %I on public.%I for update to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()))', t || '_update_own', t);
    execute format('create index %I on public.%I (user_id, version)', t || '_user_version', t);
  end loop;
end
$$;
