/// Derleme anı ayarları (`--dart-define-from-file=.env`, D6). Boşsa uygulama yalnız cihazda çalışır.
/// Hepsi istemciye gömülmesi tasarım gereği serbest olan değerlerdir; gizli anahtar burada olmaz.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Google Cloud'daki "Web application" OAuth istemci kimliği; Supabase Google sağlayıcısıyla aynı.
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );

  /// Firebase (yalnız mesaj push bildirimi, D49): Firebase konsolu → Proje ayarları → Android uygulaması.
  static const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID');
  static const firebaseSenderId = String.fromEnvironment('FIREBASE_SENDER_ID');
  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );

  static bool get backendConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get firebaseConfigured =>
      firebaseApiKey.isNotEmpty &&
      firebaseAppId.isNotEmpty &&
      firebaseSenderId.isNotEmpty &&
      firebaseProjectId.isNotEmpty;
}
