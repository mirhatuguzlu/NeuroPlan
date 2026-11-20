# QA_CHECKLIST.md — Gerçek cihaz manuel test listesi

Emülatör davranışına güvenilmez (lifecycle, pencere odağı, ekran kilidi, arama ve ön plan servisi cihaza ve üreticiye göre değişir). Her madde **gerçek Android cihazda** denenir. Sonuç, cihaz modeli ve Android sürümüyle birlikte not edilir.

Hazırlık: `flutter run` (ya da `flutter build apk --debug` ve kurulum). Bugün'de "odak gerektirir" etiketli bir iş olsun. Bildirim izni verilsin.

## A. Odak oturumu (Aşama 3)

### A1. Başlatma ve sayaç
- [ ] Bugün → işe dokun → "Odaklan": mod, işin varsayılanıyla seçili gelir; tek dokunuşla değişir.
- [ ] Pomodoro "Süreleri değiştir" açılır, seçilen değer özette görünür; sonraki oturumda hatırlanır.
- [ ] "Başla" → odak ekranı: durum çubuğu ve gezinme çubuğu gizli (immersive), büyük sayaç saniye saniye iner.
- [ ] Bildirim panelinde kalıcı "Süren odak oturumu" bildirimi: kalan süre geri sayar, "Duraklat" ve "Bitir" var, kaydırarak silinemez.
- [ ] Android 14+: uygulama çökmeden açılır (ön plan servis türü `specialUse`). `adb logcat | grep -i foreground` hata göstermez.
- [ ] Geri tuşu / geri hareketi oturumu kapatmaz, "Bitir'e dokun" uyarısı çıkar.

### A1b. Uygulama sabitleme (D36)
- [ ] "Başla" → Android "Uygulama sabitlensin mi?" onayını gösterir; onay penceresi açıkken 10 sn uyarısı **gelmez**.
- [ ] Onaylayınca: ana ekran, son uygulamalar ve bildirim paneli açılmaz; başka uygulamaya geçilemez.
- [ ] Onaylamazsan (ya da Ayarlar'da "Uygulama sabitleme" kapalıysa) oturum yine başlar; uygulamadan çıkınca 10 sn uyarısı gelir. Sabitleme kapalıyken onay penceresinin hiç çıkıp çıkmadığı not edilir.
- [ ] Sabitlemeden çık (gezinme hareketine göre: geri + son uygulamalar basılı tut ya da yukarı kaydırıp tut) → uygulama önde kalır, oturum sürer. Sonra uygulamadan çıkarsan 10 sn kuralı işler.
- [ ] "Sabitlemeyi kaldırmadan önce PIN iste" açıksa: sabitlemeden çıkınca kilit ekranı gelir; PIN'i 10 sn'den uzun sürede girsen de oturum bozulmaz (kilit açılınca 10 sn başlar, uygulama öne gelir).
- [ ] Pomodoro molası ve acil durum başlayınca sabitleme kalkar (çıkmak serbest); "Devam" ile odak başlayınca onay yeniden istenir.
- [ ] Oturum bitince ve bozulunca sabitleme kalkar.
- [ ] Sabitliyken gelen arama: arama ekranı açılabiliyor mu, aramadan sonra uygulamaya dönülüyor mu (not et).
- [ ] Xiaomi / HyperOS'ta sabitleme davranışı (onay penceresi, çıkış hareketi) not edilir.

### A2. Planı bozma: 10 sn kuralı
Not: Bu bölüm sabitleme onaylanmadan ya da sabitlemeden çıkıldıktan sonra denenir.
- [ ] **Ana ekrana çıkma:** Ana ekran tuşu/hareketi → hemen (≤ 1 sn) üstten kayan, titreşimli "Planı bozuyorsun" bildirimi; içinde 10 sn geri sayar.
- [ ] **Başka uygulama açma:** Son uygulamalardan başka uygulamaya geç → aynı uyarı.
- [ ] Uyarıya dokun → uygulamaya dönülür, oturum sürer; uyarı kalkar.
- [ ] 10 sn içinde dönüş → oturum sürer; bitişte istatistikte bir kesinti (`focus_interruptions`, `recovered = true`, `counted = true`).
- [ ] 10 sn geç → uyarının **yerine** "Odak bozuldu" bildirimi gelir, kalıcı odak bildirimi kaybolur.
- [ ] Sonra uygulamaya dön → "Oturum bozuldu" ekranı: saat, sakin açıklama, "Yeniden başlat" ve "Bugün'e dön".
- [ ] **Bildirim paneli:** Odak ekranında paneli çek (immersive'de iki kez kaydırma) → uyarı gelir, uygulama arkada kırmızı tam ekran geri sayım gösterir. Paneli kapat → oturum sürer, kesinti nedeni `notification_shade`.
- [ ] Paneli çekip orada başka uygulamanın bildirimine dokun → neden `app_left`, süre panelin açıldığı andan.
- [ ] **Son uygulamalardan süpürme:** Odaktayken son uygulamalara geç, uygulamayı süpür → 10 sn sonra yine "Odak bozuldu" bildirimi gelir (Flutter motoru ölse de). Uygulamayı yeniden aç → "Oturum bozuldu" ekranı.

### A3. Haksız ceza yok
- [ ] **Güç tuşuyla ekranı kapat:** uyarı gelmez. 2 dk bekle, aç, kilidi aç → uygulama öne gelir, oturum sürer, sayaç arada da saymıştır.
- [ ] **Ekran kendiliğinden kapanır** (ekran zaman aşımı): aynı sonuç.
- [ ] Kilidi açıp uygulamaya dönmeden başka uygulamaya geç (kilit ekranındaki bir bildirimden) → kilit açıldıktan 10 sn sonra bozulur.
- [ ] **Gelen arama, izin verildi** (Profil → Odak → "Gelen aramalar kaçış sayılmasın"): aramayı aç, 1 dk konuş, kapat → uyarı çalmaz; arama bitince uygulamaya dönülürse oturum sürer; arama süresi odak süresine eklenmez.
- [ ] **Gelen arama, izin yok:** aramayı aç, 1 dk konuş, kapat, uygulamaya dön → "Aramadaymışsın gibi görünüyor" sorusu; "Evet" → oturum sürer, "Hayır" → bozuldu ekranı.
- [ ] İnternet araması (WhatsApp vb.) izin yokken de aynı soruyu getirir (ses modu `IN_COMMUNICATION`).
- [ ] **Pomodoro molası:** mola başlayınca "Mola zamanı" bildirimi; molada uygulamadan çık, 3 dk sonra dön → ceza yok.
- [ ] Mola bitince "Mola bitti" bildirimi; sayaç kendiliğinden başlamaz, "Devam" bekler; geç dönmek ceza değildir.
- [ ] **Acil durum:** onay → oturum cezasız duraklar; uygulamadan çık, 5 dk sonra dön → ceza yok; "Devam" ile sürer. Günde 3 kez; dördüncüde buton devre dışı ve nedeni yazılı.
- [ ] **Normal Duraklat:** sayaç durur; uygulamadan çıkınca yine 10 sn uyarısı gelir.

### A4. Kurtarma
- [ ] Odaktayken uygulamayı zorla durdur (Ayarlar → Uygulama → Durmaya zorla) ve 10 sn içinde yeniden aç → oturum kaldığı yerden sürer, sayaç doğru.
- [ ] Pomodoro sırasında ekranı kapat, 1 saat bekle, aç → sayaç "Mola bitti · hazır olunca devam et" durumunda; odak süresi tam 25 dk.
- [ ] Telefonu odak sırasında yeniden başlat → açılışta oturum bozulmuş gösterilir ya da (ekran kapalıyken kapandıysa) sürer; Rahatsız Etmeyin eski haline dönmüştür.

### A5. Rahatsız Etmeyin
- [ ] Profil → Odak → "Odakta Rahatsız Etmeyin" → sistem erişim ekranı açılır; izin verince anahtar açık kalır, vermeyince kapalı kalır ve neden yazılır.
- [ ] Oturum başlayınca DND açılır; bitince, bozulunca ve uygulama süpürülüp oturum bozulunca **önceki** haline döner (önceden açıksa açık kalır).
- [ ] DND açıkken "Planı bozuyorsun" uyarısı yine görünür ve titrer.

### A6. Bildirimden eylemler
- [ ] Kalıcı bildirimdeki "Duraklat" → uygulama açılır, sayaç durur; "Devam" görünür.
- [ ] "Bitir" → uygulama açılır, bitiş adımları başlar.

### A7. Bitiş adımları
- [ ] Odak puanı → yorgunluk → not → beyin kazanımı; her biri "Şimdilik geç" ile atlanır, geri tuşu bir önceki adıma döner.
- [ ] Kazanım ekranı: "X ile ilişkilendirilen bölgelere N dk ayırdın", bölge çubukları dolar; "beyninin ölçümü değildir" açıklaması var; "beynin büyüdü" gibi cümle yok.
- [ ] Pomodoro: döngü ve seri; derin çalışma: en uzun kesintisiz süre ve rekor.

### A8. Üretici ve sürüm farkları
- [ ] Pil kısıtlaması agresif bir cihazda (Xiaomi / Huawei / Samsung "uyku modu") A2 ve A3 yeniden denenir; uyarının ve "bozuldu" değişiminin geldiği not edilir.
- [ ] Android 13 (bildirim izni ilk başlatmada istenir), Android 14 ve 15'te A1–A2.

### A9. Erişilebilirlik
- [ ] Sistem ayarında "animasyonları kaldır" açıkken ışıma durağan, geçişler anlık.
- [ ] Yazı boyutu en büyükte odak ekranı ve bitiş adımları taşmaz.
- [ ] TalkBack: sayaç "Kalan 12 dk" diye okunur; butonlar etiketli; bozuldu ekranında başlık önce okunur.

## B. 3D beyin (Aşama 4)
Hazırlık: en az bir tamamlanmış ve bir bozulmuş odak oturumu olsun (farklı kök kategorilerde). Fps ölçümü için `flutter run --profile`; `adb logcat | grep "\[brain\] fps"` 5 sn'de bir satır yazar.

### B1. Açılış ve görünüm
- [ ] Uygulama açılıp birkaç saniye sonra Beyin sekmesine geçince sahne hazır gelir (ön ısıtma); "Beyin hazırlanıyor" en çok bir an görünür.
- [ ] Yarı saydam kabuk, kenarlarda parlama, lob sınırlarında ince çizgiler; dolu katman yok. İç yapılar (hipokampüs, amigdala…) kabuğun içinden seçilir.
- [ ] Nöronlar beslenen bölgelerde, o bölgeyi en çok besleyen kategorinin renginde parlar; bozulan oturumun bölgelerinde sönük noktalar var.
- [ ] Ara sıra bir bağ boyunca ışık darbesi kayar. Sistemde "animasyonları kaldır" açıksa dönme, pırıltı ve darbe yok.
- [ ] Açık ve koyu görünümde sahne koyu kalır; renkler temadan gelir.
- [ ] Uçak modunda da açılır (internet gerekmez).

### B2. Etkileşim
- [ ] Tek parmakla döner, iki parmakla yakınlaşır/uzaklaşır; sekme kaydırmaz.
- [ ] Çift dokunuş ve "Görünümü sıfırla" kamerayı başa alır.
- [ ] Bir bölgeye dokununca bölge sayfası: üstte o bölge yakında, kalanı silik; altta ad, nöron / parlaklık, son 30 gün, besleyen kategoriler, kanıt düzeyi ve DOI'ler. Geri tuşu genel görünüme döner.
- [ ] Zaman çizelgesini geriye çekince beyin o günkü haliyle çizilir; "Bugün" düğmesi geri getirir.
- [ ] Yeni bir oturum bitirip Beyin'e gelince kazanılan bölgeler bir kez parlar (bozulan oturumda ceza rengiyle).

### B3. Performans
- [ ] Orta seviye cihazda yüksek ya da orta kademede ≥ 55 fps (5 sn'lik rapor ortalaması). Sonuç docs/BRAIN_MODEL.md §6'ya yazılır.
- [ ] Düşük seviye cihazda ≥ 30 fps; gerekirse kademe kendiliğinden iner (`[brain] fps … (low)`).
- [ ] Başka sekmeye geçince ve uygulama arka plandayken fps satırları durur (çizim yok).
- [ ] 10 dakika açık kalınca cihaz aşırı ısınmaz, bellek artmaz (Android Studio Profiler ya da `adb shell dumpsys meminfo com.mirhatuguzlu.neuroplan`).

### B4. Erişilebilirlik
- [ ] TalkBack açıkken Beyin sekmesi doğrudan bölge listesini gösterir; her satır ad, nöron ve parlaklıkla okunur; satırdan bölge sayfası açılır.
- [ ] Yazı boyutu en büyükte bölge sayfası ve liste taşmaz.

### B5. Göç (Aşama 3'ten güncelleyenler)
- [ ] Aşama 3 kurulumunun üstüne kurulunca uygulama açılır; eski oturumlar beyinde görünür (olaylar v2 kurallarıyla yeniden türetilir).

## C. Birlikte: sosyal, gerçek zaman ve ses (Aşama 4B)
**İki gerçek cihaz** ve iki ayrı Google hesabı gerekir (A ve B; mümkünse biri Android 14+). Hazırlık:
- Uzak Supabase'e `20261120120000_social_v1.sql` ve `20261120120100_brain_input.sql` uygulanmış, Edge Functions (`delete_account`, `voice_token`, `brain_snapshot`) yayınlanmış, Realtime ayarlarında **"Allow public access" kapalı** olmalı.
- Supabase Auth: Google sağlayıcısı açık, anonim giriş açık, manuel bağlama açık. `.env`'de `GOOGLE_WEB_CLIENT_ID`.
- Ses için Edge Function sırları: `LIVEKIT_URL`, `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET`.
- Her iki hesapta doğum yılı 18+; bir de 15–17 ve 13–14 yaş için üçüncü hesap (C1).

### C1. Kapı ve yaş
- [ ] Yeni kurulumda ikinci adım "Doğum yılın": atlanamaz; 13 yaşından küçük yıl seçilince "İleri" kapalı ve neden yazılı.
- [ ] Misafir: Birlikte → "Google ile bağlan"; bağlanınca planın ve beynin aynı kalır (yeni kullanıcı yok, `linkIdentity`).
- [ ] Aynı Google hesabı başka cihazda zaten varsa: o hesaba geçilir, bu cihazdaki işler o hesapta da görünür (D42).
- [ ] 13–14 yaş hesabı: Birlikte "15 yaşında açılır" der, başka bir şey açılmaz.
- [ ] 15–17 yaş hesabı: Gizlilik'te "Genel sıralamaya katıl" kapalı ve nedeni yazılı; Sıralama'da "Genel" seçilemez, süreklilik sekmesi yok.
- [ ] Takma ad ekranında topluluk kuralları metni var; "Kabul et ve başla" olmadan devam edilemez.

### C2. Arkadaşlık ve partner
- [ ] A kod oluşturur → QR ve 10 karakterlik kod görünür; B "QR kodu tara" ile okur → ikisi de arkadaş listesinde birbirini görür.
- [ ] Aynı kodu üçüncü kişi kullanmaya çalışınca "Bulunamadı ya da artık geçerli değil" (tek kullanımlık).
- [ ] A kendi kodunu kullanamaz.
- [ ] B kullanıcı adı belirleyip "bulunabilir" açar; A tam kullanıcı adıyla istek gönderir, B kabul eder. Bulunabilirlik kapalıyken istek "bulunamadı" der.
- [ ] Partner daveti kodu: kullanınca doğrudan partner olunur. A'nın partneri varken C partner isteği gönderemez ("önce o partnerlik bitmeli").
- [ ] Partnerliği bitir → ikisi de arkadaş kalır.
- [ ] Arkadaşlıktan çıkar → karşı tarafın listesinden de kalkar; sohbete yazılamaz.
- [ ] Engelle → onay sorulur; engellenen artık A'nın planını, beynini, sohbet geçmişini göremez, A'nın kodunu kullanamaz ("geçersiz kod"), A'yı kullanıcı adıyla bulamaz.

### C3. Plan görünürlüğü
- [ ] A'nın planında bir iş var (Birlikte'yi açtıktan ~20 sn sonra yayınlanır). B, A'nın planını "Bugün" ve "Hafta" olarak salt okunur görür.
- [ ] Partner değilken B yalnız "Meşgul" görür; partner olunca başlık ve saati görür.
- [ ] A Gizlilik → Partner → o kök kategoriyi "Gizli" yapar → B'nin ekranında iş kaybolur (yenileyince).
- [ ] A arkadaş sayfasında "Planımı bu kişiye tam göster" → B not ve kategoriyi de görür.
- [ ] Ortak boş zaman: A ve B seçilince yalnız boş aralıklar listelenir; A'nın gizli işi olan saat boş görünmez. "Burada planla" ortak etkinlik sihirbazını o saatle açar.

### C4. Ortak etkinlik ve proje
- [ ] A etkinlik önerir → B'de Birlikte rozeti; B kabul eder → iş ikisinin de Bugün/Plan ekranında sabit iş olarak görünür.
- [ ] A saati değiştirmeyi önerir → B onaylayana kadar değişmez; onaylayınca ikisinin planı güncellenir.
- [ ] Ortak proje: B o projede odak oturumu tamamlar → A ilerlemeyi görür.
- [ ] A iptal eder → iş ikisinin planından da kalkar.

### C5. Mesajlaşma
- [ ] A ve B arasında mesaj karşı tarafta 1–2 sn içinde görünür (Realtime); okunmamış rozeti sekmede ve listede.
- [ ] "siktir git" → karşı tarafta "****** git"; "Sıkıldım" değişmez.
- [ ] Dakikada 20'den fazla mesaj → "Biraz yavaşla" (gönderilmez).
- [ ] Basılı tut → tepki ver (iki tarafta görünür), kopyala, kendi mesajını sil ("Mesaj silindi"), karşı tarafın mesajını şikâyet et.
- [ ] B odak oturumundayken A mesaj atar → B'ye bildirim **gelmez**; oturum bitince "N yeni mesaj" özet bildirimi gelir.
- [ ] Sohbeti sessize al → arka planda bildirim gelmez.

### C6. Ortak odak (gerçek zaman)
- [ ] A iki arkadaşı davet eder (en çok 3); B'nin Birlikte ekranında davet kartı, "Katıl" → lobi. Lobide kimin bağlı olduğu canlı görünür.
- [ ] A ve B kendi işlerini ve farklı modları seçer; A "Herkesi başlat" → iki cihazda da odak ekranı **aynı anda** açılır, sayaçlar en çok 1–2 sn farkla aynıdır (iki cihazın saatini bilerek 1 dk farklı ayarlayıp da dene).
- [ ] Odak ekranının üstünde diğer katılımcı ve evresi (odakta / molada) görünür.
- [ ] B uygulamadan çıkıp 10 sn dönmez → B'nin oturumu bozulur; A'nın ekranında satır içi "B oturumdan çıktı. Sen devam edebilirsin." (pop-up yok); A'nın oturumu sürer.
- [ ] İkisi de tamamlarsa beyinde ortak bağlantı bonusu oluşur (Beyin → yeni bağ; birlikte tamamlanınca bir kez).
- [ ] Ağ kopup gelince (uçak modu 30 sn) kanal yeniden bağlanır, katılımcılar yeniden görünür.

### C7. Sesli sohbet
- [ ] Ses açık oturumda "Sese bağlan" → bağlanır, mikrofon **kapalı** başlar.
- [ ] Mikrofon düğmesi tek dokunuşla açılır/kapanır; ilk açılışta Android mikrofon izni ister; reddedilirse anlaşılır hata.
- [ ] Konuşan kişinin baş harfi vurgulanır ("konuşuyor").
- [ ] Bir kişiyi sessize al → yalnız bu cihazda duyulmaz; o kişi kendini duymaya devam eder.
- [ ] **Android 14+:** odakta mikrofon açıkken ekranı kapat / uygulama sabitliyken 2 dk konuş → ses kesilmez; `adb logcat | grep -i "foreground"` hata yok; kalıcı bildirim durum çubuğunda mikrofon göstergesiyle.
- [ ] Mikrofon açıkken uygulamadan çıkınca 10 sn kuralı aynen işler; bozulunca mikrofon kapanır.
- [ ] Oturum bitince ya da "Ayrıl" ile ses bağlantısı kapanır, mikrofon göstergesi kaybolur.
- [ ] LiveKit panosunda (Cloud) oturum için kayıt/egress **yok**.

### C8. Sıralama ve beyin karşılaştırma
- [ ] Arkadaş sıralamasında iki hesap da görünür; odak dakikası tamamlanan oturumlarla artar (yenileyince).
- [ ] Yalnız yetişkin ve "katıl" seçen hesap genel tabloda takma adıyla görünür.
- [ ] B "Arkadaşlarım beynimi görebilsin"i açınca A, B'nin sayfasından "Beyinleri karşılaştır" → Beyin sekmesinde iki beyin yan yana (solda A), altta bölge çubukları. Kapalıyken "izin yok" hatası.
- [ ] Geri tuşu karşılaştırmayı kapatır, sahne tek beyne döner.

### C9. Şikâyet ve moderasyon
- [ ] B, A'nın mesajını şikâyet eder → Supabase Studio'da `select * from moderation_queue;` kaydı ve mesaj kopyasını gösterir; A mesajı silse de kopya kalır.
- [ ] `select resolve_report('<id>', 'suspend_7d');` → A'nın Birlikte ekranı askı tarihini gösterir; plan/odak/beyin çalışır.

### C10. Hesap silme
- [ ] A Profil → Hesap → "Hesabı ve verileri sil" → onay → ilk kuruluma döner. B'nin listesinden A kalkar, sohbet ve ortak etkinlikler silinir; A hakkındaki şikâyet kimliksiz kalır.

### C11. Erişilebilirlik
- [ ] TalkBack: Birlikte sekmesi rozet sayısını okur; mesaj balonları "Sen: …" diye okunur; mikrofon düğmesi açık/kapalı durumunu söyler.
- [ ] Yazı boyutu en büyükte Birlikte ekranları, sohbet ve ortak odak şeridi taşmaz.

### C12. Mesaj push bildirimi (D49)
Hazırlık: SETUP_BACKEND §5–§7 yapılmış, `.env`'de dört `FIREBASE_*` değeri var.
- [ ] B'de uygulama tamamen kapalıyken (son uygulamalardan süpür) A mesaj atar → B'ye "A sana mesaj gönderdi" bildirimi gelir; metinde mesaj içeriği **yok**.
- [ ] Bildirime dokununca uygulama açılır ve doğrudan A ile sohbet açılır.
- [ ] B odak oturumundayken A mesaj atar → push **gelmez**; oturum bitince (uygulama açıksa) yerel özet gelir.
- [ ] B sohbeti sessize alınca push gelmez.
- [ ] B, A'yı engellerse A'nın mesajları push üretmez.
- [ ] Uygulama arka planda ama canlıyken tek bildirim gelir (çift değil).
- [ ] Dil İngilizce olan hesaba bildirim İngilizce gelir.
- [ ] Hesap silindikten sonra o cihaza push gelmez.

### C13. Web'den hesap silme
- [ ] Silme sayfası telefonda ve bilgisayarda okunur, koyu ve açık temada.
- [ ] `config.js`'te yalnız `contactEmail` varken: uygulama içi yol + e-posta yolu görünür, "sayfadan sil" görünmez.
- [ ] Supabase ayarı da varken: "Google ile giriş yap" → Google → sayfaya geri dönülür, e-posta görünür, silme düğmesi açılır; onay → "Hesabın ve verilerin silindi" ve Dashboard → Authentication'da kullanıcı yoktur.
- [ ] Hiç giriş yapılmadan silme düğmesi kapalıdır.

### C14. Bildirim izni ve uygulama içi Google girişi (D50)
- [ ] Temiz kurulum (Android 13+): ilk kurulumda "Bildirimlere izin verelim mi?" adımı çıkar; uygulama açılırken açıklamasız izin penceresi **çıkmaz**.
- [ ] "Bildirimlere izin ver" → sistem penceresi → İzin ver: "Bildirimler açık." yazar; Profil'de sıradaki iş bildirimi "10 dk önce" görünür.
- [ ] İki kez reddet, sonra düğmeye bas: uygulamanın bildirim ayarı açılır. Orada aç, uygulamaya dön: Profil'deki "Bildirimler kapalı" satırı kaybolur.
- [ ] Adım "Şimdilik geç" ile atlanınca Profil'de "Bildirimler kapalı · Aç" satırı görünür ve çalışır.
- [ ] Profil → Google ile bağlan: tarayıcı **açılmaz**, alttan sistem hesap seçicisi gelir; hesap seçilince bağlanır. Cihazda Google hesabı yoksa sistemin "hesap ekle" akışı açılır.
- [ ] Release (Play imzalı) sürümde de hesap seçici çalışır (Play imza SHA-1'i Google Cloud'da kayıtlı olmalı; yoksa "hata" görülür).

## D. Profil, analiz ve temalar (Aşama 5)
Otomatik testler: `flutter test test/ui/stats_test.dart` (12 sayfa boş/dolu, her tema × açık/koyu kontrast ve dokunma kuralı), `dart test` çekirdekte `test/stats/` (hesaplar ve 1 yıllık performans).

### D1. Font testi (UX_RULES §7)
- [ ] Her tema için `Il1| O0 rn m ğĞşŞıIiİçÇöÖüÜ 12:30 %50` dizisi 12sp, 14sp ve 16sp'de, açık ve koyu temada gerçek cihazda okunur; I/l/1 ve 0/O ayrılır. (Bir notta yazıp temaları sırayla değiştirerek bakılabilir.)
- [ ] Kalın başlıklar gerçekten kalın görünür (değişken font `wght` ekseni). Alt menüde seçili sekmenin etiketi kalın.
- [ ] Kodcu temasında büyük sayılar JetBrains Mono, gövde metni değil.

### D2. Temalar
- [ ] Ayarlar → Tema: yedi temanın her biri anında uygulanır; uygulama yeniden açılınca kalır; ikinci cihaza eşitlenir.
- [ ] İlk kurulumda görünüm adımında tema seçilebilir.
- [ ] Beyin sekmesi her temada okunur (sahne temanın koyu şemasından renk alır).
- [ ] Yüksek Kontrast temada kart ve düğme çerçeveleri kalın, odaklı alan belirgin.

- [ ] Eğlenceli: profil kartları ve analiz listesi farklı renklerde; Bugün satırları işin kök rengiyle boyalı. Genç: canlı bloklar. Kodcu: dolgusuz çerçeveler. Minimal: ince çizgiler. Her biri açık ve koyu görünümle denendi.
- [ ] Tema değişince boş durum ve hata metinleri temanın tonunda (ör. Kodcu: "Bugün: 0 kayıt").
- [ ] Tabletta / yatayda profil kartları dört sütun; büyük yazıda tek sütun.

### D3. Analiz sayfaları
- [ ] Profil: dört kart (bu hafta odak, uyum, seri, en güçlü bölge); her karta dokununca kendi sayfası açılır.
- [ ] Her sayfanın başlığı sorudur; altında tek cümlelik yorum var. Aralık seçici (Hafta / Ay / 3 ay / Yıl / Tümü) seçimi sayfalar arasında korunur.
- [ ] Grafiğe dokununca değer ve ilgili oturumlar listesi açılır; çizgi grafikte dokunma ipucu görünür.
- [ ] "Yıl" seçilince Plana uyum ve Uyku birkaç yüz ms içinde dolar, arayüz donmaz (arka planda hesap); geri dönüp tekrar girince anında açılır.
- [ ] Hiç veri yokken her sayfa boş durumunu ve çalışan düğmesini gösterir.
- [ ] TalkBack: grafiklerin tek cümlelik özeti okunur; "Liste olarak göster" açılınca değerler satır satır okunur.
- [ ] Yazı ölçeği 2.0'da kartlar tek sütuna iner, metin kesilmez.
- [ ] Profil modunda grafik sayfasını kaydırırken 16 ms'yi aşan kare yok (`flutter run --profile`).

### D4. Paylaşım ve dışa aktarma
- [ ] Haftalık rapor → "Görsel olarak paylaş": paylaşım menüsü açılır, görsel net (3×) ve koyu/açık temada okunur.
- [ ] Ayarlar → Verilerimi dışa aktar: uçak modunda da çalışır; JSON dosyası Drive / Dosyalar'a kaydedilebilir ve açılınca tablolar görünür.
- [ ] Ayarlar → Bilimsel kaynaklar: 22 kaynak listelenir; kopyalanan bağlantı doi.org'a gider.
- [ ] Ayarlar → Uyku hedefi değiştirilince Uykum yeterli mi? sayfasındaki hedef çizgisi ve fark cümlesi değişir; uyku penceresini değiştirmek hedefi değiştirmez.

## E. Temalar, dil, bayraklar, çökme raporu (Aşama 6)
Otomatik testler: `flutter test` (tema matrisi 10 tema, `test/l10n/`, `test/ui/stage6_test.dart`, `test/ui/app_flow_test.dart`), golden `flutter test --tags golden` (güncelleme: `--update-goldens`, yalnız Windows'ta), cihazda `flutter test integration_test -d <cihaz> --no-uninstall` (bitince gerçek uygulamayı yeniden kur; PERFORMANCE.md §5).

### E1. Tema seçici ve geçiş
- [ ] Ayarlar → Görünüm ve tema: on temanın her biri önizlemesiyle görünür; önizleme seçili görünümde (açık/koyu) çizilir, Kodcu ve Gece "sistem"de koyu.
- [ ] Bir temaya dokununca uygulama yeniden başlamadan, yumuşakça geçer (Kâğıt'ta anlık). Geri dönünce Bugün ve Beyin yeni temada.
- [ ] Sistem ayarında "animasyonları kaldır" açıkken geçiş anlıktır.
- [ ] TalkBack: her tema kartı "ad, açıklama, seçili / seçili değil" okunur; önizleme kutusu okunmaz.
- [ ] Yazı boyutu en büyükte kartlar taşmaz.
- [ ] İlk kurulumdaki görünüm adımı aynı önizlemeli kartları gösterir.

### E2. Yeni temalar ve fontlar
- [ ] Kâğıt: sıcak kâğıt zemin, ince mürekkep çizgileri, keskin köşe, başlıklar IBM Plex Sans; sayfa geçişleri anlık.
- [ ] Doğa: topraksı renkler, iri köşe, yavaş geçişler; grafik renkleri ayırt edilebilir.
- [ ] Gece koyu: zemin gerçek siyah (OLED'de pikseller kapalı), kartlarda hafif vurgu çerçevesi.
- [ ] D1 font dizisi IBM Plex Sans başlıkta da okunur (Türkçe harfler tam).
- [ ] Ayarlar → Hakkında → Fontlar beş fontu listeler; "Bütün lisansları göster"de IBM Plex Sans OFL metni var.

### E3. Mikro etkileşimler
- [ ] Bugün'de bir işi "Bitti" yapınca hafif titreşim ve satırda bir kez beliren işaret; ekranı yeniden açınca işaret canlanmaz.
- [ ] Odak oturumu tamamlanınca bir kez hafif titreşim; sihirbaz kaydedilince de.
- [ ] Ayarlar'da "Dokunsal geri bildirim" kapalıyken hiçbiri titreşmez.
- [ ] Mesaj balonuna dokununca tepki / kopyala / şikâyet menüsü açılır (uzun basma da çalışır).

### E4. Dil
- [ ] Dil İngilizce'ye alınınca bütün ekranlar, tarih ("November 20, 2026"), saat ve ondalık ("1.5") İngilizce biçimde; Türkçe'de "20 Kasım 2026", "1,5".
- [ ] Ayarlar → Konum: enlem / boylam Türkçe'de virgülle.
- [ ] Kurulumda doğum yılı kaydedildikten sonra adımda "Doğum yılın kaydedildi: …" yazar (boş alan yok).

### E5. Özellik bayrakları (sunucu gerekir)
- [ ] Studio'da `feature_flags`'e `together` = false ekle → uygulamayı arka plana alıp geri getir → Birlikte "Bu bölüm şu an kapalı" der. Satırı silince geri gelir.
- [ ] `voice` = false → ortak odakta ses bölümü görünmez; `messages`, `cofocus`, `leaderboard`, `brainCompare` = false → ilgili satır görünmez.
- [ ] Uçak modunda son bilinen bayraklar geçerli kalır.

### E6. Çökme raporları
- [ ] Ayarlar → Veriler → "Çökme raporları gönder" varsayılan açık; kapatılınca kalıcı (yeniden açılışta da kapalı).
- [ ] Release derlemesinde ilk çökme Firebase Crashlytics panosunda görünür; raporda e-posta, ad ya da plan içeriği yok.
- [ ] `crashReports` bayrağı false iken anahtar Ayarlar'da görünmez.
