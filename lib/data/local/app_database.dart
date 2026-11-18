import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'converters.dart';
import 'tables/focus_tables.dart';
import 'tables/plan_tables.dart';
import 'tables/sync_tables.dart';
import 'tables/system_tables.dart';

export 'tables/plan_tables.dart' show activityKinds, localProfileId;

part 'app_database.g.dart';

/// Eşitlenen bir tablo: sunucudaki adı, yerel tablosu ve JSON'dan satır kurucusu.
class SyncedTable<D extends DataClass> {
  const SyncedTable(this.info, this.fromJson, {this.appendOnly = false});

  final TableInfo<Table, D> info;
  final D Function(Map<String, dynamic> json, {ValueSerializer? serializer})
  fromJson;

  /// Yalnız eklenir; tekrar gelen kayıt yok sayılır.
  final bool appendOnly;
}

/// Tek doğru kaynak (docs/ARCHITECTURE.md §5). Şema: docs/DB_SCHEMA.md.
@DriftDatabase(
  tables: [
    RootCategories,
    BrainRegions,
    CategoryRegionWeights,
    Profiles,
    UserCategories,
    Activities,
    ScheduleRules,
    VariantGroups,
    Variants,
    Projects,
    DayOverrides,
    PlanInstances,
    FocusSessions,
    FocusInterruptions,
    BrainEvents,
    BrainSnapshots,
    SyncOutbox,
    SyncState,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e, {required this.systemData});

  /// assets/seed/system.json; ilk açılışta sistem tablolarına yazılır.
  final SystemData systemData;

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await _seedSystemData();
    },
    beforeOpen: (_) => customStatement('PRAGMA foreign_keys = ON'),
  );

  /// Sunucudaki `sync_tables()` ile aynı sıra (ebeveyn önce).
  late final List<SyncedTable> syncedTables = [
    SyncedTable(profiles, Profile.fromJson),
    SyncedTable(userCategories, UserCategory.fromJson),
    SyncedTable(activities, Activity.fromJson),
    SyncedTable(variantGroups, VariantGroup.fromJson),
    SyncedTable(variants, Variant.fromJson),
    SyncedTable(scheduleRules, ScheduleRule.fromJson),
    SyncedTable(projects, Project.fromJson),
    SyncedTable(dayOverrides, DayOverride.fromJson),
    SyncedTable(planInstances, PlanInstance.fromJson),
    SyncedTable(focusSessions, FocusSession.fromJson),
    SyncedTable(
      focusInterruptions,
      FocusInterruption.fromJson,
      appendOnly: true,
    ),
    SyncedTable(brainEvents, BrainEvent.fromJson, appendOnly: true),
  ];

  Future<void> _seedSystemData() => batch((b) {
    b.insertAll(rootCategories, [
      for (final c in systemData.rootCategories)
        RootCategoriesCompanion.insert(
          key: c.key,
          sortOrder: c.sortOrder,
          nameTr: c.nameTr,
          nameEn: c.nameEn,
          descriptionTr: c.descriptionTr,
          descriptionEn: c.descriptionEn,
          icon: c.icon,
          color: c.color,
        ),
    ]);
    b.insertAll(brainRegions, [
      for (final r in systemData.regions)
        BrainRegionsCompanion.insert(
          key: r.key,
          sortOrder: r.sortOrder,
          nameTr: r.nameTr,
          nameEn: r.nameEn,
          hemisphere: r.hemisphere,
          meshName: r.meshName,
        ),
    ]);
    b.insertAll(categoryRegionWeights, [
      for (final w in systemData.weights)
        CategoryRegionWeightsCompanion.insert(
          rootCategoryKey: w.rootCategoryKey,
          regionKey: w.regionKey,
          weight: w.weight,
          evidenceLevel: w.evidence.json,
          sourceIds: w.sourceIds,
          sourceUrls: systemData.sourceUrls(w),
        ),
    ]);
  });
}
