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

## 2026-11-18 — D25: Aşama 2 sekmeleri ve Odaklan butonu
**Karar:**
- Alt menüde dört sekme var: Bugün, Plan, Beyin, Profil.
- Beyin sekmesi bu aşamada kategori ağacını gösterir: her kök kategori, çalıştırdığı beyin bölgeleri ve kanıt düzeyiyle. Bu liste 3D beyin gelince sahnenin metin alternatifi olur (BRAIN-6).
- Profil sekmesi ayarları tutar: dil, görünüm, uyku, konum, namaz vakitleri, bildirim, parça ayarları.
- "Odaklan" butonu odak oturumu ekranıyla birlikte gelecek. Şimdilik odak gerektiren işte yalnız bir etiket görünür.

**Neden:** Proje sahibinin seçimi. İşlevsiz buton yasak (CLAUDE.md kural 3) ve odak ekranı henüz yok.
**Durum:** Kabul.

## 2026-11-18 — D26: Tema bu aşamada
**Karar:** Tek bir taban Material 3 teması var (tohum renk `#5B57D9`). Görünüm açık, koyu ya da cihazla aynı olur; varsayılan sistem fontu kullanılır. Ciddi / Eğlenceli / Genç / Kodcu temaları ve font testi tema aşamasında eklenecek; ilk kurulumdaki görünüm adımı o zaman tema seçeneklerini kazanacak.
**Neden:** Proje sahibinin seçimi; font kararı gerçek cihaz testine bağlı (D10).
**Durum:** Geçici.

## 2026-11-18 — D27: Bildirim, ana ekran widget'ı, cihaz tercihleri
**Karar:**
- **Sıradaki iş bildirimi varsayılan olarak kapalıdır.** Kullanıcı Profil'de kaç dakika önce geleceğini seçer; Android 13+ bildirim izni o anda istenir, açılışta değil.
- **Zamanlama varsayılan olarak esnektir** (`inexactAllowWhileIdle`). "Tam zamanında" anahtarı `SCHEDULE_EXACT_ALARM` iznini sistem ayarlarından ister.
- Plan değiştikçe önümüzdeki 7 günün saatli işleri için en çok 50 bildirim yeniden kurulur. Uygulama 7 gün açılmazsa bildirimler biter (`shortcut:` notu).
- **Widget** "Sıradaki: X · 14:30 · 15 dk sonra" gösterir (`home_widget` + Kotlin `NextUpWidgetProvider`).
  - Metin kalıpları ARB'den gelir, göreli süreyi Kotlin hesaplar.
  - Tazeleme `scheduleWidgetUpdates` iledir: 24 saat boyunca 15 dakikada bir ve her işin başlangıcında. Ayrı bir alarm kodu yoktur.
- Bildirim tercihleri cihaza özeldir, eşitlenmez. `sync_state` tablosunda `pref.*` anahtarlarıyla tutulur; şema değişmedi.

**Neden:** Proje sahibinin seçimi (esnek varsayılan + isteğe bağlı tam). `USE_EXACT_ALARM` Play incelemesi gerektirir. Android `compileSdk` 37'ye çıkarıldı: `flutter_local_notifications` 23, `androidx.core` 1.19 ister. `targetSdk` Flutter varsayılanında kaldı.
**Durum:** Kabul.

## 2026-11-18 — D28: Arayüz kabuğu
**Karar:**
- **Alt menü:** havada duran 4 sekmeli çubuk ve sağında ayrık, yuvarlak "Ekle" butonu. Sekmeler yalnız hedeftir, Ekle yalnız eylemdir (Material 3; ui-ux-pro-max `bottom-nav-top-level`, `primary-action`). Klavye açıkken ve sihirbazlarda gizlenir.
- **Material paketi:** Flutter 3.50'de Material ayrı paket oldu (`material_ui`) ve `flutter/material` kullanımdan kalktı. Uygulama yalnız `material_ui` kullanır; yerelleştirme `material_ui`'nin `GlobalMaterialLocalizations.delegates`'iyle kurulur. gen-l10n çıktısı eski kütüphaneye atıf verdiği için analizden hariçtir.
- **Geçişler:** `animations` paketi eski `flutter/material`'e bağlı olduğu için kullanılmadı. Shared axis (sihirbaz, alt sayfalar) ve fade through'nun giriş yarısı (sekmeler) `lib/app/transitions.dart`'ta Material 3 süre ve eğri tokenlarıyla yazıldı. Azaltılmış hareket açıksa anlık geçilir.
- **Okunur genişlik:** Geniş ekranda içerik 720dp'de ortalanır. Tablet düzeni (navigation rail) sonra gelecek.

**Durum:** Kabul.

## 2026-11-18 — D29: Sistem saat ve tarih seçicileri
**Karar:** `showTimePicker` / `showDatePicker` platformun giriş denetimi sayılır; UX_RULES §3'teki pop-up kısıtına girmez. "Yalnız bu sefer mi, her zaman mı?" sorusu iki seçenekli, akışı durduran bir karar olduğu için diyalogdur (§3'e uygun).
**Durum:** Kabul.

## 2026-11-18 — D30: Uyku penceresi
**Karar:** Uyku penceresi ayrı bir şema alanı değildir. Sıradan, kesin bir aktivitedir: Dinlenme ve Uyku kökünde, her gün, başlangıcı ve bitişi saat olan bir kural. Motor onu dolu blok olarak korur; otomatik yerleştirme oraya hiçbir şey koymaz. Profil ekranı bu izle bulup düzenler (`SleepWindow`). Sihirbazdan astronomik kalkışla kurulan uyku (S1) bu izle bulunmaz; Plan ekranından düzenlenir.
**Neden:** Motor açısından ayrı bir kavram gerekmiyor; şema ve migration değişmeden kalıyor.
**Durum:** Geçici. Birden çok uyku kuralı ya da seyahat modu gerekirse profile alan eklenir.

## 2026-11-19 — D31: Bozulan oturumun beyin cezası
**Karar:** Bozulan oturum `penalty` olayları üretir. Miktar, bozulmadan önce odaklanılan dakika × 1000 binde-birimdir ve kazançla aynı yöntemle (normalleştirilmiş ağırlık, "en büyük kalan") kök kategorinin bölgelerine dağıtılır. Ceza o kadar nöronu **söndürür, silmez**; sonraki tamamlanan oturumlar onları yeniden yakar. Pomodoro serisi de sıfırlanır. Bu aşamada olaylar yazılır; katlama (fold), bağlantılar, sönme ve 3D görünüm beyin aşamasındadır. Kazanç v1: tamamlanan oturumun her odak dakikası 1000 binde-birim `neuron_gain` (`packages/neuroplan_core/lib/src/brain/brain_engine.dart`).
**Neden:** Aşama 3 talimatı "ilgili bölgede bazı nöronlar söner, tekrar çalışılarak geri kazanılır" diyor; proje sahibi soru formunda "oturum süresi kadar söner"i seçti.
**Durum:** Kabul. **D20'nin "`penalty` olayı nöron ya da parlaklık düşürmez" maddesinin yerine geçer**; D20'nin öbür maddeleri geçerli.

## 2026-11-19 — D32: Zaman damgalı sayaç ve kurtarma
**Karar:**
- Sayaç tick saymaz. Oturum `focus_sessions.segments`'ta `{"kind":"work"|"break","start":ISO,"end":ISO|null}` dizisi olarak tutulur; her değer segmentlerden ve "şimdi"den hesaplanır (`FocusClock`, saf Dart).
- Faz sınırları (Pomodoro odak sonu, mola sonu) geç fark edilse de tam anında kapatılır. Uygulama saatler sonra açılırsa sayaç doğru fazda bulunur.
- Kesinti ve arama süresi odak segmentini böler: odak süresine girmez, kesintisiz süreyi sıfırlar. Ekran kapalıyken süre işler.
- Cihaza özel geçici durum (duraklatma türü, 10 sn kuralının durumu) `sync_state`'te `focus.runtime` anahtarındadır. Açılışta süren oturum ve bu durum okunur; dışarıdayken süre dolduysa oturum son tarih anında bozulur, dolmadıysa kaldığı yerden sürer.
- Son kullanılan Pomodoro / derin çalışma ayarları cihazda hatırlanır (`pref.focus_settings`). Varsayılanlar: 25/5, 4 döngüde bir 15 dk uzun mola; derin çalışma hedefi 90 dk.
- Derin çalışmada isteğe bağlı mola önerisi (ürün kuralı, bilimsel iddia değil): odak < 25 dk → 5, < 50 → 8, < 90 → 10, ≥ 90 → 15 dk.
**Durum:** Kabul. Şema değişmedi.

## 2026-11-19 — D33: Planı bozma algılama
**Karar:**
- Kural `EscapeGuard`'dadır (saf Dart, durum JSON'a yazılır). Platform olaylarını `FocusPlatform` arayüzü taşır (`lib/app/focus_platform.dart`); Android uygulaması `MainActivity.kt` + `FocusAlert.kt`. iOS sonra aynı arayüzle eklenir.
- **Uygulamadan çıkış:** `AppLifecycleState.hidden/paused`. **Bildirim paneli:** pencere odağının gitmesi (`onWindowFocusChanged`); uygulama arka plana geçmez. İkisi ayrı neden olarak kaydedilir (`app_left`, `notification_shade`); panelden başka uygulamaya geçilirse neden `app_left` olur, süre panelin açıldığı andan sayılır.
- Çıkıştan 750 ms sonra cihaza sorulur (ekran açık mı, arama var mı). Kaçışsa uyarı gider; son tarih yine çıkış anı + 10 sn.
- **İstisnalar (FOCUS-6 kapanışı):**
  - Ekran kapanması / kilit: çıkışla arasında ≤ 2 sn varsa `screen_off`, sayaç askıda, odak süresi işler. Kilit açılınca 10 sn başlar.
  - Gelen arama, telefon durumu izni verildiyse: `phone_call`, askıda; arama bitince 10 sn. Arama süresi odaktan düşülür.
  - İzin yoksa ses modu (`AudioManager.mode`, izinsiz) aramayı gösteriyorsa son tarihte bozulmaz; dönüşte "Aramadaymışsın, cezayı kaldırayım mı?" diye sorulur.
  - Molada, mola bitip "Devam" beklenirken ve acil durumda çıkmak serbest. Dışarıdayken son tarihten önce mola başladıysa da serbest.
  - Alarm uygulaması ayrıca algılanmaz; acil durum hakkı bunu karşılar.
- 1 sn'den kısa pencere odağı titremeleri kayda geçmez.
**Neden:** Talimat bu ayrımları ve iOS'a taşınabilir bir arayüzü istiyor. Emülatör davranışına güvenilmez; doğrulama `docs/QA_CHECKLIST.md` ile gerçek cihazda.
**Durum:** Kabul. Gerçek cihaz testi bekliyor.

## 2026-11-19 — D34: Duraklat, acil durum, mola sonu
**Karar:**
- **Duraklat** sayacı durdurur ama çıkma kuralı sürer.
- **Acil durum** sayacı durdurur ve çıkmayı serbest bırakır; günde 3 kez, cihaz başına (`focus.emergency`). Onay diyaloğuyla açılır, kalan hak görünür.
- **Mola bitince** bildirim gelir; sonraki odak bloğu kullanıcı "Devam" deyince başlar. Geç dönmek ceza değildir, aradaki süre odak sayılmaz.
- Oturum bitince iş otomatik "bitti" yapılmaz; Bugün'deki "Bitti" ayrı kalır.
**Neden:** Proje sahibinin soru formundaki seçimi.
**Durum:** Kabul.

## 2026-11-19 — D35: Ön plan servisi, uyarı bildirimi, DND, immersive
**Karar:**
- Kalıcı bildirim `flutter_local_notifications`'ın ön plan servisiyle gösterilir. Android 14 türü **`specialUse`** (alt tür `focus_timer`): zamanlayıcıya uyan başka tür yok. Play Console'da gerekçe beyanı gerekir. `stopWithTask=false`: uygulama son uygulamalardan süpürülse de süreç 10 sn uyarısını tamamlar. Bildirimde kalan süre (kronometre) ve "Duraklat / Devam / Bitir" var.
- **Kaçış uyarısı native'dedir** (`FocusAlert.kt`): üstten kayan, titreşimli, 10 sn geri sayan bildirim; dokununca uygulamaya dönülür. Süre dolunca aynı bildirimin yerine "Odak bozuldu" geçer, kalıcı bildirim kapanır, DND geri yüklenir. Flutter motoru ölse de çalışsın diye native'de. Heads-up görünme süresini sistem belirler; bildirim panelde geri saymaya devam eder.
- **Rahatsız Etmeyin** isteğe bağlı (Profil → Odak). Önceki filtre native `SharedPreferences`'ta tutulur; bitişte, bozulmada ve açılışta (oturum yoksa) geri yüklenir. DND erişimi varsa uyarı kanalı DND'yi aşar (ayrı kanal kimliği).
- Odak ekranı immersive'dir (sistem çubukları gizli).
- **Uygulama sabitleme yok.** Android sıradan bir uygulamanın başka uygulamaları engellemesine izin vermiyor; tek resmi yol olan "uygulama sabitleme" (her oturumda sistem onayı ister, kullanıcı bir hareketle çıkabilir) proje sahibi tarafından seçilmedi. Koruma uyarı + 10 sn kuralıdır.
- Sıradaki iş eşitlemesi artık yalnız zamanlanmış bildirimleri siler (`cancelAllPendingNotifications`); gösterilen odak bildirimlerine dokunmaz. Bildirim eklentisi tek yerden başlatılır (`lib/app/notifications.dart`).
**Durum:** Kabul. `specialUse` beyanı ilk Play yüklemesinden önce yapılacak.

**D25 kapanışı (2026-11-19):** "Odaklan" butonu geldi: odak gerektiren bugünkü işin açılan eylemlerinde.
