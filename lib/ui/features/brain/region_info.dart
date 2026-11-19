import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/repositories/brain_repository.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'brain_controller.dart';

/// Bölgenin son 30 günü; olay yazıldıkça yenilenir.
final regionStatsProvider = FutureProvider.autoDispose
    .family<RegionStats, String>((ref, key) {
      ref.watch(brainHistoryProvider);
      return ref
          .watch(brainRepositoryProvider)
          .regionStats(key, DateTime.now().toUtc());
    });

/// Bölgeye bağlı ağırlık satırları (bütün kök kategoriler).
final regionWeightsByRegionProvider = FutureProvider.autoDispose
    .family<List<CategoryRegionWeight>, String>((ref, key) async {
      final db = ref.watch(databaseProvider);
      return (db.select(
        db.categoryRegionWeights,
      )..where((w) => w.regionKey.equals(key))).get();
    });

extension CategoryRegionWeightX on CategoryRegionWeight {
  String detail(BuildContext c) => c.isTurkish ? detailTr : detailEn;
}

/// Bölge sayfasının içeriği (BRAIN-4): ad, durum, son 30 gün, besleyenler, kanıt.
/// 3D bölge sayfası ve metin alternatifi aynı widget'ı kullanır.
class RegionInfo extends ConsumerWidget {
  const RegionInfo({super.key, required this.regionKey, this.padding});

  final String regionKey;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final region = ref.watch(brainRegionsProvider).value?[regionKey];
    final stats = ref.watch(regionStatsProvider(regionKey));
    final weights = ref.watch(regionWeightsByRegionProvider(regionKey));
    final roots = {
      for (final r
          in ref.watch(rootCategoriesProvider).value ?? const <RootCategory>[])
        r.key: r,
    };
    final cats = {
      for (final c
          in ref.watch(categoriesProvider).value ?? const <UserCategory>[])
        c.id: c,
    };
    ref.watch(brainHistoryProvider);
    final now = ref.read(brainControllerProvider.notifier).brainState;
    final st = now?.regions[regionKey];

    if (region == null) return const SkeletonList(rows: 3);
    return ListView(
      padding: padding ?? const EdgeInsets.all(Gap.l),
      children: [
        Wrap(
          spacing: Gap.s,
          runSpacing: Gap.xs,
          children: [
            Chip(label: Text(l.regionHemisphere(region.hemisphere))),
            if (region.isInner) Chip(label: Text(l.regionInner)),
          ],
        ),
        const SizedBox(height: Gap.m),
        if (st != null) ...[
          Text(
            l.regionNeurons(st.total ~/ 1000, (st.brightness / 10).round()),
            style: theme.textTheme.titleMedium,
          ),
          if (st.dimmed >= 1000) Text(l.regionDimmed(st.dimmed ~/ 1000)),
          if (st.lastActive != null)
            Text(
              l.regionLastActive(
                DateFormat.yMMMd(context.localeName)
                    .format(st.lastActive!.toLocal()),
              ),
              style: theme.textTheme.bodySmall,
            ),
          const SizedBox(height: Gap.l),
        ],
        AsyncView<RegionStats>(
          value: stats,
          skeletonRows: 2,
          onRetry: () => ref.invalidate(regionStatsProvider(regionKey)),
          data: (s) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                s.totalMinutes > 0
                    ? l.regionMinutes30(s.totalMinutes)
                    : l.regionMinutes30None,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: Gap.m),
              _Bars(stats: s),
              if (s.minutesByCategory.isNotEmpty) ...[
                const SizedBox(height: Gap.l),
                Text(l.regionFedBy, style: theme.textTheme.titleSmall),
                for (final MapEntry(:key, :value)
                    in (s.minutesByCategory.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value))))
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Symbols.folder_rounded),
                    title: Text(
                      key.startsWith('cat:')
                          ? cats[key.substring(4)]?.name ?? '—'
                          : roots[key.substring(5)]?.name(context) ?? '—',
                    ),
                    trailing: Text(l.regionMinutes(value)),
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: Gap.l),
        Text(l.regionEvidence, style: theme.textTheme.titleSmall),
        const SizedBox(height: Gap.s),
        AsyncView<List<CategoryRegionWeight>>(
          value: weights,
          skeletonRows: 2,
          onRetry: () =>
              ref.invalidate(regionWeightsByRegionProvider(regionKey)),
          data: (ws) => ws.isEmpty
              ? Text(l.regionEvidenceNone)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final w in ws)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(Gap.m),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                roots[w.rootCategoryKey]?.name(context) ??
                                    w.rootCategoryKey,
                                style: theme.textTheme.titleSmall,
                              ),
                              Text(w.detail(context)),
                              const SizedBox(height: Gap.xs),
                              Text(
                                l.evidenceLevel(w.evidenceLevel),
                                style: theme.textTheme.labelLarge,
                              ),
                              if (w.sourceIds.isNotEmpty)
                                SelectableText(
                                  '${l.evidenceSources(w.sourceIds.join(', '))}\n'
                                  '${w.sourceUrls.join('\n')}',
                                  style: theme.textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: Gap.l),
        Text(l.regionMetaphor, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

/// Son 30 günün çubuk grafiği + erişilebilir metin özeti (STATS-5).
class _Bars extends StatelessWidget {
  const _Bars({required this.stats});

  final RegionStats stats;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final max = stats.days.fold(0, (a, d) => d.neurons > a ? d.neurons : a);
    final fed = stats.days.where((d) => d.neurons > 0).length;
    return Semantics(
      label: '${l.regionChartLabel}. ${l.regionChartSummary(fed, max)}',
      excludeSemantics: true,
      child: SizedBox(
        height: 64,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final d in stats.days)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: FractionallySizedBox(
                    heightFactor: max == 0
                        ? 0.04
                        : (d.neurons / max).clamp(0.04, 1.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: d.neurons > 0
                            ? scheme.primary
                            : scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(2),
                      ),
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

/// Metin alternatifinden açılan bölge sayfası (3D olmadan).
class RegionScreen extends ConsumerWidget {
  const RegionScreen({super.key, required this.regionKey});

  final String regionKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final region = ref.watch(brainRegionsProvider).value?[regionKey];
    return Scaffold(
      appBar: AppBar(title: Text(region?.name(context) ?? '')),
      body: RegionInfo(regionKey: regionKey),
    );
  }
}
