// docs/DB_SCHEMA.md §8 senaryoları (S1–S9), plan motoru üzerinden.
import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  test('S1: gün doğumundan 40 dk önce kalkış, en geç 00:00 yatış', () {
    const settings = PlanSettings(
      timezone: istanbul,
      latitude: 41.0,
      longitude: 29.0,
    );
    PlanRule sleep({int? minutes}) => rule(
      'R_UYKU',
      'UYKU',
      daily('2026-11-18'),
      start: [clock(ConstraintOp.notAfter, '00:00', dayOffset: 1)],
      end: [
        const TimeConstraint(
          ConstraintOp.at,
          AstroRef(AstroEvent.sunrise, dayOffset: 1),
          offsetMinutes: -40,
        ),
      ],
      minutes: minutes,
    );
    final sunrise = AstroClock(
      latitude: 41.0,
      longitude: 29.0,
    ).at(AstroEvent.sunrise, Day.parse('2026-11-19'))!;
    // UTC+3 sabit (2016'dan beri): kasımda İstanbul'da gün 07:50 civarı doğar.
    expect(
      ist.minuteOfDay(sunrise),
      inInclusiveRange(7 * 60 + 30, 8 * 60 + 30),
    );

    final out = plan(
      from: '2026-11-18',
      rules: [sleep(minutes: 450)],
      settings: settings,
    );
    final s = out.one('UYKU', '2026-11-18');
    expect(s.end, sunrise - 40);
    expect(s.start, sunrise - 40 - 450);
    expect(s.start, lessThanOrEqualTo(at('2026-11-19', '00:00')));

    // Süre yoksa en geç izinli an (00:00).
    final noDuration = plan(
      from: '2026-11-18',
      rules: [sleep()],
      settings: settings,
    ).one('UYKU', '2026-11-18');
    expect(noDuration.start, at('2026-11-19', '00:00'));
    expect(noDuration.end, sunrise - 40);
  });

  group('S2: pazartesi 12:00 çıkış, 13:00 ders, arada yol', () {
    final rules = [
      rule(
        'R_DERS',
        'DERS',
        const RRuleRecurrence(
          dtstart: '2026-11-23',
          rrule: 'FREQ=WEEKLY;BYDAY=MO',
        ),
        start: [atClock('13:00')],
        minutes: 90,
        exceptions: ['2026-11-30'],
      ),
      rule(
        'R_YOL',
        'YOL',
        const FollowRecurrence(),
        start: [atClock('12:00')],
        end: [rel(ConstraintOp.at, 'DERS', Edge.start)],
      ),
    ];

    test('her pazartesi 12:00–13:00 yol, 13:00–14:30 ders', () {
      final out = plan(from: '2026-11-23', to: '2026-11-29', rules: rules);
      expect(out.span('YOL'), '12:00–13:00');
      expect(out.span('DERS'), '13:00–14:30');
      expect(out.one('YOL').parentInstanceId, out.one('DERS').id);
      expect(out.one('DERS').id, ruleInstanceId('R_DERS', '2026-11-23'));
    });

    test('ders iptal edilen pazartesi yol da oluşmaz', () {
      final out = plan(from: '2026-11-30', rules: rules);
      expect(out.instances, isEmpty);
    });
  });

  test('S3: 14 günlük döngüde değişen günlerde 24 saatlik nöbet', () {
    final out = plan(
      from: '2026-11-23',
      to: '2026-12-06',
      rules: [
        rule(
          'R_NOBET',
          'NOBET',
          const CycleRecurrence(
            anchor: '2026-11-23',
            lengthDays: 14,
            onDays: [0, 3, 8, 11, 13],
          ),
          start: [atClock('08:00')],
          minutes: 1440,
        ),
      ],
    );
    expect(
      [for (final i in out.of('NOBET')) i.date],
      ['2026-11-23', '2026-11-26', '2026-12-01', '2026-12-04', '2026-12-06'],
    );
    final first = out.one('NOBET', '2026-11-23');
    expect(first.end, at('2026-11-24', '08:00'));
    // Ertesi günün boş zamanı nöbet bitince başlar.
    expect(out.freeOf('2026-11-24'), ['08:00–00:00']);
  });

  group('S4: "maç var" / "maç yok" varyantları', () {
    final rules = [
      rule(
        'R_MAC',
        'MAC',
        const RRuleRecurrence(
          dtstart: '2026-11-21',
          rrule: 'FREQ=WEEKLY;BYDAY=SA',
        ),
        start: [atClock('20:00')],
        minutes: 120,
      ),
      rule(
        'R_MACYOL',
        'MACYOL',
        const FollowRecurrence(),
        end: [rel(ConstraintOp.at, 'MAC', Edge.start)],
        minutes: 30,
      ),
    ];
    const activities = [
      PlanActivity(id: 'MAC'),
      PlanActivity(id: 'MACYOL', variantId: 'V_VAR'),
    ];
    const groups = [
      PlanVariantGroup(id: 'G', activityId: 'MAC', defaultVariantId: 'V_YOK'),
    ];
    const variants = [
      PlanVariant(id: 'V_VAR', groupId: 'G'),
      PlanVariant(id: 'V_YOK', groupId: 'G', cancelsOccurrence: true),
    ];
    final macId = ruleInstanceId('R_MAC', '2026-11-21');

    test('varsayılan "maç yok": akşam boş, seçim yine sunulur', () {
      final out = plan(
        from: '2026-11-21',
        rules: rules,
        activities: activities,
        groups: groups,
        variants: variants,
      );
      expect(out.instances, isEmpty);
      final choice = out.variantChoices.single;
      expect(choice.instanceId, macId);
      expect(choice.selectedVariantId, 'V_YOK');
      expect(choice.explicit, isFalse);
      expect(out.freeOf('2026-11-21'), ['00:00–00:00']);
    });

    test('"maç var" seçilince maç ve maça yol oluşur', () {
      final out = plan(
        from: '2026-11-21',
        rules: rules,
        activities: activities,
        groups: groups,
        variants: variants,
        instances: [
          PersistedInstance(
            id: macId,
            activityId: 'MAC',
            ruleId: 'R_MAC',
            date: '2026-11-21',
            variantId: 'V_VAR',
          ),
        ],
      );
      expect(out.span('MAC'), '20:00–22:00');
      expect(out.span('MACYOL'), '19:30–20:00');
      expect(out.one('MACYOL').parentInstanceId, macId);
      expect(out.variantChoices.single.explicit, isTrue);
    });

    test('varyant istemeyen kullanıcıda aktivite olduğu gibi oluşur', () {
      final out = plan(from: '2026-11-21', rules: [rules.first]);
      expect(out.span('MAC'), '20:00–22:00');
      expect(out.variantChoices, isEmpty);
    });
  });

  group('S5: saatsiz "bu hafta 3 kez koş"', () {
    final kosu = rule(
      'R_KOSU',
      'KOSU',
      const PerPeriodRecurrence(count: 3, unit: PeriodUnit.week),
      flex: Flexibility.shiftable,
      validFrom: '2026-11-16',
      validUntil: '2026-11-22',
    );

    test('boş zamanı en çok olan günlere dağılır, eşitlikte erken gün', () {
      final out = plan(
        from: '2026-11-16',
        to: '2026-11-22',
        asOf: '2026-11-18T08:00',
        rules: [kosu],
      );
      expect(
        [for (final i in out.of('KOSU')) i.date],
        ['2026-11-19', '2026-11-20', '2026-11-21'],
      );
      expect(out.of('KOSU').every((i) => !i.isTimed), isTrue);
    });

    test('yalnız bugünü isteyen ekran da aynı dağılımı görür', () {
      final week = plan(
        from: '2026-11-16',
        to: '2026-11-22',
        asOf: '2026-11-18T08:00',
        rules: [kosu],
      );
      final day = plan(
        from: '2026-11-20',
        asOf: '2026-11-18T08:00',
        rules: [kosu],
      );
      expect(day.one('KOSU').id, week.one('KOSU', '2026-11-20').id);
    });

    test('yapılan oluşum sayılır, kalan 2 oluşum dağılır', () {
      final out = plan(
        from: '2026-11-16',
        to: '2026-11-22',
        asOf: '2026-11-18T08:00',
        rules: [kosu],
        instances: [
          PersistedInstance(
            id: perPeriodInstanceId('R_KOSU', '2026-11-16', 0),
            activityId: 'KOSU',
            ruleId: 'R_KOSU',
            date: '2026-11-18',
            status: InstanceStatus.done,
          ),
        ],
      );
      expect(
        [for (final i in out.of('KOSU')) (i.date, i.status)],
        [
          ('2026-11-18', InstanceStatus.done),
          ('2026-11-19', InstanceStatus.planned),
          ('2026-11-20', InstanceStatus.planned),
        ],
      );
    });

    test('süre girilirse boşluğa saat önerilir', () {
      final out = plan(
        from: '2026-11-19',
        asOf: '2026-11-18T08:00',
        rules: [
          rule(
            'R_KOSU',
            'KOSU',
            const PerPeriodRecurrence(count: 1, unit: PeriodUnit.day),
            flex: Flexibility.shiftable,
            minutes: 40,
          ),
          rule(
            'R_IS',
            'IS',
            daily('2026-11-01'),
            start: [atClock('00:00')],
            end: [atClock('09:00')],
          ),
        ],
      );
      final k = out.one('KOSU');
      expect(out.span('KOSU'), '09:00–09:40');
      expect(k.suggested, isTrue);
    });
  });

  group('S6: 26 Kasım\'a kadar 10 saatlik ödev', () {
    final deadline = at('2026-11-26', '23:59');
    PlanProject odev({List<PreferredWindow> windows = const []}) => PlanProject(
      activityId: 'ODEV',
      totalMinutes: 600,
      deadline: deadline,
      minChunk: 30,
      maxChunk: 120,
      dailyCap: 180,
      safetyMargin: 1440,
      preferredWindows: windows,
    );

    test('parçalar 30–120 dk, günde en çok 180 dk, güvenlik payı korunur', () {
      final out = plan(
        from: '2026-11-18',
        to: '2026-11-26',
        asOf: '2026-11-18T08:00',
        projects: [odev()],
      );
      expect(out.risks, isEmpty);
      expect(out.proposals.fold(0, (s, p) => s + p.minutes), 600);
      final byDay = <String, int>{};
      for (final p in out.proposals) {
        expect(p.minutes, inInclusiveRange(30, 120));
        expect(p.end, lessThanOrEqualTo(deadline - 1440));
        expect(p.start, greaterThanOrEqualTo(at('2026-11-18', '08:00')));
        byDay[p.date] = (byDay[p.date] ?? 0) + p.minutes;
      }
      expect(byDay.values.every((m) => m <= 180), isTrue);
    });

    test('dolu günlerde son parça güvenlik payından önceki son güne (25 Kasım) düşer', () {
      // 18–24 Kasım her gün 23:00'e kadar dolu (günde 60 dk boş); 25 Kasım boş.
      final out = plan(
        from: '2026-11-18',
        to: '2026-11-26',
        asOf: '2026-11-18T00:00',
        rules: [
          rule(
            'R_IS',
            'IS',
            daily('2026-11-18'),
            start: [atClock('00:00')],
            end: [atClock('23:00')],
            validUntil: '2026-11-24',
          ),
        ],
        projects: [odev()],
      );
      expect(out.risks, isEmpty);
      expect(out.proposals.last.date, '2026-11-25');
      expect(out.proposals.length, 9);
      expect(out.proposals.every((p) => p.date != '2026-11-26'), isTrue);
    });

    test('tercih edilen pencere önce doldurulur', () {
      final out = plan(
        from: '2026-11-18',
        to: '2026-11-26',
        asOf: '2026-11-18T00:00',
        projects: [
          odev(
            windows: [const PreferredWindow(from: 19 * 60, to: 21 * 60)],
          ),
        ],
      );
      expect(hm(out.proposals.first.start), '19:00');
      expect(out.proposals.where((p) => hm(p.start) == '19:00'), hasLength(5));
    });

    test('onaylanan ve yapılan parçalar kalan süreden düşer', () {
      final out = plan(
        from: '2026-11-18',
        to: '2026-11-26',
        asOf: '2026-11-18T08:00',
        projects: [odev()],
        instances: [
          PersistedInstance(
            id: 'P1',
            activityId: 'ODEV',
            date: '2026-11-17',
            start: at('2026-11-17', '10:00'),
            end: at('2026-11-17', '12:00'),
            status: InstanceStatus.done,
            source: InstanceSource.auto,
          ),
          PersistedInstance(
            id: 'P2',
            activityId: 'ODEV',
            date: '2026-11-18',
            start: at('2026-11-18', '10:00'),
            end: at('2026-11-18', '12:00'),
            source: InstanceSource.auto,
          ),
        ],
      );
      expect(out.proposals.fold(0, (s, p) => s + p.minutes), 360);
      // Onaylı parçanın olduğu gün günlük sınır 60 dk kaldı.
      expect(
        out.proposals
            .where((p) => p.date == '2026-11-18')
            .fold(0, (s, p) => s + p.minutes),
        60,
      );
    });
  });

  test('S7: pazarlar plansız, kesin işler kalır', () {
    final out = plan(
      from: '2026-11-22',
      to: '2026-11-23',
      rules: [
        rule(
          'R_UYKU',
          'UYKU',
          daily('2026-11-01'),
          start: [atClock('23:00')],
          end: [atClock('07:00', dayOffset: 1)],
        ),
        rule(
          'R_OKU',
          'OKU',
          daily('2026-11-01'),
          start: [atClock('10:00')],
          minutes: 60,
          flex: Flexibility.shiftable,
        ),
      ],
      projects: [
        PlanProject(
          activityId: 'ODEV',
          totalMinutes: 120,
          deadline: at('2026-11-30', '00:00'),
        ),
      ],
      overrides: [
        const PlanDayOverride(
          recurrence: RRuleRecurrence(
            dtstart: '2026-11-22',
            rrule: 'FREQ=WEEKLY;BYDAY=SU',
          ),
          keep: DayKeep.fixedOnly,
        ),
      ],
    );
    expect(out.of('OKU', '2026-11-22'), isEmpty);
    expect(out.of('UYKU', '2026-11-22'), hasLength(1));
    expect(out.unplannedDays, {'2026-11-22'});
    expect(out.freeSlots.containsKey('2026-11-22'), isFalse);
    expect(out.proposals.every((p) => p.date != '2026-11-22'), isTrue);
    // Pazar gecesi başlayan uyku pazartesi sabahını doldurur; proje ona dokunmaz.
    expect(out.one('UYKU', '2026-11-22').end, at('2026-11-23', '07:00'));
    expect(hm(out.proposals.first.start), '07:00');
    expect(out.span('OKU', '2026-11-23'), '10:00–11:00');
  });

  test('S8: doğrudan kök kategoriye bağlı, saatsiz tek seferlik iş', () {
    final out = plan(
      from: '2026-11-19',
      rules: [
        rule(
          'R_ANNE',
          'ANNE',
          const OnceRecurrence('2026-11-19'),
          flex: Flexibility.shiftable,
        ),
      ],
    );
    final i = out.one('ANNE');
    expect(i.isTimed, isFalse);
    expect(i.id, ruleInstanceId('R_ANNE', '2026-11-19'));
    expect(out.freeOf('2026-11-19'), ['00:00–00:00']);
  });

  group('S9: akşam yemeğinden sonra bulaşık', () {
    final yemek = rule(
      'R_YEMEK',
      'YEMEK',
      daily('2026-11-18'),
      start: [clock(ConstraintOp.notBefore, '18:30')],
      end: [clock(ConstraintOp.notAfter, '20:30')],
      minutes: 45,
      flex: Flexibility.shiftable,
    );
    PlanRule bulasik({int? minutes = 20}) => rule(
      'R_BULASIK',
      'BULASIK',
      const FollowRecurrence(),
      start: [rel(ConstraintOp.notBefore, 'YEMEK', Edge.end)],
      minutes: minutes,
      flex: Flexibility.shiftable,
    );

    test('bulaşık yemeğin bitişinden sonraki ilk boşluğa', () {
      final out = plan(from: '2026-11-18', rules: [yemek, bulasik()]);
      expect(out.span('YEMEK'), '18:30–19:15');
      expect(out.span('BULASIK'), '19:15–19:35');
    });

    test('yemek kayarsa bulaşık da kayar', () {
      final out = plan(
        from: '2026-11-18',
        rules: [
          yemek,
          bulasik(),
          rule(
            'R_TEL',
            'TEL',
            daily('2026-11-18'),
            start: [atClock('18:00')],
            end: [atClock('19:00')],
          ),
        ],
      );
      expect(out.span('YEMEK'), '19:00–19:45');
      expect(out.span('BULASIK'), '19:45–20:05');
    });

    test('süre yoksa "yemekten sonra" etiketli saatsiz', () {
      final out = plan(
        from: '2026-11-18',
        rules: [
          rule(
            'R_YEMEK',
            'YEMEK',
            daily('2026-11-18'),
            flex: Flexibility.shiftable,
          ),
          bulasik(minutes: null),
        ],
      );
      final b = out.one('BULASIK');
      expect(b.isTimed, isFalse);
      expect(b.anchorActivityId, 'YEMEK');
    });

    test('yemek olmayan gün bulaşık da olmaz', () {
      final out = plan(
        from: '2026-11-18',
        rules: [
          rule(
            'R_YEMEK',
            'YEMEK',
            daily('2026-11-18'),
            start: [atClock('19:00')],
            minutes: 45,
            exceptions: ['2026-11-18'],
          ),
          bulasik(),
        ],
      );
      expect(out.instances, isEmpty);
    });
  });
}
