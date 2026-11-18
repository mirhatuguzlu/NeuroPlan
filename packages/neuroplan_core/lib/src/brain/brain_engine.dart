/// Beyin olaylarının türetilmesi (docs/ARCHITECTURE.md §7, DECISIONS D20 + D31).
///
/// v1 kapsamı: tamamlanan oturum → `neuron_gain`, bozulan oturum → `penalty`. Katlama
/// (fold), bağlantılar ve sönme beyin aşamasında eklenir.
library;

/// Bir odak dakikasının her kategoride verdiği toplam kazanç (binde bir nöron).
const neuronsPerMinute = 1000;

const brainEngineVersion = 1;

/// `brain_events` satırının alan katmanındaki karşılığı.
final class BrainEventDraft {
  const BrainEventDraft({
    required this.type,
    required this.regionKey,
    required this.amount,
    required this.occurredAt,
    required this.sessionId,
    required this.dedupeKey,
  });

  /// `neuron_gain` · `penalty`
  final String type;
  final String regionKey;
  final int amount;
  final DateTime occurredAt;
  final String sessionId;
  final String dedupeKey;
  int get engineVersion => brainEngineVersion;
}

/// Oturumdan olayları türetir. Kazanç da ceza da odak dakikası × [neuronsPerMinute]
/// kadardır ve kök kategorinin bölgelerine ağırlık oranında, "en büyük kalan" yöntemiyle
/// tamsayı olarak dağıtılır. Ceza nöron silmez; o kadar nöronu söndürür (D31).
List<BrainEventDraft> deriveBrainEvents({
  required String sessionId,
  required String outcome,
  required int focusedSeconds,
  required DateTime endedAt,
  required Map<String, double> weights,
}) {
  final type = switch (outcome) {
    'completed' => 'neuron_gain',
    'broken' => 'penalty',
    _ => null,
  };
  final total = focusedSeconds ~/ 60 * neuronsPerMinute;
  if (type == null || total <= 0) return const [];
  final prefix = type == 'neuron_gain' ? 'gain' : 'penalty';
  return [
    for (final MapEntry(:key, :value) in distribute(total, weights).entries)
      if (value > 0)
        BrainEventDraft(
          type: type,
          regionKey: key,
          amount: value,
          occurredAt: endedAt.toUtc(),
          sessionId: sessionId,
          dedupeKey: '$prefix:$sessionId:$key:v$brainEngineVersion',
        ),
  ];
}

/// [total]'ı ağırlıklara orantılı dağıtır; toplam korunur. Kalan birimler kesir payı en
/// büyük olana, eşitlikte bölge anahtarı sırasına gider (deterministik).
Map<String, int> distribute(int total, Map<String, double> weights) {
  final keys = [
    for (final MapEntry(:key, :value) in weights.entries)
      if (value > 0) key,
  ]..sort();
  final sum = keys.fold(0.0, (a, k) => a + weights[k]!);
  if (keys.isEmpty || sum <= 0) return const {};
  final exact = {for (final k in keys) k: total * weights[k]! / sum};
  final result = {for (final k in keys) k: exact[k]!.floor()};
  var left = total - result.values.fold(0, (a, b) => a + b);
  final byRemainder = [...keys]
    ..sort((a, b) {
      final c = (exact[b]! - result[b]!).compareTo(exact[a]! - result[a]!);
      return c != 0 ? c : a.compareTo(b);
    });
  for (final k in byRemainder) {
    if (left-- <= 0) break;
    result[k] = result[k]! + 1;
  }
  return result;
}
