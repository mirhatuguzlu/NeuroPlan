import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';
import '../sync/local_writer.dart';

/// Gün kuralları ve somut oluşumlar (docs/DB_SCHEMA.md §3.7–3.8).
class PlanRepository {
  PlanRepository(this._db, this._writer);

  final AppDatabase _db;
  final LocalWriter _writer;

  Stream<List<DayOverride>> watchDayOverrides() => (_db.select(
    _db.dayOverrides,
  )..where((o) => o.deletedAt.isNull())).watch();

  /// Tek bir gün ([DayOverridesCompanion.date]) ya da tekrar eden gün
  /// ([DayOverridesCompanion.recurrence]); tam olarak biri verilmeli.
  Future<DayOverride> addDayOverride(DayOverridesCompanion data) {
    final hasDate = data.date.present && data.date.value != null;
    final hasRecurrence =
        data.recurrence.present && data.recurrence.value != null;
    if (hasDate == hasRecurrence) {
      throw ArgumentError('Gün kuralı ya tarih ya tekrar içermeli');
    }
    return _writer.insert(
      _db.dayOverrides,
      data.id.present ? data : data.copyWith(id: Value(newId())),
    );
  }

  Future<void> deleteDayOverride(String id) =>
      _writer.softDelete(_db.dayOverrides, id);

  Stream<List<PlanInstance>> watchDay(String occurrenceDate) =>
      (_db.select(_db.planInstances)
            ..where(
              (i) =>
                  i.occurrenceDate.equals(occurrenceDate) &
                  i.deletedAt.isNull(),
            )
            ..orderBy([(i) => OrderingTerm(expression: i.startAt)]))
          .watch();

  /// Kural oluşumu deterministik kimlikle yazılır: iki cihaz aynı oluşumu üretse de tek
  /// satır olur. Elle düzenlenmiş ya da durumu değişmiş oluşuma motor dokunmaz.
  Future<PlanInstance> upsertRuleInstance({
    required String ruleId,
    required String activityId,
    required String occurrenceDate,
    DateTime? startAt,
    DateTime? endAt,
    int? engineVersion,
  }) async {
    final id = ruleInstanceId(ruleId, occurrenceDate);
    final existing = await _writer.find(_db.planInstances, id);
    final times = PlanInstancesCompanion(
      startAt: Value(startAt),
      endAt: Value(endAt),
      engineVersion: Value(engineVersion),
    );
    if (existing == null) {
      return _writer.insert(
        _db.planInstances,
        times.copyWith(
          id: Value(id),
          activityId: Value(activityId),
          ruleId: Value(ruleId),
          occurrenceDate: Value(occurrenceDate),
          source: const Value('rule'),
        ),
      );
    }
    if (existing.isManual || existing.status != 'planned') return existing;
    return _writer.update(_db.planInstances, id, times);
  }

  /// Kullanıcının saat/süre düzenlemesi; motor artık bu oluşumu yeniden yazmaz.
  Future<PlanInstance> reschedule(
    String id, {
    DateTime? startAt,
    DateTime? endAt,
  }) => _writer.update(
    _db.planInstances,
    id,
    PlanInstancesCompanion(
      startAt: Value(startAt),
      endAt: Value(endAt),
      isManual: const Value(true),
    ),
  );

  Future<PlanInstance> setStatus(String id, String status) => _writer.update(
    _db.planInstances,
    id,
    PlanInstancesCompanion(status: Value(status)),
  );

  /// O gün uygulanacak varyant; null = grubun varsayılanı.
  Future<PlanInstance> chooseVariant(String id, String? variantId) =>
      _writer.update(
        _db.planInstances,
        id,
        PlanInstancesCompanion(variantId: Value(variantId)),
      );
}
