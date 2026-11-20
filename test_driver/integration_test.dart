import 'package:integration_test/integration_test_driver.dart';

/// Profil modunda kare ölçümü (docs/PERFORMANCE.md):
/// `flutter drive --profile --no-dds --driver=test_driver/integration_test.dart
///   --target=integration_test/app_flow_test.dart --keep-app-running -d CIHAZ`
/// Sonuç `build/integration_response_data.json`'a yazılır (`frames` anahtarı).
Future<void> main() => integrationDriver();
