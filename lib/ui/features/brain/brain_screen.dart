import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../core/app_shell.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'brain_controller.dart';
import 'brain_list_screen.dart';
import 'brain_scene.dart';
import 'bridge.dart';
import '../together/brain_compare.dart';
import 'region_info.dart';

String _hex(Color c) =>
    '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

/// Sahne her zaman koyudur (neon ışıma koyu zeminde okunur): açık görünümde aktif
/// temanın koyu eşi kullanılır (D41).
ThemeData stageTheme(ThemeData t) =>
    t.brightness == Brightness.dark ? t : buildTheme(Brightness.dark);

SceneTheme sceneThemeFor(ColorScheme d) {
  return SceneTheme(
    background: _hex(d.surfaceContainerLowest),
    shell: _hex(d.primary),
    glow: _hex(d.primary),
    signal: _hex(d.tertiary),
    dim: _hex(d.outline),
    line: _hex(d.primary),
    penalty: _hex(d.error),
  );
}

/// Beyin sekmesi: 3D sahne, zaman çizelgesi ve bölge sayfası (BRAIN-1…6).
/// Bölge sayfası aynı sahneyi üst yarıda "odak" görünümünde kullanır; WebView yeniden
/// yaratılmaz, yalnız yerleşim değişir.
class BrainScreen extends ConsumerStatefulWidget {
  const BrainScreen({super.key});

  @override
  ConsumerState<BrainScreen> createState() => _BrainScreenState();
}

class _BrainScreenState extends ConsumerState<BrainScreen> {
  late final AppLifecycleListener _life;
  bool _resumed = true;

  @override
  void initState() {
    super.initState();
    _life = AppLifecycleListener(
      onStateChange: (s) {
        _resumed = s == AppLifecycleState.resumed;
        _syncVisibility();
      },
    );
  }

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _configure();
    _syncVisibility();
  }

  void _configure() {
    final scheme = stageTheme(Theme.of(context)).colorScheme;
    final roots =
        ref.read(rootCategoriesProvider).value ?? const <RootCategory>[];
    ref.read(brainControllerProvider.notifier).configure(
      sceneThemeFor(scheme),
      {for (final r in roots) r.key: r.color},
      MediaQuery.disableAnimationsOf(context),
    );
  }

  /// Sekme açık, üstünde başka sayfa yok ve uygulama ön plandaysa çizilir.
  void _syncVisibility() {
    if (!mounted) return;
    final visible =
        _resumed &&
        TickerMode.valuesOf(context).enabled &&
        (ModalRoute.of(context)?.isCurrent ?? true);
    ref.read(brainControllerProvider.notifier).setVisible(visible);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    ref.listen(rootCategoriesProvider, (_, _) => _configure());
    // Ekran okuyucu açıkken metin alternatifi öne gelir (BRAIN-6).
    if (MediaQuery.accessibleNavigationOf(context)) {
      return Scaffold(
        appBar: AppBar(title: Text(l.brainListTitle)),
        body: BrainListBody(bottomPadding: AppShell.bottomInset(context)),
      );
    }
    final st = ref.watch(brainControllerProvider);
    final ctl = ref.read(brainControllerProvider.notifier);
    final scene = ref.watch(brainSceneProvider);
    final history = ref.watch(brainHistoryProvider);
    final stageData = stageTheme(Theme.of(context));
    final stage = stageData.colorScheme;
    final selected = st.selected;
    final comparing = st.comparing;
    // Alt panel: bölge sayfası ya da arkadaşla karşılaştırma (aynı sahne, D41 / Aşama 4B).
    final panel = selected != null || comparing != null;
    void closePanel() =>
        comparing != null ? ctl.stopCompare() : ctl.select(null);
    final region = selected == null
        ? null
        : ref.watch(brainRegionsProvider).value?[selected];
    final duration = AppTokens.duration(context, Durations.medium4);
    final curve = AppTokens.of(context).standardCurve;

    return PopScope(
      canPop: !panel,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) closePanel();
      },
      child: Theme(
        data: stageData,
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: stage.surfaceContainerLowest,
            body: LayoutBuilder(
              builder: (context, box) {
                final top = MediaQuery.viewPaddingOf(context).top;
                final stageHeight = !panel
                    ? box.maxHeight
                    : box.maxHeight * 0.42;
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: duration,
                      curve: curve,
                      left: 0,
                      right: 0,
                      top: 0,
                      height: stageHeight,
                      child: st.error == null
                          ? Semantics(label: l.navBrain, child: scene.view())
                          : const SizedBox.shrink(),
                    ),
                    if (st.error != null)
                      Positioned.fill(
                        child: MessageState(
                          icon: Symbols.view_in_ar_off_rounded,
                          title: l.brainSceneErrorTitle,
                          body: l.brainSceneErrorBody,
                          actionLabel: l.brainListAction,
                          onAction: () => context.push('/brain/list'),
                        ),
                      )
                    else if (!st.ready)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: stageHeight / 2 - 24,
                        child: Semantics(
                          label: l.brainSceneLoading,
                          liveRegion: true,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    // Üst çubuk: başlık + metin alternatifi + sıfırla / geri.
                    Positioned(
                      left: Gap.s,
                      right: Gap.s,
                      top: top + Gap.xs,
                      child: Row(
                        children: [
                          if (panel)
                            IconButton(
                              tooltip: l.commonBack,
                              icon: const Icon(Symbols.arrow_back_rounded),
                              onPressed: closePanel,
                            )
                          else
                            const SizedBox(width: Gap.s),
                          Expanded(
                            child: Text(
                              comparing != null
                                  ? l.tgCompareTitle(comparing.name)
                                  : region?.name(context) ?? l.navBrain,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: stage.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (st.ready && selected == null)
                            IconButton(
                              tooltip: l.brainResetView,
                              icon: const Icon(Symbols.restart_alt_rounded),
                              onPressed: ctl.resetView,
                            ),
                          IconButton(
                            tooltip: l.brainListAction,
                            icon: const Icon(Symbols.list_rounded),
                            onPressed: () => context.push('/brain/list'),
                          ),
                        ],
                      ),
                    ),
                    if (!panel && st.error == null)
                      Positioned(
                        left: Gap.l,
                        right: Gap.l,
                        bottom: AppShell.bottomInset(context),
                        child: switch (history) {
                          AsyncData(:final value) when value.events.isEmpty =>
                            _EmptyNote(stage: stage),
                          AsyncData(:final value) => _Timeline(
                            first: value.first!,
                            asOf: st.asOf,
                            onChanged: ctl.scrub,
                          ),
                          _ => const SizedBox.shrink(),
                        },
                      ),
                    AnimatedPositioned(
                      duration: duration,
                      curve: curve,
                      left: 0,
                      right: 0,
                      top: !panel ? box.maxHeight : stageHeight,
                      bottom: !panel ? -box.maxHeight : 0,
                      child: Material(
                        color: stage.surfaceContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppTokens.of(context).radius),
                          ),
                        ),
                        child: comparing != null
                            ? CompareInfo(
                                key: ValueKey(comparing.id),
                                userId: comparing.id,
                                name: comparing.name,
                                padding: EdgeInsets.fromLTRB(
                                  Gap.l,
                                  Gap.l,
                                  Gap.l,
                                  AppShell.bottomInset(context),
                                ),
                              )
                            : selected == null
                            ? const SizedBox.shrink()
                            : RegionInfo(
                                key: ValueKey(selected),
                                regionKey: selected,
                                padding: EdgeInsets.fromLTRB(
                                  Gap.l,
                                  Gap.l,
                                  Gap.l,
                                  AppShell.bottomInset(context),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyNote extends StatelessWidget {
  const _EmptyNote({required this.stage});

  final ColorScheme stage;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      color: stage.surfaceContainer.withValues(alpha: 0.92),
      child: Padding(
        padding: const EdgeInsets.all(Gap.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.brainEmptyTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: Gap.xs),
            Text(l.brainEmptyBody, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

/// Geçmişteki bir günün beyni (olay kaynağından katlanır). En sağ = bugün.
class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.first,
    required this.asOf,
    required this.onChanged,
  });

  final DateTime first;
  final DateTime? asOf;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now().toUtc();
    final days = now.difference(first).inDays;
    if (days < 1) return const SizedBox.shrink();
    final value = asOf == null
        ? days.toDouble()
        : asOf!.difference(first).inDays.clamp(0, days).toDouble();
    final at = asOf;
    final label = at == null
        ? l.brainTimelineNow
        : l.brainTimelineAt(
            DateFormat.yMMMd(context.localeName).format(at.toLocal()),
          );
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer
          .withValues(alpha: 0.92),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.s, Gap.s),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${l.brainTimeline} · $label',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Slider(
                    value: value,
                    max: days.toDouble(),
                    divisions: days,
                    label: label,
                    semanticFormatterCallback: (_) => label,
                    onChanged: (v) => onChanged(
                      v >= days
                          ? null
                          : DateTime.utc(
                              first.year,
                              first.month,
                              first.day + v.round() + 1,
                            ).subtract(const Duration(milliseconds: 1)),
                    ),
                  ),
                ],
              ),
            ),
            if (asOf != null)
              IconButton(
                tooltip: l.brainTimelineNow,
                icon: const Icon(Symbols.today_rounded),
                onPressed: () => onChanged(null),
              ),
          ],
        ),
      ),
    );
  }
}
