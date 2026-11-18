import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

final end = DateTime.utc(2026, 11, 19, 10);

void main() {
  test('en büyük kalan: toplam korunur, eşitlikte anahtar sırası', () {
    final d = distribute(1000, {'c': 1, 'a': 1, 'b': 1});
    expect(d, {'a': 334, 'b': 333, 'c': 333});
    expect(distribute(7, {'x': 0.6, 'y': 0.3, 'z': 0.1}), {
      'x': 4,
      'y': 2,
      'z': 1,
    });
    expect(distribute(10, {'x': 0}), isEmpty);
  });

  test(
    'tamamlanan oturum kazanç, bozulan ceza üretir; anahtar deterministik',
    () {
      final gain = deriveBrainEvents(
        sessionId: 's1',
        outcome: 'completed',
        focusedSeconds: 50 * 60 + 59,
        endedAt: end,
        weights: {'hippocampus': 0.6, 'dlpfc': 0.6},
      );
      expect(
        [for (final e in gain) (e.type, e.regionKey, e.amount)],
        [
          ('neuron_gain', 'dlpfc', 25000),
          ('neuron_gain', 'hippocampus', 25000),
        ],
      );
      expect(gain.first.dedupeKey, 'gain:s1:dlpfc:v1');

      final penalty = deriveBrainEvents(
        sessionId: 's2',
        outcome: 'broken',
        focusedSeconds: 12 * 60,
        endedAt: end,
        weights: {'hippocampus': 1},
      );
      expect(penalty.single.type, 'penalty');
      expect(penalty.single.amount, 12000);
      expect(penalty.single.dedupeKey, 'penalty:s2:hippocampus:v1');
    },
  );

  test('bir dakikadan kısa ya da süren oturum olay üretmez', () {
    expect(
      deriveBrainEvents(
        sessionId: 's',
        outcome: 'completed',
        focusedSeconds: 59,
        endedAt: end,
        weights: {'a': 1},
      ),
      isEmpty,
    );
    expect(
      deriveBrainEvents(
        sessionId: 's',
        outcome: 'in_progress',
        focusedSeconds: 600,
        endedAt: end,
        weights: {'a': 1},
      ),
      isEmpty,
    );
  });
}
