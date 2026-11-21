import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/auto_start.dart';
import 'package:neuroplan/app/next_up.dart';
import 'package:neuroplan/app/notifications.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/data/local/app_database.dart';
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
      (false, true, 9 * 60 + 20), // bitişi (09:50) geçti
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

  testWidgets(
    'kesin saatli işe geç katılım: geciken süre düşer, bitişte biter (D66)',
    (t) async {
      final h = await pump(t, at: 9 * 60 + 50);
      final s = h.read(focusControllerProvider);
      expect(s.active, isTrue);
      expect(s.session!.startedAt, testNow, reason: 'dönüş anında başlar');
      Harness.focusNow = testNow.add(const Duration(minutes: 20));
      await t.pump(const Duration(minutes: 20));
      await h.settle();
      final ended = h.read(focusControllerProvider).ended;
      expect(ended?.outcome, 'completed');
      final row = await t.runAsync(
        () => h.read(focusRepositoryProvider).find(ended!.id),
      );
      expect(row!.focusedSeconds, 20 * 60);
    },
  );

  testWidgets('hiç gelinmeyen kesin saatli odak işi bozulma sayılır (D66)', (
    t,
  ) async {
    final h = await pumpApp(
      t,
      seed: (c) async {
        final db = c.read(databaseProvider);
        await (ActivityDraft(testNow)
              ..title = 'Ders'
              ..at = 8 * 60
              ..duration = 30
              ..focus = true)
            .save(
              db,
              c.read(activityRepositoryProvider),
              PlanCalendar('Europe/Istanbul'),
            );
        await c
            .read(prefsRepositoryProvider)
            .set(PrefsRepository.focusMissedSince, '0');
      },
    );
    final sessions = await t.runAsync(
      () => h.read(focusRepositoryProvider).watchSessions().first,
    );
    expect(sessions, hasLength(1));
    expect(sessions!.single.outcome, 'broken');
    expect(sessions.single.focusedSeconds, 0);
    final i = h.read(horizonProvider).value!.on('2026-11-18').single;
    expect(i.status, InstanceStatus.failed);
    expect(h.read(focusControllerProvider).active, isFalse);
    expect(find.text('Kaçırıldı'), findsOneWidget);
  });

  testWidgets(
    'Bugün: odak işinde Bitti / Atla yok; saatsiz odak işi "Şimdi başla"',
    (t) async {
      final h = await pumpApp(
        t,
        seed: (c) async {
          await (ActivityDraft(testNow)
                ..title = 'Okuma'
                ..time = TimeType.none
                ..focus = true)
              .save(
                c.read(databaseProvider),
                c.read(activityRepositoryProvider),
                PlanCalendar('Europe/Istanbul'),
              );
        },
      );
      await h.tap(find.text('Okuma'));
      expect(find.text('Bitti'), findsNothing);
      expect(find.text('Atla'), findsNothing);
      await h.tap(find.text('Şimdi başla'));
      expect(h.read(focusControllerProvider).active, isTrue);
    },
  );

  testWidgets(
    'Pomodoro işi: tekrar süreyi belirler, planda molalarla, planlı oturum (D67)',
    (t) async {
      final h = await pumpApp(
        t,
        seed: (c) async {
          final d = ActivityDraft(testNow)
            ..title = 'Tez'
            ..at = 10 * 60
            ..focus = true
            ..setFocusMode('pomodoro')
            ..focusCycles = 4
            ..syncPomodoroDuration();
          await d.save(
            c.read(databaseProvider),
            c.read(activityRepositoryProvider),
            PlanCalendar('Europe/Istanbul'),
          );
        },
      );
      final view = h.read(horizonProvider).value!;
      final i = view.on('2026-11-18').single;
      expect(i.end! - i.start!, 4 * 25 + 3 * 5, reason: '10:00–11:55');
      final s = h.read(focusControllerProvider).clock!.settings;
      expect(s.mode, FocusMode.pomodoro);
      expect(
        (s.planned, s.target, s.blockCount, s.work, s.rest),
        (true, 100, 4, 25, 5),
      );
      expect(find.text('Odak · döngü 1/4'), findsOneWidget);
    },
  );

  /// 10:00'da 120 dk derin çalışma (50 / 10), 55. dakikada molada Bitir (D69).
  Future<(Harness, PlanInstance)> finishOnBreak(
    WidgetTester t,
    String option,
  ) async {
    final h = await pumpApp(
      t,
      seed: (c) =>
          (ActivityDraft(testNow)
                ..title = 'Tez'
                ..at = 10 * 60
                ..duration = 120
                ..focus = true
                ..setFocusMode('deep'))
              .save(
                c.read(databaseProvider),
                c.read(activityRepositoryProvider),
                PlanCalendar('Europe/Istanbul'),
              ),
    );
    expect(h.read(focusControllerProvider).active, isTrue);
    Harness.focusNow = testNow.add(const Duration(minutes: 55));
    await t.pump(const Duration(minutes: 55));
    await h.settle();
    expect(h.read(focusControllerProvider).clock!.phase, FocusPhase.onBreak);
    await h.tap(find.text('Bitir'));
    expect(
      find.text('Yaptığın kısım sayıldı. Kalan 70 dk nerede beklesin?'),
      findsOneWidget,
    );
    await h.tap(find.text(option));
    expect(h.read(focusControllerProvider).ended?.outcome, 'completed');
    final db = h.read(databaseProvider);
    final rest = await t.runAsync(
      () => (db.select(
        db.planInstances,
      )..where((p) => p.plannedMinutes.isNotNull())).getSingle(),
    );
    return (h, rest!);
  }

  testWidgets('molada Bitir → bugünün ilk boşluğu: kalan 70 dk ayrı satır', (
    t,
  ) async {
    final (h, rest) = await finishOnBreak(t, 'Bugün uygun bir boşlukta');
    // Mola 10:50–11:00: kalan en erken mola bitişinde başlar.
    final at = PlanCalendar('Europe/Istanbul')
        .wallToUtc(Day.parse('2026-11-18'), 11 * 60);
    expect(rest.plannedMinutes, 70);
    expect(
      rest.startAt,
      DateTime.fromMillisecondsSinceEpoch(at * 60000, isUtc: true),
    );
    // 70 dk = 50 + 20, arada 10 dk mola.
    expect(rest.endAt!.difference(rest.startAt!), const Duration(minutes: 80));
    final view = h.read(horizonProvider).value!;
    expect(view.byId[rest.parentInstanceId]!.status, InstanceStatus.done);
    expect(view.byId[rest.id]!.minutes, 70);
  });

  testWidgets('molada Bitir → saatsiz: kalan Bugün sayfasında bekler', (
    t,
  ) async {
    final (h, rest) = await finishOnBreak(t, 'Saatsiz beklesin (bugün)');
    expect(rest.startAt, isNull);
    final i = h.read(horizonProvider).value!.byId[rest.id]!;
    expect((i.isTimed, i.minutes, i.suggested), (false, 70, false));
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
          '[focus:${id['Ders']}@${cal.wallToUtc(Day.parse('2026-11-18'), 10 * 60 + 30)}]',
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
