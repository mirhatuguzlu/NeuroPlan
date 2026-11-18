import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';
import '../sync/local_writer.dart';

/// Aktiviteler ve bağlı tanımları: kurallar, varyantlar, proje ayarları
/// (docs/DB_SCHEMA.md §3.3–3.6).
class ActivityRepository {
  ActivityRepository(this._db, this._writer);

  final AppDatabase _db;
  final LocalWriter _writer;

  Stream<List<Activity>> watchAll() =>
      (_db.select(_db.activities)
            ..where((a) => a.deletedAt.isNull())
            ..orderBy([(a) => OrderingTerm(expression: a.sortOrder)]))
          .watch();

  Future<Activity?> get(String id) => _writer.find(_db.activities, id);

  /// Kategori verilirse kök kategoriden türetilir; ikisi de boş olabilir (ör. yol).
  Future<Activity> create(ActivitiesCompanion data) async =>
      _writer.insert(_db.activities, await _withDerivedRoot(data));

  Future<Activity> update(String id, ActivitiesCompanion changes) async =>
      _writer.update(_db.activities, id, await _withDerivedRoot(changes));

  Future<void> delete(String id) => _writer.softDelete(_db.activities, id);

  Stream<List<ScheduleRule>> watchRules(String activityId) =>
      (_db.select(_db.scheduleRules)..where(
            (r) => r.activityId.equals(activityId) & r.deletedAt.isNull(),
          ))
          .watch();

  Future<ScheduleRule> addRule(ScheduleRulesCompanion rule) {
    _checkFollow(
      rule.recurrence.value,
      rule.timing.present ? rule.timing.value : Timing.none,
    );
    return _writer.insert(_db.scheduleRules, rule);
  }

  Future<ScheduleRule> updateRule(
    String id,
    ScheduleRulesCompanion changes,
  ) async {
    final old = await _writer.find(_db.scheduleRules, id);
    if (old == null) throw ArgumentError('Kural yok: $id');
    _checkFollow(
      changes.recurrence.present ? changes.recurrence.value : old.recurrence,
      changes.timing.present ? changes.timing.value : old.timing,
    );
    return _writer.update(_db.scheduleRules, id, changes);
  }

  Future<void> deleteRule(String id) =>
      _writer.softDelete(_db.scheduleRules, id);

  /// Aktivite başına tek varyant grubu (DB_SCHEMA §9).
  Future<VariantGroup> createVariantGroup({
    required String activityId,
    String? name,
    Recurrence? appliesOn,
  }) async {
    final existing =
        await (_db.select(_db.variantGroups)
              ..where(
                (g) => g.activityId.equals(activityId) & g.deletedAt.isNull(),
              )
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) {
      throw StateError('Bu aktivitenin zaten bir varyant grubu var');
    }
    return _writer.insert(
      _db.variantGroups,
      VariantGroupsCompanion.insert(
        id: newId(),
        activityId: activityId,
        name: Value(name),
        appliesOn: Value(appliesOn),
      ),
    );
  }

  Future<Variant> addVariant(VariantsCompanion variant) =>
      _writer.insert(_db.variants, variant);

  Future<Variant> updateVariant(String id, VariantsCompanion changes) =>
      _writer.update(_db.variants, id, changes);

  Future<void> deleteVariant(String id) => _writer.softDelete(_db.variants, id);

  Future<VariantGroup> setDefaultVariant(String groupId, String? variantId) =>
      _writer.update(
        _db.variantGroups,
        groupId,
        VariantGroupsCompanion(defaultVariantId: Value(variantId)),
      );

  Future<Project?> projectFor(String activityId) =>
      (_db.select(_db.projects)..where(
            (p) => p.activityId.equals(activityId) & p.deletedAt.isNull(),
          ))
          .getSingleOrNull();

  /// Aktivitenin proje ayarlarını yazar: yoksa ekler, varsa günceller (aktivite başına bir).
  Future<Project> saveProject(
    String activityId,
    ProjectsCompanion settings,
  ) async {
    final existing = await projectFor(activityId);
    return existing == null
        ? _writer.insert(
            _db.projects,
            settings.copyWith(
              id: Value(newId()),
              activityId: Value(activityId),
            ),
          )
        : _writer.update(_db.projects, existing.id, settings);
  }

  Future<ActivitiesCompanion> _withDerivedRoot(ActivitiesCompanion data) async {
    final categoryId = data.categoryId.present ? data.categoryId.value : null;
    if (categoryId == null) return data;
    final category = await _writer.find(_db.userCategories, categoryId);
    if (category == null || category.deletedAt != null) {
      throw ArgumentError('Kategori yok: $categoryId');
    }
    return data.copyWith(rootCategoryKey: Value(category.rootCategoryKey));
  }

  /// `follow` kuralı zaman kısıtında en az bir aktivite çapası ister (sunucu CHECK'i ile aynı).
  static void _checkFollow(Recurrence recurrence, Timing timing) {
    if (recurrence is FollowRecurrence && timing.anchorActivityIds.isEmpty) {
      throw ArgumentError('"follow" tekrarı bir aktivite çapası gerektirir');
    }
  }
}
