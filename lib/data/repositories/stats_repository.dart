import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';

/// Analizin okuduğu odak satırları (biten oturumlar ve kesintiler), çekirdek türlerinde.
class StatsSource {
  const StatsSource(this.sessions, this.interruptions);
  final List<StatSession> sessions;
  final List<StatInterruption> interruptions;
}

int _min(DateTime t) => t.millisecondsSinceEpoch ~/ 60000;

const _iso = ValueSerializer.defaults(serializeDateTimeValuesAsString: true);

/// Profil ve analiz için yerel okuma (internet gerekmez) ve veri dışa aktarma.
class StatsRepository {
  StatsRepository(this._db);

  final AppDatabase _db;

  Future<StatsSource> load() async {
    final sessions =
        await (_db.select(_db.focusSessions)..where(
              (s) =>
                  s.deletedAt.isNull() &
                  s.endedAt.isNotNull() &
                  s.outcome.isIn(const ['completed', 'broken']),
            ))
            .get();
    final interruptions = await (_db.select(
      _db.focusInterruptions,
    )..where((i) => i.deletedAt.isNull())).get();
    return StatsSource(
      [
        for (final s in sessions)
          StatSession(
            id: s.id,
            mode: s.mode,
            outcome: s.outcome,
            start: _min(s.startedAt),
            end: _min(s.endedAt!),
            focusedSeconds: s.focusedSeconds,
            rootKey: s.rootCategoryKey,
            categoryId: s.categoryId,
            activityId: s.activityId,
            focusRating: s.focusRating,
            fatigueRating: s.fatigueRating,
          ),
      ],
      [
        for (final i in interruptions)
          StatInterruption(
            sessionId: i.sessionId,
            at: _min(i.leftAt),
            reason: i.reason,
            counted: i.counted,
          ),
      ],
    );
  }

  /// Oturum ya da kesinti yazıldıkça yeniden okur.
  Stream<StatsSource> watch() async* {
    yield await load();
    await for (final _ in _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.focusSessions, _db.focusInterruptions]),
    )) {
      yield await load();
    }
  }

  /// Eşitlenen bütün kullanıcı tabloları tek JSON (DB_SCHEMA §6.4, çevrimdışı biçim).
  Future<String> exportJson(DateTime now) async {
    final tables = <String, Object?>{};
    for (final t in _db.syncedTables) {
      final rows = await _db.select(t.info).get();
      tables[t.info.actualTableName] = [
        for (final r in rows) r.toJson(serializer: _iso),
      ];
    }
    return const JsonEncoder.withIndent('  ').convert({
      'app': 'neuroplan',
      'format': 1,
      'exported_at': now.toUtc().toIso8601String(),
      'tables': tables,
    });
  }
}
