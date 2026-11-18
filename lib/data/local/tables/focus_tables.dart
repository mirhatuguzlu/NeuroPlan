// Drift'in check() kalıbı (bkz. plan_tables.dart).
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import '../converters.dart';
import 'plan_tables.dart';
import 'system_tables.dart';

// Odak ve beyin tabloları (docs/DB_SCHEMA.md §4).

class FocusSessions extends Table with SyncColumns {
  TextColumn get planInstanceId =>
      text().nullable().references(PlanInstances, #id)();
  TextColumn get activityId => text().nullable().references(Activities, #id)();
  // Oturum anındaki kopya: kategori sonradan taşınsa da geçmiş değişmez (CAT-4).
  TextColumn get categoryId =>
      text().nullable().references(UserCategories, #id)();
  TextColumn get rootCategoryKey =>
      text().nullable().references(RootCategories, #key)();
  // Beyne yalnız sayaçlı oturumlar katkı verir (D20).
  TextColumn get mode =>
      text().check(mode.isIn(const ['free', 'pomodoro', 'deep']))();
  TextColumn get settings =>
      text().map(const JsonValueConverter<Map<String, Object?>>()).nullable()();
  IntColumn get plannedMinutes => integer().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get focusedSeconds => integer().withDefault(const Constant(0))();
  TextColumn get segments => text()
      .map(const JsonValueConverter<List<Object?>>())
      .withDefault(const Constant('[]'))();
  TextColumn get outcome => text()
      .withDefault(const Constant('in_progress'))
      .check(outcome.isIn(const ['in_progress', 'completed', 'broken']))();
  IntColumn get focusRating => integer().nullable()();
  IntColumn get fatigueRating => integer().nullable()();
  TextColumn get note => text().nullable()();
}

class FocusInterruptions extends Table with SyncColumns {
  TextColumn get sessionId => text().references(FocusSessions, #id)();
  DateTimeColumn get leftAt => dateTime()();
  IntColumn get awayMs => integer()();
  TextColumn get reason => text().check(
    reason.isIn(const [
      'app_left',
      'notification_shade',
      'screen_off',
      'phone_call',
      'alarm',
      'other',
    ]),
  )();
  BoolColumn get recovered => boolean()();
  BoolColumn get counted => boolean()();
}

class BrainEvents extends Table with SyncColumns {
  TextColumn get type => text().check(
    type.isIn(const ['neuron_gain', 'connection_gain', 'fade', 'penalty']),
  )();
  @ReferenceName('eventsAsRegion')
  TextColumn get regionKey =>
      text().nullable().references(BrainRegions, #key)();
  @ReferenceName('eventsAsRegionB')
  TextColumn get regionBKey =>
      text().nullable().references(BrainRegions, #key)();
  IntColumn get amount => integer()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get sessionId =>
      text().nullable().references(FocusSessions, #id)();
  // İki cihaz aynı olayı üretirse tek satır kalır.
  TextColumn get dedupeKey => text().unique()();
  IntColumn get engineVersion => integer()();
}

/// Yerel önbellek; olaylardan yeniden üretilebilir, eşitlenmez.
class BrainSnapshots extends Table {
  IntColumn get engineVersion => integer()();
  DateTimeColumn get asOf => dateTime()();
  TextColumn get eventsHash => text()();
  TextColumn get state =>
      text().map(const JsonValueConverter<Map<String, Object?>>())();

  @override
  Set<Column<Object>> get primaryKey => {engineVersion};
}
