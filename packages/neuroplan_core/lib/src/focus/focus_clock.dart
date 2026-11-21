/// Odak oturumunun zaman damgalı sayacı (docs/DB_SCHEMA.md §4.1, DECISIONS D32).
///
/// Sayaç tick saymaz: her değer segmentlerden ve verilen `now`'dan hesaplanır. Uygulama
/// öldürülüp saatler sonra açılsa da [FocusClock.advance] faz sınırlarını tam anında kapatır.
library;

import 'dart:math' as math;

enum FocusMode {
  free,
  pomodoro,
  deep;

  static FocusMode fromJson(String v) => values.byName(v);
}

/// Pomodoro `{"work":25,"break":5,"long_break":15,"long_every":4}`, derin çalışma
/// `{"target":120,"block":50,"break":10}` (dakika; `block` yoksa D66 öncesi: blok yok,
/// mola isteğe bağlı). Serbest modda ayar yoktur.
final class FocusSettings {
  const FocusSettings(
    this.mode, {
    this.work = 25,
    this.rest = 5,
    this.longRest = 15,
    this.longEvery = 4,
    this.target = 90,
    this.block,
  });

  /// Bozuk ya da eksik değer varsayılana döner; süreler en az 1 dakikadır.
  factory FocusSettings.fromJson(FocusMode mode, Map<String, Object?>? j) {
    int? valid(String key) {
      final v = j?[key];
      return v is int && v >= 1 && v <= 24 * 60 ? v : null;
    }

    final deep = mode == FocusMode.deep;
    final block = deep ? valid('block') : null;
    return FocusSettings(
      mode,
      work: valid('work') ?? 25,
      rest: valid('break') ?? (block != null ? 10 : 5),
      longRest: valid('long_break') ?? 15,
      longEvery: valid('long_every') ?? 4,
      target: valid('target') ?? 90,
      block: block,
    );
  }

  final FocusMode mode;
  final int work;

  /// Pomodoro kısa molası; blok planlı derin çalışmada bloklar arası mola.
  final int rest;
  final int longRest;
  final int longEvery;

  /// Derin çalışmada toplam saf odak hedefi.
  final int target;

  /// Derin çalışma blok uzunluğu (D66); null = blok yok.
  final int? block;

  /// Blok planlı derin çalışma: blok bitince mola başlar, hedefte oturum tamamlanır.
  bool get blocked => mode == FocusMode.deep && block != null;

  /// Blok planındaki blok sayısı (son blok kısa olabilir).
  int get blockCount => blocked ? FocusBlocks.countOf(target, block!) : 1;

  Map<String, Object?>? toJson() => switch (mode) {
    FocusMode.free => null,
    FocusMode.pomodoro => {
      'work': work,
      'break': rest,
      'long_break': longRest,
      'long_every': longEvery,
    },
    FocusMode.deep => {
      'target': target,
      if (block != null) ...{'block': block, 'break': rest},
    },
  };

  FocusSettings copyWith({
    FocusMode? mode,
    int? work,
    int? rest,
    int? longRest,
    int? longEvery,
    int? target,
    int? block,
  }) => FocusSettings(
    mode ?? this.mode,
    work: work ?? this.work,
    rest: rest ?? this.rest,
    longRest: longRest ?? this.longRest,
    longEvery: longEvery ?? this.longEvery,
    target: target ?? this.target,
    block: block ?? this.block,
  );
}

/// İşin derin çalışma blok planı (D66): [block] dk odak, aralarda [rest] dk mola; iş
/// süresi saf odaktır, molalar süreyi uzatır. [spread]: bloklar gün içine dağıtılır.
final class FocusBlocks {
  const FocusBlocks({this.block = 50, this.rest = 10, this.spread = false});

  final int block;
  final int rest;
  final bool spread;

  static int countOf(int focus, int block) =>
      focus <= 0 ? 1 : (focus + block - 1) ~/ block;

  /// [focus] dk saf odak üst üste yapılınca planda kaplanan süre.
  int span(int focus) => focus + (countOf(focus, block) - 1) * rest;

  /// [span]'in tersi: planda [length] dk'ya sığan en uzun saf odak.
  int focusOf(int length) {
    for (var f = length; f > 1; f--) {
      if (span(f) <= length) return f;
    }
    return 1;
  }

  /// Dağıtılan blokların uzunlukları: [block], [block], …, kalan.
  List<int> parts(int focus) => [
    for (var left = focus; left > 0; left -= block) math.min(block, left),
  ];

  @override
  bool operator ==(Object other) =>
      other is FocusBlocks &&
      other.block == block &&
      other.rest == rest &&
      other.spread == spread;

  @override
  int get hashCode => Object.hash(block, rest, spread);
}

enum SegmentKind {
  work('work'),
  rest('break');

  const SegmentKind(this.json);
  final String json;
}

/// `{"kind":"work"|"break","start":ISO,"end":ISO|null}`; açık segmentin `end`'i null.
final class Segment {
  const Segment(this.kind, this.start, [this.end]);

  factory Segment.fromJson(Map<String, Object?> j) => Segment(
    SegmentKind.values.firstWhere((k) => k.json == j['kind']),
    DateTime.parse(j['start'] as String).toUtc(),
    j['end'] == null ? null : DateTime.parse(j['end'] as String).toUtc(),
  );

  final SegmentKind kind;
  final DateTime start;
  final DateTime? end;

  bool get open => end == null;
  Duration lengthAt(DateTime now) => (end ?? now).difference(start);
  Segment closeAt(DateTime at) => Segment(kind, start, at);

  Map<String, Object?> toJson() => {
    'kind': kind.json,
    'start': start.toUtc().toIso8601String(),
    'end': end?.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is Segment &&
      other.kind == kind &&
      other.start == start &&
      other.end == end;

  @override
  int get hashCode => Object.hash(kind, start, end);

  @override
  String toString() => '${kind.json}[$start, $end]';
}

enum FocusPhase {
  /// Odak segmenti açık.
  working,

  /// Mola segmenti açık; uygulamadan çıkmak serbest.
  onBreak,

  /// Mola bitti; sonraki odak bloğu kullanıcı "Devam" deyince başlar (D34).
  breakOver,

  /// Açık segment yok, son segment odak (duraklatıldı).
  paused,
}

/// Flowtime benzeri mola önerisi (ürün kuralı, bilimsel iddia değil; D34).
int suggestedBreakMinutes(Duration work) {
  final m = work.inMinutes;
  return m < 25
      ? 5
      : m < 50
      ? 8
      : m < 90
      ? 10
      : 15;
}

final class FocusClock {
  FocusClock(this.settings, Iterable<Segment> segments)
    : segments = List.unmodifiable(segments);

  /// Oturum `now` anında açık bir odak segmentiyle başlar.
  factory FocusClock.start(FocusSettings settings, DateTime now) =>
      FocusClock(settings, [Segment(SegmentKind.work, now.toUtc())]);

  final FocusSettings settings;
  final List<Segment> segments;

  Segment? get _last => segments.isEmpty ? null : segments.last;

  FocusPhase get phase => switch (_last) {
    null => FocusPhase.paused,
    Segment(open: true, kind: SegmentKind.work) => FocusPhase.working,
    Segment(open: true) => FocusPhase.onBreak,
    Segment(kind: SegmentKind.rest) => FocusPhase.breakOver,
    _ => FocusPhase.paused,
  };

  /// Molalar ve kaçışlar hariç odak süresi.
  Duration focused(DateTime now) => [
    for (final s in segments)
      if (s.kind == SegmentKind.work) s.lengthAt(now),
  ].fold(Duration.zero, (a, b) => a + b);

  /// En uzun kesintisiz odak (derin çalışma ödülü, FOCUS-5).
  Duration longestRun(DateTime now) => [
    for (final s in segments)
      if (s.kind == SegmentKind.work) s.lengthAt(now),
  ].fold(Duration.zero, (a, b) => a > b ? a : b);

  /// Son moladan bu yana odak süresi (açık mola varsa ondan öncesi).
  Duration _workSinceBreak(DateTime now, [int? end]) {
    var total = Duration.zero;
    for (var i = (end ?? segments.length) - 1; i >= 0; i--) {
      final s = segments[i];
      if (s.kind == SegmentKind.rest) break;
      total += s.lengthAt(now);
    }
    return total;
  }

  /// Tam süresine ulaşan Pomodoro döngüsü sayısı.
  int completedCycles(DateTime now) {
    if (settings.mode != FocusMode.pomodoro) return 0;
    final full = Duration(minutes: settings.work);
    var cycles = 0;
    var acc = Duration.zero;
    for (final s in segments) {
      if (s.kind == SegmentKind.work) {
        acc += s.lengthAt(now);
      } else {
        if (acc >= full) cycles++;
        acc = Duration.zero;
      }
    }
    return acc >= full ? cycles + 1 : cycles;
  }

  /// Şimdiki döngünün sırası (1'den başlar).
  int get cycle =>
      segments.where((s) => s.kind == SegmentKind.rest && !s.open).length + 1;

  /// [index]. molanın (1'den) uzunluğu; molalar Pomodoro'da ayardan, öbür modlarda
  /// moladan önceki odak süresinden gelir.
  Duration _breakLength(int index, Duration workBefore) =>
      settings.mode == FocusMode.pomodoro
      ? Duration(
          minutes: index % settings.longEvery == 0
              ? settings.longRest
              : settings.rest,
        )
      : settings.blocked
      ? Duration(minutes: settings.rest)
      : Duration(minutes: suggestedBreakMinutes(workBefore));

  /// Açık molanın uzunluğu ya da (mola yoksa) şimdi başlayacak molanın önerisi.
  Duration breakLength(DateTime now) {
    final breaks = segments.where((s) => s.kind == SegmentKind.rest).length;
    if (phase == FocusPhase.onBreak) {
      return _breakLength(breaks, _workSinceBreak(now, segments.length - 1));
    }
    return _breakLength(breaks + 1, _workSinceBreak(now));
  }

  /// Fazın kalan süresi: Pomodoro odak bloğu, mola ya da derin çalışma hedefi.
  /// Serbest modda ve hedef aşılınca null.
  Duration? remaining(DateTime now) {
    final end = nextBoundary(now);
    return end?.difference(now);
  }

  /// Bir sonraki faz sınırı (Pomodoro odak sonu, mola sonu, derin çalışma hedefi).
  DateTime? nextBoundary(DateTime now) {
    final last = _last;
    if (last == null || !last.open) return null;
    if (last.kind == SegmentKind.rest) {
      return last.start.add(breakLength(now));
    }
    switch (settings.mode) {
      case FocusMode.pomodoro:
        final before = _workSinceBreak(now, segments.length - 1);
        return last.start.add(Duration(minutes: settings.work) - before);
      case FocusMode.deep:
        // Hedefe ulaşıldıysa sınır yok (fazı değiştirmez, yalnız bir kez haber verilir).
        final reach = last.start.add(
          Duration(minutes: settings.target) - focused(last.start),
        );
        // Blok sonu geçmişse de döner: sayaç hemen ilerletilsin.
        if (_blockEnd(last) case final b? when b.isBefore(reach)) return b;
        return reach.isAfter(now) ? reach : null;
      case FocusMode.free:
        return null;
    }
  }

  /// Blok planlı derin çalışmada açık odak segmentinin blok sonu; blok yoksa null.
  DateTime? _blockEnd(Segment last) {
    if (!settings.blocked) return null;
    final before = _workSinceBreak(last.start, segments.length - 1);
    return last.start.add(Duration(minutes: settings.block!) - before);
  }

  /// Blok planlı derin çalışmada hedefe ulaşılan an; ulaşılmadıysa null.
  DateTime? targetReachedAt(DateTime now) {
    if (!settings.blocked) return null;
    final target = Duration(minutes: settings.target);
    if (focused(now) < target) return null;
    final last = _last;
    if (last == null || !last.open || last.kind != SegmentKind.work) {
      return last?.end ?? now;
    }
    return last.start.add(target - focused(last.start));
  }

  /// Geçmiş sınırları tam anlarında kapatır: Pomodoro odak bloğu (ve blok planlı derin
  /// çalışma bloğu) bitince mola başlar, mola bitince sayaç "bekliyor"a geçer. Derin
  /// çalışma hedefi fazı değiştirmez.
  FocusClock advance(DateTime now) {
    var clock = this;
    for (var i = 0; i < 2; i++) {
      final last = clock._last;
      if (last == null || !last.open) break;
      if (last.kind == SegmentKind.work &&
          clock.settings.mode != FocusMode.pomodoro &&
          !clock.settings.blocked) {
        break;
      }
      final DateTime? boundary;
      if (last.kind == SegmentKind.work && clock.settings.blocked) {
        // Hedef blok sonundan önce (ya da aynı anda) geliyorsa mola açılmaz.
        final reach = last.start.add(
          Duration(minutes: clock.settings.target) - clock.focused(last.start),
        );
        final b = clock._blockEnd(last)!;
        boundary = b.isBefore(reach) ? b : null;
      } else {
        boundary = clock.nextBoundary(now);
      }
      if (boundary == null || boundary.isAfter(now)) break;
      final at = boundary.isBefore(last.start) ? last.start : boundary;
      clock = FocusClock(settings, [
        ...clock.segments.take(clock.segments.length - 1),
        last.closeAt(at),
        if (last.kind == SegmentKind.work) Segment(SegmentKind.rest, at),
      ]);
    }
    return clock;
  }

  /// Açık segmenti [at]'te kapatır (duraklat, bitir, bozulma).
  FocusClock close(DateTime at) {
    final last = _last;
    if (last == null || !last.open) return this;
    final end = at.isBefore(last.start) ? last.start : at;
    return FocusClock(settings, [
      ...segments.take(segments.length - 1),
      last.closeAt(end),
    ]);
  }

  /// Yeni odak bloğu: duraklatmadan, molayı erken bitirerek ya da mola sonunda.
  FocusClock resumeWork(DateTime now) {
    if (phase == FocusPhase.working) return this;
    final closed = close(now);
    return FocusClock(settings, [
      ...closed.segments,
      Segment(SegmentKind.work, now.toUtc()),
    ]);
  }

  /// İsteğe bağlı mola (derin çalışma); uzunluk [breakLength] ile önerilir.
  FocusClock startBreak(DateTime now) {
    if (phase != FocusPhase.working) return this;
    return FocusClock(settings, [
      ...close(now).segments,
      Segment(SegmentKind.rest, now.toUtc()),
    ]);
  }

  /// Kaçış ya da arama [from]–[to] arası odak süresinden düşülür; açık odak segmenti
  /// bölünür. Açık segment mola ya da yoksa değişmez.
  FocusClock gap(DateTime from, DateTime to) {
    final last = _last;
    if (last == null || !last.open || last.kind != SegmentKind.work) {
      return this;
    }
    if (!to.isAfter(last.start)) return this;
    return FocusClock(settings, [
      ...segments.take(segments.length - 1),
      if (from.isAfter(last.start)) last.closeAt(from),
      Segment(SegmentKind.work, to.toUtc()),
    ]);
  }

  List<Map<String, Object?>> toJson() => [for (final s in segments) s.toJson()];

  static List<Segment> segmentsFromJson(List<Object?> json) => [
    for (final s in json) Segment.fromJson((s as Map).cast<String, Object?>()),
  ];
}

/// Pomodoro serisi: en yeniden geriye art arda tamamlanan Pomodoro oturumu; bozulan
/// oturum seriyi sıfırlar (FOCUS-5, D31).
int pomodoroStreak(Iterable<({String mode, String outcome})> newestFirst) {
  var streak = 0;
  for (final s in newestFirst) {
    if (s.mode != FocusMode.pomodoro.name || s.outcome == 'in_progress') {
      continue;
    }
    if (s.outcome != 'completed') break;
    streak++;
  }
  return streak;
}
