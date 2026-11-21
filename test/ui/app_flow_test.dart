import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/data/local/app_database.dart';

import 'harness.dart';

/// Uçtan uca akışın ana bilgisayar sürümü (CI'da koşar); aynısı cihazda
/// integration_test/app_flow_test.dart'tadır (D60).
void main() {
  testWidgets('kurulum → aktivite → odak → beyin büyüdü', (t) async {
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
    await t.enterText(find.byType(TextFormField).first, 'Gitar');
    await h.settle();
    await h.tap(find.text('İleri'));
    await h.tap(find.text('Müzik ve Ritim'));
    await h.tap(find.text('İleri'));
    await h.tap(find.text('İleri')); // her gün
    // Saati olmayan odak işi Bugün'den "Şimdi başla" ile açılır (D66).
    await h.tap(find.text('Saat yok, gün içinde bir ara'));
    await h.tap(find.text('İleri'));
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
    await h.tap(find.text('Şimdi başla'));
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
}
