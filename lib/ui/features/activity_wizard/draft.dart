import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
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
  VariantDraft(this.name, {this.cancels = false});
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

  bool get isProject => kind == 'project' || kind == 'task';
  bool get hasVariants => kind != 'free_time';
  bool get hasFocus => kind != 'free_time' && kind != 'travel_prep';

  static String _iso(DateTime d) => d.toIso8601String().substring(0, 10);

  Recurrence recurrence() => switch (rec) {
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

  Timing timing() {
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
        ActivitiesCompanion.insert(
          id: newId(),
          kind: kind,
          title: title.trim(),
          categoryId: Value(categoryId),
          rootCategoryKey: Value(categoryId == null ? rootKey : null),
          estimatedMinutes: Value(isProject ? null : duration),
          requiresFocus: Value(hasFocus ? focus : null),
          focusMode: Value(hasFocus && focus == true ? focusMode : null),
        ),
      );
      if (isProject) {
        final total = totalMinutes > 0 ? totalMinutes : null;
        await activities.saveProject(
          activity.id,
          ProjectsCompanion(
            totalMinutes: Value(total),
            deadlineAt: Value(
              deadline == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(
                      cal.wallToUtc(Day.parse(_iso(deadline!)), 23 * 60 + 59) *
                          60000,
                      isUtc: true,
                    ),
            ),
            splitMode: Value(autoSplit && deadline != null ? 'auto' : 'manual'),
            minChunkMinutes: Value(kind == 'task' ? null : minChunk),
            maxChunkMinutes: Value(kind == 'task' ? total : maxChunk),
            dailyCapMinutes: Value(dailyCap),
          ),
        );
        return activity;
      }
      await activities.addRule(
        ScheduleRulesCompanion.insert(
          id: newId(),
          activityId: activity.id,
          recurrence: recurrence(),
          timing: Value(timing()),
          durationMinMinutes: Value(duration),
          durationMaxMinutes: Value(duration),
          flexibility: Value(flex.name),
        ),
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
}

/// Başlangıç tarihi uygulama saatinden (Bugün ile aynı "şimdi"; testte sabit).
final activityDraftProvider = Provider<ActivityDraft>(
  (ref) => ActivityDraft(ref.read(nowProvider).value ?? DateTime.now()),
);
