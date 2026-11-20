import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../data/plan/plan_source.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../data/local/app_database.dart';
import '../../core/summaries.dart';

enum RecType {
  once,
  daily,
  weekly,
  everyN,
  monthly,
  cycle,
  dates,
  perPeriod,
  follow,
}

enum TimeType { fixed, window, relative, astro, none }

class VariantDraft {
  VariantDraft(this.name, {this.cancels = false, this.id});

  /// Düzenlemede var olan varyantın kimliği (yeni varyantta null).
  final String? id;
  String name;
  bool cancels;
}

/// Aktivite sihirbazının taslağı. Sihirbazdan çıkıp dönünce kaybolmaz.
// shortcut: taslak bellekte tutulur, uygulama kapanınca kaybolur; gerekirse sync_state'e yaz.
class ActivityDraft {
  ActivityDraft(DateTime today) : date = today, start = today;

  String title = '';
  String kind = 'routine';

  /// Seçilen alt kategori ya da yalnız kök (ikisi de null = kategorisiz).
  String? categoryId;
  String? rootKey;

  RecType rec = RecType.daily;
  DateTime date;
  DateTime start;
  Set<int> weekdays = {};
  int everyN = 2;
  bool monthByWeek = false;
  int monthDay = 1;
  int nth = 1;
  int nthWeekday = 1;
  int cycleOn = 4;
  int cycleOff = 4;
  List<DateTime> dates = [];
  int perCount = 3;
  PeriodUnit perUnit = PeriodUnit.week;

  TimeType time = TimeType.fixed;
  int at = 9 * 60;
  int windowFrom = 9 * 60;
  int windowTo = 17 * 60;
  String? relActivity;
  bool relAfterEnd = true;
  int relOffset = 0;
  AstroEvent astro = AstroEvent.sunrise;
  bool astroBefore = false;
  int astroOffset = 0;
  Flexibility flex = Flexibility.fixed;

  int? duration;
  final variants = <VariantDraft>[];
  int defaultVariant = 0;
  bool? focus;
  String focusMode = 'free';

  DateTime? deadline;
  int totalMinutes = 0;
  int? minChunk;
  int? maxChunk;
  int? dailyCap;
  bool autoSplit = true;

  /// Düzenlemede: kaydın kendisi, etkin kuralı ve varyant grubu (yeni taslakta null).
  Activity? editing;
  ScheduleRule? editingRule;
  String? variantGroupId;
  List<String> editingVariantIds = const [];

  /// Düzenlemede dokunulmayan tekrar ve saat aynen yazılır; sihirbazın kuramadığı biçimler
  /// (ör. uyku penceresi) bozulmaz. İlgili adım açılınca null yapılır.
  Recurrence? keepRecurrence;
  Timing? keepTiming;

  bool get isProject => kind == 'project' || kind == 'task';
  bool get hasVariants => kind != 'free_time';
  bool get hasFocus => kind != 'free_time' && kind != 'travel_prep';

  static String _iso(DateTime d) => d.toIso8601String().substring(0, 10);

  Recurrence recurrence() => keepRecurrence ?? _recurrence();

  Recurrence _recurrence() => switch (rec) {
    RecType.once => OnceRecurrence(_iso(date)),
    RecType.daily => RRuleRecurrence(dtstart: _iso(start), rrule: 'FREQ=DAILY'),
    RecType.weekly => RRuleRecurrence(
      dtstart: _iso(start),
      rrule:
          'FREQ=WEEKLY;BYDAY=${[for (final d in weekdays.toList()..sort()) rruleDays[d - 1]].join(',')}',
    ),
    RecType.everyN => RRuleRecurrence(
      dtstart: _iso(start),
      rrule: 'FREQ=DAILY;INTERVAL=$everyN',
    ),
    RecType.monthly => RRuleRecurrence(
      dtstart: _iso(start),
      rrule: monthByWeek
          ? 'FREQ=MONTHLY;BYDAY=$nth${rruleDays[nthWeekday - 1]}'
          : 'FREQ=MONTHLY;BYMONTHDAY=$monthDay',
    ),
    RecType.cycle => CycleRecurrence(
      anchor: _iso(start),
      lengthDays: cycleOn + cycleOff,
      onDays: [for (var i = 0; i < cycleOn; i++) i],
    ),
    RecType.dates => DatesRecurrence([for (final d in dates) _iso(d)]..sort()),
    RecType.perPeriod => PerPeriodRecurrence(count: perCount, unit: perUnit),
    RecType.follow => const FollowRecurrence(),
  };

  Timing timing() => keepTiming ?? _timing();

  Timing _timing() {
    ClockRef clock(int m, {int dayOffset = 0}) =>
        ClockRef(m ~/ 60, m % 60, dayOffset: dayOffset);
    return switch (time) {
      TimeType.fixed => Timing(
        start: [TimeConstraint(ConstraintOp.at, clock(at))],
      ),
      TimeType.window => Timing(
        start: [TimeConstraint(ConstraintOp.notBefore, clock(windowFrom))],
        end: [
          TimeConstraint(
            ConstraintOp.notAfter,
            clock(windowTo, dayOffset: windowTo <= windowFrom ? 1 : 0),
          ),
        ],
      ),
      TimeType.relative when relAfterEnd => Timing(
        start: [
          TimeConstraint(
            ConstraintOp.at,
            ActivityRef(relActivity!, Edge.end),
            offsetMinutes: relOffset,
          ),
        ],
      ),
      TimeType.relative => Timing(
        end: [
          TimeConstraint(
            ConstraintOp.at,
            ActivityRef(relActivity!, Edge.start),
            offsetMinutes: -relOffset,
          ),
        ],
      ),
      TimeType.astro => Timing(
        start: [
          TimeConstraint(
            ConstraintOp.at,
            AstroRef(astro),
            offsetMinutes: astroBefore ? -astroOffset : astroOffset,
          ),
        ],
      ),
      TimeType.none => Timing.none,
    };
  }

  /// Tek işlemde yazar: aktivite → kural → varyantlar → proje ayarları.
  Future<Activity> save(
    AppDatabase db,
    ActivityRepository activities,
    PlanCalendar cal,
  ) {
    return db.transaction(() async {
      final activity = await activities.create(
        _activity().copyWith(id: Value(newId()), kind: Value(kind)),
      );
      if (isProject) {
        await activities.saveProject(activity.id, _project(cal));
        return activity;
      }
      await activities.addRule(
        _rule().copyWith(id: Value(newId()), activityId: Value(activity.id)),
      );
      final named = [
        for (final v in variants)
          if (v.name.trim().isNotEmpty) v,
      ];
      if (hasVariants && named.length >= 2) {
        final group = await activities.createVariantGroup(
          activityId: activity.id,
        );
        final ids = <String>[];
        for (final (i, v) in named.indexed) {
          final row = await activities.addVariant(
            VariantsCompanion.insert(
              id: newId(),
              groupId: group.id,
              name: v.name.trim(),
              sortOrder: Value(i),
              cancelsOccurrence: Value(v.cancels),
            ),
          );
          ids.add(row.id);
        }
        await activities.setDefaultVariant(
          group.id,
          ids[defaultVariant.clamp(0, ids.length - 1)],
        );
      }
      return activity;
    });
  }

  ActivitiesCompanion _activity() => ActivitiesCompanion(
    title: Value(title.trim()),
    categoryId: Value(categoryId),
    rootCategoryKey: Value(categoryId == null ? rootKey : null),
    estimatedMinutes: Value(isProject ? null : duration),
    requiresFocus: Value(hasFocus ? focus : null),
    focusMode: Value(hasFocus && focus == true ? focusMode : null),
  );

  ProjectsCompanion _project(PlanCalendar cal) {
    final total = totalMinutes > 0 ? totalMinutes : null;
    return ProjectsCompanion(
      totalMinutes: Value(total),
      deadlineAt: Value(
        deadline == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                cal.wallToUtc(Day.parse(_iso(deadline!)), 23 * 60 + 59) * 60000,
                isUtc: true,
              ),
      ),
      splitMode: Value(autoSplit && deadline != null ? 'auto' : 'manual'),
      minChunkMinutes: Value(kind == 'task' ? null : minChunk),
      maxChunkMinutes: Value(kind == 'task' ? total : maxChunk),
      dailyCapMinutes: Value(dailyCap),
    );
  }

  ScheduleRulesCompanion _rule() => ScheduleRulesCompanion(
    recurrence: Value(recurrence()),
    timing: Value(timing()),
    durationMinMinutes: Value(duration),
    durationMaxMinutes: Value(duration),
    flexibility: Value(flex.name),
  );

  // ------------------------------------------------------------ düzenleme (D64)

  /// Düzenleme ekranında hangi adım neyi yazar.
  static const activitySteps = {'what', 'category', 'duration', 'focus'};
  static const ruleSteps = {'when', 'time', 'flex', 'duration'};
  static const projectSteps = {'deadline', 'total', 'chunks'};

  /// İşin bugün ve sonrası için geçerli kuralı (bölünmüş kurallardan en yenisi).
  static ScheduleRule? activeRule(
    PlanData data,
    String activityId,
    String today,
  ) =>
      ([
            for (final r in data.rules)
              if (r.activityId == activityId &&
                  (r.validUntil == null || r.validUntil!.compareTo(today) >= 0))
                r,
          ]..sort((a, b) => (a.validFrom ?? '').compareTo(b.validFrom ?? '')))
          .lastOrNull;

  /// Kayıtlı işten taslak; [today] yerel gün ("YYYY-MM-DD"). İş yoksa null.
  static ActivityDraft? edit(PlanData data, String activityId, String today) {
    final a = data.activities[activityId];
    if (a == null) return null;
    final d = ActivityDraft(DateTime.parse(today))
      ..editing = a
      ..title = a.title
      ..kind = a.kind
      ..categoryId = a.categoryId
      ..rootKey = a.categoryId == null ? a.rootCategoryKey : null
      ..duration = a.estimatedMinutes
      ..focus = a.requiresFocus
      ..focusMode = a.focusMode ?? 'free';
    if (data.projectOf(activityId) case final p?) {
      d
        ..deadline = p.deadlineAt == null
            ? null
            : DateTime.parse(
                data.calendar
                    .dayOf(p.deadlineAt!.millisecondsSinceEpoch ~/ 60000)
                    .iso,
              )
        ..totalMinutes = p.totalMinutes ?? 0
        ..minChunk = p.minChunkMinutes
        ..maxChunk = p.maxChunkMinutes
        ..dailyCap = p.dailyCapMinutes
        ..autoSplit = p.splitMode == 'auto' || p.deadlineAt == null;
    }
    if (activeRule(data, activityId, today) case final r?) {
      d
        ..editingRule = r
        ..keepRecurrence = r.recurrence
        ..keepTiming = r.timing
        ..flex = Flexibility.fromJson(r.flexibility)
        ..duration =
            r.durationMaxMinutes ?? r.durationMinMinutes ?? a.estimatedMinutes
        .._readRecurrence(r.recurrence)
        .._readTiming(r.timing);
    }
    final group = data.groups
        .where((g) => g.activityId == activityId)
        .firstOrNull;
    if (group != null) {
      final list = [
        for (final v in data.variants)
          if (v.groupId == group.id) v,
      ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      d
        ..variantGroupId = group.id
        ..editingVariantIds = [for (final v in list) v.id]
        ..variants.addAll([
          for (final v in list)
            VariantDraft(v.name, cancels: v.cancelsOccurrence, id: v.id),
        ])
        ..defaultVariant = math.max(
          0,
          list.indexWhere((v) => v.id == group.defaultVariantId),
        );
    }
    return d;
  }

  void _readRecurrence(Recurrence r) {
    DateTime day(String iso) => DateTime.parse(iso);
    switch (r) {
      case OnceRecurrence(:final date):
        rec = RecType.once;
        this.date = day(date);
      case CycleRecurrence(:final anchor, :final lengthDays, :final onDays):
        rec = RecType.cycle;
        start = day(anchor);
        cycleOn = onDays.length;
        cycleOff = math.max(1, lengthDays - onDays.length);
      case DatesRecurrence(:final dates):
        rec = RecType.dates;
        this.dates = [for (final x in dates) day(x)];
      case PerPeriodRecurrence(:final count, :final unit):
        rec = RecType.perPeriod;
        perCount = count;
        perUnit = unit;
      case FollowRecurrence():
        rec = RecType.follow;
      case RRuleRecurrence(:final dtstart, :final rrule):
        start = day(dtstart);
        final p = {
          for (final kv in rrule.split(';'))
            if (kv.contains('=')) kv.split('=')[0]: kv.split('=')[1],
        };
        final interval = int.tryParse(p['INTERVAL'] ?? '1') ?? 1;
        final byDay = p['BYDAY'];
        switch (p['FREQ']) {
          case 'DAILY':
            rec = interval > 1 ? RecType.everyN : RecType.daily;
            if (interval > 1) everyN = interval;
          case 'WEEKLY' when byDay != null:
            rec = RecType.weekly;
            weekdays = {
              for (final x in byDay.split(','))
                if (rruleDays.contains(x)) rruleDays.indexOf(x) + 1,
            };
          case 'MONTHLY':
            rec = RecType.monthly;
            final m = byDay == null
                ? null
                : RegExp(r'^([+-]?\d+)([A-Z]{2})$').firstMatch(byDay);
            if (m != null && rruleDays.contains(m.group(2))) {
              monthByWeek = true;
              nth = int.parse(m.group(1)!);
              nthWeekday = rruleDays.indexOf(m.group(2)!) + 1;
            } else {
              monthDay = int.tryParse(p['BYMONTHDAY'] ?? '') ?? monthDay;
            }
        }
    }
  }

  void _readTiming(Timing t) {
    if (t.start.isEmpty && t.end.isEmpty) {
      time = TimeType.none;
      return;
    }
    for (final (isStart, list) in [(true, t.start), (false, t.end)]) {
      for (final c in list) {
        switch (c.ref) {
          case ActivityRef(:final activityId):
            time = TimeType.relative;
            relActivity = activityId;
            relAfterEnd = isStart;
            relOffset = c.offsetMinutes.abs();
            return;
          case AstroRef(:final event):
            time = TimeType.astro;
            astro = event;
            astroBefore = c.offsetMinutes < 0;
            astroOffset = c.offsetMinutes.abs();
            return;
          case ClockRef():
        }
      }
    }
    int? clock(List<TimeConstraint> side, ConstraintOp op) =>
        switch (side.where((c) => c.op == op).firstOrNull?.ref) {
          ClockRef(:final hour, :final minute) => hour * 60 + minute,
          _ => null,
        };
    if (clock(t.start, ConstraintOp.at) case final m?) {
      time = TimeType.fixed;
      at = m;
    } else if ((
          clock(t.start, ConstraintOp.notBefore),
          clock(t.end, ConstraintOp.notAfter),
        )
        case (final from?, final to?)) {
      time = TimeType.window;
      windowFrom = from;
      windowTo = to;
    }
  }

  /// Kuralın ilk olası günü: bugünden önceyse geçmişte oluşum üretmiş olabilir.
  static String _firstDay(ScheduleRule r, PlanCalendar cal) =>
      r.validFrom ??
      switch (r.recurrence) {
        OnceRecurrence(:final date) => date,
        RRuleRecurrence(:final dtstart) => dtstart,
        CycleRecurrence(:final anchor) => anchor,
        DatesRecurrence(:final dates) when dates.isNotEmpty => dates.first,
        _ => cal.dayOf(r.createdAt.millisecondsSinceEpoch ~/ 60000).iso,
      };

  /// Düzenleme ekranındaki tek adımın sonucunu yazar. Saat, tekrar, süre ya da esneklik
  /// değişir ve kural geçmişte oluşum üretmiş olabilirse eski kural dün biter, yenisi
  /// bugün başlar: geçmiş plan ve analizler korunur (D64).
  Future<void> update(
    AppDatabase db,
    ActivityRepository activities,
    PlanCalendar cal, {
    required String step,
    required String today,
  }) {
    final a = editing!;
    return db.transaction(() async {
      if (activitySteps.contains(step)) {
        await activities.update(a.id, _activity());
      }
      if (isProject && projectSteps.contains(step)) {
        await activities.saveProject(a.id, _project(cal));
      }
      if (!isProject && ruleSteps.contains(step)) {
        final r = editingRule;
        final rule = _rule();
        if (r == null) {
          await activities.addRule(
            rule.copyWith(id: Value(newId()), activityId: Value(a.id)),
          );
        } else if (_firstDay(r, cal).compareTo(today) < 0) {
          await activities.updateRule(
            r.id,
            ScheduleRulesCompanion(
              validUntil: Value(Day.parse(today).add(-1).iso),
            ),
          );
          await activities.addRule(
            rule.copyWith(
              id: Value(newId()),
              activityId: Value(a.id),
              validFrom: Value(today),
              validUntil: Value(r.validUntil),
              exceptionDates: Value(r.exceptionDates),
            ),
          );
        } else {
          await activities.updateRule(r.id, rule);
        }
      }
      if (hasVariants && step == 'variants') {
        await _saveVariants(activities, a.id);
      }
    });
  }

  Future<void> _saveVariants(
    ActivityRepository activities,
    String activityId,
  ) async {
    final named = [
      for (final v in variants)
        if (v.name.trim().isNotEmpty) v,
    ];
    final keep = named.length >= 2;
    final kept = {
      if (keep)
        for (final v in named) ?v.id,
    };
    for (final id in editingVariantIds) {
      if (!kept.contains(id)) await activities.deleteVariant(id);
    }
    var group = variantGroupId;
    if (!keep) {
      if (group != null) await activities.setDefaultVariant(group, null);
      return;
    }
    group ??= (await activities.createVariantGroup(activityId: activityId)).id;
    final ids = <String>[];
    for (final (i, v) in named.indexed) {
      final fields = VariantsCompanion(
        name: Value(v.name.trim()),
        sortOrder: Value(i),
        cancelsOccurrence: Value(v.cancels),
      );
      ids.add(
        v.id != null
            ? (await activities.updateVariant(v.id!, fields)).id
            : (await activities.addVariant(
                fields.copyWith(id: Value(newId()), groupId: Value(group)),
              )).id,
      );
    }
    await activities.setDefaultVariant(
      group,
      ids[defaultVariant.clamp(0, ids.length - 1)],
    );
  }
}

/// Başlangıç tarihi uygulama saatinden (Bugün ile aynı "şimdi"; testte sabit).
final activityDraftProvider = Provider<ActivityDraft>(
  (ref) => ActivityDraft(ref.read(nowProvider).value ?? DateTime.now()),
);
