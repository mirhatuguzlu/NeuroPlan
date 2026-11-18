import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../data/local/app_database.dart';
import '../data/plan/plan_source.dart';
import '../data/repositories/activity_repository.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/focus_repository.dart';
import '../data/repositories/plan_repository.dart';
import '../data/repositories/prefs_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/sync/hlc_clock.dart';
import '../data/sync/local_writer.dart';

/// main() gerçek veritabanıyla, testler bellek içi veritabanıyla geçersiz kılar.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider override edilmeli'),
);

final writerProvider = Provider(
  (ref) => LocalWriter(
    ref.watch(databaseProvider),
    HlcClock(ref.watch(databaseProvider)),
  ),
);

final profileRepositoryProvider = Provider(
  (ref) =>
      ProfileRepository(ref.watch(databaseProvider), ref.watch(writerProvider)),
);
final categoryRepositoryProvider = Provider(
  (ref) => CategoryRepository(
    ref.watch(databaseProvider),
    ref.watch(writerProvider),
  ),
);
final activityRepositoryProvider = Provider(
  (ref) => ActivityRepository(
    ref.watch(databaseProvider),
    ref.watch(writerProvider),
  ),
);
final planRepositoryProvider = Provider(
  (ref) =>
      PlanRepository(ref.watch(databaseProvider), ref.watch(writerProvider)),
);
final focusRepositoryProvider = Provider(
  (ref) =>
      FocusRepository(ref.watch(databaseProvider), ref.watch(writerProvider)),
);
final prefsRepositoryProvider = Provider(
  (ref) => PrefsRepository(ref.watch(databaseProvider)),
);

final profileProvider = StreamProvider<Profile?>(
  (ref) => ref.watch(profileRepositoryProvider).watch(),
);

/// Sistem verisi: kök kategoriler, bölgeler, ağırlıklar (yalnız migration ile değişir).
final rootCategoriesProvider = FutureProvider<List<RootCategory>>(
  (ref) => ref.watch(categoryRepositoryProvider).rootCategories(),
);
final brainRegionsProvider = FutureProvider<Map<String, BrainRegion>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  return {for (final r in await db.select(db.brainRegions).get()) r.key: r};
});
final regionWeightsProvider =
    FutureProvider.family<List<CategoryRegionWeight>, String>(
      (ref, root) => ref.watch(categoryRepositoryProvider).weightsFor(root),
    );

final categoriesProvider = StreamProvider<List<UserCategory>>(
  (ref) => ref.watch(categoryRepositoryProvider).watchAll(),
);

/// Dakikada bir ilerleyen "şimdi"; testte sabitlenir.
final nowProvider = StreamProvider<DateTime>((ref) async* {
  yield DateTime.now();
  yield* Stream.periodic(const Duration(minutes: 1), (_) => DateTime.now());
});

final planDataProvider = StreamProvider<PlanData?>(
  (ref) => PlanSource(ref.watch(databaseProvider)).watch(),
);

/// Bir motor çalıştırmasının sonucu + ekranların ihtiyaç duyduğu satırlar.
class PlanView {
  PlanView(this.data, this.output, this.now);

  final PlanData data;
  final PlanOutput output;
  final DateTime now;

  PlanCalendar get calendar => data.calendar;
  int get nowMinute => now.millisecondsSinceEpoch ~/ 60000;
  String get today => calendar.dayOf(nowMinute).iso;

  late final Map<String, PlannedInstance> byId = {
    for (final i in output.instances) i.id: i,
  };

  List<PlannedInstance> on(String date) => [
    for (final i in output.instances)
      if (i.date == date) i,
  ];
}

/// Plan verisi ve "şimdi" hazır olunca motoru [range] aralığında çalıştırır.
AsyncValue<PlanView?> _plan(
  Ref ref,
  (String, String) Function(PlanData data, Day today) range,
) {
  final data = ref.watch(planDataProvider);
  final now = ref.watch(nowProvider);
  return switch ((data, now)) {
    (AsyncData(value: final d?), AsyncData(value: final n)) => () {
      final (from, to) = range(
        d,
        d.calendar.dayOf(n.millisecondsSinceEpoch ~/ 60000),
      );
      return AsyncData<PlanView?>(
        PlanView(
          d,
          const PlanEngine().plan(d.input(from: from, to: to, now: n)),
          n,
        ),
      );
    }(),
    (AsyncData(value: null), _) => const AsyncData(null),
    (AsyncError(:final error, :final stackTrace), _) ||
    (
      _,
      AsyncError(:final error, :final stackTrace),
    ) => AsyncError(error, stackTrace),
    _ => const AsyncLoading(),
  };
}

/// Bugünden itibaren en az iki hafta, en geç son tarihi en uzak projeye kadar (en çok
/// 180 gün): proje önerileri ve son tarih riski bu aralıkta hesaplanır (ARCHITECTURE §6.10).
final horizonProvider = Provider<AsyncValue<PlanView?>>(
  (ref) => _plan(ref, (d, today) {
    var to = today.add(13);
    for (final p in d.projects) {
      if (p.deadlineAt == null) continue;
      final day = d.calendar.dayOf(
        p.deadlineAt!.millisecondsSinceEpoch ~/ 60000,
      );
      if (day.isAfter(to)) to = day;
    }
    if (to.isAfter(today.add(180))) to = today.add(180);
    return (today.iso, to.iso);
  }),
);

/// Plan ekranının hafta görünümü: [weekStart] pazartesisinden itibaren 7 gün.
final weekPlanProvider = Provider.family<AsyncValue<PlanView?>, String>(
  (ref, weekStart) =>
      _plan(ref, (_, _) => (weekStart, Day.parse(weekStart).add(6).iso)),
);
