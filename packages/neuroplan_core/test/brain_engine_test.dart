import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

/// Beyin kuralları v2 (docs/BRAIN_MODEL.md §2). Her kural bir testle korunur.
final weights = {
  'planning': {'pfc_l': 0.6, 'pfc_r': 0.6, 'cing': 0.6},
  'sleep': {'hippo': 1.0},
  'social': {'amyg': 0.6, 'temp': 0.6},
};

BrainSession session(
  String id, {
  String root = 'sleep',
  FocusMode mode = FocusMode.free,
  String outcome = 'completed',
  int minutes = 30,
  String day = '2026-11-19',
  int hour = 10,
  int longest = 0,
  int cycles = 0,
  int escapes = 0,
}) {
  final p = day.split('-').map(int.parse).toList();
  return BrainSession(
    id: id,
    rootCategoryKey: root,
    mode: mode,
    outcome: outcome,
    focusedSeconds: minutes * 60,
    endedAt: DateTime.utc(p[0], p[1], p[2], hour),
    day: day,
    longestRunSeconds: longest * 60,
    completedCycles: cycles,
    recoveredEscapes: escapes,
  );
}

List<(String, String, String?, int)> brief(List<BrainEventDraft> es) => [
  for (final e in es) (e.type, e.regionKey, e.regionBKey, e.amount),
];

int gains(List<BrainEventDraft> es) => [
  for (final e in es)
    if (e.type == 'neuron_gain') e.amount,
].fold(0, (a, b) => a + b);

void main() {
  test('en büyük kalan: toplam korunur, eşitlikte anahtar sırası', () {
    expect(distribute(1000, {'c': 1, 'a': 1, 'b': 1}), {
      'a': 334,
      'b': 333,
      'c': 333,
    });
    expect(distribute(7, {'x': 0.6, 'y': 0.3, 'z': 0.1}), {
      'x': 4,
      'y': 2,
      'z': 1,
    });
    expect(distribute(10, {'x': 0}), isEmpty);
  });

  group('kazanç', () {
    test('dakika × 1000, ağırlıkla dağılır; anahtar deterministik', () {
      final es = deriveBrainEvents(
        session('s1', root: 'planning', minutes: 30),
        const [],
        weights,
      );
      expect(brief(es), [
        ('neuron_gain', 'cing', null, 10000),
        ('neuron_gain', 'pfc_l', null, 10000),
        ('neuron_gain', 'pfc_r', null, 10000),
      ]);
      expect(es.first.dedupeKey, 'gain:s1:cing:v2');
      expect(es.first.engineVersion, 2);
    });

    test('geri dönülen her kaçış çarpanı %10 düşürür, en az %60', () {
      int g(int escapes) =>
          gains(deriveBrainEvents(session('s', escapes: escapes), [], weights));
      expect(g(0), 30000);
      expect(g(2), 24000);
      expect(g(9), 18000);
    });

    test('bozulan oturum kazanç getirmez, odak dakikası kadar ceza üretir', () {
      final es = deriveBrainEvents(
        session('b', outcome: 'broken', minutes: 12),
        const [],
        weights,
      );
      expect(brief(es), [('penalty', 'hippo', null, 12000)]);
      expect(es.single.dedupeKey, 'penalty:b:hippo:v2');
    });

    test('bir dakikadan kısa, kategorisiz ya da süren oturum olay üretmez', () {
      expect(deriveBrainEvents(session('s', minutes: 0), [], weights), isEmpty);
      expect(
        deriveBrainEvents(session('s', outcome: 'in_progress'), [], weights),
        isEmpty,
      );
      expect(
        deriveBrainEvents(
          BrainSession(
            id: 's',
            rootCategoryKey: null,
            mode: FocusMode.free,
            outcome: 'completed',
            focusedSeconds: 600,
            endedAt: DateTime.utc(2026),
            day: '2026-01-01',
          ),
          [],
          weights,
        ),
        isEmpty,
      );
    });
  });

  group('Pomodoro', () {
    test('tamamlanan döngü başına %5, en çok %20', () {
      int g(int cycles) => gains(
        deriveBrainEvents(
          session('p', mode: FocusMode.pomodoro, minutes: 100, cycles: cycles),
          [],
          weights,
        ),
      );
      expect(g(0), 100000);
      expect(g(2), 110000);
      expect(g(6), 120000);
    });

    test(
      'haftalık süreklilik: penceredeki her ek gün %3; bozulma sıfırlar',
      () {
        final pomo = FocusMode.pomodoro;
        final today = session('t', mode: pomo, minutes: 100);
        final history = [
          session('a', mode: pomo, day: '2026-11-16'),
          session('b', mode: pomo, day: '2026-11-17'),
          session('c', mode: pomo, day: '2026-11-17', hour: 12),
          session('old', mode: pomo, day: '2026-11-12'), // pencere dışı (7 gün)
          session(
            'f',
            mode: FocusMode.free,
            day: '2026-11-18',
          ), // Pomodoro değil
        ];
        expect(pomodoroStreakDays(today, history), 3);
        expect(gains(deriveBrainEvents(today, history, weights)), 106000);

        final broken = session(
          'x',
          mode: FocusMode.free,
          outcome: 'broken',
          day: '2026-11-18',
        );
        expect(pomodoroStreakDays(today, [...history, broken]), 1);
      },
    );

    test('bonus yalnız Pomodoro modunda', () {
      expect(
        gains(deriveBrainEvents(session('f', cycles: 4), [], weights)),
        30000,
      );
    });
  });

  group('bağlantılar', () {
    test('derin çalışma: en uzun kesintisiz dakika × 20 bölge çiftlerine', () {
      final es = deriveBrainEvents(
        session('d', root: 'planning', mode: FocusMode.deep, longest: 60),
        const [],
        weights,
      );
      final links = [
        for (final e in es)
          if (e.type == 'connection_gain')
            (e.regionKey, e.regionBKey, e.amount),
      ];
      expect(links, [
        ('cing', 'pfc_l', 400),
        ('cing', 'pfc_r', 400),
        ('pfc_l', 'pfc_r', 400),
      ]);
      expect(es.last.dedupeKey, 'deep:d:pfc_l:pfc_r:v2');
    });

    test('tek bölgeli kategoride derin çalışma bölge içi bağdır', () {
      final es = deriveBrainEvents(
        session('d', mode: FocusMode.deep, longest: 10),
        const [],
        weights,
      );
      expect(brief(es).last, ('connection_gain', 'hippo', 'hippo', 200));
    });

    test('art arda günler bölge içi bağı seri boyunca güçlendirir', () {
      final history = [
        session('a', day: '2026-11-17'),
        session('b', day: '2026-11-18'),
        session('z', day: '2026-11-15'), // 16'sı boş: seri kopar
      ];
      final es = deriveBrainEvents(session('t'), history, weights);
      final link = es.singleWhere((e) => e.type == 'connection_gain');
      expect(
        (link.regionKey, link.regionBKey, link.amount),
        ('hippo', 'hippo', 200),
      );
      expect(link.dedupeKey, 'streak:2026-11-19:sleep:hippo:hippo:v2');
      // Dün yoksa bağ yok.
      expect(
        deriveBrainEvents(session('t'), [
          session('z', day: '2026-11-17'),
        ], weights).where((e) => e.type == 'connection_gain'),
        isEmpty,
      );
    });

    test(
      'aynı gün farklı kategori bölgeler arası bağ kurar, gün başına bir kez',
      () {
        final morning = session('m', root: 'social', hour: 8);
        final es = deriveBrainEvents(session('t'), [morning], weights);
        final links = [
          for (final e in es)
            if (e.type == 'connection_gain')
              (e.regionKey, e.regionBKey, e.amount, e.dedupeKey),
        ];
        expect(links, [
          ('amyg', 'hippo', 150, 'cross:2026-11-19:sleep:social:amyg:hippo:v2'),
          ('hippo', 'temp', 150, 'cross:2026-11-19:sleep:social:hippo:temp:v2'),
        ]);
        // Sonra biten oturum geçmişte sayılmaz.
        final later = session('l', root: 'social', hour: 20);
        expect(
          deriveBrainEvents(session('t'), [
            later,
          ], weights).where((e) => e.type == 'connection_gain'),
          isEmpty,
        );
      },
    );
  });

  test('aynı girdi aynı olayları üretir (geçmişin sırası önemsiz)', () {
    final h = [
      session('a', day: '2026-11-18'),
      session('m', root: 'social', hour: 8),
    ];
    final a = deriveBrainEvents(session('t'), h, weights);
    final b = deriveBrainEvents(session('t'), h.reversed, weights);
    expect([for (final e in a) e.toJson()], [for (final e in b) e.toJson()]);
  });

  test('addDays ay ve yıl sınırını geçer', () {
    expect(addDays('2026-12-31', 1), '2027-01-01');
    expect(addDays('2026-03-01', -1), '2026-02-28');
  });
}
