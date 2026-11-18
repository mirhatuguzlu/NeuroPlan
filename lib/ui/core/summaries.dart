import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'format.dart';

const rruleDays = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

/// Tekrarın tek satırlık özeti ("Her pzt, çar", "Haftada 3 kez").
String recurrenceText(BuildContext context, Recurrence r) {
  final l = context.l10n;
  switch (r) {
    case OnceRecurrence(:final date):
      return dateText(context, date);
    case CycleRecurrence(:final lengthDays, :final onDays):
      return l.recCycle(lengthDays, onDays.length);
    case DatesRecurrence(:final dates):
      return l.recDates(dates.length);
    case PerPeriodRecurrence(:final count, :final unit):
      return l.recPerPeriod(unit.name, count);
    case FollowRecurrence():
      return l.recFollow;
    case RRuleRecurrence(:final rrule):
      final parts = {
        for (final p in rrule.split(';'))
          if (p.contains('=')) p.split('=')[0]: p.split('=')[1],
      };
      final interval = int.tryParse(parts['INTERVAL'] ?? '1') ?? 1;
      final byDay = parts['BYDAY'];
      switch (parts['FREQ']) {
        case 'DAILY':
          return interval == 1 ? l.recDaily : l.recEveryNDays(interval);
        case 'WEEKLY' when byDay != null && interval == 1:
          return l.recWeekdays(
            [
              for (final d in byDay.split(','))
                weekdayShort(context, rruleDays.indexOf(d) + 1),
            ].join(', '),
          );
        case 'MONTHLY' when parts['BYMONTHDAY'] != null:
          return l.recMonthDay(int.parse(parts['BYMONTHDAY']!));
        case 'MONTHLY' when byDay != null:
          final m = RegExp(r'^([+-]?\d+)([A-Z]{2})$').firstMatch(byDay);
          if (m == null) break;
          final n = int.parse(m.group(1)!);
          final day = weekdayLong(context, rruleDays.indexOf(m.group(2)!) + 1);
          return n < 0 ? l.recMonthLast(day) : l.recMonthNth(n, day);
      }
      return l.recCustom;
  }
}

/// Zaman kısıtının özeti ("09:00", "14:00–18:00 arası", "Ders işine bağlı").
String timingText(
  BuildContext context,
  Timing t,
  String Function(String activityId) titleOf,
) {
  final l = context.l10n;
  final all = [...t.start, ...t.end];
  if (all.isEmpty) return l.timeNone;
  for (final c in all) {
    if (c.ref case ActivityRef(:final activityId)) {
      return l.timeRelative(titleOf(activityId));
    }
  }
  for (final c in all) {
    if (c.ref case AstroRef(:final event)) {
      return l.timeAstro(l.astroEvent(event.name));
    }
  }
  String? clock(List<TimeConstraint> side, ConstraintOp op) {
    for (final c in side) {
      if (c.op == op && c.ref is ClockRef) {
        final r = c.ref as ClockRef;
        return clockOfDay(context, r.hour * 60 + r.minute);
      }
    }
    return null;
  }

  final startAt = clock(t.start, ConstraintOp.at);
  final endAt = clock(t.end, ConstraintOp.at);
  if (startAt != null) {
    return endAt != null ? l.timeRange(startAt, endAt) : startAt;
  }
  final from = clock(t.start, ConstraintOp.notBefore);
  final to =
      clock(t.end, ConstraintOp.notAfter) ??
      clock(t.start, ConstraintOp.notAfter);
  if (from != null && to != null) return l.timeWindow(from, to);
  return endAt ?? from ?? to ?? l.timeNone;
}
