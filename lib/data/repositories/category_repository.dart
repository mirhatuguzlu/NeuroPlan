import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';
import '../sync/local_writer.dart';

/// Silinmek istenen kategorinin altında canlı kategori ya da aktivite var.
class CategoryInUseException implements Exception {
  const CategoryInUseException(this.categoryId);
  final String categoryId;

  @override
  String toString() => 'CategoryInUseException: $categoryId kullanımda';
}

/// Sistem kök kategorileri + kullanıcının kategori ağacı (docs/DB_SCHEMA.md §2.1, §3.2).
class CategoryRepository {
  CategoryRepository(this._db, this._writer);

  final AppDatabase _db;
  final LocalWriter _writer;

  Future<List<RootCategory>> rootCategories() => (_db.select(
    _db.rootCategories,
  )..orderBy([(c) => OrderingTerm(expression: c.sortOrder)])).get();

  Future<List<CategoryRegionWeight>> weightsFor(String rootCategoryKey) =>
      (_db.select(
        _db.categoryRegionWeights,
      )..where((w) => w.rootCategoryKey.equals(rootCategoryKey))).get();

  /// Silinmemiş kategoriler, sıra numarasına göre.
  Stream<List<UserCategory>> watchAll() =>
      (_db.select(_db.userCategories)
            ..where((c) => c.deletedAt.isNull())
            ..orderBy([(c) => OrderingTerm(expression: c.sortOrder)]))
          .watch();

  /// Üst kategori verilirse kökü ondan alınır; verilmezse [rootCategoryKey] zorunludur.
  Future<UserCategory> create({
    required String name,
    String? parentId,
    String? rootCategoryKey,
    String? color,
    String? icon,
    bool? requiresFocus,
    String? defaultFocusMode,
  }) async {
    final root = parentId != null
        ? (await _live(parentId)).rootCategoryKey
        : rootCategoryKey ??
              (throw ArgumentError('Üst kategori ya da kök kategori gerekli'));
    return _writer.insert(
      _db.userCategories,
      UserCategoriesCompanion.insert(
        id: newId(),
        name: name,
        rootCategoryKey: root,
        parentId: Value(parentId),
        color: Value(color),
        icon: Value(icon),
        requiresFocus: Value(requiresFocus),
        defaultFocusMode: Value(defaultFocusMode),
      ),
    );
  }

  /// Ad, renk, ikon, odak ayarları. Ağaçtaki yer yalnız [move] ile değişir.
  Future<UserCategory> update(String id, UserCategoriesCompanion changes) {
    if (changes.parentId.present || changes.rootCategoryKey.present) {
      throw ArgumentError('Kategoriyi taşımak için move() kullan');
    }
    return _writer.update(_db.userCategories, id, changes);
  }

  /// Alt ağacı yeni bir ebeveynin ya da kökün altına taşır (CAT-4). Alt kategorilerin
  /// ve bağlı aktivitelerin kökü güncellenir; geçmiş odak oturumları kendi kopyasını tuttuğu
  /// için değişmez.
  Future<void> move(
    String id, {
    String? newParentId,
    String? newRootCategoryKey,
  }) => _db.transaction(() async {
    final node = await _live(id);
    final subtree = await _subtreeIds(id);
    if (newParentId != null && subtree.contains(newParentId)) {
      throw ArgumentError('Kategori kendi alt dalına taşınamaz');
    }
    final root = newParentId != null
        ? (await _live(newParentId)).rootCategoryKey
        : newRootCategoryKey ?? node.rootCategoryKey;

    await _writer.update(
      _db.userCategories,
      id,
      UserCategoriesCompanion(
        parentId: Value(newParentId),
        rootCategoryKey: Value(root),
      ),
    );
    for (final childId in subtree.where((c) => c != id)) {
      await _writer.update(
        _db.userCategories,
        childId,
        UserCategoriesCompanion(rootCategoryKey: Value(root)),
      );
    }
    final activities = await (_db.select(
      _db.activities,
    )..where((a) => a.categoryId.isIn(subtree))).get();
    for (final a in activities) {
      await _writer.update(
        _db.activities,
        a.id,
        ActivitiesCompanion(rootCategoryKey: Value(root)),
      );
    }
  });

  /// Yumuşak siler. Altında canlı kategori ya da aktivite varsa [CategoryInUseException].
  Future<void> delete(String id) async {
    final child =
        await (_db.select(_db.userCategories)
              ..where((c) => c.parentId.equals(id) & c.deletedAt.isNull())
              ..limit(1))
            .getSingleOrNull();
    final activity =
        await (_db.select(_db.activities)
              ..where((a) => a.categoryId.equals(id) & a.deletedAt.isNull())
              ..limit(1))
            .getSingleOrNull();
    if (child != null || activity != null) throw CategoryInUseException(id);
    await _writer.softDelete(_db.userCategories, id);
  }

  Future<UserCategory> _live(String id) async {
    final c = await _writer.find(_db.userCategories, id);
    if (c == null || c.deletedAt != null) {
      throw ArgumentError('Kategori yok: $id');
    }
    return c;
  }

  /// Düğüm ve tüm alt düğümleri (silinmişler dahil; taşınınca onların kökü de tutarlı kalsın).
  Future<Set<String>> _subtreeIds(String id) async {
    final ids = {id};
    var frontier = [id];
    while (frontier.isNotEmpty) {
      final children = await (_db.select(
        _db.userCategories,
      )..where((c) => c.parentId.isIn(frontier))).get();
      frontier = [
        for (final c in children)
          if (ids.add(c.id)) c.id,
      ];
    }
    return ids;
  }
}
