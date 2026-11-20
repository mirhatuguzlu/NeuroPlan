import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show kProfileMode;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/data/local/app_database.dart';

import '../test/data/test_support.dart' show useSystemJson;
import '../test/ui/harness.dart';

/// Uçtan uca akış (D60): kurulum → aktivite ekle → odak → beyin büyüdü. Gerçek cihazda
/// koşar (`flutter test integration_test -d CIHAZ`); sayaç saati ve odak platformu
/// sahtedir ki uygulama sabitleme penceresi çıkmasın ve 10 dakika beklenmesin.
/// Aynı dosyadaki ikinci test kaydırma ve sekme geçişinin kare sürelerini ölçer
/// (`flutter drive` ile raporlanır; docs/PERFORMANCE.md).
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(
    () async =>
        useSystemJson(await rootBundle.loadString('assets/seed/system.json')),
  );

  // Profil derlemesinde (flutter drive) metin girişi test klavyesine düşmüyor; akış testi
  // hata ayıklama derlemesinde cihazda (flutter test integration_test) ve CI'da
  // ana bilgisayarda (test/ui/app_flow_test.dart) koşar. Profil koşusu yalnız ölçer.
  testWidgets('kurulum → aktivite → odak → beyin büyüdü', skip: kProfileMode, (
    t,
  ) async {
    final h = await pumpApp(
      t,
      onboarded: false,
      seed: (c) => c
          .read(profileRepositoryProvider)
          .update(const ProfilesCompanion(birthYear: Value(2000))),
    );

    // Kurulum: dil atlanır, yaş zorunlu, kalan adımlar atlanır.
    await h.tap(find.text('Şimdilik geç'));
    await h.tap(find.text('İleri'));
    while (find.text('Şimdilik geç').evaluate().isNotEmpty) {
      await h.tap(find.text('Şimdilik geç'));
    }
    expect(h.read(profileProvider).value?.onboardingCompletedAt, isNotNull);

    // Sihirbazla odak gerektiren günlük iş.
    await h.tap(find.byTooltip('Ekle'));
    // Profil derlemesinde klavye bağlantısı dokunmayla açılır.
    await t.tap(find.byType(TextFormField).first);
    await t.pump();
    await t.enterText(find.byType(TextFormField).first, 'Gitar');
    await h.settle();
    await h.tap(find.text('İleri'));
    // Gerçek ekran boyutunda liste tembel kurulur: görünene dek kaydır.
    await t.scrollUntilVisible(
      find.text('Müzik ve Ritim'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await h.tap(find.text('Müzik ve Ritim'));
    await h.tap(find.text('İleri'));
    await h.tap(find.text('İleri')); // her gün
    await h.tap(find.text('İleri')); // sabit saat
    await h.tap(find.text('Şimdilik geç')); // esneklik
    await h.tap(find.text('İleri')); // süre
    await h.tap(find.text('Şimdilik geç')); // varyant
    await h.tap(find.text('Evet')); // odak gerektirir
    await h.tap(find.text('İleri'));
    await h.tap(find.text('Kaydet'));
    expect(find.text('Gitar eklendi'), findsOneWidget);

    final before = await t.runAsync(
      () => h.read(brainRepositoryProvider).watchHistory().first,
    );

    // Odak: serbest mod, 10 dakika, bitir; puanlama adımları atlanır.
    h.read(routerProvider).go('/today');
    await h.settle();
    // Liste tembel kurulur: iş görünene dek kaydır.
    await t.scrollUntilVisible(
      find.text('Gitar').last,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await h.tap(find.text('Gitar').last);
    await h.tap(find.text('Odaklan'));
    await h.tap(find.text('Başla'));
    Harness.focusNow = Harness.focusNow.add(const Duration(minutes: 10));
    await t.pump(const Duration(seconds: 1));
    await h.tap(find.text('Bitir'));
    for (var i = 0; i < 3; i++) {
      await h.tap(find.text('Şimdilik geç'));
    }
    expect(
      find.text('Müzik ve Ritim ile ilişkilendirilen bölgelere 10 dk ayırdın.'),
      findsOneWidget,
    );
    await h.tap(find.text('Bitti'));

    // Beyin büyüdü: yeni kazanç olayları ve metin alternatifinde nöron.
    final after = await t.runAsync(
      () => h.read(brainRepositoryProvider).watchHistory().first,
    );
    expect(after!.events.length, greaterThan(before!.events.length));
    expect(after.events.any((e) => e.type == 'neuron_gain'), isTrue);
  });

  testWidgets('performans: sekmeler ve kaydırma', (t) async {
    final h = await pumpApp(t);
    // Kare süreleri motorun kendi ölçümüyle (FrameTiming; VM servisi gerekmez).
    // Anlamlı sayı yalnız profil derlemesinde: docs/PERFORMANCE.md.
    final frames = <FrameTiming>[];
    void collect(List<FrameTiming> f) => frames.addAll(f);
    SchedulerBinding.instance.addTimingsCallback(collect);
    for (final tab in ['Plan', 'Beyin', 'Birlikte', 'Profil', 'Bugün']) {
      await h.tap(find.text(tab).last);
    }
    h.read(routerProvider).go('/profile/stats/time');
    await h.settle();
    await t.fling(find.byType(Scrollable).first, const Offset(0, -600), 2000);
    await h.settle();
    SchedulerBinding.instance.removeTimingsCallback(collect);
    double ms(Duration d) => d.inMicroseconds / 1000;
    List<double> sorted(Iterable<double> x) => x.toList()..sort();
    final build = sorted(frames.map((f) => ms(f.buildDuration)));
    final raster = sorted(frames.map((f) => ms(f.rasterDuration)));
    double p(List<double> x, double q) =>
        x.isEmpty ? 0 : x[((x.length - 1) * q).round()];
    final summary = {
      'frames': frames.length,
      'build_p50': p(build, .5),
      'build_p90': p(build, .9),
      'build_max': p(build, 1),
      'raster_p50': p(raster, .5),
      'raster_p90': p(raster, .9),
      'raster_max': p(raster, 1),
      'over_16ms': frames.where((f) => ms(f.totalSpan) > 16.7).length,
    };
    binding.reportData = {'frames': summary};
    debugPrint('[perf] $summary');
  });
}
