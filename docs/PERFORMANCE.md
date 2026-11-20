# PERFORMANCE.md — Ölçümler

Cihaz: Redmi Note 10 5G (Android 13, `s8ij59rk7tc6x8gq`), orta segment. Tarih: 2026-11-20, Aşama 6, `main` + Aşama 6 değişiklikleri. Bütün sayılar **profil derlemesinden** (hata ayıklama derlemesi kare süresini 3–5 kat şişirir).

## 1. Soğuk açılış
Yöntem: `flutter build apk --profile`, `adb install -r`, her denemede `am force-stop` + 2 sn bekleme + `am start -W`. Uygulama verisi gerçek (cihazdaki mevcut kullanıcı verisi).

| Deneme | 1 | 2 | 3 | 4 | 5 | 6 | Medyan |
|---|---|---|---|---|---|---|---|
| TotalTime (ms) | 1541 | 1515 | 1504 | 1570 | 1477 | 1470 | **1510** |

Android'in "yavaş soğuk açılış" eşiği 5 sn; hedef < 2 sn karşılanıyor. Açılışta `main()` sırayla `.env` kanalı, Supabase, saat dilimi ve veritabanını hazırlar; beyin sahnesi ilk kareden **sonra** yüklenir (ön ısıtma, D40).

## 2. Kare süreleri
Yöntem: `flutter drive --profile --no-dds --keep-app-running --driver=test_driver/integration_test.dart --target=integration_test/app_flow_test.dart -d <cihaz>`. Test beş sekmeyi sırayla açar, "Zamanım nereye gidiyor?" analiz sayfasını açıp hızlı kaydırır; motorun `FrameTiming` ölçümü toplanır (3 koşu, sonuncusu).

| Ölçü | Değer |
|---|---|
| Kare | 77 |
| Build p50 / p90 / en kötü | 1,1 / 9,2 / 104 ms |
| Raster p50 / p90 / en kötü | 5,8 / 8,0 / 31 ms |
| 16,7 ms'yi aşan kare | 10 (%13) |

Yorum: kaydırma ve tekrar eden geçişler bütçe içinde (p90 build + raster < 17 ms). Aşan kareler her sekmenin **ilk** kurulumunda: Beyin (WebView platform görünümü), Birlikte ve Profil'in ilk açılışı ve analiz sayfasının ilk hesap karesi. Kullanıcı bunu oturum başına bir kez, sekmeye ilk girişte görür.

**Açık iş (Geçici, D60):** ilk sekme kurulumundaki 100 ms'lik karenin kaynağı DevTools Performance ile ayrıştırılacak (aday: Profil kartlarının `statsContextProvider` hesabı ilk karede eşzamanlı; ısı haritası/takvim hesabı `compute`'a alınabilir). UX_RULES §5'in "standart geçişlerde 16 ms" ölçütü tekrar eden geçişlerde sağlanıyor, ilk kurulumda sağlanmıyor.

## 3. Bellek
Yöntem: soğuk açılıştan 6 sn sonra `dumpsys meminfo` (Bugün ekranı, beyin sahnesi arka planda yüklü).

| Ölçü | Değer |
|---|---|
| TOTAL PSS | 263 MB |
| TOTAL RSS | 411 MB |
| Native heap | 62 MB |
| Graphics | 15 MB |

PSS'nin büyük kısmı WebView sürecinin uygulama tarafı ve Three.js sahnesidir (model + doku). Ön ısıtma beyin sekmesini anında açtığı için korunuyor (D40); bellek baskısında Android WebView'u kendisi küçültür. Beyin sekmesi görünmezken çizim durur (`visibility` mesajı).

## 4. Uygulama boyutu
| Paket | Boyut |
|---|---|
| Evrensel release APK (bütün ABI'ler) | 137 MB |
| Profil APK | 172 MB |

Play'e **AAB** yüklenir (`flutter build appbundle`); Play cihaza yalnız kendi ABI'sini gönderir (indirme yaklaşık üçte bir). CI `--split-per-abi` ile derler. Büyük kalemler: Flutter motoru (ABI başına), gömülü beyin modeli ve Three.js (`assets/brain/brain.js`), 5 değişken font, Material Symbols, LiveKit WebRTC kütüphanesi.

## 5. Tekrar ölçmek
1. `flutter build apk --profile` → `adb install -r build\app\outputs\flutter-apk\app-profile.apk`
2. Açılış: `adb shell am force-stop com.mirhatuguzlu.neuroplan` ve `adb shell am start -W -n com.mirhatuguzlu.neuroplan/.MainActivity` (5+ kez, medyan).
3. Kareler: §2 komutu; `[perf]` satırı ve `build/integration_response_data.json`.
4. **Dikkat:** `flutter test integration_test` ve `flutter drive` varsayılan olarak bittikten sonra uygulamayı **kaldırır** (cihazdaki veri silinir). Her zaman `--no-uninstall` / `--keep-app-running` ver; bittikten sonra gerçek uygulamayı yeniden kur (`flutter run` ya da 1. adım), çünkü cihazda test derlemesi kalır.
