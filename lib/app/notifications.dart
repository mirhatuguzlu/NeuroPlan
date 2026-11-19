import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tek bildirim eklentisi nesnesi: `initialize` ve dokunma geri çağırımı bir kez kurulur
/// (sıradaki iş bildirimi ve odak oturumu birlikte kullanır).
final notificationsProvider = Provider((ref) => Notifications());

/// Sistem bildirim izni açık mı (Profil'deki durum satırı; uygulamaya dönünce yenilenir).
final notificationsEnabledProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(notificationsProvider).enabled(),
);

class Notifications {
  final plugin = FlutterLocalNotificationsPlugin();
  final _responses = StreamController<NotificationResponse>.broadcast();
  Future<void>? _ready;

  static const _method = MethodChannel('neuroplan/focus');

  /// Bildirim ve eylem dokunuşları (uygulama açıkken).
  // shortcut: uygulama kapalıyken eylemden açılış (launch details) işlenmez; kurtarma
  // odak ekranını zaten açar, kullanıcı eylemi orada yineler.
  Stream<NotificationResponse> get responses => _responses.stream;

  AndroidFlutterLocalNotificationsPlugin? get android => plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<void> ensure() => _ready ??= plugin
      .initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse: _responses.add,
      )
      .then((_) {});

  Future<bool> enabled() async {
    await ensure();
    return await android?.areNotificationsEnabled() ?? true;
  }

  /// Android 13+ izin penceresi; daha eski sürümde ya da kullanıcı iki kez reddettiyse
  /// pencere çıkmaz, o zaman uygulamanın bildirim ayarı açılır.
  Future<bool> request() async {
    await ensure();
    if (await android?.requestNotificationsPermission() ?? true) {
      if (await enabled()) return true;
    }
    await _method.invokeMethod<void>('openNotificationSettings');
    return false;
  }
}
