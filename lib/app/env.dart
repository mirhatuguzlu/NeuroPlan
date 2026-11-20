import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Uygulama ayarı (D6, D52). Kökteki git-ignored `.env`'i Android derlemesi okur ve APK'ya
/// gömer (`android/app/build.gradle.kts`); burada açılışta [load] ile alınır. `flutter run`
/// ek bayrak istemez. Boşsa uygulama yalnız cihazda çalışır.
/// Hepsi istemciye gömülmesi tasarım gereği serbest olan değerlerdir; gizli anahtar burada olmaz.
abstract final class Env {
  static var _values = const <String, String>{};

  /// `main()`'de bir kez, Supabase'den önce.
  // shortcut: yalnız Android okur; iOS aşamasında Runner'a aynı "env" çağrısı eklenecek.
  static Future<void> load() async {
    try {
      _values =
          await const MethodChannel(
            'neuroplan/focus',
          ).invokeMapMethod<String, String>('env') ??
          const {};
    } on Object catch (e) {
      debugPrint('[env] okunamadı: $e');
    }
  }

  static String _get(String key) => _values[key] ?? '';

  static String get supabaseUrl => _get('SUPABASE_URL');
  static String get supabaseAnonKey => _get('SUPABASE_ANON_KEY');

  /// Google Cloud'daki "Web application" OAuth istemci kimliği; Supabase Google sağlayıcısıyla aynı.
  static String get googleWebClientId => _get('GOOGLE_WEB_CLIENT_ID');

  /// Firebase (yalnız mesaj push bildirimi, D49): Firebase konsolu → Proje ayarları → Android uygulaması.
  static String get firebaseApiKey => _get('FIREBASE_API_KEY');
  static String get firebaseAppId => _get('FIREBASE_APP_ID');
  static String get firebaseSenderId => _get('FIREBASE_SENDER_ID');
  static String get firebaseProjectId => _get('FIREBASE_PROJECT_ID');

  static bool get backendConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get firebaseConfigured =>
      firebaseApiKey.isNotEmpty &&
      firebaseAppId.isNotEmpty &&
      firebaseSenderId.isNotEmpty &&
      firebaseProjectId.isNotEmpty;
}
