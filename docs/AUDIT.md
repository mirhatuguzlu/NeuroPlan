# AUDIT.md — Aşama 6 arayüz denetimi (2026-11-20)

Yöntem: impeccable `audit` (yerel uygulama sürümü, `reference/audit.native.md`) + `critique` / `polish` / `distill` ilkeleri, ui-ux-pro-max öncelik sırası (UX_RULES §11) ve UX_RULES §13 teslim listesi. Kaynak koddan yapıldı; otomatik kanıt `test/ui/theme_matrix_test.dart` (10 tema × açık/koyu × bütün ana ekranlar ve 12 analiz sayfası: kontrast, 48 dp, etiket; 5 ekran boyutu × 3 tema: taşma) ve `test/l10n/`. Gerçek cihaz bulguları [PERFORMANCE.md](PERFORMANCE.md) ve QA_CHECKLIST E'de.

## Puan
| # | Boyut | Puan | Ana bulgu |
|---|---|---|---|
| 1 | Erişilebilirlik | 3 | Isı haritası / yıllık takvim hücreleri 48 dp altı (liste görünümü erişilebilir yol, D55) |
| 2 | Performans | 3 | Evrensel release APK 137 MB (Play'e AAB gider; ABI'ye bölünür) |
| 3 | Görünüm ve tema | 4 | Renkler şema rollerinden; 10 tema iki görünümde testli |
| 4 | Platform uyumu | 3 | Android 13–15'te tahmine dayalı geri animasyonu açık değil |
| 5 | Uyarlanabilirlik | 3 | Telefon düzeni geniş ekranda 720 dp'de ortalanıyor; tablet için ayrı düzen yok |
| **Toplam** | | **16/20** | **İyi** |

**Platform uyumu kararı:** Geçer. Material 3 bileşenleri, Material Symbols tek ikon seti, sistem saat/tarih seçicileri, `PopScope` ile öngörülebilir geri, alt menü yapısı UX_RULES §6'ya uygun. Web'den taşınmış kontrol yok; hover'a bağlı bilgi yok.

## Bulgular ve durum
| # | Öncelik | Ekran / dosya | Bulgu | Etki | Durum |
|---|---|---|---|---|---|
| 1 | P1 | Ayarlar → Tema (`settings_screen.dart`) | Tema seçimi açılır listede, adı ve bir cümleyle; önizleme yok, ayarlar ekranının içinde (tek amaç kuralı) | Kullanıcı temayı seçmeden göremiyor | **Düzeltildi:** ayrı "Görünüm ve tema" ekranı, her temada canlı önizleme (D56) |
| 2 | P1 | Tüm uygulama (`theme.dart`) | Tema değişince tokenlar ve grafik renkleri anında atlıyordu; tema hızı/karakteri yoktu, `enter/exit` tokenları hiç kullanılmıyordu | Sert geçiş, temalar hareketle ayrışmıyor | **Düzeltildi:** `Motion` tokenı, `lerp`, `themeAnimationDuration` |
| 3 | P1 | Kurulum → yaş adımı (`onboarding_screen.dart`) | Doğum yılı kaydedilince boş `Text('')` görünüyordu | Boş alan; ekran okuyucu bir şey okumuyor | **Düzeltildi:** "Doğum yılın kaydedildi: …" |
| 4 | P2 | Ayarlar → Konum | Enlem/boylam dilden bağımsız noktayla yazılıyordu | TR'de "41.0" yerine "41,0" beklenir | **Düzeltildi:** `NumberFormat` |
| 5 | P2 | Mesajlar (`messages_screens.dart`) | Mesaj eylemleri yalnız uzun basmayla açılıyordu | Görerek kullanan keşfedemez | **Düzeltildi:** dokunma da açar; ipucu metni güncellendi |
| 6 | P2 | Bugün, odak bitişi, sihirbaz | Tamamlanma anlarında geri bildirim yoktu; dokunsal geri bildirim yalnız alt menüde | Eylemin olduğu hissedilmiyor | **Düzeltildi:** `Haptics` (ayara bağlı, temaya göre şiddet), bitti işaretinin tek seferlik girişi |
| 7 | P2 | Birlikte | Bir özellik sorun çıkarırsa kapatmanın yolu yoktu | Yeni sürüm beklenir | **Düzeltildi:** özellik bayrakları (D58), kapalı bölüm açıklayıcı boş durum gösterir |
| 8 | P2 | Analiz → ısı haritası, yıllık takvim | Hücreler 48 dp'den küçük | Hassas dokunma zor | Açık (kabul, D55): tek dokunma alanı + liste görünümü |
| 9 | P2 | Uygulama boyutu | Evrensel APK 137 MB | İndirme yükü | Açık: Play'e `flutter build appbundle` (ABI bölme); bkz. RELEASE.md |
| 10 | P3 | Geri hareketi | `android:enableOnBackInvokedCallback` yok; Android 13–15'te tahmine dayalı geri önizlemesi çıkmaz | Görsel incelik | Açık: tüm `PopScope` akışları cihazda denendikten sonra açılacak |
| 11 | P3 | Geniş ekran | İçerik 720 dp'de ortalanıyor; liste–detay iki bölmesi yok | Tablette boşluk | Açık (D54'ten beri planlı; iOS/tablet aşaması) |
| 12 | P3 | Tema önizlemesi | Önizleme kutusundaki yazı ölçeklenmez | Yok: süstür, aynı bilgi kartın ölçeklenen metninde | Kabul |

Kontrol edilip sorun bulunmayanlar: ortadaki diyaloglar (6 yer) yalnız UX_RULES §3'teki iki seçenekli kararlar ve geri alınamayan onaylar; alttan kartlar (2 yer) kısa seçim listeleri. İkon yalnız düğmelerin hepsinde `tooltip` var. Sabit renk yalnız QR kodu zemininde (tarama için beyaz şart) ve WebView'un yükleme zemininde. Uzun listeler sınırlı (`take(20)`) ya da `ListView.builder`. Kodda sabit kullanıcı metni yok (`test/l10n/hardcoded_strings_test.dart`).

## Sistematik notlar
- Hareket artık tek yerden: `AppTokens.duration()` temanın hızını uygular; Kâğıt anlık, azaltılmış harekette her şey anlık.
- Dokunsal geri bildirim tek yerden: `lib/ui/core/feedback.dart`.

## Önerilen sıradaki adımlar
1. [P2] `/impeccable adapt` — tablet ve katlanabilir için liste–detay düzeni.
2. [P3] `/impeccable polish` — tahmine dayalı geri animasyonu açıldıktan sonra son geçiş turu.
