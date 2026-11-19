# SOCIAL_SAFETY.md — Sosyal özelliklerde güvenlik, gizlilik ve uyum

Durum: **Onaylandı, 2026-11-19 (Aşama 4B).** Soru formu: önce giriş + eşitleme, sosyal 15+ ve 15–17 sıkı mod, LiveKit Cloud, sıralamada odak dakikası + süreklilik, Birlikte 5. sekme, 14 günlük takvim yayını, küfür maskelenir. Kararlar DECISIONS D42–D48; uygulanan hâli aşağıda.
İlgili: [PRODUCT.md](PRODUCT.md) §5.10 ve §8 · [DB_SCHEMA.md](DB_SCHEMA.md) §5–6 · [ARCHITECTURE.md](ARCHITECTURE.md) §9.

> **Bu belge hukuki görüş değildir.** Kaynaklar 2026-11-19'da okundu; çoğu ikincil kaynaktır (hukuk bürosu yazıları, haberler). Yayından önce KVKK / GDPR ve 5651 konusunda bir avukat görüşü gerekir (§7).

## 0. Özet: kod yazmadan önce bilinmesi gereken üç engel
1. **Giriş ve sunucu eşitlemesi henüz yok.** `supabase_flutter` pakette yok; `SyncRemote` yazılmadı (D16). Sosyal özelliklerin hepsi giriş ister (D17). Sıralama ve hile koruması `focus_sessions`'ın sunucuda olmasını, partner planı `activities`'in sunucuda olmasını ister. **4B'nin ilk adımı giriş (Google + misafir) ve eşitlemenin sunucu tarafı olmak zorunda.**
2. **Partnerin planı sunucuda yok.** D22 gereği plan motorunun çıktısı bellekte kalır; `plan_instances` yalnız kullanıcı bir oluşuma dokununca yazılır. Bu yüzden şemadaki `friend_calendar` fonksiyonu bugün neredeyse boş döner. Öneri §4.2: cihaz önümüzdeki 14 günün hesaplanmış bloklarını (yalnız zaman + aktivite kimliği) sunucuya yayınlar; görünürlük yine veritabanında uygulanır.
3. **Türkiye'de 15 yaş sınırı yürürlükte.** 7578 sayılı Kanun'la 5651 sayılı Kanun ek madde 4'e eklenen hükme göre sosyal ağ sağlayıcı 15 yaşını doldurmamış çocuklara hizmet sunamaz; 15–18 yaşa "ayrıştırılmış hizmet" ve ebeveyn araçları ister. Yönetmelik 1 Kasım 2026'da yürürlüğe girdi. Veli onayıyla istisna yok. NöroPlan'ın davetle sınırlı arkadaş özelliklerinin "sosyal ağ sağlayıcı" tanımına girip girmediği belirsiz; ihtiyatlı yol §2.3'te.

Ayrıca: ilk kurulumda **yaş adımı yok**. `profiles.birth_year` sütunu var ama arayüz sormuyor (AUTH-2 eksik). 4B'de eklenmeli.

## 1. KVKK (Türkiye)
| Konu | Bulgu | Uygulamaya etkisi |
|---|---|---|
| Rıza yaşı | Kanunda ve Kurul düzenlemesinde çocuğun kendi rızası için yaş sınırı yok. Uygulamada 18 yaş altı için velinin açık rızası alınması öneriliyor; Kurul 2022/776 sayılı kararında velinin rızası alınmadan çocuk verisi işlenmesini ihlal saydı. 2020/622 sayılı karar ayırt etme gücü olan küçüğün haklarını kendi kullanabileceğini tartışıyor. | Sosyal işlemenin hukuki sebebi **açık rıza değil, sözleşmenin ifası** (KVKK m. 5/2-c) olarak kurgulanmalı: kullanıcı özelliği kendisi açar, kapatınca veri işlenmez. Rızaya dayanan ek işlem (ör. genel sıralama, pazarlama) 18 yaş altında yapılmaz. Hukuk kontrolünde doğrulanacak. |
| Yurt dışına aktarım | Supabase ve ses sağlayıcısı yurt dışındaysa veri yurt dışına aktarılır. 2024 değişikliğiyle m. 9: yeterlilik kararı yoksa standart sözleşme imzalanır ve **imzadan itibaren 5 iş günü içinde** Kurum'a bildirilir (KEP ya da Standart Sözleşme Bildirim Modülü). Bildirim yapılmazsa idari para cezası. | Supabase (bölgesi), ses sağlayıcısı ve e-posta / bildirim hizmetleri için standart sözleşme + bildirim. Aydınlatma metninde alıcı ve ülkeler yazılır. |
| Aydınlatma | Veri toplanırken aydınlatma zorunlu. | Sosyal özellik ilk açılışta kısa aydınlatma + kullanım şartları kabulü (§3). 18 yaş altında metin sade dille. |
| Veri en azlığı | Genel ilke. | Ses kaydı yok, mesajda yalnız metin, konum paylaşılmaz, plan görünürlüğü varsayılanı "başlık ve saat" ama yalnız arkadaşa. |

## 2. GDPR, DSA ve AB çocuk koruma (AB kullanıcıları)
### 2.1 GDPR Madde 8
- Yalnız **rızaya dayanan** işleme için geçerlidir. Varsayılan dijital rıza yaşı 16; ülkeler 13'e kadar indirebilir. Örnekler: Almanya, Hollanda, İrlanda 16 · Fransa 15 · İtalya, Avusturya, İspanya 14 · İsveç, Belçika, Danimarka 13 (ikincil kaynak; yayın öncesi doğrulanacak).
- Rıza yaşının altında veli rızası ve "makul çaba" ile doğrulama gerekir.
- **Sonuç:** Sosyal işlemeyi sözleşmenin ifasına (Madde 6/1-b) dayandırmak Madde 8'i devre dışı bırakır, ama çocuklara özel koruma (Madde 25 tasarımda gizlilik, Gerekçe 38) yine geçerlidir.

### 2.2 DSA Madde 28 kılavuzu (Avrupa Komisyonu, 14 Temmuz 2025, C/2025/5519)
Bağlayıcı değil ama uyum ölçütü olarak kullanılıyor. Çevrimiçi platformlara (herkese açık yayılan içerik) yönelik; davetle sınırlı arkadaş mesajlaşması tam olarak bu tanıma girmeyebilir, genel sıralama girebilir. İlkeleri yine de uyguluyoruz:
- Küçüklerin hesapları **varsayılan olarak özel**; bağlantı olmayan kişiden istenmeyen temas yok.
- En sıkı gizlilik / güvenlik ayarları varsayılan; değiştirme seçeneği nötr dille sunulur (karanlık desen yok).
- **Seri (streak) gibi zorlayıcı özellikler küçüklerde kapalı ya da yumuşatılmış.** Bizde süreklilik bir sıralama metriği adayı (§6); küçüklerde gösterilmemesi önerilir.
- Kendi beyandan öte yaş güvencesi önerilir. v1'de yalnız beyan var (açık risk, §7).

### 2.3 Türkiye 5651 ek madde 4 (15 yaş)
- Sosyal ağ sağlayıcı 15 yaş altına hizmet sunamaz; yaş doğrulama dahil tedbir alır. 15–18 yaşa ayrıştırılmış hizmet ve ebeveyn araçları ister. Yaş doğrulaması e-Devlet belirteciyle yapılacak; teknik ayrıntı Başkanlık rehberine bırakılmış.
- Yönetmelik platformları isimle saymıyor; tanım "sosyal etkileşim amacıyla içerik oluşturup paylaşma". Mesajlaşma uygulamalarının kapsamı belirsiz.
- **İhtiyatlı öneri:** Sosyal özellikler **15 yaş ve üstüne** açılır; 13–14 yaş uygulamanın kişisel kısmını (plan, odak, beyin) kullanır, Birlikte bölümü "15 yaşında açılır" diye kapalı görünür. 15–17 yaş §5'teki sıkı modda çalışır. Bu, AB'de 13–15 rıza yaşı farklarını da büyük ölçüde örter.

## 3. Google Play
### 3.1 Kullanıcı üretimli içerik (UGC) politikası
Zorunlu (Play Console yardım sayfası, 2026):
- Kullanıcı UGC oluşturmadan önce **kullanım şartlarını / kullanıcı politikasını kabul eder**; atlanamaz. Şartlar sakıncalı içerik ve davranışı tanımlar ve yasaklar.
- Uygulama içinden **kullanıcıyı ve içeriği şikâyet etme**; şikâyete gerektiğinde işlem yapılır.
- Birebir etkileşimde (doğrudan mesaj) uygulama içinden **kullanıcıyı engelleme**. Şikâyet ve engel ayrı, açık etiketli işlevler olmalı.
- Özellikle küçüklere yönelik taciz ve zorbalığa karşı yeterli önlem; şikâyetleri sürekli yanıtsız bırakmak ihlal sayılır.
- Sesli ya da yazılı sohbet için ayrı bir bölüm yok; mesajlaşma birebir etkileşim kuralına girer, sesli oturum da aynı engelle / şikâyet et akışını alır.

### 3.2 Çocuk Güvenliği Standartları politikası
- Kapsam: anonim ve rastgele sohbet uygulamaları, Play Console'da kategorisi **Sosyal** ya da **Flört** olanlar. NöroPlan **Verimlilik** kategorisinde kalırsa zorunlu değil.
- Yine de uyulması önerilir (düşük maliyet): CSAE'ye karşı yayımlanmış web standardı, uygulama içi geri bildirim, CSAM'ı bilgi edinildiğinde kaldırma, çocuk güvenliği yasalarına uyum, Play Console'da adı ve iletişimi olan bir çocuk güvenliği sorumlusu.

### 3.3 Diğer Play beyanları
- **Hedef kitle ve içerik:** 13+ hedef, Aileler programı dışı. İçerik derecelendirme anketinde "kullanıcılar birbirleriyle etkileşir" ve "kullanıcılar ses/metin paylaşır" işaretlenir.
- **Veri güvenliği formu:** mesajlar, ses (aktarılır, saklanmaz), arkadaş listesi, uygulama içi etkinlik.
- **Ön plan servisi beyanı:** Aşama 3'teki `specialUse`'a ek olarak `microphone` türü (§4.4).
- **Hesap silme:** uygulama içi + web'den silme isteği sayfası (zaten DB_SCHEMA §6.3'te açık iş).

## 4. Teknik güvenlik tasarımı
### 4.1 İlkeler
1. **Kural veritabanında.** İstemci yalnız göstermeyi bilir; görünürlük, engel, arkadaşlık, partner sınırı, hız sınırı ve yaş kuralları RLS + `security definer` fonksiyon + tetikleyiciyle uygulanır.
2. **Varsayılan kapalı.** Bulunabilirlik, genel sıralama, mikrofon, beyin karşılaştırma izni: hepsi kapalı başlar.
3. **Engel her şeyi keser.** Engellenen kişi profil, takvim, boş zaman, mesaj, oturum, sıralama, beyin: hiçbirini göremez; engelleyenin varlığını da öğrenemez (davet "geçersiz kod" döner).
4. **Yaş sunucuda bilinir.** `birth_year` profilde; RPC'ler yaşı sunucuda hesaplar. 15 yaş altı sosyal RPC'leri çağıramaz.

### 4.2 Partner / arkadaş planı (DB'de görünürlük)
- Yeni tablo `calendar_blocks` (öneri): `user_id`, `activity_id`, `start_at`, `end_at`, `window_start`. Cihaz plan değişince önümüzdeki **14 günün** bloklarını tek RPC ile değiştirir (`publish_calendar(window_start, blocks[])`). Başlık, not ve kategori bu tabloda **yoktur**; `activities`'ten (eşitlenmiş) birleştirilir.
- Tabloyu yalnız sahibi okur. Arkadaş `friend_calendar(friend, from, to)` ile okur; fonksiyon her blok için `visibility_level` uygular (`busy` · `title_time` · `full` · `hidden`). Kural yoksa varsayılan: partnere **`title_time`**, diğer arkadaşlara **`busy`** (D44, proje sahibi onayladı).
- Kişi istisnası ("bu partnerime tam göster") `visibility_settings.viewer_id` satırıdır; zaten şemada.
- Ortak boş zaman: `common_free_time(users[], from, to, min_minutes)` yalnız **herkesin boş olduğu aralıkları** döner (`tstzrange` birleşimi); kimin neyle meşgul olduğunu dönmez. Çağıran kişi listedeki herkesle arkadaş olmalı; aralık ≤ 14 gün.
- Kullanıcı Birlikte'yi hiç açmadıysa blok yayınlanmaz.

### 4.3 Realtime (ortak odak)
- Supabase Realtime **özel kanallar**: projede "Allow public access" kapatılır, `realtime.messages` üzerinde RLS. Kanal adı `cofocus:<oturum_id>`; SELECT (katıl / dinle) ve INSERT (gönder) politikası `is_cofocus_participant(oturum)` ile. Presence kim burada, broadcast olaylar (başladı, mola, plan bozuldu, bitti) içindir.
- Sayaç senkronu: oturumun `started_at` ve faz planı sunucu saatiyle yazılır (`now()`); istemci kendi saat kaymasını bir RPC'nin döndürdüğü sunucu zamanıyla düzeltir. Sayaç yine yerel `FocusClock` ile hesaplanır.
- Kota (Free): 200 eşzamanlı bağlantı, saniyede 100 mesaj. İlk sürüm için yeterli; Pro 500 bağlantı.
- Katılımcı sınırı: **en çok 4 kişi** (onaylandı, D44).

### 4.4 Ses
- Ses sağlayıcısının token'ı **Edge Function** üretir (`voice_token`): çağıranın oturum katılımcısı olduğunu, engel olmadığını ve yaşını kontrol eder; API anahtarı yalnız Edge Function ortamında (CLAUDE.md kural 7).
- **Kayıt yok:** sağlayıcının kayıt / egress / transkripsiyon özellikleri kullanılmaz; token'a `roomRecord` gibi yetki verilmez. Veritabanında sesle ilgili yalnız `voice_enabled` ve `room_id` var.
- Mikrofon varsayılan kapalı; açmak tek dokunuş. Konuşan göstergesi sağlayıcının ses düzeyi olayından. "Sessize al" yalnız dinleyenin cihazında o kişinin sesini kapatır.
- **Android 14:** `foregroundServiceType="microphone"`, `FOREGROUND_SERVICE_MICROPHONE` izni, `RECORD_AUDIO` çalışma anı izni. Mikrofon türlü ön plan servisi **uygulama öndeyken** başlatılmalı (arka plandan başlatma yasak). Ses açıkken odak servisi `specialUse|microphone` türleriyle yeniden başlatılır. Uygulamadan çıkılırsa Aşama 3'teki 10 sn kuralı aynen işler; oturum bozulursa ses de kapanır.

### 4.5 Mesajlaşma
- Yalnız kabul edilmiş arkadaşlar arasında; `send_message` RPC'si arkadaşlık, engel, yaş ve hız sınırını kontrol eder.
- **Hız sınırı:** kişi başına dakikada 20, saatte 300 mesaj; aşınca "biraz yavaşla" hatası (sunucu, kayan pencere sayacı).
- **Küfür filtresi:** sunucuda TR + EN kelime listesi (`profanity_terms` sistem tablosu, Türkçe harf normalleştirmesiyle: ı/i, ş/s, sayı-harf değişimi). Eşleşen kelime `***` ile maskelenir, mesaj yine gider (Geçici; "reddet" de seçilebilir). Liste kullanıcıya özel içerik değil; sistem verisidir.
- Hazır tepkiler: şemadaki 6 emoji.
- Fotoğraf / dosya yok. Bağlantılar tıklanabilir yapılmaz (oltalama).
- Odak oturumu sürerken mesaj bildirimi gösterilmez; oturum bitince "N yeni mesaj" özeti.

### 4.6 Şikâyet ve moderasyon
- Şikâyet edilen mesajın **metni şikâyet anında kopyalanır** (`reports.snapshot`); gönderen mesajı silse ya da hesabını silse de kanıt kalır. Saklama 1 yıl (Geçici).
- `child_safety` nedenli şikâyet öncelikli; yayın öncesi bir sorumlu kişi atanır (Play §3.2).
- İnceleme akışı (ayrı panel yerine, ilk sürüm), Supabase Studio → SQL Editor:
  1. `select * from moderation_queue;` (çocuk güvenliği önce, sonra eskiden yeniye; mesaj şikâyetinde `snapshot` mesajın kopyası).
  2. `select resolve_report('<id>', 'dismiss' | 'hide_message' | 'suspend_7d' | 'suspend_30d' | 'ban', 'not');` Mesaj gizlenir ya da kişinin sosyal özellikleri `social_profiles.suspended_until`e kadar kapanır (Birlikte ekranı nedenini ve tarihi söyler). Şikâyet `resolved` olur, işlem `moderation_actions`a yazılır.
  3. Uygulama içinden moderatör: kullanıcı kimliği `moderators` tablosuna eklenir (yalnız Studio'dan); RPC onu da kabul eder.
  4. `child_safety` şikâyetinde CSAM şüphesi varsa içerik kaldırılır ve yasal bildirim yükümlülüğü değerlendirilir (yayın öncesi sorumlu kişi atanır).
- Kullanıcı kendi şikâyetinin durumunu görür.

### 4.7 Hile koruması ve sıralama
- Sıralama yalnız sunucuda hesaplanır: arkadaş tablosu canlı SQL (`friends_leaderboard`), genel tablo pg_cron ile 30 dk'da bir (`refresh_global_leaderboard`). Girdi: eşitlenmiş `focus_sessions`.
- Reddedilen oturumlar: kendi içinde çakışan (aynı kullanıcı, kesişen zaman), `focused_seconds` > bitiş − başlangıç, gelecekte biten, sunucuya varışından > 7 gün önce biten (geriye dönük yığma), günlük toplam odak > 16 saat. Reddedilen oturum sıralamaya ve sunucu beynine girmez; kullanıcının kendi cihazındaki beyni etkilenmez.
- Beyin sunucuda `neuroplan_core` ile yeniden hesaplanır (`dart compile js`, ARCHITECTURE §7). Prototip başarısız olursa hesap TypeScript'e çevrilir ve `brain_v2.json` test vektörüyle eşitlik korunur.
- Plana uyum sunucuda doğrulanamaz (plan motoru sunucuda çalışmaz, D24); bu yüzden sıralama metriği olarak önerilmez.

### 4.8 Hesap silme ve sosyal veri
| Veri | Ne olur |
|---|---|
| Arkadaşlık, partnerlik, davetler, engeller, görünürlük, takvim blokları | Kalıcı silinir (cascade). Karşı taraf listesinden kaybolur; partnerlik biter. |
| Gönderdiği mesajlar ve tepkiler | Kalıcı silinir (cascade, DB_SCHEMA §6.3). Karşı tarafın sohbetinde "silinmiş mesaj" bile kalmaz. |
| Birebir sohbet | Üyesi kalmayınca silinir. |
| Ortak etkinlik | Oluşturan silerse etkinlik iptal edilir, karşı tarafın planından düşer; katılımcı silerse yalnız katılımı silinir. |
| Ortak odak oturumu | Katılım silinir; karşı tarafın kendi odak oturumu ve beyni etkilenmez. |
| Sıralama satırları | Silinir. |
| Hakkında yapılan şikâyetler | Kalır, `reported_user_id = null`, mesaj kopyası kalır (moderasyon kaydı). |
| Kendi yaptığı şikâyetler | Silinir. |

## 5. Yaş grubuna göre varsayılanlar (öneri)
| | 13–14 | 15–17 | 18+ |
|---|---|---|---|
| Birlikte bölümü | Kapalı ("15 yaşında açılır") | Açık | Açık |
| Davet kodu / QR ile arkadaş | — | Evet | Evet |
| Tam kullanıcı adıyla bulunabilirlik | — | Kapalı başlar, açılabilir | Kapalı başlar, açılabilir |
| Plan görünürlüğü varsayılanı | — | Başlık ve saat (yalnız arkadaş) | Başlık ve saat (yalnız arkadaş) |
| Mesaj, ortak oturum, ses | — | Yalnız arkadaşla | Yalnız arkadaşla |
| Arkadaş sıralaması | — | Açık | Açık |
| Genel sıralama | — | Kapalı, açılamaz (öneri) | Kapalı başlar, katılmak seçim |
| Süreklilik (seri) metriği | — | Gösterilmez | Gösterilir |
| Beyin karşılaştırma | — | Kapalı başlar | Kapalı başlar |

Yaş beyanı: ilk kurulumda doğum yılı (yalnız yıl). Yaş sonradan **küçültülemez**, yalnız büyür (yaş değiştirerek kural atlatmayı zorlaştırır).

## 6. Ses altyapısı karşılaştırması
| | LiveKit Cloud | LiveKit (kendi sunucumuz) | Agora | Cloudflare Realtime | Daily / 100ms |
|---|---|---|---|---|---|
| Flutter SDK | `livekit_client` 2.14, doğrulanmış yayıncı, Apache-2.0, Android/iOS | Aynı SDK | `agora_rtc_engine` 6.6, doğrulanmış yayıncı, MIT | Resmî Flutter SDK yok; `flutter_webrtc` ile elle | Var (resmî), daha küçük topluluk |
| Ücretsiz | 5.000 katılımcı-dk/ay, 100 eşzamanlı, 50 GB | Sunucu ücreti (~5–10 $/ay küçük VPS) | 10.000 dk/ay | 1.000 GB/ay (ses için çok fazla) | 10.000 dk/ay |
| Sonrası | Ship 50 $/ay: 150.000 dk, sonra 0,0005 $/dk | Bant genişliği | 0,99 $ / 1.000 dk | 0,05 $/GB | ~0,001–0,004 $/dk |
| Bölge / veri yeri | Bölge sabitleme yalnız Scale (500 $/ay) ve üstü | Tam kontrol (AB / TR'de barındırılabilir) | Küresel ağ, ABD şirketi; Ar-Ge Çin'de | Küresel anycast, bölge seçimi yok | ABD ağırlıklı |
| Açık kaynak | Sunucu açık (Apache-2.0); sağlayıcı değiştirmeden kendi sunucuya geçilebilir | Evet | Hayır | Hayır | Hayır |
| Kayıt riski | Kayıt ayrı "egress" servisi; token'da yetki verilmezse kapalı | Egress hiç kurulmaz | Bulut kaydı ayrı servis | Kayıt yok | Kayıt ayrı özellik |
| Not | Önerilen. Kilitlenme yok. | Ölçek ve bakım bizde (TURN, güncelleme) | Ucuz ama gizlilik / aktarım tarafı zayıf | En ucuz ama en çok kod | — |

Hesap: 2 kişilik 50 dk'lık sesli oturum = 100 katılımcı-dk. LiveKit Build ile ayda ~50 oturum ücretsizdir; sonrası Ship.
**Öneri:** LiveKit Cloud ile başla; veri yeri ya da maliyet gerekirse aynı SDK ile kendi sunucumuza geç. Her iki durumda KVKK m. 9 standart sözleşmesi gerekir (Cloud için).

## 7. Yayın öncesi açık riskler (hukuk kontrolüne)
1. NöroPlan'ın 5651 "sosyal ağ sağlayıcı" sayılıp sayılmadığı; sayılırsa e-Devlet yaş doğrulaması ve 15–18 ebeveyn araçları.
2. Sözleşmenin ifası hukuki sebebinin 15–17 yaş için yeterliliği (KVKK uygulaması 18 altı veli rızasına yatkın).
3. Yaş yalnız beyan; AB kılavuzu daha güçlü güvence öneriyor.
4. KVKK m. 9 standart sözleşmeleri (Supabase, ses sağlayıcısı) ve 5 iş günü bildirimi.
5. Kullanım şartları, topluluk kuralları, CSAE standardı ve gizlilik politikasının web'de yayımlanması (barındırma yeri seçilecek; taslaklar [docs/legal/](legal/)).
6. Ses kapalıyken (lobide, odak dışında) uygulama arka plana geçerse mikrofon servisi yoktur; Android sesi kesebilir. Ses asıl olarak odak sırasında (uygulama sabitliyken) kullanılır.
7. Mesaj push bildirimi (FCM, D49) metin içermez; Firebase servis hesabı yalnız Edge Function sırrındadır. Google Firebase da yurt dışı aktarım listesine girer (madde 4).

## 8. Kaynaklar
- KVKK: [Kurul kararı 2022/776](https://www.kvkk.gov.tr/Icerik/7572/2022-776) · [Standart sözleşme bildirim modülü duyurusu](https://www.kvkk.gov.tr/Icerik/8043/Standart-Sozlesme-Bildirim-Modulu-Hakkinda-Kamuoyu-Duyurusu) · [Standart sözleşmelerde dikkat edilecekler](https://www.kvkk.gov.tr/Icerik/8170/Yurt-Disina-Kisisel-Veri-Aktariminda-Kullanilacak-Standart-Sozlesmelerde-Dikkat-Edilmesi-Gereken-Hususlara-Iliskin-Kamuoyu-Duyurusu) · [Küçüklerin KVKK hakları, 2020/622 yorumu](https://www.ozgureralp.com/kucuklerin-kvkk-haklari-ayirt-etme-gucu-ve-veli-yetkisi-karar-2020-622/) · [Dülger: GDPR ve KVKK bakımından çocuk verileri](https://www.hukukihaber.net/gdpr-ve-kvkk-bakimindan-cocuklarin-kisisel-verilerinin-korunmasi-ve-konuya-iliskin-kurul-kararinin-degerlendirilmesi)
- 5651 / 15 yaş: [AA: 5 soruda düzenleme](https://www.aa.com.tr/tr/gundem/5-soruda-tbmmde-kabul-edilen-sosyal-medyaya-yonelik-duzenlemeler/3915490) · [Forbes Türkiye: ayrıştırılmış hizmet ve yaş doğrulama](https://www.forbes.com.tr/hukuk/turkiye-de-sosyal-ag-saglayicilarina-getirilen-cocuklara-ozgu-ayristirilmis-hizmet-sunulmasi-ve-yas-dogrulamaya-iliskin-yeni-duzenlemeler) · [Lexology, 26.10.2026](https://www.lexology.com/library/detail.aspx?g=7f6db7a0-5ec1-43a7-9b4a-876a48ca872b) · [Elçi Hukuk: 1 Kasım 2026](https://www.elci.av.tr/makale/15-yas-alti-sosyal-medya-yasagi-e-devlet-yas-dogrulama-1-kasim-2026-217)
- GDPR / AB: [GDPR Madde 8](https://gdpr-info.eu/art-8-gdpr/) · [Bird & Bird: ülke tablosu](https://childreninthedigitalworld.twobirds.com/home/eu) · [Komisyon: DSA Madde 28 kılavuzu](https://digital-strategy.ec.europa.eu/en/library/commission-publishes-guidelines-protection-minors) · [Hunton özeti](https://www.hunton.com/privacy-and-cybersecurity-law-blog/european-commission-issues-guidelines-on-the-protection-of-minors)
- Google Play: [UGC politikası](https://support.google.com/googleplay/android-developer/answer/9876937?hl=en) · [Çocuk Güvenliği Standartları](https://support.google.com/googleplay/android-developer/answer/14747720?hl=en)
- Android: [Ön plan servis türleri](https://developer.android.com/guide/components/fg-service-types) · [Android 14 tür zorunluluğu](https://developer.android.com/about/versions/14/changes/fgs-types-required) · [Arka plandan başlatma kısıtı](https://developer.android.com/about/versions/12/foreground-services)
- Supabase: [Realtime yetkilendirme](https://supabase.com/docs/guides/realtime/authorization) · [Realtime limitleri](https://supabase.com/docs/guides/realtime/limits) · [Realtime fiyat](https://supabase.com/docs/guides/realtime/pricing)
- Ses: [LiveKit fiyat](https://livekit.com/pricing) · [Agora sesli arama fiyatı](https://agora.io/en/pricing/voice-calling) · [Cloudflare Realtime fiyatı](https://developers.cloudflare.com/realtime/sfu/pricing) · [100ms fiyat](https://www.100ms.live/pricing) · [livekit_client](https://pub.dev/packages/livekit_client) · [agora_rtc_engine](https://pub.dev/packages/agora_rtc_engine)
