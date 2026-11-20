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

/// Temalar (PRODUCT THEME-1/2, D54). `profiles.theme` anahtarı; null = Ciddi.
enum AppTheme {
  serious(Color(0xFF5B57D9), _atkinson, null, null, 16, 400),
  playful(Color(0xFFE8613C), _atkinson, 'Nunito', null, 24, 500),
  young(Color(0xFF00A88A), 'Lexend', 'Lexend', null, 20, 500),
  coder(Color(0xFF2E9E5B), _atkinson, null, 'JetBrainsMono', 8, 300),
  calm(Color(0xFF5E8798), _atkinson, null, null, 20, 300),
  highContrast(Color(0xFF1F4FD1), _atkinson, null, null, 12, 600),
  minimal(Color(0xFF2F6FDE), _atkinson, null, null, 12, 400);

  const AppTheme(
    this.seed,
    this.body,
    this.heading,
    this.numeric,
    this.radius,
    this.iconWeight,
  );

  final Color seed;
  final String body;

  /// Yalnız ≥ 20sp başlıklarda (UX_RULES §7).
  final String? heading;

  /// Sayaç, büyük sayı ve kod benzeri etiketler (Kodcu).
  final String? numeric;
  final double radius;
  final double iconWeight;

  static AppTheme of(String? key) =>
      values.where((t) => t.name == key).firstOrNull ?? serious;
}

const _atkinson = 'AtkinsonHyperlegibleNext';

/// Fontlar değişken (tek dosya, `wght` ekseni): ağırlık eksene de yazılır, yoksa motor
/// varsayılan örneği çizer. Koddaki ağırlık değişikliği de bunu kullanır.
TextStyle weighted(TextStyle s, FontWeight w) => s.copyWith(
  fontWeight: w,
  fontVariations: [FontVariation('wght', w.value.toDouble())],
);

/// Temaya göre değişebilen tokenlar: köşe ve hareket (UX_RULES §5). Süre ve eğriler
/// yalnız Material 3 tokenlarından seçilir.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    this.theme = AppTheme.serious,
    this.radius = 16,
    this.navRadius = 28,
    this.enter = Durations.medium2,
    this.exit = Durations.short3,
    this.enterCurve = Easing.emphasizedDecelerate,
    this.exitCurve = Easing.emphasizedAccelerate,
    this.standardCurve = Easing.standard,
    this.breathe = const Duration(
      milliseconds: 4000,
    ), // 4 × Durations.extralong4
  });

  final AppTheme theme;

  /// Odak ekranındaki "yanıyor" ışımasının yarım nefesi; yalnız oturum sürerken (anlam
  /// taşıyan hareket, UX_RULES §5).
  final Duration breathe;

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

/// Grafik renkleri (UX_RULES §12, D54). dataviz skill'inin doğrulanmış paleti: kategorik
/// sıra renk körlüğü güvenliğinin kendisidir, temaya göre değişmez; açık ve koyu adımlar
/// ayrı seçilmiştir. Yazı rengi asla seri rengi değildir (ColorScheme'den gelir).
@immutable
class ChartColors extends ThemeExtension<ChartColors> {
  const ChartColors._(this.series, this.ramp, this.grid, this.empty);

  /// Kategorik: mavi, turuncu, aqua, sarı, magenta, yeşil, mor, kırmızı.
  final List<Color> series;

  /// Sıralı (büyüklük): az → çok; koyu modda çapa çevrilir (az = yüzeye yakın).
  final List<Color> ramp;
  final Color grid;

  /// Verisi olmayan hücre; en düşük değerden ayrı.
  final Color empty;

  static const _light = [
    Color(0xFF2A78D6),
    Color(0xFFEB6834),
    Color(0xFF1BAF7A),
    Color(0xFFEDA100),
    Color(0xFFE87BA4),
    Color(0xFF008300),
    Color(0xFF6250D6),
    Color(0xFFE34948),
  ];
  static const _dark = [
    Color(0xFF3987E5),
    Color(0xFFD95926),
    Color(0xFF199E70),
    Color(0xFFC98500),
    Color(0xFFD55181),
    Color(0xFF0CA30C),
    Color(0xFF9085E9),
    Color(0xFFE66767),
  ];
  // Mavi rampa 150 · 250 · 350 · 450 · 550 · 650.
  static const _blue = [
    Color(0xFFB7D3F6),
    Color(0xFF86B6EF),
    Color(0xFF5598E7),
    Color(0xFF2A78D6),
    Color(0xFF1C5CAB),
    Color(0xFF104281),
  ];

  factory ChartColors.of(ColorScheme s) => s.brightness == Brightness.light
      ? ChartColors._(
          _light,
          _blue,
          s.outlineVariant,
          s.surfaceContainerHighest,
        )
      : ChartColors._(
          _dark,
          _blue.reversed.toList(),
          s.outlineVariant,
          s.surfaceContainerHighest,
        );

  static ChartColors from(BuildContext c) =>
      Theme.of(c).extension<ChartColors>() ??
      ChartColors.of(Theme.of(c).colorScheme);

  /// 0..1 → rampa adımı.
  Color level(double t) => ramp[(t.clamp(0, 1) * (ramp.length - 1)).round()];

  @override
  ChartColors copyWith() => this;

  @override
  ChartColors lerp(ChartColors? other, double t) => other ?? this;
}

ColorScheme _scheme(AppTheme t, Brightness b) => switch (t) {
  AppTheme.calm => ColorScheme.fromSeed(
    seedColor: t.seed,
    brightness: b,
    dynamicSchemeVariant: DynamicSchemeVariant.neutral,
  ),
  AppTheme.highContrast => ColorScheme.fromSeed(
    seedColor: t.seed,
    brightness: b,
    contrastLevel: 1, // WCAG AAA hedefi (UX_RULES §9)
  ),
  // Minimal: gri yüzeyler, tek vurgu rengi.
  AppTheme.minimal => () {
    final accent = ColorScheme.fromSeed(seedColor: t.seed, brightness: b);
    return ColorScheme.fromSeed(
      seedColor: t.seed,
      brightness: b,
      dynamicSchemeVariant: DynamicSchemeVariant.monochrome,
      primary: accent.primary,
      onPrimary: accent.onPrimary,
      primaryContainer: accent.primaryContainer,
      onPrimaryContainer: accent.onPrimaryContainer,
    );
  }(),
  AppTheme.playful || AppTheme.young => ColorScheme.fromSeed(
    seedColor: t.seed,
    brightness: b,
    dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
  ),
  _ => ColorScheme.fromSeed(seedColor: t.seed, brightness: b),
};

TextTheme _text(AppTheme t, TextTheme base) {
  TextStyle? f(TextStyle? s, String family) => s == null
      ? null
      : weighted(
          s.copyWith(fontFamily: family),
          s.fontWeight ?? FontWeight.w400,
        );
  final h = t.heading ?? t.body;
  final n = t.numeric ?? h;
  return base.copyWith(
    displayLarge: f(base.displayLarge, n),
    displayMedium: f(base.displayMedium, n),
    displaySmall: f(base.displaySmall, n),
    headlineLarge: f(base.headlineLarge, h),
    headlineMedium: f(base.headlineMedium, h),
    headlineSmall: f(base.headlineSmall, h),
    titleLarge: f(base.titleLarge, h),
    titleMedium: f(base.titleMedium, t.body),
    titleSmall: f(base.titleSmall, t.body),
    bodyLarge: f(base.bodyLarge, t.body)?.copyWith(height: 1.5),
    bodyMedium: f(base.bodyMedium, t.body)?.copyWith(height: 1.45),
    bodySmall: f(base.bodySmall, t.body)?.copyWith(height: 1.4),
    labelLarge: f(base.labelLarge, t.body),
    labelMedium: f(base.labelMedium, t.body),
    labelSmall: f(base.labelSmall, t.numeric ?? t.body),
  );
}

ThemeData buildTheme(
  Brightness brightness, {
  AppTheme theme = AppTheme.serious,
}) {
  final scheme = _scheme(theme, brightness);
  final tokens = AppTokens(theme: theme, radius: theme.radius);
  final shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(tokens.radius),
  );
  final base = ThemeData(colorScheme: scheme, brightness: brightness);
  final highContrast = theme == AppTheme.highContrast;
  return ThemeData(
    colorScheme: scheme,
    textTheme: _text(theme, base.textTheme),
    fontFamily: theme.body,
    extensions: [tokens, ChartColors.of(scheme)],
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    iconTheme: IconThemeData(weight: theme.iconWeight),
    cardTheme: CardThemeData(
      shape: highContrast
          ? shape.copyWith(side: BorderSide(color: scheme.outline, width: 2))
          : shape,
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
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(64, 52),
        side: highContrast ? BorderSide(color: scheme.outline, width: 2) : null,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: const OutlineInputBorder(),
      focusedBorder: highContrast
          ? OutlineInputBorder(
              borderSide: BorderSide(color: scheme.primary, width: 3),
            )
          : null,
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}
