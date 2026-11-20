import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/app/theme.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/l10n/app_localizations.dart';
import 'package:neuroplan/ui/features/stats/stats_page.dart';
import 'package:neuroplan/ui/features/stats/stats_providers.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'harness.dart';

/// [daysAgo] gün önce yerel [hour]'da biten, puanlı bir odak oturumu (testNow: 18 Kasım).
Future<String> addSession(
  ProviderContainer c, {
  required int daysAgo,
  int hour = 8,
  int minutes = 30,
  String mode = 'deep',
  String root = 'learning_memory',
  int? focus = 4,
  int? fatigue = 2,
  String outcome = 'completed',
}) async {
  final repo = c.read(focusRepositoryProvider);
  // İstanbul UTC+3.
  final start = DateTime.utc(2026, 11, 18 - daysAgo, hour - 3);
  final s = await repo.start(
    mode: mode,
    rootCategoryKey: root,
    startedAt: start,
  );
  await repo.finish(
    s.id,
    outcome: outcome,
    focusedSeconds: minutes * 60,
    endedAt: start.add(Duration(minutes: minutes)),
  );
  await repo.rate(s.id, focusRating: focus, fatigueRating: fatigue);
  return s.id;
}

Future<void> open(Harness h, StatPage p) async {
  h.read(routerProvider).push('/profile/stats/${p.name}');
  await h.settle();
}

void main() {
  testWidgets(
    'boş veri: her analiz sayfası boş durumunu ve eylemini gösterir',
    (t) async {
      final h = await pumpApp(t);
      for (final p in StatPage.values) {
        await open(h, p);
        expect(
          find.text(p.question(lookupL10n(const Locale('tr')))),
          findsOneWidget,
        );
        expect(find.byType(FilledButton), findsWidgets, reason: p.name);
        h.read(routerProvider).pop();
        await h.settle();
      }
      // Boş durumun eylemi gerçekten bir yere götürür.
      await open(h, StatPage.time);
      await h.tap(find.text('İlk odak oturumunu başlat'));
      expect(
        h.read(routerProvider).routerDelegate.currentConfiguration.uri.path,
        '/today',
      );
    },
  );

  testWidgets('veriyle: zaman, en iyi saat, seri, kalite, denge ve rapor', (
    t,
  ) async {
    final h = await pumpApp(
      t,
      seed: (c) async {
        for (var d = 0; d < 4; d++) {
          await addSession(c, daysAgo: d, hour: 8, focus: 5);
        }
        await addSession(
          c,
          daysAgo: 1,
          hour: 15,
          root: 'body_movement',
          focus: 2,
        );
      },
    );
    // Profil kartları
    await h.tap(find.text('Profil').last);
    expect(find.text('4 gün'), findsOneWidget); // seri
    await h.expectAccessible();

    await open(h, StatPage.time);
    expect(find.textContaining('Öğrenme ve Bellek alanına'), findsOneWidget);
    await h.expectAccessible();
    // Köke dokununca alt düzeye iner; kategorisiz dakikalar ayrı satır.
    await h.tap(find.text('Öğrenme ve Bellek'));
    expect(find.text('Bir üst düzey'), findsOneWidget);
    await h.tap(find.text('Alt kategorisiz'));
    expect(find.textContaining('Öğrenme'), findsWidgets);
    h.read(routerProvider).pop();
    await h.settle();

    await open(h, StatPage.bestHours);
    expect(
      find.textContaining('En iyi odak saatin 07:00–09:00'),
      findsOneWidget,
    );
    h.read(routerProvider).pop();
    await h.settle();

    await open(h, StatPage.consistency);
    expect(
      find.text('Güncel serin 4 gün, en uzun serin 4 gün.'),
      findsOneWidget,
    );
    h.read(routerProvider).pop();
    await h.settle();

    await open(h, StatPage.quality);
    expect(find.text('Odak puanı'), findsWidgets);
    await h.tap(find.text('Ay'));
    expect(find.text('Odak puanı'), findsWidgets);
    h.read(routerProvider).pop();
    await h.settle();

    await open(h, StatPage.balance);
    expect(find.textContaining('alana odak zamanı ayrılmadı'), findsOneWidget);
    await h.expectAccessible();
    h.read(routerProvider).pop();
    await h.settle();

    await open(h, StatPage.weekly);
    expect(find.text('Görsel olarak paylaş'), findsOneWidget);
    expect(find.text('Tamamlanan oturum'), findsOneWidget);
    await h.expectAccessible();
  });

  testWidgets('modlar: veri azsa yol gösterir, yeterliyse karşılaştırır', (
    t,
  ) async {
    final h = await pumpApp(
      t,
      seed: (c) async {
        for (var d = 0; d < 5; d++) {
          await addSession(c, daysAgo: d, mode: 'pomodoro', focus: 3);
        }
      },
    );
    await open(h, StatPage.modes);
    expect(
      find.text(
        "Karşılaştırma için Pomodoro'dan 0, derin çalışmadan 5 oturum daha gerekiyor.",
      ),
      findsOneWidget,
    );
  });

  testWidgets('modlar: her moddan 5 oturum olunca kendi veriyle kıyaslar', (
    t,
  ) async {
    final h = await pumpApp(
      t,
      seed: (c) async {
        for (var d = 0; d < 5; d++) {
          await addSession(c, daysAgo: d, mode: 'pomodoro', focus: 3);
          await addSession(c, daysAgo: d, hour: 10, focus: 5);
        }
      },
    );
    await open(h, StatPage.modes);
    expect(
      find.textContaining('derin çalışmada odak puanın daha yüksek'),
      findsOneWidget,
    );
  });

  testWidgets('kesintiler: sebep ve saat; dokununca oturumlar listelenir', (
    t,
  ) async {
    final h = await pumpApp(
      t,
      seed: (c) async {
        final id = await addSession(c, daysAgo: 1, hour: 14);
        await c
            .read(focusRepositoryProvider)
            .recordInterruption(
              FocusInterruptionsCompanion.insert(
                id: newId(),
                sessionId: id,
                leftAt: DateTime.utc(2026, 11, 17, 11, 10),
                awayMs: 4000,
                reason: 'app_left',
                recovered: true,
                counted: true,
              ),
            );
      },
    );
    await open(h, StatPage.interruptions);
    expect(
      find.textContaining('en sık sebep: Uygulamadan çıkış'),
      findsOneWidget,
    );
    await h.tap(find.text('Uygulamadan çıkış').first);
    expect(find.textContaining('Uygulamadan çıkış · 1'), findsOneWidget);
    await h.expectAccessible();
  });

  testWidgets('uyku: pencere 7 saatin altındaysa sakin not; hedef ayardan', (
    t,
  ) async {
    final h = await pumpApp(
      t,
      seed: (c) async {
        final repo = c.read(activityRepositoryProvider);
        final a = await repo.create(
          ActivitiesCompanion.insert(
            id: newId(),
            kind: 'routine',
            title: 'Uyku',
            rootCategoryKey: const Value('rest_sleep'),
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
                start: [TimeConstraint(ConstraintOp.at, ClockRef(1, 0))],
                end: [TimeConstraint(ConstraintOp.at, ClockRef(7, 0))],
              ),
            ),
          ),
        );
      },
    );
    await open(h, StatPage.sleep);
    expect(
      find.textContaining('Planlanan uykun ortalama 6 sa'),
      findsOneWidget,
    );
    expect(find.textContaining('hedefinden 2 sa az'), findsOneWidget);
    expect(find.textContaining('7 saatin altında'), findsOneWidget);
  });

  testWidgets('projeler: kalan iş ve tahmin', (t) async {
    final h = await pumpApp(
      t,
      seed: (c) async {
        final repo = c.read(activityRepositoryProvider);
        final a = await repo.create(
          ActivitiesCompanion.insert(
            id: newId(),
            kind: 'project',
            title: 'Tez',
          ),
        );
        await repo.saveProject(
          a.id,
          ProjectsCompanion(
            totalMinutes: const Value(600),
            deadlineAt: Value(DateTime.utc(2026, 12, 20, 20)),
          ),
        );
      },
    );
    await open(h, StatPage.projects);
    expect(find.text('Tez'), findsOneWidget);
    expect(find.textContaining('Kalan 10 sa'), findsOneWidget);
    expect(find.textContaining('son tarih'), findsOneWidget);
  });

  testWidgets('dışa aktarma: eşitlenen tablolar tek JSON', (t) async {
    final h = await pumpApp(t, seed: (c) => addSession(c, daysAgo: 0));
    final json = await t.runAsync(
      () => h.read(statsRepositoryProvider).exportJson(testNow),
    );
    final j = jsonDecode(json!) as Map<String, Object?>;
    final tables = j['tables']! as Map<String, Object?>;
    expect(tables.keys, contains('focus_sessions'));
    expect((tables['focus_sessions']! as List).single, isA<Map>());
    expect(tables.keys, contains('profiles'));
  });

  testWidgets(
    'temalar: her tema açık ve koyuda kontrast ve dokunma kurallarını geçer',
    (t) async {
      final h = await pumpApp(t, seed: (c) => addSession(c, daysAgo: 0));
      await h.tap(find.text('Profil').last);
      for (final theme in AppTheme.values) {
        for (final mode in ['light', 'dark']) {
          await h.run(
            () => h
                .read(profileRepositoryProvider)
                .update(
                  ProfilesCompanion(
                    theme: Value(theme.name),
                    themeMode: Value(mode),
                  ),
                ),
          );
          final ctx = t.element(find.byType(Scaffold).last);
          expect(AppTokens.of(ctx).theme, theme);
          await h.expectAccessible();
        }
      }
      // Ayarlardan seçilen tema kaydedilir; Ciddi seçilince anahtar boşalır (varsayılan).
      await h.tap(find.byTooltip('Ayarlar'));
      await h.tap(find.text('Görünüm ve tema'));
      await h.tap(find.text('Ciddi'));
      final p = await t.runAsync(() => h.read(profileRepositoryProvider).get());
      expect(p!.theme, isNull);
    },
  );
}
