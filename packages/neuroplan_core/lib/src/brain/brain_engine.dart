/// Beyin olaylarının türetilmesi, v2 (docs/BRAIN_MODEL.md, DECISIONS D20 + D31 + D39).
///
/// Girdi: biten oturumun özeti + son günlerin oturumları + ağırlık tablosu. Saat okunmaz,
/// rastgelelik yoktur; aynı girdi aynı olayları ve aynı tekilleştirme anahtarlarını üretir.
library;

import '../focus/focus_clock.dart' show FocusMode;
import 'brain_config.dart';

const brainEngineVersion = BrainConfig.engineVersion;

/// `brain_events` satırının alan katmanındaki karşılığı.
final class BrainEventDraft {
  const BrainEventDraft({
    required this.type,
    required this.regionKey,
    required this.amount,
    required this.occurredAt,
    required this.dedupeKey,
    this.regionBKey,
    this.sessionId,
    this.engineVersion = brainEngineVersion,
  });

  /// `neuron_gain` · `connection_gain` · `penalty`
  final String type;
  final String regionKey;

  /// Bağlantının ikinci ucu; bölge içi bağlantıda [regionKey] ile aynıdır.
  final String? regionBKey;
  final int amount;
  final DateTime occurredAt;
  final String? sessionId;
  final String dedupeKey;
  final int engineVersion;

  Map<String, Object?> toJson() => {
    'type': type,
    'region_key': regionKey,
    if (regionBKey != null) 'region_b_key': regionBKey,
    'amount': amount,
    'occurred_at': occurredAt.toUtc().toIso8601String(),
    if (sessionId != null) 'session_id': sessionId,
    'dedupe_key': dedupeKey,
  };
}

/// Biten bir odak oturumunun beyin hesabına giren özeti.
final class BrainSession {
  const BrainSession({
    required this.id,
    required this.rootCategoryKey,
    required this.mode,
    required this.outcome,
    required this.focusedSeconds,
    required this.endedAt,
    required this.day,
    this.longestRunSeconds = 0,
    this.completedCycles = 0,
    this.recoveredEscapes = 0,
  });

  final String id;
  final String? rootCategoryKey;
  final FocusMode mode;

  /// `completed` · `broken` (başka değer olay üretmez)
  final String outcome;
  final int focusedSeconds;
  final DateTime endedAt;

  /// Bitişin kullanıcının saat dilimindeki günü, `YYYY-MM-DD`.
  final String day;
  final int longestRunSeconds;
  final int completedCycles;

  /// 10 sn içinde geri dönülen, sayılan kaçışlar (arama, ekran kapanması sayılmaz).
  final int recoveredEscapes;

  bool get completed => outcome == 'completed';
}

/// Oturumdan olayları türetir. [history] öteki oturumlardır (sırası önemsiz); yalnız
/// bu oturumdan önce bitenler ve son [BrainConfig.historyDays] gün dikkate alınır.
/// [weights]: kök kategori → bölge → ağırlık.
List<BrainEventDraft> deriveBrainEvents(
  BrainSession s,
  Iterable<BrainSession> history,
  Map<String, Map<String, double>> weights, {
  BrainConfig config = brainConfig,
}) {
  final root = s.rootCategoryKey;
  final w = weights[root] ?? const {};
  final minutes = s.focusedSeconds ~/ 60;
  if (root == null || w.isEmpty || minutes <= 0) return const [];
  final at = s.endedAt.toUtc();
  final v = 'v$brainEngineVersion';

  if (s.outcome == 'broken') {
    return [
      for (final MapEntry(:key, :value) in distribute(
        minutes * config.neuronsPerMinute,
        w,
      ).entries)
        if (value > 0)
          BrainEventDraft(
            type: 'penalty',
            regionKey: key,
            amount: value,
            occurredAt: at,
            sessionId: s.id,
            dedupeKey: 'penalty:${s.id}:$key:$v',
          ),
    ];
  }
  if (!s.completed) return const [];

  final earlier = _window(s, history, config);
  final total = gainTotal(s, earlier, config);
  final events = <BrainEventDraft>[
    for (final MapEntry(:key, :value) in distribute(total, w).entries)
      if (value > 0)
        BrainEventDraft(
          type: 'neuron_gain',
          regionKey: key,
          amount: value,
          occurredAt: at,
          sessionId: s.id,
          dedupeKey: 'gain:${s.id}:$key:$v',
        ),
  ];

  BrainEventDraft link(String a, String b, int amount, String key) =>
      BrainEventDraft(
        type: 'connection_gain',
        regionKey: a,
        regionBKey: b,
        amount: amount,
        occurredAt: at,
        sessionId: s.id,
        dedupeKey: '$key:$a:$b:$v',
      );

  // Derin çalışma: en uzun kesintisiz süre kategorinin bölgeleri arasındaki bağı kalınlaştırır.
  if (s.mode == FocusMode.deep) {
    final amount = s.longestRunSeconds ~/ 60 * config.deepLinkPerMinute;
    for (final MapEntry(:key, :value) in distribute(
      amount,
      _pairs(w, w),
    ).entries) {
      final (a, b) = _split(key);
      if (value > 0) events.add(link(a, b, value, 'deep:${s.id}'));
    }
  }

  // Art arda günler: aynı kök kategori dün de tamamlandıysa bölge içi bağlar güçlenir.
  // Anahtar gün + kategori başına tekildir; günün ikinci oturumu yeni bağ eklemez.
  final streak = _consecutiveDays(s, earlier);
  if (streak > 0) {
    final amount =
        config.consecutiveDayLink * _min(streak, config.maxConsecutiveDays);
    for (final r in _sorted(w)) {
      events.add(link(r, r, amount, 'streak:${s.day}:$root'));
    }
  }

  // Aynı gün farklı kategoriler: iki kategorinin bölgeleri arasında bağ kurulur, gün ×
  // kategori çifti başına bir kez.
  final otherRoots = {
    for (final o in earlier)
      if (o.completed && o.day == s.day && o.rootCategoryKey != root)
        ?o.rootCategoryKey,
  }.toList()..sort();
  for (final other in otherRoots) {
    final ow = weights[other] ?? const {};
    final (r1, r2) = root.compareTo(other) < 0 ? (root, other) : (other, root);
    for (final MapEntry(:key, :value) in distribute(
      config.crossCategoryLink,
      _pairs(w, ow, skipSame: true),
    ).entries) {
      final (a, b) = _split(key);
      if (value > 0) events.add(link(a, b, value, 'cross:${s.day}:$r1:$r2'));
    }
  }
  return events;
}

/// Tamamlanan oturumun toplam nöron kazancı (binde bir): dakika × birim × odak çarpanı ×
/// (1 + Pomodoro ekleri). Tamsayı aritmetiği.
int gainTotal(
  BrainSession s,
  List<BrainSession> earlier, [
  BrainConfig config = brainConfig,
]) {
  final base = s.focusedSeconds ~/ 60 * config.neuronsPerMinute;
  final focus = _max(
    config.minFocusPermille,
    1000 - config.escapePenaltyPermille * s.recoveredEscapes,
  );
  var bonus = 0;
  if (s.mode == FocusMode.pomodoro) {
    bonus += _min(
      config.cycleBonusPermille * s.completedCycles,
      config.maxCycleBonusPermille,
    );
    bonus += _min(
      config.streakDayBonusPermille *
          (pomodoroStreakDays(s, earlier, config) - 1),
      config.maxStreakBonusPermille,
    );
  }
  return base * focus ~/ 1000 * (1000 + bonus) ~/ 1000;
}

/// Pencere içinde Pomodoro tamamlanan farklı gün sayısı (bugün dahil), son bozulan
/// oturumdan sonra sayılır: bozulma seriyi sıfırlar (FOCUS-5).
int pomodoroStreakDays(
  BrainSession s,
  Iterable<BrainSession> history, [
  BrainConfig config = brainConfig,
]) {
  final earlier = _window(s, history, config);
  DateTime? lastBroken;
  for (final o in earlier) {
    if (o.outcome == 'broken' &&
        (lastBroken == null || o.endedAt.isAfter(lastBroken))) {
      lastBroken = o.endedAt;
    }
  }
  return {
    s.day,
    for (final o in earlier)
      if (o.completed &&
          o.mode == FocusMode.pomodoro &&
          (lastBroken == null || o.endedAt.isAfter(lastBroken)))
        o.day,
  }.length;
}

/// Bu oturumdan önce biten ve son `historyDays` gün içindeki oturumlar.
List<BrainSession> _window(
  BrainSession s,
  Iterable<BrainSession> history,
  BrainConfig config,
) {
  final from = addDays(s.day, -(config.historyDays - 1));
  return [
    for (final o in history)
      if (o.id != s.id &&
          o.endedAt.isBefore(s.endedAt) &&
          o.day.compareTo(from) >= 0 &&
          o.day.compareTo(s.day) <= 0)
        o,
  ];
}

/// Dünden geriye, aynı kök kategoride tamamlanan oturumu olan ardışık gün sayısı.
int _consecutiveDays(BrainSession s, List<BrainSession> earlier) {
  final days = {
    for (final o in earlier)
      if (o.completed && o.rootCategoryKey == s.rootCategoryKey) o.day,
  };
  var n = 0;
  while (days.contains(addDays(s.day, -(n + 1)))) {
    n++;
  }
  return n;
}

/// `YYYY-MM-DD` + gün (takvim günü; saat dilimi gerekmez).
String addDays(String day, int delta) {
  final p = day.split('-').map(int.parse).toList();
  final d = DateTime.utc(p[0], p[1], p[2] + delta);
  String two(int x) => x.toString().padLeft(2, '0');
  return '${d.year}-${two(d.month)}-${two(d.day)}';
}

/// Bölge çiftleri (a ≤ b) → ağırlık çarpımı. Aynı çift iki yoldan gelirse toplanır.
Map<String, double> _pairs(
  Map<String, double> x,
  Map<String, double> y, {
  bool skipSame = false,
}) {
  final out = <String, double>{};
  final xs = _sorted(x);
  final ys = _sorted(y);
  final single = identical(x, y) && xs.length == 1;
  for (final a in xs) {
    for (final b in ys) {
      if (a == b && (skipSame || !single)) continue;
      if (identical(x, y) && a.compareTo(b) > 0) continue;
      final key = a.compareTo(b) <= 0 ? '$a|$b' : '$b|$a';
      out[key] = (out[key] ?? 0) + x[a]! * y[b]!;
    }
  }
  return out;
}

(String, String) _split(String key) {
  final i = key.indexOf('|');
  return (key.substring(0, i), key.substring(i + 1));
}

List<String> _sorted(Map<String, double> w) => [
  for (final MapEntry(:key, :value) in w.entries)
    if (value > 0) key,
]..sort();

int _min(int a, int b) => a < b ? a : b;
int _max(int a, int b) => a > b ? a : b;

/// [total]'ı ağırlıklara orantılı dağıtır; toplam korunur. Kalan birimler kesir payı en
/// büyük olana, eşitlikte anahtar sırasına gider (deterministik).
Map<String, int> distribute(int total, Map<String, double> weights) {
  final keys = [
    for (final MapEntry(:key, :value) in weights.entries)
      if (value > 0) key,
  ]..sort();
  final sum = keys.fold(0.0, (a, k) => a + weights[k]!);
  if (keys.isEmpty || sum <= 0 || total <= 0) return const {};
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
