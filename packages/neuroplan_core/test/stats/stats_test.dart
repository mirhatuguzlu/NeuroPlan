import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

final cal = PlanCalendar('Europe/Istanbul'); // UTC+3, yaz saati yok
final today = Day.parse('2026-11-20'); // cuma

/// [day] gününün yerel [hour]:[min] anı, UTC dakika.
int at(String day, int hour, [int min = 0]) =>
    cal.wallToUtc(Day.parse(day), hour * 60 + min);

StatSession ses(
  String id,
  String day, {
  int hour = 9,
  int minutes = 30,
  String mode = 'deep',
  String outcome = 'completed',
  String? root = 'learning_memory',
  String? category,
  int? focus,
  int? fatigue,
  String? activity,
}) {
  final start = at(day, hour);
  return StatSession(
    id: id,
    mode: mode,
    outcome: outcome,
    start: start,
    end: start + minutes,
    focusedSeconds: minutes * 60,
    rootKey: root,
    categoryId: category,
    activityId: activity,
    focusRating: focus,
    fatigueRating: fatigue,
  );
}

StatPlanItem item(String day, String status) =>
    StatPlanItem(activityId: 'a', day: Day.parse(day), status: status);

void main() {
  group('aralık ve kovalar', () {
    test('dönemler bugünle biter; tümü ilk veriden başlar', () {
      expect(
        DayRange.of(StatPeriod.week, today).toString(),
        '2026-11-14..2026-11-20',
      );
      expect(DayRange.of(StatPeriod.year, today).length, 365);
      expect(
        DayRange.of(StatPeriod.all, today, first: Day.parse('2025-01-02')).from,
        Day.parse('2025-01-02'),
      );
      // Veri yoksa ya da yeniyse en az bir hafta.
      expect(DayRange.of(StatPeriod.all, today).length, 7);
    });

    test('hafta pazartesi başlar', () {
      expect(DayRange.weekOf(today).toString(), '2026-11-16..2026-11-22');
      expect(
        DayRange.weekOf(today).previous.toString(),
        '2026-11-09..2026-11-15',
      );
    });

    test('ay kovaları takvim ayına oturur, uçlar kırpılır', () {
      final b = bucketsOf(
        DayRange(Day.parse('2026-01-15'), Day.parse('2026-03-10')),
        Granularity.month,
      );
      expect(b.map((r) => '$r'), [
        '2026-01-15..2026-01-31',
        '2026-02-01..2026-02-28',
        '2026-03-01..2026-03-10',
      ]);
      expect(bucketIndex(b, Day.parse('2026-02-14')), 1);
      expect(bucketIndex(b, Day.parse('2026-03-11')), isNull);
    });

    test('hafta kovaları pazar biter; kova çözünürlüğü aralığa göre', () {
      final r = DayRange.of(StatPeriod.quarter, today);
      final b = bucketsOf(r);
      expect(granularityFor(r), Granularity.week);
      expect(b.skip(1).every((x) => x.from.weekday == 1), isTrue);
      expect(b.last.to, today);
      expect(
        granularityFor(DayRange.of(StatPeriod.month, today)),
        Granularity.day,
      );
      expect(
        granularityFor(DayRange.of(StatPeriod.year, today)),
        Granularity.month,
      );
    });
  });

  group('1 · zaman dağılımı', () {
    test('kök ve kategori ayrı; bozulan oturumun süresi de sayılır', () {
      final t = timeByCategory(
        [
          ses('1', '2026-11-19', category: 'c1', minutes: 40),
          ses('2', '2026-11-19', outcome: 'broken', minutes: 20),
          ses('3', '2026-11-18', root: 'body_movement', minutes: 30),
          ses('4', '2026-10-01', minutes: 99), // aralık dışı
          ses('5', '2026-11-18', root: null, minutes: 10),
        ],
        DayRange.of(StatPeriod.week, today),
        cal,
      );
      expect(t.byRoot, {
        'learning_memory': 60,
        'body_movement': 30,
        noCategory: 10,
      });
      expect(t.byCategory, {'c1': 40});
      expect(t.rootOnly['learning_memory'], 20);
      expect(t.total, 100);
    });

    test('alt kategoriler üst düğüme toplanır; döngü takılmaz', () {
      final up = rollUp(
        {'kid': 10, 'mid': 5, 'top': 1, 'x': 3},
        {'kid': 'mid', 'mid': 'top', 'top': null, 'x': 'y', 'y': 'x'},
      );
      expect(up, {'kid': 10, 'mid': 15, 'top': 16, 'x': 3, 'y': 3});
    });
  });

  group('2 · plana uyum', () {
    test('iş sayısına göre; taşınan sayılmaz; bugün ve gelecek dışarıda', () {
      final a = adherence(
        [
          item('2026-11-18', 'done'),
          item('2026-11-18', 'planned'),
          item('2026-11-18', 'moved'),
          item('2026-11-19', 'done'),
          item('2026-11-19', 'skipped'),
          item('2026-11-20', 'planned'), // bugün
          item('2026-11-21', 'planned'), // yarın
        ],
        DayRange.of(StatPeriod.week, today),
        today,
      );
      expect(a.planned, 4);
      expect(a.done, 2);
      expect(a.percent, 50);
      expect(a.days.length, 6); // 14..19
      expect(a.days.last.percent, 50);
      expect(a.days.first.percent, isNull);
    });

    test('kovalar haftalık toplar', () {
      final a = adherence(
        [item('2026-09-01', 'done'), item('2026-09-02', 'planned')],
        DayRange.of(StatPeriod.quarter, today),
        today,
      );
      final b = a.buckets.firstWhere((x) => x.planned > 0);
      expect((b.planned, b.done), (2, 1));
    });
  });

  group('3 · ısı haritası', () {
    test('saat × gün ortalaması ve en iyi iki saatlik dilim', () {
      final h = focusHeat(
        [
          ses('1', '2026-11-16', hour: 7, focus: 5),
          ses('2', '2026-11-17', hour: 8, focus: 4),
          ses('3', '2026-11-18', hour: 7, focus: 5),
          ses('4', '2026-11-18', hour: 15, focus: 2),
          ses('5', '2026-11-19', hour: 15, focus: 3),
          ses('6', '2026-11-19', hour: 16, focus: 2),
          ses('7', '2026-11-19', hour: 20), // puansız
        ],
        DayRange.of(StatPeriod.week, today),
        cal,
      );
      expect(h.rated, 6);
      expect(h.average(1, 7), 5); // pazartesi 07
      expect(h.count(3, 7), 1);
      expect(h.average(1, 8), isNull);
      final best = h.bestWindow()!;
      expect((best.start, best.end), (7, 9));
      expect(best.average, closeTo(14 / 3, 1e-9));
    });

    test('yeterli oturum yoksa en iyi dilim yok', () {
      final h = focusHeat(
        [ses('1', '2026-11-16', hour: 7, focus: 5)],
        DayRange.of(StatPeriod.week, today),
        cal,
      );
      expect(h.bestWindow(), isNull);
    });
  });

  group('4 · seri', () {
    test('bugün oturum yoksa dünkü seri sürer; bozulan gün saymaz', () {
      final s = streaks(
        [
          ses('1', '2026-11-19'),
          ses('2', '2026-11-18'),
          ses('3', '2026-11-17'),
          ses('4', '2026-11-16', outcome: 'broken'),
          ses('5', '2026-11-10'),
          ses('6', '2026-11-11'),
          ses('7', '2026-11-12'),
          ses('8', '2026-11-13'),
        ],
        cal,
        today,
      );
      expect(s.current, 3);
      expect(s.longest, 4);
      expect(s.minutesByDay[Day.parse('2026-11-16')], isNull);
    });

    test('iki gün boşluk seriyi bitirir', () {
      expect(streaks([ses('1', '2026-11-18')], cal, today).current, 0);
      expect(streaks([ses('1', '2026-11-20')], cal, today).current, 1);
    });

    test('gece yarısını geçen oturum bittiği güne yazılır', () {
      final s = streaks(
        [ses('1', '2026-11-19', hour: 23, minutes: 90)],
        cal,
        today,
      );
      expect(s.minutesByDay.keys.single, today);
    });
  });

  group('5 · kalite eğilimi', () {
    test('kova ortalamaları ve yarılar arası fark', () {
      final q = qualityTrend(
        [
          ses('1', '2026-11-14', focus: 2, fatigue: 4),
          ses('2', '2026-11-14', focus: 4, fatigue: 2),
          ses('3', '2026-11-20', focus: 5),
        ],
        DayRange.of(StatPeriod.week, today),
        cal,
      );
      expect(q.length, 7);
      expect(q.first.focus, 3);
      expect(q.first.fatigue, 3);
      expect(q.first.count, 2);
      expect(q.last.fatigue, isNull);
      expect(halfDelta([for (final p in q) p.focus]), 2);
      expect(halfDelta([3]), isNull);
    });
  });

  group('6 · kesintiler', () {
    test('sebep, saat ve oturum başına', () {
      final i = interruptionStats(
        [
          StatInterruption(
            sessionId: '1',
            at: at('2026-11-19', 10, 5),
            reason: 'app_left',
            counted: true,
          ),
          StatInterruption(
            sessionId: '1',
            at: at('2026-11-19', 10, 20),
            reason: 'app_left',
            counted: true,
          ),
          StatInterruption(
            sessionId: '2',
            at: at('2026-11-18', 14),
            reason: 'phone_call',
            counted: false,
          ),
          StatInterruption(
            sessionId: '9',
            at: at('2026-10-01', 14),
            reason: 'other',
            counted: true,
          ),
        ],
        [ses('1', '2026-11-19', hour: 10), ses('2', '2026-11-18', hour: 14)],
        DayRange.of(StatPeriod.week, today),
        cal,
      );
      expect(i.total, 3);
      expect(i.byReason, {'app_left': 2, 'phone_call': 1});
      expect(i.topReason, 'app_left');
      expect(i.peakHour, 10);
      expect(i.perSession, 1.5);
    });
  });

  group('7 · mod karşılaştırması', () {
    List<StatSession> many(String mode, int n, int focus) => [
      for (var k = 0; k < n; k++)
        ses(
          '$mode$k',
          '2026-11-1${k % 9}',
          mode: mode,
          focus: focus,
          fatigue: 3,
          outcome: k == 0 ? 'broken' : 'completed',
        ),
    ];

    test('veri azsa eksik oturum sayısını söyler', () {
      final c = compareModes(
        [...many('pomodoro', 2, 4), ...many('deep', 6, 3)],
        DayRange.of(StatPeriod.month, today),
        cal,
      );
      expect(c.enough, isFalse);
      expect(c.pomodoroMissing, 3);
      expect(c.deepMissing, 0);
      expect(c.higherFocus, isNull);
    });

    test('yeterliyse ortalama ve tamamlanma oranı', () {
      final c = compareModes(
        [
          ...many('pomodoro', 5, 4),
          ...many('deep', 5, 3),
          ses('f', '2026-11-19', mode: 'free'),
        ],
        DayRange.of(StatPeriod.month, today),
        cal,
      );
      expect(c.enough, isTrue);
      expect(c.pomodoro.completionRate, 0.8);
      expect(c.deep.avgFocus, 3);
      expect(c.higherFocus, 'pomodoro');
    });
  });

  group('8 · beyin gelişimi', () {
    BrainEventDraft ev(String type, String region, int amount, String day) =>
        BrainEventDraft(
          type: type,
          regionKey: region,
          amount: amount,
          occurredAt: DateTime.fromMillisecondsSinceEpoch(
            at(day, 12) * 60000,
            isUtc: true,
          ),
          sessionId: 's',
          dedupeKey: '$type$region$day',
        );

    test('birikimli nöron, aralık kazancı ve bağlantılar', () {
      final g = brainGrowth(
        [
          ev('neuron_gain', 'hip', 5000, '2026-10-01'), // önceden
          ev('neuron_gain', 'hip', 2000, '2026-11-15'),
          ev('neuron_gain', 'pfc', 3000, '2026-11-19'),
          ev('penalty', 'pfc', 3000, '2026-11-19'), // nöron silmez
          ev('connection_gain', 'hip', 4000, '2026-11-19'),
          ev('neuron_gain', 'hip', 9000, '2026-11-25'), // gelecek
        ],
        DayRange.of(StatPeriod.week, today),
        cal,
        const ['hip', 'pfc', 'stn'],
      );
      expect(g.neurons['hip'], [5, 7, 7, 7, 7, 7, 7]);
      expect(g.neurons['pfc']!.last, 3);
      expect(g.gained, {'hip': 2, 'pfc': 3, 'stn': 0});
      expect(g.top(), ['pfc', 'hip']);
      expect(g.connectionsGained, 4);
    });

    test('sönme: bir yarılanmadan sonra', () {
      expect(isFading(10, 1000), isFalse);
      expect(isFading(10, 600), isTrue);
      expect(isFading(0, 250), isFalse);
    });
  });

  group('9 · burn-down', () {
    final start = Day.parse('2026-11-01');

    test('plan yetiyorsa son parçanın günü', () {
      final b = burndown(
        totalMinutes: 300,
        start: start,
        today: today,
        work: [(day: Day.parse('2026-11-10'), minutes: 100)],
        planned: [
          (day: today.add(3), minutes: 150),
          (day: today.add(1), minutes: 60),
          (day: today, minutes: 500), // bugün sayılmaz
        ],
      );
      expect(b.remaining, 200);
      expect(b.points.length, 20);
      expect(b.points[9].remaining, 200);
      expect(b.finish, today.add(3));
      expect(b.byPlan, isTrue);
      expect(b.onTime(today.add(2)), isFalse);
      expect(b.onTime(null), isTrue);
    });

    test('plan yetmezse son 14 günün temposu', () {
      final b = burndown(
        totalMinutes: 280,
        start: start,
        today: today,
        work: [(day: today.add(-1), minutes: 140)],
      );
      expect(b.pace, 10);
      expect(b.finish, today.add(14));
      expect(b.byPlan, isFalse);
    });

    test('tempo yoksa tahmin yok; bitmişse son çalışma günü', () {
      expect(
        burndown(totalMinutes: 60, start: start, today: today, work: []).finish,
        isNull,
      );
      final done = burndown(
        totalMinutes: 60,
        start: start,
        today: today,
        work: [(day: Day.parse('2026-11-05'), minutes: 90)],
      );
      expect((done.remaining, done.finish), (0, Day.parse('2026-11-05')));
    });
  });

  group('10 · uyku', () {
    test('ortalama, hedef farkı ve 7 saat notu', () {
      final s = sleepStats(
        [
          (day: Day.parse('2026-11-18'), minutes: 390),
          (day: Day.parse('2026-11-19'), minutes: 420),
          (day: Day.parse('2026-10-01'), minutes: 600),
        ],
        DayRange.of(StatPeriod.week, today),
        null,
      );
      expect(s.average, 405);
      expect(s.goal, 480);
      expect(s.difference, -75);
      expect(s.belowNotice, isTrue);
      expect(
        sleepStats(
          const [],
          DayRange.of(StatPeriod.week, today),
          420,
        ).belowNotice,
        isFalse,
      );
    });
  });

  group('11 · denge', () {
    test('ihmal edilen kökler, uyku hariç', () {
      final b = balance(
        const CategoryTime(
          {'learning_memory': 30, 'body_movement': 10},
          {},
          {},
        ),
        const [
          'body_movement',
          'learning_memory',
          'creativity_art',
          'rest_sleep',
        ],
      );
      expect(b.neglected, ['creativity_art']);
      expect(b.share('learning_memory'), 0.75);
      expect(b.minutes['creativity_art'], 0);
    });
  });

  group('12 · haftalık rapor', () {
    test('bu hafta ve geçen hafta', () {
      final r = weeklyReport(
        [
          ses('1', '2026-11-17', focus: 4, minutes: 50),
          ses('2', '2026-11-18', root: 'body_movement', minutes: 20),
          ses('3', '2026-11-18', outcome: 'broken', minutes: 10),
          ses('4', '2026-11-10', minutes: 25),
        ],
        [item('2026-11-17', 'done'), item('2026-11-18', 'planned')],
        today,
        cal,
      );
      expect(r.current.focusMinutes, 80);
      expect(r.current.completedSessions, 2);
      expect(r.current.activeDays, 2);
      expect(r.current.adherencePercent, 50);
      expect(r.current.avgFocus, 4);
      expect(r.current.topRoot, 'learning_memory');
      expect(r.previous.focusMinutes, 25);
      expect(r.previous.adherencePercent, isNull);
    });
  });
}
