-- Mesaj push bildirimi: kimlik kaydı ve alıcı seçimi (supabase test db).
begin;
create extension if not exists pgtap with schema extensions;
select plan(8);

create function pg_temp.as_user(p uuid, p_anon boolean default false) returns void language sql as $$
  select set_config('request.jwt.claims',
    json_build_object('sub', p, 'role', 'authenticated', 'is_anonymous', p_anon)::text, true)
$$;

insert into auth.users (id, email, is_anonymous) values
  ('00000000-0000-0000-0000-0000000000a1', 'a@test.local', false),
  ('00000000-0000-0000-0000-0000000000b1', 'b@test.local', false),
  ('00000000-0000-0000-0000-0000000000d1', null, true);
insert into public.profiles (id, user_id, timezone, birth_year, locale) values
  ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000a1', 'Europe/Istanbul', 1990, 'tr'),
  ('00000000-0000-0000-0000-0000000000b1', '00000000-0000-0000-0000-0000000000b1', 'Europe/Istanbul', 1990, 'en');
insert into public.social_profiles (user_id, display_name) values
  ('00000000-0000-0000-0000-0000000000a1', 'A'), ('00000000-0000-0000-0000-0000000000b1', 'B');
insert into public.friendships (user_id, friend_id, status)
values ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000b1', 'accepted');

set local role authenticated;
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d1', true);
select throws_ok($$select public.register_push_token('token-misafir-123')$$, 'NP001', null, 'misafir push kaydedemez');

select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select lives_ok($$select public.register_push_token('token-b-1234567')$$, 'kullanıcı cihaz kimliğini kaydeder');
select is((select count(*)::int from public.push_tokens), 0, 'kimlik tablosu istemciye kapalı (RLS, politika yok)');

select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
create temp table c as select public.open_direct('00000000-0000-0000-0000-0000000000b1') as id;
grant select on c to authenticated;
select lives_ok($$select public.send_message((select id from c), 'selam')$$, 'Vault ayarı yokken mesaj yine gider');
create temp table m as select id from public.messages limit 1;

reset role;
select is((select count(*)::int from public.message_push_targets((select id from m))), 1, 'alıcıya bir bildirim');
select is((select locale from public.message_push_targets((select id from m))), 'en', 'alıcının dili');

-- Odakta bildirim susar.
insert into public.focus_sessions (user_id, mode, started_at, outcome)
values ('00000000-0000-0000-0000-0000000000b1', 'free', now() - interval '10 minutes', 'in_progress');
select is((select count(*)::int from public.message_push_targets((select id from m))), 0, 'odaktaki alıcıya push gitmez');
delete from public.focus_sessions where user_id = '00000000-0000-0000-0000-0000000000b1';

-- Sessize alınan sohbet.
update public.conversation_members set muted = true where user_id = '00000000-0000-0000-0000-0000000000b1';
select is((select count(*)::int from public.message_push_targets((select id from m))), 0, 'sessize alınan sohbete push gitmez');

select * from finish();
rollback;
