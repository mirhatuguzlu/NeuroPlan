# NöroPlan (NeuroPlan)

**Hayatını kendi şablonunla planla, boş zamanını bul, odaklan — emeğinin 3D neon bir beyinde büyüdüğünü gör.**

NöroPlan; rutinlerini, işlerini ve projelerini esnek bir şablonla tanımladığın, zorunlu işlerden sonra kalan boş zamanı hesaplayıp projelerini bu boşluklara bölen ve odak oturumlarını bilimsel dayanaklı kategorilere göre 3D bir beyin üzerinde görselleştiren bir mobil uygulamadır.

> **Durum: Aşama 0 — zemin kuruldu.** Proje iskeleti, ürün gereksinimleri, UX kuralları ve bilimsel kaynaklar hazır. Uygulama özellikleri henüz yazılmadı; aşağıdaki özellikler **planlanan** kapsamdır.

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
| Arka uç | Supabase: Auth, Postgres, Row Level Security, Edge Functions |
| Veri | Önce cihazda (yerel SQLite), sonra Supabase'e eşitleme |
| 3D beyin | Uygulamaya gömülü WebView içinde yerel Three.js sahnesi |

Alınan her mimari karar tarihiyle kayıtlı: [docs/DECISIONS.md](docs/DECISIONS.md).

## Yol haritası
- [x] **Aşama 0** — Proje iskeleti, araçlar, ürün / UX / bilim belgeleri, Supabase altyapısı
- [ ] **Aşama 1** — Mimari ve klasör yapısı, yerel veritabanı, eşitleme stratejisi, tema / font / ikon kararları
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
flutter test
```

- Veritabanı değişiklikleri yalnız migration'larla yapılır: `supabase migration new <ad>` → `supabase/migrations/`.
- **Windows:** Proje yolunda Türkçe karakter veya boşluk olmasın (ör. `C:\dev\NeuroPlan`); Android Gradle eklentisi ASCII olmayan yolları reddeder.

## Proje yapısı
```
lib/                 Uygulama kodu (Aşama 1'de katmanlara ayrılacak)
test/                Testler
android/, ios/       Platform projeleri
supabase/            Supabase CLI yapılandırması ve migration'lar
docs/                Ürün, UX, bilim ve karar belgeleri
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
Henüz bir lisans seçilmedi; bu nedenle şimdilik tüm hakları saklıdır.

---

<a id="english"></a>
## English summary
**NeuroPlan** is a mobile planning and focus app (Flutter, Android first). You describe your life with a fully flexible template — routines, one-off tasks, deadlines, projects, free time, unplanned days. The app computes the free time left after your fixed commitments and splits your projects into those gaps. Focus sessions (free, Pomodoro or deep work) grow neurons in a 3D neon brain, mapped to nine science-based root categories. The brain is a visualization, not a measurement; every scientific claim is sourced in [docs/SCIENCE.md](docs/SCIENCE.md).

**Status:** Stage 0 — project foundation only (skeleton, product requirements, UX rules, science sources, Supabase setup). No app features yet. Stack: Flutter, Supabase (Auth, Postgres, RLS, Edge Functions), offline-first SQLite sync, embedded Three.js in a WebView. Languages: Turkish and English.
