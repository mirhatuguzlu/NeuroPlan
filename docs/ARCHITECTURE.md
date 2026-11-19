# ARCHITECTURE.md — NöroPlan Mimarisi

Durum: **Onaylandı, 2026-11-18 (Aşama 1).** Kararlar `docs/DECISIONS.md`'de (D12–D20).
Veri modeli: [DB_SCHEMA.md](DB_SCHEMA.md).

## 1. Özet
- Üç katman var: **sunum → veri → alan**. Alan katmanı ayrı, saf Dart paketidir (`packages/neuroplan_core`). Flutter'a, veritabanına ya da ağa bağımlı değildir.
- **Tek doğru kaynak cihazdaki SQLite'tır (Drift).** Supabase; yedekleme, çoklu cihaz ve sosyal özellikler içindir.
- Plan motoru ve beyin hesabı **deterministik saf fonksiyonlardır**: aynı girdi her zaman aynı çıktıyı verir.
- Beyin **olay kaynaklıdır**: odak oturumları (gerçekler) → beyin olayları (yalnız eklenir) → anlık görüntü (önbellek).

## 2. Teknoloji seçimleri
| Alan | Seçim | Sürüm (2026-11-18) | Neden | Değerlendirilen alternatif |
|---|---|---|---|---|
| Durum yönetimi + bağımlılık enjeksiyonu | `flutter_riverpod`, kod üretimi olmadan | 3.5 | Drift akışları `StreamProvider` ile doğrudan dinlenir. Testte `overrides` ile sahte depo verilir. Bağımlılık enjeksiyonu için ayrı bir paket gerekmez. | Resmi kılavuzdaki `ChangeNotifier` + `provider`: daha az bağımlılık getirir ama asenkron durum, iptal ve test için geçersiz kılma elle yazılır. |
| Gezinme | `go_router` | 18.1 | Resmi paket. Davet bağlantısı için derin bağlantı destekler; alt menü `StatefulShellRoute` ile kurulur. | `auto_route`: kod üretimi ister. |
| Yerel veritabanı | `drift` + `drift_flutter` | 2.35 / 0.3 | Tip güvenli SQL, reaktif sorgu, şema migration'ı. Testte bellek içi veritabanı kullanılabilir. | `sqflite`: ham SQL, akış yok. PowerSync: proje sahibi kendi motorumuzu seçti. |
| Arka uç | `supabase_flutter` | 2.18 | Auth (Google, anonim), Postgres, RLS, RPC. | — |
| Kimlik | `uuid` | 4.6 | Satırlarda v7 (zaman sıralı), motor çıktısında v5 (deterministik). | — |
| Tekrar kuralı | `rrule` (saf Dart) | 0.2 | RFC 5545 standardı; ileride takvim (ICS) içe/dışa aktarımı mümkün olur. | Kendi ayrıştırıcımız. |
| Saat dilimi | `timezone` + `flutter_timezone` | 0.11 / 5.1 | IANA veritabanı, yaz saati geçişleri. | — |
| Gün doğumu / namaz vakti | `adhan_dart` (saf Dart, bağımlılıksız) | 2.0 | Hesap çevrimdışı yapılır; Diyanet yöntemi (`turkiye`) hazır gelir. Aşama 2'de `adhan` yerine seçildi (D23). | `adhan` (2023'ten beri güncellenmiyor), kendi NOAA hesabımız. |
| 3D köprü | `webview_flutter` | 4.14 | Resmi paket, `JavaScriptChannel` ve `loadFlutterAsset` destekler. | `flutter_inappwebview` |

**Önerinin değerlendirmesi:** Önerilen dörtlü (Riverpod, go_router, Drift, supabase_flutter) korunuyor. Tek ekleme, alan katmanının ayrı bir saf Dart paketi olmasıdır (Dart pub workspace). Bunun iki nedeni var:
1. Saflığı derleyici korur. `package:flutter` import'u o pakette derleme hatası verir; yalnız kod incelemesine güvenilmez.
2. Aynı kod `dart compile js` ile Supabase Edge Function'da çalıştırılabilir. Böylece sunucu doğrulaması için hesabı ikinci kez yazmak gerekmez (bkz. §7).

Kod üretimi yalnız Drift için kullanılır (`build_runner`). `riverpod_generator` ve `freezed` kullanılmaz; gerekirse karar kaydıyla eklenir.

## 3. Katmanlar
```
┌─────────────────────────── Sunum: lib/ui ────────────────────────────┐
│  Ekran (Widget) ──izler──▶ Notifier (ekran durumu: yükleniyor/boş/hata)│
│        │ kullanıcı eylemi            │ çağırır                         │
└────────┼─────────────────────────────┼─────────────────────────────────┘
         ▼                             ▼
┌─────────────────────────── Veri: lib/data ───────────────────────────┐
│  Depolar (Repository)                                                  │
│   ├─ okuma : Drift akışları ──▶ alan modelleri                         │
│   └─ yazma : satır + outbox kaydı TEK yerel işlemde                    │
│  LocalDb (Drift/SQLite) ◀──── SyncEngine ────▶ Supabase (RPC, Auth)    │
└────────────────────────────────┬───────────────────────────────────────┘
                                 ▼ çağırır
┌──────────────── Alan: packages/neuroplan_core (saf Dart) ─────────────┐
│  Modeller · PlanEngine · BrainEngine · HLC + alan birleştirme          │
│  Tekrar/zaman kısıtı çözücü · sistem verisi okuyucu                    │
└────────────────────────────────────────────────────────────────────────┘
```
- Bağımlılık yönü: `ui → data → core`. `core` yalnız saf Dart paketlerini kullanır: `rrule`, `timezone`, `adhan_dart`, `uuid`.
- Ekran yalnız Notifier'ı bilir, Notifier yalnız depoyu bilir. Supabase'i yalnız `data/remote` bilir.
- **Veri modeli:** Drift'in ürettiği satır sınıfları (`Activity`, `ScheduleRule`…) kullanılır; ayrı bir alan modeli kopyası yazılmaz. `core`'da yalnız şunlar bulunur: jsonb değer tipleri (`Recurrence`, `Timing`), HLC ve alan birleştirme, deterministik kimlikler, sistem verisi. Motorların girdi tipleri motor aşamasında `core`'a eklenir.
- Her Notifier ekran durumunu tek bir değerle sunar: yükleniyor, boş, veri, hata ya da çevrimdışı (UX_RULES §4).

## 4. Klasör yapısı
```
pubspec.yaml                  uygulama + workspace kökü
packages/neuroplan_core/      saf Dart alan katmanı
  lib/src/model/              Activity, ScheduleRule, Recurrence, Timing, FocusSession…
  lib/src/plan/               PlanEngine: tekrar genişletme, kısıt çözme, boşluk, yerleştirme
  lib/src/focus/              FocusClock (zaman damgalı sayaç), EscapeGuard (10 sn kuralı)
  lib/src/brain/              BrainEngine: olay türetme (Aşama 3: kazanç + ceza), katlama, sönme
  lib/src/sync/               HLC, alan bazlı birleştirme
  lib/src/science/            sistem verisi modelleri (kök kategori, bölge, ağırlık)
  test/                       birim testleri + test vektörleri (JSON)
lib/
  main.dart
  app/                        MaterialApp, router, sağlayıcı kökü
  ui/core/                    tema (ThemeExtension tokenları), ortak widget'lar
  ui/features/<özellik>/      ekranlar + Notifier'lar
  data/local/                 Drift veritabanı, tablolar, DAO'lar
  data/remote/                Supabase servisleri (auth, sync RPC, sosyal)
  data/sync/                  SyncEngine, outbox
  data/repositories/          depolar
  l10n/                       app_tr.arb, app_en.arb
assets/
  seed/system.json            kök kategori, bölge, ağırlık: TEK KAYNAK (SCIENCE.md'den)
  brain/                      three.js + sahne (D7)
tool/gen_seed_sql.dart        system.json → seed migration'ı (--check ile doğrular)
supabase/
  migrations/                 şema, RLS, seed (seed SQL, system.json'dan üretilir)
  functions/                  Edge Functions: delete_account, export_data, leaderboard
```
`assets/seed/system.json` hem Drift'in ilk kurulumunu hem de migration'daki seed SQL'ini besler. Bir test ikisinin aynı olduğunu doğrular.

## 5. Offline-first veri akışı
```
 Ekran ──eylem──▶ Depo ──┬─▶ Drift tablo (satır + field_versions)  ┐ tek SQLite
                         └─▶ sync_outbox (yama + HLC)              ┘ işlemi
 Ekran ◀──akış────────────── Drift tablo   (ağ beklenmez)

 SyncEngine (tetik: yazmadan 2 sn sonra · açılış · ön plana dönüş · ön planda 5 dk'da bir)
   1. PUSH  outbox ──toplu (≤200)──▶ sync_push RPC ──▶ Postgres (tek işlem, alan bazlı LWW)
            başarı: outbox kaydı silinir · geçici hata: üstel bekleme 5 sn…15 dk
            kalıcı hata (doğrulama): kayıt "dead" işaretlenir, kullanıcıya gösterilir, veri silinmez
   2. PULL  sync_pull(imleç) ──▶ {yeni imleç V, imleç < version ≤ V olan satırlar}
            yerelde alan bazlı birleştirme; outbox'ta bekleyen alanlar yeniden uygulanır
```

### 5.1 Sürüm ve imleç
- Sunucuda her kullanıcı için tek bir sayaç vardır (`sync_counters`). Kullanıcının herhangi bir satırına yazıldığında tetikleyici sayacı 1 artırır ve bu değeri satırın `version` alanına yazar.
- Sayaç satırının kilidi işlem bitene kadar tutulur. Bu yüzden aynı kullanıcının yazmaları sırayla işlenir ve sürüm sırası commit sırasıyla aynı olur. Çekme hiçbir satırı atlamaz.
- Çekme sırası: önce sayacın değeri `V` okunur, sonra `imleç < version ≤ V` olan satırlar döner, imleç `V` olur.

### 5.2 Çakışma kuralı: alan bazlı son yazan kazanır
- Her değişiklik bir **HLC** (hibrit mantıksal saat) damgası taşır: `fizikselMs-sayaç-cihazId`. Bu damga metin olarak sıralanabilir. Cihaz saati geri gitse bile, o ana kadar görülen en büyük damgadan küçük bir damga üretilmez.
- Her satırda `field_versions` (jsonb) bulunur: sütun adı → o sütuna son yazanın HLC'si. Sunucu yamayı alan alan uygular: gelen HLC kayıtlıdan büyükse alanı yazar, değilse o alanı atlar. HLC'ler eşitse cihaz kimliğinin sırası karar verir.
- Sonuç: iki cihaz aynı işin farklı alanlarını değiştirirse ikisi de korunur. Aynı alanı değiştirirse **en son yazan** kazanır, sunucuya en son ulaşan değil.
- `updated_at` sunucunun son yazma anıdır; gösterim ve denetim içindir. **Çakışmada kullanılmaz**, çünkü cihaz saatine güvenilemez.
- Saati ileri alınmış bir cihazın sonsuza dek kazanmasını önlemek için sunucu, kendi zamanından 5 dakikadan daha ileri olan HLC'yi kendi zamanına kırpar.

### 5.3 Silme
- **Yumuşak silme:** satırın `deleted_at` alanı doldurulur. `deleted_at` da sıradan bir alandır ve aynı kurala uyar. Başka bir alanı düzenlemek silmeyi geri almaz; yalnız açık bir "geri yükle" işlemi (daha yeni HLC ile `deleted_at = null`) geri alır.
- Silinmiş satırlar sunucuda 90 gün sonra kalıcı olarak temizlenir (zamanlanmış görev). İmleci bu sınırdan eski olan cihaz tam yeniden eşitleme yapar.
- Tek istisna hesap silmedir: kalıcıdır ve anında yapılır (DB_SCHEMA §6).

### 5.4 Kimlik ve kullanıcı
- Satır kimlikleri istemcide üretilir (UUIDv7). Motorun ürettiği satırlar deterministik UUIDv5 alır, ör. `v5(kural_id, tarih)`. Böylece iki cihaz çevrimdışıyken aynı oluşumu üretse de sunucuda tek satır olur.
- `user_id` istemciden alınmaz; sunucu `auth.uid()` ile doldurur. Yerel veritabanı tek kullanıcılıdır ve `user_id` tutmaz.
- **Misafir modu:** ilk bağlantıda Supabase anonim kullanıcısı açılır; o ana kadar tüm veri yerelde ve outbox'ta bekler. Kullanıcı Google ile bağlanınca `linkIdentity` aynı kullanıcıyı kalıcı yapar, veri taşımaya gerek kalmaz. Google hesabı zaten varsa oturum o hesaba geçer, yerel verinin tamamı yeni kullanıcıya gönderilir (UUID'ler çakışmaz) ve eski anonim kullanıcı silinir.

### 5.5 Eşitlenmeyen veri
| Veri | Nasıl |
|---|---|
| Sistem tabloları | Uygulamayla gelir (seed); değişiklik uygulama sürümü + migration ile yapılır. |
| `brain_snapshots` | Her taraf kendi hesaplar (önbellek). |
| `entitlements`, `leaderboard_entries` | Yalnız sunucu yazar, istemci okur. |
| Sosyal tablolar | Çevrimiçi çalışır (davet, mesaj, ortak oturum ağ ister); yerelde yalnız okuma önbelleği tutulur, outbox'a girmez. |

## 6. Plan motoru (`PlanEngine`)
```
plan(PlanInput) → PlanOutput
PlanInput : aktiviteler, kurallar, varyantlar, projeler, gün kuralları,
            mevcut plan_instances (elle düzenlenenler sabit kabul edilir),
            profil (saat dilimi, konum, SLOT-4 ayarları), tarih aralığı, asOf
PlanOutput: oluşturulacak / güncellenecek plan_instances, boş aralıklar,
            yerleştirme önerileri, uyarılar (SLOT-5), engineVersion
```
Kod: `packages/neuroplan_core/lib/src/plan/` (Aşama 2). Girdi ve çıktı tipleri `plan_types.dart`'tadır. Zaman UTC dakika (tamsayı), gün `YYYY-MM-DD` olarak tutulur.

**Adımlar:**
1. Gün kurallarını (`day_overrides`) çöz: en kısıtlayıcı `keep` kazanır.
2. Kuralları genişlet: RRULE, döngü, tarih listesi, tek tarih, `follow`. Çalışma aralığı istenen aralıktan geniştir: bir gün öncesini kapsar (gece yarısını aşan işler bugünü doldurur) ve "dönem başına N kez" kurallarının dönemlerini tam alır.
3. Varyantı uygula: o günkü seçim, yoksa varsayılan. İptal eden varyant oluşumu siler ama seçim yine `variantChoices`'ta sunulur. Varyanta özel alt aktivite yalnız o varyant seçiliyse oluşur.
4. **Yerleştirme sırası:** dolu bloklar tek ve sürekli bir zaman çizgisinde (`Timeline`) tutulur.
   0. Kullanıcının sabitlediği oluşumlar: elle düzenlenen, "bitti" ile kapatılan, onaylı proje parçası.
   1. Sabit saatli ve astronomik çapalı kesin işler. Uyku da buradadır: sıradan, kesin bir aktivitedir.
   2. Göreli kesin işler, çapalarından sonra. Bağımlılık derinliğine göre sıralanır, çapanın gerçek saati kullanılır. Bu yüzden geç biten bir iş, ona bağlı işleri kaydırır.
   3. Zaman pencereliler ve saati olan esnek işler. Esnek işler bütün kesin işlerden sonra yerleşir.
   4. Saatsiz işler: süresi varsa saat önerilir (`suggested`). "Dönem başına N kez" oluşumları bu adımda dağıtılır: ilk ölçüt en az oluşum alan gün, sonra boş zamanı en çok olan gün, eşitlikte erken gün.
   5. Proje parçaları (`ChunkPlanner`).
   6. Kalan süre boş zamandır. Plansız günlerde (`auto_placement = false`) boş zaman hesaplanmaz.
5. **Çakışma:** İki taşınamaz iş çakışırsa ikisi de kalır ve `Overlap` raporlanır; motor karar vermez. Kaydırılabilir iş kısıtları içindeki en yakın boşluğa taşınır (eşitlikte erken olana). Yer yoksa `Overflow` olur: arayüzdeki "tampon" listesi. İsteğe bağlı iş yer yoksa düşer (`dropped`).
6. **Döngü:** Göreli çapalardaki döngü (Tarjan) `DependencyCycle` olarak raporlanır; döngüdeki işler saatsiz kalır, motor çökmez. Kayıt anında da reddedilir.
7. **Eksik veri:** Konum ya da namaz yöntemi yoksa astronomik kısıt düşer ve `MissingAnchorData` raporlanır.
8. **Proje bölme** (`ChunkPlanner` arayüzü; ilk uygulama `EarliestDeadlinePlanner`):
   - Son tarihi en yakın proje önce gelir, en erken uygun boşluk kullanılır.
   - Parça süresi min/maks sınırları içinde kalır, parçalar arası tampon bırakılır.
   - Günlük sınırlar uygulanır: projenin kendi sınırı ve profilin günlük azami odak süresi.
   - Tercih edilen pencereler önce doldurulur, güvenlik payı bırakılır.
   - Yetmeyen süre `DeadlineRisk.missingMinutes` olarak döner (SLOT-5).
   - Son tarihi olmayan ya da elle bölünen projeye öneri üretilmez.
   - Motor varsayılanları: en kısa parça 30 dk, en uzun 120 dk, tampon 10 dk.
   - Akıllı planlayıcı ileride aynı arayüzle takılır.
9. **Kalıcılık (D22):** Motor çıktısı bellekte kalır. `plan_instances` satırı yalnız kullanıcı bir oluşuma dokununca yazılır: bitti, atla, saat değiştir, varyant seç, parçayı onayla. Kimlik deterministiktir: `v5(kural, gün)` ya da `v5(kural, dönem başı, sıra)`.
10. Proje önerileri ve son tarih riski, istenen aralığın içinde hesaplanır. Bu yüzden arayüz aralığı en geç son tarihe kadar ister.

**Determinizm kuralları:**
1. Motor saati kendisi okumaz; "şimdi" (`asOf`) girdi olarak verilir.
2. Rastgelelik yoktur. Sıralamalar tam tanımlıdır: (başlangıç, öncelik, id).
3. Zaman tamsayıdır (dakika). Kayan nokta yalnız astronomik hesapta kullanılır ve sonuç dakikaya yuvarlanır.
4. Girdi koleksiyonları işlenmeden önce sıralanır; Map sırası sonucu etkilemez.
5. Çıktı `engineVersion` taşır; algoritma değişince sürüm artar.
6. Her kural bir testle korunur. Plan motoru sunucuda doğrulanmadığı için senaryolar (DB_SCHEMA §8) Dart birim testidir (D24). JSON test vektörleri, sunucuda yeniden çalışan beyin motoru için kullanılır.
7. Performans testi gerçekçi yükle (~30 kural) bir yıllık aralığı ölçer. Hedef: bir hafta < 50 ms. Aşama 2 ölçümü: hafta ortalama ~4 ms, yıl ~0,7 sn.

## 7. Beyin: olay kaynağı
```
focus_sessions (gerçek) ──BrainEngine.derive──▶ brain_events (yalnız eklenir)
                                                   │ fold(olaylar, asOf)
                                                   ▼
                                            brain_snapshots (önbellek) ──▶ WebView
```
- **Gerçek kaynak:** tamamlanan `focus_sessions`, yani **yalnız sayaçlı oturumlar** (D20). Bozulan oturum nöron kazandırmaz (FOCUS-3). Bozulan oturum `penalty` üretir: odaklanılan süre kadar nöron söner, silinmez (D31).
- `derive(oturum, ağırlıklar, engineVersion)` olayları üretir. Her olayın tekilleştirme anahtarı deterministiktir (ör. `gain:<oturum>:<bölge>:v1`). İstemci ile sunucu aynı olayı ürettiğinde tek satır kalır.
- `fold(olaylar, asOf)` bölge durumunu (nöron, parlaklık, son etkinlik) ve bağlantıları üretir. Sonuç `brain_snapshots`'a yazılır. Olay kümesinin özeti değişirse ya da `engineVersion` artarsa yeniden hesaplanır.
- Miktarlar tamsayıdır (binde bir birim). Yuvarlama "en büyük kalan" yöntemiyle deterministik yapılır.
- **v1 formülünün iskeleti** (ayrıntı beyin aşamasında): bir dakikalık odak, her kategoride aynı sabit nöron kazancını verir. Bu kazanç kategorinin bölgelerine ağırlıklarla orantılı dağıtılır (normalleştirme, DB_SCHEMA §9). Aynı oturumda birlikte çalışan bölgeler arasında bağlantı güçlenir. Etkinlik olmadıkça parlaklık eşiklerle düşer; nöron silinmez (BRAIN-3).
- **Sunucuda doğrulama:** sıralama tablosu için Edge Function aynı `neuroplan_core` kodunu (`dart compile js`) `focus_sessions` üzerinden yeniden çalıştırır. İstemcinin gönderdiği anlık görüntüye güvenilmez. Bu yol prototiple doğrulanacak. Olmazsa hesap TypeScript'e çevrilir ve aynı test vektörleriyle eşitliği korunur.

## 7a. Odak oturumu (Aşama 3, D31–D35)
```
 Flutter yaşam döngüsü (hidden / resumed) ┐
 Android: pencere odağı, ekran, kilit, arama ├─▶ FocusPlatform (arayüz) ─▶ FocusController ─▶ EscapeGuard  (core, saf)
 bildirim eylemleri (Duraklat / Bitir)     ┘                               │            └─▶ FocusClock   (core, saf)
                                                                           ├─▶ FocusRepository: segmentler, kesinti, beyin olayları
                                                                           ├─▶ sync_state: focus.runtime (cihaza özel)
                                                                           └─▶ FocusPlatform: kalıcı bildirim, 10 sn uyarısı, DND
```
- **Saf çekirdek:** `FocusClock` segmentlerden ve "şimdi"den hesaplar; `EscapeGuard` 10 sn kuralının durum makinesidir. İkisi de JSON'a yazılır, Flutter'a bağlı değildir; testleri `packages/neuroplan_core/test/focus/`.
- **Arayüz:** `FocusPlatform` (`lib/app/focus_platform.dart`) yalnız olay taşır ve sistem çağrısı yapar. Android uygulaması `MainActivity.kt` (kanallar `neuroplan/focus`, `neuroplan/focus_events`) ve `FocusAlert.kt` (geri sayan uyarı, "bozuldu" değişimi, DND). iOS aynı arayüzü uygular.
- **Denetleyici:** `FocusController` (`lib/ui/features/focus/focus_controller.dart`) uygulama kökünde canlıdır (router dinler). Olayları sırayla işler; açılışta süren oturumu kurtarır. Süren oturum varken router her yolu `/focus`'a, biten oturumu sonuç ekranına yönlendirir.
- **Süreç ölse de:** son tarihte bildirim değişimi native `Handler`'la yapılır (ön plan servisi süreci canlı tutar); veri tarafı açılışta kurtarmada tamamlanır.
- **Sabitleme (D36):** kural silahlıyken `FocusPlatform.pin`, değilken `unpin`. Onay penceresinin aldığı pencere odağı 30 sn boyunca kaçış sayılmaz.

## 8. WebView köprüsü
```
Flutter: BrainScreen                               WebView: assets/brain/index.html (three.js)
  BrainEngine.fold ─▶ snapshot
  controller.runJavaScript("brain.receive(json)") ───────────▶  sahneyi günceller
  JavaScriptChannel "NeuroBridge"   ◀───────────── NeuroBridge.postMessage(json)
  bölge bilgi paneli (Flutter widget, metin SCIENCE.md'den)
```
Mesaj biçimi: `{"v": 1, "type": "...", "payload": {...}}`
| Yön | type | payload |
|---|---|---|
| Flutter → JS | `init` | tema renkleri, hareket azaltma, kalite düzeyi |
| Flutter → JS | `state` | bölgeler `[{key, mesh, neurons, brightness}]`, bağlantılar `[{a, b, strength}]` |
| Flutter → JS | `highlight` | bölge anahtarı |
| JS → Flutter | `ready` | sahne sürümü |
| JS → Flutter | `regionTapped` | bölge anahtarı; Flutter bilgi panelini açar (BRAIN-4) |
| JS → Flutter | `perf` | ortalama fps; Flutter kalite düzeyini düşürür (BRAIN-5) |
| JS → Flutter | `error` | hata mesajı |

- JS tarafında iş kuralı yoktur, yalnız çizim yapılır. Hesap Dart'tadır (determinizm ve test için).
- Sahne `loadFlutterAsset` ile yüklenir. Navigasyon temsilcisi dış URL'leri engeller, ağ erişimi yoktur (D7).
- Bilinmeyen `v` ya da `type` değeri yok sayılır ve günlüğe yazılır.
- Metin alternatifi (BRAIN-6) aynı anlık görüntüden Flutter'da liste olarak çizilir.

## 9. Sunucu
- Her tabloda RLS açıktır (DB_SCHEMA §6).
- **RPC'ler** (`security invoker`, RLS geçerli): `sync_push`, `sync_pull`. Sosyal RPC'ler (`security definer`, kontrolleri kendi içinde yapar): `redeem_invite`, `friend_calendar`, `common_free_time`, `block_user`.
- **Edge Functions** (`service_role` yalnız burada): `delete_account`, `export_data`, `leaderboard`; Aşama 6'da `verify_purchase`.

## 10. Test stratejisi
| Katman | Nasıl |
|---|---|
| core | Birim testleri + JSON test vektörleri (plan, beyin, HLC birleştirme). |
| data | Drift bellek içi veritabanında depo CRUD testleri; her yazmanın outbox'a düştüğü doğrulanır; sahte uzak servisle eşitleme testleri. |
| Supabase | Yerel stack'te `supabase db reset` + RLS testleri (SQL betiği: kullanıcı A, B'nin satırını göremez/yazamaz). Docker gerektirir. |
| ui | Widget testleri + UX_RULES §9 erişilebilirlik eşleyicileri. |

## 11. Riskler
1. Dart kodunun `dart compile js` ile Edge Function'da (Deno) çalışması prototiple doğrulanmalı.
2. Namaz vakti `adhan_dart` paketine bağlı (D23). Paket bırakılırsa NOAA güneş hesabı ve namaz vakti formülleri `core`'a taşınır.
3. Kullanıcı başına sayaç satırı yazmaları sıraya sokar. Bu tek kullanıcı ölçeğinde sorun değildir ama toplu sunucu işleri kullanıcı başına küçük işlemlerle yapılmalıdır.
4. Saat dilimi değiştiren (seyahat eden) kullanıcı: duvar saatleri profilin saat dilimine göre yorumlanır. Seyahat modu ileride değerlendirilir.
