# DECISIONS.md — Mimari karar kaydı

Her karar: tarih, karar, neden, durum. Yeni karar en alta eklenir; değişen karar silinmez, yeni kayıtla “yerine geçer” diye işaretlenir.
Durumlar: **Kabul** · **Geçici** (değişmesi bekleniyor) · **Açık** (karar verilmedi).

## 2026-11-18 — D1: Teknoloji yığını
**Karar:** Flutter (Dart), Android öncelikli; Supabase (Auth, Postgres, RLS, Edge Functions); 3D beyin gömülü WebView içinde yerel Three.js sahnesi + JS köprüsü; offline-first: yerel SQLite → Supabase eşitleme.
**Neden:** Proje sahibi tarafından sabitlendi.
**Durum:** Kabul.

## 2026-11-18 — D2: SDK sürümleri
**Karar:** Flutter 3.50.0 stable, Dart 3.14.0 (`pubspec.yaml`: `sdk: ^3.14.0`). Supabase CLI 3.2.0.
**Neden:** Başlangıçta en güncel stabil sürümler.
**Durum:** Kabul. Yükseltmeler buraya kaydedilir.

## 2026-11-18 — D3: Proje yolu
**Karar:** Proje `C:\dev\NeuroPlan` altında (yalnız ASCII karakterli yol).
**Neden:** Android Gradle eklentisi Windows'ta ASCII olmayan yolları (ör. `NöroPlan(NeuroPlan)`) reddediyor; `android.overridePathCheck` ile susturmak NDK/CMake gibi araçlarda hata riskini bırakıyor.
**Durum:** Kabul.

## 2026-11-18 — D4: Uygulama kimliği
**Karar:** `applicationId` / bundle id: `com.mirhatuguzlu.neuroplan`. Dart paket adı: `neuroplan`.
**Neden:** Sahibi olunmayan bir alan adını kullanmaz, çakışma riski yok.
**Durum:** Geçici. Play Store'a **ilk yüklemeden önce** değiştirilebilir; yüklendikten sonra değiştirilemez.

## 2026-11-18 — D5: Platform klasörleri
**Karar:** `android/` ve `ios/` oluşturuldu; web ve masaüstü yok.
**Neden:** Android öncelikli; iOS klasörü kimliğin tutarlı kalması için şimdiden var (Windows'ta derlenmez). Web hedefi yok; 3D beyin WebView içinde çalışır.
**Durum:** Kabul.

## 2026-11-18 — D6: Ortam değişkenleri ve anahtarlar
**Karar:** Supabase URL ve anon/publishable key `.env` dosyasında (git-ignored), örnek `.env.example`'da. Uygulamaya `flutter run --dart-define-from-file=.env` ile verilir, kodda `String.fromEnvironment` ile okunur. `flutter_dotenv` kullanılmaz.
**Neden:** Ek bağımlılık gerektirmez; `flutter_dotenv` dosyayı asset olarak APK'ya gömer. Not: anon/publishable key tasarım gereği istemcide bulunur ve APK'dan çıkarılabilir; güvenlik RLS ile sağlanır. `service_role` / secret key istemciye ve repoya hiç girmez, yalnız Edge Functions ortamında.
**Durum:** Kabul.

## 2026-11-18 — D7: Three.js dağıtımı
**Karar:** Three.js ve beyin sahnesi uygulamaya asset olarak gömülür; CDN'den yükleme yok.
**Neden:** Offline-first, gizlilik ve sürüm sabitliği.
**Durum:** Kabul. Sürüm ve köprü protokolü 3D beyin aşamasında kaydedilir.

## 2026-11-18 — D8: Veritabanı şeması ve migration
**Karar:** Şema değişiklikleri yalnız `supabase/migrations` altındaki SQL migration'larla (`supabase migration new`). Her tabloda RLS açık.
**Durum:** Kabul.

## 2026-11-18 — D9: Geliştirme araçları (AI skill / plugin)
**Karar:** Kullanıcı (global) kapsamında kurulu: `dart-flutter` (flutter/agent-plugins), `dart-lang/skills` (15 skill), `frontend-design` (anthropics/skills), `ui-ux-pro-max`, `impeccable` (hook'suz). Kurulum komutları CLAUDE.md'de. Supabase MCP kullanıcı kapsamında, projeye sabitlenmiş ve salt-okunur (`read_only=true`) eklendi; şema değişiklikleri MCP ile değil migration'larla yapılır. Python 3.14 (ui-ux-pro-max arama betiği için) kullanıcı kapsamında kuruldu.
**Neden:** Proje sahibinin tercihi (repo temiz kalır). impeccable hook'ları JSX/HTML odaklı, Dart'ta işe yaramaz; “live mode” izinleri atlayarak ajan çalıştırabildiği için yasak. Web odaklı skill'lerin Flutter'a uyarlanışı UX_RULES.md'de.
**Durum:** Kabul.

## 2026-11-18 — D10: İkon seti ve fontlar
**Karar (öneri):** Tek ikon seti Material Symbols (Rounded), gömülü. Fontlar UX_RULES.md §7'deki aday listesinden, glif testinden sonra seçilir; hepsi OFL ve gömülü.
**Durum:** Açık — Aşama 1'de kesinleşir.
**Güncelleme (2026-11-18):** Aşama 1 talimatı font testini kapsamadı; karar tema aşamasına taşındı. 9 kök kategorinin ikonları UX_RULES §8 kayıt tablosuna eklendi.

## 2026-11-18 — D11: Aşama 1'e bırakılan kararlar
**Durum:** Açık.
- Klasör yapısı ve katman mimarisi
- State yönetimi
- Yerel veritabanı paketi (SQLite üzerinde)
- Eşitleme stratejisi ve çakışma çözümü
- Yönlendirme (router)
- Giriş yöntemleri
- Canlı sesli oturum altyapısı (WebRTC sağlayıcısı)
- **Lisans ve repo görünürlüğü** — Repo public ama lisanssız (tüm hakları saklı). İleride ücretli olacağı için private yapmak ya da bilerek lisanssız bırakmak değerlendirilecek. Aşama 1 başında proje sahibine hatırlatılacak.

**Kapanış (2026-11-18):** Maddeler D12–D21 ile karara bağlandı. WebRTC sağlayıcısı açık kaldı (D21).

## 2026-11-18 — D12: Katmanlar ve alan paketi
**Karar:** Üç katman: sunum (`lib/ui`), veri (`lib/data`), alan (`packages/neuroplan_core`). Alan katmanı saf Dart paketidir ve pub workspace'te durur. Veri modeli olarak Drift'in ürettiği satır sınıfları kullanılır. `core`'da yalnız şunlar bulunur: jsonb değer tipleri (`Recurrence`, `Timing`), HLC ve alan birleştirme, deterministik kimlikler, sistem verisi okuyucu. Plan motoru ve beyin hesabı ilgili aşamalarda `core`'a eklenecek.
**Neden:** Flutter import'u o pakette derleme hatası verir, saflığı derleyici korur. Aynı kod `dart compile js` ile Edge Function'da çalıştırılıp sunucuda doğrulama yapılabilir. Ayrıntı: ARCHITECTURE.md §2–4.
**Durum:** Kabul. Edge Function'da çalıştırma prototiple doğrulanacak.

## 2026-11-18 — D13: Durum yönetimi
**Karar:** `flutter_riverpod` 3, kod üretimi olmadan. Notifier'lar ekran durumunu tutar; testte depolar `overrides` ile değiştirilir.
**Neden:** Drift akışlarını doğrudan dinler, bağımlılık enjeksiyonunu da çözer. Alternatif olan resmi `ChangeNotifier` + `provider`'da asenkron durum ve test geçersiz kılma elle yazılır.
**Durum:** Kabul. Paket ilk ekranla eklenecek.

## 2026-11-18 — D14: Gezinme
**Karar:** `go_router`. Alt menü `StatefulShellRoute` ile kurulur, davet bağlantısı derin bağlantıyla açılır.
**Durum:** Kabul. Paket ilk ekranla eklenecek.

## 2026-11-18 — D15: Yerel veritabanı
**Karar:** Drift 2.35. SQLite, `sqlite3` paketinin derleme kancasıyla uygulamaya gömülür. Zaman damgaları ISO metin olarak tutulur. JSON anahtarları sunucudaki sütun adlarıyla aynıdır (`build.yaml`). Üretilen `*.g.dart` dosyaları repoya girer. Yerel veritabanı tek doğru kaynaktır.
**Neden:** Tip güvenli SQL, reaktif sorgular, migration ve bellek içi test desteği var.
**Durum:** Kabul.

## 2026-11-18 — D16: Eşitleme ve çakışma
**Karar:** Kendi motorumuz kullanılır (ARCHITECTURE §5):
- Her yazma tek işlemde hem satıra hem outbox'a gider.
- Sunucu tarafında `sync_push` / `sync_pull` RPC'leri var.
- Sürüm, kullanıcı başına tek bir sayaçtan gelir. Sayaç satırının kilidi sayesinde sürüm sırası commit sırasıyla aynıdır.
- Çakışmada alan bazlı son yazan kazanır: her alanın HLC damgası `field_versions` içinde tutulur. Sunucu, kendi zamanından 5 dakikadan ileri damgayı kırpar.
- Silme yumuşaktır (`deleted_at`).
- Motorun ürettiği satırlar deterministik UUIDv5 kimlik alır.
- `user_id` istemciden gelmez, sunucu doldurur.

**Neden:** Ek servis ve ücret yok. Cihaz saatine güvenmeyen alan bazlı birleştirme, iki cihazın farklı alanlardaki düzenlemelerini birlikte korur. PowerSync değerlendirildi; ek servis ve ücret nedeniyle seçilmedi (proje sahibinin kararı).
**Durum:** Kabul. Daha yapılmayanlar: Supabase `SyncRemote` uygulaması, otomatik tetikleyiciler ve geri çekilme (giriş aşamasında); silinmiş satırların 90 gün sonra temizlenmesi.

## 2026-11-18 — D17: Giriş yöntemleri
**Karar:** Google ve misafir. Misafir modu Supabase anonim kullanıcısıyla çalışır; hesaba geçişte `linkIdentity` aynı `user_id`'yi korur. **E-posta girişi yok:** Aşama 1 talimatı "e-posta + Google" diyordu, proje sahibi Google + misafiri seçti. Apple girişi iOS aşamasında değerlendirilecek.
**Durum:** Kabul.

## 2026-11-18 — D18: Lisans ve repo görünürlüğü
**Karar:** Repo public kalır, lisans AGPL-3.0'dır (`LICENSE`).
**Neden:** Proje sahibinin kararı. Kodu kullanan bir hizmet de kendi kaynağını açmak zorunda kalır. Telif tek kişideyken uygulamayı mağazalara koymak serbesttir; dışarıdan katkı alınırsa katkıcı sözleşmesi (CLA) gerekebilir.
**Durum:** Kabul.

## 2026-11-18 — D19: Şema kuralları
**Karar:** Şema DB_SCHEMA.md'de, onaylandı.
- Her kullanıcı tablosunda yedi ortak sütun var (id, user_id, created_at, updated_at, deleted_at, version, field_versions).
- Çok biçimli alanlar jsonb'dir (`recurrence`, `timing`). Doğrulama aynı kurallarla iki yerde yapılır: sunucuda SQL, istemcide `core`.
- Durum alanları `text` + CHECK ile tutulur; süreler dakikadır.
- Kullanıcı tablolarındaki yabancı anahtarlar `(user_id, ref)` çiftiyle kurulur.
- Tekrar için RRULE alt kümesi kullanılır; dönüşümlü desenler için `cycle` eklendi.
- Sistem verisinin tek kaynağı `assets/seed/system.json`'dur; migration `tool/gen_seed_sql.dart` ile üretilir ve test eşitliği denetler.
- Sistem tablolarındaki TR/EN adlar veridir, koda sabit metin değildir (CLAUDE.md kural 8).

**Durum:** Kabul.

## 2026-11-18 — D20: Beyin hesabı ilkeleri
**Karar:**
- Beyin olay kaynaklıdır: oturumlar → `brain_events` (yalnız eklenir, `dedupe_key` ile tekil) → anlık görüntü.
- Ağırlığın tavanı kanıt düzeyidir (1,0 / 0,6 / 0,3 / 0,1).
- Ağırlıklar kategori içinde normalleştirilir: her odak dakikası her kategoride aynı toplam büyümeyi verir.
- Beyne **yalnız sayaçlı oturumlar** katkı verir. Bunun sonucu olarak Dinlenme ve Uyku pratikte büyümez; proje sahibi bunu kabul etti.
- `penalty` olayı nöron ya da parlaklık düşürmez.

**Neden:** Hiçbir etkinlik türü (ör. ibadet, meditasyon) kanıtı zayıf diye "daha yavaş büyüten" olarak cezalandırılmaz. Sayaçsız kayıt ise hile ve uyku baskınlığı riski taşıyor.
**Durum:** Kabul. Formülün ayrıntısı beyin aşamasında yazılacak.

## 2026-11-18 — D21: Canlı sesli oturum altyapısı
**Karar:** WebRTC sağlayıcısı Aşama 4B'de seçilecek. Şemada yalnız sağlayıcıdan bağımsız `cofocus_sessions.room_id` alanı var; ses kaydedilmez.
**Durum:** Açık.

## 2026-11-18 — D22: Plan oluşumlarının kalıcılığı
**Karar:** Plan motorunun çıktısı bellekte tutulur ve her değişiklikte yeniden hesaplanır. `plan_instances` satırı yalnız kullanıcı bir oluşuma dokununca yazılır:
- bitti, atla
- saat değiştir ("yalnız bu sefer")
- varyant seç
- proje parçasını onayla, elle parça ekle

Kimlikler deterministik kalır: kural oluşumu için `v5(kural, gün)`, "dönem başına N kez" için `v5(kural, dönem başı, sıra)`.
**Neden:** Her plan değişikliğinde 14 günlük oluşum yazmak her satırı outbox'a ve sunucuya taşırdı. Proje sahibi "yalnız dokunulunca"yı seçti.
**Durum:** Kabul.

## 2026-11-18 — D23: Namaz vakti paketi
**Karar:** `adhan` yerine `adhan_dart` 2.0 kullanılır (saf Dart, bağımlılıksız). Varsayılan hesap yöntemi `turkiye`'dir (Diyanet): fecir 18°, yatsı 17°, temkin düzeltmeleri (güneş −7, öğle +5, ikindi +4, akşam +7 dk). Gün doğumu ve batımı, yöntem düzeltmesi uygulanmadan hesaplanır. Namaz vakitleri yalnız çapa olarak kullanılır.
**Neden:** `adhan` 2023'ten beri güncellenmiyor ve indirmesi çok az. `adhan_dart` bakımda ve Diyanet yöntemini hazır veriyor. 19.11.2026 İstanbul için çıktısı Diyanet'in yayımladığı vakitlerle örtüşüyor (akşam 17:49).
**Durum:** Kabul.

## 2026-11-18 — D24: Plan motoru ilkeleri
**Karar:** Yerleştirme sırası, çakışma, tampon ve döngü kuralları ARCHITECTURE §6'dadır. Özeti:
- Kesin işler önce yerleşir. Esnek işler kesinlerin hepsinden sonra gelir, en yakın boşluğa taşınır.
- İki kesin iş çakışırsa motor karar vermez, kullanıcıya gösterir.
- Sığmayan işler tampona düşer; plan çökmez.
- Proje bölme `ChunkPlanner` arayüzünün arkasındadır. İlk uygulama "son tarihi en yakın önce"dir (`EarliestDeadlinePlanner`).
- Senaryolar JSON vektör değil, Dart birim testidir; çünkü plan motoru sunucuda yeniden çalıştırılmaz.

**Neden:** Aşama 2 talimatı. Akıllı planlayıcı ileride aynı arayüzle takılabilsin diye bölme ayrı tutuldu.
**Durum:** Kabul.
