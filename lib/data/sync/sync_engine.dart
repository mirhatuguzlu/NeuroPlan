import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';
import '../local/converters.dart';
import 'hlc_clock.dart';

/// Sunucunun reddettiği bir değişiklik (`sync_push` dönüşü).
class PushRejection {
  const PushRejection(this.index, this.code, this.message);
  final int index;
  final String code;
  final String message;
}

/// `sync_pull` dönüşü: yeni imleç ve tablo → satırlar (sunucu sütun adlarıyla).
class PullPage {
  const PullPage(this.cursor, this.changes, {this.hasMore = false});
  final int cursor;
  final Map<String, List<Map<String, Object?>>> changes;
  final bool hasMore;
}

/// Sunucu tarafı. Supabase uygulaması oturum açmanın geldiği aşamada yazılır;
/// testlerde sahte sunucu kullanılır.
abstract interface class SyncRemote {
  /// Ağ hatasında istisna atar; outbox korunur.
  Future<List<PushRejection>> push(List<Map<String, Object?>> changes);
  Future<PullPage> pull(int cursor);
}

/// Outbox'ı gönderir, sonra imleçten sonraki değişiklikleri çekip alan bazlı birleştirir.
/// Ne zaman çalışacağına `SyncScheduler` karar verir.
class SyncEngine {
  SyncEngine(this._db, this._remote, this._clock);

  final AppDatabase _db;
  final SyncRemote _remote;
  final HlcClock _clock;

  static const batchSize = 200;
  static const _cursorKey = 'cursor';
  static const _userKey = 'user_id';

  /// Eşitlemenin hangi sunucu kullanıcısına yapıldığını kaydeder (ARCHITECTURE §5.4).
  /// Kullanıcı değiştiyse (misafir → var olan Google hesabı) yerel satırların hepsi yeni
  /// kullanıcıya gönderilmek üzere outbox'a yeniden yazılır ve imleç sıfırlanır.
  Future<void> adoptUser(String userId) => _db.transaction(() async {
    final saved = await (_db.select(
      _db.syncState,
    )..where((s) => s.key.equals(_userKey))).getSingleOrNull();
    if (saved?.value == userId) return;
    if (saved != null) {
      final at = DateTime.now().toUtc();
      for (final t in _db.syncedTables) {
        for (final row in await _db.select(t.info).get()) {
          final json = row.toJson(serializer: syncSerializer)
            ..remove('updated_at')
            ..remove('field_versions');
          final id = json.remove('id') as String;
          await _db
              .into(_db.syncOutbox)
              .insert(
                SyncOutboxCompanion.insert(
                  targetTable: t.info.actualTableName,
                  targetId: id,
                  patch: jsonEncode(json),
                  hlc: (await _clock.send()).toString(),
                  createdAt: at,
                ),
              );
        }
      }
      await (_db.delete(
        _db.syncState,
      )..where((s) => s.key.equals(_cursorKey))).go();
    }
    await _db
        .into(_db.syncState)
        .insertOnConflictUpdate(
          SyncStateCompanion.insert(key: _userKey, value: userId),
        );
  });

  /// Yeniden denemenin işe yaramayacağı Postgres hata sınıfları: veri (22), kısıt (23),
  /// yetki/sözdizimi (42). Tekil anahtar yarışı (23505) bir sonraki denemede güncellemeye döner.
  static bool isPermanent(String code) =>
      code != '23505' &&
      (code.startsWith('22') || code.startsWith('23') || code.startsWith('42'));

  Future<void> syncOnce() async {
    await _push();
    await _pull();
  }

  Future<void> _push() async {
    while (true) {
      final batch =
          await (_db.select(_db.syncOutbox)
                ..where((o) => o.dead.equals(false))
                ..orderBy([(o) => OrderingTerm(expression: o.seq)])
                ..limit(batchSize))
              .get();
      if (batch.isEmpty) return;

      final rejections = await _remote.push([
        for (final e in batch)
          {
            'table': e.targetTable,
            'id': e.targetId,
            'hlc': e.hlc,
            'patch': jsonDecode(e.patch),
          },
      ]);
      final byIndex = {for (final r in rejections) r.index: r};
      await _db.transaction(() async {
        for (final (i, e) in batch.indexed) {
          final r = byIndex[i];
          if (r == null) {
            await (_db.delete(
              _db.syncOutbox,
            )..where((o) => o.seq.equals(e.seq))).go();
          } else {
            await (_db.update(
              _db.syncOutbox,
            )..where((o) => o.seq.equals(e.seq))).write(
              SyncOutboxCompanion(
                attempts: Value(e.attempts + 1),
                lastError: Value('${r.code}: ${r.message}'),
                dead: Value(isPermanent(r.code)),
              ),
            );
          }
        }
      });
      // Geçici red varsa bu turu bitir; sonraki syncOnce yeniden dener.
      if (rejections.any((r) => !isPermanent(r.code))) return;
    }
  }

  Future<void> _pull() async {
    final saved = await (_db.select(
      _db.syncState,
    )..where((s) => s.key.equals(_cursorKey))).getSingleOrNull();
    var cursor = int.parse(saved?.value ?? '0');
    while (true) {
      final page = await _remote.pull(cursor);
      await _db.transaction(() async {
        // Satırlar tablo tablo gelir; döngüsel FK'ler (aktivite ↔ varyant) işlem sonunda kontrol edilir.
        await _db.customStatement('PRAGMA defer_foreign_keys = ON');
        for (final t in _db.syncedTables) {
          for (final row in page.changes[t.info.actualTableName] ?? const []) {
            await _merge(t, row);
          }
        }
        await _db
            .into(_db.syncState)
            .insertOnConflictUpdate(
              SyncStateCompanion.insert(
                key: _cursorKey,
                value: '${page.cursor}',
              ),
            );
      });
      cursor = page.cursor;
      if (!page.hasMore) return;
    }
  }

  Future<void> _merge(SyncedTable t, Map<String, Object?> remoteRow) async {
    final remote = Map<String, Object?>.of(remoteRow)
      ..remove('user_id')
      ..remove('version');
    if (t.info.actualTableName == 'profiles') remote['id'] = localProfileId;
    final remoteVersions =
        (remote.remove('field_versions') as Map?)?.cast<String, String>() ??
        const <String, String>{};
    if (remoteVersions.isNotEmpty) {
      await _clock.receive(
        remoteVersions.values
            .map(Hlc.parse)
            .reduce((a, b) => a.compareTo(b) >= 0 ? a : b),
      );
    }

    final idColumn = t.info.columnsByName['id']! as GeneratedColumn<String>;
    final local = await (_db.select(
      t.info,
    )..where((_) => idColumn.equals(remote['id'] as String))).getSingleOrNull();

    Map<String, Object?> merged;
    if (local == null) {
      merged = {...remote, 'field_versions': remoteVersions};
    } else {
      final localJson = local.toJson(serializer: syncSerializer);
      final localVersions = (localJson.remove('field_versions') as Map)
          .cast<String, String>();
      final m = mergeFields(
        local: localJson,
        localVersions: localVersions,
        remote: remote,
        remoteVersions: remoteVersions,
      );
      merged = {...m.values, 'field_versions': m.versions};
    }
    final row = t.fromJson(merged, serializer: syncSerializer);
    await _db.into(t.info).insertOnConflictUpdate(row as Insertable<DataClass>);
  }
}
