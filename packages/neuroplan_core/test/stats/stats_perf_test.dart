// Performans: sahte veriyle 1 yıl; bütün analizler birlikte < 300 ms (Aşama 5 §5).
// Plan motorunun 1 yıllık koşusu ayrıca ölçülür (plan/performance_test.dart, ~0,5 sn);
// uygulama onu arka planda koşturup önbelleğe alır (D54).
@Tags(['perf'])
library;

import 'dart:math';

import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

void main() {
  final cal = PlanCalendar('Europe/Istanbul');
  final today = Day.parse('2026-11-20');
  final rnd = Random(7);
  const roots = [
    'body_movement',
    'motor_skill',
    'music_rhythm',
    'learning_memory',
    'planning_problem',
    'social_emotional',
    'attention_reflection',
    'creativity_art',
    'rest_sleep',
  ];
  final regions = [for (var i = 0; i < 24; i++) 'r$i'];
  const modes = ['free', 'pomodoro', 'deep'];
  const reasons = ['app_left', 'notification_shade', 'screen_off', 'other'];

  final sessions = <StatSession>[];
  final interruptions = <StatInterruption>[];
  final items = <StatPlanItem>[];
  final events = <BrainEventDraft>[];
  for (var d = today.add(-364); !d.isAfter(today); d = d.add(1)) {
    for (var k = 0; k < 4; k++) {
      final start = cal.wallToUtc(d, (7 + k * 3) * 60 + rnd.nextInt(60));
      final minutes = 20 + rnd.nextInt(70);
      final id = '${d.iso}-$k';
      sessions.add(
        StatSession(
          id: id,
          mode: modes[rnd.nextInt(3)],
          outcome: rnd.nextInt(10) == 0 ? 'broken' : 'completed',
          start: start,
          end: start + minutes,
          focusedSeconds: minutes * 60,
          rootKey: roots[rnd.nextInt(8)],
          categoryId: 'c${rnd.nextInt(30)}',
          activityId: 'a${rnd.nextInt(60)}',
          focusRating: 1 + rnd.nextInt(5),
          fatigueRating: 1 + rnd.nextInt(5),
        ),
      );
      for (var j = 0; j < rnd.nextInt(3); j++) {
        interruptions.add(
          StatInterruption(
            sessionId: id,
            at: start + 5 + j,
            reason: reasons[rnd.nextInt(4)],
            counted: true,
          ),
        );
      }
      for (var j = 0; j < 6; j++) {
        events.add(
          BrainEventDraft(
            type: j == 5 ? 'connection_gain' : 'neuron_gain',
            regionKey: regions[rnd.nextInt(regions.length)],
            regionBKey: j == 5 ? regions[rnd.nextInt(regions.length)] : null,
            amount: 500 + rnd.nextInt(3000),
            occurredAt: DateTime.fromMillisecondsSinceEpoch(
              (start + minutes) * 60000,
              isUtc: true,
            ),
            sessionId: id,
            dedupeKey: '$id-$j',
          ),
        );
      }
    }
    for (var j = 0; j < 20; j++) {
      items.add(
        StatPlanItem(
          activityId: 'a$j',
          day: d,
          status: const ['done', 'planned', 'skipped', 'moved'][rnd.nextInt(4)],
          minutes: 30,
          rootKey: roots[j % 9],
        ),
      );
    }
  }

  test('1 yıl, bütün analizler: ölçülür ve < 300 ms', () {
    // Isınma (JIT) ölçüme girmesin.
    timeByCategory(sessions, DayRange.of(StatPeriod.week, today), cal);
    final sw = Stopwatch()..start();
    for (final p in StatPeriod.values) {
      final r = DayRange.of(p, today, first: today.add(-364));
      final t = timeByCategory(sessions, r, cal);
      rollUp(t.byCategory, {
        for (var i = 0; i < 30; i++) 'c$i': i < 10 ? null : 'c${i % 10}',
      });
      adherence(items, r, today);
      focusHeat(sessions, r, cal).bestWindow();
      qualityTrend(sessions, r, cal);
      interruptionStats(interruptions, sessions, r, cal);
      compareModes(sessions, r, cal);
      brainGrowth(events, r, cal, regions);
      balance(t, roots);
    }
    streaks(sessions, cal, today);
    weeklyReport(sessions, items, today, cal);
    burndown(
      totalMinutes: 100000,
      start: today.add(-364),
      today: today,
      work: [
        for (final s in sessions) (day: cal.dayOf(s.end), minutes: s.minutes),
      ],
    );
    sw.stop();
    // ignore: avoid_print
    print(
      '1 yıl (${sessions.length} oturum, ${items.length} plan, '
      '${events.length} beyin olayı), 5 dönem: ${sw.elapsedMilliseconds} ms',
    );
    expect(sw.elapsedMilliseconds, lessThan(300));
  });
}
