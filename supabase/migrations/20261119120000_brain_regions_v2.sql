-- Aşama 4 (DECISIONS D38): beyin bölgeleri anatomik oldu; mesh adları bölgelerle birebir.
-- İşlevsel alt bölge adı (DLPFC, STS…) ağırlık satırında metin olarak kalır.
-- Yeni veri: 20261119120100_system_seed_v2.sql (assets/seed/system.json'dan üretilir).

alter table public.brain_regions
  add column is_inner boolean not null default false;

alter table public.category_region_weights
  add column detail_tr text not null default '',
  add column detail_en text not null default '';

-- v1 olayları eski bölge anahtarlarına bağlı. Olay kaynağı focus_sessions'tır; istemci v2
-- olaylarını oturumlardan yeniden türetir (ARCHITECTURE §7). Sunucu eşitlemesi henüz yazılmadığı
-- için silinen satır yoktur; bu ifadeler yalnız tutarlılık içindir.
delete from public.brain_snapshots;
delete from public.brain_events where engine_version < 2;
delete from public.category_region_weights;
delete from public.brain_regions;
