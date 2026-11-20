import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../data/local/app_database.dart';
import '../../l10n/app_localizations.dart';

/// Kısa erişim: `context.l10n.navToday`.
extension L10nX on BuildContext {
  L10n get l10n => L10n.of(this);
  String get localeName => Localizations.localeOf(this).toLanguageTag();
  bool get isTurkish => Localizations.localeOf(this).languageCode == 'tr';
}

/// "1 sa 15 dk" / "45 dk".
String durationText(L10n l, int minutes) {
  final h = minutes ~/ 60, m = minutes % 60;
  if (h == 0) return l.minutesShort(m);
  return m == 0 ? l.hoursShort(h) : l.hoursMinutes(h, m);
}

/// Kullanıcının saat dilimindeki "HH:MM" (yerel biçim).
String clockText(BuildContext context, PlanCalendar cal, int utcMinute) {
  final m = cal.minuteOfDay(utcMinute);
  return DateFormat.Hm(context.localeName)
      .format(DateTime(2000, 1, 1, m ~/ 60, m % 60));
}

String clockOfDay(BuildContext context, int minuteOfDay) =>
    DateFormat.Hm(context.localeName)
        .format(DateTime(2000, 1, 1, minuteOfDay ~/ 60, minuteOfDay % 60));

String dateText(BuildContext context, String isoDate, {bool weekday = true}) {
  final d = DateTime.parse(isoDate);
  return (weekday
          ? DateFormat.MMMMEEEEd(context.localeName)
          : DateFormat.yMMMd(context.localeName))
      .format(d);
}

/// 1 = pazartesi … 7 = pazar → yerel kısa ad.
String weekdayShort(BuildContext context, int weekday) =>
    DateFormat.E(context.localeName).format(DateTime(2024, 1, weekday));

String weekdayLong(BuildContext context, int weekday) =>
    DateFormat.EEEE(context.localeName).format(DateTime(2024, 1, weekday));

/// 1–12 → yerel kısa ay adı.
String monthShort(BuildContext context, int month) =>
    DateFormat.MMM(context.localeName).format(DateTime(2024, month));

DateTime utcOf(int minute) =>
    DateTime.fromMillisecondsSinceEpoch(minute * 60000, isUtc: true);

/// Kök kategorinin ikonu (UX_RULES §8 kayıt tablosu; ad sistem verisinden).
IconData rootIcon(String? name) => switch (name) {
  'directions_run' => Symbols.directions_run_rounded,
  'front_hand' => Symbols.front_hand_rounded,
  'music_note' => Symbols.music_note_rounded,
  'menu_book' => Symbols.menu_book_rounded,
  'extension' => Symbols.extension_rounded,
  'handshake' => Symbols.handshake_rounded,
  'self_improvement' => Symbols.self_improvement_rounded,
  'palette' => Symbols.palette_rounded,
  'bedtime' => Symbols.bedtime_rounded,
  _ => Symbols.circle_rounded,
};

Color rootColor(String? hex, ColorScheme scheme) {
  if (hex == null || hex.length != 7) return scheme.outline;
  return Color(int.parse('FF${hex.substring(1)}', radix: 16));
}

extension RootCategoryX on RootCategory {
  String name(BuildContext c) => c.isTurkish ? nameTr : nameEn;
  String description(BuildContext c) =>
      c.isTurkish ? descriptionTr : descriptionEn;
}

extension BrainRegionX on BrainRegion {
  String name(BuildContext c) => c.isTurkish ? nameTr : nameEn;
}

/// Kök kategori rozeti: renk zeminde, ikon her temada okunur kontrastta (UX_RULES §9).
class RootBadge extends StatelessWidget {
  const RootBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 40,
  });

  final String? icon;
  final String? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: rootColor(color, scheme).withValues(alpha: 0.28),
          border: Border.all(color: rootColor(color, scheme), width: 2),
        ),
        child: Icon(rootIcon(icon), size: size * 0.55, color: scheme.onSurface),
      ),
    );
  }
}

/// Bağlamsız "HH:MM" (bildirim ve widget metinleri için).
String clockOfDayLocale(String locale, int minuteOfDay) =>
    DateFormat.Hm(locale)
        .format(DateTime(2000, 1, 1, minuteOfDay ~/ 60, minuteOfDay % 60));
