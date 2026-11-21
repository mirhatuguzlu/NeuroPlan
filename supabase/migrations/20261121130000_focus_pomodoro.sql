-- D67: planlı Pomodoro (işe özel; null = uygulama varsayılanı). Çalışma ve kısa mola
-- D66'nın focus_block_minutes / focus_break_minutes sütunlarındadır.
alter table public.activities
  add column focus_cycles integer check (focus_cycles between 1 and 24),
  add column focus_long_break_minutes integer check (focus_long_break_minutes between 1 and 60),
  add column focus_long_every integer check (focus_long_every between 2 and 12);
