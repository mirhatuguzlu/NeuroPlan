# THEMES.md — Tema sistemi

Durum: Aşama 6, 2026-11-20 (D54, D55, D56). Kod: `lib/app/theme.dart` (tek tanım), seçici `lib/ui/core/theme_choice.dart`, ekran `lib/ui/features/profile/theme_screen.dart`.

## 1. Token yapısı
Bir tema `AppTheme` enum'unun bir değeridir; her alanı bir tokendır. Ekranlar tokenları doğrudan değil `Theme.of(context)`, `AppTokens.of(context)`, `ChartColors.from(context)` ve `context.tone` üzerinden okur.

| Token | Alan | Ne değiştirir |
|---|---|---|
| Renk tohumu ve şema türü | `seed`, `variant` | Material 3 `ColorScheme` (açık + koyu). Minimal ve Kâğıt'ta yüzeyler başka tohumdan, vurgu `seed`'den (tek vurgu rengi) |
| Fontlar | `body`, `heading`, `numeric` | Gövde, ≥ 20sp başlık, büyük sayı/sayaç (UX_RULES §7) |
| Tip ölçeği | `typeScale` | Bütün metin boyutlarının çarpanı (M3 ölçeği × çarpan) |
| Köşe | `radius` | Kart, satır, düğme, alt menü yarıçapı |
| Boşluk | `Gap` (ortak) | 4 · 8 · 12 · 16 · 24 · 32 dp; temalar paylaşır (bkz. §3) |
| Dokunma alanı | `touch` | Dolu / çerçeveli düğme en küçük yüksekliği, liste satırı yüksekliği |
| İkon ağırlığı | `iconWeight` | Material Symbols `wght` ekseni |
| Görünüm dili | `look` (`Look`) | Kart, satır ve alt menü biçimi: dolgu, çerçeve, gölge |
| Hareket | `motion` (`Motion`) | Süre çarpanı ve eğri karakteri; tema geçişinin süresi |
| Görünüm önceliği | `darkFirst` | "Sistem" seçiliyken koyu açılır |
| Grafik ve kök renkleri | `ChartColors` | 8 kategorik renk, sıralı rampa, 9 kök kategori rengi |
| Beyin renkleri | `sceneThemeFor` | 3D sahne temanın koyu şemasından boyanır (zemin, kabuk, ışıma, sinyal, sönük, ceza) + 9 kök rengi |
| Metin tonu | `tone` | ARB'deki `{tone, select, …}` dalı (UX_RULES §10) |

Hareket karakterleri (`Motion`): süreler yine Material 3 `Durations` tokenlarıdır, tema yalnız çarpanı ve eğriyi seçer (`AppTokens.duration`).

| Motion | Çarpan | Eğri | Temalar |
|---|---|---|---|
| `quiet` | 0,8 | standart | Ciddi, Kodcu, Yüksek Kontrast, Minimal |
| `soft` | 1,25 | standart | Sakin, Doğa, Gece |
| `lively` | 1,0 | vurgulu (emphasized) | Eğlenceli |
| `brisk` | 0,85 | vurgulu | Genç |
| `instant` | 0 | — | Kâğıt (e-mürekkep: geçiş yok) |

Azaltılmış hareket açıkken her tema anlık olur. Odak ekranındaki "nefes" ışıması temadan bağımsızdır: anlamı (oturum sürüyor) hızını belirler.

## 2. Tema × token matrisi
| Tema | Tohum | Şema | Gövde / başlık / sayı | Ölçek | Köşe | Dokunma | İkon | Görünüm | Hareket | Ton | Koyu öncelik |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Ciddi | #5B57D9 | tonalSpot | Atkinson / Atkinson / Atkinson | 1,0 | 16 | 52 | 400 | tonal | quiet | nötr | — |
| Eğlenceli | #E8613C | vibrant | Atkinson / Nunito / Nunito | 1,06 | 24 | 56 | 500 | colorful | lively | playful | — |
| Genç | #00A88A | vibrant | Lexend / Lexend / Lexend | 1,0 | 20 | 52 | 500 | vivid | brisk | young | — |
| Kodcu | #2E9E5B | tonalSpot | Atkinson / Atkinson / JetBrains Mono | 1,0 | 6 | 52 | 300 | terminal | quiet | coder | ✓ |
| Sakin | #5E8798 | neutral | Atkinson | 1,0 | 20 | 52 | 300 | soft | soft | calm | — |
| Yüksek Kontrast | #1F4FD1 | tonalSpot, kontrast 1 | Atkinson | 1,0 | 12 | 52 | 600 | bold | quiet | nötr | — |
| Minimal | #2F6FDE | monochrome + vurgu | Atkinson | 1,0 | 10 | 52 | 400 | hairline | quiet | nötr | — |
| Kâğıt | #2B4C7E (vurgu), #8C7A55 (kâğıt) | neutral + vurgu | Atkinson / IBM Plex Sans / IBM Plex Sans | 1,0 | 4 | 52 | 300 | paper | instant | nötr | — |
| Doğa | #6E7F3A | tonalSpot | Atkinson / Nunito / Nunito | 1,0 | 24 | 52 | 400 | earthy | soft | calm | — |
| Gece | #7B83EB | tonalSpot, koyuda gerçek siyah | Atkinson | 1,0 | 16 | 52 | 300 | oled | soft | nötr | ✓ |

## 3. Paylaşım kararları
Temalar her şeyi değiştirmek zorunda değil; bir token yalnız temanın ruhunu taşıyorsa değişir.
- **Boşluk ölçeği ortak.** Yoğunluk farkı boşlukla değil tip ölçeği ve dokunma alanıyla verilir; böylece düzen testleri (taşma, 2.0 yazı) bütün temalarda aynı kalır.
- **Gövde fontu çoğunlukla ortak (Atkinson Hyperlegible Next).** Uzun okuma ve küçük boyut netliği her temada önce gelir; kişilik başlık ve sayı fontuyla verilir. Yalnız Genç gövdede Lexend kullanır (Lexend okuma akıcılığı için tasarlandı ve Genç'in enerjik ruhunu gövdeye taşır).
- **Ciddi, Kodcu, Yüksek Kontrast, Minimal, Gece aynı gövdeyi**, Kodcu yalnız sayılarda JetBrains Mono kullanır: terminal hissi uzun metni monospace yapmadan verilir.
- **Eğlenceli ve Doğa başlıkta Nunito'yu paylaşır:** ikisi de yuvarlak, sıcak; ayrım renk, görünüm, hareket ve tonla yapılır (Doğa sakin ve yavaş, Eğlenceli canlı ve oyunbaz).
- **Metin tonu beş tane:** Kâğıt ve Gece nötr tonu (Ciddi), Doğa Sakin'in tonunu paylaşır. Yeni ton, ARB'deki 26 tonlu metnin iki dilde yeniden yazılmasını gerektirir; görsel ruh tonla zaten uyumlu.
- **Grafik serileri:** renk körlüğü kapılarını geçen sıra az bulunduğu için Sakin, Minimal ve Kâğıt aynı sakin seriyi; Gece Ciddi'nin seriyi paylaşır. Her temanın rampası ve dokuzuncu kök rengi kendinedir (`test/ui/theme_test.dart` paylaşımı yalnız bu gruplarla sınırlar).

## 4. Font seçimleri ve okunabilirlik gerekçesi
Hepsi sans-serif, SIL Open Font License 1.1, `assets/fonts/` içinde gömülü (çalışma anında indirme yok). Lisans metinleri Ayarlar → Hakkında → Fontlar ve "Bütün lisansları göster"de (`embeddedFonts`, `main.dart` `LicenseRegistry`).

| Font | Nerede | Gerekçe |
|---|---|---|
| Atkinson Hyperlegible Next | Gövde (Genç hariç hepsi) | Braille Enstitüsü az görenler için tasarladı: I / l / 1 ve 0 / O harf biçimiyle ayrışır, açık iç boşluklar küçük boyutta netlik verir, Türkçe glifleri tam |
| Nunito | Eğlenceli, Doğa başlık (≥ 20sp) | Yuvarlak uçlar sıcaklık verir; yalnız başlıkta kullanıldığı için harf benzerliği riski yok |
| Lexend | Genç (gövde + başlık) | Okuma akıcılığı için geniş harf aralığıyla tasarlandı; enerjik ama çocuksu değil |
| JetBrains Mono | Kodcu sayılar ve sayaç | Kod için tasarlandı: 0 noktalı, 1 / l / I ayrışık; rakamlar eş genişlikte, sayaç titremez |
| IBM Plex Sans | Kâğıt başlık | Akademik, mühendislik kökenli, sakin otorite; kuyruklu l ve belirgin rakamlar; geniş dil desteği (Türkçe dahil). ui-ux-pro-max'in "Academic/Research" eşleşmesi serif başlık öneriyordu; proje kuralı sans-serif olduğu için en yakın sans karşılık seçildi |

Gerçek cihaz testi: QA_CHECKLIST D1 dizisi (`Il1| O0 rn m ğĞşŞıIiİçÇöÖüÜ 12:30 %50`) yeni fontlarla da tekrarlanır (E2).

## 5. Seçici ve geçiş
- Ayarlar → "Görünüm ve tema" ayrı ekrandır (tek amaç). Başta görünüm (sistem / açık / koyu), altında her tema kendi canlı önizlemesiyle: başlık ve gövde fontu, kart biçimi, vurgu rengi, sayı fontu, grafik renkleri. Önizleme `buildTheme` ile çizilir; aynı `ThemeData` nesnesi önbellektedir.
- Dokununca anında uygulanır; uygulama yeniden başlamaz. `MaterialApp.themeAnimationDuration` temanın hareket hızından (`AppTokens.themeSwitch`, `Durations.long2` × çarpan); renkler ve grafik paleti ara değer alır (`lerp`), font değişimi geçişin ortasında olur. Kâğıt'ta ve azaltılmış harekette geçiş anlıktır.
- İlk kurulumdaki görünüm adımı aynı önizlemeli seçiciyi kullanır.

## 6. Paletlerin doğrulanması
Kategorik seriler dataviz `validate_palette.js` ile açık ve koyu modda doğrulandı (komşu çiftlerde renk körlüğü ΔE ≥ 8, normal görüşte ≥ 15, açıklık bandı, doygunluk tabanı, yüzeye 3:1). Doğa serisi bir arama betiğiyle bulundu ve aynı renkler iki modda da kapıları uyarısız geçti. Rampalar sıralı denetimin tek ton, artan açıklık ve adım aralığı kapılarını geçer; "açık uç yüzeye 2:1" kapısını mevcut rampaların hiçbiri geçmez (veri yok hücresi ayrı renktir, değer her zaman metin ve listede de var). Palet değişirse doğrulayıcı yeniden koşturulur.

## 7. Testler
- `test/ui/theme_test.dart`: paletler ve paylaşım grupları, 9 kök rengi, görünüm dilinin her temada ayrı olması, hareket ölçeği, koyu öncelik, Gece'nin gerçek siyahı, Eğlenceli'nin iri yazı ve dokunma alanı, renk ara değeri, ton.
- `test/ui/theme_matrix_test.dart`: 10 tema × açık/koyu × bütün ana ekranlar ve analiz sayfaları (kontrast, 48 dp, etiket) + 5 boyut × 3 tema taşma.
- `test/golden/`: 10 tema × açık/koyu × TR/EN × Bugün, Plan, Beyin, Profil (160 görüntü).
- `test/ui/stage6_test.dart`: seçici ekranı, anında uygulama, yazı 2.0.
