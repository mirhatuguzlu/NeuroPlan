import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../data/local/app_database.dart';
import '../../../data/plan/plan_source.dart';
import '../../../data/repositories/brain_repository.dart';
import '../../../data/repositories/stats_repository.dart';
import '../brain/brain_controller.dart';

final statsRepositoryProvider = Provider(
  (ref) => StatsRepository(ref.watch(databaseProvider)),
);

/// Biten oturumlar ve kesintiler; yazıldıkça yenilenir.
final statsSourceProvider = StreamProvider<StatsSource>(
  (ref) => ref.watch(statsRepositoryProvider).watch(),
);

/// Bütün analiz sayfalarında ortak zaman aralığı seçimi (bir kez seçilir, her sayfada kalır).
class PeriodNotifier extends Notifier<StatPeriod> {
  @override
  StatPeriod build() => StatPeriod.week;
  void set(StatPeriod p) => state = p;
}

final statPeriodProvider = NotifierProvider<PeriodNotifier, StatPeriod>(
  PeriodNotifier.new,
);

/// Analizin bütün girdisi hazır olunca.
class StatsContext {
  StatsContext({
    required this.data,
    required this.source,
    required this.history,
    required this.regions,
    required this.now,
  });

  final PlanData data;
  final StatsSource source;
  final BrainHistory history;
  final Map<String, BrainRegion> regions;
  final DateTime now;

  PlanCalendar get cal => data.calendar;
  late final Day today = cal.dayOf(now.millisecondsSinceEpoch ~/ 60000);
  List<StatSession> get sessions => source.sessions;

  /// `all` döneminin başı: kurulum günü ya da ilk oturum, hangisi önceyse.
  late final Day first = () {
    var d = cal.dayOf(data.profile.createdAt.millisecondsSinceEpoch ~/ 60000);
    for (final s in sessions) {
      final sd = sessionDay(s, cal);
      if (sd.isBefore(d)) d = sd;
    }
    return d;
  }();

  DayRange range(StatPeriod p) => DayRange.of(p, today, first: first);

  /// Bugünkü beyin (en güçlü ve sönen bölgeler için).
  late final BrainState brain = foldBrain(
    history.events,
    now.toUtc(),
    regionKeys: regions.keys.toList(),
    sessionRoots: history.sessionRoots,
  );
}

final statsContextProvider = Provider<AsyncValue<StatsContext>>((ref) {
  final data = ref.watch(planDataProvider);
  final source = ref.watch(statsSourceProvider);
  final history = ref.watch(brainHistoryProvider);
  final regions = ref.watch(brainRegionsProvider);
  final now = ref.watch(nowProvider);
  for (final v in [data, source, history, regions, now]) {
    if (v case AsyncError(:final error, :final stackTrace)) {
      return AsyncError(error, stackTrace);
    }
  }
  if (data.value case final d?
      when source.hasValue &&
          history.hasValue &&
          regions.hasValue &&
          now.hasValue) {
    return AsyncData(
      StatsContext(
        data: d,
        source: source.requireValue,
        history: history.requireValue,
        regions: regions.requireValue,
        now: now.requireValue,
      ),
    );
  }
  return const AsyncLoading();
});

/// Bir aralığın planı: uyum ölçülen işler ve uyku pencereleri.
class PlanHistory {
  const PlanHistory(this.items, this.sleep);
  final List<StatPlanItem> items;
  final List<({Day day, int minutes})> sleep;
}

/// Geçmiş aralığın planı motorla yeniden kurulur (planlananlar veritabanında değil, kurallardan
/// türer). 1 yıl ~0,5 sn sürdüğü için 31 günden uzun aralık ayrı isolate'te koşar ve sonuç
/// plan verisi değişene dek önbellekte kalır (D54).
final planHistoryProvider = FutureProvider.family<PlanHistory, DayRange>((
  ref,
  range,
) async {
  final data = await ref.watch(planDataProvider.future);
  if (data == null) return const PlanHistory([], []);
  final input = data.input(
    from: range.from.iso,
    to: range.to.iso,
    // Dakikalık "şimdi"ye abone olunmaz: yıllık koşu her dakika tekrarlanmasın.
    now: ref.read(nowProvider).value ?? DateTime.now(),
  );
  final out = range.length > 31
      ? await Isolate.run(() => const PlanEngine().plan(input))
      : const PlanEngine().plan(input);
  final items = <StatPlanItem>[];
  final sleep = <({Day day, int minutes})>[];
  for (final i in out.instances) {
    final a = data.activities[i.activityId];
    final root = a?.rootCategoryKey;
    final minutes = i.start != null && i.end != null ? i.end! - i.start! : null;
    if (root == 'rest_sleep') {
      if (minutes != null) {
        sleep.add((day: Day.parse(i.date), minutes: minutes));
      }
      continue;
    }
    if (a == null || a.kind == 'free_time') continue;
    items.add(
      StatPlanItem(
        activityId: i.activityId,
        day: Day.parse(i.date),
        status: i.status.name,
        minutes: minutes,
        rootKey: root,
      ),
    );
  }
  return PlanHistory(items, sleep);
});
