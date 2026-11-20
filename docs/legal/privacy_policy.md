# NöroPlan Gizlilik Politikası / Privacy Policy

> **Taslak (2026-11-20, Aşama 6 güncellemesi).** Yayından önce hukuk incelemesi gerekir (docs/SOCIAL_SAFETY.md §7, docs/SETUP_BACKEND.md §10, docs/RELEASE.md). Köşeli parantezli alanlar doldurulacak. Bu metin KVKK aydınlatma metni yerine geçmez; avukat onayıyla birleştirilebilir. Hukuki görüş değildir.

## Türkçe

**Veri sorumlusu:** [ad soyad / unvan, adres, iletişim e-postası]

**Hangi verileri işliyoruz?**
| Veri | Ne için | Nerede | Ne kadar süre |
|---|---|---|---|
| Planın, kategorilerin, odak oturumların, beyin verin | Uygulamanın çalışması, cihazlar arası eşitleme | Cihazında; giriş yaptıysan sunucuda yedek | Hesabını silene kadar; silinen satırlar sunucuda 90 gün sonra kalıcı temizlenir |
| Doğum yılı (tam tarih değil) | 13 yaş sınırı ve 18 yaş altı korumaları | Cihaz + sunucu | Hesapla birlikte |
| Yaklaşık konum (0,1°'ye yuvarlanmış, ≈ 11 km), isteğe bağlı | Gün doğumu ve namaz vakti hesabı | Cihaz + sunucu | Sen kaldırana ya da hesabı silene kadar |
| Google hesabı e-postası ve kimliği | Giriş | Sunucu (Supabase Auth) | Hesapla birlikte |
| Takma ad, isteğe bağlı kullanıcı adı | Birlikte bölümü | Sunucu | Hesapla birlikte |
| Arkadaşlıklar, mesajlar, tepkiler, ortak etkinlikler, şikâyetler | Birlikte bölümü, güvenlik ve moderasyon | Sunucu | Hesapla birlikte; şikâyet kayıtları en çok 1 yıl |
| Sesli sohbet sesi | Ortak odakta canlı konuşma | **Kaydedilmez**; yalnız aktarılır (LiveKit) | — |
| Bildirim cihaz kimliği | Mesaj bildirimi | Sunucu | Çıkış ya da hesap silmeyle |
| Çökme raporu (hata ayrıntısı, yığın izi, cihaz modeli ve Android sürümü, uygulama sürümü, Firebase kurulum kimliği) | Uygulamadaki hataları bulup düzeltmek | Google Firebase Crashlytics | Firebase'in saklama süresi (90 gün) |

Çökme raporuna adın, e-postan, hesap kimliğin, planların ya da notların **eklenmez**. Ayarlar → Veriler → "Çökme raporları gönder" ile kapatabilirsin.

Reklam yok, veri satışı yok, kullanım analitiği yok.

**Hukuki sebep:** sözleşmenin kurulması ve ifası (KVKK m. 5/2-c; GDPR m. 6/1-b); güvenlik, moderasyon ve çökme raporları için meşru menfaat (KVKK m. 5/2-f; GDPR m. 6/1-f) — çökme raporlarına istediğin an itiraz edip kapatabilirsin.

**Kimlerle paylaşılır (veri işleyenler, yurt dışı):** Supabase (veritabanı ve giriş, [bölge]), LiveKit (ses aktarımı), Google Firebase (bildirim ve çökme raporları). Yurt dışına aktarım KVKK m. 9 standart sözleşmeleriyle yapılır.

**Arkadaşların neyi görür:** yalnız senin seçtiğin kadar; varsayılan olarak partnerin plan başlığını ve saatini, diğer arkadaşların yalnız "meşgul" olduğunu görür. Kimse seni arayarak bulamaz.

**Saklama ve silme:** Hesabını uygulamadan (Profil → Ayarlar → Hesap) ya da [silme sayfası adresi] üzerinden silebilirsin; veriler hemen ve kalıcı olarak silinir. Hakkında yapılmış şikâyetler kimliğin olmadan moderasyon kaydı olarak en çok 1 yıl kalır. Verilerini Ayarlar → Veriler → "Verilerimi dışa aktar" ile JSON olarak alabilirsin.

**Çocuklar:** Uygulama 13 yaş ve üstü içindir; kurulumda doğum yılı sorulur ve 13 yaş altı devam edemez. Sosyal özellikler 15 yaşında açılır; 18 yaş altında en sıkı gizlilik ayarları kullanılır.

**Hakların (KVKK m. 11, GDPR m. 15–22):** verilerinin işlenip işlenmediğini öğrenme, bilgi isteme, düzeltme, silme, işlemenin kısıtlanması, itiraz, verilerin taşınması, otomatik karar almaya itiraz ve zararın giderilmesini isteme. Başvuru: [iletişim e-postası]; en geç 30 gün içinde yanıtlanır. KVKK Kurulu'na (kvkk.gov.tr) ya da AB'de bulunduğun ülkenin veri koruma otoritesine şikâyet hakkın vardır.

**Değişiklikler:** Bu metin değişirse uygulamada ve [gizlilik sayfası adresi] üzerinde duyurulur; tarih en üstte yazar.

## English

**Controller:** [name, address, contact email]

**What we process.** Your plan, categories, focus sessions and brain data (on your device, and backed up to our server when you sign in; kept until you delete your account, deleted rows are purged after 90 days); your birth year (not the full date) for age protections; an optional approximate location rounded to ~11 km for sunrise and prayer times; your Google email and ID for sign-in; your nickname and optional username, friendships, messages, reactions, shared plans and reports for the Together section and its safety (reports are kept for up to one year); voice in co-focus sessions is relayed live and **never recorded**; a device token for message notifications; and crash reports (error details, stack trace, device model and Android version, app version, Firebase installation ID) sent to Google Firebase Crashlytics and kept for 90 days. Crash reports never include your name, email, account ID, plans or notes, and you can switch them off in Settings → Data → "Send crash reports". No ads, no data sales, no usage analytics.

**Legal basis.** Performance of a contract (GDPR Art. 6(1)(b)); legitimate interest for safety, moderation and crash reports (Art. 6(1)(f)) — you can object to crash reports at any time by switching them off.

**Processors and transfers.** Supabase ([region]), LiveKit (voice relay), Google Firebase (notifications and crash reports); international transfers use standard contractual clauses.

Friends see only what you choose; by default your partner sees titles and times, other friends see only "busy". Nobody can find you by searching.

**Deletion and export.** Delete your account in the app (Profile → Settings → Account) or at [deletion page URL]; data is deleted immediately and permanently. Reports about you stay without your identity for up to one year. Export your data as JSON in Settings → Data.

**Children.** The app is for ages 13+; the setup asks for your birth year and under-13s cannot continue. Social features open at 15, with the strictest privacy under 18.

**Your rights.** Access, rectification, erasure, restriction, objection, portability and not being subject to automated decisions. Contact [email]; we reply within 30 days. You may complain to your data protection authority (in Turkey, the KVKK Board).

**Changes.** We announce changes in the app and at [privacy page URL]; the date is shown at the top.
