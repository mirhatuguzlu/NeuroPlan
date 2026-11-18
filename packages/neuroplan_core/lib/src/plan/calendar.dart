import 'dart:math' as math;

import 'package:rrule/rrule.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../model/recurrence.dart';

const _msPerDay = 86400000;
const _msPerMin = 60000;

/// Yerel takvim günü (1970-01-01'den gün sayısı); veritabanındaki `YYYY-MM-DD` ile aynı.
extension type const Day(int index) implements Object {
  factory Day.parse(String iso) => Day(
    DateTime.parse('${iso}T00:00:00Z').millisecondsSinceEpoch ~/ _msPerDay,
  );

  DateTime get utc =>
      DateTime.fromMillisecondsSinceEpoch(index * _msPerDay, isUtc: true);
  String get iso => utc.toIso8601String().substring(0, 10);

  /// 1 = pazartesi … 7 = pazar.
  int get weekday => utc.weekday;
  Day add(int days) => Day(index + days);
  bool isBefore(Day other) => index < other.index;
  bool isAfter(Day other) => index > other.index;
}

var _tzReady = false;

/// Kullanıcının saat dilimindeki duvar saati ↔ UTC dakika dönüşümleri.
final class PlanCalendar {
  PlanCalendar(String timezone) : _loc = _location(timezone);

  final tz.Location _loc;

  static tz.Location _location(String name) {
    if (!_tzReady) {
      tzdata.initializeTimeZones();
      _tzReady = true;
    }
    return tz.getLocation(name);
  }

  int _offsetMs(int utcMs) => _loc.timeZone(utcMs).offset.inMilliseconds;

  /// [day] gününün [minuteOfDay] duvar saati, UTC dakika olarak (docs/DB_SCHEMA.md §3.4.2):
  /// yaz saati boşluğuna düşen saat ileri kayar, tekrar eden saatte ilki alınır.
  int wallToUtc(Day day, int minuteOfDay) {
    final w = day.index * _msPerDay + minuteOfDay * _msPerMin;
    final before = w - _offsetMs(w - _msPerDay);
    final after = w - _offsetMs(w + _msPerDay);
    bool exists(int t) => t + _offsetMs(t) == w;
    final int t;
    if (exists(before) && exists(after)) {
      t = math.min(before, after);
    } else if (exists(after)) {
      t = after;
    } else {
      t = before; // boşluk ya da tek eşleşme: "önceki" ofset saati ileri taşır
    }
    return t ~/ _msPerMin;
  }

  int dayStart(Day day) => wallToUtc(day, 0);
  int dayEnd(Day day) => wallToUtc(day.add(1), 0);

  int _localMs(int utcMin) {
    final ms = utcMin * _msPerMin;
    return ms + _offsetMs(ms);
  }

  Day dayOf(int utcMin) => Day((_localMs(utcMin) / _msPerDay).floor());

  /// Yerel duvar saati (0–1439).
  int minuteOfDay(int utcMin) => (_localMs(utcMin) ~/ _msPerMin) % 1440;
}

/// Tekrar kurallarının gün kümesi; RRULE genişletmeleri önbelleğe alınır.
final class RecurrenceDays {
  RecurrenceDays(this.from, this.to);

  /// Çalışma aralığı (ikisi de dahil).
  final Day from;
  final Day to;
  final _cache = <String, Set<int>>{};

  bool occurs(Recurrence r, Day day) => switch (r) {
    OnceRecurrence(:final date) => Day.parse(date) == day,
    DatesRecurrence(:final dates) => _set(
      'd:${dates.join(',')}',
      () => {for (final d in dates) Day.parse(d).index},
    ).contains(day.index),
    CycleRecurrence(:final anchor, :final lengthDays, :final onDays) =>
      !day.isBefore(Day.parse(anchor)) &&
          onDays.contains((day.index - Day.parse(anchor).index) % lengthDays),
    RRuleRecurrence(:final dtstart, :final rrule) => _set(
      'r:$dtstart:$rrule',
      () => _expand(dtstart, rrule),
    ).contains(day.index),
    PerPeriodRecurrence() || FollowRecurrence() => false,
  };

  Set<int> _set(String key, Set<int> Function() build) =>
      _cache.putIfAbsent(key, build);

  Set<int> _expand(String dtstart, String rrule) {
    final start = Day.parse(dtstart);
    if (start.isAfter(to)) return const {};
    final rule = RecurrenceRule.fromString('RRULE:$rrule');
    return {
      for (final d in rule.getInstances(
        start: start.utc,
        after: (start.isAfter(from) ? start : from).utc,
        includeAfter: true,
        before: to.utc,
        includeBefore: true,
      ))
        d.millisecondsSinceEpoch ~/ _msPerDay,
    };
  }
}
