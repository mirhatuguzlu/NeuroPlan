# NöroPlan (NeuroPlan)

**Hayatını kendi şablonunla planla, boş zamanını bul, odaklan — emeğinin 3D neon bir beyinde büyüdüğünü gör.**

NöroPlan; rutinlerini, işlerini ve projelerini esnek bir şablonla tanımladığın, zorunlu işlerden sonra kalan boş zamanı hesaplayıp projelerini bu boşluklara bölen ve odak oturumlarını bilimsel dayanaklı kategorilere göre 3D bir beyin üzerinde görselleştiren bir mobil uygulamadır.

> **Durum: Aşama 1 — mimari ve veritabanı hazır.** Mimari, veri modeli, Supabase şeması (RLS dahil), yerel veritabanı ve eşitleme kuyruğunun iskeleti yazıldı ve testlerle doğrulandı. Kullanıcı arayüzü henüz yok; aşağıdaki özellikler **planlanan** kapsamdır.

[English summary below](#english)

---

## Planlanan özellikler
- **Tamamen esnek yaşam şablonu** — Rutinler, tek seferlik işler, son tarihli görevler, projeler, serbest zamanlar ve plansız günler. Uygulama senin hayatın hakkında hiçbir şey varsaymaz; her şeyi sen oluşturursun.
- **Boş zaman hesaplama** — Zorunlu işler yerleşince kalan boşluklar bulunur; projeler bu boşluklara otomatik ya da elle bölünür.
- **Bilimsel kök kategoriler** — 9 sabit kök kategori (Bedensel Hareket, Öğrenme ve Bellek, Dinlenme ve Uyku…), altlarına sınırsız derinlikte kendi kategorilerin.
- **Odak oturumları** — Serbest, Pomodoro veya derin çalışma. Oturum sırasında uygulamadan çıkarsan 10 saniye içinde dönmen gerekir, yoksa oturum bozulur.
- **3D neon beyin** — Tamamlanan oturumlar, ilgili bölgelerde nöron ve bağlantı olarak büyür. İhmal edilen bölgeler söner ama silinmez.
- **Kişisel analiz** — Grafiklerle zaman dağılımı, planlanan ve gerçekleşen, hangi odak modunun sana daha iyi geldiği.
- **Temalar** — Ciddi, Eğlenceli, Genç, Kodcu ve daha fazlası.
- **Davetle sosyal** — Arkadaş ve partner yalnız davetle; kategori bazında görünürlük, canlı ortak odak oturumu, ortak boş zaman bulma, mesajlaşma, beyin karşılaştırma.
- **Türkçe ve İngilizce**, önce cihazda çalışan (offline-first) yapı.

Hedef kitle 13 yaş ve üstü. Ayrıntılar: [docs/PRODUCT.md](docs/PRODUCT.md).

## Bilime yaklaşım
- 3D beyin bir **metafordur, ölçüm değildir**. Uygulama “beynin büyüdü” demez; “bu bölgeyle ilişkilendirilen etkinliklere şu kadar zaman ayırdın” der.
- Her bilimsel ifade, hakemli bir kaynağa ve açıkça yazılmış bir kanıt düzeyine dayanır: [docs/SCIENCE.md](docs/SCIENCE.md).
- “Sol beyinli / sağ beyinli” kişilik miti kullanılmaz.

## Teknoloji
| Katman | Seçim |
|---|---|
| Uygulama | Flutter 3.50 (Dart 3.14) — önce Android, sonra iOS |
| Alan katmanı | Saf Dart paketi `packages/neuroplan_core` (Flutter'sız; plan motoru ve beyin hesabı burada yazılacak) |
| Arka uç | Supabase: Auth (Google + misafir), Postgres, Row Level Security, RPC, Edge Functions |
| Veri | Önce cihazda (Drift / SQLite); outbox kuyruğuyla Supabase'e eşitleme, çakışmada alan bazlı son yazan kazanır |
| Arayüz durumu ve gezinme | Riverpod, go_router (planlanan; ilk ekranlarla eklenecek) |
| 3D beyin | Uygulamaya gömülü WebView içinde yerel Three.js sahnesi (planlanan) |

Mimari: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) · Veri modeli: [docs/DB_SCHEMA.md](docs/DB_SCHEMA.md) · Tarihli kararlar: [docs/DECISIONS.md](docs/DECISIONS.md).

## Yol haritası
- [x] **Aşama 0** — Proje iskeleti, araçlar, ürün / UX / bilim belgeleri, Supabase altyapısı
- [x] **Aşama 1** — Mimari, veri modeli ve senaryo testi, Supabase migration'ları + RLS + sistem seed'i, Drift yerel veritabanı, eşitleme kuyruğu iskeleti, depolar ve testler
- [ ] Tema, font ve ikon kararları (font testi; tema aşamasında)
- [ ] Sonraki aşamalar [PRODUCT.md](docs/PRODUCT.md)'deki modüllere göre planlanacak

## Geliştirme ortamı
**Gerekenler:** Flutter 3.50+, Android SDK, Java 21, [Supabase CLI](https://supabase.com/docs/guides/cli).

```bash
git clone https://github.com/mirhatuguzlu/NeuroPlan.git
cd NeuroPlan
cp .env.example .env    # kendi Supabase URL'ni ve anon / publishable key'ini yaz
flutter pub get
flutter run --dart-define-from-file=.env
```

Kontroller:
```bash
flutter analyze
flutter test                                   # uygulama + veri katmanı
cd packages/neuroplan_core && dart test        # alan katmanı
dart run tool/gen_seed_sql.dart --check        # seed migration'ı system.json ile aynı mı
supabase start && supabase test db             # şema + RLS testleri (Docker gerekir)
```

- Veritabanı değişiklikleri yalnız migration'larla yapılır: `supabase migration new <ad>` → `supabase/migrations/`.
- Drift tabloları değişince kodu yeniden üret: `dart run build_runner build` (üretilen `*.g.dart` repoya girer).
- Sistem verisi (kök kategoriler, beyin bölgeleri, ağırlıklar) yalnız `assets/seed/system.json`'da düzenlenir; migration `dart run tool/gen_seed_sql.dart` ile üretilir.
- **Windows:** Proje yolunda Türkçe karakter veya boşluk olmasın (ör. `C:\dev\NeuroPlan`); Android Gradle eklentisi ASCII olmayan yolları reddeder.

## Proje yapısı
```
lib/data/                 Yerel veritabanı (Drift), eşitleme kuyruğu, depolar
lib/ui/                   Ekranlar (planlanan)
packages/neuroplan_core/  Saf Dart alan katmanı: tekrar/zaman kuralları, HLC, sistem verisi
assets/seed/system.json   Sistem verisinin tek kaynağı (SCIENCE.md'den)
tool/                     Yardımcı betikler (seed migration üretici)
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

---

<a id="english"></a>
## English summary
**NeuroPlan** is a mobile planning and focus app (Flutter, Android first). You describe your life with a fully flexible template — routines, one-off tasks, deadlines, projects, free time, unplanned days. The app computes the free time left after your fixed commitments and splits your projects into those gaps. Focus sessions (free, Pomodoro or deep work) grow neurons in a 3D neon brain, mapped to nine science-based root categories. The brain is a visualization, not a measurement; every scientific claim is sourced in [docs/SCIENCE.md](docs/SCIENCE.md).

**Status:** Stage 1 — architecture and database. Architecture, data model, Supabase schema with RLS, local Drift database and the sync-queue skeleton are written and tested; there is no user interface yet. Stack: Flutter, a pure-Dart domain package, Supabase (Google + guest auth, Postgres, RLS), offline-first Drift/SQLite with field-level last-writer-wins sync, embedded Three.js in a WebView (planned). Languages: Turkish and English. License: AGPL-3.0.
