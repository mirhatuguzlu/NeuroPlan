import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/data/repositories/activity_repository.dart';
import 'package:neuroplan/data/repositories/category_repository.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'test_support.dart';

void main() {
  late TestDevice d;
  late ActivityRepository repo;

  setUp(() {
    d = TestDevice();
    repo = ActivityRepository(d.db, d.writer);
  });
  tearDown(() => d.db.close());

  Future<Activity> activity(String title, {String? root}) => repo.create(
    ActivitiesCompanion.insert(
      id: newId(),
      kind: 'routine',
      title: title,
      rootCategoryKey: Value(root),
    ),
  );

  test(
    'aktivite: ekle, güncelle, yumuşak sil; kategori olmadan da olur',
    () async {
      final yol = await activity('Yol');
      expect(yol.rootCategoryKey, isNull, reason: 'yol beyne katkı vermez');

      final anne = await activity('Annemle konuşmak', root: 'emotional_social');
      await repo.update(
        anne.id,
        const ActivitiesCompanion(notes: Value('Pazar')),
      );
      expect((await repo.get(anne.id))!.notes, 'Pazar');

      await repo.delete(yol.id);
      expect((await repo.watchAll().first).map((a) => a.title), [
        'Annemle konuşmak',
      ]);
    },
  );

  test('kategoriye bağlanınca kök kategoriden türetilir', () async {
    final cat = await CategoryRepository(
      d.db,
      d.writer,
    ).create(name: 'Futbol', rootCategoryKey: 'body_movement');
    final a = await repo.create(
      ActivitiesCompanion.insert(
        id: newId(),
        kind: 'routine',
        title: 'Maç',
        categoryId: Value(cat.id),
        rootCategoryKey: const Value('rest_sleep'),
      ),
    );
    expect(a.rootCategoryKey, 'body_movement');
  });

  test('kural: ekle, güncelle, sil; jsonb alanları tipli döner', () async {
    final ders = await activity('Ders', root: 'learning_memory');
    final rule = await repo.addRule(
      ScheduleRulesCompanion.insert(
        id: newId(),
        activityId: ders.id,
        recurrence: const RRuleRecurrence(
          dtstart: '2026-11-23',
          rrule: 'FREQ=WEEKLY;BYDAY=MO',
        ),
        timing: const Value(
          Timing(start: [TimeConstraint(ConstraintOp.at, ClockRef(13, 0))]),
        ),
        durationMinMinutes: const Value(90),
        durationMaxMinutes: const Value(90),
      ),
    );
    expect(rule.recurrence, isA<RRuleRecurrence>());
    expect((rule.timing.start.single.ref as ClockRef).hour, 13);

    await repo.updateRule(
      rule.id,
      const ScheduleRulesCompanion(exceptionDates: Value(['2026-11-30'])),
    );
    expect((await repo.watchRules(ders.id).first).single.exceptionDates, [
      '2026-11-30',
    ]);

    await repo.deleteRule(rule.id);
    expect(await repo.watchRules(ders.id).first, isEmpty);
  });

  test('follow kuralı çapasız reddedilir', () async {
    final yol = await activity('Yol');
    expect(
      () => repo.addRule(
        ScheduleRulesCompanion.insert(
          id: newId(),
          activityId: yol.id,
          recurrence: const FollowRecurrence(),
        ),
      ),
      throwsArgumentError,
    );
  });

  test('varyant: aktivite başına tek grup, varsayılan seçilir', () async {
    final mac = await activity('Maç', root: 'body_movement');
    final group = await repo.createVariantGroup(
      activityId: mac.id,
      name: 'Maç durumu',
    );
    final yok = await repo.addVariant(
      VariantsCompanion.insert(
        id: newId(),
        groupId: group.id,
        name: 'Maç yok',
        cancelsOccurrence: const Value(true),
      ),
    );
    await repo.addVariant(
      VariantsCompanion.insert(id: newId(), groupId: group.id, name: 'Maç var'),
    );
    final updated = await repo.setDefaultVariant(group.id, yok.id);
    expect(updated.defaultVariantId, yok.id);

    expect(() => repo.createVariantGroup(activityId: mac.id), throwsStateError);
  });

  test('proje: ilk kayıtta eklenir, sonra güncellenir', () async {
    final odev = await activity('Proje ödevi', root: 'learning_memory');
    final p = await repo.saveProject(
      odev.id,
      ProjectsCompanion(
        totalMinutes: const Value(600),
        deadlineAt: Value(DateTime.utc(2026, 11, 26, 20, 59)),
        maxChunkMinutes: const Value(120),
      ),
    );
    final again = await repo.saveProject(
      odev.id,
      const ProjectsCompanion(dailyCapMinutes: Value(180)),
    );
    expect(again.id, p.id);
    expect(again.totalMinutes, 600);
    expect(again.dailyCapMinutes, 180);
  });
}
