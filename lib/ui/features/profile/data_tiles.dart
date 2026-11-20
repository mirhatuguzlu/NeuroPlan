import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/share.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../stats/stats_providers.dart';

/// Verileri dışa aktar: eşitlenen bütün tablolar tek JSON, cihazda üretilir (DB_SCHEMA §6.4)
/// ve sistem paylaşım menüsüyle verilir.
class ExportTile extends ConsumerStatefulWidget {
  const ExportTile({super.key});

  @override
  ConsumerState<ExportTile> createState() => _ExportTileState();
}

class _ExportTileState extends ConsumerState<ExportTile> {
  bool _busy = false;

  Future<void> _export() async {
    final l = context.l10n;
    setState(() => _busy = true);
    try {
      final now = DateTime.now();
      final json = await ref.read(statsRepositoryProvider).exportJson(now);
      await shareFile(
        utf8.encode(json),
        'neuroplan-${now.toIso8601String().substring(0, 10)}.json',
        'application/json',
      );
    } on Object catch (e) {
      debugPrint('[export] $e');
      if (mounted) showSnack(context, l.exportError(context.tone));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListTile(
      leading: const Icon(Symbols.download_rounded),
      title: Text(l.exportTitle),
      subtitle: Text(l.exportSubtitle),
      trailing: _busy
          ? SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(semanticsLabel: l.stLoading),
            )
          : null,
      onTap: _busy ? null : _export,
    );
  }
}
