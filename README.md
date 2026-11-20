# NöroPlan (NeuroPlan)

**Hayatını kendi şablonunla planla, boş zamanını bul, odaklan — emeğinin 3D neon bir beyinde büyüdüğünü gör.**

NöroPlan; rutinlerini, işlerini ve projelerini esnek bir şablonla tanımladığın, zorunlu işlerden sonra kalan boş zamanı hesaplayıp projelerini bu boşluklara bölen ve odak oturumlarını bilimsel dayanaklı kategorilere göre 3D bir beyin üzerinde görselleştiren bir mobil uygulamadır.

> **Durum: Aşama 4B — Birlikte (sosyal).** Uygulama cihazda çalışıyor: ilk kurulum, Bugün, Plan, aktivite sihirbazı, kategori ağacı, proje bölme, sıradaki iş bildirimi, ana ekran widget'ı, odak oturumları (serbest, Pomodoro, derin çalışma; 10 saniye kuralı), 3D neon beyin, misafir / Google girişi ve eşitleme, davetle arkadaşlık, partner, plan paylaşımı, ortak odak (isteğe bağlı sesli), ortak etkinlik, mesajlaşma, sıralama ve beyin karşılaştırma var. Sosyal özellikler sunucu ister (`.env`) ve gerçek iki cihazla doğrulanmadı ([docs/QA_CHECKLIST.md](docs/QA_CHECKLIST.md) C). Analiz ve temalar **planlanan** kapsamdadır.

[English summary below](#english)

---

## Var olan özellikler
- **Tamamen esnek yaşam şablonu** — Rutinler, tek seferlik işler, son tarihli görevler, projeler, serbest zamanlar. Tekrar türleri: bir kez, her gün, haftanın günleri, her N günde, ayda bir, dönüşümlü vardiya, seçili tarihler, gün vermeden "haftada N kez" ve başka bir işle birlikte. Saat türleri: sabit, aralık, başka işe göre, gün doğumu / namaz vaktine göre ya da saatsiz. Uygulama senin hayatın hakkında hiçbir şey varsaymaz; her şeyi sen oluşturursun.
- **Plan motoru** — Kesin işler önce yerleşir; göreli işler bağlı oldukları işe göre kayar; kaydırılabilir işler en yakın boşluğa taşınır. Sığmayanlar "tampon"a düşer. İki kesin iş çakışırsa motor karar vermez, sana gösterir. Yaz saati, gece yarısını aşan işler ve saat dilimi değişimi doğru çalışır. Aynı girdi her zaman aynı planı üretir (bir hafta ~4 ms).
- **Boş zaman ve proje bölme** — Boş dilimler hesaplanır. Projeler son tarihe göre otomatik önerilir (sen onaylarsın) ya da boş dilimlere elle sürüklenir. Süre yetmiyorsa "bu tempoyla X tarihine N saat eksik" uyarısı ve üç seçenek çıkar.
- **Namaz vakitleri (isteğe bağlı)** — Konumdan internetsiz hesaplanır; Diyanet yöntemi varsayılandır. Vakitler yalnız çapadır: "akşam namazından sonra 30 dk" gibi.
- **Bilimsel kök kategoriler** — 9 sabit kök kategori; altlarına sınırsız derinlikte kendi kategorilerin, sürükle-bırakla taşıma. Her kökte hangi beyin bölgelerine bağlı olduğu ve kanıt düzeyi görünür.
- **Sıradaki iş** — İlk kurulumda bildirim izni açıklamalı bir adımla istenir; seçtiğin kadar önce yerel bildirim ve "Sıradaki: X, 15 dk sonra" ana ekran widget'ı.
- **Odak oturumları** — Serbest, Pomodoro (çalışma / mola / uzun mola ayarlanır) ya da derin çalışma (hedef süre, önceki odak süresine göre önerilen mola). Sayaç zaman damgasına dayanır; uygulama kapanıp açılsa da kaldığı yerden sürer. Kalıcı bildirimde kalan süre, "Duraklat" ve "Bitir" var. İsteğe bağlı Rahatsız Etmeyin.
- **Uygulama sabitleme** — Odak bloğunda uygulama Android'in sabitleme özelliğiyle sabitlenir (onay ister); sabitliyken başka uygulamaya geçilemez. Molada ve acil durumda sabitleme kalkar.
- **Planı bozma kuralı** — Odak sırasında uygulamadan çıkarsan ya da bildirim panelini çekersen 10 saniye geri sayan bir uyarı gelir; dönmezsen oturum bozulur ve bölgelerde o kadar süre söner (silinmez, çalıştıkça yanar). Ekranı kapatmak, gelen arama, mola ve günde 3 acil durum hakkı ceza saymaz.
- **Bitiş adımları** — Odak ve yorgunluk puanı, kısa not ve "bu bölgelerle ilişkilendirilen etkinliklere N dk ayırdın" özeti; Pomodoro'da seri, derin çalışmada en uzun kesintisiz süre.
- **3D neon beyin** — Tamamlanan odak oturumları, işin kök kategorisiyle ilişkilendirilen bölgelerde nöron olarak yanar. Yarı saydam kabuk, lob sınırları, iç yapılar (hipokampüs, amigdala…), nöronlar arası ışık çizgileri ve sinyal darbeleri. Pomodoro'da döngü ve süreklilik, derin çalışmada en uzun kesintisiz süre ödüllendirilir; art arda günler ve aynı gün farklı kategoriler bağlantı kurar. Beslenmeyen bölge yavaşça söner, bozulan oturum bazı nöronları söndürür; hiçbir nöron silinmez. Döndür, yakınlaştır, bölgeye dokun: bölge sayfasında son 30 gün, seni besleyen kategoriler ve kanıt düzeyi. Zaman çizelgesiyle geçmişteki halini oynat. Cihaz gücüne göre kalite kendiliğinden ayarlanır; internet gerekmez. Ekran okuyucu için liste görünümü var. Kurallar: [docs/BRAIN_MODEL.md](docs/BRAIN_MODEL.md).
- **Türkçe ve İngilizce**, açık / koyu görünüm, önce cihazda çalışan (offline-first) yapı.

- **Giriş ve eşitleme** — İlk açılışta misafir oturumu; Google ile bağlanınca (tarayıcı açılmadan, telefonun hesap seçicisiyle) aynı hesap kalıcı olur. Değişiklikler arka planda sunucuya eşitlenir, iki cihaz farklı alanları düzenlese de ikisi korunur. Hesabı ve tüm verileri uygulamadan silebilirsin.
- **Birlikte (sosyal, 15 yaş ve üstü)** — Güvenlik ve gizlilik önce: kurallar veritabanında uygulanır ([docs/SOCIAL_SAFETY.md](docs/SOCIAL_SAFETY.md)).
  - Arkadaş ve partner **yalnız davetle**: kod, QR kodu ya da tam kullanıcı adı. Arama, öneri, rastgele eşleşme yok. Kişi başına bir partner, karşılıklı onayla.
  - Plan görünürlüğü kategori kategori: tam, başlık ve saat, yalnız meşgul ya da gizli; partnere ve arkadaşlara ayrı, kişiye özel istisna. Partnerinin planını bugün ve hafta olarak salt okunur görürsün.
  - Ortak odak: arkadaşlarınla aynı anda başla, herkes kendi işine odaklansın; isteğe bağlı sesli sohbet (mikrofon kapalı başlar, kayıt yok). Birlikte tamamlanan oturum beyinde küçük bir ortak bağlantı kazandırır.
  - Ortak etkinlik ve proje: kabul edince ikinizin planına da düşer; değişiklikler onaya gider, ilerleme paylaşılır. Ortak boş zaman bulma yalnız boş saatleri gösterir.
  - Mesajlaşma: yazılı mesaj ve hazır tepkiler; küfür yıldızlanır, hız sınırı var. Uygulama kapalıyken de push bildirimi gelir (içerik göstermeden); odaktayken bildirim susar.
  - Haftalık sıralama (odak dakikası, süreklilik; yalnız sunucuda doğrulanan oturumlar) ve izin veren arkadaşla iki beyni yan yana karşılaştırma.
  - Her yerde engelle ve şikâyet et; şikâyetler incelenir. 18 yaş altında en sıkı gizlilik varsayılan.
  - Hesabını uygulama kurulu olmasa da web sayfasından silebilirsin ([docs/account-deletion](docs/account-deletion/index.html)).
- **Sunucu kurulumu** — Google, Supabase, LiveKit ve Firebase adımları: [docs/SETUP_BACKEND.md](docs/SETUP_BACKEND.md).

## Planlanan özellikler
- **Kişisel analiz** — Grafiklerle zaman dağılımı, planlanan ve gerçekleşen, hangi odak modunun sana daha iyi geldiği.
- **Temalar** — Ciddi, Eğlenceli, Genç, Kodcu ve daha fazlası.
- **Sosyal ekleri** — Grup sohbeti; ortak odak daveti ve arkadaşlık isteği için push bildirimi.

Hedef kitle 13 yaş ve üstü. Ayrıntılar: [docs/PRODUCT.md](docs/PRODUCT.md).

## Bilime yaklaşım
- 3D beyin bir **metafordur, ölçüm değildir**. Uygulama “beynin büyüdü” demez; “bu bölgeyle ilişkilendirilen etkinliklere şu kadar zaman ayırdın” der.
- Her bilimsel ifade, hakemli bir kaynağa ve açıkça yazılmış bir kanıt düzeyine dayanır: [docs/SCIENCE.md](docs/SCIENCE.md).
- “Sol beyinli / sağ beyinli” kişilik miti kullanılmaz.

## Teknoloji
| Katman | Seçim |
|---|---|
| Uygulama | Flutter 3.50 (Dart 3.14) — önce Android, sonra iOS |
| Alan katmanı | Saf Dart paketi `packages/neuroplan_core` (Flutter'sız): plan motoru, proje bölme, tekrar ve zaman kuralları, odak sayacı ve 10 sn kuralı, beyin kuralları (olay türetme, katlama, sönme, çizim planı) |
| Arka uç | Supabase: Auth (Google + misafir), Postgres, Row Level Security, RPC, Edge Functions |
| Veri | Önce cihazda (Drift / SQLite); outbox kuyruğuyla Supabase'e eşitleme, çakışmada alan bazlı son yazan kazanır |
| Arayüz | Material 3 (`material_ui`), Riverpod, go_router, Material Symbols; TR + EN (ARB) |
| Zaman | `timezone` (IANA), `rrule` (RFC 5545), `adhan_dart` (namaz vakti, çevrimdışı) |
| Bildirim ve widget | `flutter_local_notifications`, `home_widget` + Kotlin widget sağlayıcısı |
| 3D beyin | Uygulamaya gömülü WebView içinde yerel Three.js sahnesi; model BodyParts3D 4.0'dan (CC BY 4.0), meshopt ile sıkıştırılmış GLB |

Mimari: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) · Veri modeli: [docs/DB_SCHEMA.md](docs/DB_SCHEMA.md) · Tarihli kararlar: [docs/DECISIONS.md](docs/DECISIONS.md).

## Yol haritası
- [x] **Aşama 0** — Proje iskeleti, araçlar, ürün / UX / bilim belgeleri, Supabase altyapısı
- [x] **Aşama 1** — Mimari, veri modeli ve senaryo testi, Supabase migration'ları + RLS + sistem seed'i, Drift yerel veritabanı, eşitleme kuyruğu iskeleti, depolar ve testler
- [x] **Aşama 2** — Plan motoru ve proje bölme (saf Dart; senaryo, sınır durumu ve performans testli), uygulama kabuğu, ilk kurulum, Bugün, Plan, aktivite sihirbazı, kategori ağacı, proje ve profil ekranları, bildirim ve ana ekran widget'ı
- [x] **Aşama 3** — Odak sayacı: üç mod, zaman damgalı ve kurtarılabilir sayaç, ön plan servisi + kalıcı bildirim, Rahatsız Etmeyin, 10 sn kuralı ve istisnaları (ekran kapanması, arama, mola, acil durum), odak / bozulma / bitiş ekranları, beyin kazanç ve ceza olayları, gerçek cihaz test listesi
- [x] **Aşama 4** — 3D beyin: lisanslı anatomik model ve model hattı, anatomik bölgeler + göç, büyüme kuralları v2 (saf Dart, test vektörlü), WebView'da yerel Three.js sahnesi (fresnel kabuk, nöronlar, bağlar, bloom), tipli köprü, kalite kademeleri, bölge sayfası, zaman çizelgesi, metin alternatifi, Hakkında ekranı
- [x] **Aşama 4B** — Birlikte: KVKK/GDPR/Play araştırması (SOCIAL_SAFETY), misafir + Google girişi ve eşitleme, yaş adımı, davet/QR/kullanıcı adıyla arkadaşlık, tek partner kısıtı, veritabanında plan görünürlüğü, ortak odak (Realtime) + LiveKit ses, ortak etkinlik/proje, ortak boş zaman, mesajlaşma, sıralama, sunucuda beyin hesabı (Dart → JS), beyin karşılaştırma, şikâyet/engel/moderasyon, hesap silme, pgTAP RLS testleri
- [ ] Tema, font ve ikon kararları (font testi; tema aşamasında)
- [ ] Tanıtım sitesi (`mirhatuguzlu.github.io/NeuroPlan/`); hesap silme sayfası alt bilgideki bağlantıyla bu sitenin içinde (D51, son aşama)
- [ ] Sonraki aşamalar [PRODUCT.md](docs/PRODUCT.md)'deki modüllere göre planlanacak

## Geliştirme ortamı
**Gerekenler:** Flutter 3.50+, Android SDK, Java 21, [Supabase CLI](https://supabase.com/docs/guides/cli).

```bash
git clone https://github.com/mirhatuguzlu/NeuroPlan.git
cd NeuroPlan
cp .env.example .env    # kendi Supabase URL'ni ve anon / publishable key'ini yaz
flutter pub get
flutter run   # .env otomatik okunur (D52)
```

Kontroller:
```bash
flutter analyze
flutter test                                   # uygulama + veri katmanı
cd packages/neuroplan_core && dart test        # alan katmanı
dart run tool/gen_seed_sql.dart --check        # seed migration'ı system.json ile aynı mı
cd tool/brain && npm ci && npm test            # 3D sahne yardımcıları (Node)
supabase start && supabase test db             # şema + RLS testleri (Docker gerekir)
```

- Veritabanı değişiklikleri yalnız migration'larla yapılır: `supabase migration new <ad>` → `supabase/migrations/`.
- Drift tabloları değişince kodu yeniden üret: `dart run build_runner build` (üretilen `*.g.dart` repoya girer).
- Sistem verisi (kök kategoriler, beyin bölgeleri, ağırlıklar) yalnız `assets/seed/system.json`'da düzenlenir; migration `dart run tool/gen_seed_sql.dart` ile üretilir.
- 3D sahne `tool/brain/src`'de yazılır; `npm run bundle` ile `assets/brain/brain.js` üretilir (repoya girer). Model yeniden üretimi: [docs/BRAIN_MODEL.md](docs/BRAIN_MODEL.md) §1.
- **Windows:** Proje yolunda Türkçe karakter veya boşluk olmasın (ör. `C:\dev\NeuroPlan`); Android Gradle eklentisi ASCII olmayan yolları reddeder.

## Proje yapısı
```
lib/data/                 Yerel veritabanı (Drift), eşitleme kuyruğu, depolar
lib/app/                  Uygulama kabuğu: tema, gezinme, sağlayıcılar, bildirim ve widget eşitleme
lib/ui/                   Ekranlar ve ortak arayüz parçaları
lib/l10n/                 TR + EN metinler (ARB)
packages/neuroplan_core/  Saf Dart alan katmanı: plan motoru, proje bölme, tekrar/zaman kuralları, odak sayacı, 10 sn kuralı, beyin olayları, HLC, sistem verisi
assets/seed/system.json   Sistem verisinin tek kaynağı (SCIENCE.md'den)
assets/brain/             3D sahne (index.html + tek dosyalık brain.js)
tool/                     Yardımcı betikler (seed migration üretici); tool/brain: 3D model hattı ve sahne kaynağı
test/                     Uygulama ve veri katmanı testleri
android/, ios/            Platform projeleri
supabase/                 migrations (şema, RLS, seed) ve tests (pgTAP)
docs/                     Ürün, UX, bilim, mimari, veri modeli ve karar belgeleri
CLAUDE.md            Projenin değişmez kuralları (AI destekli geliştirme için de geçerli)
```

## Çalışma kuralları (özet)
- Her ekran tek bir amaç taşır; çok adımlı işler sihirbazla yapılır.
- Boş ya da işlevsiz buton yok; her eylemin yükleniyor / hata / boş durumu var.
- Kullanıcıya özel hiçbir içerik koda sabit yazılmaz.
- Her özellik testlidir; `flutter analyze` temiz olmadan commit yapılmaz.
- Tam liste: [CLAUDE.md](CLAUDE.md) · UX kuralları: [docs/UX_RULES.md](docs/UX_RULES.md)

## Güvenlik
- `.env` ve tüm gizli değerler git dışında tutulur; repoda yalnız `.env.example` bulunur.
- İstemcide yalnız Supabase anon / publishable key kullanılır; veri erişimi Row Level Security ile korunur. `service_role` / secret key istemciye ve repoya hiç girmez.
- Bir güvenlik açığı bulursan lütfen herkese açık issue açma; depo sahibine özel olarak ulaş.

## Lisans
[GNU Affero General Public License v3.0](LICENSE) (AGPL-3.0). Bu kodu değiştirip bir ağ hizmeti olarak sunan, değiştirdiği kaynak kodunu da aynı lisansla açmak zorundadır.

3D beyin modeli: BodyParts3D, © The Database Center for Life Science licensed under CC Attribution 4.0 International. Three.js: MIT.

---

<a id="english"></a>
## English summary
**NeuroPlan** is a mobile planning and focus app (Flutter, Android first). You describe your life with a fully flexible template — routines, one-off tasks, deadlines, projects, free time, unplanned days. The app computes the free time left after your fixed commitments and splits your projects into those gaps. Focus sessions (free, Pomodoro or deep work) grow neurons in a 3D neon brain, mapped to nine science-based root categories. The brain is a visualization, not a measurement; every scientific claim is sourced in [docs/SCIENCE.md](docs/SCIENCE.md).

**Status:** Stage 4B — Together (social). The app runs on the device with onboarding, Today, Plan, the add-item wizard, the category tree, project splitting (automatic suggestions or manual drag), an up-next notification, a home-screen widget and focus sessions (free, Pomodoro, deep work). The timer is timestamp-based and survives the app being killed; leaving the app or pulling down the notification shade the app is pinned during focus (Android asks to confirm), and starts a 10-second countdown notification, after which the session breaks (screen off, incoming calls, breaks and a daily emergency pause are exempt). On-device checks live in [docs/QA_CHECKLIST.md](docs/QA_CHECKLIST.md). The deterministic plan engine (pure Dart) places fixed, astronomical/prayer-anchored, relative, windowed and untimed items, reports conflicts and overflow, and is covered by scenario, edge-case and performance tests (a week plans in ~4 ms). A local Three.js scene in a WebView shows the 3D neon brain (anatomical model from BodyParts3D 4.0, CC BY 4.0): completed sessions light neurons in the regions linked to the activity's category, connections form across consecutive days and categories, unfed regions slowly dim and broken sessions dim some neurons — nothing is ever deleted. Tap a region for its last 30 days and evidence level; scrub a timeline to replay the past. Stage 4B adds guest/Google sign-in with sync and the Together tab (ages 15+): invite-only friends and one mutual partner, per-category plan visibility enforced in the database, live co-focus sessions with optional voice (LiveKit, never recorded), shared activities and projects, common free time, chat with reactions, a weekly leaderboard from server-verified sessions, side-by-side brain comparison computed on the server, and block/report everywhere. Social features need a server and are not yet verified on two real devices. Analytics and themes are planned. Stack: Flutter, a pure-Dart domain package, Supabase (Google + guest auth, Postgres, RLS), offline-first Drift/SQLite with field-level last-writer-wins sync, embedded Three.js in a WebView. Languages: Turkish and English. License: AGPL-3.0.
