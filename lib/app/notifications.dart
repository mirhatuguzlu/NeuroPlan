import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tek bildirim eklentisi nesnesi: `initialize` ve dokunma geri çağırımı bir kez kurulur
/// (sıradaki iş bildirimi ve odak oturumu birlikte kullanır).
final notificationsProvider = Provider((ref) => Notifications());

class Notifications {
  final plugin = FlutterLocalNotificationsPlugin();
  final _responses = StreamController<NotificationResponse>.broadcast();
  Future<void>? _ready;

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
}
