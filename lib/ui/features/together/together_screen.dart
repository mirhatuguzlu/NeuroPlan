import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/remote/auth_service.dart';
import '../../../data/remote/social_api.dart';
import '../../core/app_shell.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'cofocus_controller.dart';
import 'together_providers.dart';
import 'together_widgets.dart';

/// Yalnız doğum yılı tutulur; en düşük olası yaş kullanılır (SOCIAL_SAFETY §5).
int minAgeOf(int birthYear, {DateTime? now}) =>
    (now ?? DateTime.now()).year - birthYear - 1;

/// Birlikte sekmesi: önce kapı (giriş, yaş, takma ad), sonra tek amaçlı ekranlara giriş.
class TogetherScreen extends ConsumerWidget {
  const TogetherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.navTogether)),
      body: const _Gate(),
    );
  }
}

class _Gate extends ConsumerWidget {
  const _Gate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (ref.watch(socialApiProvider) == null) {
      return MessageState(
        icon: Symbols.cloud_off_rounded,
        title: l.tgOfflineTitle,
        body: l.tgOfflineBody,
      );
    }
    final profile = ref.watch(profileProvider).value;
    final user = ref.watch(authUserProvider);
    if (profile == null || user.isLoading) return const SkeletonList();
    if (user.value == null || user.value!.isAnonymous) {
      return const _ConnectGoogle();
    }
    final birthYear = profile.birthYear;
    if (birthYear == null) return const _BirthYear();
    if (minAgeOf(birthYear) < 15) {
      return MessageState(
        icon: Symbols.lock_rounded,
        title: l.tgTooYoungTitle,
        body: l.tgTooYoungBody,
      );
    }
    final status = ref.watch(socialStatusProvider);
    return SocialAsync<SocialStatus?>(
      value: status,
      onRetry: () => ref.invalidate(socialStatusProvider),
      data: (s) {
        if (s == null) return const SkeletonList();
        final until = s.profile?.suspendedUntil;
        if (until != null && until.isAfter(DateTime.now())) {
          return MessageState(
            icon: Symbols.block_rounded,
            title: l.tgSuspendedTitle,
            body: l.tgSuspendedBody(
              MaterialLocalizations.of(context).formatMediumDate(until),
            ),
          );
        }
        if (s.profile == null) return const _Setup();
        return const _Hub();
      },
    );
  }
}

class _ConnectGoogle extends ConsumerWidget {
  const _ConnectGoogle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Gap.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExcludeSemantics(
                child: Icon(
                  Symbols.diversity_3_rounded,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: Gap.l),
              Text(
                l.tgGuestTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Gap.s),
              Text(l.tgGuestBody, textAlign: TextAlign.center),
              const SizedBox(height: Gap.xl),
              BusyButton(
                label: l.tgConnectGoogle,
                onPressed: () => connectGoogle(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Misafir → Google (D17). Var olan hesaba geçilirse yerel veri o hesaba gönderilir.
Future<void> connectGoogle(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  try {
    final r = await ref.read(authServiceProvider).connectGoogle();
    ref.invalidate(socialStatusProvider);
    await ref.read(syncSchedulerProvider)?.syncNow();
    if (!context.mounted) return;
    switch (r) {
      case ConnectResult.linked:
        showSnack(context, l.tgConnected);
      case ConnectResult.switched:
        showSnack(context, l.tgConnectedSwitched);
      case ConnectResult.cancelled:
        break;
    }
  } on Object catch (e) {
    debugPrint('[auth] Google: $e');
    if (context.mounted) showSnack(context, l.tgConnectError);
  }
}

class _BirthYear extends ConsumerStatefulWidget {
  const _BirthYear();

  @override
  ConsumerState<_BirthYear> createState() => _BirthYearState();
}

class _BirthYearState extends ConsumerState<_BirthYear> {
  int? _year;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(Gap.l),
      children: [
        Text(l.tgAgeTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: Gap.s),
        Text(l.tgAgeBody),
        const SizedBox(height: Gap.xl),
        BirthYearField(
          value: _year,
          onChanged: (v) => setState(() => _year = v),
        ),
        const SizedBox(height: Gap.xl),
        BusyButton(
          label: l.commonSave,
          onPressed: _year == null
              ? null
              : () => guard(
                  context,
                  () => ref
                      .read(profileRepositoryProvider)
                      .update(ProfilesCompanion(birthYear: Value(_year))),
                ),
        ),
      ],
    );
  }
}

/// Doğum yılı seçimi; ilk kurulumda ve Birlikte kapısında aynı alan.
class BirthYearField extends StatelessWidget {
  const BirthYearField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().year;
    return DropdownMenu<int>(
      initialSelection: value,
      expandedInsets: EdgeInsets.zero,
      label: Text(context.l10n.tgBirthYear),
      menuHeight: 320,
      onSelected: onChanged,
      dropdownMenuEntries: [
        for (var y = now; y >= now - 100; y--)
          DropdownMenuEntry(value: y, label: '$y'),
      ],
    );
  }
}

class _Setup extends ConsumerStatefulWidget {
  const _Setup();

  @override
  ConsumerState<_Setup> createState() => _SetupState();
}

class _SetupState extends ConsumerState<_Setup> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l = context.l10n;
    final name = _name.text.trim();
    final user = _username.text.trim().toLowerCase();
    if (name.isEmpty) return setState(() => _error = l.tgNameRequired);
    if (user.isNotEmpty && !RegExp(r'^[a-z0-9_]{3,20}$').hasMatch(user)) {
      return setState(() => _error = l.tgUsernameRule);
    }
    setState(() => _error = null);
    final ok = await socialAction(
      context,
      () => ref
          .read(socialApiProvider)!
          .saveProfile(displayName: name, username: user.isEmpty ? null : user),
    );
    if (ok) ref.invalidate(socialStatusProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(Gap.l),
      children: [
        Text(l.tgSetupTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: Gap.s),
        Text(l.tgSetupBody),
        const SizedBox(height: Gap.xl),
        TextField(
          controller: _name,
          maxLength: 40,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l.tgDisplayName,
            errorText: _error,
          ),
        ),
        const SizedBox(height: Gap.m),
        TextField(
          controller: _username,
          maxLength: 20,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_]')),
          ],
          decoration: InputDecoration(
            labelText: l.tgUsernameOptional,
            helperText: l.tgUsernameHelp,
            helperMaxLines: 3,
          ),
        ),
        const SizedBox(height: Gap.l),
        Text(l.tgTermsBody, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: Gap.xl),
        BusyButton(label: l.tgSetupAction, onPressed: _save),
      ],
    );
  }
}

class _Hub extends ConsumerWidget {
  const _Hub();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final friends = ref.watch(friendsProvider);
    final badges = ref.watch(badgesProvider).value ?? const TogetherBadges();
    final cofocus = ref.watch(cofocusControllerProvider);
    return SocialAsync<FriendOverview>(
      value: friends,
      onRetry: () => ref.invalidate(friendsProvider),
      data: (f) {
        if (f.friends.isEmpty && f.incoming.isEmpty) {
          return MessageState(
            icon: Symbols.person_add_rounded,
            title: l.tgEmptyTitle,
            body: l.tgEmptyBody,
            actionLabel: l.tgInviteFirst,
            onAction: () => context.push('/together/invite'),
          );
        }
        Widget tile(
          IconData icon,
          String title,
          String route, {
          String? subtitle,
          int badge = 0,
        }) => ListTile(
          leading: Badge(
            isLabelVisible: badge > 0,
            label: Text('$badge'),
            child: Icon(icon),
          ),
          title: Text(title),
          subtitle: subtitle == null ? null : Text(subtitle),
          trailing: const Icon(Symbols.chevron_right_rounded),
          onTap: () => context.push(route),
        );
        final partner = f.partner;
        final partnerFrom = badges.partnerRequestFrom;
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(friendsProvider);
            ref.invalidate(badgesProvider);
            await ref.read(friendsProvider.future);
          },
          child: ListView(
            padding: EdgeInsets.only(bottom: AppShell.bottomInset(context)),
            children: [
              if (cofocus.active)
                _Banner(
                  text: l.tgCofocusBack,
                  action: l.tgOpen,
                  onAction: () =>
                      context.push('/together/cofocus/${cofocus.id}'),
                ),
              for (final inv in badges.cofocusInvites)
                _Banner(
                  text: l.tgCofocusInvite(inv.hostName),
                  action: l.tgJoin,
                  onAction: () async {
                    final ok = await socialAction(
                      context,
                      () => ref
                          .read(cofocusControllerProvider.notifier)
                          .join(inv.id),
                    );
                    ref.invalidate(badgesProvider);
                    if (ok && context.mounted) {
                      context.push('/together/cofocus/${inv.id}');
                    }
                  },
                  secondary: l.tgDecline,
                  onSecondary: () async {
                    await socialAction(
                      context,
                      () => ref
                          .read(cofocusControllerProvider.notifier)
                          .decline(inv.id),
                    );
                    ref.invalidate(badgesProvider);
                  },
                ),
              if (partnerFrom != null)
                _Banner(
                  text: l.tgPartnerAsked(
                    f.friends
                            .where((x) => x.userId == partnerFrom)
                            .firstOrNull
                            ?.displayName ??
                        '',
                  ),
                  action: l.tgAccept,
                  onAction: () async {
                    await socialAction(
                      context,
                      () => ref
                          .read(socialApiProvider)!
                          .respondPartner(partnerFrom, true),
                      success: l.tgPartnerDone,
                    );
                    ref.invalidate(friendsProvider);
                    ref.invalidate(badgesProvider);
                  },
                  secondary: l.tgDecline,
                  onSecondary: () async {
                    await socialAction(
                      context,
                      () => ref
                          .read(socialApiProvider)!
                          .respondPartner(partnerFrom, false),
                    );
                    ref.invalidate(badgesProvider);
                  },
                ),
              SectionTitle(l.tgSecTogether),
              if (partner != null)
                tile(
                  Symbols.favorite_rounded,
                  l.tgPartnerPlan(partner.displayName),
                  '/together/friend/${partner.userId}/plan',
                )
              else
                tile(
                  Symbols.favorite_rounded,
                  l.tgChoosePartner,
                  '/together/friends',
                  subtitle: l.tgChoosePartnerBody,
                ),
              tile(
                Symbols.timer_rounded,
                l.tgCofocusNew,
                '/together/cofocus/new',
                subtitle: l.tgCofocusNewBody,
              ),
              tile(
                Symbols.event_upcoming_rounded,
                l.tgShared,
                '/together/shared',
                badge: badges.sharedInvites + badges.sharedChanges,
              ),
              tile(
                Symbols.hourglass_empty_rounded,
                l.tgFreeTime,
                '/together/free-time',
              ),
              SectionTitle(l.tgSecPeople),
              tile(
                Symbols.chat_rounded,
                l.tgMessages,
                '/together/messages',
                badge: badges.unread,
              ),
              tile(
                Symbols.group_rounded,
                l.tgFriends,
                '/together/friends',
                badge: badges.friendRequests,
              ),
              tile(Symbols.person_add_rounded, l.tgInvite, '/together/invite'),
              tile(
                Symbols.leaderboard_rounded,
                l.tgLeaderboard,
                '/together/leaderboard',
              ),
              SectionTitle(l.tgSecPrivacy),
              tile(
                Symbols.lock_rounded,
                l.tgPrivacy,
                '/together/privacy',
                subtitle: l.tgPrivacyBody,
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Bekleyen bir karar (satır içi, pop-up değil; UX §3).
class _Banner extends StatelessWidget {
  const _Banner({
    required this.text,
    required this.action,
    required this.onAction,
    this.secondary,
    this.onSecondary,
  });

  final String text;
  final String action;
  final Future<void> Function()? onAction;
  final String? secondary;
  final Future<void> Function()? onSecondary;

  @override
  Widget build(BuildContext context) => Card.filled(
    margin: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.l, 0),
    child: Padding(
      padding: const EdgeInsets.all(Gap.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(liveRegion: true, child: Text(text)),
          const SizedBox(height: Gap.m),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: Gap.s,
            children: [
              if (secondary != null)
                TextButton(onPressed: onSecondary, child: Text(secondary!)),
              BusyButton(label: action, onPressed: onAction),
            ],
          ),
        ],
      ),
    ),
  );
}
