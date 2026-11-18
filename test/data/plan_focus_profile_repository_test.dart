import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/data/repositories/activity_repository.dart';
import 'package:neuroplan/data/repositories/focus_repository.dart';
import 'package:neuroplan/data/repositories/plan_repository.dart';
import 'package:neuroplan/data/repositories/profile_repository.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'test_support.dart';

void main() {
  late TestDevice d;

  setUp(() => d = TestDevice());
  tearDown(() => d.db.close());

  group('ProfileRepository', () {
    test('ensure bir kez oluşturur, update değiştirir', () async {
      final repo = ProfileRepository(d.db, d.writer);
      final p = await repo.ensure(timezone: 'Europe/Istanbul');
      expect(p.themeMode, 'system');
      await repo.ensure(timezone: 'UTC');
      expect((await repo.get())!.timezone, 'Europe/Istanbul');

      await repo.update(const ProfilesCompanion(sleepGoalMinutes: Value(450)));
      expect((await repo.get())!.sleepGoalMinutes, 450);
      expect(await d.outbox(), hasLength(2));
    });
  });

  group('PlanRepository', () {
    late PlanRepository repo;
    late ScheduleRule rule;

    setUp(() async {
      repo = PlanRepository(d.db, d.writer);
      final activities = ActivityRepository(d.db, d.writer);
      final a = await activities.create(
        ActivitiesCompanion.insert(id: newId(), kind: 'routine', title: 'Koşu'),
      );
      rule = await activities.addRule(
        ScheduleRulesCompanion.insert(
          id: newId(),
          activityId: a.id,
          recurrence: const PerPeriodRecurrence(
            count: 3,
            unit: PeriodUnit.week,
          ),
        ),
      );
    });

    test('gün kuralı: ya tarih ya tekrar; silinebilir', () async {
      expect(
        () => repo.addDayOverride(
          const DayOverridesCompanion(keep: Value('none')),
        ),
        throwsArgumentError,
      );
      final sunday = await repo.addDayOverride(
        const DayOverridesCompanion(
          recurrence: Value(
            RRuleRecurrence(
              dtstart: '2026-11-22',
              rrule: 'FREQ=WEEKLY;BYDAY=SU',
            ),
          ),
          keep: Value('fixed_only'),
        ),
      );
      expect((await repo.watchDayOverrides().first).single.id, sunday.id);
      await repo.deleteDayOverride(sunday.id);
      expect(await repo.watchDayOverrides().first, isEmpty);
    });

    test('kural oluşumu deterministik kimlikle tek satır; elle düzenleneni motor ezmez', () async {
      final first = await repo.upsertRuleInstance(
        ruleId: rule.id,
        activityId: rule.activityId,
        occurrenceDate: '2026-11-19',
      );
      expect(first.id, ruleInstanceId(rule.id, '2026-11-19'));

      final start = DateTime.utc(2026, 11, 19, 7);
      final again = await repo.upsertRuleInstance(
        ruleId: rule.id,
        activityId: rule.activityId,
        occurrenceDate: '2026-11-19',
        startAt: start,
      );
      expect(again.id, first.id);
      expect(again.startAt, start);

      await repo.reschedule(first.id, startAt: DateTime.utc(2026, 11, 19, 18));
      final engine = await repo.upsertRuleInstance(
        ruleId: rule.id,
        activityId: rule.activityId,
        occurrenceDate: '2026-11-19',
        startAt: start,
      );
      expect(engine.startAt, DateTime.utc(2026, 11, 19, 18));

      await repo.setStatus(first.id, 'done');
      expect((await repo.watchDay('2026-11-19').first).single.status, 'done');
    });
  });

  group('FocusRepository', () {
    late FocusRepository repo;

    setUp(() => repo = FocusRepository(d.db, d.writer));

    test('oturum aktivitenin kökünü kopyalar; biten oturum değişmez, puanlanabilir', () async {
      final a = await ActivityRepository(d.db, d.writer).create(
        ActivitiesCompanion.insert(
          id: newId(),
          kind: 'one_off',
          title: 'Annemle konuşmak',
          rootCategoryKey: const Value('emotional_social'),
        ),
      );
      final s = await repo.start(mode: 'free', activityId: a.id);
      expect(s.rootCategoryKey, 'emotional_social');
      expect(s.outcome, 'in_progress');

      await repo.finish(s.id, outcome: 'completed', focusedSeconds: 1200);
      expect(
        () => repo.finish(s.id, outcome: 'broken', focusedSeconds: 1),
        throwsStateError,
      );
      final rated = await repo.rate(s.id, focusRating: 4);
      expect(rated.focusRating, 4);
      expect(rated.focusedSeconds, 1200);
    });

    test(
      'kesinti ve beyin olayı yalnız eklenir, tekrar gelen yok sayılır',
      () async {
        final s = await repo.start(
          mode: 'pomodoro',
          rootCategoryKey: 'learning_memory',
        );
        final interruption = FocusInterruptionsCompanion.insert(
          id: newId(),
          sessionId: s.id,
          leftAt: DateTime.utc(2026, 11, 18, 10, 5),
          awayMs: 4000,
          reason: 'notification_shade',
          recovered: true,
          counted: true,
        );
        expect(await repo.recordInterruption(interruption), isTrue);
        expect(await repo.recordInterruption(interruption), isFalse);

        BrainEventsCompanion event() => BrainEventsCompanion.insert(
          id: newId(),
          type: 'neuron_gain',
          regionKey: const Value('hippocampus'),
          amount: 1000,
          occurredAt: DateTime.utc(2026, 11, 18, 10, 30),
          sessionId: Value(s.id),
          dedupeKey: 'gain:${s.id}:hippocampus:v1',
          engineVersion: 1,
        );
        expect(await repo.appendBrainEvent(event()), isTrue);
        expect(
          await repo.appendBrainEvent(event()),
          isFalse,
          reason: 'aynı dedupe_key',
        );
        expect(await d.db.select(d.db.brainEvents).get(), hasLength(1));
      },
    );
  });
}
