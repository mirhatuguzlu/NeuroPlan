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
**Karar:** Supabase URL ve anon/publishable key `.env` dosyasında (git-ignored), örnek `.env.example`'da. Uygulamaya `flutter run --dart-define-from-file=.env` ile verilir, kodda `String.fromEnvironment` ile okunur. `flutter_dotenv` kullanılmaz. *(2026-11-20: D52 ile değişti; Android derlemesi `.env` dosyasını kendisi okur.)*
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
- **2026-11-20 eki:** `andrej-karpathy-skills` plugin'i (multica-ai/andrej-karpathy-skills, MIT) aynı kapsamda eklendi: `karpathy-guidelines` skill'i (önce düşün, sadelik, cerrahi değişiklik, doğrulanabilir hedef). Proje kuralları (CLAUDE.md, docs/) çakışmada önceliklidir.
- **2026-11-20 eki:** `superpowers` plugin'i (obra/superpowers, resmi `claude-plugins-official` marketplace'inden) aynı kapsamda eklendi: 14 iş akışı skill'i (brainstorming, writing-plans, TDD, systematic-debugging, verification-before-completion vb.) ve her oturum başında `using-superpowers`'ı yükleyen bir SessionStart hook'u. Proje kuralları çakışmada önceliklidir.
- **2026-11-20 eki:** `mattpocock-skills` plugin'i (mattpocock/skills, MIT, resmi marketplace'ten) aynı kapsamda eklendi: 27 skill (grill-me, grill-with-docs, tdd, to-spec, to-tickets, code-review, diagnosing-bugs vb.). Hook yok. Repo başına `/setup-matt-pocock-skills` henüz çalıştırılmadı (iş takipçisi, etiketler, belge yeri sorar). Proje kuralları çakışmada önceliklidir.
- **2026-11-20 eki:** `ecc` plugin'i (affaan-m/ECC, eski adı everything-claude-code, MIT) aynı kapsamda eklendi: 72 agent, 328 skill, komutlar. **Hook'ları kapalı** (`ECC_HOOKS_ENABLED=false`, kullanıcı `settings.json` → `env`). Neden: hook'lar her araç çağrısında çalışıp işlemi durdurabiliyor, kendi hafıza ve oturum özeti sistemi superpowers, ponytail ve mevcut hafızayla çakışıyor. Plugin `rules` dağıtamadığı için ECC kural paketleri kurulmadı. Proje kuralları çakışmada önceliklidir.

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
**Durum:** D54 ile değişti (temalar Aşama 5'te yapıldı).

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

## 2026-11-19 — D36: Odakta uygulama sabitleme
**Karar:** Odak bloğu başlayınca uygulama Android'in **uygulama sabitleme** özelliğiyle sabitlenir (`startLockTask`). Sabitliyken ana ekran, son uygulamalar ve bildirim paneli kapalıdır; üstte başka uygulama açılamaz.
- Android her sabitlemede kullanıcıdan onay ister; kullanıcı bir hareketle (geri + son uygulamalar basılı tutma ya da yukarı kaydırıp tutma) çıkabilir. Çıkıp uygulamadan ayrılırsa 10 sn kuralı işler.
- Sabitleme kuralla birlikte açılır: odakta ve normal duraklatmada açık; molada, mola sonunda ve acil durumda kalkar (çıkmak serbest olsun diye); odak yeniden başlayınca yeniden istenir. Oturum bitince ya da bozulunca kalkar. Uygulama yeniden açıldığında oturum sürüyorsa yeniden istenir.
- Onay penceresi pencere odağını aldığı için, sabitleme istendikten sonraki 30 sn içinde pencere odağı geri gelene kadar odak kaybı kaçış sayılmaz.
- Sabitlemeden PIN ile çıkışta kilit ekranı açılır; kilit ekranı ekran kapanması gibi askıya alınır, kilit açılınca 10 sn başlar.
- Sabitleme ayarı kapalıysa ya da kullanıcı onaylamazsa oturum yine sürer; koruma uyarı + 10 sn kuralıdır.
**Neden:** Proje sahibi önce "yalnız uyarı"yı seçti, sonra "uygulama sabitlensin" dedi. "Her oturumda" biçimi uygulandı (ayar anahtarı yok).
**Durum:** Kabul. **D35'teki "Uygulama sabitleme yok" maddesinin yerine geçer.** Gerçek cihaz testi bekliyor (Xiaomi / HyperOS sabitleme davranışı dahil).

## 2026-11-19 — D37: 3D beyin modeli ve lisansı
**Karar:** Model BodyParts3D 4.0'dan (DBCLS) üretilir. DBCLS'nin güncel README'si (2025-02-27) veriyi **CC BY 4.0** ile lisanslıyor: ticari kullanım serbest, yalnız atıf. Atıf metni Hakkında ekranında ve lisans sayfasında: "BodyParts3D, © The Database Center for Life Science licensed under CC Attribution 4.0 International". Ham OBJ repoya girmez; türetilen model `tool/brain/model/brain.glb` ve paket `assets/brain/brain.js` girer. Three.js MIT lisansı da lisans sayfasındadır.
- `partof` arşivinde amigdala, korpus kallozum, kaudat, putamen ve üst temporal girus yok; bunlar aynı kaynağın `isa` arşivinden alındı (aynı lisans).
- Orbital girus dosyalarının sol/sağ ayrımı adda yok; derleme betiği x işaretiyle doğrular.
**Neden:** Proje sahibi soru formunda BodyParts3D'yi seçti. Z-Anatomy (CC BY-SA 4.0) ShareAlike yükü ve NC lisanslı alt parçaları yüzünden seçilmedi.
**Durum:** Kabul. **Açık nokta:** 2011 tarihli OBJ dosyalarının başlığında eski lisans (CC BY-SA 2.1 JP) yazıyor; güncel README bunun yerine geçiyor. BY-SA geçerli sayılsa da ticari kullanım serbesttir, yalnız türetilmiş model dosyası aynı lisansla paylaşılır (repo zaten açık). Yayın öncesi hukuk kontrolüne eklendi.

## 2026-11-19 — D38: Beyin bölgeleri anatomik oldu
**Karar:** `brain_regions` 20 işlevsel bölgeden 18 anatomik bölgeye geçti: frontal (motor alanlar), prefrontal, parietal, temporal, oksipital (sağ/sol ayrı), beyincik, beyin sapı, korpus kallozum, singulat, insula, striatum, hipokampüs, amigdala. Son altısı yarı saydam iç yapıdır (`is_inner`). Mesh adları bölgelerle birebir (`region_<key>`).
- İşlevsel alt bölge adı (DLPFC, STS…) `category_region_weights.detail_tr/en` metninde kalır ve bölge sayfasında gösterilir. Eşleme tablosu DB_SCHEMA §2.3'te. Aynı hücreye düşen satırlarda en yüksek kanıt düzeyi alınır, kaynaklar birleşir. S5 (müzik) yalnız sağ frontal'e bağlandı; kaynak sağ presantral girus diyor.
- Supabase: `20261119120000_brain_regions_v2.sql` (sütunlar + eski satırları silme) ve `20261119120100_system_seed_v2.sql` (üretilmiş seed). Eski seed migration'ına dokunulmadı.
- Drift `schemaVersion 2`: yeni sütunlar, v1 beyin olayları + outbox kayıtları + anlık görüntü silinir, bölgeler yeniden seed edilir; açılışta olaylar oturumlardan yeniden türetilir. Sunucu eşitlemesi henüz yazılmadığı için silinen olay sunucuya hiç gitmemişti.
**Neden:** Proje sahibi "mesh adları brain_regions ile birebir" istedi ve soru formunda anatomik bölgeleri seçti; işlevsel bölgelerin çoğu (dACC, TPJ, STS…) modelde ayrı parça değil.
**Durum:** Kabul. Uzak Supabase'e iki yeni migration uygulanmadı (ayrı onay).

## 2026-11-19 — D39: Beyin büyüme kuralları v2
**Karar:** Kurallar ve sabitler docs/BRAIN_MODEL.md §2'de; sabitler tek dosyada (`brain_config.dart`). Özeti:
- Kazanç = odak dakikası × 1000 × odak çarpanı × (1 + Pomodoro ekleri). **Odak çarpanı ölçülen kesintiden gelir** (geri dönülen her sayılan kaçış −%10, taban %60), kullanıcının 1–5 puanından değil.
- Pomodoro: döngü başına +%5 (≤ %20), haftalık süreklilikte ek gün başına +%3 (≤ %18); bozulma seriyi sıfırlar. Derin çalışma: en uzun kesintisiz dakika × 20 bağ kalınlaşması.
- Bağlantılar: art arda günlerde aynı kategori bölge içi bağ; aynı gün farklı kategoriler bölgeler arası bağ.
- Ceza D31 gibi: bozulan oturum o kadar nöronu söndürür; sonraki kazanç önce sönükleri yakar. Hiçbir nöron silinmez.
- **Sönme olaysızdır:** parlaklık katlamada son kazançtan geçen süreyle hesaplanır (yarılanma 14 gün, taban %25). `fade` olayı üretilmez; şemadaki tür yerinde durur.
- Motor sürümü 2. Olaylar `derive(oturum, son 7 günün oturumları)` ile türetilir; motor saat okumaz. JSON test vektörü sunucu eşliği için.
**Neden:** Aşama 4 talimatı; odak puanı kaynağı soru formundan.
**Durum:** Geçici. Proje sahibi sabitleri sonra ayarlayacağını söyledi; değişince sürüm artar ve olaylar yeniden türetilir.

## 2026-11-19 — D40: Sahne paketi ve köprü
**Karar:**
- Three.js r187, sahne ve GLB, esbuild ile tek klasik betik (`assets/brain/brain.js`, ~1,2 MB). WebView sahneyi `file://` altında açar; orada ES modülü ve `fetch` çalışmadığı için her şey tek dosyadadır. Sıkıştırma meshopt (çözücüsü JS'in içinde); Draco seçilmedi.
- Köprü mesajları tipli ve sürümlü (`v: 1`), ARCHITECTURE §8. Dart sealed sınıflar + JS ayrıştırıcı, ikisi de testli.
- Tek WebView: uygulama kabuğu ilk karede kurar (ön ısıtma). Görünmezken (başka sekme, üstte sayfa, arka plan) çizim durur.
- Kalite kademesi Dart'ta seçilir (`QualityGovernor`): donanım ipuçlarından başlar, düşük fps raporlarında iner, geri yükselmez.
- Nöron yerleşiminin tohumu kurulum başına rastgele kimliktir (giriş yok); `shortcut:` notu, giriş aşamasında Supabase kullanıcı kimliğine geçilecek.
- WebGL çizgi kalınlığı 1 px olduğundan güçlü bağ daha çok paralel şerit ve daha parlak çizilir.
**Durum:** Kabul.

## 2026-11-19 — D41: Beyin sekmesi düzeni
**Karar:**
- Beyin sekmesi 3D sahneyle açılır. Üstte "Liste görünümü" (metin alternatifi: bölgeler, nöron sayısı, parlaklık) ve "Görünümü sıfırla" düğmeleri; altta zaman çizelgesi kaydırıcısı (ilk olaydan bugüne, gün adımlı). Ekran okuyucu açıkken sekme doğrudan listeyi gösterir.
- Kategori ağacı Liste görünümünden "Kategoriler" satırıyla açılır (D25'teki Beyin sekmesi içeriği buraya taşındı).
- Bölgeye dokununca **ayrı sayfa görünümü**: üstte aynı sahne o bölgeye yaklaşır, beynin geri kalanı silik; altta ad, yarımküre, nöron / parlaklık, son 30 gün grafiği, seni besleyen kategoriler ve kanıt satırları. Geri tuşu genel görünüme döner. WebView yeniden yaratılmaz.
- Sahne her zaman koyudur: neon ışıma koyu zeminde okunur. Açık görünümde aktif temanın koyu eşi kullanılır (Geçici; tema aşamasında her temanın sahne renkleri ayrıca tanımlanacak).
- Profil'e "Hakkında" bölümü eklendi: lisans ve atıflar.
**Neden:** Proje sahibinin soru formu seçimleri (liste düğmesi, bölge sayfası).
**Durum:** Kabul (sahne renkleri Geçici).

**D25 güncellemesi (2026-11-19):** Beyin sekmesi artık 3D sahnedir; kategori listesi metin alternatifinin altına taşındı (D41).

## 2026-11-19 — D42: Aşama 4B kapsamı, giriş ve eşitleme
**Karar:** Sosyal özelliklerden önce giriş ve eşitlemenin sunucu tarafı yazıldı.
- `supabase_flutter` (Supabase yalnız `.env` doluysa başlar; yoksa uygulama yalnız cihazda çalışır), `google_sign_in` 7 (Credential Manager). İlk açılışta misafir (anonim) oturum açılır; Google bağlanınca `linkIdentityWithIdToken` aynı kullanıcıyı kalıcı yapar. Google hesabı başka kullanıcıya bağlıysa o hesaba geçilir ve `SyncEngine.adoptUser` yerel satırların hepsini yeni kullanıcıya göndermek üzere outbox'a yeniden yazar, imleci sıfırlar.
- `SupabaseSyncRemote` + `SyncScheduler`: yazmadan 2 sn sonra, açılışta, ön plana dönüşte, 5 dk'da bir; hatada 5 sn → 15 dk üstel bekleme (D16'daki açık iş kapandı).
- İlk kurulumda **doğum yılı adımı** (AUTH-2 eksikti): atlanamaz, en düşük olası yaş 13'ün altındaysa devam edilemez. Sunucuda doğum yılı yalnız geriye alınabilir (tetikleyici); yaş küçültülemez.
- Hesap silme: `delete_account` Edge Function + Profil → Hesap → "Hesabı ve verileri sil" (AUTH-3); yerel veritabanı da silinir.
**Neden:** Proje sahibinin soru formu seçimi ("önce giriş + eşitleme"). Sıralama, sunucu beyni ve partner planı sunucudaki veriyi okur.
**Durum:** Kabul. `shortcut:` eski misafir kullanıcı hesap değiştirince sunucuda kalır; zamanlanmış temizlik sonra.

## 2026-11-19 — D43: Sosyal yaş politikası
**Karar:** Sosyal özellikler 15 yaş ve üstüne açıktır (en düşük olası yaş; yalnız doğum yılı tutulur). 13–14 yaşta Birlikte sekmesi "15 yaşında açılır" der. 15–17 sıkı moddadır: genel sıralama açılamaz, süreklilik (seri) metriği gösterilmez, kullanıcı adıyla bulunabilirlik kapalı başlar. Veli onayı alınmaz. Kurallar sunucuda (`social_tier`, `require_social`) uygulanır.
**Neden:** 5651 ek m.4 (15 yaş, 1 Kasım 2026), DSA m.28 kılavuzu, KVKK/GDPR riskleri (docs/SOCIAL_SAFETY.md). Proje sahibinin seçimi.
**Durum:** Kabul. Yayın öncesi hukuk kontrolü gerekir (SOCIAL_SAFETY §7).

## 2026-11-19 — D44: Plan görünürlüğü ve yayınlanan takvim
**Karar:**
- Plan motoru cihazda çalıştığı için (D22) cihaz önümüzdeki **14 günün** saatli oluşumlarını `publish_calendar` ile `calendar_blocks` tablosuna yayınlar: yalnız zaman ve aktivite kimliği. Başlık, not ve kategori `activities`'ten görünürlük kuralıyla birleştirilir; tabloyu yalnız sahibi okur. `friend_calendar` artık bu tablodan okur.
- Kural yoksa varsayılan: **partner "başlık ve saat", diğer arkadaşlar "meşgul"** (Geçici). Talimat "varsayılan başlık ve saat" diyor; gizlilik önceliği nedeniyle partner dışındaki arkadaşlara bir düzey daha sıkı başlatıldı. Kullanıcı Gizlilik ekranından değiştirir.
- Kişi istisnası `visibility_settings.viewer_id` ("bu kişiye tam göster").
- `common_free_time` gizli işleri de dolu sayar, yalnız boş aralık döner; herkesin takvimini yayınlamış olması gerekir.
**Durum:** Kabul. Arkadaş varsayılanı ("meşgul") ve ortak odakta en çok 4 kişi proje sahibince 2026-11-19 onaylandı.

## 2026-11-19 — D45: Sosyal veritabanı ilkeleri
**Karar:**
- İstemci sosyal tablolara doğrudan yazamaz (eski yazma politikaları kaldırıldı); her yazma `security definer` RPC'dir ve yaşı, misafirliği, arkadaşlığı, engeli, hız sınırını denetler. Hata kodları: NP001/NP404/NP409/NP412/NP429.
- **Tek partner** `partner_slots` tablosunun birincil anahtarıyla garanti edilir (her partnerlik iki satır; yarışta da ikinci partner reddedilir).
- Engel her şeyi keser; engellenen kişi eski mesajları da göremez (`conversation_open`), davet "geçersiz kod" döner (bilgi sızmaz).
- Hız sınırı: mesaj 20/dk–300/sa, davet 5/dk–30/sa, kod kullanma 5/dk–20/sa, şikâyet 10/dk–50/sa (`social_rate_events`).
- Küfür filtresi sunucuda (`mask_profanity`, `profanity_terms`): eşleşen kelime yıldızlanır, mesaj gider (proje sahibinin seçimi). Kısa kökler yalnız tam kelimede eşleşir.
- Şikâyet mesajın kopyasını saklar; moderasyon Supabase Studio'da `moderation_queue` + `resolve_report` (moderatör tablosu) ile yapılır.
**Durum:** Kabul. Testler: `supabase/tests/social_test.sql`, `social_safety_test.sql`.

## 2026-11-19 — D46: Ses altyapısı (D21 kapanışı)
**Karar:** LiveKit Cloud (`livekit_client` 2.14). Token `voice_token` Edge Function'ında üretilir; yalnız katılmış katılımcı, ses açık oturum ve sosyal uygun kullanıcı alır. Token'da kayıt/egress yetkisi yoktur. Mikrofon varsayılan kapalı; açılınca odak ön plan servisine `microphone` türü eklenir (Android 14, uygulama öndeyken). Kişiyi sessize almak yalnız dinleyenin cihazında aboneliği kapatır.
**Neden:** Proje sahibinin seçimi; açık kaynak sunucu, aynı SDK ile kendi sunucuya geçilebilir. Karşılaştırma SOCIAL_SAFETY §6.
**Durum:** Kabul. LiveKit projesi ve Edge Function sırları (`LIVEKIT_URL`, `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET`) proje sahibinde; KVKK m.9 standart sözleşmesi gerekir.

## 2026-11-19 — D47: Ortak odak, sıralama, sunucu beyni
**Karar:**
- Ortak odak en çok 4 kişi. Başlatan başlatınca sunucu anı herkesin başlangıcıdır (`FocusController.start(startAt:)`, cihaz saat farkı gidiş-dönüşle düzeltilir). Herkes kendi işini ve modunu seçer. Realtime özel kanal `cofocus:<id>` (RLS'li presence + broadcast); biri bozarsa diğerlerinin odak ekranında satır içi sakin not.
- Ortak tamamlanan oturum bonusu: `cofocusLink = 200` bağlantı, kategorinin bölge çiftlerine (BRAIN_MODEL §2.1). Motor sürümü değişmedi: kural yalnız yeni veriyi etkiler.
- Sıralama: arkadaş tablosu canlı SQL (`friends_leaderboard`), genel tablo `pg_cron` ile 30 dk'da bir tazelenir; yalnız katılmayı seçen yetişkinler. Metrikler odak dakikası ve süreklilik (aktif gün). Hafta pazartesi sıfırlanır. Doğrulama: tamamlanmış, gerçek süreden uzun değil, gelecekte bitmeyen, sunucuya 7 günden geç gelmeyen, kişinin başka oturumuyla çakışmayan; günde 16 saati aşan gün sayılmaz. Plana uyum sunucuda doğrulanamadığı için alınmadı.
- Sunucu beyni: `brain_snapshot` Edge Function, `neuroplan_core`'un `dart compile js` çıktısını (Deno'da çalıştığı doğrulandı) `brain_input` SQL'inin verisiyle çalıştırır. ARCHITECTURE §11 risk 1 kapandı.
**Durum:** Kabul.

## 2026-11-19 — D48: Birlikte sekmesi ve beyin karşılaştırma
**Karar:** Alt menüye 5. sekme "Birlikte" (`diversity_3`), bekleyen iş varsa rozet. Sekme önce kapıyı gösterir (sunucu yok / misafir / yaş / takma ad / askı), sonra tek amaçlı ekranlara giriş listesi. Beyin karşılaştırma ayrı WebView açmaz: Beyin sekmesinde bölge sayfası gibi bir alt panel; sahne iki beyni yan yana çizer (köprüye `compare` mesajı, JS ikinci beyni aynı kabuk geometrisiyle kurar).
**Neden:** Proje sahibinin seçimi (5. sekme); tek WebView ilkesi (D40).
**Durum:** Kabul.

## 2026-11-19 — D49: Mesaj push bildirimi ve web'den hesap silme
**Karar:**
- **Push (FCM):** mesaj eklenince veritabanı tetikleyicisi `pg_net` ile `push_message` Edge Function'ını çağırır; adres ve paylaşılan sır Supabase Vault'tadır (yoksa tetikleyici hiçbir şey yapmaz, mesaj yine gider). Fonksiyon FCM HTTP v1'e servis hesabıyla (RS256 JWT, Web Crypto) gönderir. Bildirim mesaj metnini içermez ("X sana mesaj gönderdi"), alıcının dilindedir. Sessize alınmış sohbete, engelli / arkadaş olmayan alıcıya ve **o anda odak oturumunda olan** alıcıya gönderilmez (son 6 saatte başlamış `in_progress` oturum). Geçersiz cihaz kimlikleri silinir.
- İstemci Firebase'i `.env`'deki dört değerle başlatır; google-services.json ve Gradle eklentisi yoktur, ayar boşsa push kapalıdır ve uygulama derlenir. Push açıkken arka planda yerel mesaj bildirimi gösterilmez (çift bildirim olmasın); odak sonrası özet yerel kalır. Bildirime dokununca sohbet açılır.
- `firebase_messaging` 17'nin yeni `register()` API'si kurulum kimliği (FID) döndürüyor; sunucu kayıt kimliğine gönderdiği için eski `getToken` kullanılıyor (`shortcut:` notu).
- **Web'den silme:** `docs/account-deletion/` statik sayfa (GitHub Pages `/docs`'tan yayımlanabilir). Uygulama içi yol her zaman, e-posta yolu adres verilirse, "Google ile giriş yap ve sil" yolu Supabase ayarı verilirse görünür; ayar dosyası `config.js` git-ignored. Gizlilik politikası taslağı `docs/legal/privacy_policy.md`.
- Sohbet artık yalnız değişen konuşmayı yeniden yükler (impeccable denetimi P2).
**Neden:** Proje sahibi "yapılmayanları da yap" dedi; Play hesap silme için uygulama dışı bir yol ister.
**Durum:** Kabul. Kurulum adımları [SETUP_BACKEND.md](SETUP_BACKEND.md); gerçek cihazda doğrulama QA_CHECKLIST C12–C13.

## 2026-11-19 — D50: Bildirim izni kurulumda açıklamalı adımla; Google girişi uygulama içinde
**Karar:**
- **Bildirim izni:** İlk kurulumda "ilk rutin"den önce ayrı bir adım ne için bildirim gönderildiğini anlatır (sıradaki iş, odak oturumu, arkadaş mesajı; mesaj içeriği görünmez) ve "Bildirimlere izin ver" düğmesiyle sistem penceresini açar. İzin verilir ve sıradaki iş bildirimi kapalıysa 10 dk önceye açılır. Adım atlanabilir. Açıklamasız (soğuk) istek kaldırıldı: push başlarken artık izin istenmiyor; cihaz kimliği izinsiz de alınır, bildirim izin gelince görünür.
- Sistem penceresi çıkmazsa (iki kez reddedilmiş ya da Android 12 ve altında kapatılmış) uygulamanın bildirim ayarı açılır. Profil → Bildirimler'de izin kapalıyken "Bildirimler kapalı · Aç" satırı görünür; ayardan dönünce durum yeniden okunur.
- **Google girişi:** `google_sign_in` 7 Android'de Credential Manager kullanır: hesap seçici sistemin alttan açılan penceresidir, tarayıcıya yönlenmez. Bu, Android istemcisinin (paket adı + SHA-1) Google Cloud'da kayıtlı olmasını ve Supabase'de "Skip nonce checks"in açık olmasını gerektirir. Web'den silme sayfası tarayıcıda çalıştığı için yalnız orada OAuth yönlendirmesi vardır.
**Neden:** Proje sahibi bildirimlerin uygulama içinde açtırılmasını ve Google girişinin tarayıcıya gitmeden yapılmasını istedi. Açıklamalı istek reddedilme oranını düşürür; Android 13+ izni ilk reddedilişten sonra bir kez daha sorar, sonra yalnız ayar yolu kalır.
**Durum:** Kabul. Gerçek cihazda doğrulama QA_CHECKLIST C14.

## 2026-11-20 — D51: Tanıtım sitesi ve hesap silme sayfasının yeri
**Karar:**
- Uygulamanın tanıtım sayfası en son aşamada `https://mirhatuguzlu.github.io/NeuroPlan/` adresinde yayınlanacak.
- Hesap silme sayfası bu sitenin içinde kalır ve adresi değişmez: `/NeuroPlan/account-deletion/`. Menüde öne çıkarılmaz; yalnız alt bilgide (footer) "Hesap silme" bağlantısı olarak durur, gizlilik ve topluluk kuralları bağlantılarının yanında.
- Silme sayfası şimdiden bu adreste yayımlanabilir. Play Console'a girilen adres tanıtım sitesi gelince de çalışır.
- Tanıtım sitesi yapılırken iç belgelerin (DECISIONS vb.) web'de görünüp görünmeyeceği yeniden düşünülecek. Seçenek: Pages kaynağını `/docs` yerine yalnız site dosyalarını yayımlayan bir GitHub Actions iş akışına taşımak.
**Neden:** Proje sahibinin isteği. Silme yolu Play için erişilebilir olmalı ama tanıtım sayfasında öne çıkması gerekmez. Adres sabit kalırsa Play beyanı yeniden yapılmaz.
**Durum:** Planlanan (son aşama).
- **2026-11-20 eki:** Silme sayfasının `config.js`'i (Supabase URL, publishable key, iletişim e-postası) GitHub Pages'te yayımlanmak üzere repoya alındı; `.gitignore` satırı kaldırıldı. CLAUDE.md kural 7'nin istisnası: bu değerler zaten herkese açık tasarlanmıştır, secret key yoktur, güvenliği RLS sağlar. `config.example.js` boş şablon olarak kalır.

## 2026-11-20 — D52: `.env` Android derlemesince okunur; `--dart-define-from-file` gerekmez
**Karar:**
- `android/app/build.gradle.kts` her derlemede kökteki git-ignored `.env` dosyasını okur. Yalnız beyaz listedeki yedi anahtarı (`SUPABASE_URL`, `SUPABASE_ANON_KEY`, `GOOGLE_WEB_CLIENT_ID`, dört `FIREBASE_*`) `BuildConfig.ENV` olarak APK'ya gömer. Beyaz liste, `.env` dosyasına yanlışlıkla yazılmış gizli bir anahtarın APK'ya girmesini önler.
- Dart açılışta `Env.load()` ile değerleri `neuroplan/focus` kanalının `env` çağrısıyla alır; `Env` alanları artık derleme sabiti değil, okunan değerdir. `.env` yoksa değerler boştur ve uygulama yalnız cihazda çalışır.
- `flutter run`, Android Studio ▶ ve `flutter build apk` ek bayrak istemez. Değerler zaten APK'daydı (dart-define da gömüyordu); güvenlik modeli değişmez, RLS korur.
- iOS aşamasında Runner aynı `env` çağrısını karşılayacak (`shortcut:` notu `lib/app/env.dart` içinde).
**Neden:** Proje sahibi uygulamayı her başlatışta bayrak verme zorunluluğunun kaldırılmasını istedi; bayraksız başlatılan uygulama sessizce sunucusuz açılıyor ve Google girişi görünmüyordu.
**Durum:** Kabul. Bayraksız `flutter run` ile gerçek cihazda doğrulandı (ayarlar dolu, Google oturumu korunuyor).

## 2026-11-20 — D53: Aşama 4B kapanışı; Play ve hukuk süreçleri yayın öncesine
**Karar:**
- Play Console beyanları, KVKK standart sözleşmeleri ve hukuk metinlerinin avukat incelemesi (SETUP_BACKEND §10) Google Play'de yayından hemen önceye bırakıldı. Taslaklar `docs/legal/` altında hazır.
- Misafirken var olan bir Google hesabına geçilince eski misafir hesabı sunucuda sahipsiz kalıyordu. Artık geçişten hemen sonra eski misafirin hâlâ geçerli belirteciyle `delete_account` çağrılır; verisi zaten cihazdan yeni kullanıcıya gönderilmektedir (D17, `SyncEngine.adoptUser`). Silme başarısız olursa yalnız günlüğe yazılır.
- Beyin nöron yerleşiminin tohumu, oturum varsa kullanıcı kimliğidir; aynı hesabın beyni her cihazda aynı görünür. Hesapsız kurulumda kurulum başına rastgele tohum sürer.
**Neden:** Proje sahibi aşamanın açıklarının kapatılmasını, Play ve hukuk işlerinin yayın öncesine kalmasını istedi.
**Durum:** Kabul. İki cihazlı QA (QA_CHECKLIST C) proje sahibinde.

## 2026-11-20 — D54: Aşama 5 — Profil, analiz ve temalar
**Karar (proje sahibinin seçimleri):**
- **Grafik:** `fl_chart` 1.3 çizgi ve sütun grafikleri çizer (dokununca değer, renkler temadan). Isı haritası ve GitHub tarzı yıllık takvim fl_chart'ta olmadığı için kendi widget'larımızdır. fl_chart eski `flutter/material`'i içe aktarıyor ama yalnız çizer; bütün renkler açıkça verildiği için `material_ui` temasıyla çatışmaz.
- **Uyum yüzdesi iş sayısına göre:** geçmiş günlerde planlanan (taşınmamış) her oluşum bir iş, `done` olanlar yapılan. Uyku penceresi ve serbest zaman sayılmaz. Bugün henüz bitmediği için dahil değil. Planlananlar veritabanında değil kurallardan türediği için geçmiş aralık plan motoruyla yeniden kurulur (1 yıl ~0,5 sn): 31 günden uzun aralık ayrı isolate'te koşar ve sonuç plan verisi değişene dek bellekte kalır (`planHistoryProvider`). Diğer bütün analizler 1 yıllık sahte veride birlikte 36 ms tuttuğu için önbelleksizdir.
- **Seri:** en az bir tamamlanan odak oturumu olan gün (sıralamadaki "aktif gün" ile aynı, D47). Oturum bittiği güne yazılır. Bugün oturum yoksa dünkü seri sürer.
- **Uyku hedefi ayrı ayar:** uyku penceresi artık `sleep_goal_minutes`'i yazmaz. Boşsa hedef 8 saattir; planlanan uyku ortalaması 7 saatin altındaysa sakin bir not çıkar (tıbbi iddia yok). Değerler planlanan penceredir, ölçülen uyku değil.
- **Dışa aktarma ve rapor görseli** cihazda üretilir, sistem paylaşım menüsüyle verilir (`share_plus`, `path_provider`). JSON biçimi DB_SCHEMA §6.4'tür: eşitlenen bütün tablolar, tarihler ISO metin.
- **Temalar şimdi yapıldı (D26'nın yerine):** Ciddi (varsayılan, `profiles.theme = null`), Eğlenceli, Genç, Kodcu ve onaylanan üç ek tema Sakin, Yüksek Kontrast, Minimal (THEME-2). Her tema tohum renk + Material şema türü, font çifti, köşe yarıçapı ve ikon ağırlığı tanımlar. Yüksek Kontrast `contrastLevel: 1` ve kalın çerçeveler kullanır. Beyin sahnesi temanın koyu şemasından renk alır (THEME-4). İlk kurulumdaki görünüm adımında da tema seçilir.
- **Fontlar** github.com/google/fonts'tan (OFL) gömülü: Atkinson Hyperlegible Next (gövde, bütün temalar), Nunito (Eğlenceli başlık), Lexend (Genç), JetBrains Mono (Kodcu sayılar). Hepsi değişken font olduğu için ağırlık `wght` eksenine de yazılır (`weighted()`); koddaki ağırlık değişikliği bu yardımcıyla yapılır.

**Geçici kararlar (gece alındı, onay bekliyor):**
- Grafik paleti dataviz skill'inin doğrulanmış paletidir ve temaya göre değişmez: kategorik sıra renk körlüğü güvenliğinin kendisidir. Doğrulayıcı bütün temaların kart yüzeylerinde geçti; açık modda 2. ve 3. seri 3:1'in altında kaldığı için bu serileri kullanan her grafikte "Liste olarak göster" görünümü vardır. Sıralı ölçek tek renk (mavi), koyu modda çapa çevrilir.
- Adlı kategoriler (kök kategoriler, sebepler) tek renkli sıralı çubuklarla gösterilir; 9 kök için 9 renk kullanılmaz (dataviz: 8'den fazla kategorik renk yok, değere göre boyama yok).
- Aralık seçici: son 7 / 30 / 91 / 365 gün ve "tümü" (kurulum ya da ilk oturumdan). Seçim bütün sayfalarda ortaktır. Profil kartlarındaki "bu hafta" pazartesi–pazar haftasıdır.
- "En güçlü bölge" toplam nöronu en çok olan bölge. "Sönen bölge" parlaklığı bir yarılanmadan (14 gün) fazla düşmüş, nöronu olan bölge.
- Burn-down proje ekranıyla aynı ölçüyü kullanır: yapılan ve planlanan parçalar. Tahmin önce planlı parçalar ve önerilerden, yetmezse son 14 günün temposundan yapılır.
- En iyi odak saati: aynı iki saatlik dilimde en az 3 puanlı oturum; oturumun yerel başlangıç saati. Mod karşılaştırması her moddan en az 5 biten oturum ister; odak puanı farkı 0,3'ten küçükse "yakın" denir. Genel bir "daha iyi" iddiası yoktur (SCIENCE §4).
- Isı haritası ve yıllık takvim hücreleri 48 dp'den küçüktür (24 saat sütunu telefona sığmaz); aynı bilgi liste görünümünde ve tek cümlelik özette vardır.
- Temaların metin tonu (THEME-3) bu aşamada ayrışmadı; bütün temalar aynı metinleri kullanır.
- Kaynak künyeleri `assets/seed/sources.json`'da (SCIENCE §5'ten üretildi, S1–S22); künye çevrilmez, "et al." kullanılır.
**Durum:** Kabul (geçici maddeler onay bekliyor). D26 bu kararla kapandı.

## 2026-11-20 — D55: Temalar biçimle, renkle ve sesle ayrışır
**Karar (proje sahibinin isteği, D54'ün geçici maddelerini değiştirir):**
- **Görünüm dili (`Look`):** her tema kart, satır ve alt menü biçimini de belirler. Ciddi: tonlu kartlar. Eğlenceli: her kart, liste ikonu, istatistik kutusu ve rapor satırı paletten farklı bir renkle boyanır, alt menü renkli. Genç: doygun renk blokları ve belirgin kenar. Kodcu: dolgusuz, ince vurgu çerçeveli, keskin köşe. Sakin: düz, gölgesiz. Yüksek Kontrast: kalın çerçeve (değişmedi). Minimal: dolgusuz, saç teli çizgi. Renkli temalarda Bugün satırları işin kök rengiyle boyanır. Boya hafiftir, yazı onSurface kalır; kontrast her tema ve görünümde testlidir.
- **Grafik renkleri temaya göre:** her temanın kendi kategorik paleti ve sıralı rampası var. Paletler bir arama betiğiyle dataviz doğrulayıcısından geçirilerek seçildi (komşu çiftlerde renk körlüğü ΔE ≥ 8, normal görüşte ≥ 15, açık ve koyu). Sakin'in soluk tonlarıyla bu kapıları geçen bir sıra bulunamadı; Sakin, Minimal'in serisini paylaşır, rampası ve kök renkleri kendinedir.
- **Kök kategoriler 9 ayrı renk:** Ciddi sistem verisindeki renkleri kullanır; diğer temalarda paletin 8 rengi + temaya özgü dokuzuncu renk. Rozetler, sıralı çubuklar, odak ekranı ve 3D beyin bu renkleri kullanır. dataviz'in "8'den fazla kategorik renk yok" kuralı proje sahibinin isteğiyle esnetildi; kök renkleri her yerde ad ve ikonla birlikte durur, renk tek başına bilgi taşımaz.
- **Metin tonu:** beş ton. Ciddi, Yüksek Kontrast ve Minimal nötr tonu paylaşır; Sakin (yumuşak), Eğlenceli (sıcak, oyunbaz), Genç (enerjik, samimi) ve Kodcu (teknik esprili) kendi tonundadır. En görünür 26 metin (boş durumlar, hata ve kaydetme mesajları, ilk iş adımı, odak sonucu, analiz boşları) ARB'de `tone` seçimiyle yazıldı; çağrı `l.key(context.tone)`. Hiçbir tonda suçlama ya da sahte aciliyet yok (UX_RULES §10). Sosyal hata metinleri bağlamsız yardımcıda olduğu için nötr.
- **Duyarlı düzen:** profil kartları dar ekranda ya da büyük yazıda tek, telefonda iki, tablette dört sütun. Sıralı çubuk değerleri, lejant ve rapor satırları büyük yazıda alt satıra kayar. Isı haritası ve yıllık takvimde hücre başına dokunma yerine tek dokunma alanı vardır (hücreler 48 dp'den küçük; liste görünümü erişilebilir yoldur).
- **Test:** `test/ui/theme_matrix_test.dart` 7 tema × açık/koyu için bütün ana ekranları ve 12 analiz sayfasını gezer, her birinde kontrast, dokunma alanı ve etiket kurallarını çalıştırır. Ayrıca 320×640, 360×740 + yazı 1.6, yatay telefon, tablet ve açık katlanabilir boyutlarında taşma arar. `test/ui/theme_test.dart` paletlerin, 9 kök renginin ve tonların temaya göre ayrıştığını doğrular.
**Durum:** Kabul.

## 2026-11-20 — D56: Tema token yapısı, üç yeni tema, önizlemeli seçici
**Karar (proje sahibinin seçimleri):**
- `AppTheme` tek tanım olarak kalır ve tokenları genişler: hareket (`Motion`: hız çarpanı + eğri karakteri), tip ölçeği, dokunma alanı, şema türü, koyu öncelik. Ayrıntı ve tema × token matrisi: [THEMES.md](THEMES.md).
- Yeni temalar (ui-ux-pro-max önerisi, proje sahibi üçünü de seçti): **Kâğıt** (akademik, e-mürekkep: kâğıt zemin, mürekkep çizgisi, anlık geçiş, başlık IBM Plex Sans), **Doğa** (topraksı, yavaş, başlık Nunito), **Gece** (gerçek siyah OLED, koyu öncelikli). Toplam on tema. Yeni metin tonu yok: Kâğıt ve Gece nötr, Doğa Sakin'in tonunu paylaşır.
- Tema seçici ayrı ekran ("Görünüm ve tema"): görünüm + her temanın canlı önizlemesi; dokununca anında uygulanır. Geçiş `themeAnimationDuration` (temanın hızı); renkler ve grafik paleti ara değer alır.
- Dokunsal geri bildirim tek yardımcıda (`Haptics`); iş bitince satırda tek seferlik işaret animasyonu.

**Geçici kararlar (gece alındı, onay bekliyor):**
- Grafik serileri: Kâğıt, Sakin ve Minimal'in sakin serisini; Gece, Ciddi'nin serisini paylaşır (rampa ve 9. kök rengi kendilerinin). Doğa'nın topraksı serisi arama betiğiyle bulundu ve iki modda doğrulayıcıyı uyarısız geçti.
- Eğlenceli: yazı 1,06×, dolu / çerçeveli düğme en az 56 dp, liste satırı 60 dp.
- Hareket çarpanları: sakin 0,8 · yumuşak 1,25 · canlı 1,0 · çevik 0,85 · anlık 0.
- Kodcu ve Gece "sistem" görünümünde koyu açılır; açık seçilirse açık kalır.
- Seçili tema `radio_button_checked` ile işaretlenir (`check_circle` "bitti" demektir).
**Durum:** Kabul (geçici maddeler onay bekliyor).

## 2026-11-20 — D57: Dil denetimi
**Karar:**
- `test/l10n/hardcoded_strings_test.dart` arayüz kodunda (`lib/ui`, `lib/app`) harf içeren düz dize arar (`Text('…')`, `tooltip:`, `label:` …); izinli özel adlar yalnız `Three.js` ve adresler. Boş `Text('')` da hata sayılır.
- `test/l10n/arb_test.dart`: TR ve EN aynı anahtarlar, aynı yer tutucular (ICU iç içe seçimleri dahil), 26 tonlu metnin beş tonu iki dilde, tema ve Eğlenceli metinlerinde "çocuk / child / kid" yok, tarih / saat / ondalık biçimleri dile göre.
- `test/l10n/science_l10n_test.dart`: kök kategori ad + açıklama, bölge adı, kategori–bölge ayrıntısı iki dilde dolu; kaynak kimlikleri geçerli.
- Düzeltilenler: yaş adımındaki boş metin, enlem / boylamın yerel ondalığı, mesaj ipucu ("dokun").
**Geçici:** depolardaki Türkçe istisna metinleri geliştirici içindir, arayüze çıkmaz (`guard` tonlu genel hata gösterir); çevrilmedi. "·" ve ":" gibi ayraçlarla birleştirilen metinler iki dilde aynı noktalamayı kullandığı için ARB'ye taşınmadı.
**Durum:** Kabul.

## 2026-11-20 — D58: Abonelik yayından önceye; özellik bayrakları şimdi
**Karar (proje sahibinin seçimi):**
- Abonelik altyapısının tamamı (sağlayıcı seçimi, satın alma, yetki servisi) Google Play yayınından önce ayrı bir adımda kurulacak. Bu aşamada abonelik kodu yazılmadı; `entitlements` tablosu (DB_SCHEMA §4.5) hazır bekliyor. Önerilen sağlayıcı RevenueCat'ti (makbuz doğrulama, yenileme, iOS'a aynı kod); karar o adımda verilecek.
- Özellik bayrakları: Supabase'de salt okunur `feature_flags` tablosu + kod varsayılanı (açık). Uygulama açılışta ve ön plana dönüşte okur, `sync_state`'te önbellekler. Bayraklar: `together`, `messages`, `cofocus`, `voice`, `leaderboard`, `brainCompare`, `crashReports`.
- Kapalı bölüm: Birlikte'nin tamamı kapalıysa açıklayan boş durum; alt özellik kapalıysa girişi görünmez (boş ya da işlevsiz düğme kalmaz).
**Durum:** Kabul. Migration `20261120180000_feature_flags.sql` proje sahibinin onayıyla 2026-11-20'de uzak Supabase'e uygulandı (RLS açık, `anon`/`authenticated` yalnız okur). Tablo boş; satır eklenene dek kod varsayılanı (açık) geçer.

## 2026-11-20 — D59: Çökme raporları Crashlytics; kullanım analitiği yok
**Karar (proje sahibinin seçimi):**
- Firebase Crashlytics (`firebase_crashlytics`): Firebase zaten projede, yeni veri işleyen eklenmez. `.env`'deki seçeneklerle başlatılır; hata ayıklama derlemesinde kapalı; kullanıcı kimliği, e-posta, plan içeriği eklenmez.
- Ayarlar → Veriler → "Çökme raporları gönder" (cihaza özel, varsayılan açık) ve `crashReports` bayrağı.
- Crashlytics Gradle eklentisi kullanılmaz (google-services.json yok, D52): derleme kimliği zorunluluğu `android/app/src/main/res/values/crashlytics.xml` ile kapatıldı. Bedeli: R8 eşleme dosyası yüklenmez (küçültme kapalı olduğu için şimdilik etkisi yok), yerel (NDK) çökme sembolleri yok.
- Kullanım analitiği şimdilik yok (proje sahibinin seçimi). Gizlilik politikası ve Data Safety buna göre güncellendi.
**Geçici:** çökme raporlarının hukuki sebebi meşru menfaat (itiraz = anahtarı kapatmak); avukat incelemesine.
**Durum:** Kabul. Firebase konsolunda Crashlytics'in açılması proje sahibinde (SETUP_BACKEND §10.3); gerçek bir çökme raporunun panoya düştüğü henüz doğrulanmadı.

## 2026-11-20 — D60: Test, golden ve CI stratejisi
**Karar:**
- Golden: `test/golden/` 10 tema × açık/koyu × TR/EN × Bugün, Plan, Beyin, Profil = 160 görüntü, 412×915 @1×, gerçek fontlar ve gerçek gölgelerle. Etiket `golden`; referanslar Windows'ta üretilir, CI atlar (font işleme işletim sistemine göre farklı).
- Uçtan uca: `test/ui/app_flow_test.dart` (ana bilgisayar, CI) ve `integration_test/app_flow_test.dart` (gerçek cihaz): kurulum → sihirbaz → odak → beyin olayı. Cihazda hata ayıklama derlemesinde geçti (Redmi Note 10 5G). Profil derlemesinde (`flutter drive`) test klavyesine metin düşmediği için akış testi atlanır; profil koşusu yalnız kare ölçer.
- `flutter test integration_test` ve `flutter drive` varsayılan olarak uygulamayı kaldırır (cihaz verisi silinir): her zaman `--no-uninstall` / `--keep-app-running`.
- CI (`.github/workflows/ci.yml`, ubuntu, Flutter 3.50.0): analyze, test (golden hariç), çekirdek `dart test`, seed denetimi, `tool/brain` testleri, `--split-per-abi` release APK artefaktı. pgTAP ve cihaz testleri CI'da yok.
- Sihirbaz taslağının başlangıç tarihi uygulama saatinden (`nowProvider`) alınır; Bugün ile aynı "şimdi" (test saatinde tutarsızlık bulundu).
**Geçici:** ilk sekme kurulumundaki ~100 ms'lik kare (PERFORMANCE.md §2) açık iş olarak kaldı.
**Durum:** Kabul.

## 2026-11-20 — D61: Yayın hazırlığı, imza ve sürüm
**Karar:**
- Belgeler: [RELEASE.md](RELEASE.md) (hedef kitle 13–15 / 16–17 / 18+, 12 ve altı işaretsiz; Data Safety tablosu; imzalama; sürümleme; mağaza görselleri; kısa / uzun açıklama TR/EN), `docs/legal/terms_of_use.md` (yeni), gizlilik politikası güncellemesi (Crashlytics, saklama süreleri, haklar), [IOS_PORT.md](IOS_PORT.md), [PERFORMANCE.md](PERFORMANCE.md), [AUDIT.md](AUDIT.md).
- İmza: Play App Signing + yükleme anahtarı. `android/key.properties` (git-ignored) varsa release onunla imzalanır, yoksa hata ayıklama anahtarıyla (CI derleyebilsin diye; Play reddeder). Anahtarı proje sahibi üretir.
- Sürüm: `X.Y.Z+N`, `N` her yüklemede artar; etiket `vX.Y.Z`, aday `vX.Y.Z-rc.N`. Bu aşama `1.0.0+1`, etiket `v1.0.0-rc.1` (proje sahibinin seçimi, push edilir).
**Durum:** Kabul. Play Console beyanları, hukuk incelemesi ve mağaza görselleri proje sahibinde (yayından hemen önce, D53).

## 2026-11-20 — D62: Süresiz saat aralığı zaman çizelgesine yerleşir
**Sorun:** Sihirbazda "Bir saat aralığında" seçilip süre adımı boş geçilince motor işi saatsiz bırakıyordu; iş Bugün'de "Bugün bir ara"ya, Plan haftasında "—"ya düşüyordu.
**Karar:**
- Süresiz pencere, süresiz sabit saatli iş gibi **sıfır dakikayla** pencerenin ilk boş anına yerleşir (bugünse şimdiden önce değil). Boş zamanı yemez, çakışma üretmez. Bugün pencere geçtiyse süreli pencere gibi tampona düşer.
- Saatsiz kalan tek iş, saati de süresi de olmayan iştir ("Saat yok"); süresi varsa eskisi gibi saat önerilir.
- Sıfır dakikalık satırda "09:00–09:00 · 0 dk" yazılmaz; yalnız başlangıç saati görünür (Bugün ve Plan).
- `planEngineVersion` 2.
- Test: çekirdekte sınır durumları; uygulamada sihirbaz taslağı → kayıt → Bugün/Plan görünümü için 8 saat seçimi × süreli/süresiz × 9 tekrar türü = 144 birleşim (`test/data/time_step_matrix_test.dart`) ve sihirbazdan uçtan uca ekran testi.
**Durum:** Kabul.

## 2026-11-21 — D63: Saatinde otomatik başlat ve bitir
**Karar (proje sahibinin seçimi):**
- **Odak gerektiren iş:** uygulama öndeyken başlangıç saatinde odak oturumu işin varsayılan moduyla ve son kullanılan süre ayarlarıyla kendiliğinden başlar (`autoStartProvider`, `lib/app/auto_start.dart`). Uygulama kapalı ya da arkadaysa tam başlangıç saatinde bildirim gelir; dokununca oturum hemen başlar (soğuk açılışta `getNotificationAppLaunchDetails`). Tam ekran niyeti (`USE_FULL_SCREEN_INTENT`) kullanılmaz: Play yalnız alarm ve arama uygulamalarına izin veriyor.
- **Bitiş:** oturum işin planlanan bitişinde mod ne olursa olsun "tamamlandı" olur (beyin olayları dahil). Bitiş anı cihaz durumunda (`focus.runtime` → `end`) tutulur; uygulama kapalıyken geçtiyse açılışta bitiş anında tamamlanır. Süresiz işte, bitişi geçmiş işte ve ortak odakta otomatik bitiş yok.
- **Odak gerektirmeyen iş:** başlangıçta "Şimdi başlıyor", bitişte "Yaptın mı?" bildirimi; dokununca Bugün'de satır açılır. Kendiliğinden "bitti" sayılmaz (uyum yüzdesi şişmesin). Uyku ve serbest zamanda "Yaptın mı?" yok.
- **Ayar:** Ayarlar → Odak → "Saatinde otomatik başlat ve bitir", cihaza özel (`pref.auto_run`), varsayılan açık. Veritabanı değişmedi. Kapalıyken yalnız "X dk önce" hatırlatma kalır; 0 dk önce hatırlatma başlangıç bildirimiyle tekrarlanmaz.
- Bildirimler eskisi gibi önümüzdeki 7 gün, en çok 50; bildirim yükü `focus:<id>` / `open:<id>`.
**Geçici:**
- Otomatik başlatma penceresi 5 dk: uygulama işin ortasında açılınca oturum kendiliğinden başlamaz (Bugün'den başlatılır); bildirime dokunuş bu sınıra bağlı değildir.
- Saatsiz ve motorun önerdiği (`suggested`) işler otomatik başlamaz, başlangıç / "yaptın mı?" bildirimi almaz.
- Bir oluşum için oturum bir kez açıldıysa (erken bitirilse ya da bozulsa da) yeniden otomatik başlamaz.
- Önceki oturumun sonuç ekranı açıkken yeni oturum otomatik başlamaz.
- Uygulama öndeyken başlangıç bildirimi de gelir (otomatik başlayan oturumla birlikte).
- "Yaptın mı?" bildiriminden açılan satır listede çok aşağıdaysa (henüz kurulmadıysa) kaydırılmaz.
**Durum:** Kabul. Gerçek cihazda henüz doğrulanmadı (QA_CHECKLIST F).

## 2026-11-21 — D64: Düzenleme
**Karar (proje sahibinin seçimi):**
- **Ekran:** işe dokununca (Plan → Kurallar, Plan haftası satırı, Bugün satırındaki "Düzenle", proje ekranındaki kalem, kategori ağacındaki iş) özet açılır (`/edit/:id`). Satıra dokununca sihirbazın yalnız o sorusu açılır (`/edit/:id/:step`); Kaydet yalnız o adımın alanlarını yazar ve özete döner. Özette Sil ve geri al var.
- **Geçmiş korunur:** saat, tekrar, süre ya da esneklik değişir ve kural bugünden önce oluşum üretmiş olabilirse eski kural dün biter (`valid_until`), yenisi bugün başlar (`valid_from`). Geçmiş plan, uyum yüzdesi ve analizler değişmez. Kural bugün ya da sonra başlıyorsa yerinde güncellenir. Ad, kategori, odak, varyant gibi alanlar her yerde geçerlidir. Biten eski kural Kurallar listesinde ve uyku penceresi aramasında görünmez. Migration yok (alanlar zaten vardı).
- **Tür değişmez:** kural, varyant ve proje verisi türe bağlı; başka türe geçmek için yeni iş eklenir.
- Dokunulmayan tekrar ve saat aynen yazılır; sihirbazın kuramadığı biçimler (ör. uyku penceresi) bozulmaz. Uyku penceresinin saatine dokununca Ayarlar açılır (D30).
- **Varyantlar** özetten yönetilir: ad, iptal eder, varsayılan, ekle, sil (aynı satırlar güncellenir). **Kategori** ağaçta yeniden adlandırılır.
- Tek adımlı düzenlemede "Şimdilik geç" yalnız temizleyen adımda (son tarih, varyant, odak) görünür ve temizleyip kaydeder; ortak sihirbaz son adımdaki atlamada da bitirir.
**Geçici:**
- Bugün için önceden dokunulmuş oluşum (ör. bitti) eski kurala bağlı kalır; aynı gün saat değişirse bugünkü iş yeni kuraldan bir kez daha görünebilir.
- Göreli saatte işin kendisi çapa listesinde yok; başka işler üzerinden döngü kurulursa motor `DependencyCycle` olarak gösterir (kayıtta engellenmez).
**Durum:** Kabul. Gerçek cihazda henüz doğrulanmadı (QA_CHECKLIST G).

## 2026-11-21 — D65: Kendi süresi kadar odak, zamanlı "mola bitti" uyarısı
**Karar:**
- **Kendi süresi kadar:** odak başlatma ekranında mod seçicinin altında anahtar; işin süresi biliniyorsa (saatli işte aralık, değilse kuralın / işin süresi) görünür ve varsayılan açıktır. Açıkken oturum başlangıçtan o kadar sonra mod ne olursa olsun "tamamlandı" olur (D63'teki planlanan bitişin yerine geçer, `pref.auto_run`'dan bağımsız); derin çalışmada hedef de bu süre olur. Yeni mod yok, veritabanı değişmedi; oturumun `settings`'ine kullanılan hedef yazılır, kayıtlı derin çalışma hedefi ezilmez.
- **Mola bitti uyarısı** Dart zamanlayıcısı yerine `zonedSchedule` ile sistem alarmına kurulur (kimlik 903): uygulama arkadayken ya da süpürülmüşken de gelir. Mola başlayınca kurulur, moladan erken dönüşte ve oturum bitince silinir. Plan hatırlatmaları yeniden kurulurken bu kimlik silinmez.
**Geçici:**
- Tam zamanlı bildirim izni kapalıysa uyarı birkaç dakika gecikebilir.
- Pomodoro'da odak bloğu bitişi (mola başlangıcı) hâlâ Dart zamanlayıcısıyla; uygulama ölüyken mola başlangıcı açılışta işlenir, o molanın bitiş uyarısı da o zaman kurulur.
**Durum:** Kabul. Gerçek cihazda henüz doğrulanmadı (QA_CHECKLIST H).

## 2026-11-21 — D66: Derin çalışma blokları, bildirimle başlatma, geç kalma ve kaçırma
**Karar (proje sahibinin seçimi):**
- **Blok planı (işe özel):** derin çalışmada işin süresi saf odaktır; blok ve mola uzunluğu sihirbazın odak adımında seçilir (varsayılan 50 / 10 dk). Blok sayısı süreden hesaplanır (120 dk → 50 + 50 + 20). Molalar süreye eklenir: üst üste bloklar planda 10:00–12:20 kaplar (kesin saatli işte de). Sayaç blok sonunda molaya geçer, mola bitince "Mola bitti" bildirimi gelir, dokununca odak sürer; hedefte oturum kendiliğinden tamamlanır. Sayaçta "Blok 2/3" ve plan satırı görünür.
- **Gün içine dağıt:** yalnız kesin olmayan işte; her blok ayrı oluşum (1. blok oluşumun kendisi, sonrakiler `blockInstanceId`), öncekinden en az bir mola sonra aynı günün ilk boşluğuna. Yer yoksa tampon (isteğe bağlıda düşer); ertesi güne taşınmaz. Motor sürümü 3.
- **Odaklan tuşu kalktı:** başlatma ekranı (D65'in "kendi süresi kadar" anahtarı dahil) silindi; oturum işin modu, blok planı ve süresiyle doğrudan açılır. Bugün satırında odak işinde Bitti / Atla yok, sayaçta var. Saati hiç belli olmayan odak işinde "Şimdi başla" kalır. Sayaçtaki **Atla** oturumu bozulmuş sayar, odak süresini yazmaz, işi atlar.
- **Kesin saatli** (kullanıcının saat verdiği) odak işi saatinde başlamış sayılır: bitişine kadar uygulamaya dönüş ya da bildirime dokunuş oturumu o an açar; geciken süre saf odaktan düşer, iş planlanan bitişte biter, sonraki işler kaymaz. Hiç gelinmezse bitişten sonra oturum bozulmuş kaydedilir (odak 0), iş "kaçırıldı" (`failed`). "Sunucuda başlatma" cihazda yapılır: internet gerekmez.
- **Önerilen saatli** (motorun yerleştirdiği) odak işi de başlangıçta bildirim alır. İşin **geç kalma payı** (sihirbazda, varsayılan 10 dk) içinde dönülürse oturum açılır ve iş o saate sabitlenir. Pay geçince kaydırılabilir iş motorca günün ilk boşluğuna kayar, kesin ve isteğe bağlı iş atlanır. Pay geçtikten sonra dokunulan bildirim Bugün'de tek soru açar: Şimdi başlat / önerilen saatte / Atla.
- Kaçan dakikalar Bugün satırında görünür ("15 dk kaçırıldı"), iş sürerken canlı.
- Veri: `activities.focus_block_minutes`, `focus_break_minutes`, `focus_spread`, `focus_grace_minutes` (Drift şema 3, migration `20261121120000_focus_blocks.sql`).
**Geçici:**
- Kaçırma kararları uygulama çalışırken verilir (açılışta, öndeyken ya da arka planda süreç canlıyken dakikada bir); uygulama hiç açılmazsa plan ve bildirimler açılışta güncellenir.
- Bozulma cezası yalnız bu sürüm ilk açıldıktan sonra başlayan işlere uygulanır (`focus.missed_since`); önceki günler geriye dönük cezalandırılmaz.
- Önerilen saatin "son görülen" hali cihazda tutulur (`focus.starts`); hiç görülmemiş öneride pay, bildirimdeki saatten ya da motorun o anki saatinden sayılır.
- Kaydırılan önerilen işin eski yeri planda ayrıca "kaçırıldı" diye gösterilmez; kaçan süre yalnız katılınan ya da kesin saatli işte görünür.
- Pay geçince kaydırılan iş aynı süreç ömründe öndeyken kendiliğinden başlamaz; yeni saatindeki bildirimle başlar.
- Dağıtılan blokların ilki dışındakiler saatsizdir (pencere kısıtı taşımaz); dağıtma kapatılınca daha önce dokunulmuş blok satırları ayrı iş olarak kalır.
- Başlatma ekranındaki odak kuralı açıklaması (10 sn) kalktı; sistem sabitleme onayı ve kaçış uyarısı sürüyor.
- Kesin saatli odak işine katılınmadan başka bir odak oturumu sürerken bitişi geçerse, oturum bitince bozulma kaydedilir.
**Durum:** Kabul. Gerçek cihazda henüz doğrulanmadı (QA_CHECKLIST I). Sunucu migration'ı uygulanmadı: uygulanmadan bu alanları değiştiren işler eşitlemede reddedilir.
