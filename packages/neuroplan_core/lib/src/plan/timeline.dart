import 'plan_types.dart';

/// Dolu aralıklar, başlangıca göre sıralı; gece yarısını aşan işler için tek sürekli çizgi.
final class Timeline {
  final _starts = <int>[];
  final _ends = <int>[];
  final _owners = <String>[];
  var _maxLen = 0;

  /// [s, e) aralığını [owner] adına doldurur; sıfır uzunluk yok sayılır.
  void add(int s, int e, String owner) {
    if (e <= s) return;
    final i = _lowerBound(s + 1);
    _starts.insert(i, s);
    _ends.insert(i, e);
    _owners.insert(i, owner);
    if (e - s > _maxLen) _maxLen = e - s;
  }

  int _lowerBound(int value) {
    var lo = 0, hi = _starts.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (_starts[mid] < value) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    return lo;
  }

  /// [s, e) ile kesişen aralıkların sahipleri.
  List<String> overlapping(int s, int e) => [
    for (
      var i = _lowerBound(s - _maxLen);
      i < _starts.length && _starts[i] < e;
      i++
    )
      if (_ends[i] > s) _owners[i],
  ];

  /// [from, to) içindeki boş dilimler; sıfır dakikalık boşluk üretmez.
  List<TimeSlot> gaps(int from, int to) {
    final out = <TimeSlot>[];
    var cursor = from;
    for (
      var i = _lowerBound(from - _maxLen);
      i < _starts.length && _starts[i] < to;
      i++
    ) {
      if (_ends[i] <= cursor) continue;
      if (_starts[i] > cursor) out.add(TimeSlot(cursor, _starts[i]));
      cursor = _ends[i];
    }
    if (cursor < to) out.add(TimeSlot(cursor, to));
    return out;
  }

  int freeMinutes(int from, int to) =>
      gaps(from, to).fold(0, (sum, g) => sum + g.minutes);

  /// [lo, hi] arasında başlayıp [endLimit]'i aşmayan, [d] dakikalık en erken boş yer.
  int? earliestFit(int lo, int hi, int d, int endLimit) {
    for (final g in gaps(lo, endLimit)) {
      if (g.start > hi) break;
      if (g.minutes >= d) return g.start;
    }
    return null;
  }

  /// [target]'a en yakın boş yer (eşitlikte erken olan).
  int? nearestFit(int target, int lo, int hi, int d, int endLimit) {
    int? best;
    for (final g in gaps(lo, endLimit)) {
      final latest = [g.end - d, hi].reduce((a, b) => a < b ? a : b);
      if (latest < g.start) continue;
      final s = target.clamp(g.start, latest);
      if (best == null || (s - target).abs() < (best - target).abs()) best = s;
    }
    return best;
  }
}
