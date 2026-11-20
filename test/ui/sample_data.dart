import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'stats_test.dart' show addSession;

/// Gerçekçi örnek veri: bir rutin, bir proje, altı günlük odak oturumu (tema matrisi ve
/// golden testleri ortak kullanır). Kullanıcı içeriğidir, test dışında hazır gelmez.
Future<void> seedSample(ProviderContainer c) async {
  final repo = c.read(activityRepositoryProvider);
  final a = await repo.create(
    ActivitiesCompanion.insert(
      id: newId(),
      kind: 'routine',
      title: 'Okuma',
      rootCategoryKey: const Value('learning_memory'),
      requiresFocus: const Value(true),
    ),
  );
  await repo.addRule(
    ScheduleRulesCompanion.insert(
      id: newId(),
      activityId: a.id,
      recurrence: const RRuleRecurrence(
        dtstart: '2026-11-01',
        rrule: 'FREQ=DAILY',
      ),
      timing: Value(
        Timing(
          start: [TimeConstraint(ConstraintOp.at, ClockRef(11, 0))],
          end: [TimeConstraint(ConstraintOp.at, ClockRef(12, 0))],
        ),
      ),
    ),
  );
  final p = await repo.create(
    ActivitiesCompanion.insert(id: newId(), kind: 'project', title: 'Tez'),
  );
  await repo.saveProject(
    p.id,
    ProjectsCompanion(
      totalMinutes: const Value(600),
      deadlineAt: Value(DateTime.utc(2026, 12, 20, 20)),
    ),
  );
  const roots = [
    'learning_memory',
    'body_movement',
    'creativity_art',
    'music_rhythm',
  ];
  for (var d = 0; d < 6; d++) {
    await addSession(
      c,
      daysAgo: d,
      hour: 8 + d,
      root: roots[d % roots.length],
      mode: d.isEven ? 'deep' : 'pomodoro',
    );
  }
}
