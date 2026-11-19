import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bridge.dart';

/// 3D sahne: mesaj gönderir, mesaj alır, kendi görünümünü çizer. Testler sahtesini kullanır.
abstract class BrainScene {
  Stream<FromScene> get messages;
  void send(ToScene message);
  Widget view();
  void dispose();
}

/// Uygulama boyunca tek sahne: ilk karede kurulur ve yüklenir (ön ısıtma), sekme
/// `StatefulShellRoute` içinde canlı kaldığı için yeniden yaratılmaz.
final brainSceneProvider = Provider<BrainScene>((ref) {
  final scene = WebBrainScene();
  ref.onDispose(scene.dispose);
  return scene;
});

/// WebView içindeki yerel Three.js sahnesi (`assets/brain/index.html`). Ağ erişimi yok:
/// gezinme temsilcisi uygulama varlıkları dışındaki her adresi engeller (D7).
class WebBrainScene implements BrainScene {
  WebBrainScene() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..addJavaScriptChannel(
        'NeuroBridge',
        onMessageReceived: (m) {
          final msg = FromScene.decode(m.message);
          if (msg == null) {
            debugPrint('[brain] yok sayılan mesaj: ${m.message}');
            return;
          }
          if (msg is SceneReady) _flush();
          if (msg is ScenePerf) {
            debugPrint(
              '[brain] fps ${msg.fps} en uzun kare ${msg.frameMs} ms (${msg.tier})',
            );
          }
          _messages.add(msg);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (r) =>
              r.url.startsWith('file:///android_asset/') ||
                  r.url.startsWith('file:///') &&
                      r.url.contains('flutter_assets')
              ? NavigationDecision.navigate
              : NavigationDecision.prevent,
          onWebResourceError: (e) {
            if (e.isForMainFrame ?? true) {
              _messages.add(SceneError(e.description));
            }
          },
        ),
      )
      ..loadFlutterAsset('assets/brain/index.html');
  }

  late final WebViewController _controller;
  final _messages = StreamController<FromScene>.broadcast();

  /// Sahne `ready` demeden gönderilenler sırada bekler; yalnız son durum anlamlıdır.
  final _pending = <String, ToScene>{};
  bool _ready = false;

  @override
  Stream<FromScene> get messages => _messages.stream;

  @override
  void send(ToScene message) {
    if (!_ready) {
      _pending[message.type] = message;
      return;
    }
    _run(message);
  }

  void _run(ToScene m) {
    // JSON dizgesi geçerli bir JS dizge literalidir.
    final js =
        'window.brain && window.brain.receive(${jsonEncode(m.encode())})';
    unawaited(
      _controller.runJavaScript(js).catchError((Object e) {
        debugPrint('[brain] gönderilemedi: $e');
      }),
    );
  }

  void _flush() {
    _ready = true;
    // init önce gelmeli; sonra durum ve vurgu.
    for (final type in [
      'init',
      'quality',
      'state',
      'highlight',
      'visibility',
    ]) {
      final m = _pending.remove(type);
      if (m != null) _run(m);
    }
    _pending.values.forEach(_run);
    _pending.clear();
  }

  @override
  Widget view() => WebViewWidget(
    controller: _controller,
    // Sahne kendi hareketlerini işler (döndür, yakınlaştır); dış kaydırma çalmasın.
    gestureRecognizers: {Factory(() => EagerGestureRecognizer())},
  );

  @override
  void dispose() => _messages.close();
}
