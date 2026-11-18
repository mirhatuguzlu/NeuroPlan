import 'json_checks.dart';

const _day = '(MO|TU|WE|TH|FR|SA|SU)';
const _rrulePart =
    '(FREQ=(DAILY|WEEKLY|MONTHLY|YEARLY)'
    '|(INTERVAL|COUNT)=[1-9][0-9]{0,3}'
    '|BYDAY=[+-]?[0-9]{0,2}$_day(,[+-]?[0-9]{0,2}$_day)*'
    '|(BYMONTHDAY|BYMONTH|BYSETPOS)=[+-]?[0-9]{1,3}(,[+-]?[0-9]{1,3})*'
    '|UNTIL=[0-9]{8}(T[0-9]{6}Z?)?'
    '|WKST=$_day)';

/// Desteklenen RFC 5545 alt kümesi (docs/DB_SCHEMA.md §3.4.1). Aynı desen
/// sunucuda `is_valid_recurrence` içinde; birini değiştiren ikisini değiştirir.
final rrulePattern = RegExp('^$_rrulePart(;$_rrulePart)*\$');

/// Bir kuralın hangi günlerde oluştuğu. `schedule_rules.recurrence` jsonb'si.
sealed class Recurrence {
  const Recurrence();

  /// Geçersiz girdide [FormatException] atar.
  factory Recurrence.fromJson(Map<String, Object?> json) {
    final Recurrence r = switch (json) {
      {'type': 'once', 'date': final String date} => OnceRecurrence(date),
      {
        'type': 'rrule',
        'dtstart': final String dtstart,
        'rrule': final String rrule,
      } =>
        RRuleRecurrence(dtstart: dtstart, rrule: rrule),
      {
        'type': 'cycle',
        'anchor': final String anchor,
        'length_days': final int lengthDays,
        'on_days': final List<Object?> onDays,
      } =>
        CycleRecurrence(
          anchor: anchor,
          lengthDays: lengthDays,
          onDays: intList(onDays, 'on_days'),
        ),
      {'type': 'dates', 'dates': final List<Object?> dates} => DatesRecurrence(
        stringList(dates, 'dates'),
      ),
      {
        'type': 'per_period',
        'count': final int count,
        'unit': final String unit,
      } =>
        PerPeriodRecurrence(count: count, unit: PeriodUnit.fromJson(unit)),
      {'type': 'follow'} => const FollowRecurrence(),
      _ => fail('Geçersiz tekrar: $json'),
    };
    r.validate();
    return r;
  }

  Map<String, Object?> toJson();

  /// Kuralları [FormatException] ile zorlar.
  void validate();
}

/// Tek seferlik.
final class OnceRecurrence extends Recurrence {
  const OnceRecurrence(this.date);
  final String date;

  @override
  Map<String, Object?> toJson() => {'type': 'once', 'date': date};

  @override
  void validate() => check(isIsoDate(date), 'once.date geçersiz: $date');
}

/// Takvim desenleri: günlük, haftanın günleri, her N gün, ayın N. haftası…
final class RRuleRecurrence extends Recurrence {
  const RRuleRecurrence({required this.dtstart, required this.rrule});
  final String dtstart;
  final String rrule;

  @override
  Map<String, Object?> toJson() => {
    'type': 'rrule',
    'dtstart': dtstart,
    'rrule': rrule,
  };

  @override
  void validate() {
    check(isIsoDate(dtstart), 'rrule.dtstart geçersiz: $dtstart');
    check(rrulePattern.hasMatch(rrule), 'Desteklenmeyen RRULE: $rrule');
    check(
      'FREQ='.allMatches(rrule).length == 1,
      'RRULE tam bir FREQ içermeli: $rrule',
    );
  }
}

/// Dönüşümlü desen: [anchor]'dan başlayan [lengthDays] günlük döngüde
/// [onDays] ofsetlerinde oluşur (ör. 2 hafta açık 1 hafta kapalı).
final class CycleRecurrence extends Recurrence {
  const CycleRecurrence({
    required this.anchor,
    required this.lengthDays,
    required this.onDays,
  });
  final String anchor;
  final int lengthDays;
  final List<int> onDays;

  @override
  Map<String, Object?> toJson() => {
    'type': 'cycle',
    'anchor': anchor,
    'length_days': lengthDays,
    'on_days': onDays,
  };

  @override
  void validate() {
    check(isIsoDate(anchor), 'cycle.anchor geçersiz: $anchor');
    check(
      lengthDays >= 1 && lengthDays <= 366,
      'cycle.length_days 1–366 olmalı',
    );
    check(onDays.isNotEmpty, 'cycle.on_days boş olamaz');
    for (var i = 0; i < onDays.length; i++) {
      check(
        onDays[i] >= 0 && onDays[i] < lengthDays,
        'cycle.on_days 0..length_days-1 arasında olmalı',
      );
      check(
        i == 0 || onDays[i] > onDays[i - 1],
        'cycle.on_days artan ve tekrarsız olmalı',
      );
    }
  }
}

/// Elle seçilmiş tarih listesi.
final class DatesRecurrence extends Recurrence {
  const DatesRecurrence(this.dates);
  final List<String> dates;

  @override
  Map<String, Object?> toJson() => {'type': 'dates', 'dates': dates};

  @override
  void validate() {
    check(dates.isNotEmpty && dates.length <= 366, 'dates 1–366 öğe içermeli');
    check(dates.every(isIsoDate), 'dates içinde geçersiz tarih var');
  }
}

enum PeriodUnit {
  day,
  week,
  month;

  static PeriodUnit fromJson(String v) => PeriodUnit.values.firstWhere(
    (u) => u.name == v,
    orElse: () => fail('per_period.unit geçersiz: $v'),
  );
}

/// Gün ve saat vermeden "haftada 3 kez".
final class PerPeriodRecurrence extends Recurrence {
  const PerPeriodRecurrence({required this.count, required this.unit});
  final int count;
  final PeriodUnit unit;

  @override
  Map<String, Object?> toJson() => {
    'type': 'per_period',
    'count': count,
    'unit': unit.name,
  };

  @override
  void validate() =>
      check(count >= 1 && count <= 31, 'per_period.count 1–31 olmalı');
}

/// Zaman kısıtındaki çapa aktivitelerin hepsi o gün oluşursa oluşur.
final class FollowRecurrence extends Recurrence {
  const FollowRecurrence();

  @override
  Map<String, Object?> toJson() => {'type': 'follow'};

  @override
  void validate() {}
}
