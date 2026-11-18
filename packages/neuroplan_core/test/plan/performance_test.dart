// Performans: gerçekçi yükle 1 yıl; hedef bir hafta < 50 ms (Aşama 2 talimatı §3).
@Tags(['perf'])
library;

import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

import 'support.dart';

PlanInput _input(String from, String to) {
  const weekdays = RRuleRecurrence(
    dtstart: '2026-11-16',
    rrule: 'FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR',
  );
  final rules = <PlanRule>[
    rule(
      'r00',
      'sleep',
      daily('2026-11-01'),
      start: [atClock('23:00')],
      end: [atClock('07:00', dayOffset: 1)],
    ),
    rule(
      'r01',
      'work_am',
      weekdays,
      start: [atClock('09:00')],
      end: [atClock('12:00')],
    ),
    rule(
      'r02',
      'work_pm',
      weekdays,
      start: [atClock('13:00')],
      end: [atClock('17:00')],
    ),
    rule(
      'r03',
      'commute_in',
      const FollowRecurrence(),
      end: [rel(ConstraintOp.at, 'work_am', Edge.start)],
      minutes: 40,
    ),
    rule(
      'r04',
      'commute_out',
      const FollowRecurrence(),
      start: [rel(ConstraintOp.at, 'work_pm', Edge.end)],
      minutes: 40,
    ),
    rule(
      'r05',
      'lunch',
      weekdays,
      start: [clock(ConstraintOp.notBefore, '12:00')],
      end: [clock(ConstraintOp.notAfter, '13:00')],
      minutes: 45,
      flex: Flexibility.shiftable,
    ),
    rule(
      'r06',
      'gym',
      const RRuleRecurrence(
        dtstart: '2026-11-16',
        rrule: 'FREQ=WEEKLY;BYDAY=MO,WE,FR',
      ),
      start: [atClock('18:00')],
      minutes: 60,
      flex: Flexibility.shiftable,
    ),
    rule(
      'r07',
      'dinner',
      daily('2026-11-01'),
      start: [clock(ConstraintOp.notBefore, '18:30')],
      end: [clock(ConstraintOp.notAfter, '20:30')],
      minutes: 45,
      flex: Flexibility.shiftable,
    ),
    rule(
      'r08',
      'dishes',
      const FollowRecurrence(),
      start: [rel(ConstraintOp.notBefore, 'dinner', Edge.end)],
      minutes: 20,
      flex: Flexibility.shiftable,
    ),
    rule(
      'r09',
      'reading',
      const PerPeriodRecurrence(count: 3, unit: PeriodUnit.week),
      minutes: 30,
      flex: Flexibility.shiftable,
    ),
    rule(
      'r10',
      'run',
      const PerPeriodRecurrence(count: 2, unit: PeriodUnit.week),
      minutes: 45,
      flex: Flexibility.shiftable,
    ),
    rule(
      'r11',
      'shift',
      const CycleRecurrence(
        anchor: '2026-11-21',
        lengthDays: 14,
        onDays: [0, 7],
      ),
      start: [atClock('08:00')],
      minutes: 600,
    ),
    rule(
      'r12',
      'club',
      const RRuleRecurrence(
        dtstart: '2026-11-01',
        rrule: 'FREQ=MONTHLY;BYDAY=2TU',
      ),
      start: [atClock('19:00')],
      minutes: 90,
    ),
    rule(
      'r13',
      'doctor',
      const DatesRecurrence(['2026-12-03', '2027-02-11', '2027-06-17']),
      start: [atClock('15:00')],
      minutes: 60,
    ),
    for (final (i, p) in [
      AstroEvent.fajr,
      AstroEvent.dhuhr,
      AstroEvent.asr,
      AstroEvent.maghrib,
      AstroEvent.isha,
    ].indexed)
      rule(
        'r2$i',
        'prayer_$i',
        daily('2026-11-01'),
        start: [TimeConstraint(ConstraintOp.at, AstroRef(p))],
        minutes: 15,
      ),
    rule(
      'r30',
      'walk',
      daily('2026-11-01'),
      start: [
        const TimeConstraint(
          ConstraintOp.at,
          AstroRef(AstroEvent.sunset),
          offsetMinutes: -60,
        ),
      ],
      minutes: 30,
      flex: Flexibility.shiftable,
    ),
    rule(
      'r31',
      'match',
      const RRuleRecurrence(
        dtstart: '2026-11-21',
        rrule: 'FREQ=WEEKLY;BYDAY=SA',
      ),
      start: [atClock('20:00')],
      minutes: 120,
    ),
    rule(
      'r32',
      'brunch',
      const RRuleRecurrence(
        dtstart: '2026-11-21',
        rrule: 'FREQ=WEEKLY;BYDAY=SA,SU',
      ),
      start: [atClock('10:00')],
      minutes: 90,
      flex: Flexibility.shiftable,
    ),
    for (var i = 0; i < 8; i++)
      rule(
        'r4$i',
        'chore_$i',
        daily('2026-11-01'),
        minutes: 15,
        flex: i.isEven ? Flexibility.shiftable : Flexibility.optional,
      ),
  ];
  return PlanInput(
    settings: const PlanSettings(
      timezone: istanbul,
      latitude: 41.0,
      longitude: 29.0,
      prayerMethod: defaultPrayerMethod,
      dailyFocusCap: 240,
    ),
    from: from,
    to: to,
    asOf: at('2026-11-18', '08:00'),
    activities: [
      for (final id in {for (final r in rules) r.activityId})
        PlanActivity(id: id),
      const PlanActivity(id: 'p1'),
      const PlanActivity(id: 'p2'),
      const PlanActivity(id: 'p3'),
    ],
    rules: rules,
    variantGroups: const [
      PlanVariantGroup(id: 'g', activityId: 'match', defaultVariantId: 'no'),
    ],
    variants: const [
      PlanVariant(id: 'yes', groupId: 'g'),
      PlanVariant(id: 'no', groupId: 'g', cancelsOccurrence: true),
    ],
    projects: [
      for (final (id, deadline) in [
        ('p1', '2027-02-01'),
        ('p2', '2027-06-01'),
        ('p3', '2027-10-01'),
      ])
        PlanProject(
          activityId: id,
          totalMinutes: 3000,
          deadline: at(deadline, '00:00'),
          safetyMargin: 1440,
          preferredWindows: const [PreferredWindow(from: 20 * 60, to: 22 * 60)],
        ),
    ],
    dayOverrides: const [
      PlanDayOverride(
        recurrence: RRuleRecurrence(
          dtstart: '2026-11-22',
          rrule: 'FREQ=WEEKLY;BYDAY=SU',
        ),
        keep: DayKeep.fixedOnly,
      ),
    ],
  );
}

void main() {
  const engine = PlanEngine();

  test('1 yıllık aralık çalışır ve ölçülür', () {
    final sw = Stopwatch()..start();
    final out = engine.plan(_input('2026-11-18', '2027-11-17'));
    sw.stop();
    print(
      '1 yıl: ${sw.elapsedMilliseconds} ms, '
      '${out.instances.length} oluşum, ${out.proposals.length} proje parçası',
    );
    expect(out.instances.length, greaterThan(365 * 15)); // ~20 oluşum / gün
    expect(out.risks, isEmpty);
  });

  test('bir hafta < 50 ms (52 haftanın en kötüsü)', () {
    engine.plan(
      _input('2026-11-16', '2026-11-22'),
    ); // ısınma (JIT, saat dilimi verisi)
    var worst = 0;
    var total = 0;
    var start = Day.parse('2026-11-16');
    for (var w = 0; w < 52; w++, start = start.add(7)) {
      final sw = Stopwatch()..start();
      engine.plan(_input(start.iso, start.add(6).iso));
      sw.stop();
      worst = sw.elapsedMilliseconds > worst ? sw.elapsedMilliseconds : worst;
      total += sw.elapsedMilliseconds;
    }
    print(
      'hafta: ortalama ${(total / 52).toStringAsFixed(1)} ms, en kötü $worst ms',
    );
    expect(worst, lessThan(50));
  });
}
