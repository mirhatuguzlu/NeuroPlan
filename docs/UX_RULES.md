# UX_RULES.md — NöroPlan UX Anayasası (Flutter)

Bu belge, kurulu tasarım skill'lerinden ve proje sahibinin kurallarından derlenmiştir. **Kurulu skill'lerin çoğu web içindir; ilkeleri olduğu gibi değil, aşağıdaki Flutter karşılıklarıyla uygulanır.** Skill ile bu belge çelişirse bu belge kazanır.

## 0. Kaynaklar ve nasıl kullanılır
| Kaynak | Odak | Bu projede kullanım |
|---|---|---|
| `dart-flutter` plugin + `dart-lang/skills` | Flutter / Dart | Doğrudan uygulanır (resmi). |
| `frontend-design` (anthropics/skills) | Web görsel kimlik | İlkeler uyarlanır: şablon görünümden kaçın, tipografi kişilik taşır, cesaret tek yerde harcanır. CSS önerileri §1 tablosuyla çevrilir. |
| `ui-ux-pro-max` | UI/UX kural veritabanı | Öncelik sırası (§11) buradan. Arama aracında `--stack flutter` ve `--stack threejs` kullanılır. Not: arama betiği Python ister. |
| `impeccable` | Tasarım eleştirisi / “AI slop” tespiti | Eleştiri ve ilke referansı olarak kullanılır. Hook'ları kapalı (Dart dosyalarını okumaz). **“Live mode” yasak**: izinleri atlayarak ajan çalıştırabiliyor. |
| Material 3, Android erişilebilirlik dokümanı | Platform | Dokunma alanı, hareket ve erişilebilirlik ölçüleri. |

İstisna: 3D beyin sahnesi (WebView içindeki HTML/JS) gerçek web içeriğidir; orada web skill'leri ve impeccable dedektörü doğrudan kullanılabilir.

## 1. Web → Flutter eşleme tablosu
| Web kavramı | Flutter karşılığı |
|---|---|
| CSS değişkeni / design token | `ThemeData` + `ColorScheme` + `ThemeExtension` (boşluk, köşe yarıçapı, hareket tokenları) |
| `px`, `rem` (taban 16px) | mantıksal piksel (dp); metin `sp` ve `TextScaler`; gövde metni `bodyLarge` = 16 |
| `:hover` | Yok. Basılı / odaklı / seçili durumlar `WidgetStateProperty` ile; hover'a bağlı bilgi saklanmaz |
| `:focus-visible` | `FocusNode` + görünür odak halkası (klavye, D-pad, erişilebilirlik) |
| Media query / breakpoint | `MediaQuery.sizeOf`, `LayoutBuilder`; pencere sınıfları: compact < 600dp, medium < 840dp, expanded ≥ 840dp |
| `aria-label`, alt metin | `Semantics(label:)`, `tooltip`, `Image.semanticLabel`; süs öğeleri `ExcludeSemantics` |
| `prefers-reduced-motion` | `MediaQuery.disableAnimationsOf(context)` |
| `prefers-color-scheme` | `ThemeMode.system` + her temanın açık/koyu varyantı |
| CSS transition / keyframe | Implicit animasyonlar (`AnimatedOpacity`, `AnimatedSwitcher`…), `AnimationController`, `animations` paketi |
| Layout shift (CLS) | Sabit boyutlu iskelet (skeleton), bilinen öğe yüksekliği, görsel boyutu önceden |
| Lazy loading, WebP | `ListView.builder`, `cacheWidth`/`cacheHeight` |
| Web font (CDN) | Font dosyaları `pubspec.yaml` ile uygulamaya gömülür; çalışma anı indirme yok |
| SVG ikon | Tek ikon fontu (§8); `flutter_svg` yalnız illüstrasyon için |
| Toast | `SnackBar` (mümkünse “Geri al” eylemiyle) |
| Modal | `showDialog` / `showModalBottomSheet` — §3 ölçütüne tabi |
| `env(safe-area-inset-*)` | `SafeArea`, `MediaQuery.paddingOf`, `MediaQuery.viewInsetsOf` |
| iOS 44px dokunma hedefi | Android'de **48dp** (bu proje için alt sınır) |
| Landing “hero” bölümü | Yok. Uygulamanın ilk ekranı kullanıcının bugünü olur |

## 2. Ekran yapısı
- **Her ekran tek bir amaç taşır.** Ekranın amacı tek cümleyle söylenebilmeli; söylenemiyorsa ekran bölünür.
- **Çok adımlı işler adım adım sihirbazla yapılır:** her adımda tek soru, ilerleme göstergesi (“2 / 4”), geri dönülebilir, son adımda özet + onay. Sihirbaz yarıda bırakılırsa taslak kaybolmaz.
- Birincil eylem ekranda tektir ve başparmak bölgesindedir (alt kısım).
- Kimliği gösterecek tek cesur öğe 3D neon beyindir; diğer ekranlar sakin ve disiplinli kalır (frontend-design: “cesaretini tek yerde harca”).

## 3. Pop-up ve alttan kayan kart ölçütü
Varsayılan cevap **hayır**. Önce şunlar denenir: satır içi genişleme, yeni sayfa, “Geri al”lı SnackBar.
| Bileşen | Sadece şu durumda |
|---|---|
| Ortadaki diyalog | Geri alınamayan yıkıcı eylemin onayı (hesap silme gibi) **veya** akışı durduran, en fazla 2 seçenekli karar. |
| Alttan kayan kart | Bir öğeye bağlı kısa bağlamsal seçim listesi (en fazla 6 seçenek). Form, sihirbaz, uzun içerik değil. |
| Tam ekran katman | Odak oturumu kaçış uyarısı (10 sn geri sayım) gibi tüm dikkatin gerektiği anlar. |
Asla: iç içe diyalog, açılışta tanıtım / reklam pop-up'ı, ilk kullanımda puanlama isteği, diyalog içinde çok adımlı form.

## 4. Butonlar ve durumlar
- **Boş ya da işlevsiz buton yok.** “Yakında” butonu, eylemsiz ikon, tıklanınca hiçbir şey olmayan öğe yasak.
- Her eylem şu durumları tasarlar: **boşta, basılı, yükleniyor** (buton genişliği sabit kalır, çift dokunma engellenir), **devre dışı** (nedeni görünür), **hata** (mesaj ilgili yerin yanında, çözüm önerisiyle), **başarı** (kısa geri bildirim).
- Her liste / veri ekranı: **yükleniyor** (iskelet), **boş** (ne olduğunu açıklayan cümle + tek birincil eylem), **hata** (anlaşılır neden + “Tekrar dene”), **çevrimdışı** (yerel veriyle çalışmaya devam ettiğini söyler).
- Formlar: görünür etiket (yer tutucu etiket yerine geçmez), hata alanın yanında, doğrulama gönderirken ve alandan çıkarken.

## 5. Hareket dili (geçişler)
- **Tek ortak dil, 60 fps.** Süreler ve eğriler yalnız Flutter'ın Material 3 tokenlarından seçilir: `Durations` (ör. `short4`, `medium2`, `long2`) ve `Easing` (`emphasizedDecelerate` girişte, `emphasizedAccelerate` çıkışta, `standard` ekran içi). Koda gelişigüzel `Duration(milliseconds: …)` yazılmaz; tokenlar bir `ThemeExtension`'da toplanır.
- Sayfa geçişleri üç desenle sınırlıdır ve her desenin tek anlamı vardır (`lib/app/transitions.dart`; `animations` paketi `material_ui` ile uyumsuz olduğu için kullanılmaz, D28):
  | Desen | Anlam |
  |---|---|
  | Shared axis (yatay) | Hiyerarşide ileri / geri (liste → detay, sihirbaz adımları) |
  | Fade through | Alt menü sekmeleri arası geçiş (ilişkisiz ekranlar) |
  | Container transform | Bir kart / öğenin kendi detayına açılması |
- Hareket anlam taşır: süs için sürekli dönen, nabız atan öğe yok. Kullanıcı tetiklemediği hareket yalnız dikkat çekmek için ve tek seferlik.
- Sadece `transform` ve `opacity` benzeri ucuz özellikler canlandırılır; ağır alanlar `RepaintBoundary` ile ayrılır.
- `MediaQuery.disableAnimationsOf` açıksa geçişler kısa solmaya ya da anlık geçişe düşer.
- Ölçüm: `flutter run --profile` + DevTools Performance; referans cihazda standart geçişlerde 16 ms'yi aşan kare kabul edilmez (referans cihaz Aşama 1'de seçilir).

## 6. Floating alt menü
- Ekran kenarlarından ayrık, havada duran yuvarlatılmış bir çubuk: yanlardan ve alttan 16dp boşluk + sistem güvenli alanı.
- 3–5 hedef. Aşama 2: Bugün · Plan · Beyin · Profil; sağda ayrık, yuvarlak "Ekle" butonu (sekme değil, eylem; D28). Her hedefte ikon **ve** etiket her zaman görünür.
- Her hedef en az 48×48dp; seçili hedef belirgin gösterge + `Semantics(selected: true)`.
- `Scaffold(extendBody: true)` ile içerik menünün altına uzanır; listelerin son öğesi menünün arkasında kalmasın diye alt dolgu eklenir.
- Klavye açıkken gizlenir. Odak oturumu ve sihirbazlarda görünmez (tek amaç kuralı).
- Seçimde hafif dokunsal geri bildirim (kullanıcı kapatabilir).
- Görünümü (gölge, bulanıklık, kontur) temaya göre değişir; yapısı ve konumu değişmez.

## 7. Tipografi
Her temanın ruhuna uygun, uzun okumada göz yormayan **sans-serif** fontlar seçilir. Kesin seçim Aşama 1'de aşağıdaki testle yapılır.

**Zorunlu ölçütler**
1. **Türkçe:** ğ Ğ ş Ş ı I i İ ç Ç ö Ö ü Ü glifleri tam ve doğru.
2. **Ayırt edilebilirlik:** I / l / 1 ve 0 / O birbirinden açıkça ayrılır (gerekirse fontun OpenType özellikleri `FontFeature` ile açılır).
3. **Küçük boyutta netlik:** 12sp'de gerçek cihaz ekranında okunur.
4. **Rahat satır yüksekliği:** gövde metninde 1.4–1.6; satır uzunluğu geniş ekranda ~75 karakteri geçmez.
5. **Lisans:** SIL Open Font License (OFL) ya da eşdeğeri; lisans dosyası uygulamayla birlikte dağıtılır (`LicenseRegistry`).
6. **Gömülü:** font dosyaları `assets/fonts` altında, `pubspec.yaml`'da tanımlı. `google_fonts` ile çalışma anında indirme **yok**.

**Test:** Her aday için `Il1| O0 rn m ğĞşŞıIiİçÇöÖüÜ 12:30 %50` dizisi 12sp, 14sp ve 16sp'de, açık ve koyu temada gerçek Android cihazda ekran görüntüsü alınıp karşılaştırılır.

**Aday eşleşmeler** (gövde fontu ölçütleri geçmek zorunda; başlık fontu yalnız ≥ 20sp'de kullanılır)
| Tema | Gövde adayı | Başlık / vurgu adayı | Ruh |
|---|---|---|---|
| Ciddi | Atkinson Hyperlegible Next | (aynı aile, kalın) | Sakin otorite, okunabilirlik önce |
| Eğlenceli | Atkinson Hyperlegible Next | Nunito | Yuvarlak, sıcak |
| Genç | Lexend | Lexend (geniş, kalın) | Enerjik, rahat okunur |
| Kodcu | Atkinson Hyperlegible Next | JetBrains Mono (sayaç, sayılar, kod benzeri etiketler) | Terminal hissi; uzun gövde metni monospace değil |
| Sakin / Yüksek Kontrast / Minimal (öneri) | Atkinson Hyperlegible Next | — | Okunabilirlik ve düşük uyarım |

Kaçınılacaklar (frontend-design): her etikette TÜMÜ BÜYÜK HARF, başlıkta tek kelimeyi farklı renk/italikle vurgulama, içeriğin üstüne gereksiz küçük etiketler.

## 8. İkonlar
- **Tek ikon seti:** Material Symbols (Rounded), uygulamaya gömülü font olarak. Temalar ağırlık / dolgu / grade değiştirebilir; set değişmez. Emoji ikon yerine kullanılmaz.
- **Bir ikon = bir anlam.** Aynı ikon iki farklı anlamda kullanılmaz; aynı kavram her yerde aynı ikonla gösterilir.
- Yalnız ikondan oluşan her buton `tooltip` + `Semantics` etiketi taşır.
- Kayıt tablosu (yeni ikon eklemeden önce buraya yazılır; çakışma varsa eklenmez):

| Kavram | İkon |
|---|---|
| Bugün | `today` |
| Plan (takvim) | `calendar_month` |
| Odak oturumu | `timer` |
| Beyin | `psychology` |
| Profil / analiz | `person` |
| Ayarlar | `settings` |
| Ekle | `add` |
| Düzenle | `edit` |
| Sil | `delete` |
| Geri | `arrow_back` |
| Kapat | `close` |
| Arkadaşlar | `group` |
| Mesajlar | `chat` |
| Kök: Bedensel Hareket | `directions_run` |
| Kök: Motor Beceri | `front_hand` |
| Kök: Müzik ve Ritim | `music_note` |
| Kök: Öğrenme ve Bellek | `menu_book` |
| Kök: Planlama ve Problem Çözme | `extension` |
| Kök: Duygusal ve Sosyal Zeka | `handshake` |
| Kök: Dikkat ve Tefekkür | `self_improvement` |
| Kök: Yaratıcılık ve Sanat | `palette` |
| Kök: Dinlenme ve Uyku | `bedtime` |
| Uyku penceresi (ayar) | `bedtime` (aynı kavram) |
| Bitti / yapıldı | `check_circle` |
| Atla | `skip_next` |
| Saat / saati değiştir | `schedule` |
| Uyarı (çakışma, döngü, eksik ayar, hata) | `warning` |
| Bilgi | `info` |
| Boş zaman dilimi | `hourglass_empty` |
| Proje / proje önerisi | `flag` |
| Varyant seçimi | `alt_route` |
| Önerilen saat | `lightbulb` |
| Göreli bağlantı ("X sonrası") | `link` |
| Aç / kapa (genişlet) | `expand_more` · `expand_less` |
| Önceki / sonraki hafta | `chevron_left` · `chevron_right` |
| Alt kategori | `folder` |
| Ağaçta iş | `circle` |
| İç içe düzey | `subdirectory_arrow_right` |
| Taşı | `drive_file_move` |
| Sürükleme tutamacı | `drag_indicator` |
| Beyin bölgeleri / kanıt | `science` |
| Tarih | `event` |
| Plansız gün | `event_busy` |
| Dil | `translate` |
| Görünüm | `contrast` |
| Dokunsal geri bildirim | `vibration` |
| Konum | `location_on` |
| Bildirim | `notifications` |
| Tam zamanlı bildirim | `alarm` |
| Odak gerektirir (etiket) | `timer` (Odak oturumu ile aynı kavram) |

## 9. Erişilebilirlik
- **Kontrast (WCAG 2.2 AA):** normal metin ≥ 4.5:1; büyük metin, ikon ve arayüz bileşeni sınırları ≥ 3:1. Yüksek Kontrast teması AAA (7:1) hedefler. Her tema açık ve koyu modda ölçülür.
- **Dokunma alanı:** en az 48×48dp, hedefler arası en az 8dp.
- **Ekran okuyucu:** her etkileşimli öğenin anlamlı `Semantics` etiketi var; liste öğeleri `MergeSemantics` ile tek parça okunur; süs öğeleri gizlenir; odak sırası görsel sırayla aynı. Her ekran TalkBack ile denenir.
- **Metin ölçekleme:** `TextScaler` 2.0'da metin kesilmez, taşmaz; düzen gerekirse dikey akar.
- **Renk tek başına bilgi taşımaz:** grafiklerde etiket / desen / ikon da kullanılır.
- **Hareket hassasiyeti:** §5'teki azaltılmış hareket kuralı.
- **Otomatik test:** widget testlerinde Flutter'ın `androidTapTargetGuideline`, `labeledTapTargetGuideline` ve `textContrastGuideline` eşleyicileri her ekran için çalıştırılır.
- **3D beyin:** aynı bilginin metin / liste alternatifi zorunlu.

## 10. Metin ve ton
- Her tema kendi tonunu taşır (Ciddi: net ve kısa; Eğlenceli / Genç: sıcak, oyunbaz; Kodcu: teknik esprili) ama hiçbir tonda suçlama, utandırma ya da sahte aciliyet yok. Örn. sönen beyin bölgeleri için “İhmal ettin!” değil, nötr bir hatırlatma.
- Bilimsel cümleler yalnız SCIENCE.md'den; “beynin büyüdü” gibi ölçüm iddiası yok.
- Türkçe büyük/küçük harf dönüşümleri yerel ayarla yapılır (i → İ, ı → I).
- Gerçek içerik yoksa “Lorem ipsum” değil, ekranın amacını anlatan gerçekçi metin.

## 11. Öncelik sırası (ui-ux-pro-max'ten uyarlandı)
1. Erişilebilirlik · 2. Dokunma ve etkileşim · 3. Performans · 4. Navigasyon (öngörülebilir geri, alt menü ≤ 5, derin bağlantı) · 5. Stil tutarlılığı · 6. Düzen ve duyarlılık · 7. Tipografi ve renk · 8. Hareket · 9. Form ve geri bildirim · 10. Grafik ve veri.
Android geri tuşu / geri hareketi her ekranda tahmin edilebilir davranır (`PopScope`); sihirbazda bir önceki adıma döner.

## 12. Grafikler (Profil / Analiz)
Her grafikte başlık, eksen ve birim, dokununca değer, boş / yükleniyor durumu ve ekran okuyucu için tek cümlelik metin özeti bulunur. Renk paleti temadan gelir ve renk körlüğüne dayanıklıdır.

## 13. Teslim öncesi kontrol listesi (her ekran)
- [ ] Ekranın tek amacı bir cümleyle yazılabiliyor.
- [ ] Tüm butonların eylemi ve yükleniyor / hata / boş durumu var.
- [ ] Pop-up / alt kart kullanıldıysa §3 ölçütünü karşılıyor.
- [ ] Geçişler §5 tokenlarıyla; profil modunda 60 fps.
- [ ] Kontrast, 48dp, Semantics, metin ölçekleme 2.0 testleri geçiyor.
- [ ] İkonlar §8 kayıt tablosunda; çakışma yok.
- [ ] Metinler ARB'den (TR + EN), koda sabit metin yok.
- [ ] Açık ve koyu temada, en az iki temada görsel kontrol yapıldı.

## 14. Aday araçlar (kurulu değil)
- `erkamyaman/unslopovich` (MIT, 230★, 2026-11-17 güncel): Flutter dahil mobil UI kodunu çevrimdışı tarayan kural seti. Aşama 1'de ekranlar oluşunca yeniden değerlendirilecek.
- Referans: `Orange-OpenSource/a11y-guidelines` (mobil erişilebilirlik örnekleri).
