import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notifications.dart';

/// Odak oturumunun platforma bağlı işleri (DECISIONS D33). Kural mantığı burada değil,
/// `neuroplan_core`'daki `EscapeGuard` ve `FocusClock`'tadır; bu arayüz yalnız cihaz
/// olaylarını taşır ve sistem çağrılarını yapar. iOS uygulaması sonra eklenir.
abstract interface class FocusPlatform {
  /// Pencere odağı, ekran ve arama olayları.
  Stream<FocusSignal> get signals;

  /// Kalıcı bildirimdeki eylemler: [FocusAction].
  Stream<FocusAction> get actions;

  Future<DeviceState> deviceState();

  Future<bool> requestNotificationPermission();
  Future<bool> hasPhonePermission();
  Future<bool> requestPhonePermission();
  Future<bool> hasDndAccess();

  /// Sistem ayarını açar; dönüşte erişim durumunu verir.
  Future<bool> requestDndAccess();

  /// Önceki filtre platformda saklanır; erişim yoksa false.
  Future<bool> enableDnd();
  Future<void> restoreDnd();

  Future<void> showOngoing(OngoingNotice notice);

  /// Ortak odakta mikrofon açıkken kalıcı bildirimin servisine `microphone` türü eklenir
  /// (Android 14: mikrofon türlü servis uygulama öndeyken başlatılır).
  Future<void> setMicrophoneInUse(bool inUse);
  Future<void> stopOngoing();

  /// 10 sn geri sayan uyarı; [deadline]'da kendiliğinden "bozuldu"ya döner (D35).
  Future<void> escapeAlert(DateTime deadline, AlertTexts texts);
  Future<void> clearEscapeAlert();

  /// Uygulama sabitleme (D36): sistem onay ister; sabitliyken ana ekran, son uygulamalar
  /// ve bildirim paneli kapalıdır. Kullanıcı bir hareketle çıkabilir.
  Future<void> pin();
  Future<void> unpin();

  /// Faz değişimi (mola zamanı, mola bitti, hedefe ulaştın).
  Future<void> phaseAlert(
    String title,
    String body, {
    required String channelName,
  });

  /// "Mola bitti" uyarısı sistem alarmıyla [at]'te gelir: uygulama arkadayken ya da
  /// süpürülmüşken de (D65). Yeniden kurmak öncekinin yerini alır.
  Future<void> scheduleBreakOver(
    DateTime at,
    String title,
    String body, {
    required String channelName,
  });
  Future<void> cancelBreakOver();
}

enum FocusSignal {
  windowFocusLost,
  windowFocusGained,
  screenOff,
  screenOn,
  unlocked,
  callActive,
  callIdle,
}

enum FocusAction { pause, resume, finish }

class DeviceState {
  const DeviceState({
    this.interactive = true,
    this.locked = false,
    this.inCall,
    this.audioCall = false,
  });

  final bool interactive;
  final bool locked;

  /// null = telefon izni yok.
  final bool? inCall;
  final bool audioCall;
}

class OngoingNotice {
  const OngoingNotice({
    required this.title,
    required this.body,
    required this.channelName,
    required this.pauseLabel,
    required this.resumeLabel,
    required this.finishLabel,
    this.countdownTo,
    this.countUpFrom,
    this.paused = false,
  });

  final String title;
  final String body;
  final String channelName;
  final String pauseLabel;
  final String resumeLabel;
  final String finishLabel;

  /// Faz sonu (Pomodoro, mola, derin çalışma hedefi): kronometre geri sayar.
  final DateTime? countdownTo;

  /// Serbest mod: kronometre bu andan ileri sayar.
  final DateTime? countUpFrom;

  /// Odak dışında (duraklatıldı, mola): "Duraklat" yerine "Devam" gösterilir.
  final bool paused;
}

class AlertTexts {
  const AlertTexts({
    required this.channelName,
    required this.title,
    required this.body,
    required this.brokenTitle,
    required this.brokenBody,
  });

  final String channelName;
  final String title;
  final String body;
  final String brokenTitle;
  final String brokenBody;
}

final focusPlatformProvider = Provider<FocusPlatform>(
  (ref) => defaultTargetPlatform == TargetPlatform.android && !kIsWeb
      ? AndroidFocusPlatform(ref.watch(notificationsProvider))
      : const _NoFocusPlatform(),
);

class AndroidFocusPlatform implements FocusPlatform {
  AndroidFocusPlatform(this._n);

  final Notifications _n;
  static const _method = MethodChannel('neuroplan/focus');
  static const _events = EventChannel('neuroplan/focus_events');
  static const _ongoingId = 900;
  static const _phaseId = 902;

  /// Plan hatırlatmaları yeniden kurulurken bu kimlik silinmez (`next_up.dart`).
  static const breakOverId = 903;
  static const breakOverPayload = 'resume:focus';
  static const _ongoingChannel = 'focus_ongoing';

  var _microphone = false;
  OngoingNotice? _lastOngoing;

  @override
  Future<void> setMicrophoneInUse(bool inUse) async {
    if (_microphone == inUse) return;
    _microphone = inUse;
    if (_lastOngoing case final n?) await showOngoing(n);
  }

  @override
  late final Stream<FocusSignal> signals = _events
      .receiveBroadcastStream()
      .map(
        (e) => switch (e) {
          'focus_lost' => FocusSignal.windowFocusLost,
          'focus_gained' => FocusSignal.windowFocusGained,
          'screen_off' => FocusSignal.screenOff,
          'screen_on' => FocusSignal.screenOn,
          'unlocked' => FocusSignal.unlocked,
          'call_active' => FocusSignal.callActive,
          'call_idle' => FocusSignal.callIdle,
          _ => null,
        },
      )
      .where((s) => s != null)
      .cast<FocusSignal>();

  @override
  late final Stream<FocusAction> actions = _n.responses
      .map((r) => FocusAction.values.asNameMap()[r.actionId])
      .where((a) => a != null)
      .cast<FocusAction>();

  @override
  Future<DeviceState> deviceState() async {
    final m = (await _method.invokeMapMethod<String, Object?>('deviceState'))!;
    return DeviceState(
      interactive: m['interactive'] != false,
      locked: m['locked'] == true,
      inCall: m['inCall'] as bool?,
      audioCall: m['audioCall'] == true,
    );
  }

  @override
  Future<bool> requestNotificationPermission() async {
    await _n.ensure();
    return await _n.android?.requestNotificationsPermission() ?? true;
  }

  @override
  Future<bool> hasPhonePermission() async =>
      await _method.invokeMethod<bool>('phonePermission') ?? false;

  @override
  Future<bool> requestPhonePermission() async =>
      await _method.invokeMethod<bool>('requestPhonePermission') ?? false;

  @override
  Future<bool> hasDndAccess() async {
    await _n.ensure();
    return await _n.android?.hasNotificationPolicyAccess() ?? false;
  }

  @override
  Future<bool> requestDndAccess() async {
    await _n.ensure();
    return await _n.android?.requestNotificationPolicyAccess() ?? false;
  }

  @override
  Future<bool> enableDnd() async =>
      await _method.invokeMethod<bool>('enableDnd') ?? false;

  @override
  Future<void> restoreDnd() => _method.invokeMethod('restoreDnd');

  @override
  Future<void> showOngoing(OngoingNotice n) async {
    _lastOngoing = n;
    await _n.ensure();
    final at = n.countdownTo ?? n.countUpFrom;
    await _n.android?.startForegroundService(
      id: _ongoingId,
      title: n.title,
      body: n.body,
      startType: AndroidServiceStartType.startNotSticky,
      foregroundServiceTypes: {
        AndroidServiceForegroundType.foregroundServiceTypeSpecialUse,
        if (_microphone)
          AndroidServiceForegroundType.foregroundServiceTypeMicrophone,
      },
      notificationDetails: AndroidNotificationDetails(
        _ongoingChannel,
        n.channelName,
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        onlyAlertOnce: true,
        playSound: false,
        enableVibration: false,
        showWhen: at != null,
        when: at?.millisecondsSinceEpoch,
        usesChronometer: at != null,
        chronometerCountDown: n.countdownTo != null,
        category: AndroidNotificationCategory.progress,
        actions: [
          n.paused
              ? AndroidNotificationAction(
                  FocusAction.resume.name,
                  n.resumeLabel,
                  showsUserInterface: true,
                  cancelNotification: false,
                )
              : AndroidNotificationAction(
                  FocusAction.pause.name,
                  n.pauseLabel,
                  showsUserInterface: true,
                  cancelNotification: false,
                ),
          AndroidNotificationAction(
            FocusAction.finish.name,
            n.finishLabel,
            showsUserInterface: true,
            cancelNotification: false,
          ),
        ],
      ),
    );
  }

  @override
  Future<void> stopOngoing() async {
    _lastOngoing = null;
    await _n.ensure();
    await _n.android?.stopForegroundService();
  }

  /// DND erişimi varsa kanal "Rahatsız Etmeyin"i aşar; kanal ayarı sonradan değişmediği
  /// için iki ayrı kimlik kullanılır.
  Future<String> _alertChannel(String name) async {
    final bypass = await hasDndAccess();
    final id = bypass ? 'focus_alert_dnd' : 'focus_alert';
    await _n.android?.createNotificationChannel(
      AndroidNotificationChannel(
        id,
        name,
        importance: Importance.max,
        bypassDnd: bypass,
        vibrationPattern: Int64List.fromList([0, 400, 200, 400]),
      ),
    );
    return id;
  }

  @override
  Future<void> escapeAlert(DateTime deadline, AlertTexts t) async {
    await _method.invokeMethod('escapeAlert', {
      'deadline': deadline.millisecondsSinceEpoch,
      'channel': await _alertChannel(t.channelName),
      'title': t.title,
      'body': t.body,
      'brokenTitle': t.brokenTitle,
      'brokenBody': t.brokenBody,
    });
  }

  @override
  Future<void> clearEscapeAlert() => _method.invokeMethod('clearEscapeAlert');

  @override
  Future<void> pin() => _method.invokeMethod('pin');

  @override
  Future<void> unpin() => _method.invokeMethod('unpin');

  @override
  Future<void> phaseAlert(
    String title,
    String body, {
    required String channelName,
  }) async {
    final channel = await _alertChannel(channelName);
    await _n.plugin.show(
      id: _phaseId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          timeoutAfter: 60000,
        ),
      ),
    );
  }

  @override
  Future<void> scheduleBreakOver(
    DateTime at,
    String title,
    String body, {
    required String channelName,
  }) async {
    final channel = await _alertChannel(channelName);
    final exact = await _n.android?.canScheduleExactNotifications() ?? false;
    await _n.plugin.zonedSchedule(
      id: breakOverId,
      scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
      title: title,
      body: body,
      // Dokununca odak kaldığı yerden sürer (D66, `autoStartProvider`).
      payload: breakOverPayload,
      androidScheduleMode: exact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.alarm,
          // Kilitliyken uygulamayı öne getirir: kilit açılınca sayaç önde, odak sürer (D70).
          // İzin verilmemişse (Android 14+ özel erişim) sistem üstten uyarı gösterir.
          fullScreenIntent: true,
        ),
      ),
    );
  }

  @override
  Future<void> cancelBreakOver() => _n.plugin.cancel(id: breakOverId);
}

/// Android dışı (testler, ileride iOS gelene kadar): hiçbir sistem çağrısı yapılmaz.
class _NoFocusPlatform implements FocusPlatform {
  const _NoFocusPlatform();

  @override
  Stream<FocusSignal> get signals => const Stream.empty();
  @override
  Stream<FocusAction> get actions => const Stream.empty();
  @override
  Future<DeviceState> deviceState() async => const DeviceState();
  @override
  Future<bool> requestNotificationPermission() async => true;
  @override
  Future<bool> hasPhonePermission() async => false;
  @override
  Future<bool> requestPhonePermission() async => false;
  @override
  Future<bool> hasDndAccess() async => false;
  @override
  Future<bool> requestDndAccess() async => false;
  @override
  Future<bool> enableDnd() async => false;
  @override
  Future<void> restoreDnd() async {}
  @override
  Future<void> showOngoing(OngoingNotice notice) async {}
  @override
  Future<void> stopOngoing() async {}
  @override
  Future<void> setMicrophoneInUse(bool inUse) async {}
  @override
  Future<void> escapeAlert(DateTime deadline, AlertTexts texts) async {}
  @override
  Future<void> clearEscapeAlert() async {}
  @override
  Future<void> pin() async {}
  @override
  Future<void> unpin() async {}
  @override
  Future<void> phaseAlert(
    String title,
    String body, {
    required String channelName,
  }) async {}
  @override
  Future<void> scheduleBreakOver(
    DateTime at,
    String title,
    String body, {
    required String channelName,
  }) async {}
  @override
  Future<void> cancelBreakOver() async {}
}
