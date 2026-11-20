import 'feedback.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../app/transitions.dart';
import '../features/brain/brain_controller.dart';
import '../features/together/together_providers.dart';
import 'format.dart';

/// Alt menü sekmeleri + havada duran çubuk + ayrık "Ekle" butonu (UX_RULES §6, D28).
/// Sekmeler yalnız hedeftir; Ekle yalnız eylemdir.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const barHeight = 72.0;

  /// Listelerin son öğesi çubuğun arkasında kalmasın diye eklenecek alt dolgu.
  static double bottomInset(BuildContext context) =>
      barHeight + Gap.l * 2 + MediaQuery.viewPaddingOf(context).bottom;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom > 0;
    // Ön ısıtma: beyin sahnesi ilk kareden sonra arka planda yüklenir (BRAIN-5).
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(brainControllerProvider),
    );
    // Birlikte: canlı değişiklikler, takvim yayını, mesaj bildirimi (sosyal açıksa).
    ref.watch(togetherLiveProvider);
    ref.read(togetherTextsProvider).value = TogetherTexts(
      title: l.tgNoticeMessagesTitle,
      channel: l.tgNoticeMessagesChannel,
      body: l.tgNoticeMessagesBody,
    );
    final badge = ref.watch(badgesProvider).value?.total ?? 0;
    final destinations = [
      (Symbols.today_rounded, l.navToday, 0),
      (Symbols.calendar_month_rounded, l.navPlan, 0),
      (Symbols.psychology_rounded, l.navBrain, 0),
      (Symbols.diversity_3_rounded, l.navTogether, badge),
      (Symbols.person_rounded, l.navProfile, 0),
    ];
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          FadeThroughOnChange(index: shell.currentIndex, child: shell),
          if (!keyboard)
            Positioned(
              left: Gap.l,
              right: Gap.l,
              bottom: Gap.l + MediaQuery.viewPaddingOf(context).bottom,
              child: Row(
                children: [
                  Expanded(
                    child: _Bar(
                      destinations: destinations,
                      selected: shell.currentIndex,
                      onSelect: (i) {
                        Haptics.select(context);
                        shell.goBranch(
                          i,
                          initialLocation: i == shell.currentIndex,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: Gap.m),
                  _AddButton(
                    label: l.actionAdd,
                    onPressed: () => context.push('/add'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.destinations,
    required this.selected,
    required this.onSelect,
  });

  final List<(IconData, String, int)> destinations;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = AppTokens.of(context);
    // Görünüm temaya göre değişir, yapı ve konum değişmez (UX_RULES §6, D55).
    final (color, side, elevation) = switch (tokens.theme.look) {
      Look.tonal => (
        scheme.surfaceContainer,
        BorderSide(color: scheme.outlineVariant),
        3.0,
      ),
      Look.colorful => (scheme.primaryContainer, BorderSide.none, 3.0),
      Look.vivid => (
        scheme.secondaryContainer,
        BorderSide(color: scheme.secondary, width: 2),
        2.0,
      ),
      Look.terminal => (
        scheme.surface,
        BorderSide(color: scheme.primary.withValues(alpha: 0.6)),
        0.0,
      ),
      Look.soft => (scheme.surfaceContainer, BorderSide.none, 0.0),
      Look.bold => (
        scheme.surface,
        BorderSide(color: scheme.outline, width: 2),
        0.0,
      ),
      Look.hairline => (
        scheme.surface,
        BorderSide(color: scheme.outlineVariant),
        0.0,
      ),
      Look.paper => (
        scheme.surface,
        BorderSide(color: scheme.onSurface.withValues(alpha: 0.22)),
        0.0,
      ),
      Look.earthy => (scheme.secondaryContainer, BorderSide.none, 1.0),
      Look.oled => (
        scheme.surfaceContainerLow,
        BorderSide(color: scheme.primary.withValues(alpha: 0.35)),
        0.0,
      ),
    };
    return Material(
      elevation: elevation,
      color: color,
      shadowColor: scheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          tokens.theme.look == Look.terminal || tokens.theme.look == Look.paper
              ? tokens.radius
              : tokens.navRadius,
        ),
        side: side,
      ),
      child: SizedBox(
        height: AppShell.barHeight,
        child: Row(
          children: [
            for (final (i, (icon, label, badge)) in destinations.indexed)
              Expanded(
                child: _Destination(
                  icon: icon,
                  label: label,
                  badge: badge,
                  selected: i == selected,
                  onTap: () => onSelect(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Destination extends StatelessWidget {
  const _Destination({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final String label;

  /// Bekleyen iş sayısı (yalnız Birlikte); 0 = rozet yok.
  final int badge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tokens = AppTokens.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: badge > 0 ? context.l10n.navBadge(label, badge) : label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: AppTokens.duration(context, Durations.medium1),
              curve: tokens.standardCurve,
              width: 56,
              height: 32,
              decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: selected
                    ? scheme.secondaryContainer
                    : Colors.transparent,
              ),
              child: Badge(
                isLabelVisible: badge > 0,
                smallSize: 8,
                child: Icon(
                  icon,
                  fill: selected ? 1 : 0,
                  color: selected
                      ? scheme.onSecondaryContainer
                      : scheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: Gap.xs),
            // Beş sekmede dar telefonda (360dp ≈ 49dp/sekme) etiket kesilmesin, küçülsün (UX §6).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.xs),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  style: weighted(
                    theme.textTheme.labelMedium!.copyWith(
                      color: selected
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant,
                    ),
                    selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        excludeSemantics: true,
        child: Material(
          elevation: 3,
          color: scheme.primary,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox.square(
              dimension: AppShell.barHeight,
              child: Icon(
                Symbols.add_rounded,
                size: 32,
                color: scheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
