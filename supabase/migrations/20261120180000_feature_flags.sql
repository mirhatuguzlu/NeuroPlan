-- Özellik bayrakları (Aşama 6, D58). Bir özelliği yeni sürüm çıkarmadan kapatmak için:
-- Studio → Table editor → feature_flags → satır ekle (key = özellik adı, enabled = false).
-- Satır yoksa uygulamadaki kod varsayılanı (açık) geçer. İstemci yalnız okur; yazma politikası
-- yoktur, yalnız Studio (postgres rolü) ve service role yazar.

create table public.feature_flags (
  key text primary key check (key ~ '^[a-zA-Z][a-zA-Z0-9_]{0,39}$'),
  enabled boolean not null,
  note text check (char_length(note) <= 200),
  updated_at timestamptz not null default now()
);

alter table public.feature_flags enable row level security;

-- Bayraklar gizli değildir: misafir de girişli kullanıcı da okur.
create policy feature_flags_read on public.feature_flags
  for select to anon, authenticated using (true);

grant select on public.feature_flags to anon, authenticated;
revoke insert, update, delete on public.feature_flags from anon, authenticated;
