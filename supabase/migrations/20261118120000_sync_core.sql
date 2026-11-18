-- Eşitleme çekirdeği (docs/ARCHITECTURE.md §5):
-- kullanıcı başına sürüm sayacı, ortak yazma tetikleyicisi (alan bazlı LWW), sync_push / sync_pull.

-- Outbox ile eşitlenen tablolar; üstten alta (ebeveyn önce) sırayla.
create or replace function public.sync_tables()
returns text[]
language sql
immutable
set search_path = ''
as $$
  select array[
    'profiles', 'user_categories', 'activities', 'variant_groups', 'variants',
    'schedule_rules', 'projects', 'day_overrides', 'plan_instances',
    'focus_sessions', 'focus_interruptions', 'brain_events'
  ]
$$;

-- Yalnız eklenen tablolar: tekrar gönderilen satır sessizce atlanır.
create or replace function public.append_only_tables()
returns text[]
language sql
immutable
set search_path = ''
as $$ select array['focus_interruptions', 'brain_events'] $$;

create table public.sync_counters (
  user_id uuid primary key references auth.users (id) on delete cascade,
  value bigint not null default 0
);
alter table public.sync_counters enable row level security;
create policy sync_counters_select_own on public.sync_counters
  for select to authenticated using (user_id = (select auth.uid()));

-- HLC biçimi `<15 hane ms>-<5 hane sayaç>-<düğüm>` (packages/neuroplan_core Hlc ile aynı).
-- Sunucu zamanından 5 dakikadan ileri damga kırpılır: saati ileri alınmış cihaz sonsuza dek kazanmasın.
create or replace function public.hlc_clamp_all(p jsonb)
returns jsonb
language plpgsql
stable
set search_path = ''
as $$
declare
  v_key text;
  v_hlc text;
  v_out jsonb := '{}'::jsonb;
  v_max bigint := (extract(epoch from now()) * 1000)::bigint + 300000;
begin
  if jsonb_typeof(p) is distinct from 'object' then
    raise exception 'field_versions nesne olmalı' using errcode = '22023';
  end if;
  for v_key, v_hlc in select key, value from jsonb_each_text(p) loop
    if v_hlc !~ '^[0-9]{15}-[0-9]{5}-[0-9a-z]{1,32}$' then
      raise exception 'geçersiz HLC: %', v_hlc using errcode = '22023';
    end if;
    if left(v_hlc, 15)::bigint > v_max then
      v_hlc := lpad(v_max::text, 15, '0') || substr(v_hlc, 16);
    end if;
    v_out := v_out || jsonb_build_object(v_key, v_hlc);
  end loop;
  return v_out;
end
$$;

-- Her kullanıcı tablosunda ilk BEFORE tetikleyicisi (adı "aa_sync": alfabetik olarak önce çalışır).
-- security definer: sync_counters'ı RLS'e takılmadan artırmak için.
create or replace function public.sync_before_write()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_old jsonb;
  v_merged jsonb;
  v_revert jsonb := '{}'::jsonb;
  v_key text;
  v_hlc text;
begin
  if tg_op = 'INSERT' then
    -- user_id istemciden gelmez; RLS "with check" başkası adına yazmayı ayrıca engeller.
    new.user_id := coalesce(new.user_id, auth.uid());
    new.created_at := least(coalesce(new.created_at, now()), now());
    new.field_versions := public.hlc_clamp_all(coalesce(new.field_versions, '{}'::jsonb));
  else
    new.user_id := old.user_id;
    new.created_at := old.created_at;
    -- field_versions değişmediyse sürümsüz (sunucu/RPC) yazmadır: LWW uygulanmaz.
    if new.field_versions is distinct from old.field_versions then
      v_old := to_jsonb(old);
      v_merged := coalesce(old.field_versions, '{}'::jsonb);
      for v_key, v_hlc in
        select key, value from jsonb_each_text(public.hlc_clamp_all(new.field_versions))
      loop
        continue when v_key in ('id', 'user_id', 'created_at', 'updated_at', 'version', 'field_versions');
        if (v_merged ->> v_key) is null
           or v_hlc collate "C" > (v_merged ->> v_key) collate "C" then
          v_merged := v_merged || jsonb_build_object(v_key, v_hlc);
        else
          -- Gelen değişiklik daha eski: o alan eski değerinde kalır.
          v_revert := v_revert || jsonb_build_object(v_key, v_old -> v_key);
        end if;
      end loop;
      new := jsonb_populate_record(new, v_revert);
      new.field_versions := v_merged;
    end if;
  end if;

  -- Sayaç satırının kilidi işlem sonuna kadar tutulur: sürüm sırası = commit sırası.
  insert into public.sync_counters as c (user_id, value) values (new.user_id, 1)
    on conflict (user_id) do update set value = c.value + 1
    returning c.value into new.version;
  new.updated_at := now();
  return new;
end
$$;

-- Değişiklik paketi: [{"table", "id", "hlc", "patch": {sütun: değer}}].
-- Her değişiklik kendi alt işleminde uygulanır; hatalı olan reddedilir, diğerleri işlenir.
-- Dönüş: {"rejected": [{"index", "code", "error"}]}
create or replace function public.sync_push(p_changes jsonb)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  v_change jsonb;
  v_index int := -1;
  v_table text;
  v_id uuid;
  v_hlc text;
  v_patch jsonb;
  v_cols text[];
  v_set_cols text[];
  v_exists boolean;
  v_rejected jsonb := '[]'::jsonb;
begin
  if auth.uid() is null then
    raise exception 'oturum gerekli' using errcode = '42501';
  end if;
  if jsonb_typeof(p_changes) is distinct from 'array' then
    raise exception 'değişiklikler dizi olmalı' using errcode = '22023';
  end if;

  for v_change in select value from jsonb_array_elements(p_changes) loop
    v_index := v_index + 1;
    begin
      v_table := v_change ->> 'table';
      if v_table is null or not (v_table = any (public.sync_tables())) then
        raise exception 'bilinmeyen tablo: %', v_table using errcode = '22023';
      end if;
      v_id := case when v_table = 'profiles' then auth.uid() else (v_change ->> 'id')::uuid end;
      v_hlc := v_change ->> 'hlc';
      v_patch := coalesce(v_change -> 'patch', '{}'::jsonb)
        - array['id', 'user_id', 'version', 'updated_at', 'field_versions'];

      select array_agg(k order by k) into v_cols
      from jsonb_object_keys(v_patch) k
      where exists (
        select 1 from pg_catalog.pg_attribute a
        where a.attrelid = ('public.' || v_table)::regclass
          and a.attname = k and a.attnum > 0 and not a.attisdropped
      );
      if coalesce(cardinality(v_cols), 0) = 0
         or cardinality(v_cols) <> (select count(*) from jsonb_object_keys(v_patch)) then
        raise exception 'boş ya da bilinmeyen sütunlu yama' using errcode = '22023';
      end if;

      v_patch := v_patch || jsonb_build_object(
        'id', v_id,
        'field_versions', (select coalesce(jsonb_object_agg(c, v_hlc), '{}'::jsonb)
                           from unnest(v_cols) c where c <> 'created_at')
      );

      execute format('select exists (select 1 from public.%I where id = $1)', v_table)
        into v_exists using v_id;

      if not v_exists then
        execute format(
          'insert into public.%1$I (%2$s) select %2$s from jsonb_populate_record(null::public.%1$I, $1) %3$s',
          v_table,
          (select string_agg(quote_ident(c), ', ') from unnest(v_cols || array['id', 'field_versions']) c),
          case when v_table = any (public.append_only_tables()) then 'on conflict do nothing' else '' end
        ) using v_patch;
      elsif not (v_table = any (public.append_only_tables())) then
        v_set_cols := array(select c from unnest(v_cols) c where c <> 'created_at') || array['field_versions'];
        execute format(
          'update public.%1$I t set (%2$s) = (select %3$s from jsonb_populate_record(null::public.%1$I, $2) r) where t.id = $1',
          v_table,
          (select string_agg(quote_ident(c), ', ') from unnest(v_set_cols) c),
          (select string_agg('r.' || quote_ident(c), ', ') from unnest(v_set_cols) c)
        ) using v_id, v_patch;
      end if;
    exception when others then
      v_rejected := v_rejected || jsonb_build_object('index', v_index, 'code', sqlstate, 'error', sqlerrm);
    end;
  end loop;

  return jsonb_build_object('rejected', v_rejected);
end
$$;

-- İmleçten sonraki değişiklikler. Önce sayaç (V) okunur, sonra cursor < version <= üst sınır
-- satırlar döner; sayaç kilidi sayesinde bu aralıkta görünmeyen commit kalmaz.
-- Dönüş: {"cursor", "has_more", "changes": {tablo: [satır]}}
create or replace function public.sync_pull(p_cursor bigint, p_limit int default 1000)
returns jsonb
language plpgsql
stable
security invoker
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_max bigint;
  v_upper bigint;
  v_table text;
  v_rows jsonb;
  v_changes jsonb := '{}'::jsonb;
begin
  if v_uid is null then
    raise exception 'oturum gerekli' using errcode = '42501';
  end if;
  select value into v_max from public.sync_counters where user_id = v_uid;
  v_max := coalesce(v_max, 0);
  v_upper := least(v_max, p_cursor + greatest(1, least(p_limit, 5000)));

  foreach v_table in array public.sync_tables() loop
    execute format(
      'select coalesce(jsonb_agg(to_jsonb(x) - %L order by x.version), %L::jsonb)
       from public.%I x where x.user_id = $1 and x.version > $2 and x.version <= $3',
      'user_id', '[]', v_table
    ) into v_rows using v_uid, p_cursor, v_upper;
    if jsonb_array_length(v_rows) > 0 then
      v_changes := v_changes || jsonb_build_object(v_table, v_rows);
    end if;
  end loop;

  return jsonb_build_object('cursor', v_upper, 'has_more', v_upper < v_max, 'changes', v_changes);
end
$$;

revoke execute on function public.sync_push(jsonb) from public, anon;
revoke execute on function public.sync_pull(bigint, int) from public, anon;
grant execute on function public.sync_push(jsonb) to authenticated;
grant execute on function public.sync_pull(bigint, int) to authenticated;
