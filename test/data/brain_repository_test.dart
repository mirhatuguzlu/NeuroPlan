import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/data/repositories/brain_repository.dart';
import 'package:neuroplan/data/repositories/focus_repository.dart';
import 'package:neuroplan/data/repositories/prefs_repository.dart';
import 'package:neuroplan/data/repositories/profile_repository.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'test_support.dart';

void main() {
  late TestDevice d;
  late FocusRepository focus;
  late BrainRepository brain;

  setUp(() async {
    d = TestDevice();
    focus = FocusRepository(d.db, d.writer);
    brain = BrainRepository(d.db, d.writer, PrefsRepository(d.db));
    await ProfileRepository(d.db, d.writer).ensure(timezone: 'Europe/Istanbul');
  });
  tearDown(() => d.db.close());

  Future<String> session(
    String root,
    DateTime end, {
    String outcome = 'completed',
    int minutes = 30,
    String mode = 'free',
  }) async {
    final s = await focus.start(
      mode: mode,
      rootCategoryKey: root,
      startedAt: end.subtract(Duration(minutes: minutes)),
    );
    await focus.finish(
      s.id,
      outcome: outcome,
      focusedSeconds: minutes * 60,
      endedAt: end,
      segments: [
        {
          'kind': 'work',
          'start': end.subtract(Duration(minutes: minutes)).toIso8601String(),
          'end': end.toIso8601String(),
        },
      ],
    );
    return s.id;
  }

  test('deriveFor geçmişe bakar: art arda gün bağı, bir kez yazılır', () async {
    final a = await session('rest_sleep', DateTime.utc(2026, 11, 17, 20));
    await brain.deriveFor(a);
    final b = await session('rest_sleep', DateTime.utc(2026, 11, 18, 20));
    final added = await brain.deriveFor(b);
    expect(
      [for (final e in added) (e.type, e.regionKey, e.regionBKey, e.amount)],
      [
        ('neuron_gain', 'hippocampus', null, 30000),
        ('connection_gain', 'hippocampus', 'hippocampus', 100),
      ],
    );
    // Aynı oturum ikinci kez türetilince yeni olay yazılmaz (dedupe_key).
    expect(await brain.deriveFor(b), isEmpty);
    final rows = await d.db.select(d.db.brainEvents).get();
    expect(rows, hasLength(3));
    expect(rows.every((r) => r.engineVersion == 2), isTrue);
    // Her olay eşitleme kuyruğuna girer.
    final outbox = await d.outbox();
    expect(outbox.where((o) => o.targetTable == 'brain_events'), hasLength(3));
  });

  test('rebuildIfNeeded bütün oturumları bir kez türetir', () async {
    await session('planning_problem_solving', DateTime.utc(2026, 11, 17, 9));
    await session(
      'planning_problem_solving',
      DateTime.utc(2026, 11, 18, 9),
      outcome: 'broken',
      minutes: 10,
    );
    await brain.rebuildIfNeeded();
    final rows = await d.db.select(d.db.brainEvents).get();
    expect(rows.map((r) => r.type).toSet(), {'neuron_gain', 'penalty'});
    await d.db.delete(d.db.brainEvents).go();
    await brain.rebuildIfNeeded(); // bayrak: ikinci kez çalışmaz
    expect(await d.db.select(d.db.brainEvents).get(), isEmpty);
  });

  test('katlama ve bölge istatistiği', () async {
    final id = await session('emotional_social', DateTime.utc(2026, 11, 18, 9));
    await brain.deriveFor(id);
    final h = await brain.watchHistory().first;
    expect(h.sessionRoots[id], 'emotional_social');
    final regions = [
      for (final r in await d.db.select(d.db.brainRegions).get()) r.key,
    ];
    final s = foldBrain(
      h.events,
      DateTime.utc(2026, 11, 19),
      regionKeys: regions,
      sessionRoots: h.sessionRoots,
    );
    expect(s.regions['amygdala']!.lit, 6000);
    expect(s.regions['amygdala']!.byRoot, {'emotional_social': 6000});
    await brain.cache(s, h);
    expect(await d.db.select(d.db.brainSnapshots).get(), hasLength(1));

    final stats = await brain.regionStats(
      'amygdala',
      DateTime.utc(2026, 11, 19, 9),
    );
    expect(stats.days, hasLength(30));
    expect(stats.days.last.day, '2026-11-19');
    expect(stats.days[28], (day: '2026-11-18', neurons: 6));
    expect(stats.totalMinutes, 30);
    expect(stats.minutesByCategory, {'root:emotional_social': 30});
  });

  test('tohum kurulum başına sabit', () async {
    final a = await brain.seed();
    expect(await brain.seed(), a);
  });

  test(
    'Drift v1 → v2: eski bölgeler ve olaylar gider, anatomik seed gelir',
    () async {
      final dir = await Directory.systemTemp.createTemp('neuroplan_mig');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/db.sqlite');

      // v1 biçimini kur: yeni sütunları düşür, eski bölge + olay + outbox ekle.
      final v2 = AppDatabase(NativeDatabase(file), systemData: systemData);
      expect(
        await v2.select(v2.brainRegions).get(),
        hasLength(18),
      ); // oluşturur
      await v2.customStatement('PRAGMA foreign_keys = OFF');
      await v2.customStatement('DELETE FROM category_region_weights');
      await v2.customStatement('DELETE FROM brain_regions');
      await v2.customStatement(
        'ALTER TABLE brain_regions DROP COLUMN is_inner',
      );
      await v2.customStatement(
        'ALTER TABLE category_region_weights DROP COLUMN detail_tr',
      );
      await v2.customStatement(
        'ALTER TABLE category_region_weights DROP COLUMN detail_en',
      );
      await v2.customStatement(
        "INSERT INTO brain_regions VALUES ('dlpfc', 1, 'DLPFC', 'DLPFC', 'bilateral', 'region_dlpfc')",
      );
      await v2.customStatement(
        "INSERT INTO brain_events (id, type, region_key, amount, occurred_at, dedupe_key, engine_version, created_at, updated_at, field_versions) "
        "VALUES ('e1', 'neuron_gain', 'dlpfc', 1000, '2026-11-18T00:00:00.000Z', 'gain:x:dlpfc:v1', 1, '2026-11-18T00:00:00.000Z', '2026-11-18T00:00:00.000Z', '{}')",
      );
      await v2.customStatement(
        "INSERT INTO sync_outbox (target_table, target_id, patch, hlc, created_at) "
        "VALUES ('brain_events', 'e1', '{}', 'h', '2026-11-18T00:00:00.000Z')",
      );
      await v2.customStatement('PRAGMA user_version = 1');
      await v2.close();

      final db = AppDatabase(NativeDatabase(file), systemData: systemData);
      addTearDown(db.close);
      final regions = await db.select(db.brainRegions).get();
      expect(regions, hasLength(18));
      expect(regions.where((r) => r.isInner), hasLength(6));
      expect(await db.select(db.brainEvents).get(), isEmpty);
      final outbox = await db.select(db.syncOutbox).get();
      expect(outbox.where((o) => o.targetTable == 'brain_events'), isEmpty);
      final w = await (db.select(
        db.categoryRegionWeights,
      )..where((w) => w.regionKey.equals('cingulate'))).get();
      expect(
        w.map((x) => x.detailEn),
        contains('Dorsal anterior cingulate cortex'),
      );
    },
  );
}
