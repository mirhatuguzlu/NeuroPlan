-- Özellik bayrakları: herkes okur, istemci yazamaz (supabase test db, D58).
begin;
create extension if not exists pgtap with schema extensions;
select plan(4);

insert into public.feature_flags (key, enabled) values ('voice', false);

set local role anon;
select is((select enabled from public.feature_flags where key = 'voice'), false, 'misafir bayrağı okur');
select throws_ok($$insert into public.feature_flags (key, enabled) values ('together', false)$$,
  '42501', null, 'anon bayrak ekleyemez');

set local role authenticated;
select set_config('request.jwt.claims', json_build_object('sub', gen_random_uuid(), 'role', 'authenticated')::text, true);
select throws_ok($$update public.feature_flags set enabled = true where key = 'voice'$$,
  '42501', null, 'kullanıcı bayrağı değiştiremez');
select is((select count(*)::int from public.feature_flags), 1, 'girişli kullanıcı da okur');

select * from finish();
rollback;
