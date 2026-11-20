# SETUP_BACKEND.md — Sunucu kurulumu (proje sahibinin adımları)

Aşama 4B'nin sunucu tarafını canlıya almak için yapılacaklar, sırayla ve tıklama tıklama. Kod ve migration'lar repoda hazır. Buradaki adımlar hesaplara, panolara ve gizli anahtarlara dokunduğu için proje sahibi yapar.
Kararlar: DECISIONS D42–D50 · Güvenlik: [SOCIAL_SAFETY.md](SOCIAL_SAFETY.md) · Test: [QA_CHECKLIST.md](QA_CHECKLIST.md) C.

**Altın kural:** Şu dört şey **hiçbir zaman** repoya ya da uygulamanın `.env`'ine girmez:
- `service_role` / secret key,
- LiveKit API secret,
- Firebase servis hesabı JSON'u,
- `PUSH_WEBHOOK_SECRET`.

Bunlar yalnız Supabase sırlarına (adım 6) ve Vault'a (adım 7) girer. Uygulamanın `.env`'inde yalnız istemcide zaten görünen değerler durur.

Süre: ilk kez yapılıyorsa 2–3 saat. Hukuk ve Play adımları (10) ayrı.

---

## 0. Başlamadan

**Kısaltmalar**
- `<REF>`: Supabase proje kimliği, 20 harfli bir dizi. Bulmak için: [supabase.com/dashboard](https://supabase.com/dashboard) → projeye tıkla → tarayıcı adres çubuğunda `.../project/<REF>/...`. Ya da **Project Settings → General → Project ID**.
- `<PAKET>` = `com.mirhatuguzlu.neuroplan`

**Değer defteri**
- Adımlar boyunca birçok kimlik ve sır kopyalayacaksın.
- Bunları repo **dışında** geçici bir metin dosyasında topla, ör. `C:\Users\<sen>\Documents\neuroplan-kurulum.txt`.
- Kurulum bitince sırları bu dosyadan sil. Firebase JSON'unu da sil.

**Terminal**
- VS Code'da projeyi aç (`C:\dev\NeuroPlan`) → üst menü **Terminal → New Terminal**.
- Alttaki satırın `C:\dev\NeuroPlan` ile başladığını kontrol et.
- Aşağıdaki komutları bu terminale yapıştırıp Enter'a bas.

**Gerekli araçlar** (bu bilgisayarda kurulu)
- Supabase CLI 3.2: `supabase --version`
- Node: `node --version`
- JDK keytool: `C:\Program Files\Java\jdk-21.0.10\bin\keytool.exe`

**`.env` dosyası**
- Proje kökündeki `.env` dosyasını VS Code'da aç. Terminalden: `code .env`.
- Her satır `AD=değer` biçiminde olsun; tırnak yok, `=` etrafında boşluk yok.
- Eksik satırları `.env.example`'dan kopyalayıp ekle.
- Kaydet: Ctrl+S.

**Bu bilgisayarda hazır olanlar**
- `.env`'de `SUPABASE_URL` ve `SUPABASE_ANON_KEY` dolu.
- Repo bir Supabase projesine bağlı (`supabase/.temp/project-ref` var).
- Eksik satırlar: `GOOGLE_WEB_CLIENT_ID` ve dört `FIREBASE_*` satırı.

---

## 1. Google girişi (Google Cloud)

Giriş uygulamanın içinde, telefonun alttan açılan hesap seçicisiyle olur; tarayıcı açılmaz (D50). Bunun için iki istemci gerekir:
- **Web istemcisi:** Supabase'in Google'dan gelen kimliği doğruladığı istemci.
- **Android istemcisi:** her imza anahtarı için ayrı bir tane. Google, uygulamayı paket adı + SHA-1 ile tanır.

### 1.1 Proje
1. [console.cloud.google.com](https://console.cloud.google.com)'a Gmail hesabınla gir. Arayüz Türkçeyse menü adları çevrilmiş olur; konumları aynıdır.
2. Sol üstteki proje seçiciye tıkla → açılan pencerede **NEW PROJECT**.
3. *Project name*: `NeuroPlan` → **CREATE**.
4. Birkaç saniye sonra bildirim gelir → **SELECT PROJECT**. Üst çubukta "NeuroPlan" yazdığını kontrol et.

### 1.2 Onay ekranı (Google Auth Platform)
1. Üstteki arama kutusuna `Google Auth Platform` yaz → aç. Eski adı "OAuth consent screen".
2. İlk kez açılıyorsa **GET STARTED**:
   1. *App name*: `NöroPlan`, *User support email*: Gmail adresin → **NEXT**.
   2. *Audience*: **External** → **NEXT**.
   3. *Contact information*: Gmail adresin → **NEXT**.
   4. Politikayı onayla → **CONTINUE** → **CREATE**.
3. Soldan **Branding**:
   - *Application home page* ve *Application privacy policy link*: adım 8'deki GitHub Pages adresleri. Henüz yoksa boş bırak, adım 8'den sonra dön.
     - Ana sayfa: `https://mirhatuguzlu.github.io/NeuroPlan/account-deletion/`
     - Gizlilik: `https://mirhatuguzlu.github.io/NeuroPlan/legal/privacy_policy.html`
   - *Authorized domains* → **+ ADD DOMAIN**: `<REF>.supabase.co`. Pages adresleri girildiyse ayrıca `mirhatuguzlu.github.io`.
   - **SAVE**.
4. Soldan **Data Access** → **ADD OR REMOVE SCOPES**:
   - Listeden `.../auth/userinfo.email`, `.../auth/userinfo.profile` ve `openid` kutularını işaretle → **UPDATE** → **SAVE**.
   - Bunlar hassas kapsam değil; Google incelemesi gerekmez.
5. Soldan **Audience**:
   - *Publishing status* "Testing" ise yalnız listedeki hesaplar giriş yapabilir. **+ ADD USERS** → iki test cihazının Gmail adreslerini yaz → **SAVE**.
   - Herkese açmak için **PUBLISH APP** → **CONFIRM**. Hassas kapsam olmadığı için inceleme beklemez. Yayından önce bunu yapmayı unutma.

### 1.3 Web istemcisi
1. Soldan **Clients** → **+ CREATE CLIENT**.
2. *Application type*: **Web application**. *Name*: `NeuroPlan Supabase`.
3. *Authorized redirect URIs* → **+ ADD URI** → `https://<REF>.supabase.co/auth/v1/callback`
4. **CREATE**. Açılan pencerede *Client ID* ve *Client secret* görünür.
   - İkisini de hemen değer defterine kopyala.
   - Yeni istemcilerde secret yalnız bu pencerede tam gösterilir. Kaybedersen istemci sayfasından yeni bir secret eklersin.
   - **OK**.

### 1.4 Android istemcileri
**SHA-1'i bul (geliştirme / debug)** — terminale yapıştır:
```bash
& "C:\Program Files\Java\jdk-21.0.10\bin\keytool.exe" -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```
Çıktıdaki `SHA1:` satırının değerini kopyala (`08:72:...` gibi 20 çift). Bash terminali kullanıyorsan baştaki `& ` ve `$env:USERPROFILE` yerine `~` yaz.

**İstemciyi oluştur**
1. **Clients → + CREATE CLIENT** → *Application type*: **Android**.
2. *Name*: `NeuroPlan debug`.
3. *Package name*: `com.mirhatuguzlu.neuroplan`.
4. *SHA-1 certificate fingerprint*: kopyaladığın değer.
5. **CREATE**. Android istemcisinin kimliğini hiçbir yere yazmazsın; Google eşleştirmeyi kendisi yapar.

**Yayın için** (Play'e yüklemeden önce)
- Play Console → uygulama → **Test et ve yayınla → Kurulum → Uygulama bütünlüğü → Uygulama imzalama**.
- Sayfadaki iki SHA-1 için ayrı ayrı Android istemcisi oluştur, adımlar yukarıdakiyle aynı:
  - "Uygulama imzalama anahtarı sertifikası"
  - "Yükleme anahtarı sertifikası"
- Not: şu an release derlemesi de debug anahtarıyla imzalanıyor (`android/app/build.gradle.kts`). Play'e yüklemeden önce bir yükleme anahtarı oluşturulmalı; bu ayrı bir iş.

Belirti: SHA-1 kayıtlı değilse hesap seçici açılır, hesap seçilir, ama giriş hata ile döner.

### 1.5 `.env`
`.env`'e ekle:
```
GOOGLE_WEB_CLIENT_ID=<1.3'teki Client ID, sonu .apps.googleusercontent.com>
```
Buraya Android istemcisinin kimliği değil, **Web** istemcisinin kimliği girer.

---

## 2. Supabase panosu
[supabase.com/dashboard](https://supabase.com/dashboard) → projeye tıkla. Sol menü simgelerinin adı fareyle üzerine gelince görünür.

**2.1 API anahtarları** (`.env` zaten dolu; yalnız kontrol)
- **Project Settings** (dişli) → **API Keys**.
- `.env`'deki `SUPABASE_ANON_KEY` buradaki **Publishable key** (`sb_publishable_...`) ya da eski **anon** key olmalı.
- **Secret key / service_role asla `.env`'e girmez.**

**2.2 Google sağlayıcısı**
1. **Authentication** (kişi simgesi) → *Configuration* altında **Sign In / Providers**.
2. Üstteki *User Signups* bölümünde aç:
   - **Allow new users to sign up**
   - **Allow manual linking**: misafir → Google bağlama için.
   - **Allow anonymous sign-ins**: misafir modu için.
3. **Save changes**.
4. Aşağıda *Auth Providers* listesinde **Google**'a tıkla:
   - **Enable Sign in with Google**: aç.
   - *Client IDs*: 1.3'teki Web Client ID.
   - *Client Secret (for OAuth)*: 1.3'teki secret.
   - **Skip nonce checks**: **aç**. Android hesap seçicisi nonce göndermiyor; kapalı kalırsa giriş reddedilir.
   - *Callback URL* alanı zaten `https://<REF>.supabase.co/auth/v1/callback`; 1.3'te girdiğin adresle aynı olmalı.
   - **Save**.

**2.3 Saldırı koruması**
- **Authentication → Attack Protection**: *Enable Captcha protection* **kapalı** kalsın. Uygulama henüz CAPTCHA belirteci göndermiyor; açılırsa misafir girişi kırılır.

**2.4 Yönlendirme adresi** (yalnız adım 8'de "sayfadan sil" yolunu kullanacaksan)
- **Authentication → URL Configuration → Redirect URLs → Add URL**.
- Adres: `https://mirhatuguzlu.github.io/NeuroPlan/account-deletion/` → **Save URLs**.

**2.5 Realtime**
- **Realtime** (sol menü) → **Settings** → **Allow public access**: **kapalı** → **Save**.
- Ortak odak kanalı özeldir; bu açık kalırsa kanal yetki politikası atlanabilir.

**2.6 Eklentiler**
- Migration bunları kendisi açmayı dener; adım 3 hata verirse elle aç.
- **Database → Extensions** → arama kutusuna `pg_cron` yaz → anahtarı aç → **Enable extension**.
- Aynısını `pg_net` için yap. `supabase_vault` varsayılan olarak açık.

**2.7 Veritabanı şifresi**
- Adım 3'te CLI sorabilir.
- Bilmiyorsan: **Project Settings → Database → Reset database password** → yeni şifreyi değer defterine kaydet.
- Uygulama bu şifreyi kullanmaz; sıfırlamak uygulamayı bozmaz.

---

## 3. Migration'ları uygula
Bu CLI sürümünde (3.2) `db push` ve `migration list` hedef verilmezse **yerel** veritabanını seçer. Uzak proje için her zaman `--remote` yaz ve çıktıdaki hedef satırına bak.

1. Supabase'e giriş yap:
   ```bash
   supabase login
   ```
   Tarayıcı açılır → **Authorize** → terminalde "You are now logged in".
2. Bağlı projeyi kontrol et:
   ```bash
   supabase projects list
   ```
   Listede projenin yanında `●` işareti olmalı ve REF'i doğru olmalı. Değilse:
   ```bash
   supabase link --project-ref <REF>
   ```
   Şifre sorarsa 2.7'deki şifreyi yaz.
3. Önce kuru deneme (hiçbir şey değiştirmez):
   ```bash
   supabase db push --remote --dry-run
   ```
   Listede yalnız şu üç dosya görünmeli:
   - `20261120120000_social_v1.sql`
   - `20261120120100_brain_input.sql`
   - `20261120120200_message_push.sql`

   Daha fazlası görünüyorsa dur ve bana göster.
4. Uygula:
   ```bash
   supabase db push --remote
   ```
   Onay sorarsa `Y`.
5. Doğrula:
   ```bash
   supabase migration list --remote
   ```
   Üç dosya "Remote" sütununda da görünmeli.
6. Panoda **Advisors → Security Advisor** → **Rerun linter**. Yeni bir "ERROR" çıkmamalı; çıkarsa bana göster.

---

## 4. Sesli sohbet (LiveKit Cloud)
1. [cloud.livekit.io](https://cloud.livekit.io) → Google hesabınla kaydol.
2. İlk girişte proje oluşturma ekranı gelir. Gelmezse sol üstte proje adı → **Create new project**. Ad: `neuroplan`.
   - Plan: **Build (ücretsiz)**. Ayda 5.000 katılımcı-dakika ve 100 eşzamanlı bağlantı içerir; kart gerekmez.
3. Proje ana sayfasında **WebSocket URL**'i değer defterine kopyala (`wss://neuroplan-xxxx.livekit.cloud`).
4. Sol menü **Settings → API Keys** → **Create key** → açıklama `supabase` → oluştur.
   - Çıkan **API Key** ve **API Secret**'ı kopyala. Secret yalnız bir kez gösterilir.
5. **Egress / Recording açma.** Uygulama kayıt yetkisi vermiyor (SOCIAL_SAFETY §4.4).
6. Bu üç değer uygulamanın `.env`'ine **girmez**, adım 6'ya girer.

---

## 5. Mesaj push bildirimi (Firebase Cloud Messaging, D49)

### 5.1 Firebase projesi
1. [console.firebase.google.com](https://console.firebase.google.com) → **Create a project** (ya da **Add project**).
2. Ad kutusunun altındaki "Add Firebase to Google Cloud project" bağlantısına tıkla → 1.1'deki **NeuroPlan** projesini seç → **Continue**.
3. Faturalandırma planı sorulursa **Spark (ücretsiz)**. FCM ücretsiz.
4. Google Analytics: **kapat** → **Create project / Add Firebase** → **Continue**.

### 5.2 Android uygulaması ve `.env` değerleri
1. Proje ana sayfasında Android simgesine tıkla. Görünmüyorsa: sol üst dişli → **Project settings** → **General** → *Your apps* → **Add app → Android**.
2. *Android package name*: `com.mirhatuguzlu.neuroplan`. SHA-1 isteğe bağlı. **Register app**.
3. **Download google-services.json** → dosya İndirilenler'e iner. **Repoya kopyalama.** Uygulama bu dosya olmadan çalışır; yalnız içinden değer okuyacağız.
4. "Add Firebase SDK" adımlarını **atla**: **Next → Next → Continue to console**. Gradle eklentisi bilerek kullanılmıyor.
5. İndirilen dosyayı VS Code'da aç ve `.env`'e şu dört satırı ekle:
   ```
   FIREBASE_API_KEY=<client[0] → api_key[0] → current_key, "AIza" ile başlar>
   FIREBASE_APP_ID=<client[0] → client_info → mobilesdk_app_id, "1:...:android:..." biçiminde>
   FIREBASE_SENDER_ID=<project_info → project_number, yalnız rakam>
   FIREBASE_PROJECT_ID=<project_info → project_id>
   ```
   Bunlar istemcide zaten açık kimliklerdir, gizli değil. Sonra `google-services.json`'u silebilirsin.

### 5.3 Cloud Messaging API
- **Project settings → Cloud Messaging** sekmesi.
- *Firebase Cloud Messaging API (V1)* "Enabled" olmalı.
- Değilse yanındaki **⋮ → Manage API in Google Cloud Console → ENABLE**.
- "Legacy API" kapalı kalabilir.

### 5.4 Servis hesabı anahtarı (gizli)
1. **Project settings → Service accounts** sekmesi → *Firebase Admin SDK* → **Generate new private key** → **Generate key**.
2. Bir `.json` dosyası iner. Bu dosya **gizlidir**: Firebase projene tam yetki verir.
3. Repo klasörüne koyma. Adım 6'dan sonra sil.

### 5.5 Paylaşılan sır
Veritabanı push fonksiyonunu çağırırken bu sırrı gösterir. Üret:
```bash
node -e "console.log(require('crypto').randomBytes(36).toString('base64url'))"
```
Çıkan 48 karakterlik değeri değer defterine kopyala. Bu değer hem 6.2'de `PUSH_WEBHOOK_SECRET`'a hem 7'de Vault'a girer; ikisi **aynı** olmalı.

---

## 6. Edge Functions ve sırlar

### 6.1 Sır dosyasını oluştur
```bash
copy supabase\functions\.env.example supabase\functions\.env.prod
```
`supabase/.gitignore` `functions/.env*` dosyalarını git'e sokmaz (örnek dosya hariç). Kontrol için `git status` çalıştır: `.env.prod` listede **görünmemeli**.

### 6.2 Doldur
`code supabase\functions\.env.prod` ile aç:
```
LIVEKIT_URL=<4.3'teki wss://... adresi>
LIVEKIT_API_KEY=<4.4 API Key>
LIVEKIT_API_SECRET=<4.4 API Secret>
PUSH_WEBHOOK_SECRET=<5.5'teki değer>
FIREBASE_SERVICE_ACCOUNT=<aşağıdaki tek satır>
```

**`FIREBASE_SERVICE_ACCOUNT` satırı**

JSON'un tamamı tek satırda olmalı. Elle birleştirme; şu komut dosyayı tek satıra çevirip panoya kopyalar (yolu kendi dosyanla değiştir):
```bash
node -e "process.stdout.write(JSON.stringify(require(process.argv[1])))" "C:\Users\<sen>\Downloads\neuroplan-xxxx-firebase-adminsdk-xxxx.json" | clip
```
Sonra `.env.prod`'daki `FIREBASE_SERVICE_ACCOUNT=` satırında eşittirden sonrasını sil ve Ctrl+V ile yapıştır.
- Satır `{"type":"service_account",` ile başlayıp `}` ile bitmeli.
- `private_key` içindeki `\n`'ler olduğu gibi kalır.

`SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY` yazma; Supabase bunları fonksiyonlara kendisi verir.

### 6.3 Sırları gönder
```bash
supabase secrets set --env-file supabase/functions/.env.prod
```
Bu sürümde `--project-ref` yoktur; komut bağlı projeye gider.

Kontrol:
```bash
supabase secrets list
```
Beş adın listelenmesi gerekir; değerler gösterilmez, yalnız özetleri gösterilir:
- `LIVEKIT_URL`, `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET`
- `PUSH_WEBHOOK_SECRET`
- `FIREBASE_SERVICE_ACCOUNT`

Ayrıca Supabase'in kendi `SUPABASE_*` adları da listede görünür.

### 6.4 Fonksiyonları yayınla
Docker Desktop açıksa olduğu gibi çalışır. Değilse her komutun sonuna `--use-api` ekle.
```bash
supabase functions deploy delete_account
```
```bash
supabase functions deploy voice_token
```
```bash
supabase functions deploy brain_snapshot
```
```bash
supabase functions deploy push_message --no-verify-jwt
```
`push_message` kullanıcı oturumunu değil 5.5'teki sırrı denetler. Bu yüzden `--no-verify-jwt` ile yayınlanır. Bu bayrak yalnız bu fonksiyonda kullanılır, diğer üçünde **kullanma**.

Kontrol: panoda **Edge Functions** → dördü listede.

### 6.5 Temizlik
- 5.4'teki servis hesabı JSON'unu İndirilenler'den sil.
- `.env.prod` bilgisayarında kalabilir (git'e girmez). Ama sırlar değişince yeniden `secrets set` yapman gerekir.

---

## 7. Push tetikleyicisinin Vault ayarı
Mesaj eklenince veritabanı push fonksiyonunu çağırır. Adresi ve sırrı Vault'tan okur.

1. Panoda **SQL Editor** → **+ New query**.
2. Şunu yapıştır ve `<REF>` ile sırrı değiştir. Sır, 5.5'teki ve `.env.prod`'daki değerin **aynısı** olmalı.
   ```sql
   select vault.create_secret('https://<REF>.supabase.co/functions/v1/push_message', 'push_function_url');
   select vault.create_secret('<5.5 PUSH_WEBHOOK_SECRET ile aynı değer>', 'push_webhook_secret');
   ```
3. **Run** (Ctrl+Enter).
   - SQL Editor yalnız **son** satırın sonucunu gösterir: tek bir kimlik (uuid) görürsün. Bu normaldir; iki kayıt da oluşmuştur.
   - Bu kimliği **saklaman gerekmez**. Kayıtlara her zaman adlarıyla ulaşılır.
4. Sorgu sekmesini kaydetme ya da kapattıktan sonra sil; sırrı içeriyor.

Aynı sorguyu ikinci kez çalıştırmak `duplicate key value violates unique constraint` hatası verir. Bunun anlamı "bu adla kayıt zaten var"; zararsızdır. Var olanı değiştirmek için aşağıdaki "Değiştirmek" bölümünü kullan.

Bu iki kayıt yoksa tetikleyici hiçbir şey yapmaz: mesajlar yine gider, yalnız push gelmez.

### 7.1 Kontrol
Bu sorgu sırrı ekrana tam yazmaz; yalnız ilk 4 karakterini ve uzunluğunu gösterir:
```sql
select name,
       case when name = 'push_function_url' then decrypted_secret
            else left(decrypted_secret, 4) || '…' end as deger,
       length(decrypted_secret) as uzunluk
from vault.decrypted_secrets
where name in ('push_function_url', 'push_webhook_secret');
```
Doğru sonuç iki satırdır:
- `push_function_url`: `https://<senin REF'in>.supabase.co/functions/v1/push_message`. İçinde `<REF>` yazısı **kalmamış** olmalı.
- `push_webhook_secret`: uzunluk **48**, ilk 4 karakter `.env.prod`'daki `PUSH_WEBHOOK_SECRET`'ın ilk 4 karakteriyle aynı.

### 7.2 Değiştirmek
Kontrolde bir satır yanlışsa düzelt. `update_secret` başarılı olunca **boş sonuç** döndürür; bu normaldir.
- **Komuttaki `<...>` kısmını, köşeli parantezler dahil, gerçek değerle değiştir.** `'<yeni>'` diye bırakırsan sır kelimenin tam olarak "<yeni>" olur ve push çalışmaz.
- Sır için: `.env.prod`'u aç ve `PUSH_WEBHOOK_SECRET=` satırında eşittirden sonrasını kopyala. Tırnak ve boşluk alma.
  ```sql
  select vault.update_secret((select id from vault.secrets where name = 'push_webhook_secret'), 'BURAYA_GERCEK_SIR');
  ```
- Adres için:
  ```sql
  select vault.update_secret((select id from vault.secrets where name = 'push_function_url'), 'https://GERCEK_REF.supabase.co/functions/v1/push_message');
  ```
- Sonra 7.1'i tekrar çalıştır.
- Sırrı tamamen yenilemek istersen (5.5'te yeni değer ürettiysen) iki yeri birlikte güncelle: önce `.env.prod`, sonra 6.3 (`secrets set`), en son yukarıdaki Vault komutu.

---

## 8. Web'den hesap silme sayfası (Play zorunluluğu)
Sayfa repoda: [docs/account-deletion/index.html](account-deletion/index.html). Üç yol gösterir:
- uygulamadan silme (her zaman),
- e-postayla istek (adres verilirse),
- sayfada Google ile giriş yapıp silme (Supabase ayarı verilirse).

### 8.1 Ayar dosyası
```bash
copy docs\account-deletion\config.example.js docs\account-deletion\config.js
```
`code docs\account-deletion\config.js` ile aç ve doldur:
- `contactEmail`: silme isteklerinin geleceği adres. **Mutlaka doldur**; Play bu yolu ister.
- `supabaseUrl` ve `supabaseKey`: yalnız "sayfadan sil" yolu için. `.env`'deki `SUPABASE_URL` ve `SUPABASE_ANON_KEY` ile aynı değerler.

### 8.2 Yayınlama kararı (senin)
`config.js` git-ignored. CLAUDE.md kural 7, Supabase değerlerini yalnız `.env`'de tutar. Seçenekler:
- **(a) GitHub Pages, en kolayı:**
  - Repo herkese açık, Pages ücretsiz.
  - Kök `.gitignore`'daki `docs/account-deletion/config.js` satırını sil ve `config.js`'i commit'le.
  - Publishable key herkese açık olacak şekilde tasarlanmıştır; güvenliği RLS sağlar.
  - Bunu seçersen DECISIONS'a bir satır düş.
- **(b) Elle yükleme:**
  - `config.js`'i commit'leme.
  - `docs/account-deletion/` klasörünü `config.js` ile birlikte [Netlify Drop](https://app.netlify.com/drop)'a sürükle-bırak; anında bir adres verir.
  - Bu durumda hukuk metinlerini de ayrıca yayımlaman gerekir.
- **(c) Yalnız e-posta yolu:**
  - `supabaseUrl` ve `supabaseKey`'i boş bırak.
  - Sayfa ayar olmadan da uygulama içi yolu gösterir. Ama e-posta yolu `config.js` ister; bu yüzden (a) ya da (b) yine gerekir.

### 8.3 GitHub Pages'i aç
1. [github.com/mirhatuguzlu/NeuroPlan](https://github.com/mirhatuguzlu/NeuroPlan) → **Settings** → soldan **Pages**.
2. *Build and deployment → Source*: **Deploy from a branch**.
3. *Branch*: `main`, klasör `/docs` → **Save**.
4. 1–3 dakika sonra sayfanın üstünde "Your site is live at `https://mirhatuguzlu.github.io/NeuroPlan/`" yazar. **Actions** sekmesinde "pages build and deployment" yeşil olmalı.
5. Adresler:
   - Silme: `https://mirhatuguzlu.github.io/NeuroPlan/account-deletion/`
   - Gizlilik: `https://mirhatuguzlu.github.io/NeuroPlan/legal/privacy_policy.html`
   - Topluluk kuralları: `.../legal/community_guidelines.html`
   - Çocuk güvenliği: `.../legal/child_safety_standards.html`
6. Not: `/docs` yayımlanınca diğer belgeler de (DECISIONS vb.) web'de okunur. Repo zaten herkese açık; yeni bir şey açığa çıkmaz.

### 8.4 Sonra
- "Sayfadan sil" kullanılacaksa 2.4'ü yap.
- 1.2'deki Branding'e dönüp gizlilik politikası adresini gir.

### 8.5 E-postayla gelen istek nasıl işlenir
1. Panoda **Authentication → Users** → arama kutusuna isteği gönderen e-postayı yaz.
2. Kullanıcı yoksa: "Bu adrese bağlı hesap bulunamadı" diye yanıtla.
3. Varsa: satırın sonundaki **⋮ → Delete user** → onayla. Tablolar cascade ile silinir (DB_SCHEMA §6.3).
4. 30 gün içinde yanıtla.

---

## 9. Moderasyon
1. Kendi kullanıcı kimliğini bul:
   - Uygulamada Google ile giriş yap.
   - Panoda **Authentication → Users** → kendi e-postanın satırına tıkla → **User UID**'i kopyala.
2. **SQL Editor → + New query**:
   ```sql
   insert into public.moderators (user_id) values ('<kopyaladığın-UID>');
   ```
   **Run**.
3. Kuyruğa bakmak:
   ```sql
   select * from moderation_queue;
   ```
   `child_safety` şikâyetleri en üstte gelir.
4. Karar vermek:
   ```sql
   select resolve_report('<şikâyet-id>', 'dismiss', 'kısa not');
   ```
   Seçenekler (SOCIAL_SAFETY §4.6): `dismiss` · `hide_message` · `suspend_7d` · `suspend_30d` · `ban`.
5. Haftada en az bir kez kuyruğa bak. Çocuk güvenliği şikâyetlerine aynı gün bak.
6. Hatırlamak için telefonuna haftalık bir hatırlatıcı kur.

---

## 10. Hukuk ve Play Console (yayından önce)

### 10.1 KVKK
Bu bölüm hukuki tavsiye değildir; avukatla birlikte yürüt.

**Yurt dışına aktarım (m. 9)**
- Veriler Türkiye dışındaki sunuculara gidiyor: Supabase (proje bölgesi AB olsa bile yurt dışı), LiveKit Cloud, Google Firebase.
- Kişisel Verileri Koruma Kurumu'nun yayımladığı **standart sözleşme** metni her sağlayıcıyla imzalanır.
- İmzadan itibaren **5 iş günü** içinde Kurum'a bildirilir. Güncel yöntem kvkk.gov.tr'deki "Standart Sözleşme" duyurusundadır: KEP, posta ya da elden.

**Sağlayıcı sözleşmeleri (DPA)** — indirip avukata ver:
- Supabase: **Organization settings → Legal Documents**.
- LiveKit: livekit.io → Legal → DPA.
- Google: Firebase Data Processing Terms.

**Diğer**
- VERBİS kaydı: çalışan sayısı ve bilanço eşiklerine göre muaf olabilirsin; avukatına sor.
- Gizlilik politikası ve aydınlatma metni: [docs/legal/privacy_policy.md](legal/privacy_policy.md) taslağı avukata kontrol ettir. Topluluk kuralları ve çocuk güvenliği metinleri de.
- Açık sorular (SOCIAL_SAFETY §7):
  - 5651 "sosyal ağ sağlayıcı" kapsamı,
  - 15–17 yaş için hukuki sebep,
  - yalnız beyana dayalı yaş doğrulaması.

### 10.2 Play Console
[play.google.com/console](https://play.google.com/console) → uygulama → soldan **Policy and programs → App content** (Türkçe: **Politika → Uygulama içeriği**). Her kartta **Start** / **Manage**:
- **Privacy policy:** 8.3'teki gizlilik adresi.
- **App access:**
  - "All or some functionality is restricted" → **Add instructions**.
  - Bir test Google hesabının e-postasını ve şifresini ver. Bu şifreyi Play formuna sen girersin.
  - Not ekle: "Sosyal sekmeyi görmek için kurulumda doğum yılı 18 yaş ve üstü seçin".
- **Target audience and content:** 13–15, 16–17 ve 18+ işaretli; 12 ve altı **işaretsiz** (Aileler programı dışı).
- **Content rating:** anketi doldur.
  - Kategori: Utility / Productivity.
  - "Kullanıcılar birbiriyle etkileşir ya da içerik paylaşır?" → **Evet**.
  - "Konum paylaşılır?" → **Hayır**.
- **Data safety:**
  - Toplanan veriler:
    - Ad (takma ad), e-posta (Google), kullanıcı kimlikleri
    - Mesajlar (kullanıcı içeriği)
    - Uygulama etkinliği (planlar, odak oturumları)
    - Yaklaşık konum (0,1°'ye yuvarlanmış, eşitleniyor)
    - Ses: sesli sohbette **aktarılır, saklanmaz**
  - Hepsi aktarımda şifreli.
  - Kullanıcı silme isteyebilir → 8.3'teki silme adresi.
- **Account deletion:** uygulama içi yol (Profil → Hesabı ve verileri sil) + 8.3 silme adresi.
- **Foreground service permissions:** iki tür beyan edilir:
  - `specialUse`: odak sayacı, kalan süre ve 10 sn dönüş uyarısı. Kısa bir ekran kaydı videosu yükle.
  - `microphone`: ortak odakta kullanıcının kendi açtığı sesli sohbet.
- **Child safety standards:**
  - Adres: `.../legal/child_safety_standards.html`.
  - Sorumlu kişi: ad + e-posta.
- **Kategori:** Productivity.

---

## 11. Doğrulama

**11.1 `.env` son hali** — yedi satır dolu olmalı:
- `SUPABASE_URL`, `SUPABASE_ANON_KEY`
- `GOOGLE_WEB_CLIENT_ID`
- `FIREBASE_API_KEY`, `FIREBASE_APP_ID`, `FIREBASE_SENDER_ID`, `FIREBASE_PROJECT_ID`

**11.2 İki cihaz**
1. Cihazları USB ile bağla. Geliştirici seçenekleri → USB hata ayıklama açık olsun.
2. Cihaz kimliklerini gör:
   ```bash
   flutter devices
   ```
3. İki ayrı terminalde (Terminal → New Terminal), her cihaz için birer kez:
   ```bash
   flutter run --dart-define-from-file=.env -d <cihaz-kimliği>
   ```
   İkinci cihaz USB ile bağlanamıyorsa: `flutter build apk --debug --dart-define-from-file=.env` ve `build\app\outputs\flutter-apk\app-debug.apk` dosyasını telefona kopyalayıp kur.
4. İki **farklı** Google hesabıyla giriş yap. "Testing" durumundaysa ikisi de 1.2'deki test kullanıcıları listesinde olmalı.

**11.3** [QA_CHECKLIST.md](QA_CHECKLIST.md) bölüm C'yi sırayla yap:
- C12: push bildirimi
- C13: web'den silme
- C14: bildirim izni ve uygulama içi Google girişi

**11.4 Sorun giderme**

| Belirti | Bak |
|---|---|
| Google hesap seçici açılıyor, seçince hata | 1.4 SHA-1 eksik ya da yanlış; 2.2 "Skip nonce checks" kapalı; `.env`'de Web değil Android istemci kimliği var |
| Hesap seçici hiç açılmıyor | `.env`'de `GOOGLE_WEB_CLIENT_ID` boş; uygulamayı `--dart-define-from-file=.env` ile çalıştırmadın |
| "Access blocked / app not verified" | 1.2 onay ekranı "Testing" ve hesap test kullanıcısı değil |
| Misafir oturumu açılmıyor | 2.2 "Allow anonymous sign-ins" kapalı ya da CAPTCHA açık |
| Birlikte sekmesi "sunucuya ulaşılamadı" | Adım 3 uygulanmadı; panoda **Logs → Postgres** |
| Sesli sohbet bağlanmıyor | 6.3 LiveKit sırları; panoda **Edge Functions → voice_token → Logs** |
| Push gelmiyor | Sırayla: telefonda bildirim izni (C14) → 5.2 `.env` değerleri → 7 Vault iki satır → 6.3'teki sır ile Vault'taki sır aynı mı → **Edge Functions → push_message → Logs** |
| Silme sayfasında "Google ile giriş" geri dönmüyor | 2.4 Redirect URL eksik |

**Telefon günlüğü:**
```bash
adb logcat | findstr /R "\[sync\] \[push\] \[voice\] \[auth\]"
```
Bash'te: `adb logcat | grep -E "\[sync\]|\[push\]|\[voice\]|\[auth\]"`.

Postgres hata kodları (NP001…NP429) SOCIAL_SAFETY'de açıklanır.
