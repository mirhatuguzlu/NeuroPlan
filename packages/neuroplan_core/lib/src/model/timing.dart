import 'json_checks.dart';

/// Bir kısıtın yönü.
enum ConstraintOp {
  at('at'),
  notBefore('not_before'),
  notAfter('not_after');

  const ConstraintOp(this.json);
  final String json;

  static ConstraintOp fromJson(Object? v) => values.firstWhere(
    (e) => e.json == v,
    orElse: () => fail('Geçersiz op: $v'),
  );
}

/// Astronomik çapalar; namaz vakitleri yalnız profilde yöntem seçiliyse kullanılır.
enum AstroEvent { sunrise, sunset, fajr, dhuhr, asr, maghrib, isha }

enum Edge { start, end }

T _byName<T extends Enum>(List<T> values, Object? v, String field) =>
    values.firstWhere((e) => e.name == v, orElse: () => fail('$field: $v'));

int _dayOffset(Map<String, Object?> json) {
  final v = json['day_offset'] ?? 0;
  check(v is int && v >= -1 && v <= 1, 'day_offset -1..1 olmalı');
  return v as int;
}

/// Bir kısıtın neye göre ölçüldüğü.
sealed class TimeRef {
  const TimeRef();

  factory TimeRef.fromJson(Map<String, Object?> json) => switch (json) {
    {'clock': final String clock} => ClockRef.parse(
      clock,
      dayOffset: _dayOffset(json),
    ),
    {'astro': final String astro} => AstroRef(
      _byName(AstroEvent.values, astro, 'astro'),
      dayOffset: _dayOffset(json),
    ),
    {'activity_id': final String id, 'edge': final String edge} =>
      isUuid(id)
          ? ActivityRef(id, _byName(Edge.values, edge, 'edge'))
          : fail('activity_id UUID olmalı: $id'),
    _ => fail('Geçersiz ref: $json'),
  };

  Map<String, Object?> toJson();
}

/// Duvar saati; [dayOffset] gece yarısını aşan kısıtlar içindir.
final class ClockRef extends TimeRef {
  const ClockRef(this.hour, this.minute, {this.dayOffset = 0});

  factory ClockRef.parse(String hhmm, {int dayOffset = 0}) {
    final m = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').firstMatch(hhmm);
    if (m == null) fail('Saat HH:MM olmalı: $hhmm');
    return ClockRef(
      int.parse(m.group(1)!),
      int.parse(m.group(2)!),
      dayOffset: dayOffset,
    );
  }

  final int hour;
  final int minute;
  final int dayOffset;

  @override
  Map<String, Object?> toJson() => {
    'clock':
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
    if (dayOffset != 0) 'day_offset': dayOffset,
  };
}

final class AstroRef extends TimeRef {
  const AstroRef(this.event, {this.dayOffset = 0});
  final AstroEvent event;
  final int dayOffset;

  @override
  Map<String, Object?> toJson() => {
    'astro': event.name,
    if (dayOffset != 0) 'day_offset': dayOffset,
  };
}

/// Başka bir aktivitenin aynı günkü oluşumunun başı ya da sonu.
final class ActivityRef extends TimeRef {
  const ActivityRef(this.activityId, this.edge);
  final String activityId;
  final Edge edge;

  @override
  Map<String, Object?> toJson() => {
    'activity_id': activityId,
    'edge': edge.name,
  };
}

final class TimeConstraint {
  const TimeConstraint(this.op, this.ref, {this.offsetMinutes = 0});

  factory TimeConstraint.fromJson(Object? json) {
    if (json is! Map<String, Object?>) fail('Kısıt nesne olmalı: $json');
    final offset = json['offset_minutes'] ?? 0;
    check(
      offset is int && offset.abs() <= 1440,
      'offset_minutes -1440..1440 olmalı',
    );
    final ref = json['ref'];
    if (ref is! Map<String, Object?>) fail('ref nesne olmalı');
    return TimeConstraint(
      ConstraintOp.fromJson(json['op']),
      TimeRef.fromJson(ref),
      offsetMinutes: offset as int,
    );
  }

  final ConstraintOp op;
  final TimeRef ref;
  final int offsetMinutes;

  Map<String, Object?> toJson() => {
    'op': op.json,
    'ref': ref.toJson(),
    if (offsetMinutes != 0) 'offset_minutes': offsetMinutes,
  };
}

/// Zaman kısıtları (docs/DB_SCHEMA.md §3.4.2). Boş = saat yok ("bugün bir ara").
/// `schedule_rules.timing` ve `variants.timing` jsonb'si.
final class Timing {
  const Timing({this.start = const [], this.end = const []});

  static const none = Timing();

  /// Geçersiz girdide [FormatException] atar; sunucuda `is_valid_timing`.
  factory Timing.fromJson(Map<String, Object?> json) {
    check(
      json.keys.every((k) => k == 'start' || k == 'end'),
      'timing yalnız start/end içerebilir',
    );
    List<TimeConstraint> side(String key) {
      final v = json[key] ?? const [];
      if (v is! List) fail('$key liste olmalı');
      final list = [for (final c in v) TimeConstraint.fromJson(c)];
      check(
        list.where((c) => c.op == ConstraintOp.at).length <= 1,
        '$key içinde en fazla bir "at" olabilir',
      );
      return list;
    }

    return Timing(start: side('start'), end: side('end'));
  }

  final List<TimeConstraint> start;
  final List<TimeConstraint> end;

  /// Çapa olarak kullanılan aktiviteler (`follow` ve döngü kontrolü için).
  Set<String> get anchorActivityIds => {
    for (final c in [...start, ...end])
      if (c.ref case ActivityRef(:final activityId)) activityId,
  };

  Map<String, Object?> toJson() => {
    if (start.isNotEmpty) 'start': [for (final c in start) c.toJson()],
    if (end.isNotEmpty) 'end': [for (final c in end) c.toJson()],
  };
}
