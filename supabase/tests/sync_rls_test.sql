-- Eşitleme ve RLS testleri (supabase test db). Tek işlemde çalışır, sonunda geri alınır.
begin;
create extension if not exists pgtap with schema extensions;
select plan(26);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000a1', 'a@test.local'),
  ('00000000-0000-0000-0000-0000000000b1', 'b@test.local');

-- Sistem tabloları: herkes okur, kimse yazamaz.
set local role anon;
select is((select count(*)::int from public.root_categories), 9, 'anon kök kategorileri okur');
select is((select count(*)::int from public.brain_regions), 20, 'bölgeler seed edildi');
select is((select count(*)::int from public.category_region_weights), 32, 'ağırlıklar seed edildi');
reset role;

set local role authenticated;
set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-0000000000a1", "role": "authenticated"}';

select throws_ok(
  $$insert into public.root_categories values ('x', 99, 'x', 'x', 'x', 'x', 'x', '#000000')$$,
  '42501', null, 'sistem tablosuna yazılamaz');

-- Push: yeni satır, user_id sunucuda.
select is(
  public.sync_push($$[{"table": "activities", "id": "0193a5b2-0000-7000-8000-000000000001",
    "hlc": "001763481000000-00000-deva",
    "patch": {"kind": "task", "title": "Koşu", "root_category_key": "body_movement",
              "created_at": "2026-11-18T10:00:00Z"}}]$$::jsonb),
  '{"rejected": []}'::jsonb, 'push yeni satırı ekler');
select is((select user_id from public.activities where id = '0193a5b2-0000-7000-8000-000000000001'),
  '00000000-0000-0000-0000-0000000000a1'::uuid, 'user_id sunucuda atanır');

-- Alan bazlı LWW: varış sırası değil HLC karar verir.
select public.sync_push($$[
  {"table": "activities", "id": "0193a5b2-0000-7000-8000-000000000001",
   "hlc": "001763481000300-00000-devb", "patch": {"title": "Yeni başlık"}},
  {"table": "activities", "id": "0193a5b2-0000-7000-8000-000000000001",
   "hlc": "001763481000200-00000-deva", "patch": {"title": "Eski başlık", "notes": "Not"}}
]$$::jsonb);
select is((select title from public.activities where id = '0193a5b2-0000-7000-8000-000000000001'),
  'Yeni başlık', 'aynı alanda büyük HLC kazanır');
select is((select notes from public.activities where id = '0193a5b2-0000-7000-8000-000000000001'),
  'Not', 'farklı alan korunur');

select public.sync_push($$[{"table": "activities", "id": "0193a5b2-0000-7000-8000-000000000001",
  "hlc": "009999999999999-00000-devc", "patch": {"priority": 2}}]$$::jsonb);
select ok(
  left((select field_versions ->> 'priority' from public.activities
        where id = '0193a5b2-0000-7000-8000-000000000001'), 15)::bigint
    <= (extract(epoch from now()) * 1000)::bigint + 300000,
  'ileri tarihli HLC kırpılır');

-- Doğrulama: hatalı değişiklik reddedilir, aynı paketteki geçerli olan uygulanır.
select is(
  jsonb_array_length(public.sync_push($$[
    {"table": "schedule_rules", "id": "0193a5b2-0000-7000-8000-000000000010", "hlc": "001763481000400-00000-deva",
     "patch": {"activity_id": "0193a5b2-0000-7000-8000-000000000001",
               "recurrence": {"type": "rrule", "dtstart": "2026-11-23", "rrule": "FREQ=HOURLY"}}},
    {"table": "schedule_rules", "id": "0193a5b2-0000-7000-8000-000000000011", "hlc": "001763481000400-00000-deva",
     "patch": {"activity_id": "0193a5b2-0000-7000-8000-000000000001", "recurrence": {"type": "follow"}}},
    {"table": "schedule_rules", "id": "0193a5b2-0000-7000-8000-000000000012", "hlc": "001763481000400-00000-deva",
     "patch": {"activity_id": "0193a5b2-0000-7000-8000-000000000001",
               "recurrence": {"type": "per_period", "count": 3, "unit": "week"}, "flexibility": "shiftable"}},
    {"table": "secrets", "id": "0193a5b2-0000-7000-8000-000000000013", "hlc": "001763481000400-00000-deva",
     "patch": {"x": 1}}
  ]$$::jsonb) -> 'rejected'),
  3, 'geçersiz tekrar, çapasız follow ve bilinmeyen tablo reddedilir');
select is((select count(*)::int from public.schedule_rules), 1, 'geçerli kural uygulandı');

-- Pull: imleçten sonrası; user_id dönmez.
select is(public.sync_pull(0) -> 'changes' -> 'activities' -> 0 ->> 'title', 'Yeni başlık', 'pull değişikliği getirir');
select ok(not ((public.sync_pull(0) -> 'changes' -> 'activities' -> 0) ? 'user_id'), 'pull user_id döndürmez');
select is(public.sync_pull((public.sync_pull(0) ->> 'cursor')::bigint) -> 'changes', '{}'::jsonb,
  'imleçten sonra değişiklik yok');

-- Kategori ağacı, kök türetme.
select is(
  public.sync_push($$[
    {"table": "user_categories", "id": "0193a5b2-0000-7000-8000-000000000020", "hlc": "001763481000500-00000-deva",
     "patch": {"name": "Okul", "root_category_key": "learning_memory"}},
    {"table": "user_categories", "id": "0193a5b2-0000-7000-8000-000000000021", "hlc": "001763481000500-00000-deva",
     "patch": {"name": "Matematik", "root_category_key": "learning_memory",
               "parent_id": "0193a5b2-0000-7000-8000-000000000020"}},
    {"table": "activities", "id": "0193a5b2-0000-7000-8000-000000000002", "hlc": "001763481000500-00000-deva",
     "patch": {"kind": "project", "title": "Ödev", "root_category_key": "body_movement",
               "category_id": "0193a5b2-0000-7000-8000-000000000021"}}
  ]$$::jsonb),
  '{"rejected": []}'::jsonb, 'kategori ağacı ve aktivite eklenir');
select is((select root_category_key from public.activities where id = '0193a5b2-0000-7000-8000-000000000002'),
  'learning_memory', 'aktivitenin kökü kategoriden türetilir');
select is(
  jsonb_array_length(public.sync_push($$[
    {"table": "user_categories", "id": "0193a5b2-0000-7000-8000-000000000022", "hlc": "001763481000600-00000-deva",
     "patch": {"name": "Yanlış", "root_category_key": "body_movement",
               "parent_id": "0193a5b2-0000-7000-8000-000000000020"}},
    {"table": "user_categories", "id": "0193a5b2-0000-7000-8000-000000000020", "hlc": "001763481000600-00000-deva",
     "patch": {"parent_id": "0193a5b2-0000-7000-8000-000000000021"}}
  ]$$::jsonb) -> 'rejected'),
  2, 'kök uyuşmazlığı ve döngü reddedilir');

-- Biten odak oturumu değişmez; puan değişebilir.
select public.sync_push($$[{"table": "focus_sessions", "id": "0193a5b2-0000-7000-8000-000000000030",
  "hlc": "001763481000700-00000-deva",
  "patch": {"mode": "free", "root_category_key": "body_movement", "started_at": "2026-11-18T10:00:00Z",
            "ended_at": "2026-11-18T10:30:00Z", "focused_seconds": 1500, "outcome": "completed"}}]$$::jsonb);
select is(
  jsonb_array_length(public.sync_push($$[{"table": "focus_sessions", "id": "0193a5b2-0000-7000-8000-000000000030",
    "hlc": "001763481000800-00000-deva", "patch": {"focused_seconds": 1700}}]$$::jsonb) -> 'rejected'),
  1, 'biten oturumun süresi değiştirilemez');
select is(
  public.sync_push($$[{"table": "focus_sessions", "id": "0193a5b2-0000-7000-8000-000000000030",
    "hlc": "001763481000800-00000-deva", "patch": {"focus_rating": 4}}]$$::jsonb),
  '{"rejected": []}'::jsonb, 'biten oturuma puan verilebilir');

-- Beyin olayı tekilleşir.
select public.sync_push($$[
  {"table": "brain_events", "id": "0193a5b2-0000-7000-8000-000000000040", "hlc": "001763481000900-00000-deva",
   "patch": {"type": "neuron_gain", "region_key": "hippocampus", "amount": 1000, "occurred_at": "2026-11-18T10:30:00Z",
             "session_id": "0193a5b2-0000-7000-8000-000000000030", "dedupe_key": "gain:s1:hippocampus:v1", "engine_version": 1}},
  {"table": "brain_events", "id": "0193a5b2-0000-7000-8000-000000000041", "hlc": "001763481000900-00000-devb",
   "patch": {"type": "neuron_gain", "region_key": "hippocampus", "amount": 1000, "occurred_at": "2026-11-18T10:30:00Z",
             "session_id": "0193a5b2-0000-7000-8000-000000000030", "dedupe_key": "gain:s1:hippocampus:v1", "engine_version": 1}}
]$$::jsonb);
select is((select count(*)::int from public.brain_events), 1, 'aynı beyin olayı tek satır');

-- Kalıcı silme yok.
delete from public.activities;
select is((select count(*)::int from public.activities), 2, 'istemci kalıcı silemez');

-- B, A'nın verisini göremez ve değiştiremez.
set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-0000000000b1", "role": "authenticated"}';
select is((select count(*)::int from public.activities), 0, 'B, A''nın satırlarını görmez');
select is(public.sync_pull(0) -> 'changes', '{}'::jsonb, 'B''nin pull''u boş');
update public.activities set title = 'hack';
select is(
  jsonb_array_length(public.sync_push($$[{"table": "activities", "id": "0193a5b2-0000-7000-8000-000000000001",
    "hlc": "001763481009999-00000-devx", "patch": {"kind": "task", "title": "hack"}}]$$::jsonb) -> 'rejected'),
  1, 'B, A''nın satırını push ile ezemez');
select throws_ok(
  $$insert into public.activities (user_id, kind, title) values ('00000000-0000-0000-0000-0000000000a1', 'task', 'x')$$,
  '42501', null, 'başkası adına satır eklenemez');

set local request.jwt.claims to '{"sub": "00000000-0000-0000-0000-0000000000a1", "role": "authenticated"}';
select is((select title from public.activities where id = '0193a5b2-0000-7000-8000-000000000001'),
  'Yeni başlık', 'B''nin denemeleri etkisiz');

select * from finish();
rollback;
