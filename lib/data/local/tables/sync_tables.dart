import 'package:drift/drift.dart';

// Eşitleme kuyruğu (docs/ARCHITECTURE.md §5). Yalnız yerelde.

/// Sunucuya gönderilmeyi bekleyen yamalar; yazma sırasıyla.
@DataClassName('OutboxEntry')
class SyncOutbox extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get targetTable => text()();
  TextColumn get targetId => text()();

  /// Yalnız değişen alanlar, sunucu sütun adlarıyla (JSON).
  TextColumn get patch => text()();
  TextColumn get hlc => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  /// Sunucu kalıcı olarak reddetti; veri silinmez, kullanıcıya gösterilir.
  BoolColumn get dead => boolean().withDefault(const Constant(false))();
}

/// Anahtar/değer: imleç, cihaz kimliği, son HLC.
@DataClassName('SyncStateEntry')
class SyncState extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
