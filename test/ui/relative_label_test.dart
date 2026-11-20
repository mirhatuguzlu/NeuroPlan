import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/ui/features/activity_wizard/draft.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'harness.dart';

/// Hata: "X başlamadan 30 dk önce" kurulan iş, X saatsizken Bugün'de "X sonrası"
/// diye görünüyordu; yön ve dakika etikete hiç yansımıyordu.
void main() {
  Future<Harness> pump(
    WidgetTester t, {
    required TimeType anchorTime,
    required bool afterEnd,
    int offset = 30,
  }) => pumpApp(
    t,
    seed: (c) async {
      final db = c.read(databaseProvider);
      final repo = c.read(activityRepositoryProvider);
      final cal = PlanCalendar('Europe/Istanbul');
      final x =
          await (ActivityDraft(testNow)
                ..title = 'Ders'
                ..time = anchorTime)
              .save(db, repo, cal);
      await (ActivityDraft(testNow)
            ..title = 'Hazırlık'
            ..time = TimeType.relative
            ..relActivity = x.id
            ..relAfterEnd = afterEnd
            ..relOffset = offset
            ..duration = 20)
          .save(db, repo, cal);
    },
  );

  for (final (afterEnd, offset, label) in [
    (false, 30, 'Ders başlamadan 30 dk önce'),
    (false, 0, 'Ders başlamadan önce'),
    (true, 30, 'Ders bitiminden 30 dk sonra'),
    (true, 0, 'Ders bitince'),
  ]) {
    testWidgets('çapa saatsiz: Bugün etiketi "$label"', (t) async {
      final h = await pump(
        t,
        anchorTime: TimeType.none,
        afterEnd: afterEnd,
        offset: offset,
      );
      h.read(routerProvider).go('/today');
      await h.settle();
      expect(find.text(label), findsOneWidget);
      expect(find.text('Ders sonrası'), findsNothing);

      // Plan → kurallar listesi aynı özeti gösterir.
      h.read(routerProvider).go('/plan');
      await h.settle();
      await h.tap(find.text('Kurallar'));
      expect(find.textContaining(label), findsOneWidget);
    });
  }

  testWidgets(
    'çapa süresiz saat aralığı: önceki iş aralığın 30 dk önce biter',
    (t) async {
      final h = await pump(t, anchorTime: TimeType.window, afterEnd: false);
      h.read(routerProvider).go('/plan');
      await h.settle();
      String? lead(String title) => [
        for (final e
            in find
                .ancestor(of: find.text(title), matching: find.byType(ListTile))
                .evaluate())
          ((e.widget as ListTile).leading! as Text).data,
      ][1]; // yarın: aralık 09:00'da başlar
      expect(lead('Ders'), '09:00');
      expect(lead('Hazırlık'), '08:10'); // 08:30'da biter, 20 dk
    },
  );
}
