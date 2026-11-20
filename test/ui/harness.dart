import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override, ProviderListenable;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/app.dart';
import 'package:neuroplan/app/focus_platform.dart';
import 'package:neuroplan/app/next_up.dart';
import 'package:neuroplan/app/notifications.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/ui/features/brain/brain_scene.dart';
import 'package:neuroplan/ui/features/focus/focus_controller.dart';
import 'package:drift/drift.dart' as drift show driftRuntimeOptions;

import '../data/test_support.dart';
import '../support/fake_brain_scene.dart';
import '../support/fake_focus_platform.dart';

/// 18 Kasım 2026 çarşamba 10:00 (İstanbul).
final testNow = DateTime.utc(2026, 11, 18, 7);

class Harness {
  Harness(this.tester, this.db, this.container, this.focus, this.brain);

  final FakeBrainScene brain;

  final FakeFocusPlatform focus;

  /// Odak sayacının saati; testte ileri alınır.
  static DateTime focusNow = testNow;

  final WidgetTester tester;
  final AppDatabase db;
  final ProviderContainer container;

  T read<T>(ProviderListenable<T> p) => container.read(p);

  /// Drift akışları gerçek zamanlayıcı ister; sahte zamanda birkaç tur pompalanır.
  Future<void> settle() async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 400));
    }
  }

  Future<void> tap(Finder f) async {
    await tester.ensureVisible(f);
    await tester.pump();
    await tester.tap(f);
    await settle();
  }

  Future<void> run(Future<void> Function() action) async {
    await tester.runAsync(action);
    await settle();
  }

  Future<void> expectAccessible() async {
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }
}

Future<Harness> pumpApp(
  WidgetTester tester, {
  bool onboarded = true,
  String locale = 'tr',
  Future<void> Function(ProviderContainer c)? seed,
  FakeFocusPlatform? focus,
  List<Override> overrides = const [],
}) async {
  final platform = focus ?? FakeFocusPlatform();
  Harness.focusNow = testNow;
  drift.driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  await tester.binding.setSurfaceSize(const Size(412, 915));
  final db = AppDatabase(NativeDatabase.memory(), systemData: systemData);
  final brain = FakeBrainScene();
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(db),
      nowProvider.overrideWith((ref) => Stream.value(testNow)),
      nextUpProvider.overrideWithValue(_NoNextUp()),
      focusPlatformProvider.overrideWithValue(platform),
      focusNowProvider.overrideWithValue(() => Harness.focusNow),
      brainSceneProvider.overrideWithValue(brain),
      ...overrides,
    ],
  );
  await tester.runAsync(() async {
    final profiles = container.read(profileRepositoryProvider);
    await profiles.ensure(timezone: 'Europe/Istanbul');
    await profiles.update(
      ProfilesCompanion(
        locale: Value(locale),
        onboardingCompletedAt: Value(onboarded ? DateTime.utc(2026) : null),
      ),
    );
    await seed?.call(container);
  });
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const NeuroPlanApp(),
    ),
  );
  final h = Harness(tester, db, container, platform, brain);
  await h.settle();
  addTearDown(() async {
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    await tester.runAsync(db.close);
    await tester.binding.setSurfaceSize(null);
  });
  return h;
}

/// Testte bildirim ve widget eklentisi yok.
class _NoNextUp extends NextUp {
  _NoNextUp() : super(Notifications());

  @override
  Future<void> sync(
    view,
    l, {
    required lead,
    required exact,
    auto = false,
  }) async {}
}
