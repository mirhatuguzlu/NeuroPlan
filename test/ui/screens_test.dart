import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/ui/core/app_shell.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'harness.dart';

/// Her gün [hhmm]'de [minutes] dakikalık kesin iş.
Future<String> addDaily(
  ProviderContainer c,
  String title, {
  int hour = 11,
  int minutes = 60,
  bool focus = false,
}) async {
  final repo = c.read(activityRepositoryProvider);
  final a = await repo.create(
    ActivitiesCompanion.insert(
      id: newId(),
      kind: 'routine',
      title: title,
      rootCategoryKey: const Value('learning_memory'),
      requiresFocus: Value(focus),
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
        Timing(start: [TimeConstraint(ConstraintOp.at, ClockRef(hour, 0))]),
      ),
      durationMinMinutes: Value(minutes),
      durationMaxMinutes: Value(minutes),
    ),
  );
  return a.id;
}

void main() {
  testWidgets(
    'ilk kurulum: 7 adım atlanabilir, sonunda boş Bugün ilk adımı gösterir',
    (t) async {
      final h = await pumpApp(t, onboarded: false);
      expect(find.text('1 / 7'), findsOneWidget);
      expect(find.text('Hangi dili kullanalım?'), findsOneWidget);
      await h.expectAccessible();
      for (var i = 0; i < 6; i++) {
        await h.tap(find.text('Şimdilik geç'));
      }
      expect(find.text('7 / 7'), findsOneWidget);
      expect(find.text('İlk rutinimi ekle'), findsOneWidget);
      await h.tap(find.text('Şimdilik geç'));
      expect(find.text('Planın henüz boş'), findsOneWidget);
      expect(find.text('İlk rutinini ekle'), findsOneWidget);
      expect(h.read(profileProvider).value?.onboardingCompletedAt, isNotNull);
    },
  );

  testWidgets(
    'ilk kurulum: uyku penceresi kesin bir aktivite olarak kaydedilir',
    (t) async {
      final h = await pumpApp(t, onboarded: false);
      await h.tap(find.text('Şimdilik geç'));
      await h.tap(find.text('Şimdilik geç'));
      expect(find.text('Genelde ne zaman uyursun?'), findsOneWidget);
      await h.tap(find.text('İleri'));
      final data = await t.runAsync(() => h.read(planDataProvider.future));
      final sleep = data!.activities.values.single;
      expect(sleep.title, 'Uyku');
      expect(sleep.rootCategoryKey, 'rest_sleep');
      expect(data.rules.single.flexibility, 'fixed');
      expect(data.profile.sleepGoalMinutes, 480);
    },
  );

  testWidgets('Bugün: sıradaki iş, boş dilimler ve odak etiketi görünür', (
    t,
  ) async {
    final h = await pumpApp(t, seed: (c) => addDaily(c, 'Okuma', focus: true));
    expect(find.text('Sıradaki'), findsOneWidget);
    expect(find.text('Okuma'), findsWidgets);
    expect(find.textContaining('Boş ·'), findsWidgets);
    expect(find.text('Odak gerektirir'), findsOneWidget);
    await h.expectAccessible();
  });

  testWidgets('Bugün: "Bitti" satırı yazar, geri al eski haline döndürür', (
    t,
  ) async {
    final h = await pumpApp(t, seed: (c) => addDaily(c, 'Okuma'));
    await h.tap(find.text('Okuma').last);
    await h.tap(find.text('Bitti'));
    expect(find.text('Okuma tamamlandı'), findsOneWidget);
    expect(find.text('Yapıldı'), findsOneWidget);
    await h.tap(find.text('Geri al'));
    expect(find.text('Yapıldı'), findsNothing);
  });

  testWidgets('Ekle → sihirbaz → kaydet: iş Bugün\'de görünür', (t) async {
    final h = await pumpApp(t);
    await h.tap(find.byTooltip('Ekle'));
    expect(find.text('Ne?'), findsOneWidget);
    await h.expectAccessible();
    await t.enterText(find.byType(TextFormField).first, 'Gitar');
    await h.settle();
    // Her satır o adımı geçer: ne → kategori → ne zaman → saat → esneklik → süre →
    // varyant → odak → özet.
    await h.tap(find.text('İleri'));
    await h.tap(find.text('Müzik ve Ritim'));
    await h.tap(find.text('İleri'));
    await h.tap(find.text('İleri')); // her gün
    await h.tap(find.text('İleri')); // sabit 09:00
    await h.tap(
      find.text('Şimdilik geç'),
    ); // esneklik: saat türünün varsayılanı
    await h.tap(find.text('İleri')); // süre boş
    await h.tap(find.text('Şimdilik geç')); // varyant yok
    await h.tap(find.text('Şimdilik geç')); // odak: kategoriden
    expect(find.text('Özet'), findsOneWidget);
    expect(find.text('Gitar'), findsOneWidget);
    await h.tap(find.text('Kaydet'));
    expect(find.text('Gitar eklendi'), findsOneWidget);
    final data = await t.runAsync(() => h.read(planDataProvider.future));
    final a = data!.activities.values.single;
    expect(a.rootCategoryKey, 'music_rhythm');
    expect(data.rules.single.recurrence, isA<RRuleRecurrence>());
  });

  testWidgets('Plan: kurallar ve hafta görünümü', (t) async {
    final h = await pumpApp(t, seed: (c) => addDaily(c, 'Okuma'));
    await h.tap(find.text('Plan').last);
    expect(find.textContaining('Boş'), findsWidgets);
    await h.expectAccessible();
    await h.tap(find.text('Kurallar'));
    expect(find.text('Okuma'), findsOneWidget);
    expect(find.textContaining('Her gün'), findsOneWidget);
  });

  testWidgets('Beyin: kök kategoriler, bölgeler ve kanıt düzeyi', (t) async {
    final h = await pumpApp(t);
    await openCategories(h);
    expect(find.text('Bedensel Hareket'), findsOneWidget);
    await h.expectAccessible();
    await h.tap(find.text('Bedensel Hareket'));
    await h.tap(find.text('Beyninin neresini çalıştırır?'));
    expect(find.text('Hipokampüs'), findsOneWidget);
    expect(find.textContaining('Güçlü kanıt'), findsOneWidget);
  });

  testWidgets('Beyin: tutamaçtan sürükleyince iş kategoriye taşınır', (
    t,
  ) async {
    late String catId, actId;
    final h = await pumpApp(
      t,
      seed: (c) async {
        actId = await addDaily(c, 'Okuma');
        final cat = await c
            .read(categoryRepositoryProvider)
            .create(name: 'Kitaplar', rootCategoryKey: 'learning_memory');
        catId = cat.id;
      },
    );
    await openCategories(h);
    await h.tap(find.text('Öğrenme ve Bellek'));
    await centre(t, find.text('Okuma'));
    final g = await t.startGesture(t.getCenter(handleOf('Okuma')));
    await g.moveBy(const Offset(0, 20));
    await t.pump();
    await g.moveTo(t.getCenter(find.text('Kitaplar')));
    await t.pump();
    await g.up();
    await h.settle();
    expect(find.text('Okuma taşındı'), findsOneWidget);
    final data = await t.runAsync(() => h.read(planDataProvider.future));
    expect(data!.activities[actId]!.categoryId, catId);
  });

  testWidgets(
    'Beyin: alt kenarda tutunca liste kayar, bırakınca altına gelen başlığa taşınır',
    (t) async {
      late String actId;
      final h = await pumpApp(
        t,
        seed: (c) async => actId = await addDaily(c, 'Okuma'),
      );
      await openCategories(h);
      await h.tap(find.text('Öğrenme ve Bellek'));
      await centre(t, find.text('Okuma'));
      final scroll = t.state<ScrollableState>(
        find.byType(Scrollable).hitTestable().first,
      );
      final before = scroll.position.pixels;
      // Alt menünün hemen üstü: kayma bölgesinde ama liste içeriğinin üzerinde.
      final list = t.getRect(find.byWidget(scroll.widget));
      final hold = Offset(
        list.center.dx,
        list.bottom - AppShell.bottomInset(scroll.context) - 36,
      );
      final g = await t.startGesture(t.getCenter(handleOf('Okuma')));
      await g.moveBy(const Offset(0, 20));
      await t.pump();
      await g.moveTo(hold);
      for (var last = -1.0; last != scroll.position.pixels;) {
        last = scroll.position.pixels;
        for (var i = 0; i < 5; i++) {
          await t.pump(const Duration(milliseconds: 20));
        }
      }
      expect(scroll.position.pixels, scroll.position.maxScrollExtent);
      expect(scroll.position.pixels, greaterThan(before));
      // Parmak hiç oynamadan bırakılır; hedef kaymadan sonraki başlık olmalı.
      await g.up();
      await h.settle();
      final data = await t.runAsync(() => h.read(planDataProvider.future));
      expect(data!.activities[actId]!.rootCategoryKey, 'rest_sleep');
    },
  );

  testWidgets(
    'yazı ölçeği 2.0: Bugün, sihirbaz ve alt menü taşmaz (UX_RULES §9)',
    (t) async {
      t.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
      final h = await pumpApp(
        t,
        seed: (c) => addDaily(c, 'Okuma', focus: true),
      );
      expect(find.text('Sıradaki'), findsOneWidget);
      await h.tap(find.byTooltip('Ekle'));
      expect(find.text('Ne?'), findsOneWidget);
    },
  );

  testWidgets('Profil: ayarlar açılır', (t) async {
    final h = await pumpApp(t);
    await h.tap(find.text('Profil').last);
    expect(find.text('Profil ve ayarlar'), findsOneWidget);
    expect(find.text('Uyku penceresi'), findsOneWidget);
    await h.expectAccessible();
  });

  testWidgets('Proje: öneriler onaylanır, risk seçenekleri görünür', (t) async {
    late String id;
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
        id = a.id;
        await repo.saveProject(
          a.id,
          ProjectsCompanion(
            totalMinutes: const Value(6000),
            deadlineAt: Value(DateTime.utc(2026, 11, 20, 20)),
          ),
        );
      },
    );
    h.read(routerProvider).push('/project/$id');
    await h.settle();
    expect(find.text('Önerilen parçalar'), findsOneWidget);
    expect(find.textContaining('eksik kalıyor'), findsOneWidget);
    expect(find.text('Son tarihi taşı'), findsOneWidget);
    await h.expectAccessible();
    await h.tap(find.text('Hepsini onayla'));
    expect(find.textContaining('parça onaylandı'), findsOneWidget);
  });

  testWidgets('Proje (elle): parça tutamaçtan boş dilime sürüklenir', (
    t,
  ) async {
    late String id;
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
        id = a.id;
        await repo.saveProject(
          a.id,
          ProjectsCompanion(
            totalMinutes: const Value(120),
            deadlineAt: Value(DateTime.utc(2026, 11, 25, 20)),
            splitMode: const Value('manual'),
          ),
        );
      },
    );
    h.read(routerProvider).push('/project/$id');
    await h.settle();
    final handle = find.byIcon(Symbols.drag_indicator_rounded);
    await centre(t, handle);
    final g = await t.startGesture(t.getCenter(handle));
    await g.moveBy(const Offset(0, 20));
    await t.pump();
    await g.moveTo(
      t.getCenter(find.byIcon(Symbols.hourglass_empty_rounded).first),
    );
    await t.pump();
    await g.up();
    await h.settle();
    expect(find.text('Parça yerleştirildi'), findsOneWidget);
  });
}

/// [title] satırındaki sürükleme tutamacı.
Finder handleOf(String title) => find.descendant(
  of: find.widgetWithText(Row, title).first,
  matching: find.byIcon(Symbols.drag_indicator_rounded),
);

/// [f]'yi listenin ortasına kaydırır; kenardaki otomatik kayma bölgesine düşmesin.
Future<void> centre(WidgetTester t, Finder f) async {
  await Scrollable.ensureVisible(t.element(f), alignment: 0.5);
  await t.pump();
}

/// Beyin sekmesi → Liste görünümü → Kategoriler (D41).
Future<void> openCategories(Harness h) async {
  await h.tap(find.text('Beyin').last);
  await h.tap(find.byTooltip('Liste görünümü'));
  await h.tap(find.text('Kategoriler'));
}
