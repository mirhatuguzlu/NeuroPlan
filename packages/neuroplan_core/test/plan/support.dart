import 'package:neuroplan_core/neuroplan_core.dart';

const istanbul = 'Europe/Istanbul';
final ist = PlanCalendar(istanbul);

/// [date] gününün yerel [hhmm] saati, UTC dakika.
int at(String date, String hhmm, [PlanCalendar? cal]) {
  final c = ClockRef.parse(hhmm);
  return (cal ?? ist).wallToUtc(Day.parse(date), c.hour * 60 + c.minute);
}

/// UTC dakika → yerel "HH:MM".
String hm(int? utcMin, [PlanCalendar? cal]) {
  if (utcMin == null) return '--:--';
  final m = (cal ?? ist).minuteOfDay(utcMin);
  return '${(m ~/ 60).toString().padLeft(2, '0')}:${(m % 60).toString().padLeft(2, '0')}';
}

TimeConstraint atClock(String hhmm, {int dayOffset = 0, int offset = 0}) {
  final c = ClockRef.parse(hhmm, dayOffset: dayOffset);
  return TimeConstraint(ConstraintOp.at, c, offsetMinutes: offset);
}

TimeConstraint clock(ConstraintOp op, String hhmm, {int dayOffset = 0}) =>
    TimeConstraint(op, ClockRef.parse(hhmm, dayOffset: dayOffset));

TimeConstraint rel(
  ConstraintOp op,
  String activityId,
  Edge edge, {
  int offset = 0,
}) => TimeConstraint(op, ActivityRef(activityId, edge), offsetMinutes: offset);

Recurrence daily(String from) =>
    RRuleRecurrence(dtstart: from, rrule: 'FREQ=DAILY');

PlanRule rule(
  String id,
  String activityId,
  Recurrence recurrence, {
  List<TimeConstraint> start = const [],
  List<TimeConstraint> end = const [],
  int? minutes,
  Flexibility flex = Flexibility.fixed,
  List<String> exceptions = const [],
  String? validFrom,
  String? validUntil,
}) => PlanRule(
  id: id,
  activityId: activityId,
  recurrence: recurrence,
  timing: Timing(start: start, end: end),
  durationMin: minutes,
  durationMax: minutes,
  flexibility: flex,
  exceptionDates: exceptions,
  validFrom: validFrom,
  validUntil: validUntil,
);

/// Motoru çalıştırır; kurallardaki aktiviteler verilmemişse kendiliğinden eklenir.
PlanOutput plan({
  required String from,
  String? to,
  String asOf = '2026-11-18T00:00',
  String timezone = istanbul,
  List<PlanRule> rules = const [],
  List<PlanActivity> activities = const [],
  List<PlanVariantGroup> groups = const [],
  List<PlanVariant> variants = const [],
  List<PlanProject> projects = const [],
  List<PlanDayOverride> overrides = const [],
  List<PersistedInstance> instances = const [],
  PlanSettings? settings,
}) {
  final cal = PlanCalendar(timezone);
  final known = {for (final a in activities) a.id};
  final [date, time] = asOf.split('T');
  return const PlanEngine().plan(
    PlanInput(
      settings: settings ?? PlanSettings(timezone: timezone),
      from: from,
      to: to ?? from,
      asOf: at(date, time, cal),
      activities: [
        ...activities,
        for (final id in {
          for (final r in rules) r.activityId,
          for (final p in projects) p.activityId,
          for (final i in instances) i.activityId,
        })
          if (!known.contains(id)) PlanActivity(id: id),
      ],
      rules: rules,
      variantGroups: groups,
      variants: variants,
      projects: projects,
      dayOverrides: overrides,
      instances: instances,
    ),
  );
}

extension PlanOutputX on PlanOutput {
  List<PlannedInstance> of(String activityId, [String? date]) => [
    for (final i in instances)
      if (i.activityId == activityId && (date == null || i.date == date)) i,
  ];

  PlannedInstance one(String activityId, [String? date]) {
    final list = of(activityId, date);
    if (list.length != 1) {
      throw StateError('$activityId/$date: ${list.length} oluşum');
    }
    return list.single;
  }

  /// "HH:MM–HH:MM" (yerel).
  String span(String activityId, [String? date, PlanCalendar? cal]) {
    final i = one(activityId, date);
    return '${hm(i.start, cal)}–${hm(i.end, cal)}';
  }

  List<String> freeOf(String date, [PlanCalendar? cal]) => [
    for (final s in freeSlots[date] ?? const <TimeSlot>[])
      '${hm(s.start, cal)}–${hm(s.end, cal)}',
  ];
}
