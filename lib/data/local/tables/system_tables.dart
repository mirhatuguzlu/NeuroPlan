import 'package:drift/drift.dart';

import '../converters.dart';

// Sistem tabloları (docs/DB_SCHEMA.md §2). İlk açılışta assets/seed/system.json'dan doldurulur;
// yerelde de salt okunur kabul edilir (yazan tek yer AppDatabase seed'i).

@DataClassName('RootCategory')
class RootCategories extends Table {
  TextColumn get key => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get nameTr => text()();
  TextColumn get nameEn => text()();
  TextColumn get descriptionTr => text()();
  TextColumn get descriptionEn => text()();
  TextColumn get icon => text()();
  TextColumn get color => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class BrainRegions extends Table {
  TextColumn get key => text()();
  IntColumn get sortOrder => integer()();
  TextColumn get nameTr => text()();
  TextColumn get nameEn => text()();
  TextColumn get hemisphere => text()();
  TextColumn get meshName => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class CategoryRegionWeights extends Table {
  TextColumn get rootCategoryKey => text().references(RootCategories, #key)();
  TextColumn get regionKey => text().references(BrainRegions, #key)();
  RealColumn get weight => real()();
  TextColumn get evidenceLevel => text()();
  TextColumn get sourceIds => text().map(const StringListConverter())();
  TextColumn get sourceUrls => text().map(const StringListConverter())();

  @override
  Set<Column<Object>> get primaryKey => {rootCategoryKey, regionKey};
}
