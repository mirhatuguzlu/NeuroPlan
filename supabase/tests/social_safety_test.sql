-- Arkadaşlık, partner, yaş, mesaj, engel, şikâyet, sıralama ve ortak işler (supabase test db).
begin;
create extension if not exists pgtap with schema extensions;
select plan(35);

create function pg_temp.as_user(p uuid) returns void language sql as $$
  select set_config('request.jwt.claims',
    json_build_object('sub', p, 'role', 'authenticated', 'is_anonymous', false)::text, true)
$$;

-- A, B, C, E yetişkin · T 16 yaş (en düşük olası) · M 14 yaş.
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000a1', 'a@test.local'),
  ('00000000-0000-0000-0000-0000000000b1', 'b@test.local'),
  ('00000000-0000-0000-0000-0000000000c1', 'c@test.local'),
  ('00000000-0000-0000-0000-0000000000e1', 'e@test.local'),
  ('00000000-0000-0000-0000-0000000000f1', 't@test.local'),
  ('00000000-0000-0000-0000-000000000011', 'm@test.local');
insert into public.profiles (id, user_id, timezone, birth_year)
select u, u, 'Europe/Istanbul', y from (values
  ('00000000-0000-0000-0000-0000000000a1'::uuid, 1990),
  ('00000000-0000-0000-0000-0000000000b1'::uuid, 1991),
  ('00000000-0000-0000-0000-0000000000c1'::uuid, 1992),
  ('00000000-0000-0000-0000-0000000000e1'::uuid, 1993),
  ('00000000-0000-0000-0000-0000000000f1'::uuid, extract(year from now())::int - 17),
  ('00000000-0000-0000-0000-000000000011'::uuid, extract(year from now())::int - 14)) v(u, y);

set local role authenticated;

-- Yaş kuralları.
select pg_temp.as_user('00000000-0000-0000-0000-000000000011');
select throws_ok($$select public.save_social_profile('M')$$, 'NP001', null, '15 yaş altı sosyal açamaz');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f1');
select public.save_social_profile('T', 'teen_t', false, true, false);
select is((select global_leaderboard from public.social_profiles), false, '15–17 yaş genel sıralamaya giremez');
select throws_ok($$select * from public.global_leaderboard()$$, 'NP001', null, '15–17 yaş genel tabloyu açamaz');
select is((public.social_status() ->> 'tier'), 'minor', '16 yaş sıkı modda');
select is((select discoverable from public.social_profiles), false, 'bulunabilirlik varsayılan kapalı');

select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select public.save_social_profile('A', 'user_a', true);
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select public.save_social_profile('B', 'user_b');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select public.save_social_profile('C');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
select public.save_social_profile('E');
select throws_ok($$select public.save_social_profile('E2', 'user_a')$$, 'NP409', null, 'kullanıcı adı tekil');

-- Davetle arkadaşlık.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
create temp table inv as select public.create_invite('friend') ->> 'code' as code;
grant select on inv to authenticated;
select throws_ok($$select public.redeem_invite((select code from inv))$$, 'NP404', null, 'kendi davetini kullanamaz');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select is((public.redeem_invite((select code from inv)) ->> 'display_name'), 'A', 'davet kodu arkadaşlık kurar');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select throws_ok($$select public.redeem_invite((select code from inv))$$, 'NP404', null, 'tek kullanımlık davet ikinci kez çalışmaz');

-- Kullanıcı adıyla istek: yalnız bulunabilir hesaba.
select throws_ok($$select public.request_friend('user_b')$$, 'NP404', null, 'bulunabilir olmayan hesaba istek gitmez');
select lives_ok($$select public.request_friend('user_a')$$, 'tam kullanıcı adıyla istek');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select is(jsonb_array_length(public.friend_overview() -> 'incoming'), 1, 'istek gelen kutusunda');
select public.respond_friend_request((select (public.friend_overview() -> 'incoming' -> 0 ->> 'friendship_id')::uuid), true);
select is(jsonb_array_length(public.friend_overview() -> 'friends'), 2, 'istek kabul edildi');

-- Partner: karşılıklı onay, kişi başına bir partner.
select public.request_partner('00000000-0000-0000-0000-0000000000b1');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select public.respond_partner('00000000-0000-0000-0000-0000000000a1', true);
select is((select count(*)::int from public.friendships where is_partner), 1, 'partnerlik karşılıklı onayla kurulur');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select throws_ok($$select public.request_partner('00000000-0000-0000-0000-0000000000a1')$$, 'NP409', null,
  'partneri olan kişiye partner isteği gitmez');
reset role;
select throws_ok($$update public.friendships set is_partner = true
  where '00000000-0000-0000-0000-0000000000c1' in (user_id, friend_id)$$,
  '23505', null, 'veritabanı kısıtı ikinci partneri reddeder');
set local role authenticated;

-- Mesaj: küfür maskelenir, masum kelime kalır.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
create temp table conv as select public.open_direct('00000000-0000-0000-0000-0000000000b1') as id;
grant select on conv to authenticated;
select is((public.send_message((select id from conv), 'siktir git')).body, '****** git', 'küfür maskelenir');
select is((public.send_message((select id from conv), 'Sıkıldım, Fuck!')).body, 'Sıkıldım, ****!', 'masum kelime ve büyük harf');

-- Şikâyet mesajın kopyasını tutar; mesaj silinse de kanıt kalır.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
create temp table rep as select public.report_content('message',
  (select id from public.messages order by created_at limit 1), 'harassment') as id;
grant select on rep to authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select public.delete_message((select id from public.messages order by created_at limit 1));
reset role;
select is((select snapshot from public.reports where id = (select id from rep)), '****** git', 'şikâyet mesaj kopyasını saklar');
select is((select reported_user_id from public.reports where id = (select id from rep)),
  '00000000-0000-0000-0000-0000000000a1'::uuid, 'şikâyet edilen kişi sunucuda belirlenir');
set local role authenticated;
select throws_ok($$select * from public.moderation_queue$$, '42501', null, 'moderasyon kuyruğu istemciye kapalı');

-- Arkadaş olmayan mesaj atamaz.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
select throws_ok($$select public.open_direct('00000000-0000-0000-0000-0000000000a1')$$, 'NP404', null,
  'arkadaş olmayanla sohbet açılamaz');
select throws_ok($$select public.send_message((select id from conv), 'merhaba')$$, '42501', null,
  'üye olmayan sohbete yazamaz');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select public.remove_friend('00000000-0000-0000-0000-0000000000a1');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select throws_ok($$select public.send_message((select id from conv), 'hâlâ orada mısın')$$, '42501', null,
  'arkadaşlıktan çıkınca mesaj atılamaz');
select is((select count(*)::int from public.partner_slots), 0, 'arkadaşlık bitince partnerlik de biter');

-- Engellenmiş kişi eski mesajları da göremez.
create temp table conv_c as select public.open_direct('00000000-0000-0000-0000-0000000000c1') as id;
grant select on conv_c to authenticated;
select public.send_message((select id from conv_c), 'selam');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select public.block_user('00000000-0000-0000-0000-0000000000a1');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select is((select count(*)::int from public.messages where conversation_id = (select id from conv_c)), 0,
  'engellenmiş kişi sohbeti göremez');
select is(jsonb_array_length(public.friend_overview() -> 'friends'), 0, 'engel arkadaşlığı siler');

-- Hız sınırı: dakikada 20 mesaj.
reset role;
insert into public.friendships (user_id, friend_id, status)
values ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000e1', 'accepted');
set local role authenticated;
create temp table conv_e as select public.open_direct('00000000-0000-0000-0000-0000000000e1') as id;
grant select on conv_e to authenticated;
select throws_ok($$select public.send_message((select id from conv_e), 'n' || g) from generate_series(1, 21) g$$,
  'NP429', null, 'dakikada 20 mesajdan sonrası reddedilir');

-- Ortak etkinlik: değişiklik karşı tarafın onayıyla uygulanır.
create temp table sa as select public.propose_shared_activity('Kütüphane',
  array['00000000-0000-0000-0000-0000000000e1'::uuid], now() + interval '2 days', now() + interval '2 days 2 hours') as id;
grant select on sa to authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
select public.respond_shared_activity((select id from sa), true);
select is((public.shared_overview() -> 0 ->> 'status'), 'confirmed', 'kabul edilince onaylanır');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
create temp table ch as select public.propose_shared_change((select id from sa), '{"title": "Kafe"}') as id;
grant select on ch to authenticated;
select is((public.shared_overview() -> 0 ->> 'title'), 'Kütüphane', 'değişiklik onaysız uygulanmaz');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
select public.respond_shared_change((select id from ch), true);
select is((public.shared_overview() -> 0 ->> 'title'), 'Kafe', 'onaylanan değişiklik uygulanır');

-- Ortak odak kanalı yalnız katılımcıya açık.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
create temp table cf as select public.create_cofocus(array['00000000-0000-0000-0000-0000000000e1'::uuid], true) as id;
grant select on cf to authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select is(public.cofocus_topic_ok('cofocus:' || (select id from cf)), false, 'katılımcı olmayan kanala giremez');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
select is(public.voice_room((select id from cf)), null, 'davetli katılmadan ses odası alamaz');

-- Sıralama yalnız doğrulanan oturumlardan: çakışan ve gerçek süreden uzun oturum sayılmaz.
reset role;
insert into public.focus_sessions (id, user_id, mode, started_at, ended_at, focused_seconds, outcome) values
  ('0193a5b2-0000-7000-8000-00000000f001', '00000000-0000-0000-0000-0000000000a1', 'free',
   public.week_start_for('00000000-0000-0000-0000-0000000000a1') + interval '1 hour',
   public.week_start_for('00000000-0000-0000-0000-0000000000a1') + interval '1 hour 30 minutes', 1800, 'completed'),
  ('0193a5b2-0000-7000-8000-00000000f002', '00000000-0000-0000-0000-0000000000a1', 'free',
   public.week_start_for('00000000-0000-0000-0000-0000000000a1') + interval '3 hours',
   public.week_start_for('00000000-0000-0000-0000-0000000000a1') + interval '4 hours', 3600, 'completed'),
  ('0193a5b2-0000-7000-8000-00000000f003', '00000000-0000-0000-0000-0000000000a1', 'free',
   public.week_start_for('00000000-0000-0000-0000-0000000000a1') + interval '3 hours 30 minutes',
   public.week_start_for('00000000-0000-0000-0000-0000000000a1') + interval '4 hours 30 minutes', 3600, 'completed'),
  ('0193a5b2-0000-7000-8000-00000000f004', '00000000-0000-0000-0000-0000000000a1', 'free',
   now() - interval '10 minutes', now() + interval '1 hour', 600, 'completed');
set local role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select is((select focus_minutes from public.friends_leaderboard() where is_me), 30,
  'çakışan ve gelecekte biten oturumlar sıralamaya girmez');

-- Yaş sonradan küçültülemez.
reset role;
select throws_ok($$update public.profiles set birth_year = 2000 where id = '00000000-0000-0000-0000-0000000000a1'$$,
  '22023', null, 'doğum yılı ileri alınamaz');

select * from finish();
rollback;
