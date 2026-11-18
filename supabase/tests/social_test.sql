-- Sosyal görünürlük ve misafir kısıtı testleri (supabase test db).
begin;
create extension if not exists pgtap with schema extensions;
select plan(12);

insert into auth.users (id, email, is_anonymous) values
  ('00000000-0000-0000-0000-0000000000a1', 'a@test.local', false),
  ('00000000-0000-0000-0000-0000000000b1', 'b@test.local', false),
  ('00000000-0000-0000-0000-0000000000c1', 'c@test.local', false),
  ('00000000-0000-0000-0000-0000000000d1', null, true);

-- Kurulum (postgres olarak): A ile B arkadaş; A'nın yarın bir planı var.
insert into public.friendships (user_id, friend_id, status)
values ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000b1', 'accepted');
insert into public.activities (id, user_id, kind, title, notes, root_category_key)
values ('0193a5b2-0000-7000-8000-0000000000a0', '00000000-0000-0000-0000-0000000000a1',
        'routine', 'Antrenman', 'gizli not', 'body_movement');
insert into public.plan_instances (user_id, activity_id, occurrence_date, start_at, end_at, source)
values ('00000000-0000-0000-0000-0000000000a1', '0193a5b2-0000-7000-8000-0000000000a0',
        current_date + 1, now() + interval '1 day', now() + interval '1 day 1 hour', 'manual');

set local role authenticated;
set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-0000000000b1", "role": "authenticated"}';

select is((select count(*)::int from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  0, 'kural yoksa varsayılan gizli');
select is((select count(*)::int from public.plan_instances), 0, 'arkadaş tabloyu doğrudan okuyamaz');

reset role;
insert into public.visibility_settings (user_id, audience, level)
values ('00000000-0000-0000-0000-0000000000a1', 'friends', 'busy');
set local role authenticated;

select is((select count(*)::int from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  1, 'meşgul düzeyinde zaman görünür');
select is((select title from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  null, 'meşgul düzeyinde başlık gizli');

reset role;
insert into public.visibility_settings (user_id, viewer_id, level)
values ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000b1', 'title_time');
set local role authenticated;

select is((select title from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  'Antrenman', 'kişiye özel kural kitle kuralını geçer');
select is((select notes from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  null, 'başlık+saat düzeyinde not gizli');

reset role;
insert into public.visibility_settings (user_id, viewer_id, root_category_key, level)
values ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000b1', 'body_movement', 'hidden');
set local role authenticated;

select is((select count(*)::int from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')),
  0, 'kişi + kategori kuralı en özel olandır');

-- Arkadaş olmayan göremez.
set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-0000000000c1", "role": "authenticated"}';
select throws_ok(
  $$select * from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')$$,
  '42501', null, 'arkadaş olmayan takvimi göremez');

-- Misafir sosyal tablolara yazamaz; normal kullanıcı yazabilir.
set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-0000000000d1", "role": "authenticated", "is_anonymous": true}';
select throws_ok(
  $$insert into public.blocks (blocked_user_id) values ('00000000-0000-0000-0000-0000000000a1')$$,
  '42501', null, 'misafir engelleme yazamaz');

set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-0000000000b1", "role": "authenticated"}';
select lives_ok(
  $$insert into public.blocks (blocked_user_id) values ('00000000-0000-0000-0000-0000000000a1')$$,
  'kullanıcı engelleyebilir');
select throws_ok(
  $$select * from public.friend_calendar('00000000-0000-0000-0000-0000000000a1', now(), now() + interval '7 days')$$,
  '42501', null, 'engel arkadaşlık görünürlüğünü kapatır');

-- Davet kodu sunucuda üretilir.
select ok((select code from public.invites limit 1) is null
          and (with i as (select public.gen_invite_code() c) select c ~ '^[A-HJ-KM-NP-Z2-9]{10}$' from i),
  'davet kodu 10 karakter, karışan harf yok');

select * from finish();
rollback;
