import 'dart:convert';

import 'package:drift/drift.dart';

import '../local/app_database.dart';
import '../local/converters.dart';
import 'hlc_clock.dart';

/// Tüm yerel yazmalar buradan geçer (docs/ARCHITECTURE.md §5): satır, değişen alanların
/// HLC'si ve outbox yaması tek SQLite işleminde yazılır. Ekran ağ beklemez.
class LocalWriter {
  LocalWriter(this._db, this._clock);

  final AppDatabase _db;
  final HlcClock _clock;

  /// Sürümlenmeyen alanlar; `created_at` yalnız ilk yamada gider.
  static const _unversioned = {
    'id',
    'created_at',
    'updated_at',
    'field_versions',
  };

  Future<D?> find<D extends DataClass>(TableInfo<Table, D> table, String id) =>
      (_db.select(
        table,
      )..where((_) => _idColumn(table).equals(id))).getSingleOrNull();

  Future<D> insert<D extends DataClass>(
    TableInfo<Table, D> table,
    Insertable<D> row,
  ) => _db.transaction(() async {
    final id = _idOf(row);
    await _db.into(table).insert(row);
    return _commit(table, id, null);
  });

  Future<D> update<D extends DataClass>(
    TableInfo<Table, D> table,
    String id,
    Insertable<D> changes,
  ) => _db.transaction(() async {
    final old = await find(table, id);
    if (old == null) throw StateError('${table.actualTableName}/$id yok');
    await (_db.update(
      table,
    )..where((_) => _idColumn(table).equals(id))).write(changes);
    return _commit(table, id, old);
  });

  /// Yumuşak silme (`deleted_at`); kalıcı silme yok.
  Future<D> softDelete<D extends DataClass>(
    TableInfo<Table, D> table,
    String id,
  ) => _db.transaction(() async {
    final old = await find(table, id);
    if (old == null) throw StateError('${table.actualTableName}/$id yok');
    await _set(table, id, {
      'deleted_at': Variable<DateTime>(DateTime.now().toUtc()),
    });
    return _commit(table, id, old);
  });

  /// Yalnız eklenen tablolar: aynı kimlik ya da tekil anahtar varsa hiçbir şey yazılmaz.
  /// Eklendiyse `true`.
  Future<bool> append<D extends DataClass>(
    TableInfo<Table, D> table,
    Insertable<D> row,
  ) => _db.transaction(() async {
    final id = _idOf(row);
    if (await find(table, id) != null) return false;
    await _db.into(table).insert(row, mode: InsertMode.insertOrIgnore);
    if (await find(table, id) == null) return false;
    await _commit(table, id, null);
    return true;
  });

  Future<D> _commit<D extends DataClass>(
    TableInfo<Table, D> table,
    String id,
    D? old,
  ) async {
    final current = (await find(table, id))!;
    final now = current.toJson(serializer: syncSerializer);
    final before = old?.toJson(serializer: syncSerializer);
    final changed = [
      for (final k in now.keys)
        if (!_unversioned.contains(k) &&
            (before == null || jsonEncode(before[k]) != jsonEncode(now[k])))
          k,
    ];
    if (changed.isEmpty) return current;

    final hlc = (await _clock.send()).toString();
    final versions = {
      ...(now['field_versions'] as Map).cast<String, String>(),
      for (final k in changed) k: hlc,
    };
    final at = DateTime.now().toUtc();
    await _set(table, id, {
      'field_versions': Variable<String>(jsonEncode(versions)),
      'updated_at': Variable<DateTime>(at),
    });
    await _db
        .into(_db.syncOutbox)
        .insert(
          SyncOutboxCompanion.insert(
            targetTable: table.actualTableName,
            targetId: id,
            patch: jsonEncode({
              if (old == null) 'created_at': now['created_at'],
              for (final k in changed) k: now[k],
            }),
            hlc: hlc,
            createdAt: at,
          ),
        );
    return (await find(table, id))!;
  }

  /// Meta sütunları tipten bağımsız yazar (tablo ve sütun adları koddan gelir, kullanıcıdan değil).
  Future<void> _set(
    TableInfo<Table, Object?> table,
    String id,
    Map<String, Variable<Object>> values,
  ) => _db.customUpdate(
    'UPDATE "${table.actualTableName}" SET '
    '${values.keys.map((k) => '"$k" = ?').join(', ')} WHERE "id" = ?',
    variables: [...values.values, Variable<String>(id)],
    updates: {table},
    updateKind: UpdateKind.update,
  );

  static GeneratedColumn<String> _idColumn(TableInfo<Table, Object?> table) =>
      table.columnsByName['id']! as GeneratedColumn<String>;

  static String _idOf(Insertable<Object?> row) {
    final id = row.toColumns(false)['id'];
    if (id is Variable<String> && id.value != null) return id.value!;
    throw ArgumentError('Satırın kimliği (id) verilmeli');
  }
}
