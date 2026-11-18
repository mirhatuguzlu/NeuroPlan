import 'dart:convert';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/data/repositories/activity_repository.dart';
import 'package:neuroplan/data/repositories/category_repository.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'test_support.dart';

void main() {
  late TestDevice d;
  late CategoryRepository repo;

  setUp(() {
    d = TestDevice();
    repo = CategoryRepository(d.db, d.writer);
  });
  tearDown(() => d.db.close());

  test('sistem verisi seed edildi', () async {
    final roots = await repo.rootCategories();
    expect(roots.map((r) => r.key).first, 'body_movement');
    expect(roots, hasLength(9));
    final sleep = await repo.weightsFor('rest_sleep');
    expect(sleep.single.regionKey, 'hippocampus');
    expect(sleep.single.sourceUrls, hasLength(2));
  });

  test('ekle, oku, güncelle, yumuşak sil; her yazma outbox\'a düşer', () async {
    final okul = await repo.create(
      name: 'Okul',
      rootCategoryKey: 'learning_memory',
    );
    final mat = await repo.create(name: 'Matematik', parentId: okul.id);
    expect(mat.rootCategoryKey, 'learning_memory', reason: 'kök ebeveynden');

    await repo.update(
      mat.id,
      const UserCategoriesCompanion(name: Value('Mat')),
    );
    expect((await repo.watchAll().first).map((c) => c.name), ['Okul', 'Mat']);

    await repo.delete(mat.id);
    expect((await repo.watchAll().first).map((c) => c.name), ['Okul']);

    final outbox = await d.outbox();
    expect(outbox, hasLength(4));
    expect(jsonDecode(outbox[2].patch), {'name': 'Mat'});
    expect(jsonDecode(outbox[3].patch), contains('deleted_at'));
  });

  test('kök kategori ya da ebeveyn zorunlu', () {
    expect(() => repo.create(name: 'Boşta'), throwsArgumentError);
  });

  test(
    'taşıma: döngü reddedilir, alt ağaç ve aktiviteler yeni köke geçer',
    () async {
      final a = await repo.create(
        name: 'A',
        rootCategoryKey: 'learning_memory',
      );
      final b = await repo.create(name: 'B', parentId: a.id);
      final c = await repo.create(name: 'C', parentId: b.id);
      final activity = await ActivityRepository(d.db, d.writer).create(
        ActivitiesCompanion.insert(
          id: newId(),
          kind: 'task',
          title: 'Ödev',
          categoryId: Value(c.id),
        ),
      );
      expect(activity.rootCategoryKey, 'learning_memory');

      expect(() => repo.move(a.id, newParentId: c.id), throwsArgumentError);

      await repo.move(a.id, newRootCategoryKey: 'planning_problem_solving');
      final all = await repo.watchAll().first;
      expect(all.map((x) => x.rootCategoryKey).toSet(), {
        'planning_problem_solving',
      });
      expect(
        (await d.writer.find(d.db.activities, activity.id))!.rootCategoryKey,
        'planning_problem_solving',
      );
    },
  );

  test('kullanımdaki kategori silinemez', () async {
    final a = await repo.create(name: 'A', rootCategoryKey: 'body_movement');
    await repo.create(name: 'B', parentId: a.id);
    expect(() => repo.delete(a.id), throwsA(isA<CategoryInUseException>()));
  });

  test('ağaçtaki yer update ile değiştirilemez', () async {
    final a = await repo.create(name: 'A', rootCategoryKey: 'body_movement');
    expect(
      () => repo.update(
        a.id,
        const UserCategoriesCompanion(rootCategoryKey: Value('rest_sleep')),
      ),
      throwsArgumentError,
    );
  });
}
