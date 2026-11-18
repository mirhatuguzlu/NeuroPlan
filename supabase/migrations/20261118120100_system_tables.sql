-- Sistem tabloları (docs/DB_SCHEMA.md §2): herkes okur, yalnız migration yazar.
-- Veri: 20261118120200_system_seed.sql (assets/seed/system.json'dan üretilir).

create table public.root_categories (
  key text primary key,
  sort_order smallint not null,
  name_tr text not null,
  name_en text not null,
  description_tr text not null,
  description_en text not null,
  icon text not null,
  color text not null check (color ~ '^#[0-9A-F]{6}$')
);

create table public.brain_regions (
  key text primary key,
  sort_order smallint not null,
  name_tr text not null,
  name_en text not null,
  hemisphere text not null check (hemisphere in ('left', 'right', 'bilateral')),
  mesh_name text not null unique
);

create table public.category_region_weights (
  root_category_key text not null references public.root_categories (key),
  region_key text not null references public.brain_regions (key),
  weight numeric(3, 2) not null,
  evidence_level text not null check (evidence_level in ('strong', 'moderate', 'weak', 'no_source')),
  source_ids text[] not null default '{}',
  source_urls text[] not null default '{}',
  primary key (root_category_key, region_key),
  -- SCIENCE.md §1 ilke 2: kanıt düzeyi ağırlığın tavanıdır.
  check (weight > 0 and weight <= case evidence_level
    when 'strong' then 1.0 when 'moderate' then 0.6 when 'weak' then 0.3 else 0.1 end)
);

do $$
declare t text;
begin
  foreach t in array array['root_categories', 'brain_regions', 'category_region_weights'] loop
    execute format('alter table public.%I enable row level security', t);
    execute format('create policy %I on public.%I for select to anon, authenticated using (true)', t || '_read_all', t);
  end loop;
end
$$;
