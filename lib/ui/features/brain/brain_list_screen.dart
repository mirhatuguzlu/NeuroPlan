import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'brain_controller.dart';

/// 3D sahnenin metin alternatifi (BRAIN-6): her bölge, nöron sayısı ve parlaklığı.
/// Ekran okuyucu açıkken Beyin sekmesi bunu doğrudan gösterir.
class BrainListBody extends ConsumerWidget {
  const BrainListBody({super.key, this.bottomPadding = Gap.l});

  final double bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    ref.watch(brainHistoryProvider);
    final regions = ref.watch(brainRegionsProvider);
    final state = ref.read(brainControllerProvider.notifier).brainState;
    return AsyncView(
      value: regions,
      onRetry: () => ref.invalidate(brainRegionsProvider),
      data: (map) {
        final list = map.values.toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        return ListView(
          padding: EdgeInsets.only(bottom: bottomPadding),
          children: [
            ListTile(
              leading: const Icon(Symbols.account_tree_rounded),
              title: Text(l.brainCategoriesTile),
              subtitle: Text(l.brainCategoriesBody),
              trailing: const Icon(Symbols.chevron_right_rounded),
              onTap: () => context.push('/brain/categories'),
            ),
            const Divider(),
            for (final r in list)
              () {
                final s = state?.regions[r.key];
                return ListTile(
                  leading: Icon(
                    r.isInner
                        ? Symbols.blur_on_rounded
                        : Symbols.psychology_rounded,
                  ),
                  title: Text(r.name(context)),
                  subtitle: Text(
                    l.regionNeurons(
                      (s?.total ?? 0) ~/ 1000,
                      ((s?.brightness ?? 0) / 10).round(),
                    ),
                  ),
                  trailing: const Icon(Symbols.chevron_right_rounded),
                  onTap: () => context.push('/brain/region/${r.key}'),
                );
              }(),
          ],
        );
      },
    );
  }
}

class BrainListScreen extends StatelessWidget {
  const BrainListScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.brainListTitle)),
    body: const BrainListBody(),
  );
}
