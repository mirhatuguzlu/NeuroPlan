import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/auto_start.dart';
import 'package:neuroplan/app/next_up.dart';
import 'package:neuroplan/app/notifications.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/data/repositories/prefs_repository.dart';
import 'package:neuroplan/l10n/app_localizations.dart';
import 'package:neuroplan/ui/core/format.dart';
import 'package:neuroplan/ui/features/activity_wizard/draft.dart';
import 'package:neuroplan/ui/features/focus/focus_controller.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'harness.dart';

/// Saatinde otomatik başlat ve bitir (D63). Test saati 18 Kasım 10:00.
void main() {
  Future<Harness> pump(
    WidgetTester t, {
    int at = 10 * 60,
    bool focus = true,
    bool autoOff = false,
    List<(String, int, bool)> more = const [],
  }) => pumpApp(
    t,
    seed: (c) async {
      final db = c.read(databaseProvider);
      final repo = c.read(activityRepositoryProvider);
      final cal = PlanCalendar('Europe/Istanbul');
      for (final (title, start, needsFocus) in [('Ders', at, focus), ...more]) {
        await (ActivityDraft(testNow)
              ..title = title
              ..at = start
              ..duration = 30
              ..focus = needsFocus)
            .save(db, repo, cal);
      }
      if (autoOff) {
        await c.read(prefsRepositoryProvider).set(PrefsRepository.autoRun, '0');
      }
    },
  );

  testWidgets('odak işi saatinde başlar, bitişte tamamlanır', (t) async {
    final h = await pump(t);
    final s = h.read(focusControllerProvider);
    expect(s.active, isTrue);
    expect(s.title, 'Ders');
    expect(find.text('Bitir'), findsOneWidget); // odak ekranı

    Harness.focusNow = testNow.add(const Duration(minutes: 30));
    await t.pump(const Duration(minutes: 30));
    await h.settle();
    expect(h.read(focusControllerProvider).ended?.outcome, 'completed');
  });

  testWidgets('anahtar kapalıysa, odak istemeyen ya da geçmiş işte başlamaz', (
    t,
  ) async {
    for (final (autoOff, focus, at) in [
      (true, true, 10 * 60),
      (false, false, 10 * 60),
      (false, true, 9 * 60 + 50), // 10 dk önce başladı: pencere 5 dk
      (false, true, 10 * 60 + 30), // henüz değil
    ]) {
      final h = await pump(t, autoOff: autoOff, focus: focus, at: at);
      expect(
        h.read(focusControllerProvider).active,
        isFalse,
        reason: '$autoOff $focus $at',
      );
      await t.pumpWidget(const SizedBox());
    }
  });

  testWidgets('bildirime dokunuş: Bugün\'de iş açılır', (t) async {
    final h = await pump(t, at: 12 * 60, focus: false);
    final id = h.read(horizonProvider).value!.on('2026-11-18').single.id;
    expect(find.text('Bitti'), findsNothing);
    h.read(todayRevealProvider.notifier).show(id);
    await h.settle();
    expect(find.text('Bitti'), findsOneWidget);
    expect(h.read(todayRevealProvider), isNull);
  });

  testWidgets('bildirimler: hatırlatma, başlangıç ve "yaptın mı?"', (t) async {
    final h = await pump(
      t,
      at: 10 * 60 + 30,
      more: [('Yürüyüş', 12 * 60, false)],
    );
    final view = h.read(horizonProvider).value!;
    final cal = view.calendar;
    final today = cal.wallToUtc(Day.parse('2026-11-18'), 24 * 60);
    final next = NextUp(Notifications());
    final id = {
      for (final i in view.output.instances)
        if (i.date == '2026-11-18')
          view.data.activities[i.activityId]!.title: i.id,
    };
    List<String> of({int? lead, required bool auto}) => [
      for (final r in next.reminders(
        view,
        lookupL10n(const Locale('tr')),
        lead: lead,
        auto: auto,
      ))
        if (r.at < today)
          '${clockOfDayLocale('tr', cal.minuteOfDay(r.at))} ${r.title}: '
              '${r.body} [${r.payload}]',
    ];

    expect(of(lead: 10, auto: true), [
      '10:20 Ders: 10:30 · 10 dk sonra [open:${id['Ders']}]',
      '10:30 Ders: Odaklanma zamanı. Dokun, oturum başlasın. '
          '[focus:${id['Ders']}]',
      '11:50 Yürüyüş: 12:00 · 10 dk sonra [open:${id['Yürüyüş']}]',
      '12:00 Yürüyüş: Şimdi başlıyor · 12:00 [open:${id['Yürüyüş']}]',
      '12:30 Yürüyüş: Bitiş saati geldi. Yaptın mı? [open:${id['Yürüyüş']}]',
    ]);
    // Anahtar kapalı: yalnız hatırlatma; hatırlatma da kapalıysa hiç bildirim yok.
    expect(of(lead: 10, auto: false), hasLength(2));
    expect(of(auto: false), isEmpty);
    // 0 dk önce hatırlatma, başlangıç bildirimiyle çakışmaz.
    expect(of(lead: 0, auto: true), hasLength(3));
  });
}
