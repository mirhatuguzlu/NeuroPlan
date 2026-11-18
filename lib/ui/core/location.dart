import 'package:drift/drift.dart' show Value;
import 'package:geolocator/geolocator.dart';

import '../../data/local/app_database.dart';
import '../../data/repositories/profile_repository.dart';

enum LocateResult { saved, denied, failed }

/// Yaklaşık konumu alıp 0,1°'ye yuvarlayarak kaydeder (≈ 11 km; DB_SCHEMA §3.1).
Future<LocateResult> locateAndSave(ProfileRepository profiles) async {
  try {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return LocateResult.denied;
    }
    final p = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 20),
      ),
    );
    double round(double v) => (v * 10).round() / 10;
    await profiles.update(
      ProfilesCompanion(
        locationLat: Value(round(p.latitude)),
        locationLon: Value(round(p.longitude)),
      ),
    );
    return LocateResult.saved;
  } on Object {
    return LocateResult.failed;
  }
}
