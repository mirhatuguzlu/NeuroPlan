-- brain_snapshot Edge Function'ının girdisi (ARCHITECTURE §7). Yalnız service role çağırır.
-- Oturumlar sıralamadaki gibi süzülür: gelecekte biten, gerçek süreden uzun ve aynı kişinin başka
-- tamamlanmış oturumuyla çakışan oturum sunucu beynine girmez (SOCIAL_SAFETY §4.7).
create or replace function public.brain_input(p_user uuid)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  with s as (
    select f.* from public.focus_sessions f
    where f.user_id = p_user and f.deleted_at is null and f.ended_at is not null
      and f.outcome in ('completed', 'broken')
      and f.ended_at <= now() + interval '5 minutes'
      and f.focused_seconds <= extract(epoch from f.ended_at - f.started_at) + 60
      and not exists (select 1 from public.focus_sessions o
                      where o.user_id = f.user_id and o.id <> f.id and o.deleted_at is null
                        and o.outcome = 'completed' and o.ended_at is not null
                        and o.started_at < f.ended_at and o.ended_at > f.started_at)
  )
  select jsonb_build_object(
    'timezone', coalesce((select timezone from public.profiles where id = p_user), 'Etc/UTC'),
    'as_of', now(),
    'region_keys', (select jsonb_agg(key order by sort_order) from public.brain_regions),
    'weights', (select jsonb_agg(jsonb_build_object('root_category_key', root_category_key,
                                                    'region_key', region_key, 'weight', weight))
                from public.category_region_weights),
    'sessions', coalesce((select jsonb_agg(jsonb_build_object(
        'id', id, 'root_category_key', root_category_key, 'mode', mode, 'settings', settings,
        'segments', segments, 'outcome', outcome, 'focused_seconds', focused_seconds,
        'started_at', started_at, 'ended_at', ended_at, 'deleted_at', deleted_at)) from s), '[]'::jsonb),
    'recovered_escapes', coalesce((select jsonb_object_agg(session_id, n) from (
        select i.session_id, count(*) n from public.focus_interruptions i
        where i.user_id = p_user and i.counted and i.recovered and i.deleted_at is null
        group by i.session_id) e), '{}'::jsonb),
    'cofocus_peers', coalesce((select jsonb_object_agg(focus_session_id, n) from (
        select p.focus_session_id, count(o.*) n
        from public.cofocus_participants p
        join public.cofocus_participants o on o.cofocus_session_id = p.cofocus_session_id
          and o.user_id <> p.user_id and o.outcome = 'completed'
        where p.user_id = p_user and p.outcome = 'completed' and p.focus_session_id is not null
        group by p.focus_session_id) c), '{}'::jsonb)
  )
$$;
revoke execute on function public.brain_input(uuid) from public, anon, authenticated;
grant execute on function public.brain_input(uuid) to service_role;
