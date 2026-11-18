import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'focus_controller.dart';

final _savedSettingsProvider = FutureProvider.autoDispose(
  (ref) => savedFocusSettings(ref.watch(prefsRepositoryProvider)),
);

/// Odak başlatma: mod işin varsayılanıyla gelir, tek dokunuşla değişir; süreler satır
/// içinde açılır. Tek birincil eylem: Başla.
class FocusStartScreen extends ConsumerStatefulWidget {
  const FocusStartScreen({super.key, required this.instanceId});

  final String instanceId;

  @override
  ConsumerState<FocusStartScreen> createState() => _FocusStartScreenState();
}

class _FocusStartScreenState extends ConsumerState<FocusStartScreen> {
  FocusMode? _mode;
  Map<FocusMode, FocusSettings>? _settings;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final view = ref.watch(horizonProvider).value;
    final saved = ref.watch(_savedSettingsProvider).value;
    final instance = view?.byId[widget.instanceId];
    final body = switch ((view, saved, instance)) {
      (null, _, _) || (_, null, _) => const SkeletonList(),
      (_, _, null) => MessageState(
        icon: Symbols.info_rounded,
        title: l.focusMissingTitle,
        body: l.focusMissingBody,
        actionLabel: l.commonBack,
        onAction: () => context.pop(),
      ),
      (final v?, final s?, final i?) => () {
        _settings ??= {...s};
        final mode = _mode ??= FocusMode.fromJson(
          v.data.focusMode(i.activityId),
        );
        final settings = _settings![mode]!;
        return ListView(
          padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.l, Gap.xl, Gap.xxl),
          children: [
            Semantics(
              header: true,
              child: Text(
                v.data.activities[i.activityId]?.title ?? '',
                style: theme.textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: Gap.xl),
            Text(l.wizFocusMode, style: theme.textTheme.titleSmall),
            const SizedBox(height: Gap.s),
            SegmentedButton<FocusMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: FocusMode.free, label: Text(l.modeFree)),
                ButtonSegment(
                  value: FocusMode.pomodoro,
                  label: Text(l.modePomodoro),
                ),
                ButtonSegment(value: FocusMode.deep, label: Text(l.modeDeep)),
              ],
              selected: {mode},
              onSelectionChanged: (m) => setState(() => _mode = m.single),
            ),
            const SizedBox(height: Gap.l),
            Text(_summary(l, settings), style: theme.textTheme.bodyLarge),
            if (mode != FocusMode.free)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text(l.focusChangeDurations),
                children: [
                  for (final (label, value, options, apply) in _fields(
                    l,
                    settings,
                  ))
                    _Choices(
                      label: label,
                      value: value,
                      options: options,
                      onChanged: (v) =>
                          setState(() => _settings![mode] = apply(settings, v)),
                    ),
                ],
              ),
            const SizedBox(height: Gap.l),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Icon(
                    Symbols.info_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: Gap.s),
                Expanded(
                  child: Text(
                    l.focusRuleHint,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }(),
    };
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l.commonClose,
          icon: const Icon(Symbols.close_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(l.actionFocus),
      ),
      body: SafeArea(child: body),
      bottomNavigationBar: instance == null || _mode == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, Gap.l),
              child: BusyButton(
                label: l.focusStart,
                onPressed: () => guard(
                  context,
                  () => ref
                      .read(focusControllerProvider.notifier)
                      .start(instance: instance, settings: _settings![_mode!]!),
                ),
              ),
            ),
    );
  }

  String _summary(L10n l, FocusSettings s) => switch (s.mode) {
    FocusMode.free => l.focusSummaryFree,
    FocusMode.pomodoro => l.focusSummaryPomodoro(
      s.work,
      s.rest,
      s.longEvery,
      s.longRest,
    ),
    FocusMode.deep => l.focusSummaryDeep(s.target),
  };

  List<(String, int, List<int>, FocusSettings Function(FocusSettings, int))>
  _fields(L10n l, FocusSettings s) => switch (s.mode) {
    FocusMode.pomodoro => [
      (
        l.focusFieldWork,
        s.work,
        [15, 20, 25, 30, 45, 50],
        (s, v) => s.copyWith(work: v),
      ),
      (
        l.focusFieldBreak,
        s.rest,
        [3, 5, 10, 15],
        (s, v) => s.copyWith(rest: v),
      ),
      (
        l.focusFieldLongBreak,
        s.longRest,
        [10, 15, 20, 30],
        (s, v) => s.copyWith(longRest: v),
      ),
      (
        l.focusFieldLongEvery,
        s.longEvery,
        [2, 3, 4, 5, 6],
        (s, v) => s.copyWith(longEvery: v),
      ),
    ],
    FocusMode.deep => [
      (
        l.focusFieldTarget,
        s.target,
        [45, 60, 90, 120, 180],
        (s, v) => s.copyWith(target: v),
      ),
    ],
    FocusMode.free => const [],
  };
}

/// Hazır değerler arasından tek seçim (sayaçlı +/- yerine; daha az dokunuş).
class _Choices extends StatelessWidget {
  const _Choices({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final int value;
  final List<int> options;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.m),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: Gap.xs),
        Wrap(
          spacing: Gap.s,
          runSpacing: Gap.s,
          children: [
            for (final o in {...options, value}.toList()..sort())
              ChoiceChip(
                label: Text('$o'),
                selected: o == value,
                onSelected: (_) => onChanged(o),
              ),
          ],
        ),
      ],
    ),
  );
}
