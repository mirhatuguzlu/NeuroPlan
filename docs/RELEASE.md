# RELEASE.md — Google Play yayın hazırlığı

Durum: Aşama 6 taslağı, 2026-11-20 (D61). Hukuki görüş değildir; Play Console beyanları ve hukuk metinleri yayından hemen önce avukatla gözden geçirilir (D53). Sunucu adımları: [SETUP_BACKEND.md](SETUP_BACKEND.md) §10.

## 1. Hedef kitle ve içerik
- **Hedef yaş grupları (Play Console → App content → Target audience and content):** 13–15, 16–17, 18 ve üstü işaretli; **12 ve altı işaretsiz**. Uygulama Aileler programına girmez ve çocuklara yönelik değildir.
- **"Uygulama çocukların ilgisini çekebilir mi?"** Hayır: mağaza görselleri ve metinleri çocuk temalı değil (§6).
- **Uygulamada yaş kapısı:** ilk kurulumda doğum yılı (yalnız yıl) zorunludur; 13 yaş altı devam edemez (AUTH-2). Yaş sonradan küçültülemez (sunucu tetikleyicisi). Birlikte bölümü 15 yaş ve üstü (D43).
- **İçerik derecelendirmesi (IARC):** kategori Utility / Productivity. "Kullanıcılar etkileşir / içerik paylaşır" → Evet (mesaj, ses). "Konum paylaşılır" → Hayır (konum yalnız namaz vakti hesabı için cihazda ve hesapta; başkasına gösterilmez). Şiddet, cinsellik, kumar, satın alma yok.
- **Kategori:** Productivity. **Reklam içerir:** Hayır. **Uygulama içi satın alma:** Hayır (abonelik yayından önce ayrı karar, D58).

## 2. Data Safety formu
Bütün veriler aktarımda şifrelidir (HTTPS/TLS). Kullanıcı silme isteyebilir: uygulama içi (Profil → Ayarlar → Hesap) ve web sayfası (SETUP_BACKEND §8.3). Veri satılmaz; reklam ya da pazarlama için kullanılmaz.

| Play veri türü | Uygulamadaki karşılığı | Toplanıyor | Paylaşılıyor* | Zorunlu / isteğe bağlı | Amaç |
|---|---|---|---|---|---|
| Kişisel bilgi → Ad | Takma ad (Birlikte) | Evet | Hayır | İsteğe bağlı (Birlikte'yi açarsa) | Uygulama işlevi |
| Kişisel bilgi → E-posta adresi | Google girişi | Evet | Hayır | İsteğe bağlı (misafir kullanılabilir) | Hesap yönetimi |
| Kişisel bilgi → Kullanıcı kimlikleri | Hesap kimliği, isteğe bağlı kullanıcı adı | Evet | Hayır | Zorunlu (misafir de anonim kimlik alır) | Uygulama işlevi, hesap yönetimi |
| Kişisel bilgi → Diğer | Doğum yılı | Evet | Hayır | Zorunlu | Uygulama işlevi (yaş korumaları) |
| Konum → Yaklaşık konum | 0,1°'ye yuvarlanmış konum | Evet | Hayır | İsteğe bağlı | Uygulama işlevi (gün doğumu, namaz vakti) |
| Mesajlar → Diğer uygulama içi mesajlar | Birebir mesajlar, tepkiler | Evet | Hayır | İsteğe bağlı | Uygulama işlevi |
| Ses → Ses kayıtları | Sesli sohbet | **Hayır** (aktarılır, saklanmaz; "geçici işleme") | Hayır | İsteğe bağlı | Uygulama işlevi |
| Uygulama etkinliği → Diğer kullanıcı içeriği | Planlar, kategoriler, notlar, ortak etkinlikler | Evet | Hayır | Zorunlu (giriş yapınca eşitlenir) | Uygulama işlevi |
| Uygulama etkinliği → Uygulama etkileşimleri | Odak oturumları, sıralama verisi | Evet | Hayır | Zorunlu | Uygulama işlevi |
| Sosyal → Diğer | Arkadaş listesi, partner | Evet | Hayır | İsteğe bağlı | Uygulama işlevi |
| Uygulama bilgileri ve performansı → Kilitlenme günlükleri | Firebase Crashlytics | Evet | Hayır | İsteğe bağlı (Ayarlar'dan kapatılır) | Analiz (hata ayıklama) |
| Uygulama bilgileri ve performansı → Diğer tanılama verileri | Cihaz modeli, Android ve uygulama sürümü (çökme raporuyla) | Evet | Hayır | İsteğe bağlı | Analiz (hata ayıklama) |
| Cihaz ya da diğer kimlikler | FCM bildirim kimliği, Firebase kurulum kimliği | Evet | Hayır | İsteğe bağlı (bildirim / çökme raporu) | Uygulama işlevi, analiz |

\* Play tanımında veri işleyene (Supabase, LiveKit, Google Firebase) aktarım "paylaşma" sayılmaz.

Toplanmayanlar: kesin konum, kişiler, fotoğraf / video, dosyalar, takvim, sağlık, finans, web geçmişi, yüklü uygulamalar. Kamera yalnız davet QR kodunu okumak için anlık açılır; görüntü saklanmaz ve gönderilmez.

## 3. İmzalama
**Play App Signing** kullanılır: Google uygulamanın imza anahtarını saklar, sen yalnız **yükleme anahtarını** tutarsın. Yükleme anahtarı kaybolursa Play Console'dan sıfırlanabilir.

1. Yükleme anahtarını üret (parolayı sen seçersin; kimseyle paylaşma, bir parola yöneticisinde sakla):
   ```powershell
   keytool -genkey -v -keystore C:\dev\NeuroPlan\upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. `android/key.properties.example`'ı `android/key.properties` olarak kopyala, parolaları yaz. İkisi de git-ignored (`*.jks`, `android/key.properties`).
3. `.jks` dosyasını ve parolasını repo dışında yedekle (ör. parola yöneticisi + şifreli bulut).
4. Derle: `flutter build appbundle --release` → `build/app/outputs/bundle/release/app-release.aab`. `key.properties` yoksa paket hata ayıklama anahtarıyla imzalanır ve **Play reddeder**; bu, CI'ın sırsız derleyebilmesi içindir (`android/app/build.gradle.kts`).
5. Play Console → Setup → App signing: ilk yüklemede Play App Signing'i kabul et. Google'ın verdiği **uygulama imza SHA-1**'ini Google Cloud'daki Android OAuth istemcisine ekle (SETUP_BACKEND §1.4), yoksa Play'den kurulan uygulamada Google girişi çalışmaz.

## 4. Sürüm numaralandırma
- `pubspec.yaml` → `version: X.Y.Z+N`. `X.Y.Z` = `versionName` (anlamsal sürüm), `N` = `versionCode` (Play'e her yüklemede **artmalı**, geri dönmez).
- Anlamsal sürüm: hata düzeltme → Z, yeni özellik → Y, uyumsuz veri / büyük değişiklik → X.
- Git etiketi: `vX.Y.Z`; yayın adayları `vX.Y.Z-rc.N` (pubspec'te ön ek yok, `+N` yine artar).
- Bu aşama: `1.0.0+1`, etiket `v1.0.0-rc.1`. Play'e ilk yükleme dahili test kanalına.
- Veritabanı: Drift `schemaVersion` ve Supabase migration'ları uygulama sürümünden bağımsız ilerler; her yayın notunda migration varsa yazılır.

## 5. Kanallar ve kontrol listesi
1. Dahili test (en çok 100 kişi) → kapalı test (Play: yeni kişisel hesaplarda üretime çıkmadan önce **en az 12 test kullanıcısıyla 14 gün kapalı test** şartı) → üretim.
2. Her yüklemeden önce: `flutter analyze`, `flutter test`, çekirdek `dart test`, `flutter test integration_test -d <cihaz> --no-uninstall`, QA_CHECKLIST'in ilgili bölümleri, `versionCode` arttı mı.
3. Uzak Supabase'e migration'lar uygulandı mı (`supabase db push --remote`), Edge Functions yayımlandı mı.
4. Gizlilik politikası, kullanım şartları, topluluk kuralları ve çocuk güvenliği sayfaları yayında (tanıtım sitesi, D51).
5. Firebase konsolunda Crashlytics açık; ilk sürümden sonra panoda kayıt görünüyor.

## 6. Mağaza görselleri listesi
Görseller gerçek uygulamadan, örnek ama gerçekçi yetişkin / öğrenci verisiyle alınır (ör. "Tez", "Gitar", "Koşu"). **Çocuk karakter, oyuncak, çizgi film figürü, ana sınıfı renk paleti ya da "çocuk" kelimesi kullanılmaz.** Eğlenceli tema gösterilecekse yanında Ciddi ya da Kodcu da olur.

| Varlık | Boyut | İçerik |
|---|---|---|
| Uygulama simgesi | 512×512 PNG, 32 bit | Neon beyin işareti, düz zemin |
| Öne çıkan görsel | 1024×500 PNG/JPG | 3D beyin + "Planla. Odaklan. Gör." metni (TR ve EN ayrı) |
| Telefon ekran görüntüleri | En az 2, en çok 8; 1080×1920 (9:16) | 1) Bugün (sıradaki iş, boş zaman) 2) Proje bölme önerileri 3) Odak sayacı 4) 3D beyin 5) Bölge sayfası ve kanıt düzeyi 6) Analiz: zamanım nereye gidiyor 7) Tema seçici (Ciddi, Kodcu, Gece) 8) Birlikte: ortak odak |
| 7" ve 10" tablet görüntüleri | 1200×1920 / 1600×2560 | Bugün ve analiz (tablet düzeni gelene dek isteğe bağlı) |
| Tanıtım videosu (isteğe bağlı) | YouTube, 30–60 sn | Kurulum → iş ekle → odak → beyin |
| Ön plan servisi videosu | Ekran kaydı | Odak sayacının kalıcı bildirimi ve 10 sn uyarısı (Play beyanı için, SETUP_BACKEND §10.2) |

Her görüntü TR ve EN ayrı alınır (Play'de iki dil listesi). Golden testler (`test/golden/goldens/`) düzen kontrolü için kullanılabilir ama mağaza görüntüsü cihazdan alınır.

## 7. Mağaza metinleri (taslak)
Bilimsel iddia yalnız SCIENCE.md'den; "beynini büyüt", "IQ", "zekâ" gibi ifadeler yok.

### Türkçe
**Uygulama adı (≤ 30):** NöroPlan: Plan ve Odak

**Kısa açıklama (≤ 80):** Boş zamanını bul, projelerini böl, odaklan; emeğini 3D neon bir beyinde gör.

**Uzun açıklama (≤ 4000):**
NöroPlan, hayatını kendi şablonunla planladığın bir planlama ve odak uygulamasıdır. Uygulama senin hayatın hakkında hiçbir şey varsaymaz: rutinlerini, işlerini, projelerini ve kategorilerini sen oluşturursun.

PLANLA
• Rutinler, tek seferlik işler, son tarihli görevler, projeler, serbest zaman ve plansız günler.
• Her gün, haftanın günleri, her N günde, dönüşümlü vardiya, "haftada 3 kez" gibi esnek tekrarlar.
• Zorunlu işler yerleştikten sonra kalan boş zaman hesaplanır; projelerin son tarihe göre boşluklara bölünür, sen onaylarsın.
• Süre yetmeyecekse önceden uyarılırsın.

ODAKLAN
• Serbest, Pomodoro ya da derin çalışma.
• Odak sırasında uygulamadan çıkarsan 10 saniyelik bir hatırlatma gelir; ekranı kapatmak, gelen arama ve molalar ceza saymaz.
• Bitince odak ve yorgunluk puanı, kısa not.

GÖR
• Tamamlanan odak oturumların, işin kategorisiyle ilişkilendirilen bölgelerde 3D neon bir beyinde ışık olarak görünür.
• Beyin bir metafordur, ölçüm değildir. Her bilimsel açıklama hakemli bir kaynağa ve açıkça yazılmış bir kanıt düzeyine dayanır.
• Ekran okuyucu için liste görünümü vardır.

ANLA
• Zamanın nereye gidiyor, plana ne kadar uyuyorsun, ne zaman en iyi odaklanıyorsun, Pomodoro mu derin çalışma mı sana daha iyi geliyor: hepsi kendi verinle, cihazında hesaplanır.

BİRLİKTE (15 yaş ve üstü, isteğe bağlı)
• Yalnız davetle arkadaş ve partner; arama ve rastgele eşleşme yok.
• Ortak odak oturumu, isteğe bağlı sesli sohbet (kayıt yok), ortak etkinlikler ve mesajlar.
• Her ekranda engelle ve şikâyet et.

SENİN TARZIN
• On tema: Ciddi, Eğlenceli, Genç, Kodcu, Sakin, Yüksek Kontrast, Minimal, Kâğıt, Doğa ve Gece; her biri açık ve koyu görünümle.
• Türkçe ve İngilizce.

GİZLİLİK
• İnternetsiz çalışır; giriş yaparsan cihazların arasında eşitlenir.
• Reklam yok, veri satışı yok, kullanım analitiği yok. Hesabını ve bütün verilerini uygulamadan silebilir, verilerini dışa aktarabilirsin.
• Açık kaynak (AGPL-3.0).

NöroPlan 13 yaş ve üstü içindir.

### English
**App name (≤ 30):** NeuroPlan: Plan and Focus

**Short description (≤ 80):** Find your free time, split your projects, focus, and see it glow in a 3D brain.

**Full description (≤ 4000):**
NeuroPlan is a planning and focus app built around your own template. It assumes nothing about your life: you create your routines, tasks, projects and categories.

PLAN
• Routines, one-off tasks, deadlines, projects, free time and unplanned days.
• Flexible repeats: daily, weekdays, every N days, rotating shifts, "3 times a week".
• Free time is computed after your fixed commitments, and projects are split into the gaps before their deadlines — you approve every suggestion.
• You are warned early when time will run short.

FOCUS
• Free, Pomodoro or deep work.
• Leave the app during focus and a 10-second reminder brings you back; screen off, incoming calls and breaks never count against you.
• Rate your focus and fatigue, add a short note.

SEE
• Completed sessions light up in a 3D neon brain, in the regions linked to the activity's category.
• The brain is a metaphor, not a measurement. Every scientific note is backed by a peer-reviewed source and a stated level of evidence.
• A list view is available for screen readers.

UNDERSTAND
• Where your time goes, how well you follow your plan, when you focus best, whether Pomodoro or deep work suits you — all from your own data, computed on your device.

TOGETHER (ages 15+, optional)
• Friends and a partner by invitation only; no search, no random matching.
• Co-focus sessions with optional voice chat (never recorded), shared activities and messages.
• Block and report from every screen.

YOUR STYLE
• Ten themes — Serious, Playful, Young, Coder, Calm, High contrast, Minimal, Paper, Nature and Night — each in light and dark.
• English and Turkish.

PRIVACY
• Works offline; syncs between your devices when you sign in.
• No ads, no data sales, no usage analytics. Delete your account and all data in the app, or export your data.
• Open source (AGPL-3.0).

NeuroPlan is for ages 13 and up.
