import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import 'format.dart';

/// Yükleniyor / hata / veri durumlarını tek yerde çizer (UX_RULES §4).
class AsyncView<T> extends StatelessWidget {
  const AsyncView({
    super.key,
    required this.value,
    required this.data,
    required this.onRetry,
    this.skeletonRows = 6,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback onRetry;
  final int skeletonRows;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncData(:final value) => data(value),
    AsyncError() => ErrorState(onRetry: onRetry),
    _ => SkeletonList(rows: skeletonRows),
  };
}

/// Sabit yükseklikli iskelet: içerik gelince düzen kaymaz.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.rows = 6});

  final int rows;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Semantics(
      label: context.l10n.commonLoading,
      liveRegion: true,
      child: ExcludeSemantics(
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(Gap.l),
          itemCount: rows,
          separatorBuilder: (_, _) => const SizedBox(height: Gap.m),
          itemBuilder: (_, i) => Container(
            height: i == 0 ? 96 : 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppTokens.of(context).radius),
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => MessageState(
    icon: Symbols.warning_rounded,
    title: context.l10n.errorTitle,
    body: context.l10n.errorBody,
    actionLabel: context.l10n.commonRetry,
    onAction: onRetry,
  );
}

/// Boş / hata durumu: ne olduğunu anlatan cümle + tek birincil eylem.
class MessageState extends StatelessWidget {
  const MessageState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Gap.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(icon, size: 48, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: Gap.l),
              Text(
                title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Gap.s),
              Text(
                body,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null) ...[
                const SizedBox(height: Gap.xl),
                FilledButton(onPressed: onAction, child: Text(actionLabel!)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Basınca kendini kilitleyen, genişliği sabit buton: çift dokunma ve kaybolan geri
/// bildirim olmaz (UX_RULES §4).
class BusyButton extends StatefulWidget {
  const BusyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.tonal = false,
  });

  final String label;
  final Future<void> Function()? onPressed;
  final bool tonal;

  @override
  State<BusyButton> createState() => _BusyButtonState();
}

class _BusyButtonState extends State<BusyButton> {
  var _busy = false;

  Future<void> _run() async {
    setState(() => _busy = true);
    try {
      await widget.onPressed!();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = Stack(
      alignment: Alignment.center,
      children: [
        Opacity(opacity: _busy ? 0 : 1, child: Text(widget.label)),
        if (_busy)
          SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              semanticsLabel: context.l10n.commonLoading,
            ),
          ),
      ],
    );
    final onPressed = widget.onPressed == null || _busy ? null : _run;
    return widget.tonal
        ? FilledButton.tonal(onPressed: onPressed, child: child)
        : FilledButton(onPressed: onPressed, child: child);
  }
}

void showSnack(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        action: actionLabel == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: onAction!),
      ),
    );
}

/// Kaydetme hatası kullanıcıya anlaşılır biçimde gösterilir; veri kaybolmaz.
Future<bool> guard(BuildContext context, Future<void> Function() action) async {
  try {
    await action();
    return true;
  } catch (e, st) {
    debugPrint('Kaydetme hatası: $e\n$st');
    if (context.mounted) showSnack(context, context.l10n.saveError);
    return false;
  }
}
