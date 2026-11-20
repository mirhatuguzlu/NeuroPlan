# PRODUCT.md — NöroPlan Ürün Gereksinimleri

Ürün adı: **NöroPlan** (Türkçe arayüz) / **NeuroPlan** (İngilizce arayüz).
Durum: Aşama 0 taslağı, 2026-11-18. Gereksinim kimlikleri (ör. `PLAN-3`) testlerde ve commit mesajlarında referans olarak kullanılır.

## 1. Özet
NöroPlan, kişinin kendi hayatını esnek bir şablonla tanımladığı, zorunlu işler yerleştikten sonra kalan boş zamanı hesaplayıp projeleri bu boşluklara bölen, odak oturumlarını sayan ve emeği 3D neon bir beyin üzerinde görselleştiren bir mobil planlama uygulamasıdır.

- Platform: Android öncelikli, iOS sonra. Herkese açık, girişli SaaS.
- Diller: Türkçe + İngilizce; ayarlardan değişir, varsayılan cihaz dili.
- Hedef kitle: 13 yaş ve üstü.
- İleride ücretli abonelik.

## 2. Ürün ilkeleri
1. **Uygulama kimsenin hayatını bilmiyormuş gibi davranır.** Hiçbir kişiye özel şey (ör. “nöbetçilik”, “maç”) hazır gelmez; rutinleri, işleri, alt kategorileri kullanıcı oluşturur. Sabit olan yalnızca bilimsel kök kategorilerdir (SCIENCE.md).
2. **Bilim abartılmaz.** 3D beyin bir metafordur; tüm iddialar SCIENCE.md'den gelir.
3. **Önce cihazda çalışır.** İnternet yokken plan, sayaç ve beyin tam çalışır; bağlantı gelince eşitlenir.
4. **Sade ve tek amaçlı ekranlar.** UX_RULES.md'ye uyulur.

## 3. Kullanıcı tipleri (örnek, ürün bunlara sabitlenmez)
| Tip | İhtiyaç | Önerilen tema |
|---|---|---|
| Lise / üniversite öğrencisi (13+) | Ders, sınav, proje takibi; odaklanma | Genç, Eğlenceli |
| Çalışan profesyonel | Vardiya / toplantı arası boşlukları verimli kullanma | Ciddi |
| Yazılımcı | Uzun derin çalışma blokları, kod projeleri | Kodcu |
| Düzensiz programlı kişi | Her gün farklı; plansız günler | Sakin (öneri) |
| Görme / dikkat hassasiyeti olan kullanıcı | Yüksek okunabilirlik, düşük uyarım | Yüksek Kontrast (öneri), Sakin (öneri) |

## 4. Kapsam
**v1 (ilk sürüm):** Bölüm 5'teki tüm modüller, sosyal özellikler dahil.
**Sonra:** iOS yayını, ücretli abonelik, ek temalar, giyilebilir cihaz / takvim entegrasyonları.

## 5. İşlevsel gereksinimler

### 5.1 Hesap ve giriş (`AUTH`)
- `AUTH-1` Supabase Auth ile kayıt / giriş. Yöntemler: **Google** ve **misafir** (Supabase anonim kullanıcı); e-posta girişi yok (DECISIONS D17). Google girişi uygulama içinde sistemin hesap seçicisiyle yapılır, tarayıcıya yönlenmez (D50). Apple girişi iOS aşamasında değerlendirilir.
- `AUTH-2` Kayıtta yaş beyanı; 13 yaş altı kayıt olamaz. 13–17 yaş için ek korumalar (bkz. 8).
- `AUTH-3` Hesabı ve tüm verileri silme uygulama içinden yapılabilir (Play Store şartı).
- `AUTH-4` Misafir modu var: uygulama girişsiz tam çalışır, veriler cihazda tutulur. Google'a bağlanınca aynı kullanıcı kalıcı olur ve veri taşınmaz. Sosyal özellikler giriş ister (D17).

### 5.2 Esnek yaşam şablonu (`PLAN`)
Kullanıcı hayatını aşağıdaki öğe türleriyle tanımlar. Her öğe bir kategoriye (dolayısıyla bir kök kategoriye) bağlıdır.
| Tür | Tanım | Zaman davranışı |
|---|---|---|
| Rutin | Tekrarlanan zorunlu iş | Tekrar kuralı (günlük, haftanın günleri, her N günde bir, ayın günü, vardiya döngüsü gibi özel desenler) + saat aralığı |
| Tek seferlik iş | Belirli tarih/saatte bir kez | Sabit zaman |
| Son tarihli görev | Bitiş tarihi olan, zamanı esnek iş | Tahmini süre + son tarih; boşluklara yerleşir |
| Proje | Büyük hedef, alt görevlere ayrılır | Toplam tahmini süre; boşluklara bölünür |
| Serbest zaman | Kullanıcının bilerek boş bıraktığı blok | Planlamaya kapalı |
| Plansız gün | Hiçbir otomatik yerleştirme yapılmayan gün | Tüm gün planlamaya kapalı |

- `PLAN-1` Her öğe oluşturma işlemi adım adım sihirbazla yapılır (tür → ad → kategori → zaman → onay).
- `PLAN-2` Tekrar kuralları istisna kabul eder (tek bir günü atla / taşı).
- `PLAN-3` Hiçbir örnek öğe hazır gelmez; boş durum ekranı kullanıcıyı ilk öğesini oluşturmaya yönlendirir.

### 5.3 Boş zaman hesaplama ve proje bölme (`SLOT`)
- `SLOT-1` Gün penceresi (uyanış–uyku) kullanıcı tarafından tanımlanır.
- `SLOT-2` Boş zaman = gün penceresi − (rutinler + tek seferlik işler + serbest zaman) − tamponlar. Plansız günlerde boş zaman hesaplanmaz.
- `SLOT-3` Projeler ve son tarihli görevler boşluklara **otomatik** (öneri olarak gösterilir, kullanıcı onaylar) ya da **manuel** (sürükle-bırak) bölünür.
- `SLOT-4` Ayarlar: en kısa parça süresi, parçalar arası tampon, günlük azami odak süresi.
- `SLOT-5` Son tarihe yetişmeyecek bir proje varsa kullanıcı uyarılır ve seçenek sunulur (süreyi azalt, tarihi uzat, serbest zamandan al).
- `SLOT-6` Algoritma deterministik ve birim testli olur; aynı girdi aynı planı üretir.

### 5.4 Kategoriler (`CAT`)
- `CAT-1` 9 sabit kök kategori: Bedensel Hareket, Motor Beceri, Müzik ve Ritim, Öğrenme ve Bellek, Planlama ve Problem Çözme, Duygusal ve Sosyal Zeka, Dikkat ve Tefekkür, Yaratıcılık ve Sanat, Dinlenme ve Uyku (SCIENCE.md §3).
- `CAT-2` Kök kategoriler silinemez, yeniden adlandırılamaz; kullanıcı altına sınırsız derinlikte alt kategori ya da doğrudan iş ekler.
- `CAT-3` Her kök kategori, SCIENCE.md'deki kanıt düzeyiyle sınırlandırılmış ağırlıklarla beyin bölgelerine bağlıdır. Ağırlık tablosu veri olarak tutulur, kodda dağınık sabit olarak değil.
- `CAT-4` Alt kategori taşınabilir; taşınınca geçmiş oturumların kök ataması değişmez (geçmiş korunur).

### 5.5 Odak oturumu (`FOCUS`)
- `FOCUS-1` Odak gerektiren işlerde sayaç başlatılabilir. Modlar:
  - **Serbest:** süre sınırı yok, kullanıcı bitirir.
  - **Pomodoro:** çalışma / mola süreleri ayarlanabilir (varsayılan 25/5), uzun mola aralığı ayarlanabilir.
  - **Derin çalışma:** tek, uzun, kesintisiz blok; hedef süre ayarlanabilir.
- `FOCUS-2` **Kaçış kuralı:** Oturum sırasında kullanıcı uygulamadan çıkarsa veya bildirim panelini aşağı çekerse 10 saniyelik geri sayım başlar ve dönmesi istenir (bildirim + titreşim). 10 saniye içinde dönmezse oturum **bozulur**.
- `FOCUS-3` Bozulan oturum silinmez; “bozuldu” olarak kaydedilir, beyne katkı vermez, istatistikte ayrı gösterilir.
- `FOCUS-4` Pomodoro molası sırasında uygulamadan çıkmak kaçış sayılmaz.
- `FOCUS-5` Ödül kuralı (SCIENCE.md §4): Pomodoro'da süreklilik (art arda tamamlanan oturum) ve oturum sayısı; derin çalışmada en uzun kesintisiz süre ödüllendirilir.
- `FOCUS-6` İstisnalar (D33): ekranın kapanması / kilitlenmesi kaçış sayılmaz, oturum arka planda sürer. Gelen arama telefon durumu izni varsa cezasızdır; izin yoksa dönüşte "cezayı kaldırayım mı?" diye sorulur. Alarm ayrıca algılanmaz, acil durum hakkı kullanılır.
- `FOCUS-7` Uyarı (D35): kaçışta üstten kayan, titreşimli bildirim 10 sn geriye sayar; dokununca uygulamaya dönülür; süre dolunca yerini "Odak bozuldu" bildirimi alır. Odak bloğunda uygulama sabitlenir (D36): Android onay ister, sabitliyken başka uygulama açılamaz; molada ve acil durumda sabitleme kalkar.
- `FOCUS-8` Duraklat sayacı durdurur, kural sürer. Acil durum cezasız duraklatır ve çıkmayı serbest bırakır, günde 3 kez (D34).
- `FOCUS-9` İsteğe bağlı Rahatsız Etmeyin: oturumda açılır, bitince eski haline döner. Odak ekranında sistem çubukları gizlidir.
- `FOCUS-10` Bitiş adımları, her biri atlanabilir: odak puanı 1–5 → yorgunluk 1–5 → kısa not → beyin kazanımı. Bozulan oturumda ne olduğu sakin dille anlatılır, yeniden başlatma önerilir.

### 5.6 3D Beyin (`BRAIN`)
- `BRAIN-1` Uygulama içine gömülü WebView'da yerel Three.js sahnesi; JS köprüsüyle Flutter'a bağlı. Sahne ve kütüphane uygulamaya asset olarak gömülür, CDN kullanılmaz, çevrimdışı çalışır.
- `BRAIN-2` Tamamlanan her odak oturumu, işin kök kategorisine bağlı bölgelerde ağırlıklarla orantılı nöron ve bağlantı olarak büyür.
- `BRAIN-3` İhmal edilen bölgeler zamanla söner (parlaklık düşer) ama nöronlar silinmez; yeniden çalışınca canlanır.
- `BRAIN-4` Bölgeye dokununca: bölge adı, bağlı kök kategoriler, toplam süre ve SCIENCE.md'deki kaynaklı açıklama + kanıt düzeyi gösterilir. “Beynin büyüdü” gibi ölçüm iddiası yapılmaz.
- `BRAIN-5` Performans: orta seviye Android cihazda 60 fps hedef; düşük uç cihazda nöron sayısı ve efektler otomatik azaltılır.
- `BRAIN-6` Erişilebilirlik: 3D sahnenin metin / liste alternatifi bulunur (ekran okuyucu ile aynı bilgi).

### 5.7 Profil ve analiz (`STATS`)
- `STATS-1` Kök kategori ve alt kategori bazında zaman dağılımı.
- `STATS-2` Günlük / haftalık / aylık zaman serisi; planlanan vs gerçekleşen.
- `STATS-3` Odak modlarının kişisel karşılaştırması (tamamlanma oranı, ortalama süre, bozulma oranı) — “hangisi sana daha iyi geliyor” kullanıcının kendi verisiyle.
- `STATS-4` En verimli saat aralıkları, seriler, en uzun derin çalışma.
- `STATS-5` Her grafik boş durumu, yükleniyor durumu ve erişilebilir metin özeti içerir.

### 5.8 Temalar (`THEME`)
- `THEME-1` İstenen temalar: **Ciddi, Eğlenceli, Genç, Kodcu.**
- `THEME-2` Ek temalar (2026-11-20 onaylandı, D54):
  - **Sakin:** düşük doygunluk, az hareket, az bildirim dili; akşam kullanımı ve dikkat hassasiyeti için.
  - **Yüksek Kontrast:** WCAG AAA hedefli kontrast, kalın odak çerçeveleri; az görenler için.
  - **Minimal:** tek vurgu rengi, süssüz; dikkat dağıtmayan sade görünüm.
- `THEME-3` Her tema; renk paleti (açık + koyu), font çifti, ikon ağırlığı, hareket yoğunluğu ve metin tonunu birlikte tanımlar (UX_RULES.md §4–6).
- `THEME-4` 3D beynin neon renkleri temaya uyar.

### 5.9 Dil (`I18N`)
- `I18N-1` Türkçe ve İngilizce; Flutter yerelleştirme (ARB). Kodda sabit metin yok.
- `I18N-2` Türkçe büyük/küçük harf kuralları (i/İ, ı/I) doğru uygulanır.
- `I18N-3` Tarih, saat, sayı biçimleri yerel ayara göre.

### 5.10 Sosyal (`SOCIAL`) — v1
Aşama 4B'de uygulandı; güvenlik ve uyum: [SOCIAL_SAFETY.md](SOCIAL_SAFETY.md), kararlar D42–D48.
- `SOCIAL-0` Sosyal özellikler Google hesabı ve **15 yaş** ister (D43). 15–17 yaş sıkı modda: genel sıralama yok, süreklilik metriği yok, kullanıcı adıyla bulunabilirlik kapalı başlar.
- `SOCIAL-1` Arkadaş ve partner **yalnızca davetle** eklenir: davet kodu, QR kodu ya da tam kullanıcı adı (yalnız bulunabilirliği açık hesaba). Herkese açık arama, öneri, keşfet, rastgele eşleşme yok. Partner karşılıklı onayla kurulur; kişi başına bir partner (veritabanı kısıtı).
- `SOCIAL-2` Plan görünürlüğü kategori bazında: tam / başlık ve saat / meşgul / gizli; kitle partner ve arkadaşlar ayrı; kişi bazında istisna ("bu kişiye tam göster"). Kural yoksa partner "başlık ve saat", diğer arkadaşlar "meşgul" (D44). Kurallar veritabanında uygulanır.
- `SOCIAL-3` Canlı ortak odak oturumu (en çok 4 kişi, sayaçlar sunucu anıyla); isteğe bağlı sesli sohbet, mikrofon kapalı başlar. Ses kaydedilmez. Birlikte tamamlanan oturum küçük bir ortak bağlantı kazandırır.
- `SOCIAL-4` Ortak etkinlik ve proje: kabul edilince herkesin planına düşer, ilerleme paylaşılır, değişiklikler onaya gider.
- `SOCIAL-5` Ortak boş zaman bulma: yalnızca boş aralıklar döner, iş içerikleri paylaşılmaz.
- `SOCIAL-6` Mesajlaşma: birebir, yazılı + hazır tepkiler; fotoğraf/dosya yok; küfür yıldızlanır; hız sınırı; odak sırasında bildirim susar. Grup mesajı açık konu.
- `SOCIAL-7` Beyin karşılaştırma (arkadaş izin verdiyse, sunucuda hesaplanan beyin) ve sıralama (arkadaşlar; isteğe bağlı genel tablo yalnız yetişkinler). Haftalık, odak dakikası + süreklilik, yalnız doğrulanan oturumlar.
- `SOCIAL-8` Güvenlik: engelle, şikâyet et, daveti geri al, arkadaşlıktan çıkar her sosyal ekrandan erişilebilir; şikâyetler Supabase'de incelenir.

### 5.11 Abonelik (`SUB`) — ileride
- `SUB-1` Google Play Billing (iOS'ta App Store). Hangi özelliklerin ücretli olacağı açık konu.
- `SUB-2` Ücretsiz sürüm planlama + odak + beyin çekirdeğini kapsar (öneri).

## 6. İşlevsel olmayan gereksinimler
| Alan | Gereksinim |
|---|---|
| Offline-first | Yerel SQLite tek doğru kaynaktır; değişiklikler kuyruğa alınıp Supabase'e eşitlenir. Çakışmada alan bazlı son yazan kazanır (DECISIONS D16, ARCHITECTURE §5). |
| Güvenlik | Supabase RLS her tabloda açık; istemcide yalnız anon/publishable key; `service_role` yalnız Edge Functions'ta. |
| Gizlilik | En az veri; sosyal paylaşım varsayılan kapalı; analiz verisi cihazda hesaplanır. |
| Performans | Sayfa geçişleri ve 3D beyin 60 fps hedef; soğuk açılış hedefi Aşama 1'de ölçülüp belirlenir. |
| Erişilebilirlik | WCAG 2.2 AA; 48dp dokunma alanı; ekran okuyucu etiketleri; metin ölçekleme %200'e kadar bozulmaz. |
| Kalite | Her özellik testli; `flutter analyze` temiz; bilimsel metin SCIENCE.md'den. |

## 7. Ekran listesi (taslak, Aşama 1'de kesinleşir)
Karşılama + ilk kurulum sihirbazı · Bugün · Plan (takvim) · Öğe oluşturma sihirbazı · Kategoriler · Odak oturumu · Beyin · Profil/Analiz · Sosyal (arkadaşlar, mesajlar, ortak oturum) · Ayarlar (tema, dil, bildirim, hesap).
Alt menü (floating) en fazla 5 hedef içerir; öneri: Bugün · Plan · Odak · Beyin · Profil.

## 8. Hukuk ve uyum (açık konular — yayın öncesi uzman görüşü gerekir)
- **Yaş:** 13+ hedef. KVKK ve GDPR Madde 8 kapsamında dijital onay yaşı ülkeye göre 13–16 arası değişir; bazı ülkelerde 13–15 yaş için ebeveyn onayı gerekebilir.
- **Google Play:** Hedef kitle ve içerik beyanı; 13 yaş altını hedeflemediğimiz için “Aileler” programı dışında kalınır, ama reşit olmayan kullanıcılar için kullanıcı üretimli içerik (mesajlaşma, sesli oturum) politikaları geçerlidir.
- **Mesajlaşma ve sesli oturum:** engelleme + şikâyet + moderasyon süreci zorunlu; 13–17 yaş için yetişkinlerle iletişim kısıtları değerlendirilecek.
- **Veri silme ve dışa aktarma** uygulama içinden yapılabilmeli.

## 9. Teknik riskler ve prototiple doğrulanacaklar
1. **Bildirim panelini çekmeyi algılama:** Android'de panelin çekilmesi uygulamayı arka plana atmaz; pencere odağını değiştirir. Flutter'ın `AppLifecycleState.inactive` bildiriminin tüm cihaz/sürümlerde güvenilir gelip gelmediği prototiple test edilecek. Aşama 3: yerel `onWindowFocusChanged` olayı kullanılıyor; gerçek cihazda `docs/QA_CHECKLIST.md` ile doğrulanacak.
2. **10 saniyelik geri sayım arka planda:** Uygulama arka plandayken sayaç çalışmayabilir. Öneri: çıkış anının zaman damgası kaydedilir, dönüşte geçen süre hesaplanır; uyarı için yerel bildirim zamanlanır. Ön plan servisi gerekip gerekmediği test edilecek. Aşama 3: çıkış anı kaydediliyor, uyarı ve "bozuldu" değişimi native zamanlayıcıyla, ön plan servisi süreci canlı tutuyor (D35).
3. **WebView + Three.js performansı** düşük uç Android cihazlarda; bellek ve pil tüketimi.
4. **Eşitleme çakışmaları** (iki cihazda aynı öğe düzenlenirse).
5. **Canlı sesli oturum altyapısı** (WebRTC sağlayıcısı, maliyet) — açık karar.

## 10. Açık sorular
- Grup mesajlaşma (`SOCIAL-6`).
- Ücretli özellik sınırları (`SUB-1`).
