import 'dart:math' as math;

/// Hibrit mantıksal saat (docs/ARCHITECTURE.md §5.2).
///
/// Metin biçimi sözlük sırasıyla sıralanır: `<15 hane ms>-<5 hane sayaç>-<düğüm>`.
/// Sunucudaki `hlc_clamp_all` aynı biçimi doğrular.
final class Hlc implements Comparable<Hlc> {
  Hlc(this.millis, this.counter, this.node) {
    if (millis < 0 || millis > 999999999999999) {
      throw RangeError('HLC ms aralık dışı: $millis');
    }
    if (counter < 0 || counter > 99999) {
      throw StateError('HLC sayacı taştı: $counter');
    }
    if (!_nodeRe.hasMatch(node)) throw FormatException('Geçersiz düğüm: $node');
  }

  factory Hlc.zero(String node) => Hlc(0, 0, node);

  factory Hlc.parse(String s) {
    final m = _re.firstMatch(s);
    if (m == null) throw FormatException('Geçersiz HLC: $s');
    return Hlc(int.parse(m[1]!), int.parse(m[2]!), m[3]!);
  }

  static final _re = RegExp(r'^(\d{15})-(\d{5})-([0-9a-z]{1,32})$');
  static final _nodeRe = RegExp(r'^[0-9a-z]{1,32}$');

  final int millis;
  final int counter;
  final String node;

  /// Yerel olay: cihaz saati geri gitse bile öncekinden büyük damga üretir.
  Hlc send(int nowMillis) => nowMillis > millis
      ? Hlc(nowMillis, 0, node)
      : Hlc(millis, counter + 1, node);

  /// Uzak damga görüldü: sonraki yerel damgalar ondan büyük olur.
  Hlc receive(Hlc remote, int nowMillis) {
    final m = math.max(nowMillis, math.max(millis, remote.millis));
    final c = switch ((m == millis, m == remote.millis)) {
      (true, true) => math.max(counter, remote.counter) + 1,
      (true, false) => counter + 1,
      (false, true) => remote.counter + 1,
      (false, false) => 0,
    };
    return Hlc(m, c, node);
  }

  /// Sunucu kuralı: [maxMillis]'ten ileri damga ona kırpılır.
  Hlc clamp(int maxMillis) =>
      millis > maxMillis ? Hlc(maxMillis, counter, node) : this;

  @override
  int compareTo(Hlc other) => toString().compareTo(other.toString());

  @override
  bool operator ==(Object other) =>
      other is Hlc && other.toString() == toString();

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() =>
      '${millis.toString().padLeft(15, '0')}-'
      '${counter.toString().padLeft(5, '0')}-$node';
}
