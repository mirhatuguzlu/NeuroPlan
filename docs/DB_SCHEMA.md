# DB_SCHEMA.md — NöroPlan Veri Modeli

Durum: **Onaylandı, 2026-11-18 (Aşama 1).** Supabase migration'ları (`supabase/migrations`) ve Drift tabloları (`lib/data/local`) bu belgeye göre yazıldı.
Mimari: [ARCHITECTURE.md](ARCHITECTURE.md).

## 0. Temel kurallar
1. **Hiçbir kişiye özel senaryo varsayılmaz.** Saat, tekrar, süre, kategori, varyant, son tarih: hepsi isteğe bağlıdır. Çoğu tabloda zorunlu tek alan başlık ya da addır.
2. Koddaki tek sabit içerik sistem tablolarıdır: kök kategoriler, beyin bölgeleri ve ağırlıklar. Hepsi SCIENCE.md'den seed edilir.
3. Süreler tamsayı **dakika** olarak tutulur. Anlar `timestamptz` olarak (UTC) saklanır. Duvar saati ("13:00") kullanıcının saat dilimine göre yorumlanır.
4. Çok biçimli alanlar (tekrar, zaman kısıtı) `jsonb`'dir. Şemaları aşağıdadır; sunucuda CHECK fonksiyonuyla, istemcide Dart sealed sınıflarıyla doğrulanır.
5. Durum alanları `text` + `CHECK` ile tutulur, Postgres enum tipi kullanılmaz. Böylece yeni değer migration'da kolay eklenir ve Drift'te düz metin olarak kalır.

### Ortak sütunlar (O)
Her kullanıcı tablosunda bulunur. Aşağıdaki tablolarda "O" diye kısaltılır.
| Sütun | Tip | Açıklama |
|---|---|---|
| `id` | uuid PK | İstemci üretir (UUIDv7). Motorun ürettiği satırlarda deterministik UUIDv5 kullanılır. |
| `user_id` | uuid not null → `auth.users` ON DELETE CASCADE | Satırın sahibi. Sunucu `auth.uid()` ile doldurur, istemciden gelen değer yok sayılır. Yerelde tutulmaz. |
| `created_at` | timestamptz not null | |
| `updated_at` | timestamptz not null | Sunucudaki son yazma anı (gösterim/denetim). Çakışma çözümünde kullanılmaz. |
| `deleted_at` | timestamptz null | Yumuşak silme. |
| `version` | bigint not null | Eşitleme sürümü; her yazmada kullanıcı sayacından alınır (ARCHITECTURE §5.1). |
| `field_versions` | jsonb not null default `'{}'` | Sütun → HLC eşlemesi; alan bazlı "son yazan kazanır" bunu kullanır (ARCHITECTURE §5.2). |

**Sistem tabloları** farklıdır: birincil anahtar `key text`'tir, kullanıcı ve eşitleme sütunu yoktur. Herkes okur, kimse yazamaz; değişiklik yalnız migration ile yapılır.

## 1. Genel bakış
```
auth.users 1──1 profiles

SİSTEM   root_categories ──< category_region_weights >── brain_regions

PLAN     root_categories ──< user_categories (parent_id ile sınırsız ağaç)
         user_categories / root_categories ──< activities ──< schedule_rules
         activities ──1 projects
         activities ──1 variant_groups ──< variants ──< activities (variant_id: varyanta özel alt aktivite)
         activities ──< activities (parent_activity_id: alt görev)
         day_overrides (bağımsız gün kuralları)
         schedule_rules / activities ──< plan_instances

ODAK     plan_instances ──< focus_sessions ──< focus_interruptions

BEYİN    focus_sessions ──▶ brain_events ──▶ brain_snapshots

HESAP    entitlements

SOSYAL   friendships · invites · blocks · visibility_settings
         shared_activities ──< shared_activity_participants
         cofocus_sessions ──< cofocus_participants
         conversations ──< conversation_members ; conversations ──< messages ──< reactions
         reports · leaderboard_entries
```

## 2. Sistem tabloları

### 2.1 `root_categories`
| Sütun | Tip | Açıklama |
|---|---|---|
| `key` | text PK | Kalıcı anahtar |
| `sort_order` | smallint | |
| `name_tr`, `name_en` | text | |
| `description_tr`, `description_en` | text | Kapsam açıklaması (bilimsel iddia değil) |
| `icon` | text | Material Symbols adı; UX_RULES §8 kayıt tablosuna eklenir |
| `color` | text | `#RRGGBB` taban renk; temalar yeniden eşleyebilir |

Seed (renkler taslaktır; kontrastları tema aşamasında ölçülür):
| key | TR | EN | ikon | renk |
|---|---|---|---|---|
| `body_movement` | Bedensel Hareket | Physical Movement | `directions_run` | `#FF6B4A` |
| `motor_skill` | Motor Beceri | Motor Skills | `front_hand` | `#FFB347` |
| `music_rhythm` | Müzik ve Ritim | Music and Rhythm | `music_note` | `#F7E04B` |
| `learning_memory` | Öğrenme ve Bellek | Learning and Memory | `menu_book` | `#6BD968` |
| `planning_problem_solving` | Planlama ve Problem Çözme | Planning and Problem Solving | `extension` | `#2EC4B6` |
| `emotional_social` | Duygusal ve Sosyal Zeka | Emotional and Social Intelligence | `handshake` | `#FF7AB6` |
| `attention_contemplation` | Dikkat ve Tefekkür | Attention and Contemplation | `self_improvement` | `#9B8CFF` |
| `creativity_art` | Yaratıcılık ve Sanat | Creativity and Art | `palette` | `#C77DFF` |
| `rest_sleep` | Dinlenme ve Uyku | Rest and Sleep | `bedtime` | `#4EA8DE` |

### 2.2 `brain_regions`
**Aşama 4'te anatomik oldu (DECISIONS D38).** Her satır 3D modeldeki bir düğümdür; mesh adları birebir eşleşir. Kaynaklardaki işlevsel alt bölge (DLPFC, STS…) ağırlık satırında `detail_*` metni olarak kalır.
| Sütun | Tip | Açıklama |
|---|---|---|
| `key` | text PK | |
| `sort_order` | smallint | |
| `name_tr`, `name_en` | text | |
| `hemisphere` | text: `left` · `right` · `bilateral` | Bölgesel yan bilgisi (SCIENCE §1 ilke 3: kişilik miti değil) |
| `mesh_name` | text | 3D modeldeki düğüm adı: `region_<key>` (`tool/brain/regions.json`, docs/BRAIN_MODEL.md §1) |
| `is_inner` | bool default false | Yarı saydam iç yapı (kabuğun içinde çizilir) |

| key | TR | EN | yarımküre | iç yapı |
|---|---|---|---|---|
| `prefrontal_left` | Prefrontal korteks (sol) | Prefrontal cortex (left) | left | — |
| `prefrontal_right` | Prefrontal korteks (sağ) | Prefrontal cortex (right) | right | — |
| `frontal_left` | Frontal lob, motor alanlar (sol) | Frontal lobe, motor areas (left) | left | — |
| `frontal_right` | Frontal lob, motor alanlar (sağ) | Frontal lobe, motor areas (right) | right | — |
| `parietal_left` | Parietal lob (sol) | Parietal lobe (left) | left | — |
| `parietal_right` | Parietal lob (sağ) | Parietal lobe (right) | right | — |
| `temporal_left` | Temporal lob (sol) | Temporal lobe (left) | left | — |
| `temporal_right` | Temporal lob (sağ) | Temporal lobe (right) | right | — |
| `occipital_left` | Oksipital lob (sol) | Occipital lobe (left) | left | — |
| `occipital_right` | Oksipital lob (sağ) | Occipital lobe (right) | right | — |
| `cerebellum` | Beyincik | Cerebellum | bilateral | — |
| `brainstem` | Beyin sapı | Brainstem | bilateral | — |
| `corpus_callosum` | Korpus kallozum | Corpus callosum | bilateral | evet |
| `cingulate` | Singulat korteks | Cingulate cortex | bilateral | evet |
| `insula` | İnsula | Insula | bilateral | evet |
| `striatum` | Striatum | Striatum | bilateral | evet |
| `hippocampus` | Hipokampüs | Hippocampus | bilateral | evet |
| `amygdala` | Amigdala | Amygdala | bilateral | evet |

Beyin sapının ağırlık satırı yoktur: beyin bütün görünsün diye çizilir, büyümez.

### 2.3 `category_region_weights`
| Sütun | Tip | Açıklama |
|---|---|---|
| `root_category_key` | text → root_categories | PK (1/2) |
| `region_key` | text → brain_regions | PK (2/2) |
| `weight` | numeric(3,2) | `0 < weight ≤ tavan(evidence_level)` (CHECK) |
| `evidence_level` | text: `strong` · `moderate` · `weak` · `no_source` | SCIENCE §2 |
| `source_ids` | text[] | `{S2}` gibi SCIENCE §5 kimlikleri |
| `source_urls` | text[] | `https://doi.org/...` |
| `detail_tr`, `detail_en` | text default `''` | Kaynaktaki işlevsel alt bölge (ör. "Dorsolateral prefrontal korteks"); bölge sayfasında gösterilir (D38) |

**Ağırlık kuralı (SCIENCE §1 ilke 2):** tavan kanıt düzeyine göre belirlenir: `strong` 1.0, `moderate` 0.6, `weak` 0.3, `no_source` 0.1. v1'de ağırlık tavana eşittir. Birden çok işlevsel satır aynı anatomik bölgeye düşerse en yüksek düzey alınır, kaynaklar birleşir. Çürütücü bulgu (S14) ayrıca kaynak olarak gösterilir.

**İşlevsel → anatomik eşleme (Aşama 4, D38):**
| İşlevsel (Aşama 1–3) | Anatomik |
|---|---|
| motor_cortex | frontal L+R; S5 (müzik) yalnız `frontal_right` (kaynak sağ presantral girus diyor) |
| dlpfc, vmpfc, frontopolar | prefrontal L+R |
| language_frontal (sol) | prefrontal_left |
| dacc, posterior_cingulate | cingulate |
| posterior_parietal, tpj | parietal L+R |
| intraparietal_sulcus (sol) | parietal_left |
| hmt_v5 | occipital L+R |
| sts | temporal L+R |
| superior_temporal_gyrus (sol) · auditory_cortex (sağ) | temporal_left · temporal_right |
| hippocampus, cerebellum, amygdala, corpus_callosum, insula, striatum | aynı adla |

| Kök kategori | Bölge | Düzey | Ağırlık | Kaynak | İşlevsel alt bölge |
|---|---|---|---|---|---|
| body_movement | hippocampus | strong | 1.0 | S2 | Hipokampüs |
| body_movement | frontal_left | no_source | 0.1 | — | Motor korteks |
| body_movement | frontal_right | no_source | 0.1 | — | Motor korteks |
| body_movement | cerebellum | no_source | 0.1 | — | Beyincik |
| motor_skill | occipital_left | moderate | 0.6 | S3 | Görsel hareket alanı (hMT/V5) |
| motor_skill | occipital_right | moderate | 0.6 | S3 | Görsel hareket alanı (hMT/V5) |
| motor_skill | parietal_left | moderate | 0.6 | S3 | Arka intraparietal sulkus |
| motor_skill | cerebellum | moderate | 0.6 | S4 | Beyincik |
| motor_skill | striatum | moderate | 0.6 | S4 | Striatum |
| music_rhythm | frontal_right | moderate | 0.6 | S5 | Motor korteks |
| music_rhythm | corpus_callosum | moderate | 0.6 | S5 | Korpus kallozum |
| music_rhythm | temporal_right | moderate | 0.6 | S5 | Birincil işitme alanı |
| learning_memory | hippocampus | moderate | 0.6 | S7, S8 | Hipokampüs |
| learning_memory | prefrontal_left | moderate | 0.6 | S7 | Alt ve orta frontal girus |
| learning_memory | temporal_left | moderate | 0.6 | S7 | Üst temporal girus |
| learning_memory | parietal_left | moderate | 0.6 | S8 | Arka parietal korteks |
| learning_memory | parietal_right | moderate | 0.6 | S8 | Arka parietal korteks |
| planning_problem_solving | prefrontal_left | moderate | 0.6 | S9 | Dorsolateral prefrontal korteks |
| planning_problem_solving | prefrontal_right | moderate | 0.6 | S9 | Dorsolateral prefrontal korteks |
| planning_problem_solving | cingulate | moderate | 0.6 | S9 | Dorsal ön singulat korteks |
| planning_problem_solving | parietal_left | moderate | 0.6 | S9 | Arka parietal korteks |
| planning_problem_solving | parietal_right | moderate | 0.6 | S9 | Arka parietal korteks |
| emotional_social | amygdala | moderate | 0.6 | S10, S11 | Amigdala |
| emotional_social | prefrontal_left | moderate | 0.6 | S10 | Ventromedial prefrontal korteks |
| emotional_social | prefrontal_right | moderate | 0.6 | S10 | Ventromedial prefrontal korteks |
| emotional_social | temporal_left | moderate | 0.6 | S12 | Üst temporal sulkus |
| emotional_social | temporal_right | moderate | 0.6 | S12 | Üst temporal sulkus |
| attention_contemplation | hippocampus | weak | 0.3 | S13, S14, S15 | Hipokampüs |
| attention_contemplation | cingulate | weak | 0.3 | S13, S14 | Arka singulat korteks |
| attention_contemplation | parietal_left | weak | 0.3 | S13, S14 | Temporoparietal bileşke |
| attention_contemplation | parietal_right | weak | 0.3 | S13, S14 | Temporoparietal bileşke |
| attention_contemplation | cerebellum | weak | 0.3 | S13, S14 | Beyincik |
| attention_contemplation | insula | weak | 0.3 | S15 | İnsula |
| attention_contemplation | prefrontal_left | weak | 0.3 | S15 | Frontopolar korteks |
| attention_contemplation | prefrontal_right | weak | 0.3 | S15 | Frontopolar korteks |
| creativity_art | prefrontal_left | weak | 0.3 | S16, S17 | Ventromedial prefrontal korteks, Dorsolateral prefrontal korteks |
| creativity_art | prefrontal_right | weak | 0.3 | S16, S17 | Ventromedial prefrontal korteks, Dorsolateral prefrontal korteks |
| creativity_art | cingulate | weak | 0.3 | S16, S17 | Arka singulat korteks, Dorsal ön singulat korteks |
| creativity_art | parietal_left | weak | 0.3 | S16, S17 | Arka parietal korteks |
| creativity_art | parietal_right | weak | 0.3 | S16, S17 | Arka parietal korteks |
| rest_sleep | hippocampus | strong | 1.0 | S18, S19 | Hipokampüs |

Yaratıcılık satırları kaynağa sadık kalmak için yalnız üç ağın **frontal ve parietal** merkezlerini içerir: varsayılan mod ağı için vmPFC ve arka singulat, salience için dACC, yürütücü ağ için DLPFC ve arka parietal. İnsula bu yüzden yaratıcılığa bağlanmadı.
Not: Hemisfere ayrılan bölgelerde normalleştirme bölge başınadır. Örneğin Planlama'da beş satır (prefrontal L/R, singulat, parietal L/R) eşit pay alır.

## 3. Plan tabloları

### 3.1 `profiles`: kullanıcı başına bir satır
O sütunları vardır; tek istisna `id = user_id = auth.users.id` olmasıdır. Yerelde tek satır tutulur.
| Sütun | Tip | Açıklama |
|---|---|---|
| `display_name` | text null | |
| `locale` | text null: `tr` · `en` | null = cihaz dili |
| `theme` | text null | Tema anahtarı; null = varsayılan |
| `theme_mode` | text: `system` · `light` · `dark` | varsayılan `system` |
| `timezone` | text not null | IANA adı, ilk açılışta cihazdan alınır |
| `sleep_goal_minutes` | int null | Uyku hedefi; sihirbaz önerisi ve istatistik için |
| `birth_year` | smallint null | AUTH-2: 13 yaş sınırı ve 13–17 korumaları için. Tam doğum tarihi tutulmaz. |
| `onboarding_completed_at` | timestamptz null | null = ilk kurulum bitmedi. Sihirbaz taslağı yalnız cihazda tutulur. |
| `location_lat`, `location_lon` | numeric(4,1) null | Gün doğumu ve namaz vakti için. 0,1°'ye yuvarlanır (≈ 11 km), gizlilik içindir. |
| `location_label` | text null | Kullanıcının yazdığı yer adı |
| `prayer_method` | text null | null = namaz vakitleri kapalı. Hesap yöntemi anahtarı (ör. `turkiye` = Diyanet; liste `neuroplan_core` `prayerMethods`). |
| `prayer_madhab` | text null: `shafi` · `hanafi` | İkindi vakti hesabı için |
| `min_chunk_minutes`, `chunk_buffer_minutes`, `daily_focus_cap_minutes` | int null | SLOT-4 varsayılanları; null = motor varsayılanı |
| `haptics_enabled` | bool default true | UX_RULES §6 |

### 3.2 `user_categories`: kullanıcının kategori ağacı
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `parent_id` | uuid null → user_categories | null = doğrudan kök kategorinin altında |
| `root_category_key` | text not null → root_categories | Her düğümde tutulur. Çocuğun kökü ebeveyninkiyle aynı olmalıdır (tetikleyici). |
| `name` | text not null | |
| `color`, `icon` | text null | null = üst düğümden ya da kökten miras |
| `requires_focus` | bool null | null = miras; en üstte null = hayır |
| `default_focus_mode` | text null: `free` · `pomodoro` · `deep` | null = miras |
| `sort_order` | int | |

- Döngü yasaktır; hem tetikleyici hem istemci kontrol eder. Derinlik sınırı yoktur.
- Taşıma (CAT-4): alt ağacın `root_category_key` alanı güncellenir. Geçmiş oturumlar kendi kopyalarını tuttuğu için değişmez (§4.1).

### 3.3 `activities`: kullanıcının tanımladığı her şey
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `kind` | text: `routine` · `one_off` · `task` · `project` · `free_time` · `travel_prep` | Sihirbazın ve listelerin etiketidir. **Motor davranışı kurallardan gelir, `kind`'dan değil.** Tek istisna `free_time`: planlamaya kapalı bloktur. |
| `title` | text not null | |
| `notes` | text null | |
| `category_id` | uuid null → user_categories | |
| `root_category_key` | text null → root_categories | `category_id` varsa ondan türetilir (tetikleyici). Doğrudan kök bağlantı da olabilir. **İkisi de boş olabilir** (ör. yol); o zaman beyne katkı vermez. |
| `parent_activity_id` | uuid null → activities | Alt aktivite (proje alt görevi) |
| `variant_id` | uuid null → variants | Yalnız o varyant seçildiğinde var olan alt aktivite |
| `estimated_minutes` | int null | |
| `priority` | smallint null: 1–3 | null = normal |
| `requires_focus` | bool null | null = kategoriden miras |
| `focus_mode` | text null: `free` · `pomodoro` · `deep` | null = kategoriden miras |
| `sort_order` | int | |

Kuralı olmayan aktivite **tarihsiz bir yapılacak** olarak kalır (gelen kutusu).

### 3.4 `schedule_rules`: bir aktivitenin ne zaman olacağı
Bir aktivitenin birden çok kuralı olabilir (ör. "pazartesi 13:00, çarşamba 15:00").
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `activity_id` | uuid not null → activities | |
| `recurrence` | jsonb not null | §3.4.1 |
| `timing` | jsonb not null default `'{}'` | §3.4.2; boş = saat yok |
| `duration_min_minutes`, `duration_max_minutes` | int null | İkisi eşitse sabit, farklıysa aralık, ikisi de null ise süre yok (varsa `estimated_minutes` kullanılır). |
| `flexibility` | text: `fixed` · `shiftable` · `optional` | **kesin:** motor kımıldatmaz ve "sadece zorunlular" günlerinde de kalır. **kaydırılabilir:** motor kısıtlar içinde taşır. **isteğe bağlı:** yer yoksa düşürülür. |
| `valid_from`, `valid_until` | date null | Geçerlilik aralığı |
| `exception_dates` | date[] default `'{}'` | Bu tarihlerde oluşum yok (RFC 5545 EXDATE). Tek oluşumu başka zamana taşımak `plan_instances` ile yapılır. |

#### 3.4.1 `recurrence` (jsonb)
| type | Alanlar | Örnek | Ne için |
|---|---|---|---|
| `once` | `date` | `{"type":"once","date":"2026-11-26"}` | Tek seferlik |
| `rrule` | `dtstart`, `rrule` | `{"type":"rrule","dtstart":"2026-11-23","rrule":"FREQ=WEEKLY;BYDAY=MO"}` | Günlük; haftanın seçili günleri; her N günde (`FREQ=DAILY;INTERVAL=N`); ayın N. haftası (`FREQ=MONTHLY;BYDAY=2TU`, `-1FR`); ayın günü; iki haftada bir (`INTERVAL=2`) |
| `cycle` | `anchor`, `length_days`, `on_days` | `{"type":"cycle","anchor":"2026-11-23","length_days":21,"on_days":[0,1,2,3,4,5,6,7,8,9,10,11,12,13]}` | Dönüşümlü desenler: "2 hafta açık 1 hafta kapalı", "4 gün çalış 4 gün izin", A/B haftaları. Bunlar tek RRULE ile yazılamaz. |
| `dates` | `dates` | `{"type":"dates","dates":["2026-12-01","2026-12-09"]}` | Elle seçilmiş tarih listesi |
| `per_period` | `count`, `unit`: `day` · `week` · `month` | `{"type":"per_period","count":3,"unit":"week"}` | Gün ve saat verilmeden "haftada 3 kez" |
| `follow` | — | `{"type":"follow"}` | `timing` içindeki çapa aktivitelerin **hepsi** o gün oluşursa oluşur (yol, "yemekten sonra") |

**RRULE kararı:** Değerlendirildi ve kullanılıyor. Standarttır, takvim içe/dışa aktarımına kapı açar ve saf Dart paketi vardır. Desteklenen alt küme: `FREQ` (DAILY, WEEKLY, MONTHLY, YEARLY), `INTERVAL`, `BYDAY` (aylıkta sırayla), `BYMONTHDAY`, `BYMONTH`, `BYSETPOS`, `COUNT`, `UNTIL`. Saat bileşenleri (`BYHOUR` vb.) kullanılmaz; saat `timing`'de tutulur. Dönüşümlü vardiyalar tek RRULE ile yazılamadığı için yanına `cycle` eklendi.

#### 3.4.2 `timing` (jsonb): zaman kısıtları
```
timing  = {"start": [Kısıt, ...], "end": [Kısıt, ...]}       (ikisi de isteğe bağlı)
Kısıt   = {"op": "at" | "not_before" | "not_after", "ref": Ref, "offset_minutes": int = 0}
Ref     = {"clock": "HH:MM", "day_offset": int = 0}
        | {"astro": "sunrise" | "sunset" | "fajr" | "dhuhr" | "asr" | "maghrib" | "isha", "day_offset": int = 0}
        | {"activity_id": uuid, "edge": "start" | "end"}
```
Arayüzdeki beş zaman türü bu dilbilgisinin hazır kalıplarıdır:
| Arayüzdeki tür | `timing` |
|---|---|
| Saat yok ("bugün bir ara") | `{}` |
| Sabit saat 13:00 | `{"start":[{"op":"at","ref":{"clock":"13:00"}}]}` |
| Pencere 14:00–18:00 arası bir yerde | `{"start":[{"op":"not_before","ref":{"clock":"14:00"}}],"end":[{"op":"not_after","ref":{"clock":"18:00"}}]}` |
| Göreli: X bitince | `{"start":[{"op":"at","ref":{"activity_id":"X","edge":"end"}}]}` |
| Göreli: X'ten 30 dk önce | `{"end":[{"op":"at","ref":{"activity_id":"X","edge":"start"},"offset_minutes":-30}]}` |
| Astronomik: gün doğumundan 40 dk önce | `{"start":[{"op":"at","ref":{"astro":"sunrise"},"offset_minutes":-40}]}` |

Türler birleştirilebilir, ör. "yemekten sonra ama 22:00'den önce".

**Çözüm kuralları:**
- Duvar saati, kullanıcının saat diliminde ve oluşum tarihine göre yorumlanır. Yaz saati boşluğuna düşen saat ileri kaydırılır; tekrar eden saatte ilki alınır.
- `day_offset` gece yarısını aşan kısıtlar içindir (ör. "en geç 00:00" = ertesi günün 00:00'ı).
- Çapa aktivite o gün oluşmazsa: `follow` kuralında oluşum da olmaz. Diğer tekrar türlerinde o kısıt düşer ve oluşum saatsiz kalır.
- Göreli bağımlılıklarda döngü (A → B → A) kayıt anında reddedilir.
- Astronomik çapa için profilde konum gerekir. Namaz vakitleri yalnız `prayer_method` doluysa seçilebilir.
- Başlangıç aralıklı, bitiş kesinse (ör. "en geç 00:00 yat, gün doğumundan 40 dk önce kalk"): süre varsa başlangıç = bitiş − süre olur ve kısıta kırpılır. Süre yoksa izin verilen en geç an alınır.

### 3.5 `variant_groups` ve `variants`
**`variant_groups`**: aktivite başına en fazla bir grup.
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `activity_id` | uuid not null → activities | Silinmemiş satırlar arasında tekil |
| `name` | text null | Kullanıcının yazdığı ad (ör. "Maç durumu") |
| `applies_on` | jsonb null | `recurrence` biçimindedir; null = aktivitenin her oluşumu. Varyant hiçbir güne zorunlu değildir. |
| `default_variant_id` | uuid null → variants | Seçim yapılmazsa uygulanır. Null ise aktivite olduğu gibi oluşur. |

**`variants`**
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `group_id` | uuid not null → variant_groups | |
| `name` | text not null | |
| `sort_order` | int | |
| `timing` | jsonb null | null = kuraldaki zaman |
| `duration_min_minutes`, `duration_max_minutes` | int null | null = kuraldaki süre |
| `cancels_occurrence` | bool default false | Bu varyant seçilirse aktivite o gün olmaz; varyanta özel alt aktiviteler yine olabilir. |

- Varyanta özel alt aktiviteler `activities.variant_id` ile bağlanır; kuralları genelde `follow` olur.
- **Seçim:** o günün `plan_instances.variant_id` alanında tutulur. Seçim yoksa `default_variant_id` uygulanır; o da yoksa aktivite olduğu gibi oluşur.

### 3.6 `projects`: esnek yerleşim ayarları
`activities` ile birebir bağlıdır. "Son tarihli görev" de bu tabloyu kullanır: sihirbaz tek parça önerir (`max_chunk_minutes = total_minutes`).
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `activity_id` | uuid not null unique → activities | |
| `total_minutes` | int null | null = bilinmiyor; yalnız elle bölme yapılır |
| `deadline_at` | timestamptz null | |
| `split_mode` | text: `auto` · `manual` | varsayılan `auto` (SLOT-3: otomatik öneri, kullanıcı onaylar) |
| `min_chunk_minutes`, `max_chunk_minutes` | int null | null = profil varsayılanı |
| `daily_cap_minutes` | int null | |
| `preferred_windows` | jsonb null | `[{"days":["MO","TU"],"from":"09:00","to":"12:00"}]`; `days` yoksa her gün |
| `safety_margin_minutes` | int null | Son tarihten önce boş bırakılacak pay |

İlerleme saklanmaz; `done` durumdaki parçalardan ve bağlı odak oturumlarından hesaplanır.

### 3.7 `day_overrides`: gün kuralları
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `date` | date null | |
| `recurrence` | jsonb null | `date` ve `recurrence`'tan **tam olarak biri** dolu olur (CHECK). |
| `valid_from`, `valid_until` | date null | |
| `keep` | text: `all` · `fixed_only` · `none` | O gün başlayan oluşumlardan hangileri kalır |
| `auto_placement` | bool default false | Proje ya da görev parçaları o güne yerleşebilir mi |
| `label` | text null | Kullanıcının verdiği ad ("Tatil", "Dinlenme günü") |

Hazır kalıplar:
| Kalıp | keep | auto_placement |
|---|---|---|
| Plansız gün (PRODUCT §5.2): otomatik yerleştirme yok, boş zaman hesaplanmaz | `all` | false |
| Bugün sadece zorunlular | `fixed_only` | false |
| Tamamen serbest / tatil | `fixed_only` (önerilen) ya da `none` | false |

Aynı güne birden çok kayıt düşerse en kısıtlayıcı olan kazanır (`none` > `fixed_only` > `all`; `auto_placement` için `false`). Bu kural deterministiktir; iki cihaz aynı gün için ayrı kayıt oluştursa da sonuç değişmez.

### 3.8 `plan_instances`: belli bir tarihteki somut oluşumlar
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `activity_id` | uuid not null → activities | |
| `rule_id` | uuid null → schedule_rules | null = elle eklenen ya da proje parçası |
| `occurrence_date` | date not null | Oluşumun başladığı yerel gün (gece yarısını aşsa da) |
| `start_at`, `end_at` | timestamptz null | null = saatsiz ("bugün bir ara") |
| `status` | text: `planned` · `done` · `skipped` · `moved` · `failed` | **done:** yapıldı. **skipped:** kullanıcı atladı. **moved:** başka güne taşındı (yenisi `moved_from_id` taşır). **failed:** yapılamadı (kullanıcı işaretler ya da bağlı odak oturumu bozuldu). |
| `source` | text: `rule` · `auto` · `manual` | Kuraldan, otomatik yerleştirmeden (kullanıcı onayladı) ya da elle |
| `variant_id` | uuid null → variants | O gün seçilen varyant |
| `parent_instance_id` | uuid null → plan_instances | Varyant alt aktivitesinin ya da `follow` oluşumunun üst oluşumu |
| `moved_from_id` | uuid null → plan_instances | |
| `is_manual` | bool default false | Kullanıcı saati ya da süreyi değiştirdi; motor bu satırı yeniden yazmaz |
| `engine_version` | int null | Motorun ürettiği satırlarda |

**Kimlik:** kural oluşumunun kimliği `v5(rule_id, occurrence_date)`, `per_period` oluşumunun kimliği `v5(rule_id, dönem_başı, sıra)` olur. Böylece aynı oluşum iki cihazda ayrı ayrı üretilse de tek satır kalır. Kullanıcının onayladığı proje parçaları UUIDv7 alır. Motor yalnız `status = planned` ve `is_manual = false` olan satırları yeniden yazar.

## 4. Odak ve beyin tabloları

### 4.1 `focus_sessions`
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `plan_instance_id` | uuid null → plan_instances | null = plansız başlatıldı |
| `activity_id` | uuid null → activities | Plansız ama bir işe bağlı oturum |
| `category_id`, `root_category_key` | uuid null, text null | **Oturum anındaki kopya** (CAT-4: kategori sonradan taşınsa da geçmiş değişmez). Beyin bunu kullanır. |
| `mode` | text: `free` · `pomodoro` · `deep` | Beyne yalnız sayaçlı oturumlar katkı verir (§9) |
| `settings` | jsonb null | Pomodoro `{"work":25,"break":5,"long_break":15,"long_every":4}`, derin çalışma `{"target":90}` |
| `planned_minutes` | int null | |
| `started_at` | timestamptz not null | |
| `ended_at` | timestamptz null | null = sürüyor |
| `focused_seconds` | int not null default 0 | Molalar ve kaçışlar hariç gerçek odak süresi |
| `segments` | jsonb not null default `'[]'` | `[{"kind":"work"|"break","start":ISO,"end":ISO|null}]`; açık segmentin `end`'i null (D32). Kesinti ve arama odak segmentini böler; segmentler arası boşluk duraklatmadır. Pomodoro serisi ve en uzun kesintisiz süre (FOCUS-5) buradan hesaplanır. |
| `outcome` | text: `in_progress` · `completed` · `broken` | `broken`: kaçış kuralı (FOCUS-2) |
| `focus_rating`, `fatigue_rating` | smallint null: 1–5 | Kullanıcı bildirir |
| `note` | text null | |

Oturum `completed` ya da `broken` olduktan sonra yalnız puanlar ve not değişebilir. Sunucu tetikleyicisi bunu zorlar, çünkü beyin bu kayıttan türetilir.

### 4.2 `focus_interruptions`: yalnız eklenir
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `session_id` | uuid not null → focus_sessions | |
| `left_at` | timestamptz not null | |
| `away_ms` | int not null | Dışarıda kalma süresi |
| `reason` | text: `app_left` · `notification_shade` · `screen_off` · `phone_call` · `alarm` · `other` | |
| `recovered` | bool not null | 10 saniye içinde dönüldü mü |
| `counted` | bool not null | Kaçış sayıldı mı (arama ve alarm istisnası, FOCUS-6) |

### 4.3 `brain_events`: yalnız eklenir
O sütunları vardır; satır güncellenmez, `updated_at = created_at` olur.
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `type` | text: `neuron_gain` · `connection_gain` · `fade` · `penalty` | `fade` şemada durur ama v2 üretmez: sönme katlamada hesaplanır (D39) |
| `region_key` | text null → brain_regions | |
| `region_b_key` | text null → brain_regions | Bağlantının ikinci ucu |
| `amount` | int not null | Binde bir birim (tamsayı, determinizm için) |
| `occurred_at` | timestamptz not null | |
| `session_id` | uuid null → focus_sessions | |
| `dedupe_key` | text not null | `UNIQUE(user_id, dedupe_key)`. Biçimler docs/BRAIN_MODEL.md §2.1'de (ör. `gain:<oturum>:hippocampus:v2`). İki cihaz ya da sunucu aynı olayı üretirse tek satır kalır. |
| `engine_version` | int not null | |

| type | Ne zaman |
|---|---|
| `neuron_gain`, `connection_gain` | Tamamlanan oturumdan ve son 7 günün oturumlarından türetilir (kurallar: docs/BRAIN_MODEL.md §2) |
| `fade` | Üretilmez (v2, D39). Parlaklık katlamada son kazançtan geçen süreyle hesaplanır; nöron silinmez (BRAIN-3). |
| `penalty` | Bozulan oturumdan türetilir. Miktar: bozulmadan önceki odak dakikası × 1000, kazançla aynı dağıtım. O kadar nöronu **söndürür, silmez**; sonraki kazançlar yeniden yakar. Seri ödülünü sıfırlar (FOCUS-5). Önceki "düşürmez" kuralının yerine geçti (D31). |

### 4.4 `brain_snapshots`: önbellek
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `engine_version` | int not null | `UNIQUE(user_id, engine_version)` |
| `as_of` | timestamptz not null | |
| `events_hash` | text not null | Katlanan olay kümesinin özeti; uyuşmazsa yeniden hesaplanır |
| `state` | jsonb not null | `{"regions":{"hippocampus":{"neurons":12345,"lit":12000,"dimmed":345,"brightness":800,"last_active":"2026-11-18T09:00:00.000Z","by_root":{"rest_sleep":12345}}},"connections":[{"a":"cingulate","b":"prefrontal_left","strength":340}]}` (binde-birim; `brightness` ‰) |

Yerelde istemci hesaplar, eşitlenmez. Sunucuda Edge Function hesaplar (sıralama ve arkadaşla beyin karşılaştırma); istemci yalnız okur.

### 4.5 `entitlements` (Aşama 6'da doldurulacak)
| Sütun | Tip | Açıklama |
|---|---|---|
| O | | |
| `plan` | text: `free` · `premium` | |
| `status` | text: `active` · `grace` · `expired` · `revoked` | |
| `store` | text null: `play` · `app_store` · `promo` | |
| `product_id` | text null | |
| `purchase_token_hash` | text null | Ham token tutulmaz |
| `expires_at` | timestamptz null | |

Yalnız sunucu yazar (satın almayı doğrulayan Edge Function); istemci okur. Satır yoksa plan `free` kabul edilir.

## 5. Sosyal tablolar (Aşama 4B'de kullanılacak)
Ortak kurallar:
- Sosyal tablolar çevrimiçi çalışır ve outbox'a girmez.
- Misafir (anonim) kullanıcı sosyal tablolara yazamaz (RLS: `is_anonymous` false olmalı).
- Her sosyal okuma ve yazmada engel (`blocks`) kontrol edilir.
- `user_id` her tabloda satırın **sahibidir**, yani o satırı değiştirebilen kişidir.

| Tablo | Sütunlar (O hariç) | Kurallar |
|---|---|---|
| `friendships` | `friend_id` uuid; `status`: `pending` · `accepted`; `is_partner` bool; `partner_requested_by` uuid null | `user_id` = isteği gönderen. Çift tekildir (`least/greatest`). Partner iki taraf onaylayınca olur; kullanıcı başına en fazla bir partner (tetikleyici). **Engel burada değil `blocks`'tadır:** engel tek taraflıdır ve arkadaşlık silinse de sürmelidir. Engellemek arkadaşlığı siler ve `blocks` satırı ekler (tek RPC). |
| `invites` | `code` text unique (sunucu üretir, 10 karakter, birbirine benzemeyen harfler); `kind`: `friend` · `partner`; `expires_at` (varsayılan 7 gün); `max_uses` (1); `use_count`; `revoked_at` | Kod yalnız `redeem_invite(code)` RPC'siyle kullanılır. RPC süreyi, kullanım sayısını ve engeli kontrol eder, sonra `friendships`'i `accepted` olarak yazar. |
| `blocks` | `blocked_user_id` uuid | `UNIQUE(user_id, blocked_user_id)` |
| `visibility_settings` | `viewer_id` uuid null; `audience` null: `friends` · `partner`; `category_id` / `root_category_key` null; `level`: `full` · `title_time` · `busy` · `hidden` | `viewer_id` ya da `audience`'tan biri dolu olur. Çözüm sırası (en özel kazanır): kişi + kategori > kişi > kitle + kategori > kitle > **varsayılan `hidden`** (SOCIAL-2). Alt kategori en yakın ataya düşer. |
| `shared_activities` | `title`; `notes` null; `start_at` / `end_at` null; `root_category_key` null; `status`: `proposed` · `confirmed` · `cancelled` | `user_id` = düzenleyen |
| `shared_activity_participants` | `shared_activity_id`; `status`: `invited` · `accepted` · `declined` | `user_id` = katılımcı; `UNIQUE(shared_activity_id, user_id)`. Kabul eden katılımcının plan motoru etkinliği sabit blok olarak görür. |
| `cofocus_sessions` | `mode`; `settings` jsonb; `planned_start_at` / `started_at` / `ended_at` null; `voice_enabled` bool; `room_id` text null (ses sağlayıcısının oda kimliği; sağlayıcı açık karar); `status`: `scheduled` · `live` · `ended` | `user_id` = başlatan. **Ses kaydedilmez, sesle ilgili veri tutulmaz** (SOCIAL-3). |
| `cofocus_participants` | `cofocus_session_id`; `joined_at` / `left_at` null; `focus_session_id` null → kişinin kendi `focus_sessions` satırı | `user_id` = katılımcı. Beyne katkı herkesin kendi oturumundan gelir. |
| `conversations` | `kind`: `direct` (grup açık konu, SOCIAL-6); `direct_key` text unique null (iki kullanıcı kimliğinin sıralı birleşimi) | Bir çift için tek birebir sohbet |
| `conversation_members` | `conversation_id`; `last_read_at` null; `muted` bool | `user_id` = üye; `UNIQUE(conversation_id, user_id)` |
| `messages` | `conversation_id`; `body` text (1–2000 karakter); `reply_to_id` null; `edited_at` null | `user_id` = gönderen. Yalnız üyeler okur, gönderen yalnız kendi mesajını düzenler ya da siler. Engel varsa yazma reddedilir. |
| `reactions` | `message_id`; `emoji` text (küçük sabit küme, CHECK) | `UNIQUE(message_id, user_id, emoji)` |
| `reports` | `reported_user_id` null (hesap silinirse null olur, kayıt moderasyon için kalır); `target_type`: `user` · `message` · `shared_activity` · `cofocus_session`; `target_id` null; `reason`: `spam` · `harassment` · `inappropriate` · `child_safety` · `other`; `details` null; `status`: `open` · `reviewing` · `resolved` | Şikâyet eden ekler ve kendi kaydını okur. `status`'ü yalnız moderatör (service role) değiştirir. |
| `leaderboard_entries` | `period`: `week` · `month`; `period_start` date; `score` int; `engine_version`; `computed_at` | `UNIQUE(user_id, period, period_start)`. Yalnız sunucu yazar (`focus_sessions`'tan yeniden hesap, ARCHITECTURE §7). Yalnız kabul edilmiş arkadaşlar okur (SOCIAL-7). |

**Görünürlük veritabanında uygulanır:** Arkadaş, başkasının plan tablolarını doğrudan okuyamaz; o tablolarda RLS yalnız sahibe izin verir. Paylaşılan görünüm `friend_calendar(friend_id, from, to)` fonksiyonundan gelir (`security definer`). Fonksiyon görünürlük düzeyini satır satır uygular:
- `busy`: yalnız başlangıç ve bitiş
- `title_time`: + başlık
- `full`: + kategori ve not
- `hidden`: hiç görünmez

Ortak boş zaman fonksiyonu (SOCIAL-5) her zaman `busy` düzeyini kullanır. İstemci bu kuralları atlayamaz.

## 6. Güvenlik

### 6.1 RLS
| Tablo grubu | Politika |
|---|---|
| Kullanıcı tabloları | SELECT, INSERT, UPDATE: `using (user_id = (select auth.uid()))` ve aynı `with check`. **DELETE politikası yok:** silme yumuşaktır, kalıcı silme yalnız service role ile yapılır. |
| Sistem tabloları | `for select to anon, authenticated using (true)`; yazma politikası yok |
| Sunucunun yazdığı tablolar (`entitlements`, `leaderboard_entries`, sunucu `brain_snapshots`) | Yalnız SELECT politikası |
| Sosyal tablolar | Yardımcı fonksiyonlar: `is_friend(a, b)`, `is_blocked(a, b)`, `is_member(conversation)` (`security definer`, `set search_path = ''`, `stable`). Yazma politikalarında `(auth.jwt()->>'is_anonymous')::boolean is not true`. **Bu yardımcılar REST'ten çağrılamaz** (`EXECUTE` geri alındı). Politikalarda yalnız çağıranın kendi ilişkisini söyleyenler kullanılır: `is_my_friend(other)`, `is_member`, `is_*_party`. Böylece kimse iki yabancının arkadaşlığını sorgulayamaz. |

- `user_id`, `version`, `created_at`, `updated_at` ve `field_versions` istemciden gelse de tetikleyici bunları ezer.
- Doğrulama sunucuda da yapılır: CHECK kısıtları ve jsonb doğrulama fonksiyonları (`is_valid_recurrence`, `is_valid_timing`).
- RLS performansı: `auth.uid()` `(select …)` içinde çağrılır (satır başına değil, sorgu başına bir kez). Her kullanıcı tablosunda `(user_id, version)` indeksi bulunur.

### 6.2 Kimlik doğrulama
- **Google:** Android'de Credential Manager → `signInWithIdToken`.
- **E-posta girişi yok** (proje sahibinin kararı, DECISIONS D17).
- **Misafir:** Supabase anonim girişi. Hesaba geçiş `linkIdentity` ile yapılır ve `user_id` aynı kalır (ARCHITECTURE §5.4). Kötüye kullanıma karşı Supabase'te CAPTCHA ve oran sınırı açılır.
- Hem kayıtta hem misafir başlangıcında yaş beyanı alınır; 13 yaş altı devam edemez. Profilde yalnız doğum yılı tutulur.

### 6.3 Hesap silme (AUTH-3, Play Store şartı)
1. Uygulama içinde "Hesabı sil" → onay diyaloğu (UX §3) → `delete_account` Edge Function'ı (service role).
2. Fonksiyon auth kullanıcısını siler. Tüm kullanıcı tabloları `ON DELETE CASCADE` ile **kalıcı** olarak silinir; karşı tarafların sohbetlerindeki mesajları da buna dahildir. Tek istisna `reports.reported_user_id` alanıdır: `SET NULL` olur, moderasyon kaydı kalır ama kişiyi göstermez.
3. İstemci yerel veritabanını siler.
4. Yayın öncesi: uygulaması kurulu olmayanlar için web'den silme isteği sayfası gerekir (Play Store).

Misafir de aynı akışı kullanır; anonim kullanıcı silinir.

### 6.4 Veri dışa aktarma
- `export_data` Edge Function'ı kullanıcının tüm satırlarını tek JSON olarak döndürür. Tablo listesi `information_schema`'dan, yani `public` şemasında `user_id` sütunu olan tablolardan okunur. Yeni tablo eklendiğinde dışa aktarmaya kendiliğinden girer.
- Çevrimdışıyken aynı biçimde yerel veritabanından (yalnız eşitlenen tablolar) üretilir.

## 7. Eşitleme altyapısı
**Sunucu:**
- `sync_counters(user_id PK, value bigint)`
- Her kullanıcı tablosunda `BEFORE INSERT OR UPDATE` tetikleyicisi. Service role dışında `user_id = auth.uid()` yapar; `version`'u sayaçtan alır, `updated_at = now()` yazar ve `field_versions`'ı birleştirir.
- RPC'ler: `sync_push(changes jsonb)`, `sync_pull(cursor bigint)`.

**Outbox ile eşitlenen tablolar:** `profiles`, `user_categories`, `activities`, `schedule_rules`, `variant_groups`, `variants`, `projects`, `day_overrides`, `plan_instances`, `focus_sessions`, `focus_interruptions`, `brain_events`. Eşitlenmeyenler için ARCHITECTURE §5.5.

**Yerel (Drift):**
- Eşitlenen tabloların aynısı (`user_id` ve `version` hariç, `field_versions` dahil)
- Sistem tabloları (seed'den)
- Yerel `brain_snapshots`
- `sync_outbox(seq INTEGER PK autoincrement, table_name, row_id, patch TEXT (yalnız değişen alanlar, JSON), hlc TEXT, created_at, attempts, last_error, dead bool)`
- `sync_state(key PK, value)`: imleç, cihaz kimliği, son HLC, son kullanıcı kimliği (hesap değişimini algılamak için)

Yama örneği:
```json
{"table": "activities", "id": "0193a5b2-…", "hlc": "001763481234567-0003-a1b2", "patch": {"title": "Koşu", "deleted_at": null}}
```

## 8. Senaryo testi
Örneklerde kimlikler okunabilirlik için kısaltıldı. Gösterilmeyen sütunlar varsayılan değerdedir. Tarihler 2026'dır; 18 Kasım bir çarşambadır.

### S1: Her gün gün doğumundan 40 dk önce kalkan, gece en geç 00:00'da yatan biri
```yaml
profiles: {timezone: Europe/Istanbul, location_lat: 41.0, location_lon: 29.0, sleep_goal_minutes: 450}
activities:
  - {id: UYKU, kind: routine, title: "Uyku", root_category_key: rest_sleep}
schedule_rules:
  - activity_id: UYKU
    recurrence: {type: rrule, dtstart: "2026-11-18", rrule: "FREQ=DAILY"}
    timing:
      start: [{op: not_after, ref: {clock: "00:00", day_offset: 1}}]
      end:   [{op: at, ref: {astro: sunrise, day_offset: 1}, offset_minutes: -40}]
    duration_min_minutes: 450   # sihirbaz profildeki uyku hedefinden önerir; isteğe bağlı
    duration_max_minutes: 450
    flexibility: fixed
```
- Örneğin ertesi gün gün doğumu 07:16 ise uyanış 06:36 olur. Süre 7,5 saat olduğu için yatış 23:06'dır; bu "en geç 00:00" kısıtına uyar.
- Süre girilmemişse motor en geç izinli anı (00:00) alır.
- Ayrı bir "Kalkış" aktivitesi gerekmez; uyanış uykunun bitişidir. İsteyen aynı astronomik kısıtla süresiz bir "Kalkış" anı da ekleyebilir.
- **Modele etkisi:** kısıtların hem başlangıç hem bitiş tarafı olabilmesi ve `day_offset` bu senaryo için eklendi.

### S2: Pazartesi 12:00'de bir yerden çıkıp 13:00'teki derse yetişen biri (aradaki 1 saat yol)
```yaml
user_categories: [{id: OKUL, root_category_key: learning_memory, name: "Okul"}]
activities:
  - {id: DERS, kind: routine, title: "Ders", category_id: OKUL}
  - {id: YOL,  kind: travel_prep, title: "Yol"}           # kategorisi yok → beyne katkı vermez
schedule_rules:
  - activity_id: DERS
    recurrence: {type: rrule, dtstart: "2026-11-23", rrule: "FREQ=WEEKLY;BYDAY=MO"}
    timing: {start: [{op: at, ref: {clock: "13:00"}}]}
    duration_min_minutes: 90
    duration_max_minutes: 90
    flexibility: fixed
  - activity_id: YOL
    recurrence: {type: follow}
    timing:
      start: [{op: at, ref: {clock: "12:00"}}]
      end:   [{op: at, ref: {activity_id: DERS, edge: start}}]
    flexibility: fixed
```
- Sonuç: her pazartesi 12:00–13:00 yol, 13:00–14:30 ders.
- Ders bir pazartesi iptal edilirse (`exception_dates`) yol da oluşmaz (`follow`).
- Kullanıcı çıkış saatini değil de yol süresini biliyorsa `start` yerine `duration 60` girer.
- Çıktığı yer de bir aktiviteyse (ör. 12:00'de biten "İş") başlangıç kısıtı `{activity_id: IS, edge: end}` olur.

### S3: İki haftada bir değişen günlerde nöbet tutan biri
```yaml
activities:
  - {id: NOBET, kind: routine, title: "<kullanıcının yazdığı ad>"}   # "Nöbet" kelimesi kodda yok
schedule_rules:
  - activity_id: NOBET
    recurrence: {type: cycle, anchor: "2026-11-23", length_days: 14, on_days: [0, 3, 8, 11, 13]}
    timing: {start: [{op: at, ref: {clock: "08:00"}}]}
    duration_min_minutes: 1440
    duration_max_minutes: 1440
    flexibility: fixed
```
- A haftası pazartesi + perşembe, B haftası salı + cuma + pazar.
- Gece yarısını aşan oluşumun `occurrence_date` alanı başladığı gündür; bitiş ertesi gün 08:00'dir.
- Alternatif yazım: iki RRULE. Biri `FREQ=WEEKLY;INTERVAL=2;BYDAY=MO,TH`, diğeri bir hafta sonra başlayan `…;BYDAY=TU,FR,SU`.
- Nöbet günleri hiçbir desene uymuyorsa `dates` listesi kullanılır.
- **Modele etkisi:** tek RRULE bu deseni yazamadığı için `cycle` eklendi.

### S4: Cumartesi akşamı "maç var" / "maç yok" diye iki varyantı olan etkinlik
```yaml
user_categories: [{id: FUTBOL, root_category_key: body_movement, name: "Futbol"}]
activities:
  - {id: MAC,    kind: routine,     title: "Maç",      category_id: FUTBOL}
  - {id: MACYOL, kind: travel_prep, title: "Maça yol", variant_id: V_VAR}
schedule_rules:
  - activity_id: MAC
    recurrence: {type: rrule, dtstart: "2026-11-21", rrule: "FREQ=WEEKLY;BYDAY=SA"}
    timing: {start: [{op: at, ref: {clock: "20:00"}}]}
    duration_min_minutes: 120
    duration_max_minutes: 120
    flexibility: fixed
  - activity_id: MACYOL
    recurrence: {type: follow}
    timing: {end: [{op: at, ref: {activity_id: MAC, edge: start}}]}
    duration_min_minutes: 30
    duration_max_minutes: 30
variant_groups:
  - {id: G, activity_id: MAC, name: "Maç durumu", applies_on: null, default_variant_id: V_YOK}
variants:
  - {id: V_VAR, group_id: G, name: "Maç var"}                              # kuraldaki 20:00–22:00 + maça yol
  - {id: V_YOK, group_id: G, name: "Maç yok", cancels_occurrence: true}   # akşam boş kalır
plan_instances:   # kullanıcı 21 Kasım için "Maç var"ı seçti
  - {id: v5(R_MAC, 2026-11-21), activity_id: MAC, rule_id: R_MAC, occurrence_date: "2026-11-21", variant_id: V_VAR, source: rule}
```
- Varyant kendi saatini de taşıyabilir. Ör. "Maç var" günlerinde 19:00 başlanıyorsa `V_VAR.timing` doldurulur.
- **Varyant istemeyen kullanıcıda `variant_groups` ve `variants` satırı hiç yoktur;** aktivite her cumartesi olduğu gibi oluşur.

### S5: Sadece "bu hafta 3 kez koş" diyen, saat vermeyen biri
```yaml
activities:
  - {id: KOSU, kind: routine, title: "Koşu", root_category_key: body_movement}
schedule_rules:
  - activity_id: KOSU
    recurrence: {type: per_period, count: 3, unit: week}
    valid_from: "2026-11-16"     # bu haftanın pazartesisi
    valid_until: "2026-11-22"    # her hafta sürecekse boş bırakılır
    timing: {}                   # saat yok
    flexibility: shiftable
```
- Motor haftaya 3 saatsiz oluşum koyar. Bunları boş zamanı en çok olan günlere deterministik olarak dağıtır (eşitlikte erken gün öne geçer).
- Kullanıcı hangi gün koşarsa bir oluşum `done` olur ve arayüzde "2 / 3" gibi kalan sayı görünür.
- Süre girilirse motor boşluğa saat de önerir.
- **Modele etkisi:** `per_period` bu senaryo için eklendi.

### S6: 26 Kasım'a kadar 10 saatlik proje ödevi
```yaml
activities:
  - {id: ODEV, kind: project, title: "Proje ödevi", category_id: OKUL}
projects:
  - activity_id: ODEV
    total_minutes: 600
    deadline_at: "2026-11-26T23:59:00+03:00"
    split_mode: auto
    min_chunk_minutes: 30
    max_chunk_minutes: 120
    daily_cap_minutes: 180
    preferred_windows: null
    safety_margin_minutes: 1440   # son günü boş bırak
```
- Kural satırı yoktur. Motor 18–25 Kasım boşluklarına 30–120 dakikalık parçalar önerir ve günde en çok 180 dakika koyar. Güvenlik payı nedeniyle son parça 25 Kasım'a düşer.
- Kullanıcı onaylayınca parçalar `plan_instances` olur (`source: auto`).
- Parçalar sığmazsa SLOT-5 uyarısı çıkar.
- İlerleme `done` parçalardan ve bağlı odak oturumlarından hesaplanır.

### S7: Pazarı tamamen plansız geçirmek isteyen biri
```yaml
day_overrides:
  - recurrence: {type: rrule, dtstart: "2026-11-22", rrule: "FREQ=WEEKLY;BYDAY=SU"}
    keep: fixed_only
    auto_placement: false
```
- Pazarları kaydırılabilir ve isteğe bağlı oluşumlar düşer, proje parçası yerleşmez, boş zaman hesaplanmaz.
- `fixed_only` önerilir, çünkü uyku gibi kesin işler kalmalıdır: pazar gecesi başlayan uyku pazartesi sabahına uzanır ve pazartesinin boş zaman hesabı ona dayanır. Kullanıcı gerçekten hiçbir şey istemiyorsa `keep: none` seçer.
- Rutinleri kalsın, yalnız projeler gelmesin isteyen kullanıcı `keep: all` seçer. Tek bir pazar için `recurrence` yerine `date` kullanılır.
- **Modele etkisi:** gün kuralına tekrar eklendi; tek tarih yetmiyordu.

### S8: Doğrudan kök kategoriye bağlanmış "Annemle konuşmak"
```yaml
activities:
  - {id: ANNE, kind: one_off, title: "Annemle konuşmak", root_category_key: emotional_social, category_id: null}
schedule_rules:   # isteğe bağlı; kural yoksa tarihsiz bir yapılacak olarak kalır
  - {activity_id: ANNE, recurrence: {type: once, date: "2026-11-19"}, timing: {}, flexibility: shiftable}
focus_sessions:   # konuşurken serbest sayaç açtıysa
  - {activity_id: ANNE, root_category_key: emotional_social, mode: free, focused_seconds: 1200, outcome: completed}
```
- Sayaçla yapıldıysa beyinde amigdala, vmPFC ve STS ağırlıklarına göre büyür. Sayaçsız "yaptım" demek oluşumu `done` yapar ama beyne katkı vermez (§9).
- **Modele etkisi:** kategorinin isteğe bağlı olması ve doğrudan kök bağlantısı bu senaryo için eklendi.

### S9: Sabit saati olmayan ama "akşam yemeğinden sonra" olması gereken bulaşık
```yaml
activities:
  - {id: YEMEK,   kind: routine, title: "Akşam yemeği"}
  - {id: BULASIK, kind: routine, title: "Bulaşık"}
schedule_rules:
  - activity_id: YEMEK
    recurrence: {type: rrule, dtstart: "2026-11-18", rrule: "FREQ=DAILY"}
    timing:
      start: [{op: not_before, ref: {clock: "18:30"}}]
      end:   [{op: not_after, ref: {clock: "20:30"}}]
    duration_min_minutes: 45
    duration_max_minutes: 45
    flexibility: shiftable
  - activity_id: BULASIK
    recurrence: {type: follow}
    timing: {start: [{op: not_before, ref: {activity_id: YEMEK, edge: end}}]}
    duration_min_minutes: 20
    duration_max_minutes: 20
    flexibility: shiftable
```
- Motor bulaşığı yemeğin bitişinden sonraki ilk uygun boşluğa koyar; yemek kayarsa bulaşık da kayar.
- Süre girilmemişse "yemekten sonra" etiketli saatsiz bir oluşum olur.
- Yemek o gün yoksa bulaşık da olmaz. Her gün olsun isteniyorsa tekrar `FREQ=DAILY` yapılır; o zaman çapa yoksa kısıt düşer ve oluşum saatsiz kalır.

### Sonuç
| Senaryo | Taşınıyor mu | Senaryo yüzünden modele eklenen |
|---|---|---|
| S1 | ✓ | Başlangıç + bitiş kısıtı, `day_offset`, astronomik çapa |
| S2 | ✓ | `follow` tekrar türü, göreli çapa |
| S3 | ✓ | `cycle` tekrar türü |
| S4 | ✓ | `cancels_occurrence`, varyanta özel alt aktivite |
| S5 | ✓ | `per_period` tekrar türü |
| S6 | ✓ | — (`projects`) |
| S7 | ✓ | Gün kuralında tekrar, `keep` düzeyleri |
| S8 | ✓ | İsteğe bağlı kategori, doğrudan kök bağlantısı |
| S9 | ✓ | `not_before` + aktivite çapası |

## 9. Onayda verilen kararlar (2026-11-18)
1. **Beyin ağırlıkları kategori içinde normalleştirilir.** Her odak dakikası her kategoride aynı toplam büyümeyi verir; bu büyüme bölgelere ağırlık oranında dağıtılır. Normalleştirilmeseydi toplam büyüme bölge sayısına bağlı olurdu: Dinlenme ve Uyku dakika başına 1,0, Dikkat ve Tefekkür 1,8 birim alırdı. Kanıt düzeyi hangi bölgenin daha çok parladığını belirler ve bilgi panelinde yazılır. Hiçbir etkinlik türü (ör. namaz, meditasyon) "beyni daha yavaş büyüten" olarak cezalandırılmaz.
2. **Beyne yalnız sayaçlı oturumlar katkı verir.** Sayaçsız süre kaydı (`logged`) yoktur. Bunun sonucu: Dinlenme ve Uyku kategorisi pratikte büyümez. Proje sahibi bunu kabul etti.
3. **Aktivite başına tek varyant grubu.** Bağımsız iki koşul ("maç" ve "hava") birleşik varyantlarla yazılır.
4. **Sosyal veri çevrimiçi çalışır:** mesaj ve davetler ağ ister, outbox'a girmez.
5. **Engel durumu `friendships` yerine ayrı `blocks` tablosunda tutulur.** Engel tek taraflıdır ve arkadaşlık silinse de sürmelidir.
6. **Giriş: Google + misafir.** E-posta girişi yok.
7. Konum 0,1°'ye yuvarlanır (≈ 11 km; gün doğumunda en fazla 1 dakikalık fark).

**Uygulama notları (Aşama 1):**
- Kullanıcı tablolarında yabancı anahtarlar `(user_id, <ref>_id)` çiftiyle kurulur. Bu yüzden bir satır yalnız aynı kullanıcının satırına bağlanabilir.
- `sync_push` değişiklikleri sırayla uygular. Hatalı bir değişiklik reddedilir ama aynı paketteki diğer değişiklikler uygulanır.
- Sosyal tablolarda bu aşamada okuma politikaları ve kendi satırına yazılan tablolar (`invites`, `blocks`, `visibility_settings`, `reports`, `shared_activities`, `cofocus_sessions`) var. Başkasını ilgilendiren yazmalar Aşama 4B'de RPC olarak gelecek: davet kullanma, arkadaşlık, partner sınırı, mesajlaşma, katılımcı ekleme.
