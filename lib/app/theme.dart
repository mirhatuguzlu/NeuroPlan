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

/// Kart ve yüzey dili (D55): temalar yalnız renkle değil biçimle de ayrışır.
enum Look {
  /// Sakin tonlu kartlar (Ciddi).
  tonal,

  /// Her kart ve satır farklı renkle boyanır (Eğlenceli).
  colorful,

  /// Doygun renk blokları, belirgin kenar (Genç).
  vivid,

  /// Dolgusuz, ince vurgu çerçeveli, keskin köşe (Kodcu).
  terminal,

  /// Düz, gölgesiz, düşük uyarım (Sakin).
  soft,

  /// Kalın çerçeve, en yüksek kontrast (Yüksek Kontrast).
  bold,

  /// Dolgusuz, saç teli çizgi (Minimal).
  hairline,
}

/// Temalar (PRODUCT THEME-1/2, D54, D55). `profiles.theme` anahtarı; null = Ciddi.
/// [tone] metin tonudur (ARB'deki `tone` seçimi): Ciddi, Yüksek Kontrast ve Minimal nötr
/// tonu paylaşır.
enum AppTheme {
  serious(
    Color(0xFF5B57D9),
    _atkinson,
    null,
    null,
    16,
    400,
    Look.tonal,
    'serious',
  ),
  playful(
    Color(0xFFE8613C),
    _atkinson,
    'Nunito',
    null,
    24,
    500,
    Look.colorful,
    'playful',
  ),
  young(
    Color(0xFF00A88A),
    'Lexend',
    'Lexend',
    null,
    20,
    500,
    Look.vivid,
    'young',
  ),
  coder(
    Color(0xFF2E9E5B),
    _atkinson,
    null,
    'JetBrainsMono',
    6,
    300,
    Look.terminal,
    'coder',
  ),
  calm(Color(0xFF5E8798), _atkinson, null, null, 20, 300, Look.soft, 'calm'),
  highContrast(
    Color(0xFF1F4FD1),
    _atkinson,
    null,
    null,
    12,
    600,
    Look.bold,
    'serious',
  ),
  minimal(
    Color(0xFF2F6FDE),
    _atkinson,
    null,
    null,
    10,
    400,
    Look.hairline,
    'serious',
  );

  const AppTheme(
    this.seed,
    this.body,
    this.heading,
    this.numeric,
    this.radius,
    this.iconWeight,
    this.look,
    this.tone,
  );

  final Color seed;
  final String body;

  /// Yalnız ≥ 20sp başlıklarda (UX_RULES §7).
  final String? heading;

  /// Sayaç, büyük sayı ve kod benzeri etiketler (Kodcu).
  final String? numeric;
  final double radius;
  final double iconWeight;
  final Look look;
  final String tone;

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

  /// Renkli temalarda [accent] ile boyanmış yüzey (kart, satır); diğerlerinde null
  /// (tema kartı kullanılır). Yazı onSurface kalır: boya hafiftir, kontrastı testlidir.
  static Color? tintOf(BuildContext context, Color accent) {
    final t = Theme.of(context);
    final dark = t.brightness == Brightness.dark;
    final a = switch (of(context).theme.look) {
      Look.colorful => dark ? 0.22 : 0.16,
      Look.vivid => dark ? 0.30 : 0.24,
      _ => null,
    };
    return a == null
        ? null
        : Color.alphaBlend(accent.withValues(alpha: a), t.colorScheme.surface);
  }

  /// Sıradaki [i]. kart için boya (renkli temalarda palet sırasıyla döner).
  static Color? tint(BuildContext context, int i) {
    final s = ChartColors.from(context).series;
    return tintOf(context, s[i % s.length]);
  }

  /// Azaltılmış hareket açıksa geçişler anlık olur (UX_RULES §5).
  static Duration duration(BuildContext context, Duration d) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : d;

  @override
  AppTokens copyWith() => this;

  @override
  AppTokens lerp(AppTokens? other, double t) => other ?? this;
}

typedef _Palette = ({
  List<Color> light,
  List<Color> dark,
  ({Color light, Color dark}) ninth,
  List<Color> ramp,
});

/// Grafik renkleri (UX_RULES §12, D54, D55). Her temanın kendi kategorik paleti, sıralı
/// rampası ve 9 kök rengi vardır. Paletler dataviz doğrulayıcısıyla seçildi: kategorik sıra
/// renk körlüğü güvenliğinin kendisidir (komşu çiftlerde CVD ΔE ≥ 8, normal görüşte ≥ 15,
/// iki modda). Sakin'de soluk tonlarla bu kapıları geçen sıra bulunamadığı için Minimal'in
/// serisini paylaşır; rampası ve kök renkleri kendinedir. Yazı rengi asla seri rengi değildir.
@immutable
class ChartColors extends ThemeExtension<ChartColors> {
  const ChartColors._(
    this.series,
    this.ramp,
    this.grid,
    this.empty,
    this._roots,
  );

  final List<Color> series;

  /// Sıralı (büyüklük): az → çok; koyu modda çapa çevrilir (az = yüzeye yakın).
  final List<Color> ramp;
  final Color grid;

  /// Verisi olmayan hücre; en düşük değerden ayrı.
  final Color empty;

  /// Kök anahtarı → renk; null = sistem verisindeki renk (Ciddi).
  final Map<String, Color>? _roots;

  /// Kök kategoriler, sistem verisindeki sırayla (assets/seed/system.json; test eşitliği denetler).
  static const rootKeys = [
    'body_movement',
    'motor_skill',
    'music_rhythm',
    'learning_memory',
    'planning_problem_solving',
    'emotional_social',
    'attention_contemplation',
    'creativity_art',
    'rest_sleep',
  ];

  /// Ciddi: dataviz skill'inin varsayılan paleti.
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
  static const _blue = [
    Color(0xFFB7D3F6),
    Color(0xFF86B6EF),
    Color(0xFF5598E7),
    Color(0xFF2A78D6),
    Color(0xFF1C5CAB),
    Color(0xFF104281),
  ];

  static _Palette? _palette(AppTheme t) => switch (t) {
    AppTheme.serious => null,
    AppTheme.playful => (
      light: [
        Color(0xFFE14B39),
        Color(0xFF06999A),
        Color(0xFFDC7D12),
        Color(0xFFAB58BE),
        Color(0xFF2F9F3D),
        Color(0xFF337BD0),
        Color(0xFFD6A20A),
        Color(0xFFDF5E97),
      ],
      dark: [
        Color(0xFFE9523F),
        Color(0xFF19A0A0),
        Color(0xFFCC7200),
        Color(0xFFB561C8),
        Color(0xFF2F9F3D),
        Color(0xFF4087DE),
        Color(0xFFB88A01),
        Color(0xFFD4558E),
      ],
      ninth: (light: Color(0xFF0386B1), dark: Color(0xFF0396C6)),
      ramp: [
        Color(0xFFFFD2CA),
        Color(0xFFFFA191),
        Color(0xFFF17260),
        Color(0xFFCE5342),
        Color(0xFFAC3225),
        Color(0xFF8A0700),
      ],
    ),
    AppTheme.young => (
      light: [
        Color(0xFF773CD6),
        Color(0xFF15AC7D),
        Color(0xFF2955D3),
        Color(0xFFC5AF06),
        Color(0xFFD43691),
        Color(0xFFEA630C),
        Color(0xFF158EAB),
        Color(0xFF4D9501),
      ],
      dark: [
        Color(0xFF945FF9),
        Color(0xFF0EA175),
        Color(0xFF4475F6),
        Color(0xFFA6930B),
        Color(0xFFDF419B),
        Color(0xFFE15F0A),
        Color(0xFF1898B7),
        Color(0xFF519C03),
      ],
      ninth: (light: Color(0xFFBB565A), dark: Color(0xFFCC6568)),
      ramp: [
        Color(0xFFE0D8FE),
        Color(0xFFC3AFFF),
        Color(0xFFA884FF),
        Color(0xFF8C5EE8),
        Color(0xFF703DC6),
        Color(0xFF5517A5),
      ],
    ),
    AppTheme.coder => (
      light: [
        Color(0xFF038D25),
        Color(0xFFAE3EA8),
        Color(0xFFE24A3F),
        Color(0xFF235BC8),
        Color(0xFF9B980B),
        Color(0xFF9575E2),
        Color(0xFFE69D12),
        Color(0xFF199EAA),
      ],
      dark: [
        Color(0xFF2DA73D),
        Color(0xFFC252BB),
        Color(0xFFE54D42),
        Color(0xFF407AEA),
        Color(0xFF9B980B),
        Color(0xFF8968D4),
        Color(0xFFC28412),
        Color(0xFF199EAA),
      ],
      ninth: (light: Color(0xFFB65577), dark: Color(0xFFC76486)),
      ramp: [
        Color(0xFF96FA9A),
        Color(0xFF75D87A),
        Color(0xFF54B85B),
        Color(0xFF31983D),
        Color(0xFF01791E),
        Color(0xFF035814),
      ],
    ),
    AppTheme.calm => (
      light: [
        Color(0xFF2971C6),
        Color(0xFFCB882E),
        Color(0xFF14938D),
        Color(0xFFC66846),
        Color(0xFF2C94B0),
        Color(0xFFC05B6E),
        Color(0xFF7466B5),
        Color(0xFF57914A),
      ],
      dark: [
        Color(0xFF4087DE),
        Color(0xFFC17F21),
        Color(0xFF169D97),
        Color(0xFFCA6B49),
        Color(0xFF2C94B0),
        Color(0xFFCA6477),
        Color(0xFF8678C9),
        Color(0xFF5D9850),
      ],
      ninth: (light: Color(0xFFA45B9F), dark: Color(0xFFB46AAE)),
      ramp: [
        Color(0xFF93F1F0),
        Color(0xFF72D0D0),
        Color(0xFF50B0B0),
        Color(0xFF2B9191),
        Color(0xFF067272),
        Color(0xFF075353),
      ],
    ),
    AppTheme.highContrast => (
      light: [
        Color(0xFF0061BE),
        Color(0xFFDA720D),
        Color(0xFFAB4B90),
        Color(0xFFD23F18),
        Color(0xFF299FCD),
        Color(0xFFC8B212),
        Color(0xFF724AAB),
        Color(0xFF0A9068),
      ],
      dark: [
        Color(0xFF308CF6),
        Color(0xFFDA720D),
        Color(0xFFC664A8),
        Color(0xFFE4512C),
        Color(0xFF259CCA),
        Color(0xFFA6930B),
        Color(0xFF956ED2),
        Color(0xFF0EA175),
      ],
      ninth: (light: Color(0xFF698722), dark: Color(0xFF779634)),
      ramp: [
        Color(0xFFC9E0FE),
        Color(0xFF91C1FF),
        Color(0xFF53A0FF),
        Color(0xFF207FE8),
        Color(0xFF0061BE),
        Color(0xFF00468C),
      ],
    ),
    AppTheme.minimal => (
      light: [
        Color(0xFF2971C6),
        Color(0xFFCB882E),
        Color(0xFF14938D),
        Color(0xFFC66846),
        Color(0xFF2C94B0),
        Color(0xFFC05B6E),
        Color(0xFF7466B5),
        Color(0xFF57914A),
      ],
      dark: [
        Color(0xFF4087DE),
        Color(0xFFC17F21),
        Color(0xFF169D97),
        Color(0xFFCA6B49),
        Color(0xFF2C94B0),
        Color(0xFFCA6477),
        Color(0xFF8678C9),
        Color(0xFF5D9850),
      ],
      ninth: (light: Color(0xFF8B7B02), dark: Color(0xFF9C8A04)),
      ramp: [
        Color(0xFFCDE0F9),
        Color(0xFFADC0D8),
        Color(0xFF8EA0B8),
        Color(0xFF708298),
        Color(0xFF54657A),
        Color(0xFF39495D),
      ],
    ),
  };

  factory ChartColors.of(ColorScheme s, [AppTheme theme = AppTheme.serious]) {
    final p = _palette(theme);
    final dark = s.brightness == Brightness.dark;
    final series = p == null
        ? (dark ? _dark : _light)
        : (dark ? p.dark : p.light);
    final ramp = p?.ramp ?? _blue;
    return ChartColors._(
      series,
      dark ? ramp.reversed.toList() : ramp,
      s.outlineVariant,
      s.surfaceContainerHighest,
      p == null
          ? null
          : {
              for (var i = 0; i < rootKeys.length; i++)
                rootKeys[i]: i < 8
                    ? series[i]
                    : (dark ? p.ninth.dark : p.ninth.light),
            },
    );
  }

  static ChartColors from(BuildContext c) =>
      Theme.of(c).extension<ChartColors>() ??
      ChartColors.of(Theme.of(c).colorScheme);

  /// 0..1 → rampa adımı.
  Color level(double t) => ramp[(t.clamp(0, 1) * (ramp.length - 1)).round()];

  /// Kök kategorinin bu temadaki rengi; Ciddi'de sistem verisindeki renk ([systemHex]).
  Color root(String? key, String? systemHex, ColorScheme scheme) =>
      _roots?[key] ?? hexColor(systemHex) ?? scheme.outline;

  @override
  ChartColors copyWith() => this;

  @override
  ChartColors lerp(ChartColors? other, double t) => other ?? this;
}

/// `#RRGGBB` → renk; biçim bozuksa null.
Color? hexColor(String? hex) => hex == null || hex.length != 7
    ? null
    : Color(int.parse('FF${hex.substring(1)}', radix: 16));

/// Renk → `#RRGGBB` (beyin sahnesi köprüsü).
String hexOf(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

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
  final look = theme.look;
  final (cardColor, cardSide) = switch (look) {
    Look.tonal ||
    Look.colorful => (scheme.surfaceContainerLow, BorderSide.none),
    Look.vivid => (
      scheme.secondaryContainer,
      BorderSide(color: scheme.secondary, width: 1.5),
    ),
    Look.terminal => (
      scheme.surface,
      BorderSide(color: scheme.primary.withValues(alpha: 0.55)),
    ),
    Look.soft => (scheme.surfaceContainer, BorderSide.none),
    Look.bold => (scheme.surface, BorderSide(color: scheme.outline, width: 2)),
    Look.hairline => (scheme.surface, BorderSide(color: scheme.outlineVariant)),
  };
  return ThemeData(
    colorScheme: scheme,
    textTheme: _text(theme, base.textTheme),
    fontFamily: theme.body,
    extensions: [tokens, ChartColors.of(scheme, theme)],
    visualDensity: VisualDensity.standard,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    iconTheme: IconThemeData(weight: theme.iconWeight),
    cardTheme: CardThemeData(
      shape: shape.copyWith(side: cardSide),
      margin: EdgeInsets.zero,
      color: cardColor,
      elevation: look == Look.colorful ? 1 : 0,
      shadowColor: scheme.primary.withValues(alpha: 0.3),
    ),
    dividerTheme: DividerThemeData(
      color: look == Look.bold ? scheme.outline : null,
      thickness: look == Look.bold ? 2 : null,
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
