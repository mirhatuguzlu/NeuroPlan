import 'dart:async';

import 'package:neuroplan/app/focus_platform.dart';

/// Testte cihaz: olaylar elle gönderilir, sistem çağrıları kaydedilir.
class FakeFocusPlatform implements FocusPlatform {
  final signalsCtl = StreamController<FocusSignal>.broadcast();
  final actionsCtl = StreamController<FocusAction>.broadcast();
  DeviceState device = const DeviceState();
  bool phonePermission = false;
  bool dndAccess = false;

  /// Son kurulan kaçış uyarısının son tarihi; null = uyarı yok.
  DateTime? alertDeadline;
  OngoingNotice? ongoing;
  bool dndOn = false;
  bool pinned = false;
  final phaseAlerts = <String>[];

  @override
  Stream<FocusSignal> get signals => signalsCtl.stream;
  @override
  Stream<FocusAction> get actions => actionsCtl.stream;
  @override
  Future<DeviceState> deviceState() async => device;
  @override
  Future<bool> requestNotificationPermission() async => true;
  @override
  Future<bool> hasPhonePermission() async => phonePermission;
  @override
  Future<bool> requestPhonePermission() async => phonePermission = true;
  @override
  Future<bool> hasDndAccess() async => dndAccess;
  @override
  Future<bool> requestDndAccess() async => dndAccess;
  @override
  Future<bool> enableDnd() async => dndOn = dndAccess;
  @override
  Future<void> restoreDnd() async => dndOn = false;
  @override
  Future<void> showOngoing(OngoingNotice notice) async => ongoing = notice;
  @override
  Future<void> stopOngoing() async => ongoing = null;
  var microphone = false;
  @override
  Future<void> setMicrophoneInUse(bool inUse) async => microphone = inUse;
  @override
  Future<void> escapeAlert(DateTime deadline, AlertTexts texts) async =>
      alertDeadline = deadline;
  @override
  Future<void> clearEscapeAlert() async => alertDeadline = null;
  @override
  Future<void> pin() async => pinned = true;
  @override
  Future<void> unpin() async => pinned = false;
  @override
  Future<void> phaseAlert(
    String title,
    String body, {
    required String channelName,
  }) async => phaseAlerts.add(title);

  /// Kurulu "mola bitti" uyarısının anı; null = yok.
  DateTime? breakOverAt;
  @override
  Future<void> scheduleBreakOver(
    DateTime at,
    String title,
    String body, {
    required String channelName,
  }) async => breakOverAt = at;
  @override
  Future<void> cancelBreakOver() async => breakOverAt = null;
}
