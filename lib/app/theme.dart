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

  /// Kâğıt zemin, mürekkep çizgisi, neredeyse keskin köşe (Kâğıt).
  paper,

  /// Yumuşak, topraksı tonlu yüzeyler, iri köşe (Doğa).
  earthy,

  /// Gerçek siyah zemin, hafif vurgu çerçevesi (Gece).
  oled,
}

/// Hareketin hızı ve karakteri (UX_RULES §5, D56). Süreler yine Material 3
/// tokenlarıdır; tema yalnız çarpanı ve eğriyi seçer ([AppTokens.duration]).
enum Motion {
  /// Az ve kısa hareket, standart eğri (Ciddi, Kodcu, Yüksek Kontrast, Minimal).
  quiet(0.8, Easing.standardDecelerate, Easing.standardAccelerate),

  /// Yavaş ve yumuşak (Sakin, Doğa, Gece).
  soft(1.25, Easing.standardDecelerate, Easing.standardAccelerate),

  /// Vurgulu eğri, normal hız (Eğlenceli).
  lively(1, Easing.emphasizedDecelerate, Easing.emphasizedAccelerate),

  /// Vurgulu eğri, çevik (Genç).
  brisk(0.85, Easing.emphasizedDecelerate, Easing.emphasizedAccelerate),

  /// Anlık: e-mürekkep hissi, geçiş yok (Kâğıt).
  instant(0, Easing.standard, Easing.standard);

  const Motion(this.speed, this.enterCurve, this.exitCurve);

  final double speed;
  final Curve enterCurve;
  final Curve exitCurve;
}

/// Temalar (PRODUCT THEME-1/2, D54–D56). `profiles.theme` anahtarı; null = Ciddi.
/// Bütün tema tokenları burada; kararlar ve paylaşımlar docs/THEMES.md'de.
/// [tone] metin tonudur (ARB'deki `tone` seçimi): Ciddi, Yüksek Kontrast, Minimal,
/// Kâğıt ve Gece nötr tonu, Doğa Sakin'in tonunu paylaşır.
enum AppTheme {
  serious(
    seed: Color(0xFF5B57D9),
    radius: 16,
    iconWeight: 400,
    look: Look.tonal,
    tone: 'serious',
    motion: Motion.quiet,
  ),
  playful(
    seed: Color(0xFFE8613C),
    heading: 'Nunito',
    radius: 24,
    iconWeight: 500,
    look: Look.colorful,
    tone: 'playful',
    motion: Motion.lively,
    variant: DynamicSchemeVariant.vibrant,
    typeScale: 1.06,
    touch: 56,
  ),
  young(
    seed: Color(0xFF00A88A),
    body: 'Lexend',
    heading: 'Lexend',
    radius: 20,
    iconWeight: 500,
    look: Look.vivid,
    tone: 'young',
    motion: Motion.brisk,
    variant: DynamicSchemeVariant.vibrant,
  ),
  coder(
    seed: Color(0xFF2E9E5B),
    numeric: 'JetBrainsMono',
    radius: 6,
    iconWeight: 300,
    look: Look.terminal,
    tone: 'coder',
    motion: Motion.quiet,
    darkFirst: true,
  ),
  calm(
    seed: Color(0xFF5E8798),
    radius: 20,
    iconWeight: 300,
    look: Look.soft,
    tone: 'calm',
    motion: Motion.soft,
    variant: DynamicSchemeVariant.neutral,
  ),
  highContrast(
    seed: Color(0xFF1F4FD1),
    radius: 12,
    iconWeight: 600,
    look: Look.bold,
    tone: 'serious',
    motion: Motion.quiet,
  ),
  minimal(
    seed: Color(0xFF2F6FDE),
    radius: 10,
    iconWeight: 400,
    look: Look.hairline,
    tone: 'serious',
    motion: Motion.quiet,
  ),
  paper(
    seed: Color(0xFF2B4C7E),
    heading: 'IBMPlexSans',
    radius: 4,
    iconWeight: 300,
    look: Look.paper,
    tone: 'serious',
    motion: Motion.instant,
  ),
  nature(
    seed: Color(0xFF6E7F3A),
    heading: 'Nunito',
    radius: 24,
    iconWeight: 400,
    look: Look.earthy,
    tone: 'calm',
    motion: Motion.soft,
  ),
  night(
    seed: Color(0xFF7B83EB),
    radius: 16,
    iconWeight: 300,
    look: Look.oled,
    tone: 'serious',
    motion: Motion.soft,
    darkFirst: true,
  );

  const AppTheme({
    required this.seed,
    this.body = _atkinson,
    this.heading,
    this.numeric,
    required this.radius,
    required this.iconWeight,
    required this.look,
    required this.tone,
    required this.motion,
    this.variant = DynamicSchemeVariant.tonalSpot,
    this.typeScale = 1,
    this.touch = 52,
    this.darkFirst = false,
  });

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
  final Motion motion;

  /// Material şema türü (renklerin doygunluğu).
  final DynamicSchemeVariant variant;

  /// Yazı boyutu çarpanı (Eğlenceli biraz iri).
  final double typeScale;

  /// Dolu ve çerçeveli butonların en küçük yüksekliği (dp; alt sınır 48).
  final double touch;

  /// Görünüm "sistem" iken de koyu açılır (Kodcu, Gece).
  final bool darkFirst;

  static AppTheme of(String? key) =>
      values.where((t) => t.name == key).firstOrNull ?? serious;

  /// "Sistem" görünümünde bu temanın ve cihazın parlaklığı.
  Brightness brightnessFor(String? mode, Brightness platform) => switch (mode) {
    'light' => Brightness.light,
    'dark' => Brightness.dark,
    _ => darkFirst ? Brightness.dark : platform,
  };
}

const _atkinson = 'AtkinsonHyperlegibleNext';

/// Uygulamaya gömülü fontlar (görünen ad, `assets/fonts/OFL_<dosya>.txt`). Hepsi SIL
/// Open Font License 1.1; Hakkında ekranı ve lisans sayfası buradan okur (UX_RULES §7).
const embeddedFonts = [
  ('Atkinson Hyperlegible Next', 'atkinsonhyperlegiblenext'),
  ('Nunito', 'nunito'),
  ('Lexend', 'lexend'),
  ('JetBrains Mono', 'jetbrainsmono'),
  ('IBM Plex Sans', 'ibmplexsans'),
];

/// Fontlar değişken (tek dosya, `wght` ekseni): ağırlık eksene de yazılır, yoksa motor
/// varsayılan örneği çizer. Koddaki ağırlık değişikliği de bunu kullanır.
TextStyle weighted(TextStyle s, FontWeight w) => s.copyWith(
  fontWeight: w,
  fontVariations: [FontVariation('wght', w.value.toDouble())],
);

/// Temaya göre değişen tokenlar: köşe ve hareket (UX_RULES §5, D56). Süre ve eğriler
/// yalnız Material 3 tokenlarından seçilir; tema hız çarpanını ve eğri karakterini
/// verir ([Motion]).
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    this.theme = AppTheme.serious,
    this.radius = 16,
    this.navRadius = 28,
    this.breathe = const Duration(
      milliseconds: 4000,
    ), // 4 × Durations.extralong4
  });

  final AppTheme theme;

  /// Odak ekranındaki "yanıyor" ışımasının yarım nefesi; yalnız oturum sürerken (anlam
  /// taşıyan hareket, UX_RULES §5). Temadan bağımsızdır: anlamı hızı belirler.
  final Duration breathe;

  final double radius;
  final double navRadius;

  Curve get enterCurve => theme.motion.enterCurve;
  Curve get exitCurve => theme.motion.exitCurve;
  Curve get standardCurve => Easing.standard;

  /// Tema geçişinin süresi (MaterialApp.themeAnimationDuration).
  Duration get themeSwitch => scaled(Durations.long2);

  /// [d]'yi temanın hız çarpanıyla ölçekler.
  Duration scaled(Duration d) =>
      Duration(microseconds: (d.inMicroseconds * theme.motion.speed).round());

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

  /// Temanın hızıyla ölçeklenmiş süre; azaltılmış hareket açıksa ya da tema anlıksa
  /// sıfır (UX_RULES §5).
  static Duration duration(BuildContext context, Duration d) =>
      MediaQuery.disableAnimationsOf(context)
      ? Duration.zero
      : of(context).scaled(d);

  /// Geçiş çizilmeli mi (azaltılmış hareket ya da anlık tema değilse).
  static bool animates(BuildContext context) =>
      !MediaQuery.disableAnimationsOf(context) &&
      of(context).theme.motion != Motion.instant;

  @override
  AppTokens copyWith() => this;

  @override
  AppTokens lerp(AppTokens? other, double t) =>
      other == null || t < 0.5 ? this : other;
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

  /// Minimal ve Kâğıt'ın (ve Sakin'in) ortak sakin serisi.
  static const _minimalSeries = (
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
  );

  static const _natureSeries = [
    Color(0xFFAE5528),
    Color(0xFF45A075),
    Color(0xFFB46D10),
    Color(0xFF955890),
    Color(0xFF76771A),
    Color(0xFFD8625C),
    Color(0xFF46712B),
    Color(0xFF139CB6),
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
      light: _minimalSeries.light,
      dark: _minimalSeries.dark,
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
      light: _minimalSeries.light,
      dark: _minimalSeries.dark,
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
    // Kâğıt: Minimal'in sakin serisi; mürekkep mavisi rampa ve kahve dokuzuncu renk.
    AppTheme.paper => (
      light: _minimalSeries.light,
      dark: _minimalSeries.dark,
      ninth: (light: Color(0xFF8C6B4A), dark: Color(0xFFA07C58)),
      ramp: [
        Color(0xFFD1DFF2),
        Color(0xFFABBCD3),
        Color(0xFF869AB4),
        Color(0xFF637996),
        Color(0xFF415A79),
        Color(0xFF243E5F),
      ],
    ),
    // Doğa: topraksı seri (terrakota, deniz yeşili, aşı boyası, erik, zeytin, mercan,
    // yosun, çamurcun); aynı renkler iki modda da kapıları geçti.
    AppTheme.nature => (
      light: _natureSeries,
      dark: _natureSeries,
      ninth: (light: Color(0xFF4B6FA5), dark: Color(0xFF5A80B8)),
      ramp: [
        Color(0xFFD6E4C1),
        Color(0xFFB1C297),
        Color(0xFF8EA16E),
        Color(0xFF6C8046),
        Color(0xFF4C611C),
        Color(0xFF304600),
      ],
    ),
    // Gece: Ciddi'nin doğrulanmış serisi; çivit rampa ve camgöbeği dokuzuncu renk.
    AppTheme.night => (
      light: _light,
      dark: _dark,
      ninth: (light: Color(0xFF1E93A6), dark: Color(0xFF2BA9BD)),
      ramp: [
        Color(0xFFD3DBFF),
        Color(0xFFAEB6EE),
        Color(0xFF8A92D3),
        Color(0xFF6870B8),
        Color(0xFF494D9D),
        Color(0xFF302D85),
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
  ChartColors lerp(ChartColors? other, double t) {
    if (other == null) return this;
    List<Color> mix(List<Color> a, List<Color> b) => a.length != b.length
        ? (t < 0.5 ? a : b)
        : [for (var i = 0; i < a.length; i++) Color.lerp(a[i], b[i], t)!];
    return ChartColors._(
      mix(series, other.series),
      mix(ramp, other.ramp),
      Color.lerp(grid, other.grid, t)!,
      Color.lerp(empty, other.empty, t)!,
      t < 0.5 ? _roots : other._roots,
    );
  }
}

/// `#RRGGBB` → renk; biçim bozuksa null.
Color? hexColor(String? hex) => hex == null || hex.length != 7
    ? null
    : Color(int.parse('FF${hex.substring(1)}', radix: 16));

/// Renk → `#RRGGBB` (beyin sahnesi köprüsü).
String hexOf(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

ColorScheme _scheme(AppTheme t, Brightness b) {
  ColorScheme seeded(Color seed, DynamicSchemeVariant v) =>
      ColorScheme.fromSeed(
        seedColor: seed,
        brightness: b,
        dynamicSchemeVariant: v,
        contrastLevel: t == AppTheme.highContrast
            ? 1
            : 0, // YK: WCAG AAA hedefi
      );
  // Tek vurgu rengi, yüzeyler başka bir tohumdan (Minimal: gri, Kâğıt: sıcak kâğıt).
  ColorScheme accented(ColorScheme surfaces) {
    final accent = seeded(t.seed, DynamicSchemeVariant.tonalSpot);
    return surfaces.copyWith(
      primary: accent.primary,
      onPrimary: accent.onPrimary,
      primaryContainer: accent.primaryContainer,
      onPrimaryContainer: accent.onPrimaryContainer,
    );
  }

  return switch (t) {
    AppTheme.minimal => accented(
      seeded(t.seed, DynamicSchemeVariant.monochrome),
    ),
    AppTheme.paper => accented(
      seeded(const Color(0xFF8C7A55), DynamicSchemeVariant.neutral),
    ),
    // Gece koyuda gerçek siyah (OLED); kaplar siyaha yakın basamaklar.
    AppTheme.night when b == Brightness.dark =>
      seeded(t.seed, t.variant).copyWith(
        surface: const Color(0xFF000000),
        surfaceDim: const Color(0xFF000000),
        surfaceContainerLowest: const Color(0xFF000000),
        surfaceContainerLow: const Color(0xFF0B0B10),
        surfaceContainer: const Color(0xFF121218),
        surfaceContainerHigh: const Color(0xFF1A1A21),
        surfaceContainerHighest: const Color(0xFF23232B),
        surfaceBright: const Color(0xFF2B2B33),
      ),
    _ => seeded(t.seed, t.variant),
  };
}

TextTheme _text(AppTheme t, TextTheme base) {
  // Boyutlar çizimde M3 geometrisinden gelir; ölçekli temada yalnız boyut önceden yazılır
  // (stil `inherit: true` kalır ki tema geçişinde ara değer alınabilsin).
  final geo = Typography.material2021().englishLike;
  TextStyle? f(TextStyle? s, TextStyle? g, String family) {
    if (s == null) return null;
    final size = s.fontSize ?? g?.fontSize;
    return weighted(
      s.copyWith(
        fontFamily: family,
        fontSize: t.typeScale == 1 || size == null
            ? s.fontSize
            : size * t.typeScale,
      ),
      s.fontWeight ?? FontWeight.w400,
    );
  }

  final h = t.heading ?? t.body;
  final n = t.numeric ?? h;
  return base.copyWith(
    displayLarge: f(base.displayLarge, geo.displayLarge, n),
    displayMedium: f(base.displayMedium, geo.displayMedium, n),
    displaySmall: f(base.displaySmall, geo.displaySmall, n),
    headlineLarge: f(base.headlineLarge, geo.headlineLarge, h),
    headlineMedium: f(base.headlineMedium, geo.headlineMedium, h),
    headlineSmall: f(base.headlineSmall, geo.headlineSmall, h),
    titleLarge: f(base.titleLarge, geo.titleLarge, h),
    titleMedium: f(base.titleMedium, geo.titleMedium, t.body),
    titleSmall: f(base.titleSmall, geo.titleSmall, t.body),
    bodyLarge: f(base.bodyLarge, geo.bodyLarge, t.body)?.copyWith(height: 1.5),
    bodyMedium: f(
      base.bodyMedium,
      geo.bodyMedium,
      t.body,
    )?.copyWith(height: 1.45),
    bodySmall: f(base.bodySmall, geo.bodySmall, t.body)?.copyWith(height: 1.4),
    labelLarge: f(base.labelLarge, geo.labelLarge, t.body),
    labelMedium: f(base.labelMedium, geo.labelMedium, t.body),
    labelSmall: f(base.labelSmall, geo.labelSmall, t.numeric ?? t.body),
  );
}

/// Tema verisi saf bir fonksiyondur; tema seçicideki önizlemeler aynı nesneyi kullanır.
ThemeData buildTheme(
  Brightness brightness, {
  AppTheme theme = AppTheme.serious,
}) => _themes[(theme, brightness)] ??= _build(brightness, theme);

final _themes = <(AppTheme, Brightness), ThemeData>{};

ThemeData _build(Brightness brightness, AppTheme theme) {
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
    Look.paper => (
      scheme.surface,
      BorderSide(color: scheme.onSurface.withValues(alpha: 0.22)),
    ),
    Look.earthy => (scheme.surfaceContainerLow, BorderSide.none),
    Look.oled => (
      scheme.surfaceContainerLow,
      BorderSide(color: scheme.primary.withValues(alpha: 0.35)),
    ),
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
      minTileHeight: theme.touch + 4,
      contentPadding: const EdgeInsets.symmetric(horizontal: Gap.l),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: Size(64, theme.touch)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: Size(64, theme.touch),
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
