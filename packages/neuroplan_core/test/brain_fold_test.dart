import 'dart:convert';
import 'dart:io';

import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

DateTime day(int d, [int h = 12]) => DateTime.utc(2026, 11, d, h);

BrainEventDraft ev(
  String type,
  String region,
  int amount,
  DateTime at, {
  String? b,
  String session = 's',
}) => BrainEventDraft(
  type: type,
  regionKey: region,
  regionBKey: b,
  amount: amount,
  occurredAt: at,
  sessionId: session,
  dedupeKey: '$type:$session:$region:${b ?? ''}:${at.toIso8601String()}',
);

const keys = ['a', 'b'];

void main() {
  group('katlama', () {
    test('ceza söndürür ama silmez; sonraki kazanç önce sönükleri yakar', () {
      final s = foldBrain(
        [
          ev('neuron_gain', 'a', 10000, day(1)),
          ev('penalty', 'a', 4000, day(2)),
        ],
        day(2),
        regionKeys: keys,
      );
      expect((s.regions['a']!.lit, s.regions['a']!.dimmed), (6000, 4000));
      expect(s.regions['a']!.total, 10000);

      final t = foldBrain(
        [
          ev('neuron_gain', 'a', 10000, day(1)),
          ev('penalty', 'a', 4000, day(2)),
          ev('neuron_gain', 'a', 3000, day(3)),
        ],
        day(3),
        regionKeys: keys,
      );
      // 3000'in hepsi sönükleri yaktı: toplam değişmedi.
      expect((t.regions['a']!.lit, t.regions['a']!.dimmed), (9000, 1000));
      expect(t.regions['a']!.total, 10000);
    });

    test('ceza yanandan fazlaysa yalnız yananlar söner', () {
      final s = foldBrain(
        [
          ev('neuron_gain', 'a', 2000, day(1)),
          ev('penalty', 'a', 5000, day(1, 13)),
        ],
        day(2),
        regionKeys: keys,
      );
      expect((s.regions['a']!.lit, s.regions['a']!.dimmed), (0, 2000));
    });

    test('asOf sonrası olaylar yok sayılır (zaman çizelgesi)', () {
      final events = [
        ev('neuron_gain', 'a', 1000, day(1)),
        ev('neuron_gain', 'a', 2000, day(5)),
      ];
      expect(
        foldBrain(events, day(3), regionKeys: keys).regions['a']!.total,
        1000,
      );
      expect(
        foldBrain(events, day(6), regionKeys: keys).regions['a']!.total,
        3000,
      );
    });

    test('bağlantılar sıralı çift anahtarında toplanır', () {
      final s = foldBrain(
        [
          ev('connection_gain', 'b', 100, day(1), b: 'a'),
          ev('connection_gain', 'a', 50, day(2), b: 'b'),
          ev('connection_gain', 'a', 30, day(2), b: 'a'),
        ],
        day(3),
        regionKeys: keys,
      );
      expect(s.connections, {'a|b': 150, 'a|a': 30});
    });

    test('olay sırası sonucu değiştirmez', () {
      final events = [
        ev('neuron_gain', 'a', 1000, day(1)),
        ev('penalty', 'a', 500, day(2)),
        ev('neuron_gain', 'b', 700, day(2)),
      ];
      expect(
        jsonEncode(foldBrain(events, day(4), regionKeys: keys).toJson()),
        jsonEncode(
          foldBrain(events.reversed, day(4), regionKeys: keys).toJson(),
        ),
      );
    });

    test('kök kategori payı oturumdan izlenir', () {
      final s = foldBrain(
        [
          ev('neuron_gain', 'a', 1000, day(1), session: 'x'),
          ev('neuron_gain', 'a', 3000, day(2), session: 'y'),
        ],
        day(3),
        regionKeys: keys,
        sessionRoots: {'x': 'sleep', 'y': 'planning'},
      );
      expect(s.regions['a']!.byRoot, {'sleep': 1000, 'planning': 3000});
    });
  });

  group('sönme', () {
    test('yarılanma 14 gün, taban 250; hiç beslenmeyen tabanda', () {
      expect(brightnessAt(day(1), day(1), brainConfig), 1000);
      expect(brightnessAt(day(1), day(15), brainConfig), 625);
      expect(brightnessAt(day(1), DateTime.utc(2027, 6), brainConfig), 250);
      expect(brightnessAt(null, day(1), brainConfig), 250);
    });

    test('yeni kazanç parlaklığı tama döndürür', () {
      final s = foldBrain(
        [
          ev('neuron_gain', 'a', 1000, day(1)),
          ev('neuron_gain', 'a', 1000, day(20)),
        ],
        day(20),
        regionKeys: keys,
      );
      expect(s.regions['a']!.brightness, 1000);
    });
  });

  group('çizim planı', () {
    BrainState state(int aNeurons, int bNeurons) => foldBrain(
      [
        ev('neuron_gain', 'a', aNeurons * 1000, day(1)),
        ev('neuron_gain', 'b', bNeurons * 1000, day(1)),
      ],
      day(1),
      regionKeys: keys,
    );

    test('sınırın altında bir nöron bir noktadır', () {
      final p = renderPlan(state(100, 50), QualityTier.low);
      expect([for (final r in p.regions) r.points], [100, 50]);
      expect([for (final r in p.regions) r.glow], [1000, 1000]);
    });

    test('sınır aşılınca noktalar orantılı, fazla ışımaya yansır', () {
      final s = foldBrain(
        [
          ev('neuron_gain', 'a', 1800 * 1000, day(1)),
          ev('neuron_gain', 'b', 600 * 1000, day(1)),
        ],
        day(15),
        regionKeys: keys,
      );
      final p = renderPlan(s, QualityTier.low);
      expect([for (final r in p.regions) r.points], [900, 300]);
      // parlaklık 625 × (1 + 0,25 × log2(2)) = 781
      expect(p.regions.first.glow, 781);
    });

    test('sönük noktalar oranla ayrılır', () {
      final s = foldBrain(
        [
          ev('neuron_gain', 'a', 100 * 1000, day(1)),
          ev('penalty', 'a', 25 * 1000, day(1, 13)),
        ],
        day(1, 14),
        regionKeys: keys,
      );
      final r = renderPlan(s, QualityTier.high).regions.first;
      expect((r.points, r.dimPoints), (75, 25));
    });

    test('bağlar güce göre sıralanır, kademe sınırıyla kesilir', () {
      final s = foldBrain(
        [
          for (var i = 0; i < 50; i++)
            ev('connection_gain', 'a', 100 + i, day(1), b: 'b', session: '$i'),
          ev('neuron_gain', 'a', 1000, day(1)),
          ev('neuron_gain', 'b', 1000, day(1)),
        ],
        day(1),
        regionKeys: keys,
      );
      final links = renderPlan(s, QualityTier.low).links;
      expect(links.single.level, inInclusiveRange(1, 1000));
    });
  });

  group('kalite', () {
    test('donanım ipuçlarından kademe', () {
      expect(
        QualityGovernor.fromHints(cores: 8, memoryGb: 8).tier,
        QualityTier.high,
      );
      expect(
        QualityGovernor.fromHints(cores: 8, memoryGb: 4).tier,
        QualityTier.mid,
      );
      expect(
        QualityGovernor.fromHints(cores: 4, memoryGb: 8).tier,
        QualityTier.low,
      );
      expect(
        QualityGovernor.fromHints(renderer: 'Mali-T628').tier,
        QualityTier.low,
      );
    });

    test('iki düşük rapor üst üste bir kademe indirir, tabanda durur', () {
      final g = QualityGovernor(QualityTier.high);
      expect(g.report(40), isNull);
      expect(g.report(58), isNull); // iyi rapor sayacı sıfırlar
      expect(g.report(40), isNull);
      expect(g.report(41), QualityTier.mid);
      expect(g.report(20), isNull);
      expect(g.report(20), QualityTier.low);
      expect(
        g.report(28),
        isNull,
      ); // düşük kademe hedefi 30: 27'nin üstü yeterli
      expect(g.report(10), isNull);
      expect(g.report(10), isNull);
      expect(g.tier, QualityTier.low);
    });
  });

  test('olay özeti sıradan bağımsız, içerik değişince değişir', () {
    expect(eventsHash(['b', 'a']), eventsHash(['a', 'b']));
    expect(eventsHash(['a']), isNot(eventsHash(['a', 'b'])));
    expect(eventsHash(['a']), '1-${eventsHash(['a']).split('-')[1]}');
  });

  // Sunucuda yeniden çalışacak hesap için test vektörü (ARCHITECTURE §7).
  // Güncellemek: UPDATE_VECTORS=1 dart test test/brain_fold_test.dart
  test('test vektörü: brain_v2.json', () {
    final file = File('test/vectors/brain_v2.json');
    final input = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    final weights = {
      for (final MapEntry(:key, :value)
          in (input['weights'] as Map<String, Object?>).entries)
        key: {
          for (final MapEntry(:key, :value)
              in (value as Map<String, Object?>).entries)
            key: (value as num).toDouble(),
        },
    };
    final sessions = [
      for (final j in input['sessions'] as List)
        () {
          final m = j as Map<String, Object?>;
          return BrainSession(
            id: m['id'] as String,
            rootCategoryKey: m['root'] as String,
            mode: FocusMode.fromJson(m['mode'] as String),
            outcome: m['outcome'] as String,
            focusedSeconds: m['focused_seconds'] as int,
            endedAt: DateTime.parse(m['ended_at'] as String),
            day: m['day'] as String,
            longestRunSeconds: m['longest_run_seconds'] as int? ?? 0,
            completedCycles: m['completed_cycles'] as int? ?? 0,
            recoveredEscapes: m['recovered_escapes'] as int? ?? 0,
          );
        }(),
    ];
    final events = [
      for (final s in sessions) ...deriveBrainEvents(s, sessions, weights),
    ];
    final asOf = DateTime.parse(input['as_of'] as String);
    final regionKeys = {for (final w in weights.values) ...w.keys}.toList()
      ..sort();
    final output = {
      'events': [for (final e in events) e.toJson()],
      'state': foldBrain(events, asOf, regionKeys: regionKeys).toJson(),
    };
    if (Platform.environment['UPDATE_VECTORS'] == '1') {
      input['expected'] = output;
      file.writeAsStringSync(
        '${const JsonEncoder.withIndent('  ').convert(input)}\n',
      );
    }
    expect(
      jsonEncode(output),
      jsonEncode(input['expected']),
      reason: 'UPDATE_VECTORS=1 ile yeniden üret ve farkı incele',
    );
  });
}
