-- Sosyal görünürlük, takvim ve misafir kısıtı testleri (supabase test db).
begin;
create extension if not exists pgtap with schema extensions;
select plan(19);

create function pg_temp.as_user(p uuid, p_anon boolean default false) returns void language sql as $$
  select set_config('request.jwt.claims',
    json_build_object('sub', p, 'role', 'authenticated', 'is_anonymous', p_anon)::text, true)
$$;

insert into auth.users (id, email, is_anonymous) values
  ('00000000-0000-0000-0000-0000000000a1', 'a@test.local', false),
  ('00000000-0000-0000-0000-0000000000b1', 'b@test.local', false),
  ('00000000-0000-0000-0000-0000000000c1', 'c@test.local', false),
  ('00000000-0000-0000-0000-0000000000d1', null, true);
insert into public.profiles (id, user_id, timezone, birth_year) values
  ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000a1', 'Europe/Istanbul', 1990),
  ('00000000-0000-0000-0000-0000000000b1', '00000000-0000-0000-0000-0000000000b1', 'Europe/Istanbul', 1992),
  ('00000000-0000-0000-0000-0000000000c1', '00000000-0000-0000-0000-0000000000c1', 'Europe/Istanbul', 1991);
insert into public.social_profiles (user_id, display_name) values
  ('00000000-0000-0000-0000-0000000000a1', 'A'),
  ('00000000-0000-0000-0000-0000000000b1', 'B'),
  ('00000000-0000-0000-0000-0000000000c1', 'C');

-- A ile B arkadaş; A'nın yarın bir işi var ve takvimini yayınladı.
insert into public.friendships (user_id, friend_id, status)
values ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000b1', 'accepted');
insert into public.activities (id, user_id, kind, title, notes, root_category_key)
values ('0193a5b2-0000-7000-8000-0000000000a0', '00000000-0000-0000-0000-0000000000a1',
        'routine', 'Antrenman', 'gizli not', 'body_movement');
insert into public.calendar_blocks (user_id, activity_id, start_at, end_at)
values ('00000000-0000-0000-0000-0000000000a1', '0193a5b2-0000-7000-8000-0000000000a0',
        date_trunc('hour', now()) + interval '1 day', date_trunc('hour', now()) + interval '1 day 1 hour');
insert into public.calendar_publications (user_id, window_start, window_end) values
  ('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '14 days'),
  ('00000000-0000-0000-0000-0000000000b1', now(), now() + interval '14 days');
insert into public.leaderboard_entries (user_id, period, period_start, score, engine_version)
values ('00000000-0000-0000-0000-0000000000a1', 'week', current_date, 1200, 1);

set local role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');

select is((select count(*)::int from public.leaderboard_entries), 1, 'arkadaş sıralama satırını görür');
select is((select count(*)::int from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  1, 'kural yoksa arkadaş meşgul bloğu görür');
select is((select title from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  null, 'meşgul düzeyinde başlık gizli');
select is((select count(*)::int from public.calendar_blocks) + (select count(*)::int from public.activities),
  0, 'arkadaş blok ve aktivite tablolarını doğrudan okuyamaz');

reset role;
update public.friendships set is_partner = true
where user_id = '00000000-0000-0000-0000-0000000000a1' and friend_id = '00000000-0000-0000-0000-0000000000b1';
set local role authenticated;

select is((select title from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  'Antrenman', 'partner varsayılan olarak başlık ve saati görür');
select is((select notes from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  null, 'başlık+saat düzeyinde not gizli');

-- A kategoriyi partnerden gizler.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select public.set_visibility('hidden', 'partner', null, null, 'body_movement');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select is((select count(*)::int from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  0, 'gizli kategori takvimden sızmaz');
select is((select count(*)::int from public.common_free_time(array['00000000-0000-0000-0000-0000000000a1'::uuid],
           now(), now() + interval '3 days', 30) f
           where f.start_at < date_trunc('hour', now()) + interval '1 day 1 hour'
             and f.end_at > date_trunc('hour', now()) + interval '1 day'),
  0, 'gizli iş ortak boş zamanda dolu sayılır');
select ok((select count(*) from public.common_free_time(array['00000000-0000-0000-0000-0000000000a1'::uuid],
           now(), now() + interval '3 days', 30)) >= 2, 'ortak boş zaman yalnız aralık döner');

-- Kişi istisnası: "bu partnerime tam göster".
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select public.set_visibility('full', null, '00000000-0000-0000-0000-0000000000b1', null, 'body_movement');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select is((select notes from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  'gizli not', 'kişi istisnası kitle kuralını geçer');

-- Arkadaş olmayan göremez.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select throws_ok(
  $$select * from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')$$,
  '42501', null, 'arkadaş olmayan takvimi göremez');
select is((select count(*)::int from public.leaderboard_entries), 0, 'arkadaş olmayan sıralamayı görmez');
select throws_ok(
  $$select * from public.common_free_time(array['00000000-0000-0000-0000-0000000000a1'::uuid], now(), now() + interval '3 days', 30)$$,
  '42501', null, 'arkadaş olmayanla boş zaman aranamaz');
select throws_ok(
  $$select public.is_friend('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000b1')$$,
  '42501', null, 'başkalarının arkadaşlığı sorgulanamaz');

-- Misafir sosyal işlem yapamaz; kimse sosyal tablolara doğrudan yazamaz.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d1', true);
select throws_ok($$select public.create_invite('friend')$$, 'NP001', null, 'misafir davet oluşturamaz');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select throws_ok(
  $$insert into public.blocks (blocked_user_id) values ('00000000-0000-0000-0000-0000000000a1')$$,
  '42501', null, 'sosyal tabloya doğrudan yazılamaz');

-- B, A'yı engeller.
select lives_ok($$select public.block_user('00000000-0000-0000-0000-0000000000a1')$$, 'kullanıcı engelleyebilir');
select throws_ok(
  $$select * from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')$$,
  '42501', null, 'engel takvim görünürlüğünü kapatır');

select ok((with i as (select public.gen_invite_code() c) select c ~ '^[A-HJ-KM-NP-Z2-9]{10}$' from i),
  'davet kodu 10 karakter, karışan harf yok');

select * from finish();
rollback;
