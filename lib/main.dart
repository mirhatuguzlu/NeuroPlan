import 'dart:async';
import 'dart:convert';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'app/env.dart';
import 'app/providers.dart';
import 'app/theme.dart';
import 'data/local/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final system = SystemData.fromJson(
    jsonDecode(await rootBundle.loadString('assets/seed/system.json'))
        as Map<String, Object?>,
  );
  await Env.load();
  if (Env.backendConfigured) {
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabaseAnonKey,
    );
  } else {
    debugPrint(
      '[env] SUPABASE_URL boş: derlemede .env yoktu ya da eksikti; '
      'giriş, eşitleme ve Birlikte kapalı.',
    );
  }
  final db = AppDatabase(driftDatabase(name: 'neuroplan'), systemData: system);
  final container = ProviderContainer(
    overrides: [databaseProvider.overrideWithValue(db)],
  );
  // Profil ilk açılışta cihazın saat dilimiyle oluşur (DB_SCHEMA §3.1).
  var tz = (await FlutterTimezone.getLocalTimezone()).identifier;
  try {
    PlanCalendar(tz);
  } on Object {
    tz = 'UTC'; // IANA veritabanında olmayan cihaz kimliği
  }
  await container.read(profileRepositoryProvider).ensure(timezone: tz);
  // Motor sürümü değiştiyse beyin olayları oturumlardan yeniden türetilir (D39).
  unawaited(container.read(brainRepositoryProvider).rebuildIfNeeded());
  // İlk bağlantıda misafir oturumu açılır; her oturum değişiminde eşitleme koşar (ARCHITECTURE §5.4).
  final sync = container.read(syncSchedulerProvider)?..start();
  container.listen(authUserProvider, (_, _) => sync?.syncNow());
  unawaited(container.read(authServiceProvider).ensureGuest());
  LicenseRegistry.addLicense(_assetLicenses);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const NeuroPlanApp(),
    ),
  );
}

/// Uygulamaya gömülü üçüncü taraf varlıklar (Hakkında → Lisanslar).
Stream<LicenseEntry> _assetLicenses() async* {
  yield const LicenseEntryWithLineBreaks(
    ['BodyParts3D'],
    'BodyParts3D, © The Database Center for Life Science licensed under CC '
    'Attribution 4.0 International.\n'
    'https://creativecommons.org/licenses/by/4.0/\n'
    'https://dbarchive.biosciencedbc.jp/en/bodyparts3d/\n\n'
    'The 3D brain in this app is a simplified, recombined derivative of the '
    'BodyParts3D 4.0 polygon data (see tool/brain in the source repository).',
  );
  yield LicenseEntryWithLineBreaks([
    'three.js',
  ], await rootBundle.loadString('assets/brain/LICENSE_threejs.txt'));
  for (final (name, file) in embeddedFonts) {
    yield LicenseEntryWithLineBreaks([
      name,
    ], await rootBundle.loadString('assets/fonts/OFL_$file.txt'));
  }
}
