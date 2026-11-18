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
