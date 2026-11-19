import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'env.dart';
import 'notifications.dart';

/// Mesaj push bildirimi (FCM, D49). Firebase ayarı `.env`'den gelir (google-services.json ve
/// Gradle eklentisi gerekmez); yoksa push kapalıdır ve uygulama yerel bildirimle yetinir.
/// Bildirimi sunucu (`push_message` Edge Function) gönderir; metin içermez.
class Push {
  Push(this._notifications);

  final Notifications _notifications;

  static const channelId = 'together_messages';

  static FirebaseOptions? get options => Env.firebaseConfigured
      ? const FirebaseOptions(
          apiKey: Env.firebaseApiKey,
          appId: Env.firebaseAppId,
          messagingSenderId: Env.firebaseSenderId,
          projectId: Env.firebaseProjectId,
        )
      : null;

  Future<bool>? _ready;

  /// Firebase'i bir kez başlatır; ayar yoksa ya da başlatılamazsa false.
  Future<bool> ready() => _ready ??= _init();

  Future<bool> _init() async {
    final o = options;
    if (o == null || defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    try {
      await Firebase.initializeApp(options: o);
      return true;
    } on Object catch (e) {
      debugPrint('[push] Firebase başlatılamadı: $e');
      return false;
    }
  }

  /// Bildirim kanalı FCM'den önce var olmalı (Android 8+); ad ARB'den.
  Future<void> ensureChannel(String name) async {
    await _notifications.ensure();
    await _notifications.android?.createNotificationChannel(
      AndroidNotificationChannel(
        channelId,
        name,
        importance: Importance.defaultImportance,
      ),
    );
  }

  /// Cihaz kimliğini alır ve [register] ile sunucuya bildirir; yenilenince yeniden bildirir.
  /// Dönüş: aboneliği kapatan işlev.
  Future<VoidCallback?> start(
    Future<void> Function(String token) register,
  ) async {
    if (!await ready()) return null;
    final m = FirebaseMessaging.instance;
    try {
      await m.requestPermission();
      // shortcut: firebase_messaging 17 register()/onRegistered kurulum kimliği (FID) döndürür;
      // sunucu FCM v1 ile kayıt kimliğine gönderiyor. FID ile gönderim doğrulanınca geçilecek.
      // ignore: deprecated_member_use
      final token = await m.getToken();
      if (token != null) await register(token);
    } on Object catch (e) {
      debugPrint('[push] kimlik alınamadı: $e');
    }
    // ignore: deprecated_member_use
    final sub = m.onTokenRefresh.listen(
      (t) => unawaited(
        register(t).catchError((Object e) => debugPrint('[push] $e')),
      ),
    );
    return sub.cancel;
  }

  /// Bildirime dokunulunca açılacak sohbet: uygulama kapalıyken açılış ve arkadayken dokunuş.
  Future<Stream<Map<String, dynamic>>> taps() async {
    if (!await ready()) return const Stream.empty();
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    final controller = StreamController<Map<String, dynamic>>();
    if (initial != null) controller.add(initial.data);
    final sub = FirebaseMessaging.onMessageOpenedApp.listen(
      (m) => controller.add(m.data),
    );
    controller.onCancel = sub.cancel;
    return controller.stream;
  }

  /// Hesap silinince cihaz kimliği de geçersiz olur.
  Future<void> forget() async {
    if (!await ready()) return;
    try {
      // ignore: deprecated_member_use
      await FirebaseMessaging.instance.deleteToken();
    } on Object catch (e) {
      debugPrint('[push] $e');
    }
  }
}
