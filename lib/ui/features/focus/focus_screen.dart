import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'focus_controller.dart';

/// Kök kategori ve bölgeleri, ağırlığa göre büyükten küçüğe.
typedef FocusRegions = ({
  RootCategory? root,
  List<({BrainRegion region, double weight})> regions,
});

final focusRegionsProvider = FutureProvider.family<FocusRegions, String>((
  ref,
  rootKey,
) async {
  final roots = await ref.watch(rootCategoriesProvider.future);
  final regions = await ref.watch(brainRegionsProvider.future);
  final weights = await ref.watch(regionWeightsProvider(rootKey).future);
  return (
    root: roots.where((r) => r.key == rootKey).firstOrNull,
    regions: [
      for (final w in weights)
        if (regions[w.regionKey] case final r?) (region: r, weight: w.weight),
    ]..sort((a, b) => b.weight.compareTo(a.weight)),
  );
});

/// "12:05" ya da "1:02:05".
String timerText(Duration d) {
  final s = d.inSeconds < 0 ? 0 : d.inSeconds;
  String two(int v) => v.toString().padLeft(2, '0');
  final h = s ~/ 3600, m = s % 3600 ~/ 60, sec = s % 60;
  return h > 0 ? '$h:${two(m)}:${two(sec)}' : '${two(m)}:${two(sec)}';
}

/// Odak oturumu: tek amaç, en az dikkat dağıtıcı. Sistem çubukları gizli (immersive).
class FocusScreen extends ConsumerStatefulWidget {
  const FocusScreen({super.key});

  @override
  ConsumerState<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends ConsumerState<FocusScreen> {
  Timer? _tick;
  var _askingPardon = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Yalnız gösterim tazelenir; sayaç zaman damgasından hesaplanır.
    _tick = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _tick?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  FocusController get _c => ref.read(focusControllerProvider.notifier);

  Future<void> _askPardon() async {
    if (_askingPardon) return;
    _askingPardon = true;
    final l = context.l10n;
    final yes = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: Text(l.focusPardonTitle),
        content: Text(l.focusPardonBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l.focusPardonNo),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l.focusPardonYes),
          ),
        ],
      ),
    );
    _askingPardon = false;
    if (!mounted) return;
    await guard(context, yes == true ? _c.pardon : _c.refuse);
  }

  Future<void> _emergency(int left) async {
    final l = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.focusEmergencyTitle),
        content: Text(l.focusEmergencyBody(left - 1)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l.focusEmergencyConfirm),
          ),
        ],
      ),
    );
    if (ok == true && mounted) await guard(context, _c.emergency);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(focusControllerProvider.select((s) => s.needsPardon), (_, ask) {
      if (ask) _askPardon();
    });
    final l = context.l10n;
    final theme = Theme.of(context);
    final state = ref.watch(focusControllerProvider);
    final clock = state.clock;
    if (clock == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final now = ref.read(focusNowProvider)().toUtc();
    final phase = clock.phase;
    final mode = clock.settings.mode;
    final boundary = clock.nextBoundary(now);
    final focused = clock.focused(now);
    final countdown = boundary != null;
    final shown = countdown ? boundary.difference(now) : focused;
    final label = switch (phase) {
      FocusPhase.working => switch (mode) {
        FocusMode.pomodoro => l.focusPhaseCycle(clock.cycle),
        FocusMode.deep when countdown => l.focusPhaseDeep(
          clock.settings.target,
        ),
        FocusMode.deep => l.focusTargetTitle,
        FocusMode.free => l.modeFree,
      },
      FocusPhase.onBreak => l.focusPhaseBreak,
      FocusPhase.breakOver => l.focusPhaseBreakOver,
      FocusPhase.paused =>
        state.pause == PauseKind.emergency
            ? l.focusPhaseEmergency
            : l.focusPhasePaused,
    };
    final minutes = durationText(l, shown.inMinutes);
    final absence = state.absence;
    final deadline = absence?.callHint == true ? null : absence?.deadline;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) showSnack(context, l.focusBackHint);
      },
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(Gap.xl),
                        child: Column(
                          children: [
                            Semantics(
                              header: true,
                              child: Text(
                                state.title,
                                style: theme.textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: Gap.s),
                            Text(
                              label,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Gap.xl),
                            if (state.session?.rootCategoryKey case final root?)
                              _RegionGlow(
                                rootKey: root,
                                lit: phase == FocusPhase.working,
                              ),
                            const SizedBox(height: Gap.xl),
                            Semantics(
                              label: countdown
                                  ? l.focusTimeLeft(minutes)
                                  : l.focusTimeElapsed(minutes),
                              child: ExcludeSemantics(
                                child: Text(
                                  timerText(shown),
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (countdown && mode != FocusMode.free) ...[
                              const SizedBox(height: Gap.s),
                              Text(
                                l.focusTotal(
                                  durationText(l, focused.inMinutes),
                                ),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  _Actions(
                    state: state,
                    now: now,
                    onEmergency: () => _emergency(state.emergencyLeft),
                  ),
                ],
              ),
            ),
            // Bildirim paneli çekiliyken uygulama arkada görünür: tam ekran geri sayım
            // (UX_RULES §3).
            if (deadline != null)
              Positioned.fill(
                child: _EscapeOverlay(left: deadline.difference(now)),
              ),
          ],
        ),
      ),
    );
  }
}

class _Actions extends ConsumerWidget {
  const _Actions({
    required this.state,
    required this.now,
    required this.onEmergency,
  });

  final FocusState state;
  final DateTime now;
  final VoidCallback onEmergency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = ref.read(focusControllerProvider.notifier);
    final clock = state.clock!;
    final phase = clock.phase;
    final working = phase == FocusPhase.working;
    final emergencyOn = state.pause == PauseKind.emergency;
    final (primaryLabel, primaryIcon, primary) = switch (phase) {
      FocusPhase.working => (l.focusPause, Symbols.pause_rounded, c.pause),
      FocusPhase.onBreak => (
        l.focusEndBreak,
        Symbols.play_arrow_rounded,
        c.resume,
      ),
      _ => (l.focusResume, Symbols.play_arrow_rounded, c.resume),
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.l, 0, Gap.l, Gap.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            icon: Icon(primaryIcon),
            label: Text(primaryLabel),
            onPressed: () => guard(context, primary),
          ),
          const SizedBox(height: Gap.s),
          if (working && clock.settings.mode == FocusMode.deep) ...[
            OutlinedButton.icon(
              icon: const Icon(Symbols.coffee_rounded),
              label: Text(l.focusTakeBreak(clock.breakLength(now).inMinutes)),
              onPressed: () => guard(context, c.takeBreak),
            ),
            const SizedBox(height: Gap.s),
          ],
          OutlinedButton.icon(
            icon: const Icon(Symbols.stop_rounded),
            label: Text(l.focusFinish),
            onPressed: () => guard(context, c.finish),
          ),
          if ((working || phase == FocusPhase.paused) && !emergencyOn) ...[
            const SizedBox(height: Gap.s),
            TextButton.icon(
              icon: const Icon(Symbols.emergency_rounded),
              label: Text(
                state.emergencyLeft > 0
                    ? l.focusEmergency(state.emergencyLeft)
                    : l.focusEmergencyNone,
              ),
              onPressed: state.emergencyLeft > 0 ? onEmergency : null,
            ),
          ],
        ],
      ),
    );
  }
}

/// İşin kök kategorisinin en ağır bölgesi: odak sürerken yavaşça "yanar", duraklatınca
/// söner. Azaltılmış harekette durağandır. 3D beyin beyin aşamasında gelir.
class _RegionGlow extends ConsumerStatefulWidget {
  const _RegionGlow({required this.rootKey, required this.lit});

  final String rootKey;
  final bool lit;

  @override
  ConsumerState<_RegionGlow> createState() => _RegionGlowState();
}

class _RegionGlowState extends ConsumerState<_RegionGlow>
    with SingleTickerProviderStateMixin {
  late final _breath = AnimationController(vsync: this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_RegionGlow old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    _breath.duration = AppTokens.of(context).breathe;
    if (widget.lit && !MediaQuery.disableAnimationsOf(context)) {
      if (!_breath.isAnimating) _breath.repeat(reverse: true);
    } else {
      _breath.stop();
      _breath.value = widget.lit ? 1 : 0;
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(focusRegionsProvider(widget.rootKey)).value;
    final scheme = Theme.of(context).colorScheme;
    final color = rootColor(info?.root?.color, scheme);
    final region = info?.regions.firstOrNull?.region;
    return Column(
      children: [
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _breath,
            builder: (_, child) {
              final t = 0.25 + 0.75 * _breath.value;
              return DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withValues(alpha: 0.55 * t),
                      color.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: child,
              );
            },
            child: SizedBox.square(
              dimension: 120,
              child: ExcludeSemantics(
                child: Icon(
                  Symbols.psychology_rounded,
                  size: 56,
                  color: widget.lit ? color : scheme.outline,
                ),
              ),
            ),
          ),
        ),
        if (region != null) ...[
          const SizedBox(height: Gap.s),
          Text(
            region.name(context),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

class _EscapeOverlay extends StatelessWidget {
  const _EscapeOverlay({required this.left});

  final Duration left;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final seconds = (left.inMilliseconds / 1000).ceil().clamp(0, 10);
    return ColoredBox(
      color: theme.colorScheme.errorContainer,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(Gap.xl),
            child: Semantics(
              liveRegion: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.focusAlertTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Gap.l),
                  Text(
                    l.focusOverlaySeconds(seconds),
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
