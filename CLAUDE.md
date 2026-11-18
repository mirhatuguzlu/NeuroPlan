# NöroPlan (NeuroPlan) — Proje Anayasası

Girişli SaaS planlama + odak uygulaması. Flutter (Android öncelikli, iOS sonra), Supabase, offline-first (yerel SQLite → Supabase eşitleme), 3D beyin WebView içinde yerel Three.js. Diller: Türkçe + İngilizce.
Ayrıntı her zaman `docs/` altında; bu dosya kısa kalır.

| Belge | İçerik |
|---|---|
| [docs/PRODUCT.md](docs/PRODUCT.md) | Ürün gereksinimleri (ne yapıyoruz) |
| [docs/UX_RULES.md](docs/UX_RULES.md) | UX anayasası (nasıl görünür ve davranır) |
| [docs/SCIENCE.md](docs/SCIENCE.md) | Kök kategoriler, beyin bölgeleri, kaynaklar, kanıt düzeyleri |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Katmanlar, offline-first eşitleme, plan/beyin motoru ilkeleri, WebView köprüsü |
| [docs/DB_SCHEMA.md](docs/DB_SCHEMA.md) | Veri modeli, RLS, senaryo testi |
| [docs/DECISIONS.md](docs/DECISIONS.md) | Tarihli mimari kararlar (her yeni karar buraya eklenir) |
| [docs/QA_CHECKLIST.md](docs/QA_CHECKLIST.md) | Gerçek cihaz manuel test listesi (odak algılama vb.) |

## Değişmez kurallar
1. **Her ekran tek bir amaç taşır.** Çok adımlı işler adım adım sihirbazla yapılır.
2. **Ortadaki pop-up ve alttan kayan kartlar sadece gerçekten gerektiğinde** kullanılır (ölçüt: UX_RULES.md §3).
3. **Boş ya da işlevsiz buton yok.** Her butonun bir eylemi ve yükleniyor / hata / boş durumu olur.
4. **Hiçbir kullanıcıya özel içerik koda sabit yazılmaz.** Rutin, iş, alt kategori, örnek etkinlik — hepsini kullanıcı oluşturur. Koddaki tek sabit içerik SCIENCE.md'deki kök kategorilerdir.
5. **Bilimsel iddia sadece docs/SCIENCE.md'deki kaynaklı satırlardan gelir.** Sol beyin / sağ beyin kişilik miti yasaktır.
6. **Her özellik bitince test yazılır; `flutter analyze` temiz olmadan commit yok.**
7. Gizli anahtar asla commit'lenmez. Supabase değerleri yalnız `.env`'de (git-ignored); `service_role` / secret key istemciye ve repoya hiç girmez. Güvenlik RLS ile sağlanır.
8. Kullanıcıya görünen her metin TR + EN yerelleştirme dosyasından gelir; koda sabit metin yazılmaz.
9. Mimari bir karar alındığında `docs/DECISIONS.md`'ye tarihli kayıt düşülür.
10. `README.md` uygulamayla birlikte güncellenir: her aşama ya da özellik bitince durum, özellikler ve yol haritası README'ye yansıtılır. README yalnız var olanı “var”, planlananı “planlanan” diye yazar.

## Komutlar
```bash
flutter analyze
flutter test
flutter run --dart-define-from-file=.env
supabase migration new <ad>   # migration'lar: supabase/migrations
```

## Flutter resmi AI kuralları
Kaynak: [flutter/agent-plugins/rules](https://github.com/flutter/agent-plugins/tree/main/rules) (docs.flutter.dev/ai/get-started'in yönlendirdiği resmi depo; 2026-11-18 itibarıyla tek kural: `flutter-hot-reload.md`). Yeni kural eklendiğinde buraya alınır.

**Proaktif Hot Reload** — `lib/` altındaki bir `.dart` dosyası düzenlendiğinde:
1. **Atla:** `lib/` dışındaki dosyalar (`test/`, `integration_test/`, `benchmark/`, `test_driver/`, `example/`) ve yalnızca yorum / doc / boşluk değişiklikleri için tetikleme.
2. **Bul ve bağlan:** Dart MCP sunucusunun `dtd` aracıyla (ya da `list_running_apps` / `vm_service`) çalışan uygulamayı bul.
3. **Tetikle:** Widget / `build` / basit metod değişikliğinde hemen `hot_reload`; temel mantık, state başlatma (`initState`), global/static state ya da `main()` değiştiyse `hot_restart`.

## Geliştirici ortamı
Skill ve plugin'ler kullanıcı (global) kapsamında kurulu; yeni makinede:
```bash
claude plugin marketplace add flutter/agent-plugins
claude plugin install dart-flutter@dart-flutter
claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill
claude plugin install ui-ux-pro-max@ui-ux-pro-max-skill
npx skills add dart-lang/skills --skill '*' -g --agent claude-code -y
npx skills add anthropics/skills --skill frontend-design -g --agent claude-code -y
npx impeccable install --providers=claude --global --no-hooks -y
```
Web odaklı skill'ler (frontend-design, ui-ux-pro-max, impeccable) **doğrudan uygulanmaz**; Flutter karşılıkları UX_RULES.md §1'de. impeccable “live mode” kullanılmaz.

- Proje yolu ASCII olmalı (`C:\dev\NeuroPlan`); Android Gradle eklentisi Windows'ta ASCII olmayan yolu reddeder.
- Gradle `Unable to establish loopback connection` verirse: `TEMP`/`TMP` 8.3 kısa yol (`DEVELO~1`) içeriyordur; uzun yola (ör. `C:\dev\tmp`) çevirip tekrar derle.
