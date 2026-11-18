import 'package:adhan_dart/adhan_dart.dart';

import '../model/timing.dart';
import 'calendar.dart';

/// Seçilebilir namaz vakti hesap yöntemleri (`profiles.prayer_method` anahtarı).
/// Türkiye için varsayılan `turkiye` (Diyanet: fecir 18°, yatsı 17°, temkin düzeltmeleri).
final prayerMethods = <String, CalculationParameters Function()>{
  'turkiye': CalculationMethodParameters.turkiye,
  'muslimWorldLeague': CalculationMethodParameters.muslimWorldLeague,
  'egyptian': CalculationMethodParameters.egyptian,
  'karachi': CalculationMethodParameters.karachi,
  'ummAlQura': CalculationMethodParameters.ummAlQura,
  'dubai': CalculationMethodParameters.dubai,
  'gulfRegion': CalculationMethodParameters.gulfRegion,
  'kuwait': CalculationMethodParameters.kuwait,
  'qatar': CalculationMethodParameters.qatar,
  'moonsightingCommittee': CalculationMethodParameters.moonsightingCommittee,
  'northAmerica': CalculationMethodParameters.northAmerica,
  'singapore': CalculationMethodParameters.singapore,
  'indonesian': CalculationMethodParameters.indonesian,
  'tehran': CalculationMethodParameters.tehran,
  'jafari': CalculationMethodParameters.jafari,
  'jordan': CalculationMethodParameters.jordan,
  'algerian': CalculationMethodParameters.algerian,
  'morocco': CalculationMethodParameters.morocco,
  'tunisia': CalculationMethodParameters.tunisia,
  'france': CalculationMethodParameters.france,
  'portugal': CalculationMethodParameters.portugal,
  'russia': CalculationMethodParameters.russia,
};

const defaultPrayerMethod = 'turkiye';

/// Gün doğumu / batımı ve namaz vakitleri; internetsiz hesaplanır, dakikaya yuvarlanır.
final class AstroClock {
  AstroClock({
    required this.latitude,
    required this.longitude,
    this.prayerMethod,
    this.madhab,
  });

  final double? latitude;
  final double? longitude;

  /// null = namaz vakitleri kapalı; yalnız gün doğumu / batımı kullanılabilir.
  final String? prayerMethod;
  final String? madhab;

  bool get hasLocation => latitude != null && longitude != null;
  bool get hasPrayer => hasLocation && prayerMethods.containsKey(prayerMethod);

  final _neutral = <int, PrayerTimes>{};
  final _prayer = <int, PrayerTimes>{};

  /// UTC dakika; konum (namaz vaktinde yöntem) yoksa null.
  int? at(AstroEvent event, Day day) {
    final isSun = event == AstroEvent.sunrise || event == AstroEvent.sunset;
    if (isSun ? !hasLocation : !hasPrayer) return null;
    final times = isSun
        ? _neutral.putIfAbsent(day.index, () => _compute(day, _neutralParams()))
        : _prayer.putIfAbsent(day.index, () => _compute(day, _methodParams()));
    final t = switch (event) {
      AstroEvent.sunrise => times.sunrise,
      AstroEvent.sunset => times.sunset,
      AstroEvent.fajr => times.fajr,
      AstroEvent.dhuhr => times.dhuhr,
      AstroEvent.asr => times.asr,
      AstroEvent.maghrib => times.maghrib,
      AstroEvent.isha => times.isha,
    };
    return (t.millisecondsSinceEpoch / 60000).round();
  }

  PrayerTimes _compute(Day day, CalculationParameters params) => PrayerTimes(
    date: day.utc,
    coordinates: Coordinates(latitude!, longitude!),
    calculationParameters: params,
  );

  // Gün doğumu / batımı yöntem düzeltmesi taşımaz (ör. Diyanet'in temkini).
  static CalculationParameters _neutralParams() => CalculationParameters(
    method: CalculationMethod.other,
    fajrAngle: 18,
    ishaAngle: 17,
  );

  CalculationParameters _methodParams() {
    final p = prayerMethods[prayerMethod]!();
    p.madhab = madhab == 'hanafi' ? Madhab.hanafi : Madhab.shafi;
    return p;
  }
}
