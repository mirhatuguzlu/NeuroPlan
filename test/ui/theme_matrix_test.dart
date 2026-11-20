import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/app/theme.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/ui/features/stats/stats_page.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'harness.dart';
import 'stats_test.dart' show addSession;

/// Her tema × görünüm × ekran (D55): kontrast, dokunma alanı, etiket ve taşma.
const _screens = [
  '/today',
  '/plan',
  '/brain',
  '/together',
  '/profile',
  '/profile/settings',
  '/profile/sources',
  '/profile/about',
  '/brain/categories',
  '/brain/list',
  '/add',
];

Future<void> _seed(ProviderContainer c) async {
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

Future<void> _visit(Harness h, String path, {bool a11y = true}) async {
  h.read(routerProvider).go(path);
  await h.settle();
  if (a11y) await h.expectAccessible();
}

void main() {
  for (final theme in AppTheme.values) {
    for (final mode in const ['light', 'dark']) {
      testWidgets('${theme.name} · $mode: bütün ekranlar erişilebilir', (
        t,
      ) async {
        final h = await pumpApp(
          t,
          seed: (c) async {
            await _seed(c);
            await c
                .read(profileRepositoryProvider)
                .update(
                  ProfilesCompanion(
                    theme: Value(theme.name),
                    themeMode: Value(mode),
                  ),
                );
          },
        );
        final ctx = t.element(find.byType(Scaffold).first);
        expect(AppTokens.of(ctx).theme, theme);
        expect(
          Theme.of(ctx).brightness,
          mode == 'dark' ? Brightness.dark : Brightness.light,
        );
        for (final p in _screens) {
          await _visit(h, p);
        }
        for (final p in StatPage.values) {
          await _visit(h, '/profile/stats/${p.name}');
        }
      });
    }
  }

  // Taşma (RenderFlex overflow) test çerçevesinde hata sayılır: her boyutta ekranlar gezilir.
  for (final (name, size, scale) in const [
    ('küçük telefon', Size(320, 640), 1.0),
    ('küçük telefon, yazı 1.6', Size(360, 740), 1.6),
    ('yatay telefon', Size(915, 412), 1.0),
    ('tablet', Size(1024, 1366), 1.0),
    ('katlanabilir açık', Size(884, 1104), 1.3),
  ]) {
    for (final theme in const [AppTheme.serious, AppTheme.young]) {
      testWidgets('düzen: $name · ${theme.name}', (t) async {
        final h = await pumpApp(
          t,
          seed: (c) async {
            await _seed(c);
            await c
                .read(profileRepositoryProvider)
                .update(ProfilesCompanion(theme: Value(theme.name)));
          },
        );
        await t.binding.setSurfaceSize(size);
        t.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
        await h.settle();
        for (final p in _screens) {
          await _visit(h, p, a11y: false);
        }
        for (final p in StatPage.values) {
          await _visit(h, '/profile/stats/${p.name}', a11y: false);
        }
      });
    }
  }
}
