import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

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

/// Saati gelen odak işini uygulama öndeyken kendiliğinden başlatır; bildirime dokunuşu
/// (uygulama açıkken ya da bildirimden soğuk açılışta) işler (D63).
final autoStartProvider = Provider<void>((ref) {
  final tried = <String>{};
  String? pending; // plan hazır olmadan gelen dokunuş
  var busy = false;

  Future<void> handle(String payload) async {
    final cut = payload.indexOf(':');
    if (cut < 0) return;
    final kind = payload.substring(0, cut), id = payload.substring(cut + 1);
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
        !ref.read(focusControllerProvider).active) {
      tried.add(id);
      await startFocusFor(ref, view, instance);
      return;
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
      final life = WidgetsBinding.instance.lifecycleState;
      if (life != null && life != AppLifecycleState.resumed) return;
      if (ref.read(profileProvider).value?.onboardingCompletedAt == null) {
        return;
      }
      final focus = ref.read(focusControllerProvider);
      if (focus.active || focus.ended != null) return;
      final view = ref.read(horizonProvider).value;
      if (view == null) return;
      final due = dueFocus(view, tried);
      if (due == null) return;
      tried.add(due.id);
      // Kullanıcı bu iş için oturumu zaten açıp kapattıysa yeniden başlatılmaz.
      if (await ref.read(focusRepositoryProvider).hasSessionFor(due.id)) return;
      await startFocusFor(ref, view, due);
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

/// Otomatik başlatma penceresi: saati geçeli bu kadar dakika olmamışsa başlar.
// Geçici (D63): uygulama işin ortasında açılınca oturum kendiliğinden başlamaz.
const autoStartGrace = 5;

/// Şimdi başlaması gereken odak işi: saatli, planlı, motorun önerisi değil, odak ister.
@visibleForTesting
PlannedInstance? dueFocus(PlanView view, Set<String> tried) {
  final now = view.nowMinute;
  for (final i in view.output.instances) {
    if (!i.isTimed ||
        i.suggested ||
        i.status != InstanceStatus.planned ||
        tried.contains(i.id) ||
        !view.data.requiresFocus(i.activityId)) {
      continue;
    }
    final s = i.start!, e = i.end!;
    if (s <= now && now - s < autoStartGrace && (e > now || e == s)) return i;
  }
  return null;
}

/// İşin varsayılan moduyla ve son kayıtlı süre ayarlarıyla oturum açar.
Future<void> startFocusFor(Ref ref, PlanView view, PlannedInstance i) async {
  final saved = await savedFocusSettings(ref.read(prefsRepositoryProvider));
  final mode = FocusMode.fromJson(view.data.focusMode(i.activityId));
  await ref
      .read(focusControllerProvider.notifier)
      .start(instance: i, settings: saved[mode]!);
}
