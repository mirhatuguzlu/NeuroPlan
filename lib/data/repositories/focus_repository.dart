import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';
import '../sync/local_writer.dart';

/// Odak oturumları, kesintiler ve beyin olayları (docs/DB_SCHEMA.md §4).
class FocusRepository {
  FocusRepository(this._db, this._writer);

  final AppDatabase _db;
  final LocalWriter _writer;

  Stream<List<FocusSession>> watchSessions() =>
      (_db.select(_db.focusSessions)
            ..where((s) => s.deletedAt.isNull())
            ..orderBy([
              (s) => OrderingTerm(
                expression: s.startedAt,
                mode: OrderingMode.desc,
              ),
            ]))
          .watch();

  /// Bu oluşum için daha önce oturum açıldı mı (otomatik başlatma bir kez dener).
  Future<bool> hasSessionFor(String planInstanceId) async =>
      await (_db.select(_db.focusSessions)
            ..where(
              (s) =>
                  s.deletedAt.isNull() &
                  s.planInstanceId.equals(planInstanceId),
            )
            ..limit(1))
          .getSingleOrNull() !=
      null;

  /// Süren oturum (en çok bir tane; uygulama açılınca kurtarılır).
  Stream<FocusSession?> watchActive() =>
      (_db.select(_db.focusSessions)
            ..where(
              (s) => s.deletedAt.isNull() & s.outcome.equals('in_progress'),
            )
            ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
            ..limit(1))
          .watchSingleOrNull();

  Future<FocusSession?> find(String id) => _writer.find(_db.focusSessions, id);

  /// Süren oturumun segmentleri (faz değişimi, duraklatma, kesinti).
  Future<FocusSession> updateSegments(String id, List<Object?> segments) async {
    await _requireInProgress(id);
    return _writer.update(
      _db.focusSessions,
      id,
      FocusSessionsCompanion(segments: Value(segments)),
    );
  }

  /// Oturumu başlatır. Kategori ve kök, oturum anında kopyalanır (CAT-4): bir aktiviteye
  /// bağlıysa onunkiler, yoksa verilenler.
  Future<FocusSession> start({
    required String mode,
    String? planInstanceId,
    String? activityId,
    String? categoryId,
    String? rootCategoryKey,
    Map<String, Object?>? settings,
    int? plannedMinutes,
    DateTime? startedAt,
    List<Object?> segments = const [],
  }) async {
    final activity = activityId == null
        ? null
        : await _writer.find(_db.activities, activityId);
    return _writer.insert(
      _db.focusSessions,
      FocusSessionsCompanion.insert(
        id: newId(),
        mode: mode,
        startedAt: (startedAt ?? DateTime.now()).toUtc(),
        planInstanceId: Value(planInstanceId),
        activityId: Value(activityId),
        categoryId: Value(activity?.categoryId ?? categoryId),
        rootCategoryKey: Value(activity?.rootCategoryKey ?? rootCategoryKey),
        settings: Value(settings),
        plannedMinutes: Value(plannedMinutes),
        segments: Value(segments),
      ),
    );
  }

  /// Oturumu bitirir (`completed` ya da kaçış kuralıyla `broken`, FOCUS-2/3).
  Future<FocusSession> finish(
    String id, {
    required String outcome,
    required int focusedSeconds,
    List<Object?> segments = const [],
    DateTime? endedAt,
  }) async {
    if (outcome != 'completed' && outcome != 'broken') {
      throw ArgumentError('Sonuç completed ya da broken olmalı: $outcome');
    }
    await _requireInProgress(id);
    return _writer.update(
      _db.focusSessions,
      id,
      FocusSessionsCompanion(
        outcome: Value(outcome),
        focusedSeconds: Value(focusedSeconds),
        segments: Value(segments),
        endedAt: Value((endedAt ?? DateTime.now()).toUtc()),
      ),
    );
  }

  /// Kullanıcının bildirdiği puanlar ve not; oturum bittikten sonra da değişebilir.
  Future<FocusSession> rate(
    String id, {
    int? focusRating,
    int? fatigueRating,
    String? note,
  }) => _writer.update(
    _db.focusSessions,
    id,
    FocusSessionsCompanion(
      focusRating: Value.absentIfNull(focusRating),
      fatigueRating: Value.absentIfNull(fatigueRating),
      note: Value.absentIfNull(note),
    ),
  );

  /// Eklendiyse `true`; aynı kesinti tekrar gelirse yok sayılır.
  Future<bool> recordInterruption(FocusInterruptionsCompanion data) =>
      _writer.append(_db.focusInterruptions, data);

  /// `dedupe_key` aynıysa (iki cihaz aynı olayı üretti) yazılmaz; eklendiyse `true`.
  Future<bool> appendBrainEvent(BrainEventsCompanion event) =>
      _writer.append(_db.brainEvents, event);

  Future<void> _requireInProgress(String id) async {
    final s = await _writer.find(_db.focusSessions, id);
    if (s == null) throw ArgumentError('Oturum yok: $id');
    // Beyin bu kayıttan türetilir; biten oturum değişmez (sunucu tetikleyicisiyle aynı kural).
    if (s.outcome != 'in_progress') {
      throw StateError('Biten oturum değiştirilemez');
    }
  }
}
