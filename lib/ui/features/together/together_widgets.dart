import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../data/remote/social_api.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/format.dart';
import '../../core/states.dart';

/// Sunucu hatasının kullanıcı metni; ne olduğunu ve ne yapılabileceğini söyler (UX §4).
String socialErrorText(L10n l, Object e) {
  final s = e is SocialException ? e : SocialException.from(e);
  return switch (s.kind) {
    SocialError.rateLimited => l.tgErrRate,
    SocialError.network => l.tgErrNetwork,
    SocialError.notFound => l.tgErrNotFound,
    SocialError.forbidden => l.tgErrForbidden,
    SocialError.notPublished => l.tgErrNotPublished,
    SocialError.notEligible => l.tgErrNotEligible,
    SocialError.conflict when s.detail.contains('username_taken') =>
      l.tgErrUsernameTaken,
    SocialError.conflict when s.detail.contains('partner_taken') =>
      l.tgErrPartnerTaken,
    SocialError.conflict => l.tgErrAlready,
    SocialError.invalid => l.tgErrInvalid,
    SocialError.unknown => l.errorBody,
  };
}

/// Sunucu eylemi: yükleniyor butonda, hata SnackBar'da; başarı mesajı isteğe bağlı.
Future<bool> socialAction(
  BuildContext context,
  Future<void> Function() action, {
  String? success,
}) async {
  try {
    await action();
    if (success != null && context.mounted) showSnack(context, success);
    return true;
  } on Object catch (e) {
    if (context.mounted) showSnack(context, socialErrorText(context.l10n, e));
    return false;
  }
}

/// Liste ekranlarının ortak durumu: yükleniyor iskeleti, hata + Tekrar dene.
class SocialAsync<T> extends StatelessWidget {
  const SocialAsync({
    super.key,
    required this.value,
    required this.onRetry,
    required this.data,
  });

  final AsyncValue<T> value;
  final VoidCallback onRetry;
  final Widget Function(T data) data;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncData(:final value) => data(value),
    AsyncError(:final error) => MessageState(
      icon: Symbols.warning_rounded,
      title: context.l10n.errorTitle,
      body: socialErrorText(context.l10n, error),
      actionLabel: context.l10n.commonRetry,
      onAction: onRetry,
    ),
    _ => const SkeletonList(),
  };
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.s),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    ),
  );
}

/// Baş harf rozeti (fotoğraf yok, ilk sürümde dosya paylaşımı yok).
class Initials extends StatelessWidget {
  const Initials(this.name, {super.key, this.highlight = false});
  final String name;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = name.trim();
    return ExcludeSemantics(
      child: CircleAvatar(
        backgroundColor: highlight ? scheme.primary : scheme.secondaryContainer,
        foregroundColor: highlight
            ? scheme.onPrimary
            : scheme.onSecondaryContainer,
        child: Text(t.isEmpty ? '?' : t.characters.first.toUpperCase()),
      ),
    );
  }
}

/// İki seçenekli, akışı durduran karar (UX §3: geri alınamayan eylemin onayı).
Future<bool> confirmAction(
  BuildContext context, {
  required String title,
  required String body,
  required String confirm,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(c.l10n.tgCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(confirm),
          ),
        ],
      ),
    ) ??
    false;

/// Arkadaş seçimi (ortak odak, ortak etkinlik, boş zaman). [max] aşılınca seçim kapanır.
class FriendPicker extends StatelessWidget {
  const FriendPicker({
    super.key,
    required this.friends,
    required this.selected,
    required this.onChanged,
    this.max,
  });

  final List<Friend> friends;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final int? max;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Sınır dolunca kalan satırlar kapanır; nedeni görünür (UX §4).
      if (max != null) Text(context.l10n.tgPickMax(max!)),
      for (final f in friends)
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Initials(f.displayName, highlight: f.isPartner),
          title: Text(f.displayName),
          subtitle: f.isPartner ? Text(context.l10n.tgPartner) : null,
          value: selected.contains(f.userId),
          onChanged:
              !selected.contains(f.userId) &&
                  max != null &&
                  selected.length >= max!
              ? null
              : (v) => onChanged(
                  v == true
                      ? {...selected, f.userId}
                      : ({...selected}..remove(f.userId)),
                ),
        ),
    ],
  );
}

/// Görünürlük düzeyinin adı.
String levelText(L10n l, String? level) => switch (level) {
  'full' => l.tgLevelFull,
  'title_time' => l.tgLevelTitleTime,
  'busy' => l.tgLevelBusy,
  'hidden' => l.tgLevelHidden,
  _ => l.tgLevelDefault,
};

String timeRangeText(BuildContext context, DateTime a, DateTime b) =>
    context.l10n.timeRange(
      TimeOfDay.fromDateTime(a).format(context),
      TimeOfDay.fromDateTime(b).format(context),
    );
