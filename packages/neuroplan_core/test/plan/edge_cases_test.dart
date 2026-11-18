// Plan motorunun sınır durumları (Aşama 2 talimatı §3).
import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  final sleep = rule(
    'R_UYKU',
    'UYKU',
    daily('2026-11-01'),
    start: [atClock('23:00')],
    end: [atClock('07:00', dayOffset: 1)],
  );

  test(
    'gece yarısını geçen iş: oluşum başladığı günde, ertesi sabahı doldurur',
    () {
      final out = plan(from: '2026-11-19', rules: [sleep]);
      final last = out.of('UYKU');
      expect([for (final i in last) i.date], ['2026-11-18', '2026-11-19']);
      expect(last.first.end, at('2026-11-19', '07:00'));
      expect(out.freeOf('2026-11-19'), ['07:00–23:00']);
    },
  );

  group('yaz saati (Europe/Berlin)', () {
    const berlin = 'Europe/Berlin';
    final cal = PlanCalendar(berlin);
    PlanRule at0230(String date) => rule(
      'R',
      'A',
      OnceRecurrence(date),
      start: [atClock('02:30')],
      minutes: 30,
    );

    test('ileri geçiş: olmayan 02:30 ileri kayar, gün 23 saat', () {
      final out = plan(
        from: '2026-03-29',
        timezone: berlin,
        rules: [at0230('2026-03-29')],
      );
      expect(out.span('A', null, cal), '03:30–04:00');
      final free = out.freeSlots['2026-03-29']!;
      expect(free.fold(0, (s, g) => s + g.minutes), 23 * 60 - 30);
    });

    test('geri geçiş: iki kez yaşanan 02:30 ilki alınır, gün 25 saat', () {
      final out = plan(
        from: '2026-10-25',
        timezone: berlin,
        rules: [at0230('2026-10-25')],
      );
      final a = out.one('A');
      expect(
        a.start,
        DateTime.utc(2026, 10, 25, 0, 30).millisecondsSinceEpoch ~/ 60000,
      );
      final free = out.freeSlots['2026-10-25']!;
      expect(free.fold(0, (s, g) => s + g.minutes), 25 * 60 - 30);
    });
  });

  test(
    'saat dilimi değiştiren kullanıcı: duvar saatleri yeni dilimde yorumlanır',
    () {
      final r = rule(
        'R',
        'A',
        daily('2026-11-01'),
        start: [atClock('13:00')],
        minutes: 60,
      );
      final ny = PlanCalendar('America/New_York');
      final inIst = plan(from: '2026-11-18', rules: [r]).one('A');
      final inNy = plan(
        from: '2026-11-18',
        timezone: 'America/New_York',
        rules: [r],
      ).one('A');
      expect(hm(inIst.start), '13:00');
      expect(hm(inNy.start, ny), '13:00');
      expect(inNy.start! - inIst.start!, 8 * 60); // UTC+3 → UTC−5
      expect(inIst.id, inNy.id); // kimlik saate değil kurala ve güne bağlı
    },
  );

  test('0 dakikalık boşluk üretilmez', () {
    final out = plan(
      from: '2026-11-18',
      rules: [
        rule(
          'RA',
          'A',
          daily('2026-11-01'),
          start: [atClock('09:00')],
          minutes: 60,
        ),
        rule(
          'RB',
          'B',
          daily('2026-11-01'),
          start: [atClock('10:00')],
          minutes: 60,
        ),
      ],
    );
    expect(out.freeOf('2026-11-18'), ['00:00–09:00', '11:00–00:00']);
    expect(out.issues, isEmpty);
  });

  group('3\'lü göreli zincir', () {
    final rules = [
      rule(
        'RA',
        'A',
        daily('2026-11-01'),
        start: [atClock('09:00')],
        minutes: 60,
      ),
      rule(
        'RB',
        'B',
        daily('2026-11-01'),
        start: [rel(ConstraintOp.at, 'A', Edge.end)],
        minutes: 30,
      ),
      rule(
        'RC',
        'C',
        daily('2026-11-01'),
        start: [rel(ConstraintOp.at, 'B', Edge.end)],
        minutes: 15,
      ),
    ];

    test('her halka bir öncekinin bitişinde başlar', () {
      final out = plan(from: '2026-11-18', rules: rules);
      expect(out.span('A'), '09:00–10:00');
      expect(out.span('B'), '10:00–10:30');
      expect(out.span('C'), '10:30–10:45');
    });

    test('ilk iş geç bitince sonrakiler kendiliğinden kayar', () {
      final out = plan(
        from: '2026-11-18',
        rules: rules,
        instances: [
          PersistedInstance(
            id: ruleInstanceId('RA', '2026-11-18'),
            activityId: 'A',
            ruleId: 'RA',
            date: '2026-11-18',
            start: at('2026-11-18', '09:00'),
            end: at('2026-11-18', '10:20'),
            status: InstanceStatus.done,
          ),
        ],
      );
      expect(out.span('B'), '10:20–10:50');
      expect(out.span('C'), '10:50–11:05');
    });
  });

  test(
    'döngüsel bağımlılık yakalanır, motor çökmez, döngüdekiler saatsiz kalır',
    () {
      final out = plan(
        from: '2026-11-18',
        rules: [
          rule(
            'RA',
            'A',
            daily('2026-11-01'),
            start: [rel(ConstraintOp.at, 'B', Edge.end)],
            minutes: 30,
          ),
          rule(
            'RB',
            'B',
            daily('2026-11-01'),
            start: [rel(ConstraintOp.at, 'A', Edge.end)],
            minutes: 30,
          ),
          rule(
            'RC',
            'C',
            daily('2026-11-01'),
            start: [atClock('09:00')],
            minutes: 30,
          ),
        ],
      );
      expect(out.issues.whereType<DependencyCycle>().single.activityIds, [
        'A',
        'B',
      ]);
      expect(out.one('A').isTimed, isFalse);
      expect(out.one('B').isTimed, isFalse);
      expect(out.span('C'), '09:00–09:30');
    },
  );

  test('tamamen boş gün: tek boşluk, hiç oluşum yok', () {
    final out = plan(from: '2026-11-18');
    expect(out.instances, isEmpty);
    expect(out.issues, isEmpty);
    expect(out.freeSlots['2026-11-18']!.single.minutes, 1440);
  });

  test(
    'tamamen dolu gün: boşluk yok, kaydırılabilir tampona, isteğe bağlı düşer',
    () {
      final out = plan(
        from: '2026-11-18',
        rules: [
          rule(
            'RF',
            'FULL',
            daily('2026-11-01'),
            start: [atClock('00:00')],
            end: [atClock('00:00', dayOffset: 1)],
          ),
          rule(
            'RS',
            'S',
            daily('2026-11-01'),
            start: [clock(ConstraintOp.notBefore, '09:00')],
            minutes: 60,
            flex: Flexibility.shiftable,
          ),
          rule(
            'RO',
            'O',
            daily('2026-11-01'),
            start: [atClock('10:00')],
            minutes: 30,
            flex: Flexibility.optional,
          ),
        ],
      );
      expect(out.freeOf('2026-11-18'), isEmpty);
      final overflow = {for (final o in out.overflow) o.instanceId: o.dropped};
      expect(overflow, {
        ruleInstanceId('RS', '2026-11-18'): false,
        ruleInstanceId('RO', '2026-11-18'): true,
      });
      expect(out.one('S').isTimed, isFalse);
    },
  );

  test('sığmayan proje: eksik dakika raporlanır, plan çökmez', () {
    final out = plan(
      from: '2026-11-18',
      to: '2026-11-19',
      rules: [
        rule(
          'R_IS',
          'IS',
          daily('2026-11-01'),
          start: [atClock('00:00')],
          end: [atClock('23:00')],
        ),
      ],
      projects: [
        PlanProject(
          activityId: 'P',
          totalMinutes: 600,
          deadline: at('2026-11-20', '00:00'),
        ),
      ],
    );
    expect(out.proposals.fold(0, (s, p) => s + p.minutes), 120);
    final risk = out.risks.single;
    expect(risk.activityId, 'P');
    expect(risk.missingMinutes, 480);
    expect(out.instances, hasLength(2));
  });

  test('iki kesin iş çakışırsa ikisi de kalır ve çakışma raporlanır', () {
    final out = plan(
      from: '2026-11-18',
      rules: [
        rule(
          'RA',
          'A',
          daily('2026-11-01'),
          start: [atClock('10:00')],
          minutes: 60,
        ),
        rule(
          'RB',
          'B',
          daily('2026-11-01'),
          start: [atClock('10:30')],
          minutes: 60,
        ),
      ],
    );
    expect(out.span('A'), '10:00–11:00');
    expect(out.span('B'), '10:30–11:30');
    final o = out.issues.whereType<Overlap>().single;
    expect({o.a, o.b}, {out.one('A').id, out.one('B').id});
  });

  test('kaydırılabilir iş en yakın boşluğa taşınır (eşitlikte erken)', () {
    final out = plan(
      from: '2026-11-18',
      rules: [
        rule(
          'RA',
          'A',
          daily('2026-11-01'),
          start: [atClock('10:00')],
          minutes: 60,
        ),
        rule(
          'RB',
          'B',
          daily('2026-11-01'),
          start: [atClock('10:00')],
          minutes: 60,
          flex: Flexibility.shiftable,
        ),
        rule(
          'RC',
          'C',
          daily('2026-11-01'),
          start: [atClock('10:30')],
          minutes: 30,
          flex: Flexibility.shiftable,
        ),
      ],
    );
    expect(out.span('B'), '09:00–10:00');
    expect(out.span('C'), '11:00–11:30');
    expect(out.issues, isEmpty);
  });

  test('"bugün" için saatsiz işe geçmiş saat önerilmez', () {
    final out = plan(
      from: '2026-11-18',
      asOf: '2026-11-18T14:10',
      rules: [
        rule(
          'R',
          'A',
          const OnceRecurrence('2026-11-18'),
          minutes: 30,
          flex: Flexibility.shiftable,
        ),
      ],
    );
    expect(out.span('A'), '14:10–14:40');
  });

  test('varyant kendi saatini taşır', () {
    final out = plan(
      from: '2026-11-21',
      rules: [
        rule(
          'R_MAC',
          'MAC',
          daily('2026-11-01'),
          start: [atClock('20:00')],
          minutes: 120,
        ),
      ],
      groups: const [
        PlanVariantGroup(
          id: 'G',
          activityId: 'MAC',
          defaultVariantId: 'V_ERKEN',
        ),
      ],
      variants: [
        PlanVariant(
          id: 'V_ERKEN',
          groupId: 'G',
          timing: Timing(start: [atClock('19:00')]),
        ),
      ],
    );
    expect(out.span('MAC'), '19:00–21:00');
  });

  group('namaz vakti çapası', () {
    final r = rule(
      'R',
      'A',
      daily('2026-11-01'),
      start: [
        const TimeConstraint(ConstraintOp.at, AstroRef(AstroEvent.maghrib)),
      ],
      minutes: 30,
    );

    test('"akşam namazından sonra 30 dk" Diyanet yöntemiyle', () {
      final out = plan(
        from: '2026-11-19',
        rules: [r],
        settings: const PlanSettings(
          timezone: istanbul,
          latitude: 41.0,
          longitude: 29.0,
          prayerMethod: defaultPrayerMethod,
        ),
      );
      final maghrib = AstroClock(
        latitude: 41.0,
        longitude: 29.0,
        prayerMethod: defaultPrayerMethod,
      ).at(AstroEvent.maghrib, Day.parse('2026-11-19'))!;
      expect(out.one('A').start, maghrib);
      expect(out.one('A').end, maghrib + 30);
      expect(hm(maghrib), '17:49'); // Diyanet İstanbul, 19.11.2026
    });

    test('modül kapalıysa kısıt düşer ve neden raporlanır', () {
      final out = plan(
        from: '2026-11-19',
        rules: [r],
        settings: const PlanSettings(
          timezone: istanbul,
          latitude: 41.0,
          longitude: 29.0,
        ),
      );
      expect(out.one('A').isTimed, isTrue); // saatsiz işe saat önerildi
      expect(out.one('A').suggested, isTrue);
      expect(
        out.issues.whereType<MissingAnchorData>().single.missing,
        MissingData.prayerMethod,
      );
    });
  });

  test('determinizm: girdi sırası sonucu değiştirmez', () {
    final rules = [
      sleep,
      rule(
        'RA',
        'A',
        daily('2026-11-01'),
        start: [clock(ConstraintOp.notBefore, '09:00')],
        minutes: 60,
        flex: Flexibility.shiftable,
      ),
      rule(
        'RB',
        'B',
        daily('2026-11-01'),
        start: [clock(ConstraintOp.notBefore, '09:00')],
        minutes: 60,
        flex: Flexibility.shiftable,
      ),
    ];
    String digest(PlanOutput o) =>
        [for (final i in o.instances) '${i.id}@${i.start}-${i.end}'].join(',');
    final a = plan(from: '2026-11-18', to: '2026-11-24', rules: rules);
    final b = plan(
      from: '2026-11-18',
      to: '2026-11-24',
      rules: rules.reversed.toList(),
    );
    expect(digest(a), digest(b));
    expect(a.engineVersion, planEngineVersion);
  });
}
