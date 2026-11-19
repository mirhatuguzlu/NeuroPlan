# SETUP_BACKEND.md — Sunucu kurulumu (proje sahibinin adımları)

Aşama 4B'nin sunucu tarafını canlıya almak için yapılacaklar, sırayla. Kod ve migration'lar repoda hazır; buradaki adımlar hesaplara, panolara ve gizli anahtarlara dokunduğu için proje sahibi yapar.
Kararlar: DECISIONS D42–D49 · Güvenlik: [SOCIAL_SAFETY.md](SOCIAL_SAFETY.md) · Test: [QA_CHECKLIST.md](QA_CHECKLIST.md) C.

**Altın kural:** `service_role` / secret key, LiveKit API secret, Firebase servis hesabı JSON'u ve `PUSH_WEBHOOK_SECRET` **hiçbir zaman** repoya ya da `.env`'e girmez; yalnız Supabase sırlarına (`supabase secrets set`) ve Vault'a girer. Uygulamanın `.env`'inde yalnız istemcide zaten görünen değerler durur.

Aşağıda `<REF>` Supabase proje referansındır (Dashboard → Project Settings → General → Reference ID), `<PAKET>` = `com.mirhatuguzlu.neuroplan`.

---

## 1. Google girişi (Google Cloud)
1. [console.cloud.google.com](https://console.cloud.google.com) → üstten projeyi seç ya da **Yeni proje** (Firebase için de aynı proje kullanılabilir, §7).
2. **Google Auth Platform → Branding** (eski adı "OAuth consent screen"): uygulama adı NöroPlan, destek e-postası, gizlilik politikası adresi (§9). **Audience → External**. Kapsamlar: `openid`, `email`, `profile` (hassas kapsam yok, Google incelemesi gerekmez).
   - Yayınlamadan önce durum "Testing" kalırsa yalnız eklediğin test kullanıcıları giriş yapabilir; iki test hesabını **Test users**'a ekle ya da **Publish app** de.
3. **Clients → Create client → Web application**:
   - Ad: `NeuroPlan Supabase`
   - **Authorized redirect URIs:** `https://<REF>.supabase.co/auth/v1/callback`
   - Oluşan **Client ID** ve **Client secret**'ı not et.
4. **Clients → Create client → Android** (her imza anahtarı için bir tane):
   - Package name: `<PAKET>`
   - **SHA-1, geliştirme (debug):**
     ```bash
     keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
     ```
   - **SHA-1, yayın:** Play Console → uygulama → **Test et ve yayınla → Kurulum → Uygulama bütünlüğü → Uygulama imzalama** sayfasındaki "Uygulama imzalama anahtarı sertifikası" SHA-1'i (Play App Signing) ve kendi yükleme anahtarının SHA-1'i için ayrı ayrı Android client.
   - Android client'ın kimliğini koda yazmazsın; Google onu paket adı + SHA-1 ile eşleştirir.
5. Uygulamanın `.env` dosyasına (git-ignored):
   ```
   GOOGLE_WEB_CLIENT_ID=<3. adımdaki Web Client ID>.apps.googleusercontent.com
   ```

## 2. Supabase panosu
**Authentication → Sign In / Providers**
- **Google:** Enable. *Client IDs* = 1.3'teki Web Client ID; *Client Secret (for OAuth)* = Web client secret. **Skip nonce checks: açık** (Android Credential Manager girişi nonce göndermiyor; kapalı kalırsa `signInWithIdToken` reddedilir). Kaydet.
- **User Signups** bölümünde: **Allow anonymous sign-ins: açık** (misafir modu) · **Allow manual linking: açık** (misafir → Google bağlama).
- *Confirm email* ayarı önemsiz (e-posta girişi yok).

**Authentication → Attack Protection**
- CAPTCHA'yı **şimdilik açma**: uygulama henüz CAPTCHA belirteci göndermiyor, misafir girişi kırılır. Varsayılan oran sınırları (saatte IP başına 30 anonim giriş) yeterli.

**Authentication → URL Configuration** (yalnız web silme sayfasını §8'de "sayfadan sil" ile kullanacaksan)
- *Redirect URLs*'e silme sayfasının tam adresini ekle, ör. `https://<github-kullanıcın>.github.io/NeuroPlan/account-deletion/`.

**Realtime → Settings**
- **Allow public access: kapalı.** (Ortak odak kanalı özel; kapalı olmazsa RLS politikası atlanabilir.)

**Database → Extensions** (migration oluşturmayı dener; hata olursa elle aç)
- `pg_cron` (genel sıralama 30 dk'da bir tazelenir) · `pg_net` (mesaj push tetikleyicisi) · `supabase_vault` (varsayılan açık).

## 3. Migration'ları uygula
Bu CLI sürümü hedef verilmezse **yerel** stack'i seçer; her komutta çıktıdaki `Target:` satırına bak.
```bash
supabase login
supabase link --project-ref <REF>
supabase migration list --remote
supabase db push --remote
```
Uygulanacak üç yeni dosya: `20261120120000_social_v1.sql`, `20261120120100_brain_input.sql`, `20261120120200_message_push.sql`. Sonra:
```bash
supabase migration list --remote
```
ile üçünün de "Remote" sütununda göründüğünü doğrula. Supabase **Advisors → Security**'de yeni bir uyarı çıkmamalı (çıkarsa sabah bana göster).

## 4. Sesli sohbet (LiveKit Cloud)
1. [cloud.livekit.io](https://cloud.livekit.io) → hesap → **Create project** (ad: neuroplan). Plan: **Build (ücretsiz)**: ayda 5.000 katılımcı-dakika, 100 eşzamanlı bağlantı.
2. Proje → **Settings → API Keys → Create key**. *API Key* ve *API Secret*'ı kopyala (secret bir kez gösterilir).
3. Proje ana sayfasındaki **WebSocket URL** (`wss://<ad>.livekit.cloud`).
4. **Egress / Recording'i açma**; uygulama kayıt yetkisi vermiyor (SOCIAL_SAFETY §4.4).
5. Değerler §6'daki sır dosyasına girer, uygulamaya girmez.

## 5. Mesaj push bildirimi (Firebase Cloud Messaging, D49)
1. [console.firebase.google.com](https://console.firebase.google.com) → **Add project** → var olan Google Cloud projesini seç (§1) ya da yeni. Google Analytics gerekmez, kapat.
2. Proje ayarları (dişli) → **Your apps → Android ekle**: paket adı `<PAKET>`, SHA-1 isteğe bağlı. **google-services.json'u indir ama repoya koyma**; yalnız içinden değer okuyacağız. Uygulama bu dosyasız çalışır (Firebase `.env`'den başlatılır).
3. google-services.json'dan uygulamanın `.env` dosyasına:
   ```
   FIREBASE_API_KEY=<client[0].api_key[0].current_key>
   FIREBASE_APP_ID=<client[0].client_info.mobilesdk_app_id>
   FIREBASE_SENDER_ID=<project_info.project_number>
   FIREBASE_PROJECT_ID=<project_info.project_id>
   ```
   (Bu değerler istemcide zaten açık olan kimliklerdir, gizli değildir.)
4. Proje ayarları → **Cloud Messaging**: "Firebase Cloud Messaging API (V1)" **Enabled** olmalı (yeni projelerde varsayılan).
5. Proje ayarları → **Service accounts → Generate new private key** → JSON indirilir. Bu dosya **gizlidir**: yalnız §6'daki sır dosyasına tek satır olarak girer; bilgisayarında repo klasörünün dışında tut ya da işin bitince sil.
6. Rastgele uzun bir paylaşılan sır üret (ör. 48 karakter):
   ```bash
   node -e "console.log(require('crypto').randomBytes(36).toString('base64url'))"
   ```
   Bu değer hem §6'da `PUSH_WEBHOOK_SECRET`'a hem §7'de Vault'a girer.

## 6. Edge Functions ve sırlar
1. Şablonu kopyala ve doldur (dosya git'e girmez):
   ```bash
   copy supabase\functions\.env.example supabase\functions\.env.prod
   ```
   - `LIVEKIT_URL`, `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET` (§4)
   - `PUSH_WEBHOOK_SECRET` (§5.6)
   - `FIREBASE_SERVICE_ACCOUNT` = servis hesabı JSON'unun tamamı **tek satırda** (`private_key` içindeki `\n`'ler olduğu gibi kalır).
2. Sırları gönder:
   ```bash
   supabase secrets set --env-file supabase/functions/.env.prod --project-ref <REF>
   ```
3. Fonksiyonları yayınla (push fonksiyonu kullanıcı JWT'si değil kendi sırrını denetler, bu yüzden `--no-verify-jwt`):
   ```bash
   supabase functions deploy delete_account --project-ref <REF>
   supabase functions deploy voice_token --project-ref <REF>
   supabase functions deploy brain_snapshot --project-ref <REF>
   supabase functions deploy push_message --no-verify-jwt --project-ref <REF>
   ```
4. Kontrol: Dashboard → **Edge Functions**'ta dördü de "Active". `supabase secrets list --project-ref <REF>` beş sırrı listeler (değerleri göstermez).

## 7. Push tetikleyicisinin Vault ayarı
Dashboard → **SQL Editor**:
```sql
select vault.create_secret('https://<REF>.supabase.co/functions/v1/push_message', 'push_function_url');
select vault.create_secret('<§5.6 PUSH_WEBHOOK_SECRET ile aynı değer>', 'push_webhook_secret');
```
Bu iki satır yoksa tetikleyici hiçbir şey yapmaz; mesajlar yine gider, yalnız push gelmez.
Değiştirmek için: `select vault.update_secret((select id from vault.secrets where name = 'push_webhook_secret'), '<yeni>');` ve §6'daki sırrı da aynı değere güncelle.

## 8. Web'den hesap silme sayfası (Play zorunluluğu)
Sayfa repoda: [docs/account-deletion/index.html](account-deletion/index.html). Üç yol gösterir: uygulamadan silme (her zaman), e-postayla istek (adres verilirse), sayfadan Google ile giriş yapıp silme (Supabase ayarı verilirse).

**Yayınlama (GitHub Pages, ücretsiz):**
1. GitHub → repo → **Settings → Pages → Build and deployment → Deploy from a branch → `main` / `/docs`** → Save. Birkaç dakika sonra adres: `https://<github-kullanıcın>.github.io/NeuroPlan/account-deletion/`.
2. Ayar dosyası: `docs/account-deletion/config.example.js`'i `config.js` olarak kopyala ve doldur:
   - `contactEmail`: silme isteklerinin geleceği adres (Play bu yolu ister; mutlaka doldur).
   - `supabaseUrl` + `supabaseKey` (publishable/anon key): "sayfadan sil" yolu için. İstemcide zaten açık değerlerdir, ama CLAUDE.md kural 7 Supabase değerlerini yalnız `.env`'de tutar; bu yüzden `config.js` git-ignored'dır.
   - **Karar senin:** (a) GitHub Pages kullanacaksan `config.js`'i yayınlamak için `.gitignore`'daki satırı kaldırıp commit'lemen gerekir (publishable key herkese açık tasarlanmıştır, RLS korur); (b) istemezsen `docs/account-deletion/` klasörünü `config.js` ile birlikte Cloudflare Pages / Netlify Drop gibi bir yere elle yükle; (c) yalnız e-posta yolu yetiyorsa `supabaseUrl`/`supabaseKey`'i boş bırak.
3. "Sayfadan sil" kullanılacaksa §2'deki *Redirect URLs*'e sayfa adresini ekle.
4. **E-postayla gelen istek nasıl işlenir:** isteği gönderen adresin bir NöroPlan hesabına bağlı olduğunu doğrula (Dashboard → Authentication → Users → e-postayla ara) → kullanıcıyı seç → **Delete user**. Tablolar cascade ile silinir (DB_SCHEMA §6.3). 30 gün içinde yanıtla.
5. Aynı Pages adresinde hukuk taslakları da yayımlanır: `.../legal/community_guidelines.html`, `.../legal/child_safety_standards.html`, `.../legal/privacy_policy.html` (Jekyll Markdown'ı HTML'e çevirir). **Önce hukuk incelemesi** (§10).

## 9. Moderasyon
1. Kendi kullanıcı kimliğini moderatör yap (Dashboard → Authentication → Users → kimliği kopyala → SQL Editor):
   ```sql
   insert into public.moderators (user_id) values ('<senin-kullanıcı-kimliğin>');
   ```
2. İnceleme: `select * from moderation_queue;` → karar: `select resolve_report('<şikâyet-id>', 'dismiss' | 'hide_message' | 'suspend_7d' | 'suspend_30d' | 'ban', 'not');` (SOCIAL_SAFETY §4.6).
3. Haftada en az bir kez kuyruğa bak; `child_safety` şikâyetleri en üstte gelir ve aynı gün bakılmalı.

## 10. Hukuk ve Play Console (yayından önce)
**KVKK**
- Yurt dışına aktarım (m. 9): Supabase (proje bölgesi AB ise yine yurt dışı), LiveKit Cloud ve Google Firebase için **standart sözleşme** imzala; imzadan itibaren **5 iş günü** içinde KVKK'nın Standart Sözleşme Bildirim Modülü'nden ya da KEP ile bildir. Sağlayıcıların DPA'larını indir (Supabase: Dashboard → Organization → Legal Documents; LiveKit ve Google: kendi sitelerinde).
- VERBİS kaydı: çalışan sayısı / bilanço eşiklerine göre muaf olabilirsin; avukatına sor.
- Aydınlatma metni ve gizlilik politikası: taslak [docs/legal/privacy_policy.md](legal/privacy_policy.md).
- Açık sorular (SOCIAL_SAFETY §7): 5651 "sosyal ağ sağlayıcı" kapsamı, 15–17 yaş için hukuki sebep, yalnız beyana dayalı yaş.

**Play Console (Uygulama içeriği)**
- **Gizlilik politikası:** §8'deki `privacy_policy.html` adresi.
- **Hedef kitle ve içerik:** 13–15, 16–17, 18+ seçili; 13 yaş altı seçili değil (Aileler programı dışı).
- **İçerik derecelendirme anketi:** "Kullanıcılar birbiriyle etkileşir / içerik paylaşır" → Evet; "Konum paylaşılır" → Hayır.
- **Veri güvenliği formu:** toplanan → ad (takma ad), e-posta (Google), kullanıcı kimlikleri, kullanıcı içeriği (mesajlar), uygulama etkinliği (planlar, odak oturumları), yaklaşık konum (profilde 0,1°'ye yuvarlanmış, eşitleniyor), ses (sesli sohbette **aktarılır, saklanmaz**); hepsi aktarımda şifreli; kullanıcı silme isteyebilir → §8 adresi.
- **Hesap silme:** uygulama içi yol + §8 adresi.
- **Ön plan servisi beyanları:** `specialUse` (odak sayacı: kalan süre ve 10 sn dönüş uyarısı, kısa video ekle) ve `microphone` (ortak odakta kullanıcının açtığı sesli sohbet).
- **Kategori:** Verimlilik. Çocuk Güvenliği Standartları zorunlu değil ama hazır: §8'deki `child_safety_standards.html` adresi ve bir sorumlu kişi (ad + e-posta) gir.
- **Uygulama erişimi (inceleme için):** Google girişi gerekiyor → inceleme ekibine bir test Google hesabı ve "Birlikte'yi görmek için doğum yılı 18+ seç" notu ver.

## 11. Doğrulama
1. `.env` doldurulduktan sonra iki cihaza kur: `flutter run --dart-define-from-file=.env -d <cihaz>`.
2. [QA_CHECKLIST.md](QA_CHECKLIST.md) bölüm C'yi sırayla yap (C12: push, C13: web silme).
3. Sorun çıkarsa: Dashboard → **Logs → Edge Functions** (fonksiyon hataları), **Logs → Postgres** (RPC hataları; hata kodları NP001…NP429 SOCIAL_SAFETY'de), `adb logcat | grep -E "\[sync\]|\[push\]|\[voice\]|\[auth\]"`.
