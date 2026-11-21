-- D69: molada bitirilen işin kalan saf odağı (dakika); null = normal oluşum.
alter table public.plan_instances
  add column planned_minutes integer check (planned_minutes between 1 and 1440);
