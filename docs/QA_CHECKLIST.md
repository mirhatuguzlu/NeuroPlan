# QA_CHECKLIST.md — Gerçek cihaz manuel test listesi

Emülatör davranışına güvenilmez (lifecycle, pencere odağı, ekran kilidi, arama ve ön plan servisi cihaza ve üreticiye göre değişir). Her madde **gerçek Android cihazda** denenir. Sonuç, cihaz modeli ve Android sürümüyle birlikte not edilir.

Hazırlık: `flutter run --dart-define-from-file=.env` (ya da `flutter build apk --debug` ve kurulum). Bugün'de "odak gerektirir" etiketli bir iş olsun. Bildirim izni verilsin.

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
