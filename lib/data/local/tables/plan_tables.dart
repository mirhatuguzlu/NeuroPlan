// Drift'in check() kalıbı sütun getter'ını kendine başvurarak yazar; bu getter'lar
// çalıştırılmaz, yalnız drift_dev tarafından okunur.
// ignore_for_file: recursive_getters

import 'package:drift/drift.dart';

import '../converters.dart';
import 'system_tables.dart';

// Plan tabloları (docs/DB_SCHEMA.md §3). Sunucudaki tabloların aynısı; user_id ve version yok
// (yerel veritabanı tek kullanıcılı, sürüm sunucunun sayacı).

/// Eşitlenen her tablonun ortak sütunları.
mixin SyncColumns on Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now().toUtc())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get fieldVersions => text()
      .map(const FieldVersionsConverter())
      .withDefault(const Constant('{}'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Yerelde tek satır; kimliği sabittir, sunucu kendi tarafında auth.uid() kullanır.
const localProfileId = '00000000-0000-0000-0000-000000000000';

class Profiles extends Table with SyncColumns {
  TextColumn get displayName => text().nullable()();
  TextColumn get locale => text().nullable()();
  TextColumn get theme => text().nullable()();
  TextColumn get themeMode => text()
      .withDefault(const Constant('system'))
      .check(themeMode.isIn(const ['system', 'light', 'dark']))();
  TextColumn get timezone => text()();
  IntColumn get sleepGoalMinutes => integer().nullable()();
  IntColumn get birthYear => integer().nullable()();
  DateTimeColumn get onboardingCompletedAt => dateTime().nullable()();
  RealColumn get locationLat => real().nullable()();
  RealColumn get locationLon => real().nullable()();
  TextColumn get locationLabel => text().nullable()();
  TextColumn get prayerMethod => text().nullable()();
  TextColumn get prayerMadhab => text().nullable()();
  IntColumn get minChunkMinutes => integer().nullable()();
  IntColumn get chunkBufferMinutes => integer().nullable()();
  IntColumn get dailyFocusCapMinutes => integer().nullable()();
  BoolColumn get hapticsEnabled =>
      boolean().withDefault(const Constant(true))();
}

@DataClassName('UserCategory')
class UserCategories extends Table with SyncColumns {
  TextColumn get parentId =>
      text().nullable().references(UserCategories, #id)();
  TextColumn get rootCategoryKey => text().references(RootCategories, #key)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get color => text().nullable()();
  TextColumn get icon => text().nullable()();
  BoolColumn get requiresFocus => boolean().nullable()();
  TextColumn get defaultFocusMode => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

const activityKinds = [
  'routine',
  'one_off',
  'task',
  'project',
  'free_time',
  'travel_prep',
];

@DataClassName('Activity')
class Activities extends Table with SyncColumns {
  TextColumn get kind => text().check(kind.isIn(activityKinds))();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get notes => text().nullable()();
  TextColumn get categoryId =>
      text().nullable().references(UserCategories, #id)();
  TextColumn get rootCategoryKey =>
      text().nullable().references(RootCategories, #key)();
  TextColumn get parentActivityId =>
      text().nullable().references(Activities, #id)();
  TextColumn get variantId => text().nullable().references(Variants, #id)();
  IntColumn get estimatedMinutes => integer().nullable()();
  IntColumn get priority => integer().nullable()();
  BoolColumn get requiresFocus => boolean().nullable()();
  TextColumn get focusMode => text().nullable()();

  /// Derin çalışma blok planı ve geç kalma payı (D66); null = varsayılan.
  IntColumn get focusBlockMinutes => integer().nullable()();
  IntColumn get focusBreakMinutes => integer().nullable()();
  BoolColumn get focusSpread => boolean().nullable()();
  IntColumn get focusGraceMinutes => integer().nullable()();

  /// Planlı Pomodoro (D67): tekrar sayısı, uzun mola ve kaç döngüde bir olduğu.
  IntColumn get focusCycles => integer().nullable()();
  IntColumn get focusLongBreakMinutes => integer().nullable()();
  IntColumn get focusLongEvery => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class ScheduleRules extends Table with SyncColumns {
  TextColumn get activityId => text().references(Activities, #id)();
  TextColumn get recurrence => text().map(const RecurrenceConverter())();
  TextColumn get timing =>
      text().map(const TimingConverter()).withDefault(const Constant('{}'))();
  IntColumn get durationMinMinutes => integer().nullable()();
  IntColumn get durationMaxMinutes => integer().nullable()();
  TextColumn get flexibility => text()
      .withDefault(const Constant('fixed'))
      .check(flexibility.isIn(const ['fixed', 'shiftable', 'optional']))();
  TextColumn get validFrom => text().nullable()();
  TextColumn get validUntil => text().nullable()();
  TextColumn get exceptionDates => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
}

class VariantGroups extends Table with SyncColumns {
  TextColumn get activityId => text().references(Activities, #id)();
  TextColumn get name => text().nullable()();
  TextColumn get appliesOn =>
      text().map(const RecurrenceConverter()).nullable()();
  TextColumn get defaultVariantId =>
      text().nullable().references(Variants, #id)();
}

class Variants extends Table with SyncColumns {
  TextColumn get groupId => text().references(VariantGroups, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get timing => text().map(const TimingConverter()).nullable()();
  IntColumn get durationMinMinutes => integer().nullable()();
  IntColumn get durationMaxMinutes => integer().nullable()();
  BoolColumn get cancelsOccurrence =>
      boolean().withDefault(const Constant(false))();
}

class Projects extends Table with SyncColumns {
  TextColumn get activityId => text().references(Activities, #id)();
  IntColumn get totalMinutes => integer().nullable()();
  DateTimeColumn get deadlineAt => dateTime().nullable()();
  TextColumn get splitMode => text()
      .withDefault(const Constant('auto'))
      .check(splitMode.isIn(const ['auto', 'manual']))();
  IntColumn get minChunkMinutes => integer().nullable()();
  IntColumn get maxChunkMinutes => integer().nullable()();
  IntColumn get dailyCapMinutes => integer().nullable()();
  TextColumn get preferredWindows =>
      text().map(const JsonValueConverter<List<Object?>>()).nullable()();
  IntColumn get safetyMarginMinutes => integer().nullable()();
}

class DayOverrides extends Table with SyncColumns {
  TextColumn get date => text().nullable()();
  TextColumn get recurrence =>
      text().map(const RecurrenceConverter()).nullable()();
  TextColumn get validFrom => text().nullable()();
  TextColumn get validUntil => text().nullable()();
  TextColumn get keep => text()
      .withDefault(const Constant('all'))
      .check(keep.isIn(const ['all', 'fixed_only', 'none']))();
  BoolColumn get autoPlacement =>
      boolean().withDefault(const Constant(false))();
  TextColumn get label => text().nullable()();
}

class PlanInstances extends Table with SyncColumns {
  TextColumn get activityId => text().references(Activities, #id)();
  TextColumn get ruleId => text().nullable().references(ScheduleRules, #id)();
  TextColumn get occurrenceDate => text()();
  DateTimeColumn get startAt => dateTime().nullable()();
  DateTimeColumn get endAt => dateTime().nullable()();
  TextColumn get status => text()
      .withDefault(const Constant('planned'))
      .check(
        status.isIn(const ['planned', 'done', 'skipped', 'moved', 'failed']),
      )();
  TextColumn get source =>
      text().check(source.isIn(const ['rule', 'auto', 'manual']))();
  TextColumn get variantId => text().nullable().references(Variants, #id)();
  TextColumn get parentInstanceId =>
      text().nullable().references(PlanInstances, #id)();
  TextColumn get movedFromId =>
      text().nullable().references(PlanInstances, #id)();
  BoolColumn get isManual => boolean().withDefault(const Constant(false))();
  IntColumn get engineVersion => integer().nullable()();
}
