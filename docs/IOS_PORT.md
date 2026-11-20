# IOS_PORT.md — iOS'a geçerken değişecekler

Durum: Aşama 6 taslağı, 2026-11-20. iOS aşamasında bu belge karar listesine dönüşür (DECISIONS). Bugün `ios/` Flutter şablonudur: `AppDelegate`, boş `SceneDelegate`, izin metinleri yok, widget eklentisi yok; `FocusPlatform`'un iOS uygulaması yok (`lib/app/focus_platform.dart` → `_NoFocusPlatform`).

Paylaşılan her şey olduğu gibi kalır: `neuroplan_core` (plan, odak saati, 10 sn kuralının durum makinesi, beyin, analiz), Drift veritabanı ve eşitleme, Supabase, arayüz, temalar, 3D sahne (WebView). Değişen yalnız işletim sistemine dokunan katmandır.

## 1. Odak algılama ve 10 saniye kuralı (en kritik)
| Android bugün (D33–D36) | iOS karşılığı | Fark |
|---|---|---|
| `onWindowFocusChanged` → bildirim paneli çekildi / başka pencere | Yok. `UIScene` yalnız `willResignActive` / `didBecomeActive` verir; Denetim Merkezi ve Bildirim Merkezi de `willResignActive` tetikler | Panel çekmek ile kısa kesinti ayırt edilemez. Öneri: `willResignActive` → uyarı **zamanla ama gösterme**; `didEnterBackground` → 10 sn sayaç başlar. Yalnız `inactive` kalıp dönen (Denetim Merkezi) cezasız |
| Ekran kapandı / kilit (cezasız) | `protectedDataWillBecomeUnavailable` (cihaz kilitlendi, parola varsa) + `UIApplication.isProtectedDataAvailable`; kilit tuşu `didEnterBackground`'dan **önce** gelir | Parolasız cihazda kilit algılanamaz → dönüşte "cezayı kaldırayım mı?" sorusu (bugünkü arama akışı gibi) |
| Gelen arama (`READ_PHONE_STATE`, cezasız) | `CXCallObserver` (CallKit), izin istemez | Daha kolay; izin adımı kalkar |
| Ön plan servisi + kalıcı bildirim + yerel zamanlayıcıyla "bozuldu" değişimi | Arka planda kod çalışmaz. Çıkış anı zaten zaman damgasıyla kaydediliyor (D32); 10 sn sonra `UNNotificationRequest` (zaman tetikli) "Odak bozuldu" bildirimi; sonuç dönüşte saf çekirdekte hesaplanır | Geri sayan bildirim yok: tek "10 sn içinde dön" bildirimi + 10. saniyede ikinci bildirim. `interruptionLevel = .timeSensitive` (Time Sensitive Notifications yeteneği) |
| Kalıcı bildirimde kalan süre, Duraklat / Bitir | **Live Activity** (ActivityKit) + Dynamic Island: kalan süre `Text(timerInterval:)` ile kendiliğinden akar; Duraklat / Bitir App Intent düğmeleri (iOS 17+) | Widget eklentisi hedefi gerekir (§3) |
| Uygulama sabitleme (`startLockTask`, D36) | Yok. Kılavuzlu Erişim yalnız kullanıcı açar; uygulama başlatamaz | Ayarlar'da "Kılavuzlu Erişim nasıl açılır" yardım metni; kural metni "sabitleme" yerine "çıkarsan 10 sn" olur |
| Rahatsız Etmeyin (`ACCESS_NOTIFICATION_POLICY`) | Uygulama Odak modunu açamaz. **Focus Filter** (App Intents, iOS 16+): kullanıcı kendi Odak modunu kurar, NöroPlan filtre olarak bağlanır; ya da Kısayollar otomasyonu önerilir | Otomatik açma yok; ayar adımı yardım metnine döner |
| Tam ekran (immersive) | `prefersStatusBarHidden`, `prefersHomeIndicatorAutoHidden` | Kolay |
| Bildirim eylemleri (Duraklat / Bitir) | `UNNotificationCategory` eylemleri | Aynı |

Yeni `IosFocusPlatform` aynı `FocusPlatform` arayüzünü uygular; olay adları (`focus_lost`, `background`, `screen_off`, `call`…) korunur ki `FocusController` değişmesin. QA_CHECKLIST A bölümü iOS için kopyalanır.

## 2. Bildirimler ve push
- Yerel bildirimler `flutter_local_notifications` ile aynı; izin `UNUserNotificationCenter` (D50'deki açıklamalı adım aynen).
- Tam zamanlı alarm izni (Android `SCHEDULE_EXACT_ALARM`) iOS'ta yok; zaman tetikli bildirimler zaten kesin. 64 bekleyen bildirim sınırı: sıradaki iş bildirimleri en yakın 64 ile sınırlanır.
- Push: FCM iOS'ta APNs üzerinden; Apple Developer'da APNs anahtarı (.p8) Firebase'e yüklenir, `Push Notifications` + `Background Modes → Remote notifications` yetenekleri. `push_message` Edge Function değişmez.
- Crashlytics: iOS'ta dSYM yüklemesi için Xcode "Run Script" adımı (Android'de Gradle eklentisi kullanılmıyor, D59).

## 3. Ana ekran widget'ı
- Android `NextUpWidgetProvider` (RemoteViews) → iOS **WidgetKit** eklentisi (SwiftUI). `home_widget` paketi iki tarafı da destekler: veri **App Group** (`group.com.mirhatuguzlu.neuroplan`) `UserDefaults`'ına yazılır.
- Zaman çizelgesi: "Sıradaki: X, 15 dk sonra" için `TimelineProvider` sıradaki işlerin saatlerinde girişler üretir (sistem yenileme sıklığını sınırlar; `Text(date, style: .relative)` dakikayı kendisi sayar).
- Aynı eklenti hedefi Live Activity'yi de taşır (§1).

## 4. Ayar ve gizli değerler
- `.env` Android'de Gradle'ın `BuildConfig.ENV`'ine giriyor (D52). iOS: bir Xcode "Run Script" adımı `.env`'deki aynı yedi beyaz listeli anahtarı `Runner/Env.xcconfig` → `Info.plist`'e yazar; `AppDelegate` `neuroplan/focus` kanalının `env` çağrısını karşılar (`lib/app/env.dart`'taki `shortcut:` notu).
- Firebase: `.env`'deki seçenekler iOS uygulama kimliğini (`FIREBASE_IOS_APP_ID`) de taşımalı; `GoogleService-Info.plist` kullanılmaz (Android'deki gibi).

## 5. Giriş ve hesap
- Google girişi: `google_sign_in` iOS'ta `GIDSignIn`; Google Cloud'da iOS istemcisi + `Info.plist` URL şeması (ters istemci kimliği).
- **Apple ile giriş zorunlu:** App Store kuralı 4.8, üçüncü taraf girişi olan uygulamada Apple girişi ister. Supabase Apple sağlayıcısı + `sign_in_with_apple`; misafirden bağlanma (`linkIdentity`) aynı akış.
- Hesap silme uygulama içinden zaten var (App Store 5.1.1(v) şartı); Apple ile girişte ek olarak Apple belirteci iptali (`revoke`) `delete_account` Edge Function'ına eklenir.

## 6. Abonelik
App Store'da StoreKit 2; Play Billing ile aynı ürün kimlikleri. Abonelik altyapısı yayından önce kurulacağı için (D58) seçilen sağlayıcı iki mağazayı da kapsamalı. Sunucuda `entitlements.store = 'app_store'` hazır.

## 7. İzinler (Info.plist açıklama metinleri, TR + EN `InfoPlist.strings`)
| Anahtar | Neden |
|---|---|
| `NSCameraUsageDescription` | Davet QR kodunu okumak |
| `NSMicrophoneUsageDescription` | Ortak odakta sesli sohbet |
| `NSLocationWhenInUseUsageDescription` | Gün doğumu ve namaz vakti (yaklaşık konum) |
| `UIBackgroundModes: audio` | Ortak odakta ses, uygulama arka plandayken (LiveKit) |
| `NSUserTrackingUsageDescription` | **Eklenmez**: izleme yok |

Gizlilik bildirimi: `PrivacyInfo.xcprivacy` (toplanan veri türleri RELEASE.md §2 tablosuyla aynı; "tracking: false"; zorunlu API nedenleri: `UserDefaults`, dosya zaman damgası). App Store "Uygulama Gizliliği" formu aynı tablodan doldurulur.

## 8. 3D beyin (WebView)
- `webview_flutter` iOS'ta `WKWebView`. `loadFlutterAsset` çalışır; `file://` altında klasik betik tek dosya olduğu için (D40) ek ayar gerekmez.
- WebGL ve bloom WKWebView'da desteklenir; kalite kademesi (`QualityGovernor`) aynı. Bellek: iOS WebContent sürecini bellek baskısında öldürebilir → `webViewWebContentProcessDidTerminate`'te sahneyi yeniden yükle.

## 9. Arayüz ve platform uyumu
- Kenardan kaydırarak geri (iOS) `PopScope` ile çakışmamalı: sihirbazda geri hareketi önceki adıma döner, odak ekranında engellenir (bugünkü davranış). `CupertinoPageTransitionsBuilder` sayfa geçişini iOS'a uydurur; UX_RULES §5'teki üç desen iOS'ta da anlamını korur.
- Dokunma alanı: proje alt sınırı 48 dp iOS'un 44 pt'sinden büyük, değişmez.
- Haptik: `HapticFeedback` iOS'ta Taptic Engine'e eşlenir; `Haptics` yardımcısı aynı.
- Fontlar gömülü; Dynamic Type `TextScaler` ile zaten destekleniyor.
- Alt menü: iOS'ta da 5 hedef + ayrı Ekle düğmesi; ev göstergesi için `SafeArea` alt dolgusu hesaba katılı.

## 10. Derleme ve yayın
- Bundle kimliği `com.mirhatuguzlu.neuroplan`, en düşük iOS 16 (Focus Filter, App Intents, Live Activity için 16.1+; düğmeli Live Activity 17+).
- Yetenekler: Push Notifications, Background Modes (remote notifications, audio), App Groups, Time Sensitive Notifications, Sign in with Apple.
- CI: macOS çalıştırıcısında `flutter build ipa --no-codesign` (yalnız derleme denetimi); imza ve TestFlight yerelde ya da Xcode Cloud'da.
- Yaş derecelendirmesi App Store'da 13+ değil "12+" ya da "17+" basamaklarıdır: kullanıcı üretimli içerik ve sohbet nedeniyle **12+** (sınırsız web erişimi yok); uygulama içi 13 yaş kapısı aynen kalır.
