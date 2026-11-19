-- Aşama 4B: sosyal özellikler (docs/SOCIAL_SAFETY.md, DB_SCHEMA §5).
-- İlke: istemci sosyal tablolara doğrudan yazmaz; her yazma security definer RPC'den geçer ve
-- yaş, misafirlik, arkadaşlık, engel ve hız sınırını burada denetler.
-- Hata kodları (istemci çevirir): NP001 uygun değil · NP404 bulunamadı (engel dahil, bilgi sızmasın)
-- NP409 çakışma · NP412 ön koşul yok · NP429 hız sınırı · 42501 yetki · 22023 geçersiz girdi.

-- ───────────────────────── 1. Yaş ve sosyal profil ─────────────────────────

-- Yalnız doğum yılı tutulur; en düşük olası yaş kullanılır (SOCIAL_SAFETY §5).
create or replace function public.min_age(p_user uuid)
returns int
language sql
stable
security definer
set search_path = ''
as $$
  select extract(year from now())::int - p.birth_year - 1
  from public.profiles p where p.id = p_user and p.deleted_at is null
$$;

-- Yaş sonradan küçültülemez (doğum yılı ancak geriye gider), kural atlatmayı zorlaştırır.
create or replace function public.profiles_age_guard()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if old.birth_year is not null and (new.birth_year is null or new.birth_year > old.birth_year) then
    raise exception 'yaş küçültülemez' using errcode = '22023';
  end if;
  return new;
end
$$;
create trigger bb_age_guard before update of birth_year on public.profiles
  for each row execute function public.profiles_age_guard();

create table public.social_profiles (
  user_id uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  display_name text not null check (char_length(btrim(display_name)) between 1 and 40),
  -- Tam kullanıcı adıyla istek için; bulunabilirlik ayrıca açılır (varsayılan kapalı).
  username text unique check (username ~ '^[a-z0-9_]{3,20}$'),
  discoverable boolean not null default false,
  global_leaderboard boolean not null default false,
  share_brain boolean not null default false,
  suspended_until timestamptz
);
alter table public.social_profiles enable row level security;
create policy social_profiles_select on public.social_profiles for select to authenticated
  using (user_id = (select auth.uid()) or public.is_my_friend(user_id));

-- none: sosyal kapalı (misafir, profil yok, 15 yaş altı, askıda) · minor: 15–17 · adult: 18+.
create or replace function public.social_tier(p_user uuid)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select case
    when u.id is null or coalesce(u.is_anonymous, false) then 'none'
    when s.user_id is null or coalesce(s.suspended_until > now(), false) then 'none'
    when a.age is null or a.age < 15 then 'none'
    when a.age < 18 then 'minor'
    else 'adult'
  end
  from (select p_user as id) x
  left join auth.users u on u.id = x.id
  left join public.social_profiles s on s.user_id = x.id
  cross join lateral (select public.min_age(x.id) as age) a
$$;

create or replace function public.require_social()
returns text
language plpgsql
stable
security definer
set search_path = ''
as $$
declare v text := public.social_tier(auth.uid());
begin
  if v = 'none' then raise exception 'not_eligible' using errcode = 'NP001'; end if;
  return v;
end
$$;

-- Birlikte bölümünün kapısı: istemci hangi ekranı göstereceğini buradan öğrenir.
create or replace function public.social_status()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'anonymous', coalesce(u.is_anonymous, true),
    'age', public.min_age(auth.uid()),
    'tier', public.social_tier(auth.uid()),
    'profile', case when s.user_id is null then null else jsonb_build_object(
      'display_name', s.display_name, 'username', s.username, 'discoverable', s.discoverable,
      'global_leaderboard', s.global_leaderboard, 'share_brain', s.share_brain,
      'suspended_until', s.suspended_until) end)
  from (select auth.uid() as id) x
  left join auth.users u on u.id = x.id
  left join public.social_profiles s on s.user_id = x.id
$$;

create or replace function public.save_social_profile(
  p_display_name text,
  p_username text default null,
  p_discoverable boolean default false,
  p_global_leaderboard boolean default false,
  p_share_brain boolean default false
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_age int := public.min_age(v_me);
begin
  if v_me is null or coalesce((select is_anonymous from auth.users where id = v_me), true) then
    raise exception 'guest' using errcode = 'NP001';
  end if;
  if v_age is null or v_age < 15 then raise exception 'too_young' using errcode = 'NP001'; end if;
  -- 15–17: genel sıralama açılamaz (SOCIAL_SAFETY §5).
  if v_age < 18 then p_global_leaderboard := false; end if;
  begin
    insert into public.social_profiles as s
      (user_id, display_name, username, discoverable, global_leaderboard, share_brain)
    values (v_me, btrim(p_display_name), nullif(lower(btrim(p_username)), ''),
            p_discoverable, p_global_leaderboard, p_share_brain)
    on conflict (user_id) do update set
      display_name = excluded.display_name, username = excluded.username,
      discoverable = excluded.discoverable, global_leaderboard = excluded.global_leaderboard,
      share_brain = excluded.share_brain, updated_at = now();
  exception when unique_violation then
    raise exception 'username_taken' using errcode = 'NP409';
  end;
end
$$;

-- ───────────────────────── 2. Doğrudan yazma kapanır ─────────────────────────
do $$
declare t text;
begin
  foreach t in array array['invites', 'blocks', 'visibility_settings', 'shared_activities', 'cofocus_sessions', 'reports'] loop
    execute format('drop policy if exists %I on public.%I', t || '_insert_own', t);
    execute format('drop policy if exists %I on public.%I', t || '_update_own', t);
  end loop;
end
$$;

-- ───────────────────────── 3. Hız sınırı ─────────────────────────
create table public.social_rate_events (
  user_id uuid not null references auth.users (id) on delete cascade,
  action text not null,
  at timestamptz not null default now()
);
create index social_rate_events_lookup on public.social_rate_events (user_id, action, at);
alter table public.social_rate_events enable row level security;

create or replace function public.rate_limit(p_action text, p_per_minute int, p_per_hour int)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v_me uuid := auth.uid();
begin
  delete from public.social_rate_events where user_id = v_me and at < now() - interval '1 day';
  if (select count(*) from public.social_rate_events
      where user_id = v_me and action = p_action and at > now() - interval '1 minute') >= p_per_minute
     or (select count(*) from public.social_rate_events
         where user_id = v_me and action = p_action and at > now() - interval '1 hour') >= p_per_hour then
    raise exception 'rate_limited' using errcode = 'NP429';
  end if;
  insert into public.social_rate_events (user_id, action) values (v_me, p_action);
end
$$;

-- ───────────────────────── 4. Arkadaşlık ve partner ─────────────────────────

-- Kullanıcı başına en fazla bir partner: birincil anahtar garanti eder (yarış durumunda da).
create table public.partner_slots (
  user_id uuid primary key references auth.users (id) on delete cascade,
  friendship_id uuid not null references public.friendships (id) on delete cascade
);
alter table public.partner_slots enable row level security;

create or replace function public.friendships_partner_slots()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_was boolean := tg_op = 'UPDATE' and old.is_partner and old.status = 'accepted' and old.deleted_at is null;
  v_is boolean := new.is_partner and new.status = 'accepted' and new.deleted_at is null;
begin
  if v_was and not v_is then
    delete from public.partner_slots where friendship_id = new.id;
  elsif v_is and not v_was then
    insert into public.partner_slots (user_id, friendship_id)
    values (new.user_id, new.id), (new.friend_id, new.id);
  end if;
  return new;
end
$$;
create trigger cc_partner_slots after insert or update on public.friendships
  for each row execute function public.friendships_partner_slots();

-- Çiftin satırı (silinmemiş), kilitli.
create or replace function public.pair_friendship(a uuid, b uuid)
returns public.friendships
language sql
volatile
security definer
set search_path = ''
as $$
  select f.* from public.friendships f
  where f.deleted_at is null
    and least(f.user_id, f.friend_id) = least(a, b) and greatest(f.user_id, f.friend_id) = greatest(a, b)
  for update
$$;

create or replace function public.display_name_of(p_user uuid)
returns text
language sql
stable
security definer
set search_path = ''
as $$ select display_name from public.social_profiles where user_id = p_user $$;

create or replace function public.create_invite(p_kind text default 'friend')
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare v public.invites;
begin
  perform public.require_social();
  perform public.rate_limit('invite', 5, 30);
  if (select count(*) from public.invites
      where user_id = auth.uid() and deleted_at is null and revoked_at is null
        and expires_at > now() and use_count < max_uses) >= 5 then
    raise exception 'too_many_invites' using errcode = 'NP429';
  end if;
  insert into public.invites (user_id, kind) values (auth.uid(), p_kind) returning * into v;
  return jsonb_build_object('id', v.id, 'code', v.code, 'kind', v.kind, 'expires_at', v.expires_at);
end
$$;

create or replace function public.revoke_invite(p_id uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.invites set revoked_at = now()
  where id = p_id and user_id = auth.uid() and revoked_at is null
$$;

create or replace function public.redeem_invite(p_code text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_inv public.invites;
  v_f public.friendships;
  v_partner boolean := false;
begin
  perform public.require_social();
  perform public.rate_limit('redeem', 5, 20);
  select * into v_inv from public.invites
  where code = upper(btrim(p_code)) and deleted_at is null for update;
  -- Engel, süre, kullanım ve kendi kodu aynı yanıtı verir: davet eden hakkında bilgi sızmaz.
  if v_inv.id is null or v_inv.revoked_at is not null or v_inv.expires_at < now()
     or v_inv.use_count >= v_inv.max_uses or v_inv.user_id = v_me
     or public.is_blocked(v_me, v_inv.user_id) or public.social_tier(v_inv.user_id) = 'none' then
    raise exception 'invalid_invite' using errcode = 'NP404';
  end if;
  v_f := public.pair_friendship(v_me, v_inv.user_id);
  if v_f.id is null then
    insert into public.friendships (user_id, friend_id, status)
    values (v_inv.user_id, v_me, 'accepted') returning * into v_f;
  elsif v_f.status = 'pending' then
    update public.friendships set status = 'accepted' where id = v_f.id returning * into v_f;
  end if;
  if v_inv.kind = 'partner' then
    begin
      update public.friendships set is_partner = true, partner_requested_by = null where id = v_f.id;
      v_partner := true;
    exception when unique_violation then
      v_partner := false; -- birinin zaten partneri var; arkadaşlık yine kurulur
    end;
  end if;
  update public.invites set use_count = use_count + 1 where id = v_inv.id;
  return jsonb_build_object('friend_id', v_inv.user_id, 'display_name', public.display_name_of(v_inv.user_id),
                            'kind', v_inv.kind, 'partner', v_partner);
end
$$;

create or replace function public.request_friend(p_username text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_to uuid;
  v_f public.friendships;
begin
  perform public.require_social();
  perform public.rate_limit('friend_request', 5, 30);
  select user_id into v_to from public.social_profiles
  where username = lower(btrim(p_username)) and discoverable;
  if v_to is null or v_to = v_me or public.is_blocked(v_me, v_to) or public.social_tier(v_to) = 'none' then
    raise exception 'not_found' using errcode = 'NP404';
  end if;
  v_f := public.pair_friendship(v_me, v_to);
  if v_f.id is null then
    insert into public.friendships (user_id, friend_id, status) values (v_me, v_to, 'pending');
  elsif v_f.status = 'pending' and v_f.friend_id = v_me then
    update public.friendships set status = 'accepted' where id = v_f.id; -- karşılıklı istek
  else
    raise exception 'already' using errcode = 'NP409';
  end if;
end
$$;

create or replace function public.respond_friend_request(p_friendship uuid, p_accept boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform public.require_social();
  update public.friendships
  set status = case when p_accept then 'accepted' else status end,
      deleted_at = case when p_accept then null else now() end
  where id = p_friendship and friend_id = auth.uid() and status = 'pending' and deleted_at is null;
  if not found then raise exception 'not_found' using errcode = 'NP404'; end if;
end
$$;

-- Arkadaşlıktan çıkar ya da gönderilen isteği geri al; partnerlik de biter.
create or replace function public.remove_friend(p_friend uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.friendships set deleted_at = now(), is_partner = false, partner_requested_by = null
  where deleted_at is null and (select auth.uid()) in (user_id, friend_id) and p_friend in (user_id, friend_id)
$$;

create or replace function public.request_partner(p_friend uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_f public.friendships;
begin
  perform public.require_social();
  v_f := public.pair_friendship(v_me, p_friend);
  if v_f.id is null or v_f.status <> 'accepted' or not public.is_friend(v_me, p_friend) then
    raise exception 'not_found' using errcode = 'NP404';
  end if;
  if exists (select 1 from public.partner_slots where user_id in (v_me, p_friend)) then
    raise exception 'partner_taken' using errcode = 'NP409';
  end if;
  if v_f.partner_requested_by = p_friend then
    update public.friendships set is_partner = true, partner_requested_by = null where id = v_f.id;
  else
    update public.friendships set partner_requested_by = v_me where id = v_f.id;
  end if;
end
$$;

create or replace function public.respond_partner(p_friend uuid, p_accept boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v_f public.friendships;
begin
  perform public.require_social();
  v_f := public.pair_friendship(auth.uid(), p_friend);
  if v_f.id is null or v_f.partner_requested_by is distinct from p_friend then
    raise exception 'not_found' using errcode = 'NP404';
  end if;
  if not p_accept then
    update public.friendships set partner_requested_by = null where id = v_f.id;
    return;
  end if;
  begin
    update public.friendships set is_partner = true, partner_requested_by = null where id = v_f.id;
  exception when unique_violation then
    raise exception 'partner_taken' using errcode = 'NP409';
  end;
end
$$;

create or replace function public.end_partner(p_friend uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.friendships set is_partner = false, partner_requested_by = null
  where deleted_at is null and (select auth.uid()) in (user_id, friend_id) and p_friend in (user_id, friend_id)
$$;

-- Engellemek arkadaşlığı ve partnerliği bitirir; engel tek taraflıdır ve arkadaşlıktan bağımsız sürer.
create or replace function public.block_user(p_user uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v_me uuid := auth.uid();
begin
  if v_me is null or coalesce((select is_anonymous from auth.users where id = v_me), true) then
    raise exception 'guest' using errcode = 'NP001';
  end if;
  if p_user = v_me then raise exception 'self' using errcode = '22023'; end if;
  insert into public.blocks (user_id, blocked_user_id)
  select v_me, p_user
  where not exists (select 1 from public.blocks
                    where user_id = v_me and blocked_user_id = p_user and deleted_at is null);
  update public.friendships set deleted_at = now(), is_partner = false, partner_requested_by = null
  where deleted_at is null and v_me in (user_id, friend_id) and p_user in (user_id, friend_id);
  update public.cofocus_participants p set status = 'left', left_at = now()
  where p.user_id = v_me and p.status in ('invited', 'joined')
    and exists (select 1 from public.cofocus_participants o
                where o.cofocus_session_id = p.cofocus_session_id and o.user_id = p_user);
end
$$;

create or replace function public.unblock_user(p_user uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.blocks set deleted_at = now()
  where user_id = (select auth.uid()) and blocked_user_id = p_user and deleted_at is null
$$;

create or replace function public.friend_overview()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  with me as (select auth.uid() as id),
  rows as (
    select f.*, case when f.user_id = me.id then f.friend_id else f.user_id end as other
    from public.friendships f, me
    where f.deleted_at is null and me.id in (f.user_id, f.friend_id)
      and not public.is_blocked(f.user_id, f.friend_id)
  )
  select jsonb_build_object(
    'friends', coalesce((select jsonb_agg(jsonb_build_object(
        'user_id', r.other, 'display_name', s.display_name, 'username', s.username,
        'is_partner', r.is_partner, 'partner_requested_by', r.partner_requested_by,
        'since', r.created_at) order by s.display_name)
      from rows r left join public.social_profiles s on s.user_id = r.other
      where r.status = 'accepted'), '[]'::jsonb),
    'incoming', coalesce((select jsonb_agg(jsonb_build_object(
        'friendship_id', r.id, 'user_id', r.other, 'display_name', s.display_name, 'at', r.created_at))
      from rows r left join public.social_profiles s on s.user_id = r.other, me
      where r.status = 'pending' and r.friend_id = me.id), '[]'::jsonb),
    'outgoing', coalesce((select jsonb_agg(jsonb_build_object(
        'friendship_id', r.id, 'user_id', r.other, 'display_name', s.display_name, 'at', r.created_at))
      from rows r left join public.social_profiles s on s.user_id = r.other, me
      where r.status = 'pending' and r.user_id = me.id), '[]'::jsonb),
    'blocked', coalesce((select jsonb_agg(jsonb_build_object(
        'user_id', b.blocked_user_id, 'display_name', s.display_name))
      from public.blocks b left join public.social_profiles s on s.user_id = b.blocked_user_id, me
      where b.user_id = me.id and b.deleted_at is null), '[]'::jsonb),
    'invites', coalesce((select jsonb_agg(jsonb_build_object(
        'id', i.id, 'code', i.code, 'kind', i.kind, 'expires_at', i.expires_at) order by i.created_at desc)
      from public.invites i, me
      where i.user_id = me.id and i.deleted_at is null and i.revoked_at is null
        and i.expires_at > now() and i.use_count < i.max_uses), '[]'::jsonb)
  )
$$;

-- ───────────────────────── 5. Şikâyet ve moderasyon ─────────────────────────
alter table public.reports add column snapshot text check (char_length(snapshot) <= 2000);

create or replace function public.report_content(
  p_target_type text,
  p_target_id uuid,
  p_reason text,
  p_details text default null,
  p_user uuid default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_user uuid := p_user;
  v_snapshot text;
  v_id uuid;
begin
  if v_me is null or coalesce((select is_anonymous from auth.users where id = v_me), true) then
    raise exception 'guest' using errcode = 'NP001';
  end if;
  perform public.rate_limit('report', 10, 50);
  if p_target_type = 'message' then
    -- Mesajın metni şikâyet anında kopyalanır; silinse de kanıt kalır (SOCIAL_SAFETY §4.6).
    select m.user_id, m.body into v_user, v_snapshot from public.messages m
    where m.id = p_target_id and public.is_member(m.conversation_id);
    if v_user is null then raise exception 'not_found' using errcode = 'NP404'; end if;
  end if;
  insert into public.reports (user_id, reported_user_id, target_type, target_id, reason, details, snapshot)
  values (v_me, v_user, p_target_type, p_target_id, p_reason, nullif(btrim(p_details), ''), v_snapshot)
  returning id into v_id;
  return v_id;
end
$$;

create table public.moderators (
  user_id uuid primary key references auth.users (id) on delete cascade
);
alter table public.moderators enable row level security;

create table public.moderation_actions (
  id uuid primary key default gen_random_uuid(),
  report_id uuid references public.reports (id) on delete set null,
  moderator_id uuid references auth.users (id) on delete set null,
  action text not null check (action in ('dismiss', 'hide_message', 'suspend_7d', 'suspend_30d', 'ban')),
  note text,
  at timestamptz not null default now()
);
alter table public.moderation_actions enable row level security;

-- Studio'da açılır (postgres rolü); istemci rolleri göremez.
create view public.moderation_queue as
select r.id, r.created_at, r.reason, r.target_type, r.target_id, r.status, r.details, r.snapshot,
       r.user_id as reporter_id, ps.display_name as reporter_name,
       r.reported_user_id, rs.display_name as reported_name, rs.suspended_until
from public.reports r
left join public.social_profiles ps on ps.user_id = r.user_id
left join public.social_profiles rs on rs.user_id = r.reported_user_id
where r.status <> 'resolved' and r.deleted_at is null
order by (r.reason = 'child_safety') desc, r.created_at;
revoke all on public.moderation_queue from public, anon, authenticated;

create or replace function public.resolve_report(p_report uuid, p_action text, p_note text default null)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v public.reports;
begin
  if not (session_user in ('postgres', 'supabase_admin') or coalesce(auth.jwt() ->> 'role', '') = 'service_role'
          or exists (select 1 from public.moderators where user_id = auth.uid())) then
    raise exception 'moderators only' using errcode = '42501';
  end if;
  select * into v from public.reports where id = p_report for update;
  if v.id is null then raise exception 'not_found' using errcode = 'NP404'; end if;
  if p_action = 'hide_message' and v.target_type = 'message' then
    update public.messages set body = ' ', deleted_at = now() where id = v.target_id;
  elsif p_action in ('suspend_7d', 'suspend_30d', 'ban') and v.reported_user_id is not null then
    update public.social_profiles
    set suspended_until = now() + case p_action when 'suspend_7d' then interval '7 days'
                                                when 'suspend_30d' then interval '30 days'
                                                else interval '100 years' end
    where user_id = v.reported_user_id;
  end if;
  update public.reports set status = 'resolved' where id = p_report;
  insert into public.moderation_actions (report_id, moderator_id, action, note)
  values (p_report, auth.uid(), p_action, p_note);
end
$$;

-- ───────────────────────── 6. Görünürlük ─────────────────────────
-- Kural yoksa: partner "başlık ve saat", diğer arkadaşlar "meşgul" (D44, onaylandı).
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
    ), case when public.is_partner(p_owner, p_viewer) then 'title_time' else 'busy' end)
  end
$$;

-- Tek kural yazar ya da (p_level null) siler. Kitle, kişi ve kategori seçimi DB_SCHEMA §5'teki gibi.
create or replace function public.set_visibility(
  p_level text,
  p_audience text default null,
  p_viewer uuid default null,
  p_category uuid default null,
  p_root text default null
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v_id uuid;
begin
  perform public.require_social();
  if (p_audience is null) = (p_viewer is null) or (p_category is not null and p_root is not null) then
    raise exception 'audience or viewer' using errcode = '22023';
  end if;
  if p_viewer is not null and not public.is_friend(auth.uid(), p_viewer) then
    raise exception 'not_found' using errcode = 'NP404';
  end if;
  select id into v_id from public.visibility_settings
  where user_id = auth.uid() and deleted_at is null
    and audience is not distinct from p_audience and viewer_id is not distinct from p_viewer
    and category_id is not distinct from p_category and root_category_key is not distinct from p_root;
  if p_level is null then
    update public.visibility_settings set deleted_at = now() where id = v_id;
  elsif v_id is null then
    insert into public.visibility_settings (user_id, audience, viewer_id, category_id, root_category_key, level)
    values (auth.uid(), p_audience, p_viewer, p_category, p_root, p_level);
  else
    update public.visibility_settings set level = p_level where id = v_id;
  end if;
end
$$;

-- ───────────────────────── 7. Yayınlanan takvim ─────────────────────────
-- Plan motoru cihazda çalışır (D22); cihaz önümüzdeki 14 günün bloklarını yayınlar (D44).
-- Başlık, not, kategori burada yok: `activities`'ten görünürlük kuralıyla birleştirilir.
create table public.calendar_blocks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  activity_id uuid,
  start_at timestamptz not null,
  end_at timestamptz not null,
  check (end_at > start_at)
);
create index calendar_blocks_user_time on public.calendar_blocks (user_id, start_at);
alter table public.calendar_blocks enable row level security;
create policy calendar_blocks_select_own on public.calendar_blocks for select to authenticated
  using (user_id = (select auth.uid()));

create table public.calendar_publications (
  user_id uuid primary key references auth.users (id) on delete cascade,
  published_at timestamptz not null default now(),
  window_start timestamptz not null,
  window_end timestamptz not null
);
alter table public.calendar_publications enable row level security;

create or replace function public.publish_calendar(p_window_start timestamptz, p_window_end timestamptz, p_blocks jsonb)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v_me uuid := auth.uid();
begin
  perform public.require_social();
  if p_window_end <= p_window_start or p_window_end - p_window_start > interval '15 days'
     or p_window_start < now() - interval '2 days' or jsonb_array_length(p_blocks) > 1500 then
    raise exception 'bad window' using errcode = '22023';
  end if;
  delete from public.calendar_blocks where user_id = v_me;
  insert into public.calendar_blocks (user_id, activity_id, start_at, end_at)
  select v_me, x.activity_id, greatest(x.start_at, p_window_start), least(x.end_at, p_window_end)
  from jsonb_to_recordset(p_blocks) as x(activity_id uuid, start_at timestamptz, end_at timestamptz)
  where x.end_at > x.start_at and x.start_at < p_window_end and x.end_at > p_window_start;
  insert into public.calendar_publications as c (user_id, window_start, window_end)
  values (v_me, p_window_start, p_window_end)
  on conflict (user_id) do update set published_at = now(), window_start = excluded.window_start,
                                       window_end = excluded.window_end;
end
$$;

drop function public.friend_calendar(uuid, timestamptz, timestamptz);
create function public.friend_calendar(p_friend uuid, p_from timestamptz, p_to timestamptz)
returns table (
  block_id uuid,
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
  if auth.uid() is null or public.social_tier(auth.uid()) = 'none' or not public.is_friend(auth.uid(), p_friend) then
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
    select b.id, b.start_at, b.end_at, a.title, a.root_category_key, a.notes,
           public.visibility_level(p_friend, auth.uid(), a.category_id, a.root_category_key) as lvl
    from public.calendar_blocks b
    left join public.activities a on a.id = b.activity_id and a.user_id = b.user_id and a.deleted_at is null
    where b.user_id = p_friend and b.start_at < p_to and b.end_at > p_from
  ) x
  where x.lvl <> 'hidden'
  order by x.start_at, x.id;
end
$$;

-- Herkesin boş olduğu aralıklar; kimin neyle meşgul olduğu dönmez. Gizli işler de "dolu" sayılır.
create or replace function public.common_free_time(
  p_users uuid[],
  p_from timestamptz,
  p_to timestamptz,
  p_min_minutes int default 30
)
returns table (start_at timestamptz, end_at timestamptz)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_all uuid[];
  v_end timestamptz;
begin
  perform public.require_social();
  v_all := array(select distinct u from unnest(p_users || v_me) u where u is not null);
  if cardinality(v_all) < 2 or cardinality(v_all) > 8 or p_min_minutes < 5 then
    raise exception 'bad request' using errcode = '22023';
  end if;
  if exists (select 1 from unnest(v_all) u where u <> v_me and not public.is_friend(v_me, u)) then
    raise exception 'yalnız arkadaşlarla' using errcode = '42501';
  end if;
  select min(c.window_end) into v_end from public.calendar_publications c
  where c.user_id = any(v_all) having count(*) = cardinality(v_all);
  if v_end is null then raise exception 'not_published' using errcode = 'NP412'; end if;
  p_from := greatest(p_from, now());
  p_to := least(p_to, v_end, p_from + interval '15 days');
  if p_to <= p_from then return; end if;
  return query
  select lower(f), upper(f)
  from unnest(
    tstzmultirange(tstzrange(p_from, p_to))
    - coalesce((select range_agg(tstzrange(b.start_at, b.end_at)) from public.calendar_blocks b
                where b.user_id = any(v_all) and b.start_at < p_to and b.end_at > p_from),
               '{}'::tstzmultirange)
  ) f
  where upper(f) - lower(f) >= make_interval(mins => p_min_minutes)
  order by 1;
end
$$;

-- ───────────────────────── 8. Mesajlaşma ─────────────────────────
create table public.profanity_terms (
  term text primary key check (term = lower(term)),
  mode text not null check (mode in ('word', 'prefix'))
);
alter table public.profanity_terms enable row level security;
-- Kısa kökler yalnız tam kelimede eşleşir ("sıkıldım" gibi masum kelimeler yakalanmasın).
insert into public.profanity_terms (term, mode) values
  ('amk', 'word'), ('aq', 'word'), ('oc', 'word'), ('sikim', 'word'), ('pust', 'word'), ('ibne', 'word'),
  ('siktir', 'prefix'), ('siker', 'prefix'), ('sikey', 'prefix'), ('sikik', 'prefix'), ('yarra', 'prefix'),
  ('orosp', 'prefix'), ('gavat', 'prefix'), ('pezeven', 'prefix'), ('kahpe', 'prefix'), ('amina', 'prefix'),
  ('yavsak', 'prefix'), ('serefsiz', 'prefix'), ('dalyarak', 'prefix'), ('ananiz', 'prefix'),
  ('fuck', 'prefix'), ('motherf', 'prefix'), ('shit', 'prefix'), ('bitch', 'prefix'), ('cunt', 'prefix'),
  ('asshole', 'prefix'), ('bastard', 'prefix'), ('whore', 'prefix'), ('slut', 'prefix'), ('dick', 'word'),
  ('fagg', 'prefix'), ('nigg', 'prefix'), ('retard', 'prefix');

-- Eşleşen kelime yıldızla örtülür, mesaj yine gider (D47). Türkçe harfler tek karaktere eşlenir;
-- uzunluk değişmediği için konumlar özgün metinde de geçerlidir.
create or replace function public.mask_profanity(p_text text)
returns text
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_norm text := lower(translate(p_text, 'İIıŞşĞğÇçÖöÜü', 'iiissggccoouu'));
  v_pat text;
  v_out text := p_text;
  v_start int := 1;
  v_pos int;
  v_end int;
begin
  select '(?:^|(?<=[^[:alpha:]]))(?:' || string_agg(
           case mode when 'prefix' then term || '[[:alpha:]]*' else term end, '|') || ')(?![[:alpha:]])'
  into v_pat from public.profanity_terms;
  if v_pat is null then return p_text; end if;
  loop
    v_pos := regexp_instr(v_norm, v_pat, v_start, 1, 0);
    exit when v_pos = 0;
    v_end := regexp_instr(v_norm, v_pat, v_start, 1, 1);
    exit when v_end <= v_pos;
    v_out := overlay(v_out placing repeat('*', v_end - v_pos) from v_pos for v_end - v_pos);
    v_start := v_end;
  end loop;
  return v_out;
end
$$;

-- Sohbet açık mı: üyeyim ve karşı tarafla aramda engel yok (engellenen eski mesajları da göremez).
create or replace function public.conversation_open(p_conversation uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select public.is_member(p_conversation) and not exists (
    select 1 from public.conversation_members m
    where m.conversation_id = p_conversation and m.user_id <> auth.uid()
      and public.is_blocked(auth.uid(), m.user_id))
$$;

drop policy messages_select_member on public.messages;
create policy messages_select_member on public.messages for select to authenticated
  using (public.conversation_open(conversation_id));
drop policy reactions_select_member on public.reactions;
create policy reactions_select_member on public.reactions for select to authenticated
  using (exists (select 1 from public.messages m where m.id = message_id and public.conversation_open(m.conversation_id)));

create or replace function public.open_direct(p_friend uuid)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_key text := least(v_me::text, p_friend::text) || ':' || greatest(v_me::text, p_friend::text);
  v_id uuid;
begin
  perform public.require_social();
  if not public.is_friend(v_me, p_friend) then raise exception 'not_found' using errcode = 'NP404'; end if;
  insert into public.conversations (user_id, kind, direct_key) values (v_me, 'direct', v_key)
  on conflict (direct_key) do nothing;
  select id into v_id from public.conversations where direct_key = v_key;
  insert into public.conversation_members (user_id, conversation_id) values (v_me, v_id), (p_friend, v_id)
  on conflict (conversation_id, user_id) do update set deleted_at = null;
  return v_id;
end
$$;

create or replace function public.other_member(p_conversation uuid)
returns uuid
language sql
stable
security definer
set search_path = ''
as $$
  select m.user_id from public.conversation_members m
  where m.conversation_id = p_conversation and m.user_id <> auth.uid() and m.deleted_at is null
  limit 1
$$;

create or replace function public.send_message(p_conversation uuid, p_body text, p_reply_to uuid default null)
returns public.messages
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_body text := btrim(p_body);
  v_other uuid := public.other_member(p_conversation);
  v public.messages;
begin
  perform public.require_social();
  if not public.is_member(p_conversation) or v_other is null or not public.is_friend(auth.uid(), v_other) then
    raise exception 'arkadaş olmayana mesaj gönderilemez' using errcode = '42501';
  end if;
  if char_length(v_body) not between 1 and 2000 then raise exception 'body' using errcode = '22023'; end if;
  if p_reply_to is not null and not exists (
    select 1 from public.messages where id = p_reply_to and conversation_id = p_conversation) then
    raise exception 'reply' using errcode = '22023';
  end if;
  perform public.rate_limit('message', 20, 300);
  insert into public.messages (user_id, conversation_id, body, reply_to_id)
  values (auth.uid(), p_conversation, public.mask_profanity(v_body), p_reply_to)
  returning * into v;
  update public.conversation_members set last_read_at = now()
  where conversation_id = p_conversation and user_id = auth.uid();
  return v;
end
$$;

create or replace function public.delete_message(p_message uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.messages set body = ' ', deleted_at = now()
  where id = p_message and user_id = (select auth.uid()) and deleted_at is null
$$;

create or replace function public.toggle_reaction(p_message uuid, p_emoji text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v_conv uuid;
begin
  perform public.require_social();
  select conversation_id into v_conv from public.messages where id = p_message and deleted_at is null;
  if v_conv is null or not public.conversation_open(v_conv)
     or not public.is_friend(auth.uid(), public.other_member(v_conv)) then
    raise exception 'not_found' using errcode = 'NP404';
  end if;
  perform public.rate_limit('reaction', 30, 600);
  delete from public.reactions where message_id = p_message and user_id = auth.uid() and emoji = p_emoji;
  if not found then
    insert into public.reactions (user_id, message_id, emoji) values (auth.uid(), p_message, p_emoji);
  end if;
end
$$;

create or replace function public.mark_read(p_conversation uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.conversation_members set last_read_at = now()
  where conversation_id = p_conversation and user_id = (select auth.uid())
$$;

create or replace function public.set_conversation_muted(p_conversation uuid, p_muted boolean)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.conversation_members set muted = p_muted
  where conversation_id = p_conversation and user_id = (select auth.uid())
$$;

create or replace function public.conversations_overview()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(jsonb_agg(x order by x ->> 'last_at' desc nulls last), '[]'::jsonb) from (
    select jsonb_build_object(
      'id', m.conversation_id, 'friend_id', o.user_id, 'display_name', s.display_name, 'muted', m.muted,
      'last_body', l.body, 'last_deleted', l.deleted_at is not null, 'last_mine', l.user_id = auth.uid(),
      'last_at', l.created_at,
      'unread', (select count(*) from public.messages u
                 where u.conversation_id = m.conversation_id and u.user_id <> auth.uid() and u.deleted_at is null
                   and u.created_at > coalesce(m.last_read_at, '-infinity'))) as x
    from public.conversation_members m
    join public.conversation_members o on o.conversation_id = m.conversation_id and o.user_id <> m.user_id
    left join public.social_profiles s on s.user_id = o.user_id
    left join lateral (select * from public.messages mm where mm.conversation_id = m.conversation_id
                       order by mm.created_at desc limit 1) l on true
    where m.user_id = auth.uid() and m.deleted_at is null and public.is_friend(auth.uid(), o.user_id)
  ) q
$$;

-- ───────────────────────── 9. Ortak etkinlik ve proje ─────────────────────────
alter table public.shared_activities
  add column kind text not null default 'activity' check (kind in ('activity', 'project')),
  add column total_minutes int check (total_minutes > 0);
alter table public.shared_activity_participants
  add column progress_minutes int not null default 0 check (progress_minutes >= 0);

-- Değişiklikler karşı tarafa onaya gider; herkes onaylayınca uygulanır.
create table public.shared_activity_changes (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  shared_activity_id uuid not null references public.shared_activities (id) on delete cascade,
  proposed_by uuid not null references auth.users (id) on delete cascade,
  patch jsonb not null check (jsonb_typeof(patch) = 'object'),
  approvals uuid[] not null default '{}',
  status text not null default 'pending' check (status in ('pending', 'applied', 'rejected'))
);
alter table public.shared_activity_changes enable row level security;
create policy shared_activity_changes_select on public.shared_activity_changes for select to authenticated
  using (public.is_shared_activity_party(shared_activity_id));

create or replace function public.propose_shared_activity(
  p_title text,
  p_participants uuid[],
  p_start_at timestamptz default null,
  p_end_at timestamptz default null,
  p_notes text default null,
  p_root text default null,
  p_kind text default 'activity',
  p_total_minutes int default null
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_id uuid;
  v_users uuid[] := array(select distinct u from unnest(p_participants) u where u is not null and u <> v_me);
begin
  perform public.require_social();
  perform public.rate_limit('shared', 10, 50);
  if cardinality(v_users) not between 1 and 7 then raise exception 'participants' using errcode = '22023'; end if;
  if exists (select 1 from unnest(v_users) u where not public.is_friend(v_me, u)) then
    raise exception 'yalnız arkadaşlarla' using errcode = '42501';
  end if;
  insert into public.shared_activities (user_id, title, notes, start_at, end_at, root_category_key, kind, total_minutes)
  values (v_me, btrim(p_title), nullif(btrim(p_notes), ''), p_start_at, p_end_at, p_root, p_kind, p_total_minutes)
  returning id into v_id;
  insert into public.shared_activity_participants (user_id, shared_activity_id, status)
  select v_me, v_id, 'accepted'
  union all select u, v_id, 'invited' from unnest(v_users) u;
  return v_id;
end
$$;

create or replace function public.settle_shared_activity(p_id uuid)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.shared_activities s set status = case
      when exists (select 1 from public.shared_activity_participants p
                   where p.shared_activity_id = s.id and p.user_id <> s.user_id and p.status = 'accepted') then 'confirmed'
      when not exists (select 1 from public.shared_activity_participants p
                       where p.shared_activity_id = s.id and p.user_id <> s.user_id and p.status = 'invited') then 'cancelled'
      else s.status end
  where s.id = p_id and s.status <> 'cancelled'
$$;

create or replace function public.respond_shared_activity(p_id uuid, p_accept boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform public.require_social();
  update public.shared_activity_participants set status = case when p_accept then 'accepted' else 'declined' end
  where shared_activity_id = p_id and user_id = auth.uid() and status = 'invited';
  if not found then raise exception 'not_found' using errcode = 'NP404'; end if;
  perform public.settle_shared_activity(p_id);
end
$$;

-- Düzenleyen iptal eder; katılımcı ayrılır.
create or replace function public.leave_shared_activity(p_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if exists (select 1 from public.shared_activities where id = p_id and user_id = auth.uid()) then
    update public.shared_activities set status = 'cancelled' where id = p_id;
  else
    update public.shared_activity_participants set status = 'declined'
    where shared_activity_id = p_id and user_id = auth.uid();
    perform public.settle_shared_activity(p_id);
  end if;
end
$$;

create or replace function public.shared_parties(p_id uuid)
returns uuid[]
language sql
stable
security definer
set search_path = ''
as $$
  select array(select p.user_id from public.shared_activity_participants p
               where p.shared_activity_id = p_id and p.status = 'accepted' order by 1)
$$;

create or replace function public.apply_shared_change(p_change uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare c public.shared_activity_changes;
begin
  select * into c from public.shared_activity_changes where id = p_change;
  update public.shared_activities set
    title = coalesce(btrim(c.patch ->> 'title'), title),
    notes = case when c.patch ? 'notes' then nullif(btrim(c.patch ->> 'notes'), '') else notes end,
    start_at = case when c.patch ? 'start_at' then (c.patch ->> 'start_at')::timestamptz else start_at end,
    end_at = case when c.patch ? 'end_at' then (c.patch ->> 'end_at')::timestamptz else end_at end,
    total_minutes = case when c.patch ? 'total_minutes' then (c.patch ->> 'total_minutes')::int else total_minutes end
  where id = c.shared_activity_id;
  update public.shared_activity_changes set status = 'applied' where id = p_change;
end
$$;

create or replace function public.propose_shared_change(p_id uuid, p_patch jsonb)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare v_id uuid;
begin
  perform public.require_social();
  if not (auth.uid() = any(public.shared_parties(p_id)))
     or (select status from public.shared_activities where id = p_id) = 'cancelled' then
    raise exception 'not_found' using errcode = 'NP404';
  end if;
  if exists (select 1 from jsonb_object_keys(p_patch) k
             where k not in ('title', 'notes', 'start_at', 'end_at', 'total_minutes')) then
    raise exception 'patch' using errcode = '22023';
  end if;
  perform public.rate_limit('shared', 10, 50);
  insert into public.shared_activity_changes (shared_activity_id, proposed_by, patch, approvals)
  values (p_id, auth.uid(), p_patch, array[auth.uid()]) returning id into v_id;
  if cardinality(public.shared_parties(p_id)) <= 1 then perform public.apply_shared_change(v_id); end if;
  return v_id;
end
$$;

create or replace function public.respond_shared_change(p_change uuid, p_accept boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare c public.shared_activity_changes;
begin
  perform public.require_social();
  select * into c from public.shared_activity_changes where id = p_change and status = 'pending' for update;
  if c.id is null or not (auth.uid() = any(public.shared_parties(c.shared_activity_id)))
     or auth.uid() = any(c.approvals) then
    raise exception 'not_found' using errcode = 'NP404';
  end if;
  if not p_accept then
    update public.shared_activity_changes set status = 'rejected' where id = p_change;
    return;
  end if;
  update public.shared_activity_changes set approvals = approvals || auth.uid() where id = p_change
  returning * into c;
  if public.shared_parties(c.shared_activity_id) <@ c.approvals then
    perform public.apply_shared_change(p_change);
  end if;
end
$$;

-- İlerleme: her katılımcı kendi odak dakikasını bildirir; herkes toplamı görür.
create or replace function public.report_shared_progress(p_id uuid, p_minutes int)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.shared_activity_participants set progress_minutes = greatest(0, least(p_minutes, 100000))
  where shared_activity_id = p_id and user_id = (select auth.uid()) and status = 'accepted'
$$;

create or replace function public.shared_overview()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce(jsonb_agg(jsonb_build_object(
    'id', s.id, 'organizer_id', s.user_id, 'title', s.title, 'notes', s.notes,
    'start_at', s.start_at, 'end_at', s.end_at, 'root_category_key', s.root_category_key,
    'kind', s.kind, 'total_minutes', s.total_minutes, 'status', s.status, 'updated_at', s.updated_at,
    'participants', (select jsonb_agg(jsonb_build_object(
        'user_id', p.user_id, 'display_name', sp.display_name, 'status', p.status,
        'progress_minutes', p.progress_minutes) order by p.created_at)
      from public.shared_activity_participants p
      left join public.social_profiles sp on sp.user_id = p.user_id
      where p.shared_activity_id = s.id),
    'changes', coalesce((select jsonb_agg(jsonb_build_object(
        'id', c.id, 'proposed_by', c.proposed_by, 'patch', c.patch,
        'approved', auth.uid() = any(c.approvals)) order by c.created_at)
      from public.shared_activity_changes c where c.shared_activity_id = s.id and c.status = 'pending'),
      '[]'::jsonb)
  ) order by coalesce(s.start_at, s.created_at)), '[]'::jsonb)
  from public.shared_activities s
  where public.is_shared_activity_party(s.id) and s.deleted_at is null
    and (s.status <> 'cancelled' or s.updated_at > now() - interval '7 days')
    and not exists (select 1 from public.shared_activity_participants p
                    where p.shared_activity_id = s.id and p.user_id <> auth.uid()
                      and public.is_blocked(auth.uid(), p.user_id))
$$;

-- ───────────────────────── 10. Ortak odak ─────────────────────────
alter table public.cofocus_participants
  add column status text not null default 'invited' check (status in ('invited', 'joined', 'left', 'declined')),
  add column outcome text check (outcome in ('completed', 'broken', 'left')),
  add column mode text check (mode in ('free', 'pomodoro', 'deep'));
-- Katılımcının oturumu sunucuya henüz eşitlenmemiş olabilir; bağ yabancı anahtarsız tutulur.
alter table public.cofocus_participants drop constraint if exists cofocus_participants_user_id_focus_session_id_fkey;

create or replace function public.server_now()
returns timestamptz
language sql
stable
as $$ select now() $$;

create or replace function public.create_cofocus(p_invitees uuid[], p_voice boolean default false)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_id uuid := gen_random_uuid();
  v_users uuid[] := array(select distinct u from unnest(p_invitees) u where u is not null and u <> v_me);
begin
  perform public.require_social();
  perform public.rate_limit('cofocus', 5, 30);
  -- En çok 4 kişi (SOCIAL_SAFETY §4.3).
  if cardinality(v_users) not between 1 and 3 then raise exception 'invitees' using errcode = '22023'; end if;
  if exists (select 1 from unnest(v_users) u where not public.is_friend(v_me, u)) then
    raise exception 'yalnız arkadaşlarla' using errcode = '42501';
  end if;
  insert into public.cofocus_sessions (id, user_id, mode, voice_enabled, room_id, status)
  values (v_id, v_me, 'free', p_voice, case when p_voice then 'cofocus_' || v_id end, 'scheduled');
  insert into public.cofocus_participants (user_id, cofocus_session_id, status, joined_at)
  select v_me, v_id, 'joined', now()
  union all select u, v_id, 'invited', null from unnest(v_users) u;
  return v_id;
end
$$;

create or replace function public.respond_cofocus(p_id uuid, p_join boolean)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  perform public.require_social();
  update public.cofocus_participants
  set status = case when p_join then 'joined' else 'declined' end,
      joined_at = case when p_join then now() end
  where cofocus_session_id = p_id and user_id = auth.uid() and status = 'invited'
    and (select status from public.cofocus_sessions where id = p_id) <> 'ended';
  if not found then raise exception 'not_found' using errcode = 'NP404'; end if;
end
$$;

-- Başlatan başlatır; sayaçlar bu sunucu anından itibaren işler.
create or replace function public.start_cofocus(p_id uuid)
returns timestamptz
language plpgsql
security definer
set search_path = ''
as $$
declare v timestamptz;
begin
  update public.cofocus_sessions set status = 'live', started_at = now()
  where id = p_id and user_id = auth.uid() and status = 'scheduled'
  returning started_at into v;
  if v is null then raise exception 'not_found' using errcode = 'NP404'; end if;
  -- Yanıt vermeyen davetliler katılmamış sayılır.
  update public.cofocus_participants set status = 'declined'
  where cofocus_session_id = p_id and status = 'invited';
  return v;
end
$$;

create or replace function public.set_cofocus_focus(p_id uuid, p_focus_session uuid, p_mode text)
returns void
language sql
security definer
set search_path = ''
as $$
  update public.cofocus_participants set focus_session_id = p_focus_session, mode = p_mode
  where cofocus_session_id = p_id and user_id = (select auth.uid()) and status = 'joined'
$$;

create or replace function public.finish_cofocus(p_id uuid, p_outcome text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.cofocus_participants set status = 'left', left_at = now(), outcome = p_outcome
  where cofocus_session_id = p_id and user_id = auth.uid() and status in ('joined', 'invited');
  update public.cofocus_sessions s set status = 'ended', ended_at = greatest(now(), s.started_at)
  where s.id = p_id and s.status <> 'ended'
    and not exists (select 1 from public.cofocus_participants p
                    where p.cofocus_session_id = p_id and p.status = 'joined');
end
$$;

create or replace function public.cofocus_state(p_id uuid)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'id', s.id, 'host_id', s.user_id, 'status', s.status, 'started_at', s.started_at, 'ended_at', s.ended_at,
    'voice', s.voice_enabled, 'server_now', now(),
    'participants', (select jsonb_agg(jsonb_build_object(
        'user_id', p.user_id, 'display_name', sp.display_name, 'status', p.status,
        'outcome', p.outcome, 'mode', p.mode) order by p.created_at)
      from public.cofocus_participants p left join public.social_profiles sp on sp.user_id = p.user_id
      where p.cofocus_session_id = s.id))
  from public.cofocus_sessions s
  where s.id = p_id and public.is_cofocus_party(s.id)
$$;

-- Ses token'ı (voice_token Edge Function, kullanıcının JWT'siyle çağırır).
create or replace function public.voice_room(p_id uuid)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select s.room_id from public.cofocus_sessions s
  join public.cofocus_participants p on p.cofocus_session_id = s.id
  where s.id = p_id and s.voice_enabled and s.status in ('scheduled', 'live')
    and p.user_id = auth.uid() and p.status = 'joined'
    and public.social_tier(auth.uid()) <> 'none'
$$;

-- Realtime özel kanalı "cofocus:<id>": yalnız katılmış katılımcılar dinler ve gönderir.
create or replace function public.cofocus_topic_ok(p_topic text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select p_topic ~ '^cofocus:[0-9a-f-]{36}$' and exists (
    select 1 from public.cofocus_participants p
    where p.cofocus_session_id = substr(p_topic, 9)::uuid and p.user_id = auth.uid()
      and p.status in ('joined', 'left'))
$$;

do $$
begin
  if to_regclass('realtime.messages') is not null then
    execute $p$create policy cofocus_channel_read on realtime.messages for select to authenticated
      using (extension in ('broadcast', 'presence') and public.cofocus_topic_ok((select realtime.topic())))$p$;
    execute $p$create policy cofocus_channel_write on realtime.messages for insert to authenticated
      with check (extension in ('broadcast', 'presence') and public.cofocus_topic_ok((select realtime.topic())))$p$;
  end if;
end
$$;

-- Birlikte sekmesinin rozeti ve bekleyen işler.
create or replace function public.together_badges()
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'friend_requests', (select count(*) from public.friendships f
      where f.friend_id = auth.uid() and f.status = 'pending' and f.deleted_at is null
        and not public.is_blocked(f.user_id, f.friend_id)),
    'partner_request', (select f.partner_requested_by from public.friendships f
      where f.deleted_at is null and auth.uid() in (f.user_id, f.friend_id)
        and f.partner_requested_by is not null and f.partner_requested_by <> auth.uid() limit 1),
    'cofocus_invites', (select coalesce(jsonb_agg(jsonb_build_object(
        'id', s.id, 'host_id', s.user_id, 'host_name', public.display_name_of(s.user_id), 'voice', s.voice_enabled)), '[]'::jsonb)
      from public.cofocus_participants p join public.cofocus_sessions s on s.id = p.cofocus_session_id
      where p.user_id = auth.uid() and p.status = 'invited' and s.status <> 'ended'
        and s.created_at > now() - interval '12 hours' and public.is_friend(auth.uid(), s.user_id)),
    'shared_invites', (select count(*) from public.shared_activity_participants p
      join public.shared_activities s on s.id = p.shared_activity_id
      where p.user_id = auth.uid() and p.status = 'invited' and s.status <> 'cancelled'),
    'shared_changes', (select count(*) from public.shared_activity_changes c
      where c.status = 'pending' and auth.uid() = any(public.shared_parties(c.shared_activity_id))
        and not (auth.uid() = any(c.approvals))),
    'unread', (select coalesce(sum((x ->> 'unread')::int), 0)
               from jsonb_array_elements(public.conversations_overview()) x
               where not (x ->> 'muted')::boolean))
$$;

-- ───────────────────────── 11. Sıralama ─────────────────────────
-- Sunucunun gördüğü an: hile denetiminde "geriye dönük yığma" için (istemci yazamaz).
alter table public.focus_sessions add column server_received_at timestamptz not null default now();
create or replace function public.focus_sessions_received()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.server_received_at := case when tg_op = 'INSERT' then now() else old.server_received_at end;
  return new;
end
$$;
create trigger ab_received before insert or update on public.focus_sessions
  for each row execute function public.focus_sessions_received();

-- Sıralamaya giren oturumlar (SOCIAL_SAFETY §4.7): tamamlanmış, sayaçlı, gerçek süreden uzun değil,
-- gelecekte bitmeyen, sunucuya 7 günden geç gelmemiş ve aynı kişinin başka bir oturumuyla çakışmayan.
create or replace function public.valid_focus(p_user uuid, p_from timestamptz, p_to timestamptz)
returns table (day date, minutes int)
language sql
stable
security definer
set search_path = ''
as $$
  with s as (
    select f.id, f.started_at, f.ended_at, f.focused_seconds,
           (f.started_at at time zone coalesce(p.timezone, 'UTC'))::date as d
    from public.focus_sessions f
    left join public.profiles p on p.id = f.user_id
    where f.user_id = p_user and f.deleted_at is null and f.outcome = 'completed'
      and f.ended_at is not null and f.started_at >= p_from and f.started_at < p_to
      and f.ended_at <= now() + interval '5 minutes'
      and f.focused_seconds <= extract(epoch from f.ended_at - f.started_at) + 60
      and f.server_received_at <= f.ended_at + interval '7 days'
      and not exists (select 1 from public.focus_sessions o
                      where o.user_id = f.user_id and o.id <> f.id and o.deleted_at is null
                        and o.outcome = 'completed' and o.ended_at is not null
                        and o.started_at < f.ended_at and o.ended_at > f.started_at)
  )
  select d, (sum(focused_seconds) / 60)::int from s group by d
  having sum(focused_seconds) <= 16 * 3600   -- günde 16 saatten fazla odak inandırıcı değil
$$;

create or replace function public.week_start_for(p_user uuid)
returns timestamptz
language sql
stable
security definer
set search_path = ''
as $$
  select (date_trunc('week', now() at time zone tz) at time zone tz)
  from (select coalesce((select timezone from public.profiles where id = p_user), 'UTC') as tz) z
$$;

-- Arkadaş tablosu canlı hesaplanır; hafta pazartesi sıfırlanır (çağıranın saat diliminde).
-- 15–17 yaşta süreklilik dönmez (DSA kılavuzu: küçüklerde seri özellikleri).
create or replace function public.friends_leaderboard()
returns table (user_id uuid, display_name text, is_me boolean, focus_minutes int, active_days int)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_me uuid := auth.uid();
  v_tier text := public.require_social();
  v_from timestamptz := public.week_start_for(v_me);
begin
  return query
  select u.id, s.display_name, u.id = v_me,
         coalesce((select sum(v.minutes) from public.valid_focus(u.id, v_from, v_from + interval '7 days') v), 0)::int,
         case when v_tier = 'adult' then
           (select count(*) from public.valid_focus(u.id, v_from, v_from + interval '7 days') v where v.minutes > 0)::int
         end
  from (select v_me as id
        union select case when f.user_id = v_me then f.friend_id else f.user_id end
        from public.friendships f
        where f.deleted_at is null and f.status = 'accepted' and v_me in (f.user_id, f.friend_id)
          and not public.is_blocked(f.user_id, f.friend_id)) u
  left join public.social_profiles s on s.user_id = u.id
  where public.social_tier(u.id) <> 'none'
  order by 4 desc, 2;
end
$$;

alter table public.leaderboard_entries add column active_days int not null default 0;

-- Genel tablo: yalnız katılmayı seçen yetişkinler, UTC haftası; zamanlanmış görev tazeler.
create or replace function public.refresh_global_leaderboard()
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare v_from timestamptz := date_trunc('week', now() at time zone 'UTC') at time zone 'UTC';
begin
  delete from public.leaderboard_entries e
  where e.period = 'week' and e.period_start = v_from::date
    and not exists (select 1 from public.social_profiles s where s.user_id = e.user_id and s.global_leaderboard);
  insert into public.leaderboard_entries as e (user_id, period, period_start, score, active_days, engine_version, computed_at)
  select s.user_id, 'week', v_from::date,
         coalesce((select sum(v.minutes) from public.valid_focus(s.user_id, v_from, v_from + interval '7 days') v), 0),
         coalesce((select count(*) from public.valid_focus(s.user_id, v_from, v_from + interval '7 days') v where v.minutes > 0), 0),
         1, now()
  from public.social_profiles s
  where s.global_leaderboard and public.social_tier(s.user_id) = 'adult'
  on conflict (user_id, period, period_start) do update
    set score = excluded.score, active_days = excluded.active_days, computed_at = now();
end
$$;

create or replace function public.global_leaderboard()
returns table (rank int, display_name text, is_me boolean, focus_minutes int, active_days int)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare v_from date := (date_trunc('week', now() at time zone 'UTC'))::date;
begin
  if public.require_social() <> 'adult' then raise exception 'adults only' using errcode = 'NP001'; end if;
  return query
  select x.rank::int, x.display_name, x.is_me, x.score, x.active_days from (
    select rank() over (order by e.score desc) as rank, s.display_name, e.user_id = auth.uid() as is_me,
           e.score, e.active_days
    from public.leaderboard_entries e join public.social_profiles s on s.user_id = e.user_id
    where e.period = 'week' and e.period_start = v_from and s.global_leaderboard
      and not public.is_blocked(auth.uid(), e.user_id)
  ) x
  where x.rank <= 50 or x.is_me
  order by x.rank;
end
$$;

do $$
begin
  create extension if not exists pg_cron;
  perform cron.schedule('global-leaderboard', '*/30 * * * *', 'select public.refresh_global_leaderboard()');
exception when others then
  raise notice 'pg_cron yok; genel sıralama elle tazelenir: %', sqlerrm;
end
$$;

-- ───────────────────────── 12. Beyin karşılaştırma ─────────────────────────
-- brain_snapshot Edge Function'ı kullanıcının JWT'siyle sorar.
create or replace function public.can_view_brain(p_friend uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select public.social_tier(auth.uid()) <> 'none' and (p_friend = auth.uid() or (
    public.is_friend(auth.uid(), p_friend)
    and coalesce((select share_brain from public.social_profiles where user_id = p_friend), false)))
$$;

-- ───────────────────────── 13. Canlı değişiklikler ─────────────────────────
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    alter publication supabase_realtime add table public.messages, public.friendships,
      public.cofocus_participants, public.shared_activity_participants, public.shared_activity_changes;
  end if;
end
$$;

-- ───────────────────────── 14. Yetkiler ─────────────────────────
do $$
declare f text;
begin
  -- İstemciye açık RPC'ler (yalnız oturumlu kullanıcı).
  foreach f in array array[
    'social_status()', 'save_social_profile(text, text, boolean, boolean, boolean)',
    'create_invite(text)', 'revoke_invite(uuid)', 'redeem_invite(text)', 'request_friend(text)',
    'respond_friend_request(uuid, boolean)', 'remove_friend(uuid)', 'request_partner(uuid)',
    'respond_partner(uuid, boolean)', 'end_partner(uuid)', 'block_user(uuid)', 'unblock_user(uuid)',
    'friend_overview()', 'report_content(text, uuid, text, text, uuid)',
    'set_visibility(text, text, uuid, uuid, text)', 'publish_calendar(timestamptz, timestamptz, jsonb)',
    'friend_calendar(uuid, timestamptz, timestamptz)', 'common_free_time(uuid[], timestamptz, timestamptz, int)',
    'open_direct(uuid)', 'send_message(uuid, text, uuid)', 'delete_message(uuid)', 'toggle_reaction(uuid, text)',
    'mark_read(uuid)', 'set_conversation_muted(uuid, boolean)', 'conversations_overview()',
    'propose_shared_activity(text, uuid[], timestamptz, timestamptz, text, text, text, int)',
    'respond_shared_activity(uuid, boolean)', 'leave_shared_activity(uuid)',
    'propose_shared_change(uuid, jsonb)', 'respond_shared_change(uuid, boolean)',
    'report_shared_progress(uuid, int)', 'shared_overview()', 'server_now()',
    'create_cofocus(uuid[], boolean)', 'respond_cofocus(uuid, boolean)', 'start_cofocus(uuid)',
    'set_cofocus_focus(uuid, uuid, text)', 'finish_cofocus(uuid, text)', 'cofocus_state(uuid)',
    'voice_room(uuid)', 'together_badges()', 'friends_leaderboard()', 'global_leaderboard()',
    'can_view_brain(uuid)', 'cofocus_topic_ok(text)'
  ] loop
    execute format('revoke execute on function public.%s from public, anon', f);
    execute format('grant execute on function public.%s to authenticated', f);
  end loop;
  -- Yalnız içeriden kullanılanlar: hiçbir istemci rolü çağıramaz.
  foreach f in array array[
    'min_age(uuid)', 'profiles_age_guard()', 'social_tier(uuid)', 'require_social()',
    'rate_limit(text, int, int)', 'friendships_partner_slots()', 'pair_friendship(uuid, uuid)',
    'display_name_of(uuid)', 'resolve_report(uuid, text, text)', 'mask_profanity(text)',
    'conversation_open(uuid)', 'other_member(uuid)', 'settle_shared_activity(uuid)', 'shared_parties(uuid)',
    'apply_shared_change(uuid)', 'focus_sessions_received()', 'valid_focus(uuid, timestamptz, timestamptz)',
    'week_start_for(uuid)', 'refresh_global_leaderboard()'
  ] loop
    execute format('revoke execute on function public.%s from public, anon, authenticated', f);
  end loop;
end
$$;
-- RLS politikalarında kullanıldığı için oturumlu kullanıcı çağırabilmeli; yalnız kendi ilişkisini söyler.
grant execute on function public.conversation_open(uuid) to authenticated;
grant execute on function public.shared_parties(uuid) to authenticated;
