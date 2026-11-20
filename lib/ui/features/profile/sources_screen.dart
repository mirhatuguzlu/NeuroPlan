import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../core/format.dart';
import '../../core/states.dart';

typedef Source = ({String id, String citation, String url, String ref});

/// docs/SCIENCE.md §5'in kopyası (`assets/seed/sources.json`); kaynak künyesi çevrilmez.
final sourcesProvider = FutureProvider<List<Source>>((ref) async {
  final j = jsonDecode(
    await rootBundle.loadString('assets/seed/sources.json'),
  ) as Map;
  return [
    for (final s in (j['sources'] as List).cast<Map>())
      (
        id: s['id'] as String,
        citation: s['citation'] as String,
        url: s['url'] as String,
        ref: s['ref'] as String,
      ),
  ];
});

/// Bilimsel kaynaklar: uygulamadaki her bilimsel ifadenin dayandığı liste (CLAUDE.md kural 5).
class SourcesScreen extends ConsumerWidget {
  const SourcesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.sourcesTitle)),
      body: AsyncView<List<Source>>(
        value: ref.watch(sourcesProvider),
        onRetry: () => ref.invalidate(sourcesProvider),
        data: (list) => ListView(
          padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, Gap.xxl),
          children: [
            Text(l.sourcesIntro, style: theme.textTheme.bodyLarge),
            const SizedBox(height: Gap.m),
            Text(l.regionMetaphor, style: theme.textTheme.bodyMedium),
            const SizedBox(height: Gap.l),
            for (final s in list)
              MergeSemantics(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Text(s.id, style: theme.textTheme.labelLarge),
                  title: Text(s.citation),
                  subtitle: Text(s.ref),
                  trailing: IconButton(
                    tooltip: l.sourcesCopy,
                    icon: const Icon(Symbols.content_copy_rounded),
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: s.url));
                      if (context.mounted) showSnack(context, l.tgCopied);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
