-- D66: derin çalışma blok planı ve geç kalma payı (işe özel; null = uygulama varsayılanı).
alter table public.activities
  add column focus_block_minutes integer check (focus_block_minutes between 5 and 240),
  add column focus_break_minutes integer check (focus_break_minutes between 1 and 60),
  add column focus_spread boolean,
  add column focus_grace_minutes integer check (focus_grace_minutes between 1 and 120);
