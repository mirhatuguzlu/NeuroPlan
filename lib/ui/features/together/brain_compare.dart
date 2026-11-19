import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../core/format.dart';
import '../brain/brain_controller.dart';
import 'together_providers.dart';
import 'together_widgets.dart';

/// Beyin sekmesinin karşılaştırma paneli: sahnede iki beyin yan yana (solda sen), altta
/// bölge bazında nöron çubukları. Arkadaşın beyni sunucuda oturum kayıtlarından hesaplanır
/// (ARCHITECTURE §7); izin vermediyse sunucu reddeder.
class CompareInfo extends ConsumerStatefulWidget {
  const CompareInfo({
    super.key,
    required this.userId,
    required this.name,
    required this.padding,
  });

  final String userId;
  final String name;
  final EdgeInsets padding;

  @override
  ConsumerState<CompareInfo> createState() => _CompareInfoState();
}

class _CompareInfoState extends ConsumerState<CompareInfo> {
  String get userId => widget.userId;
  String get name => widget.name;

  @override
  void initState() {
    super.initState();
    // Arkadaşın beyni gelince sahneye bir kez verilir (her yeniden çizimde değil).
    ref.listenManual(friendBrainProvider(userId), (_, next) {
      if (next.value case final s?) {
        ref.read(brainControllerProvider.notifier).compare(s);
      }
    }, fireImmediately: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ctl = ref.read(brainControllerProvider.notifier);
    final regions = ref.watch(brainRegionsProvider).value ?? const {};
    final mine = ctl.brainState;
    final scheme = Theme.of(context).colorScheme;
    return SocialAsync<BrainState>(
      value: ref.watch(friendBrainProvider(userId)),
      onRetry: () => ref.invalidate(friendBrainProvider(userId)),
      data: (other) {
        final keys = regions.values.toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        int n(BrainState? s, String k) =>
            (s?.regions[k]?.total ?? 0) ~/ unitsPerNeuron;
        var maxN = 1;
        for (final r in keys) {
          for (final v in [n(mine, r.key), n(other, r.key)]) {
            if (v > maxN) maxN = v;
          }
        }
        return ListView(
          padding: widget.padding,
          children: [
            Row(
              children: [
                _Dot(color: scheme.primary),
                Text(l.tgLeftYou),
                const SizedBox(width: Gap.l),
                _Dot(color: scheme.tertiary),
                Expanded(child: Text(l.tgRightFriend(name))),
              ],
            ),
            const SizedBox(height: Gap.s),
            Text(l.tgCompareNote, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: Gap.l),
            for (final r in keys)
              if (n(mine, r.key) > 0 || n(other, r.key) > 0)
                MergeSemantics(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: Gap.m),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.name(context)),
                        const SizedBox(height: Gap.xs),
                        _Bar(
                          label: l.tgYou,
                          value: n(mine, r.key),
                          max: maxN,
                          color: scheme.primary,
                        ),
                        _Bar(
                          label: name,
                          value: n(other, r.key),
                          max: maxN,
                          color: scheme.tertiary,
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: Gap.xs),
    child: SizedBox.square(
      dimension: 12,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    ),
  );
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
  });
  final String label;
  final int value;
  final int max;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 88,
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / max,
            minHeight: 10,
            color: color,
          ),
        ),
      ),
      SizedBox(
        width: 72,
        child: Text(context.l10n.tgNeurons(value), textAlign: TextAlign.end),
      ),
    ],
  );
}
