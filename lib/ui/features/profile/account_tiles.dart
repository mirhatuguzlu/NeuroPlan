import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../data/remote/auth_service.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../together/together_providers.dart' show pushProvider;
import '../together/together_screen.dart' show connectGoogle;
import '../together/together_widgets.dart';

/// Hesap: misafir / Google, Google ile bağlan, hesabı ve tüm verileri sil (AUTH-3).
class AccountTiles extends ConsumerWidget {
  const AccountTiles({super.key});

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    if (!await confirmAction(
      context,
      title: l.accountDeleteTitle,
      body: l.accountDeleteBody,
      confirm: l.accountDeleteAction,
    )) {
      return;
    }
    final auth = ref.read(authServiceProvider);
    try {
      if (auth.user != null) {
        await auth.deleteAccount();
        await ref.read(pushProvider).forget();
      }
      final db = ref.read(databaseProvider);
      final tz =
          (await ref.read(profileRepositoryProvider).get())?.timezone ?? 'UTC';
      await db.wipeUserData();
      await ref.read(profileRepositoryProvider).ensure(timezone: tz);
      await auth.ensureGuest();
      if (context.mounted) context.go('/onboarding');
    } on Object catch (e) {
      debugPrint('[account] silme: $e');
      if (context.mounted) showSnack(context, l.accountDeleteError);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final auth = ref.watch(authServiceProvider);
    final user = ref.watch(authUserProvider).value;
    final kind = user == null ? AccountKind.none : auth.kind;
    return Column(
      children: [
        ListTile(
          leading: const Icon(Symbols.account_circle_rounded),
          title: Text(switch (kind) {
            AccountKind.google => l.accountGoogle,
            AccountKind.guest => l.accountGuest,
            AccountKind.none => l.accountDeviceOnly,
          }),
          subtitle: Text(switch (kind) {
            AccountKind.google => user?.email ?? '',
            AccountKind.guest => l.accountGuestBody,
            AccountKind.none =>
              auth.available ? l.accountOffline : l.accountDeviceOnlyBody,
          }),
        ),
        if (kind == AccountKind.guest)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BusyButton(
              tonal: true,
              label: l.tgConnectGoogle,
              onPressed: () => connectGoogle(context, ref),
            ),
          ),
        ListTile(
          leading: const Icon(Symbols.delete_forever_rounded),
          title: Text(l.accountDeleteTitle),
          subtitle: Text(l.accountDeleteSubtitle),
          onTap: () => _delete(context, ref),
        ),
      ],
    );
  }
}
