import 'dart:convert';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'data/local/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final system = SystemData.fromJson(
    jsonDecode(await rootBundle.loadString('assets/seed/system.json'))
        as Map<String, Object?>,
  );
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
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const NeuroPlanApp(),
    ),
  );
}
