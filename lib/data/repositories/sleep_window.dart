import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';
import '../plan/plan_source.dart';
import 'activity_repository.dart';

/// Uyku penceresi sıradan, kesin bir aktivitedir ve motor onu dolu blok olarak korur.
/// Ayrı bir şema alanı yoktur. Profil ekranı onu şu izle bulur: Dinlenme ve Uyku
/// kökünde, başlangıcı ve bitişi saat olan kural.
class SleepWindow {
  const SleepWindow(this.activityId, this.ruleId, this.bed, this.wake);

  final String activityId;
  final String ruleId;

  /// Dakika (0–1439).
  final int bed;
  final int wake;

  int get minutes => (wake - bed) % 1440;

  static SleepWindow? find(PlanData data) {
    for (final r in data.rules) {
      // Bitiş tarihli kural, düzenlemeyle biten eski kuraldır (D64).
      if (data.activities[r.activityId]?.rootCategoryKey != 'rest_sleep' ||
          r.validUntil != null) {
        continue;
      }
      final start = r.timing.start.firstOrNull;
      final end = r.timing.end.firstOrNull;
      if (start case TimeConstraint(
        op: ConstraintOp.at,
        ref: ClockRef(hour: final bh, minute: final bm),
      )) {
        if (end case TimeConstraint(
          op: ConstraintOp.at,
          ref: ClockRef(hour: final wh, minute: final wm),
        )) {
          return SleepWindow(r.activityId, r.id, bh * 60 + bm, wh * 60 + wm);
        }
      }
    }
    return null;
  }

  static Timing timing(int bed, int wake) => Timing(
    start: [TimeConstraint(ConstraintOp.at, ClockRef(bed ~/ 60, bed % 60))],
    end: [
      TimeConstraint(
        ConstraintOp.at,
        ClockRef(wake ~/ 60, wake % 60, dayOffset: wake <= bed ? 1 : 0),
      ),
    ],
  );

  /// Yoksa "her gün, kesin" kuralıyla oluşturur, varsa saatlerini günceller. Uyku hedefi
  /// ayrı bir ayardır; pencere onu değiştirmez (D54).
  static Future<void> save({
    required AppDatabase db,
    required ActivityRepository activities,
    required SleepWindow? existing,
    required String title,
    required String today,
    required int bed,
    required int wake,
  }) => db.transaction(() async {
    final t = timing(bed, wake);
    if (existing != null) {
      await activities.updateRule(
        existing.ruleId,
        ScheduleRulesCompanion(timing: Value(t)),
      );
    } else {
      final a = await activities.create(
        ActivitiesCompanion.insert(
          id: newId(),
          kind: 'routine',
          title: title,
          rootCategoryKey: const Value('rest_sleep'),
        ),
      );
      await activities.addRule(
        ScheduleRulesCompanion.insert(
          id: newId(),
          activityId: a.id,
          recurrence: RRuleRecurrence(dtstart: today, rrule: 'FREQ=DAILY'),
          timing: Value(t),
          flexibility: const Value('fixed'),
        ),
      );
    }
  });
}
