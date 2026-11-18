import 'package:material_ui/material_ui.dart';

/// Boşluk ölçeği (dp). Ekranlarda gelişigüzel sayı yerine bunlar kullanılır.
abstract final class Gap {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 12.0;
  static const l = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
}

/// Temaya göre değişebilen tokenlar: köşe ve hareket (UX_RULES §5). Süre ve eğriler
/// yalnız Material 3 tokenlarından seçilir.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    this.radius = 16,
    this.navRadius = 28,
    this.enter = Durations.medium2,
    this.exit = Durations.short3,
    this.enterCurve = Easing.emphasizedDecelerate,
    this.exitCurve = Easing.emphasizedAccelerate,
    this.standardCurve = Easing.standard,
  });

  final double radius;
  final double navRadius;
  final Duration enter;
  final Duration exit;
  final Curve enterCurve;
  final Curve exitCurve;
  final Curve standardCurve;

  static AppTokens of(BuildContext context) =>
      Theme.of(context).extension<AppTokens>() ?? const AppTokens();

  /// Azaltılmış hareket açıksa geçişler anlık olur (UX_RULES §5).
  static Duration duration(BuildContext context, Duration d) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : d;

  @override
  AppTokens copyWith() => this;

  @override
  AppTokens lerp(AppTokens? other, double t) => other ?? this;
}

// Taban tema; Ciddi / Eğlenceli / Genç / Kodcu temaları ve fontlar tema aşamasında (D26).
const _seed = Color(0xFF5B57D9);

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(seedColor: _seed, brightness: brightness);
  const tokens = AppTokens();
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(tokens.radius),
  );
  return ThemeData(
    colorScheme: scheme,
    extensions: const [tokens],
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    cardTheme: CardThemeData(
      shape: shape,
      margin: EdgeInsets.zero,
      color: scheme.surfaceContainerLow,
      elevation: 0,
    ),
    listTileTheme: ListTileThemeData(
      shape: shape,
      minTileHeight: 56,
      contentPadding: const EdgeInsets.symmetric(horizontal: Gap.l),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size(64, 52)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: const Size(64, 52)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
