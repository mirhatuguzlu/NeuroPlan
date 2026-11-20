# BRAIN_MODEL.md — 3D beyin: model, büyüme kuralları, çizim

Durum: **Aşama 4, 2026-11-19.** Kararlar: DECISIONS D37–D41. Bilimsel dayanak: [SCIENCE.md](SCIENCE.md). Veri: [DB_SCHEMA.md](DB_SCHEMA.md) §2.2–2.3, §4.3–4.4. Köprü: [ARCHITECTURE.md](ARCHITECTURE.md) §8.

**3D beyin bir metafordur, ölçüm değildir** (SCIENCE §1). Aşağıdaki sayılar ürün kararıdır; literatürdeki etki büyüklüğünü temsil etmez.

## 1. Model
- **Kaynak:** BodyParts3D 4.0 (DBCLS), `partof` ve `isa` ağaçlarının %99 sadeleştirilmiş OBJ arşivleri.
- **Lisans:** DBCLS'nin güncel README'si (2025-02-27) veritabanını **CC BY 4.0** ile lisanslıyor. Ticari kullanım serbest, yalnız atıf gerekir. Atıf metni Hakkında ekranında ve lisans sayfasında: "BodyParts3D, © The Database Center for Life Science licensed under CC Attribution 4.0 International".
  - Not: 2011 tarihli OBJ dosyalarının başlığında eski lisans (CC BY-SA 2.1 JP) yazıyor. Güncel README bunun yerine geçtiği için BY 4.0 esas alındı. En kötü durumda, BY-SA geçerli sayılırsa, ticari kullanım yine serbesttir; yalnız türetilmiş model dosyası (`tool/brain/model/brain.glb`) aynı lisansla paylaşılır. Repo zaten açık. Yayın öncesi hukuk kontrolü listesine eklendi (D37).
- **Yeniden üretim** (ham OBJ repoda yok):
  ```bash
  cd tool/brain && npm ci
  node build_model.mjs <FJ*.obj klasörü>   # → model/brain.glb
  npm run bundle                           # → assets/brain/brain.js
  npm test
  ```
- **Bölge → BodyParts3D parçaları** (`tool/brain/regions.json`, element dosya kimlikleri):
  | Bölge | Parçalar |
  |---|---|
  | `prefrontal_*` | üst, orta ve alt frontal girus, orbital girus |
  | `frontal_*` (motor alanlar) | presantral girus |
  | `parietal_*` | postsantral girus, üst parietal lobül, supramarjinal, angular girus |
  | `temporal_*` | üst temporal girus (ön + arka), orta ve alt temporal girus, fusiform, parahipokampal girus |
  | `occipital_*` | oksipital lob |
  | `cerebellum` | beyincik (iki yarı) |
  | `brainstem` | medulla, pons, orta beyin parçaları, kollikuluslar |
  | `corpus_callosum` · `cingulate` · `insula` · `striatum` (kaudat + putamen) · `hippocampus` · `amygdala` | aynı adlı parçalar (yarı saydam iç yapı) |
  - Sınırlar girus düzeyindedir. Prefrontal / motor ayrımı yaklaşıktır: premotor alan üst ve orta frontal girusun arka bölümündedir ama burada prefrontal sayıldı. Parasantral lobül ve frontal kutup BodyParts3D'de ayrı parça değil.
  - Eksen: BodyParts3D (x sol+, y arka+, z yukarı, mm) → three.js (x, z, −y). Bütün beyin [−1, 1] küpüne ölçeklenir.
- **Sadeleştirme:** köşeler birleştirilir (weld), meshoptimizer ile toplam ≈ 60 000 üçgene inilir (bölge başına en az 400), sıkıştırma `EXT_meshopt_compression` + `KHR_mesh_quantization`. Draco seçilmedi: çözücüsü ayrı wasm dosyası ister, `file://` altında yüklenmez; meshopt çözücüsü JS'in içindedir.
- **GLB düğümleri:** `region_<key>` (kabuk), `points_<key>` (nöron adayları: bölge hacminin içinde, ışın paritesiyle seçilmiş 1500 nokta, iç yapılarda 750), `lines_boundaries` (lob sınırları: başka bir kabuğa 0,012 birimden yakın, dışa bakan kenarlar).

## 2. Büyüme kuralları (v2, `packages/neuroplan_core/lib/src/brain/`)
Bütün sabitler `brain_config.dart`'tadır (`BrainConfig`). Oranlar binde birdir (‰); hesap tamsayıdır ve bu yüzden deterministiktir. Bir sabit değişirse `engineVersion` artar ve olaylar oturumlardan yeniden türetilir.

| Sabit | Değer | Anlamı |
|---|---|---|
| `neuronsPerMinute` | 1000 | Bir odak dakikası = 1 nöron (1000 binde-birim), kategori başına |
| `escapePenaltyPermille` / `minFocusPermille` | 100 / 600 | Odak çarpanı |
| `cycleBonusPermille` / `maxCycleBonusPermille` | 50 / 200 | Pomodoro döngü eki |
| `streakDayBonusPermille` / `maxStreakBonusPermille` | 30 / 180 | Pomodoro haftalık süreklilik eki |
| `historyDays` | 7 | Süreklilik ve art arda gün penceresi (bugün dahil) |
| `deepLinkPerMinute` | 20 | Derin çalışma bağ kalınlaşması |
| `consecutiveDayLink` / `maxConsecutiveDays` | 100 / 7 | Art arda gün bağı |
| `crossCategoryLink` | 300 | Aynı gün farklı kategori bağı |
| `cofocusLink` | 200 | Arkadaşla birlikte tamamlanan ortak odak bağı (Aşama 4B) |
| `halfLifeDays` / `brightnessFloorPermille` | 14 / 250 | Sönme |

### 2.1 Türetme: `deriveBrainEvents(oturum, geçmiş, ağırlıklar)`
- Yalnız sayaçlı ve biten oturumlar (D20). Kök kategorisi olmayan ya da 1 dakikadan kısa oturum olay üretmez.
- **Kazanç** (`neuron_gain`), tamamlanan oturum:
  ```
  taban   = odak_dakikası × 1000
  odak    = max(600, 1000 − 100 × geri_dönülen_kaçış)          ‰
  ek      = Pomodoro ise min(50 × döngü, 200) + min(30 × (süreklilik_günü − 1), 180)   ‰
  toplam  = taban × odak ÷ 1000 × (1000 + ek) ÷ 1000            (tamsayı bölme)
  ```
  Toplam, kök kategorinin bölgelerine **kategori içinde normalleştirilmiş ağırlıkla** "en büyük kalan" yöntemiyle dağıtılır (DB_SCHEMA §9.1).
  - "Odak puanı çarpanı" ölçülen kesintiden gelir, kullanıcının 1–5 puanından değil (soru formu). Sayılan ve 10 sn içinde geri dönülen her kaçış %10 düşürür. Arama ve ekran kapanması sayılmaz (FOCUS-6).
  - Pomodoro sürekliliği: penceredeki (son 7 gün) Pomodoro tamamlanan farklı gün sayısı, bugün dahil. Son bozulan oturumdan önceki günler sayılmaz (bozulma seriyi sıfırlar, FOCUS-5).
- **Bağlantı** (`connection_gain`, `region_key` ≤ `region_b_key`; bölge içi bağda ikisi aynı):
  - Derin çalışma: `en_uzun_kesintisiz_dakika × 20`, kategorinin bölge çiftlerine ağırlık çarpımıyla dağıtılır. Tek bölgeli kategoride bölge içi bağdır.
  - Art arda gün: aynı kök kategori dün de tamamlandıysa, kategorinin her bölgesine bölge içi `100 × min(seri, 7)`. Seri dünden geriye kesintisiz gün sayısıdır. Anahtar gün + kategori başına tekildir; günün ikinci oturumu yeni bağ eklemez.
  - Aynı gün farklı kategori: bugün başka bir kök kategoride daha önce tamamlanan oturum varsa, iki kategorinin bölgeleri arasına toplam 300 (ağırlık çarpımıyla; aynı bölge kendisiyle eşleşmez). Gün × kategori çifti başına bir kez.
- **Ortak odak** (Aşama 4B, D47): oturum ortak odakta tamamlandıysa ve aynı ortak oturumu en az bir arkadaş da tamamladıysa `cofocusLink = 200` bağlantı, kategorinin bölge çiftlerine (derin çalışma gibi) dağıtılır. Sayı sunucudan öğrenilir: istemcide `sync_state` `cofocus.peers.<oturum>`, sunucuda `cofocus_participants`. Anahtar `cofocus:<oturum>:<a>:<b>:v2`. Kural yalnız yeni veriyi etkilediği için motor sürümü değişmedi.
- **Ceza** (`penalty`, D31): bozulan oturum kazanç getirmez; `odak_dakikası × 1000` kazançla aynı dağıtımla.
- **Tekilleştirme anahtarları:** `gain:<oturum>:<bölge>:v2`, `penalty:…`, `deep:<oturum>:<a>:<b>:v2`, `streak:<gün>:<kök>:<a>:<a>:v2`, `cross:<gün>:<kök1>:<kök2>:<a>:<b>:v2`.

### 2.2 Katlama: `foldBrain(olaylar, asOf)`
- Olaylar (an, anahtar) sırasıyla işlenir; `asOf` sonrası yok sayılır. Zaman çizelgesi aynı fonksiyonu geçmiş bir günün sonuyla çağırır.
- Bölge durumu: **yanan** ve **sönük** nöron (binde-birim). Kazanç önce sönükleri yakar (`yeniden_yanan = min(sönük, kazanç)`), toplam `kazanç − yeniden_yanan` kadar artar. Ceza yanandan sönüğe taşır. **Toplam hiç azalmaz; hiçbir nöron silinmez** (BRAIN-3).
- **Sönme olaysızdır** (D39): `parlaklık = 250 + 750 × 0,5^(gün / 14)` (‰), gün = son kazançtan bu yana. Hiç beslenmemiş bölge tabandadır. Bu yüzden `fade` olayı üretilmez; şemadaki tür ileride sunucu bildirimi gibi kullanımlar için durur.
- Bağlantılar çift anahtarında toplanır. `byRoot`: bölgeye kök kategori başına giden kazanç (renk ve "seni besleyenler" için).
- Anlık görüntü `brain_snapshots`'a yazılır; olay özeti (`eventsHash`, FNV-1a) aynıysa yeniden yazılmaz.

### 2.3 Test vektörü
`packages/neuroplan_core/test/vectors/brain_v2.json`: altı oturum, beklenen olaylar ve durum. Sunucu hesabı (ARCHITECTURE §7) bununla eşitliği kanıtlar. Aşama 4B: `brain_snapshot` Edge Function aynı Dart kodunu `dart compile js` ile çalıştırır (`packages/neuroplan_core/tool/server_brain_js.dart` → `supabase/functions/brain_snapshot/server_brain.js`); `test/server_brain_test.dart` istemci türetmesiyle eşitliği denetler. Çekirdek değişince JS yeniden derlenir:
  ```bash
  cd packages/neuroplan_core && dart compile js -O2 --no-source-maps -o ../../supabase/functions/brain_snapshot/server_brain.js tool/server_brain_js.dart
  ``` Güncellemek: `UPDATE_VECTORS=1 dart test test/brain_fold_test.dart`.

## 3. Çizim planı (`render_plan.dart`, Dart'ta)
- Bir nöron bir noktadır. Toplam nokta kademe üst sınırını aşarsa noktalar bölgelere toplamla orantılı dağıtılır ve fazlası **ışıma** olarak yansır: `ışıma = parlaklık × (1 + 0,25 × log2(toplam / üst_sınır))`, en çok 1000.
- Sönük noktalar bölgedeki sönük oranıyla ayrılır.
- Bağlar güce göre sıralanır, kademe sınırı kadarı çizilir. Seviye: `1000 × ln(1 + güç/100) / ln(1001)`, iki ucun düşük parlaklığıyla çarpılır (sönen bölgenin bağı da söner).
- Bölge rengi: o bölgeyi en çok besleyen kök kategorinin rengi (`root_categories.color`); hiç beslenmemişse temanın ışıma rengi.

## 4. Sahne (`tool/brain/src/`, JS yalnız çizer)
- Kabuk: bölge başına fresnel shader (kenarda parlayan, dolu katman yok), toplamalı karışım. İç yapılar daha saydam. Lob sınırları ince çizgi.
- Nöronlar: tek `THREE.Points` çağrısı. Nokta i'nin yeri `mulberry32(fnv(tohum:bölge))` akışının i. çekilişidir: aday havuzundan bir nokta + küçük sapma. Yeni nöron gelince eskiler kımıldamaz. Tohum: kurulum başına rastgele kimlik (giriş aşamasında Supabase kullanıcı kimliğine geçecek, `shortcut:` notu).
- Bağlar: `LineSegments`; WebGL çizgi kalınlığı 1 px olduğu için güçlü bağ daha çok paralel şerit (1–5) ve daha parlak çizilir. Ara sıra bir bağ boyunca sinyal darbesi kayar; kazanç olayında o bölgelerin bağlarında darbe çıkar.
- Bloom: `UnrealBloomPass` (yüksek kademede tam, ortada yarım çözünürlük, düşükte kapalı).
- Etkileşim: tek parmak döndür, iki parmak yakınlaştır, çift dokunuş sıfırla, tek dokunuş bölge seçer. Vurguda seçili bölge parlar, kalanlar soluk; bölge sayfasında (`focus`) yalnız o bölge kalır ve kamera ona yaklaşır.
- Hareket azaltma açıksa kendiliğinden dönme, pırıltı ve darbe yok.

## 5. Performans
| Kademe | Nokta üst sınırı | Bağ | Bloom | pixelRatio | Hedef |
|---|---|---|---|---|---|
| `high` | 6000 | 150 | tam | ≤ 2 | 60 fps |
| `mid` | 3000 | 80 | yarım | ≤ 1,5 | 60 fps |
| `low` | 1200 | 40 | kapalı | 1 | 30 fps |
- Başlangıç kademesi sahnenin bildirdiği ipuçlarından (`QualityGovernor.fromHints`): ≤ 4 çekirdek, ≤ 2 GB bellek ya da eski Mali/Adreno/PowerVR → düşük; ≤ 6 çekirdek ya da ≤ 4 GB → orta; yoksa yüksek.
- Sahne 5 sn'de bir fps bildirir. Hedefin %90'ının altında iki rapor üst üste bir kademe indirir. Kademe oturum boyunca geri yükselmez (titreşimi önler).
- Sekme görünmezken, üstüne sayfa açılınca ve uygulama arka plandayken `requestAnimationFrame` durur.
- Ön ısıtma: WebView ilk karede (alt menü kurulurken) yaratılıp sahneyi yükler; Beyin sekmesine gelince model hazırdır.
- Ölçümler: §6.

## 6. Ölçümler
- **Model:** 18 bölge, 59 992 üçgen, 1419 sınır kenarı, `brain.glb` 401 KB; paket `brain.js` 1,2 MB.
- **Tarayıcı önizlemesi** (masaüstü, yüksek kademe): görünüm [screenshots/brain_scene_preview.jpg](screenshots/brain_scene_preview.jpg).
- **Gerçek cihaz:** henüz ölçülmedi; proje sahibi QA_CHECKLIST B3 ile yapacak. Yük altında ölçmek için (veritabanına dokunmaz):
  ```bash
  flutter run --profile --dart-define=BRAIN_BENCH=6000 --dart-define=BRAIN_TIER=high
  adb logcat | grep "[brain] fps"
  ```
  Kademe başına bir satır yazılır: cihaz, kademe, nöron sayısı, ortalama fps, en uzun kare.

| Cihaz | Kademe | Nöron | fps | En uzun kare |
|---|---|---|---|---|
| | | | | |
