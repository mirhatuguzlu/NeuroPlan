-- Mesaj push bildirimi (FCM, Aşama 4B, D49).
-- Mesaj eklenince tetikleyici pg_net ile `push_message` Edge Function'ını çağırır. Adres ve paylaşılan
-- sır Supabase Vault'tadır (`push_function_url`, `push_webhook_secret`); yoksa hiçbir şey yapılmaz.
-- Push mesajı asla engellemez: hata yutulur.

create extension if not exists pg_net with schema extensions;

create table public.push_tokens (
  token text primary key check (char_length(token) between 10 and 4096),
  user_id uuid not null references auth.users (id) on delete cascade,
  platform text not null default 'android' check (platform in ('android', 'ios')),
  updated_at timestamptz not null default now()
);
create index push_tokens_user on public.push_tokens (user_id);
-- Politika yok: yalnız RPC'ler ve service role erişir.
alter table public.push_tokens enable row level security;

-- Cihazın FCM kimliği; aynı cihaz başka hesaba geçince kimlik o hesaba taşınır.
create or replace function public.register_push_token(p_token text, p_platform text default 'android')
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if auth.uid() is null or coalesce((select is_anonymous from auth.users where id = auth.uid()), true) then
    raise exception 'guest' using errcode = 'NP001';
  end if;
  insert into public.push_tokens as t (token, user_id, platform)
  values (p_token, auth.uid(), p_platform)
  on conflict (token) do update set user_id = excluded.user_id, platform = excluded.platform, updated_at = now();
end
$$;

create or replace function public.unregister_push_token(p_token text)
returns void
language sql
security definer
set search_path = ''
as $$ delete from public.push_tokens where token = p_token and user_id = (select auth.uid()) $$;

create or replace function public.messages_push()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_url text;
  v_secret text;
begin
  select decrypted_secret into v_url from vault.decrypted_secrets where name = 'push_function_url';
  select decrypted_secret into v_secret from vault.decrypted_secrets where name = 'push_webhook_secret';
  if v_url is null or v_secret is null then
    return new;
  end if;
  perform net.http_post(
    url := v_url,
    headers := jsonb_build_object('Content-Type', 'application/json', 'x-webhook-secret', v_secret),
    body := jsonb_build_object('message_id', new.id)
  );
  return new;
exception when others then
  return new;
end
$$;

create trigger zz_push after insert on public.messages
  for each row execute function public.messages_push();

-- push_message Edge Function'ının girdisi: alıcılar, kimlikleri, dilleri. Sessize alan, engelleyen ve
-- o anda odak oturumunda olan (talimat: odakta mesaj bildirimi susar) alıcı listeye girmez.
create or replace function public.message_push_targets(p_message uuid)
returns table (token text, locale text, sender_name text, conversation_id uuid, sender_id uuid)
language sql
stable
security definer
set search_path = ''
as $$
  select t.token, coalesce(p.locale, 'tr'), coalesce(s.display_name, ''), m.conversation_id, m.user_id
  from public.messages m
  join public.conversation_members r
    on r.conversation_id = m.conversation_id and r.user_id <> m.user_id
   and r.deleted_at is null and not r.muted
  join public.push_tokens t on t.user_id = r.user_id
  left join public.profiles p on p.id = r.user_id
  left join public.social_profiles s on s.user_id = m.user_id
  where m.id = p_message and m.deleted_at is null
    and public.is_friend(m.user_id, r.user_id)
    and public.social_tier(r.user_id) <> 'none'
    and not exists (
      select 1 from public.focus_sessions f
      where f.user_id = r.user_id and f.outcome = 'in_progress' and f.deleted_at is null
        and f.started_at > now() - interval '6 hours')
$$;

revoke execute on function public.register_push_token(text, text) from public, anon;
grant execute on function public.register_push_token(text, text) to authenticated;
revoke execute on function public.unregister_push_token(text) from public, anon;
grant execute on function public.unregister_push_token(text) to authenticated;
revoke execute on function public.messages_push() from public, anon, authenticated;
revoke execute on function public.message_push_targets(uuid) from public, anon, authenticated;
grant execute on function public.message_push_targets(uuid) to service_role;
