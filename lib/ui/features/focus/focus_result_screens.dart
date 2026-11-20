import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../../core/wizard.dart';
import 'focus_controller.dart';
import 'focus_screen.dart' show focusRegionsProvider;

final _sessionProvider = FutureProvider.autoDispose
    .family<FocusSession?, String>(
      (ref, id) => ref.watch(focusRepositoryProvider).find(id),
    );

final _sessionsProvider = StreamProvider.autoDispose<List<FocusSession>>(
  (ref) => ref.watch(focusRepositoryProvider).watchSessions(),
);

void _leave(BuildContext context, WidgetRef ref, String to) {
  ref.read(focusControllerProvider.notifier).acknowledge();
  context.go(to);
}

/// Bozulan oturum: ne olduğunu sakin bir dille anlatır, yeniden başlatmayı önerir
/// (UX_RULES §10: suçlama yok).
class FocusBrokenScreen extends ConsumerWidget {
  const FocusBrokenScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final s = ref.watch(_sessionProvider(sessionId)).value;
    final root = s?.rootCategoryKey;
    final rootName = root == null
        ? null
        : ref.watch(focusRegionsProvider(root)).value?.root?.name(context);
    final minutes = (s?.focusedSeconds ?? 0) ~/ 60;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave(context, ref, '/today');
      },
      child: Scaffold(
        body: SafeArea(
          child: s == null
              ? const SkeletonList()
              : ListView(
                  padding: const EdgeInsets.all(Gap.xl),
                  children: [
                    const SizedBox(height: Gap.xl),
                    Semantics(
                      header: true,
                      child: Text(
                        l.focusBrokenHeading(context.tone),
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: Gap.l),
                    Text(
                      l.focusBrokenWhat(
                        DateFormat.Hm(context.localeName)
                            .format(s.endedAt!.toLocal()),
                      ),
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: Gap.m),
                    Text(
                      minutes > 0 && rootName != null
                          ? l.focusBrokenBrain(rootName, minutes)
                          : l.focusBrokenBrainNone,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: Gap.m),
                    Text(
                      l.focusBrokenAgain(context.tone),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
        ),
        bottomNavigationBar: s == null
            ? null
            : SafeArea(
                minimum: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, Gap.l),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (s.planInstanceId != null)
                      FilledButton.icon(
                        icon: const Icon(Symbols.restart_alt_rounded),
                        label: Text(l.focusRestart),
                        onPressed: () => _leave(
                          context,
                          ref,
                          '/focus/new/${s.planInstanceId}',
                        ),
                      ),
                    const SizedBox(height: Gap.s),
                    TextButton(
                      onPressed: () => _leave(context, ref, '/today'),
                      child: Text(l.focusBackToToday),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

/// Bitiş adımları, her biri ayrı ekran ve atlanabilir: odak puanı → yorgunluk → not →
/// beyin kazanımı.
class FocusFinishScreen extends ConsumerStatefulWidget {
  const FocusFinishScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<FocusFinishScreen> createState() => _FocusFinishScreenState();
}

class _FocusFinishScreenState extends ConsumerState<FocusFinishScreen> {
  int? _focus;
  int? _fatigue;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _rate({int? focus, int? fatigue, String? note}) => ref
      .read(focusRepositoryProvider)
      .rate(
        widget.sessionId,
        focusRating: focus,
        fatigueRating: fatigue,
        note: note,
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return WizardScaffold(
      onClose: () => _leave(context, ref, '/today'),
      onFinish: () async => _leave(context, ref, '/today'),
      steps: [
        WizardStep(
          id: 'focus',
          title: l.focusRateFocus,
          optional: true,
          canNext: _focus != null,
          onNext: () => _rate(focus: _focus),
          body: _Rating(
            value: _focus,
            low: l.focusRateFocusLow,
            high: l.focusRateFocusHigh,
            onChanged: (v) => setState(() => _focus = v),
          ),
        ),
        WizardStep(
          id: 'fatigue',
          title: l.focusRateFatigue,
          optional: true,
          canNext: _fatigue != null,
          onNext: () => _rate(fatigue: _fatigue),
          body: _Rating(
            value: _fatigue,
            low: l.focusRateFatigueLow,
            high: l.focusRateFatigueHigh,
            onChanged: (v) => setState(() => _fatigue = v),
          ),
        ),
        WizardStep(
          id: 'note',
          title: l.focusNoteTitle,
          optional: true,
          onNext: () async {
            final text = _note.text.trim();
            if (text.isNotEmpty) await _rate(note: text);
          },
          body: TextField(
            controller: _note,
            maxLength: 500,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l.focusNoteLabel,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        WizardStep(
          id: 'gain',
          title: l.focusGainTitle(context.tone),
          nextLabel: l.focusDone,
          body: _Gain(sessionId: widget.sessionId),
        ),
      ],
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({
    required this.value,
    required this.low,
    required this.high,
    required this.onChanged,
  });

  final int? value;
  final String low;
  final String high;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<int>(
          showSelectedIcon: false,
          emptySelectionAllowed: true,
          segments: [
            for (var i = 1; i <= 5; i++)
              ButtonSegment(value: i, label: Text('$i')),
          ],
          selected: {?value},
          onSelectionChanged: (s) {
            if (s.isNotEmpty) onChanged(s.single);
          },
        ),
        const SizedBox(height: Gap.s),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(low, style: style)),
            const SizedBox(width: Gap.l),
            Flexible(
              child: Text(high, style: style, textAlign: TextAlign.end),
            ),
          ],
        ),
      ],
    );
  }
}

/// Bu oturumun karşılığı: "X ile ilişkilendirilen bölgelere N dk ayırdın" ve kazancın
/// bölgelere dağılımı (SCIENCE §1: ölçüm değil, metafor). Moda göre ödül: Pomodoro'da
/// döngü ve seri, derin çalışmada en uzun kesintisiz süre (FOCUS-5).
class _Gain extends ConsumerWidget {
  const _Gain({required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final s = ref.watch(_sessionProvider(sessionId)).value;
    final sessions = ref.watch(_sessionsProvider).value ?? const [];
    if (s == null) return const SizedBox(height: 120);
    final minutes = s.focusedSeconds ~/ 60;
    final info = s.rootCategoryKey == null
        ? null
        : ref.watch(focusRegionsProvider(s.rootCategoryKey!)).value;
    final regions = info?.regions ?? const [];
    final total = regions.fold(0.0, (a, r) => a + r.weight);
    final top = regions.isEmpty ? 1.0 : regions.first.weight;
    final mode = FocusMode.fromJson(s.mode);
    final clock = FocusClock(
      FocusSettings.fromJson(mode, s.settings),
      FocusClock.segmentsFromJson(s.segments),
    );
    final end = s.endedAt ?? DateTime.now().toUtc();
    final reward = switch (mode) {
      FocusMode.pomodoro => l.focusRewardPomodoro(
        clock.completedCycles(end),
        pomodoroStreak([
          for (final x in sessions) (mode: x.mode, outcome: x.outcome),
        ]),
      ),
      FocusMode.deep => l.focusRewardDeep(
        clock.longestRun(end).inMinutes,
        [
          for (final x in sessions)
            if (x.mode == 'deep' && x.outcome == 'completed')
              FocusClock(
                FocusSettings.fromJson(mode, x.settings),
                FocusClock.segmentsFromJson(x.segments),
              ).longestRun(x.endedAt ?? end).inMinutes,
        ].fold(0, (a, b) => a > b ? a : b),
      ),
      FocusMode.free => null,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          minutes < 1
              ? l.focusGainNone(context.tone)
              : l.focusGainBody(info?.root?.name(context) ?? '', minutes),
          style: theme.textTheme.bodyLarge,
        ),
        if (minutes >= 1 && regions.isNotEmpty) ...[
          const SizedBox(height: Gap.l),
          for (final r in regions)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.m),
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.region.name(context),
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: Gap.xs),
                    Semantics(
                      value: l.focusGainShare((r.weight / total * 100).round()),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: r.weight / top),
                        duration: AppTokens.duration(
                          context,
                          Durations.extralong4,
                        ),
                        curve: AppTokens.of(context).enterCurve,
                        builder: (_, v, _) => LinearProgressIndicator(
                          value: v,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                          color: rootColor(
                            context,
                            info?.root?.key,
                            info?.root?.color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Text(
            l.focusGainExplain,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (reward != null) ...[
          const SizedBox(height: Gap.l),
          Text(reward, style: theme.textTheme.titleMedium),
        ],
      ],
    );
  }
}
