import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'format.dart';

String themeName(L10n l, AppTheme t) => switch (t) {
  AppTheme.serious => l.themeSerious,
  AppTheme.playful => l.themePlayful,
  AppTheme.young => l.themeYoung,
  AppTheme.coder => l.themeCoder,
  AppTheme.calm => l.themeCalm,
  AppTheme.highContrast => l.themeHighContrast,
  AppTheme.minimal => l.themeMinimal,
  AppTheme.paper => l.themePaper,
  AppTheme.nature => l.themeNature,
  AppTheme.night => l.themeNight,
};

String themeSpirit(L10n l, AppTheme t) => switch (t) {
  AppTheme.serious => l.themeSeriousBody,
  AppTheme.playful => l.themePlayfulBody,
  AppTheme.young => l.themeYoungBody,
  AppTheme.coder => l.themeCoderBody,
  AppTheme.calm => l.themeCalmBody,
  AppTheme.highContrast => l.themeHighContrastBody,
  AppTheme.minimal => l.themeMinimalBody,
  AppTheme.paper => l.themePaperBody,
  AppTheme.nature => l.themeNatureBody,
  AppTheme.night => l.themeNightBody,
};

/// Tema seçimi: her tema kendi canlı önizlemesiyle (D56); dokununca anında uygulanır.
/// [mode] görünüm tercihidir (`system` / `light` / `dark`); önizleme o parlaklıkta
/// çizilir. `null` = Ciddi (varsayılan, DB_SCHEMA §3.1).
class ThemeChoice extends StatelessWidget {
  const ThemeChoice({
    super.key,
    required this.value,
    required this.mode,
    required this.onChanged,
  });

  final String? value;
  final String? mode;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = AppTheme.of(value);
    final platform = MediaQuery.platformBrightnessOf(context);
    return Column(
      children: [
        for (final t in AppTheme.values)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.l,
              vertical: Gap.xs,
            ),
            child: _ThemeCard(
              theme: t,
              brightness: t.brightnessFor(mode, platform),
              selected: t == selected,
              onTap: () => onChanged(t == AppTheme.serious ? null : t.name),
            ),
          ),
      ],
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.theme,
    required this.brightness,
    required this.selected,
    required this.onTap,
  });

  final AppTheme theme;
  final Brightness brightness;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final app = Theme.of(context);
    final scheme = app.colorScheme;
    return MergeSemantics(
      child: Semantics(
        button: true,
        selected: selected,
        inMutuallyExclusiveGroup: true,
        child: Material(
          color: scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.of(context).radius),
            side: BorderSide(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected ? 3 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(Gap.m),
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: ThemePreview(theme: theme, brightness: brightness),
                  ),
                  const SizedBox(width: Gap.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          themeName(l, theme),
                          style: app.textTheme.titleMedium,
                        ),
                        const SizedBox(height: Gap.xs),
                        Text(
                          themeSpirit(l, theme),
                          style: app.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(width: Gap.s),
                    // Seçili seçenek (UX_RULES §8; check_circle "bitti" demektir).
                    Icon(
                      Symbols.radio_button_checked_rounded,
                      color: scheme.primary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Temanın küçük örneği: başlık ve gövde fontu, kart biçimi, vurgu rengi, sayı fontu ve
/// grafik paleti. Süstür (ekran okuyucudan gizlenir); yazı ölçeklenmez ki kutu taşmasın,
/// aynı bilgi kartın yanındaki ad ve açıklamada ölçeklenerek durur.
class ThemePreview extends StatelessWidget {
  const ThemePreview({
    super.key,
    required this.theme,
    required this.brightness,
  });

  final AppTheme theme;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final data = buildTheme(brightness, theme: theme);
    final s = data.colorScheme;
    final text = data.textTheme;
    final series = data.extension<ChartColors>()!.series;
    final card = data.cardTheme;
    return MediaQuery.withNoTextScaling(
      child: Container(
        width: 128,
        padding: const EdgeInsets.all(Gap.s),
        decoration: BoxDecoration(
          color: s.surface,
          borderRadius: BorderRadius.circular(theme.radius / 2 + 4),
          border: Border.all(color: s.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.navToday,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: text.titleLarge?.copyWith(
                fontSize: 16,
                color: s.onSurface,
              ),
            ),
            const SizedBox(height: Gap.xs),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              decoration: ShapeDecoration(
                color: card.color,
                shape: card.shape ?? const RoundedRectangleBorder(),
              ),
              child: Text(
                l.themePreviewBody,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: text.bodySmall?.copyWith(
                  fontSize: 10,
                  height: 1.3,
                  color: s.onSurface,
                ),
              ),
            ),
            const SizedBox(height: Gap.s),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Gap.s,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: s.primary,
                    borderRadius: BorderRadius.circular(theme.radius),
                  ),
                  child: Text(
                    '25:00',
                    style: text.labelSmall?.copyWith(
                      fontSize: 10,
                      color: s.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: Gap.s),
                Expanded(
                  child: Wrap(
                    spacing: 2,
                    runSpacing: 2,
                    children: [
                      for (final c in series.take(4))
                        Container(width: 8, height: 14, color: c),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
