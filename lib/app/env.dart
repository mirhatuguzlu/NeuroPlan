/// Derleme anı ayarları (`--dart-define-from-file=.env`, D6). Boşsa uygulama yalnız cihazda çalışır.
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Google Cloud'daki "Web application" OAuth istemci kimliği; Supabase Google sağlayıcısıyla aynı.
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );

  static bool get backendConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
