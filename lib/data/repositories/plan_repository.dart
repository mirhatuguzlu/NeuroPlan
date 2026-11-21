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

  /// Motorun bellekte ürettiği oluşumu kullanıcı dokunduğunda satıra yazar (D22):
  /// satır yoksa motorun deterministik kimliğiyle eklenir, varsa [fields] güncellenir.
  Future<PlanInstance> touch(
    PlannedInstance instance,
    PlanInstancesCompanion fields,
  ) async {
    final existing = await _writer.find(_db.planInstances, instance.id);
    if (existing != null) {
      return _writer.update(_db.planInstances, instance.id, fields);
    }
    return _writer.insert(
      _db.planInstances,
      fields.copyWith(
        id: Value(instance.id),
        activityId: Value(instance.activityId),
        ruleId: Value(instance.ruleId),
        occurrenceDate: Value(instance.date),
        source: Value(instance.source.name),
        variantId: fields.variantId.present
            ? fields.variantId
            : Value(instance.variantId),
      ),
    );
  }

  /// "Bitti": gerçek bitiş [now] kaydedilir; bu işe bağlı göreli işler buna göre kayar.
  Future<PlanInstance> complete(PlannedInstance i, DateTime now) {
    final end = now.toUtc();
    final length = i.isTimed ? i.end! - i.start! : 0;
    final planned = i.start == null ? null : _utc(i.start!);
    final start = planned != null && planned.isBefore(end)
        ? planned
        : end.subtract(Duration(minutes: length));
    return touch(
      i,
      PlanInstancesCompanion(
        status: const Value('done'),
        startAt: Value(start),
        endAt: Value(end),
      ),
    );
  }

  /// Odak oturumu tamamlandı (D69): iş "bitti", gerçek başlangıç ve bitişiyle.
  Future<PlanInstance> markDone(String id, DateTime start, DateTime end) =>
      _writer.update(
        _db.planInstances,
        id,
        PlanInstancesCompanion(
          status: const Value('done'),
          startAt: Value(start.toUtc()),
          endAt: Value(end.toUtc()),
        ),
      );

  /// Molada bitirilen işin kalan kısmı (D69): verilen saatte ya da saatsiz bekler.
  Future<PlanInstance> addRemainder({
    required String activityId,
    required String parentId,
    required String date,
    required int minutes,
    DateTime? start,
    DateTime? end,
  }) => _writer.insert(
    _db.planInstances,
    PlanInstancesCompanion.insert(
      id: newId(),
      activityId: activityId,
      occurrenceDate: date,
      startAt: Value(start?.toUtc()),
      endAt: Value(end?.toUtc()),
      source: 'manual',
      parentInstanceId: Value(parentId),
      plannedMinutes: Value(minutes),
    ),
  );

  Future<PlanInstance> skip(PlannedInstance i) =>
      touch(i, const PlanInstancesCompanion(status: Value('skipped')));

  /// Yalnız bu sefer başka saate alınır; motor bu satırı bir daha kımıldatmaz.
  Future<PlanInstance> moveOnce(
    PlannedInstance i,
    DateTime start,
    DateTime end,
  ) => touch(
    i,
    PlanInstancesCompanion(
      startAt: Value(start.toUtc()),
      endAt: Value(end.toUtc()),
      isManual: const Value(true),
    ),
  );

  Future<PlanInstance> selectVariant(VariantChoice c, String variantId) =>
      touch(
        PlannedInstance(
          id: c.instanceId,
          activityId: c.activityId,
          ruleId: c.ruleId,
          date: c.date,
          status: InstanceStatus.planned,
          source: InstanceSource.rule,
          flexibility: Flexibility.fixed,
        ),
        PlanInstancesCompanion(variantId: Value(variantId)),
      );

  /// Onaylanan proje parçası ya da elle yerleştirilen parça (UUIDv7).
  Future<PlanInstance> addChunk({
    required String activityId,
    required String date,
    required DateTime start,
    required DateTime end,
    bool manual = false,
  }) => _writer.insert(
    _db.planInstances,
    PlanInstancesCompanion.insert(
      id: newId(),
      activityId: activityId,
      occurrenceDate: date,
      startAt: Value(start.toUtc()),
      endAt: Value(end.toUtc()),
      source: manual ? 'manual' : 'auto',
      engineVersion: Value(manual ? null : planEngineVersion),
    ),
  );

  Future<void> remove(String id) => _writer.softDelete(_db.planInstances, id);

  static DateTime _utc(int minute) =>
      DateTime.fromMillisecondsSinceEpoch(minute * 60000, isUtc: true);
}
