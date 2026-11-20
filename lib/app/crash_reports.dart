import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../ui/features/together/together_providers.dart';
import 'feature_flags.dart';
import 'providers.dart';

/// Çökme raporları (Firebase Crashlytics, D59). Firebase `.env`'den başlatılır (Push ile aynı
/// uygulama örneği). Kullanıcı kimliği, e-posta ya da plan içeriği eklenmez; yalnız hata ve
/// yığın izi gider. Hata ayıklama derlemesinde ve Firebase ayarı yokken hiçbir şey yapılmaz.
/// Kullanıcı Ayarlar'dan kapatabilir (cihaza özel); `crashReports` bayrağı hepsini kapatır.
const crashReportsPref = 'pref.crash_reports';

/// Cihaz tercihi: açık (varsayılan) ya da kapalı ('0').
final crashReportsPrefProvider = StreamProvider<bool>(
  (ref) => ref
      .watch(prefsRepositoryProvider)
      .watch(crashReportsPref)
      .map((v) => v != '0'),
);

/// Tercih ve bayrak değişince toplamayı açar / kapatır. Uygulama kökü izler.
final crashReportsProvider = Provider<void>((ref) {
  final pref = ref.watch(crashReportsPrefProvider).value ?? true;
  final flags = ref.watch(featureFlagsProvider).value ?? const FeatureFlags();
  final on = pref && flags.on(Feature.crashReports);
  unawaited(_apply(ref, on));
});

var _hooked = false;

Future<void> _apply(Ref ref, bool on) async {
  if (kDebugMode) return;
  try {
    if (!await ref.read(pushProvider).ready()) return;
    final c = FirebaseCrashlytics.instance;
    await c.setCrashlyticsCollectionEnabled(on);
    if (_hooked) return;
    _hooked = true;
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      previous?.call(details);
      c.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      c.recordError(error, stack, fatal: true);
      return true;
    };
  } on Object catch (e) {
    debugPrint('[crash] başlatılamadı: $e');
  }
}
