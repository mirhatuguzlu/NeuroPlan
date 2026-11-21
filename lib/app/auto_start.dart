import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../data/local/app_database.dart';
import '../data/plan/plan_source.dart';
import '../data/repositories/prefs_repository.dart';
import '../ui/features/focus/focus_controller.dart';
import 'next_up.dart';
import 'notifications.dart';
import 'providers.dart';
import 'router.dart';

/// Bugün'de açılıp gösterilecek oluşum ("yaptın mı?" bildirimine dokunuş).
final todayRevealProvider = NotifierProvider<TodayReveal, String?>(
  TodayReveal.new,
);

class TodayReveal extends Notifier<String?> {
  @override
  String? build() => null;

  void show(String? instanceId) => state = instanceId;
}

/// Geç kalma payı geçtikten sonra bildirimine dokunulan önerilen saatli odak işi: Bugün
/// "Şimdi başlat / önerilen saatte / Atla" diye sorar (D66).
final missedFocusProvider = NotifierProvider<MissedFocus, String?>(
  MissedFocus.new,
);

class MissedFocus extends Notifier<String?> {
  @override
  String? build() => null;

  void ask(String? instanceId) => state = instanceId;
}

final focusStarterProvider = Provider(FocusStarter.new);

/// Plandaki işten odak oturumu açar: işin modu, blok planı ve süresiyle (D63, D65, D66).
class FocusStarter {
  FocusStarter(this._ref);

  final Ref _ref;

  /// [slot]: işin başlaması gereken an (UTC dakika); geç kalınan süre saf odaktan düşer,
  /// sonraki işler kaymaz. Önerilen saatli iş bu ana sabitlenir.
  Future<void> start(PlanView view, PlannedInstance i, {int? slot}) async {
    final data = view.data;
    final now = _ref.read(focusNowProvider)().millisecondsSinceEpoch ~/ 60000;
    final saved = await savedFocusSettings(_ref.read(prefsRepositoryProvider));
    final mode = FocusMode.fromJson(data.focusMode(i.activityId));
    final blocks = data.focusBlocks(i.activityId);
    final length = i.isTimed ? i.end! - i.start! : null;
    // Saf odak: kalan işte kalan süre (D69), dağıtılan blokta ve proje parçasında süresi,
    // üst üste blokta molalar hariç süre (molaları yalnız kural oluşumunda motor ekler).
    final focus =
        i.minutes ??
        (i.blocks != null || i.ruleId == null
            ? length
            : length != null
            ? (blocks?.focusOf(length) ?? length)
            : plannedMinutes(data, i));
    final from = slot ?? (i.isTimed && !i.suggested ? i.start! : now);
    final late = math.max(0, now - from);
    var settings = saved[mode]!;
    // Dağıtılan blok tek bloktur; Pomodoro süresi bilinmiyorsa klasik (hedefsiz) kalır.
    if (blocks != null) {
      final block = i.blocks != null ? focus : blocks.block;
      settings = switch (mode) {
        FocusMode.deep => settings.copyWith(block: block, rest: blocks.rest),
        FocusMode.pomodoro => settings.copyWith(
          work: block,
          rest: blocks.rest,
          longRest: blocks.longRest,
          longEvery: blocks.longEvery,
          planned: focus != null,
        ),
        FocusMode.free => settings,
      };
    }
    if (i.suggested && length != null) {
      // Motor saati geçen öneriyi kaydırır; oturum açılan iş yerinde kalsın.
      await _ref
          .read(planRepositoryProvider)
          .moveOnce(i, _utc(from), _utc(from + length));
    }
    await _ref
        .read(focusControllerProvider.notifier)
        .start(
          instance: i,
          settings: settings,
          ownMinutes: focus == null ? null : math.max(1, focus - late),
        );
  }

  static DateTime _utc(int minute) =>
      DateTime.fromMillisecondsSinceEpoch(minute * 60000, isUtc: true);
}

/// Saatsiz işin süresi: kuralın, yoksa işin kendisinin.
int? plannedMinutes(PlanData data, PlannedInstance i) {
  final r = data.rules.where((r) => r.id == i.ruleId).firstOrNull;
  final m =
      r?.durationMaxMinutes ??
      r?.durationMinMinutes ??
      data.activities[i.activityId]?.estimatedMinutes;
  return m != null && m > 0 ? m : null;
}

/// Odak işlerini saatinde başlatır, bildirime dokunuşu işler ve kaçırılanları kapatır
/// (D63, D66):
/// - **Kesin saatli** (kullanıcının saat verdiği) iş saatinde başlamış sayılır: işin
///   bitişine kadar uygulamaya dönüş ya da bildirime dokunuş oturumu o an açar, geç
///   kalınan süre düşer. Hiç gelinmezse bitişte oturum bozulmuş sayılır.
/// - **Önerilen saatli** (motorun yerleştirdiği) işte işin geç kalma payı içinde dönülürse
///   oturum açılır. Pay geçince kaydırılabilir iş motorca ilk boşluğa kayar, kesin ve
///   isteğe bağlı iş atlanır; geç dokunulan bildirim Bugün'de kısa bir soru açar.
final autoStartProvider = Provider<void>((ref) {
  final tried = <String>{};
  String? pending; // plan hazır olmadan gelen dokunuş
  var busy = false;
  final prefs = ref.read(prefsRepositoryProvider);

  Future<Map<String, int>> readStarts() async {
    try {
      final raw = await prefs.get(PrefsRepository.focusStarts);
      return raw == null ? {} : (jsonDecode(raw) as Map).cast<String, int>();
    } on Object {
      return {};
    }
  }

  Future<void> handle(String payload) async {
    final cut = payload.indexOf(':');
    if (cut < 0) return;
    final kind = payload.substring(0, cut);
    var id = payload.substring(cut + 1);
    int? slot;
    if (id.indexOf('@') case final at when at > 0) {
      slot = int.tryParse(id.substring(at + 1));
      id = id.substring(0, at);
    }
    final focus = ref.read(focusControllerProvider);
    // "Mola bitti" bildirimi (`AndroidFocusPlatform.breakOverPayload`): odak sürer.
    if (kind == 'resume') {
      final phase = focus.clock?.phase;
      if (phase == FocusPhase.breakOver || phase == FocusPhase.onBreak) {
        await ref.read(focusControllerProvider.notifier).resume();
      }
      return;
    }
    final view = ref.read(horizonProvider).value;
    if (view == null) {
      pending = payload;
      return;
    }
    pending = null;
    final instance = view.byId[id];
    if (kind == 'focus' &&
        instance != null &&
        instance.status == InstanceStatus.planned &&
        !focus.active) {
      tried.add(id);
      final now = view.nowMinute;
      if (!instance.suggested && instance.isTimed) {
        if (now < instance.end! || instance.end == instance.start) {
          await ref.read(focusStarterProvider).start(view, instance);
          return;
        }
      } else {
        final start = slot ?? (await readStarts())[id] ?? instance.start ?? now;
        if (now < start + view.data.graceMinutes(instance.activityId)) {
          await ref
              .read(focusStarterProvider)
              .start(view, instance, slot: math.min(start, now));
          return;
        }
        ref.read(missedFocusProvider.notifier).ask(id);
        ref.read(routerProvider).go('/today');
        return;
      }
    }
    ref.read(todayRevealProvider.notifier).show(id);
    ref.read(routerProvider).go('/today');
  }

  Future<void> check() async {
    if (busy) return;
    busy = true;
    try {
      if (pending case final p?) return await handle(p);
      if (ref.read(autoRunProvider).value == false) return;
      if (ref.read(profileProvider).value?.onboardingCompletedAt == null) {
        return;
      }
      final focus = ref.read(focusControllerProvider);
      if (focus.active || focus.ended != null) return;
      final view = ref.read(horizonProvider).value;
      if (view == null) return;
      final now = view.nowMinute;
      final sessions = ref.read(focusRepositoryProvider);
      final plans = ref.read(planRepositoryProvider);

      // Önerilen saatlerin son hali: saat geçince motor öneriyi kaydırır.
      final starts = await readStarts();
      final before = jsonEncode(starts);
      starts.removeWhere((_, s) => s < now - 1440);
      for (final i in view.output.instances) {
        if (i.suggested &&
            i.isTimed &&
            i.start! > now &&
            i.status == InstanceStatus.planned &&
            view.data.requiresFocus(i.activityId)) {
          starts[i.id] = i.start!;
        }
      }

      // Kaçırılanlar: arka planda da kapanır ki plan ve bildirimler güncellensin.
      var since = int.tryParse(
        await prefs.get(PrefsRepository.focusMissedSince) ?? '',
      );
      if (since == null) {
        since = now;
        await prefs.set(PrefsRepository.focusMissedSince, '$now');
      }
      for (final i in missedTimed(view, since, tried)) {
        tried.add(i.id);
        if (await sessions.hasSessionFor(i.id)) continue;
        await _recordMissed(ref, i);
      }
      for (final i in missedSuggested(view, starts, tried)) {
        tried.add(i.id);
        starts.remove(i.id);
        if (await sessions.hasSessionFor(i.id)) continue;
        // Kaydırılabilir iş motorca ilk boşluğa kayar; öbürleri atlanır.
        if (i.flexibility != Flexibility.shiftable) await plans.skip(i);
      }
      if (jsonEncode(starts) != before) {
        await prefs.set(PrefsRepository.focusStarts, jsonEncode(starts));
      }

      final life = WidgetsBinding.instance.lifecycleState;
      if (life != null && life != AppLifecycleState.resumed) return;
      final due = dueFocus(view, tried, starts);
      if (due == null) return;
      tried.add(due.instance.id);
      // Kullanıcı bu iş için oturumu zaten açıp kapattıysa yeniden başlatılmaz.
      if (await sessions.hasSessionFor(due.instance.id)) return;
      await ref
          .read(focusStarterProvider)
          .start(view, due.instance, slot: due.slot);
    } catch (e) {
      debugPrint('[autoStart] $e');
    } finally {
      busy = false;
    }
  }

  ref.listen(horizonProvider, (_, _) => check(), fireImmediately: true);
  ref.listen(focusControllerProvider.select((s) => s.ended), (_, _) => check());
  final life = AppLifecycleListener(onResume: check);
  final n = ref.read(notificationsProvider);
  final taps = n.responses.listen((r) {
    // Odak bildiriminin eylem düğmeleri (duraklat, bitir) FocusController'ındır.
    final p = r.payload;
    if (r.actionId == null && p != null) handle(p);
  });
  ref.onDispose(() {
    life.dispose();
    taps.cancel();
  });
  if (defaultTargetPlatform == TargetPlatform.android && !kIsWeb) {
    n.ensure().then((_) => n.plugin.getNotificationAppLaunchDetails()).then((
      d,
    ) {
      final p = d?.notificationResponse?.payload;
      if (d?.didNotificationLaunchApp == true && p != null) handle(p);
    }, onError: (Object e) => debugPrint('[autoStart] launch: $e'));
  }
});

/// Kesin saatli işe bitişine kadar gelinmedi: oturum bozulmuş sayılır, odak yazılmaz.
Future<void> _recordMissed(Ref ref, PlannedInstance i) async {
  final plans = ref.read(planRepositoryProvider);
  final sessions = ref.read(focusRepositoryProvider);
  DateTime utc(int m) =>
      DateTime.fromMillisecondsSinceEpoch(m * 60000, isUtc: true);
  await plans.touch(i, const PlanInstancesCompanion());
  final view = ref.read(horizonProvider).value;
  final s = await sessions.start(
    mode: view?.data.focusMode(i.activityId) ?? FocusMode.free.name,
    planInstanceId: i.id,
    activityId: i.activityId,
    plannedMinutes: i.end! - i.start!,
    startedAt: utc(i.start!),
  );
  await sessions.finish(
    s.id,
    outcome: 'broken',
    focusedSeconds: 0,
    endedAt: utc(i.end!),
  );
  await plans.setStatus(i.id, 'failed');
  await ref.read(brainRepositoryProvider).deriveFor(s.id);
}

bool _focusPlanned(PlanView view, PlannedInstance i, Set<String> tried) =>
    i.isTimed &&
    i.status == InstanceStatus.planned &&
    !tried.contains(i.id) &&
    view.data.requiresFocus(i.activityId);

/// Şimdi açılması gereken odak oturumu ve işin başlaması gereken an.
@visibleForTesting
({PlannedInstance instance, int slot})? dueFocus(
  PlanView view,
  Set<String> tried,
  Map<String, int> starts,
) {
  final now = view.nowMinute;
  for (final i in view.output.instances) {
    if (!_focusPlanned(view, i, tried)) continue;
    final s = i.start!, e = i.end!;
    if (!i.suggested) {
      if (s <= now && (e > now || (e == s && now - s < 5))) {
        return (instance: i, slot: s);
      }
      continue;
    }
    final at = starts[i.id] ?? s;
    if (at <= now && now < at + view.data.graceMinutes(i.activityId)) {
      return (instance: i, slot: at);
    }
  }
  return null;
}

/// Bitişi geçmiş, katılınmamış kesin saatli odak işleri ([since]'ten sonra başlayanlar).
@visibleForTesting
List<PlannedInstance> missedTimed(
  PlanView view,
  int since,
  Set<String> tried,
) => [
  for (final i in view.output.instances)
    if (_focusPlanned(view, i, tried) &&
        !i.suggested &&
        i.end! > i.start! &&
        i.end! <= view.nowMinute &&
        i.start! >= since)
      i,
];

/// Geç kalma payı geçmiş önerilen saatli odak işleri.
@visibleForTesting
List<PlannedInstance> missedSuggested(
  PlanView view,
  Map<String, int> starts,
  Set<String> tried,
) => [
  for (final i in view.output.instances)
    if (_focusPlanned(view, i, tried) &&
        i.suggested &&
        starts[i.id] != null &&
        view.nowMinute >= starts[i.id]! + view.data.graceMinutes(i.activityId))
      i,
];
