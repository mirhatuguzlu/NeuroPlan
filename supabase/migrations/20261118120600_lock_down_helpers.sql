-- Yardımcı security definer fonksiyonları REST'ten (/rest/v1/rpc) çağrılamasın
-- (Supabase güvenlik danışmanı 0028/0029). Aksi halde oturumsuz biri bile is_friend(a, b) ile
-- herhangi iki kullanıcının arkadaş ya da engelli olup olmadığını sorgulayabiliyordu.

-- Yalnız başka definer fonksiyonların içinden ya da tetikleyici olarak çalışanlar: herkese kapalı.
revoke execute on function public.sync_before_write() from public, anon, authenticated;
revoke execute on function public.is_blocked(uuid, uuid) from public, anon, authenticated;
revoke execute on function public.is_partner(uuid, uuid) from public, anon, authenticated;
revoke execute on function public.is_friend(uuid, uuid) from public, anon, authenticated;
revoke execute on function public.visibility_level(uuid, uuid, uuid, text) from public, anon, authenticated;

-- RLS politikalarında kullanılanlar yalnız çağıranın kendi ilişkisini söyler; yalnız oturumlu kullanıcıya açık.
create or replace function public.is_my_friend(p_other uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$ select public.is_friend(auth.uid(), p_other) $$;

revoke execute on function public.is_my_friend(uuid) from public, anon;
revoke execute on function public.is_member(uuid) from public, anon;
revoke execute on function public.is_shared_activity_party(uuid) from public, anon;
revoke execute on function public.is_cofocus_party(uuid) from public, anon;
grant execute on function public.is_my_friend(uuid) to authenticated;
grant execute on function public.is_member(uuid) to authenticated;
grant execute on function public.is_shared_activity_party(uuid) to authenticated;
grant execute on function public.is_cofocus_party(uuid) to authenticated;

drop policy leaderboard_select on public.leaderboard_entries;
create policy leaderboard_select on public.leaderboard_entries for select to authenticated
  using (user_id = (select auth.uid()) or public.is_my_friend(user_id));
