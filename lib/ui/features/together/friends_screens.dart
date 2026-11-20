import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/feature_flags.dart';
import '../../../app/theme.dart';
import '../../../data/remote/social_api.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../brain/brain_controller.dart';
import 'together_providers.dart';
import 'together_widgets.dart';

void _refreshFriends(WidgetRef ref) {
  ref.invalidate(friendsProvider);
  ref.invalidate(badgesProvider);
}

/// Arkadaşlar: gelen ve giden istekler, arkadaş listesi, engellenenler.
class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final api = ref.watch(socialApiProvider)!;
    return Scaffold(
      appBar: AppBar(title: Text(l.tgFriends)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/together/invite'),
        icon: const Icon(Symbols.person_add_rounded),
        label: Text(l.tgInvite),
      ),
      body: SocialAsync<FriendOverview>(
        value: ref.watch(friendsProvider),
        onRetry: () => ref.invalidate(friendsProvider),
        data: (f) {
          if (f.friends.isEmpty &&
              f.incoming.isEmpty &&
              f.outgoing.isEmpty &&
              f.blocked.isEmpty) {
            return MessageState(
              icon: Symbols.group_rounded,
              title: l.tgEmptyTitle,
              body: l.tgEmptyBody,
              actionLabel: l.tgInviteFirst,
              onAction: () => context.push('/together/invite'),
            );
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              if (f.incoming.isNotEmpty) SectionTitle(l.tgIncoming),
              for (final r in f.incoming)
                ListTile(
                  leading: Initials(r.displayName),
                  title: Text(r.displayName),
                  subtitle: Text(l.tgWantsToBeFriends),
                  trailing: Wrap(
                    spacing: Gap.xs,
                    children: [
                      TextButton(
                        onPressed: () async {
                          await socialAction(
                            context,
                            () => api.respondFriend(r.friendshipId, false),
                          );
                          _refreshFriends(ref);
                        },
                        child: Text(l.tgDecline),
                      ),
                      FilledButton.tonal(
                        onPressed: () async {
                          await socialAction(
                            context,
                            () => api.respondFriend(r.friendshipId, true),
                          );
                          _refreshFriends(ref);
                        },
                        child: Text(l.tgAccept),
                      ),
                    ],
                  ),
                ),
              if (f.friends.isNotEmpty) SectionTitle(l.tgFriends),
              for (final fr in f.friends)
                ListTile(
                  leading: Initials(fr.displayName, highlight: fr.isPartner),
                  title: Text(fr.displayName),
                  subtitle: fr.isPartner
                      ? Text(l.tgPartner)
                      : fr.partnerRequestedBy != null
                      ? Text(l.tgPartnerPending)
                      : null,
                  trailing: const Icon(Symbols.chevron_right_rounded),
                  onTap: () => context.push('/together/friend/${fr.userId}'),
                ),
              if (f.outgoing.isNotEmpty) SectionTitle(l.tgOutgoing),
              for (final r in f.outgoing)
                ListTile(
                  leading: Initials(r.displayName),
                  title: Text(r.displayName),
                  subtitle: Text(l.tgRequestSent),
                  trailing: TextButton(
                    onPressed: () async {
                      await socialAction(
                        context,
                        () => api.removeFriend(r.userId),
                      );
                      _refreshFriends(ref);
                    },
                    child: Text(l.tgWithdraw),
                  ),
                ),
              if (f.blocked.isNotEmpty) SectionTitle(l.tgBlocked),
              for (final b in f.blocked)
                ListTile(
                  leading: const Icon(Symbols.block_rounded),
                  title: Text(b.displayName),
                  trailing: TextButton(
                    onPressed: () async {
                      await socialAction(
                        context,
                        () => api.unblock(b.userId),
                        success: l.tgUnblocked,
                      );
                      _refreshFriends(ref);
                    },
                    child: Text(l.tgUnblock),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Tek arkadaşla ilgili her şey: mesaj, plan, beyin, partner, istisna, çıkar, engelle, şikâyet.
class FriendScreen extends ConsumerWidget {
  const FriendScreen({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final api = ref.watch(socialApiProvider)!;
    return SocialAsync<FriendOverview>(
      value: ref.watch(friendsProvider),
      onRetry: () => ref.invalidate(friendsProvider),
      data: (o) {
        final f = o.friends.where((x) => x.userId == userId).firstOrNull;
        if (f == null) {
          return Scaffold(
            appBar: AppBar(),
            body: MessageState(
              icon: Symbols.person_remove_rounded,
              title: l.tgNotFriendTitle,
              body: l.tgNotFriendBody,
            ),
          );
        }
        final iAsked =
            f.partnerRequestedBy != null && f.partnerRequestedBy != userId;
        final theyAsked = f.partnerRequestedBy == userId;
        final hasOtherPartner =
            o.partner != null && o.partner!.userId != userId;
        final rules = ref.watch(visibilityRulesProvider).value ?? const [];
        final fullForThem = rules.any(
          (r) =>
              r['viewer_id'] == userId &&
              r['category_id'] == null &&
              r['root_category_key'] == null &&
              r['level'] == 'full',
        );
        return Scaffold(
          appBar: AppBar(title: Text(f.displayName)),
          body: ListView(
            children: [
              if (f.username != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, 0),
                  child: Text('@${f.username}'),
                ),
              ListTile(
                leading: const Icon(Symbols.chat_rounded),
                title: Text(l.tgSendMessage),
                onTap: () async {
                  try {
                    final id = await api.openDirect(userId);
                    if (context.mounted) {
                      context.push(
                        '/together/chat/$id?name=${Uri.encodeComponent(f.displayName)}&friend=$userId',
                      );
                    }
                  } on Object catch (e) {
                    if (context.mounted) {
                      showSnack(context, socialErrorText(l, e));
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Symbols.calendar_month_rounded),
                title: Text(l.tgSeePlan),
                onTap: () => context.push('/together/friend/$userId/plan'),
              ),
              if (featureOn(ref, Feature.brainCompare))
                ListTile(
                  leading: const Icon(Symbols.compare_arrows_rounded),
                  title: Text(l.tgCompareBrains),
                  onTap: () {
                    ref
                        .read(brainControllerProvider.notifier)
                        .startCompare(userId, f.displayName);
                    context.go('/brain');
                  },
                ),
              SectionTitle(l.tgPartner),
              if (f.isPartner)
                ListTile(
                  leading: const Icon(Symbols.heart_broken_rounded),
                  title: Text(l.tgEndPartner),
                  subtitle: Text(l.tgEndPartnerBody),
                  onTap: () async {
                    if (!await confirmAction(
                      context,
                      title: l.tgEndPartner,
                      body: l.tgEndPartnerBody,
                      confirm: l.tgEndPartner,
                    )) {
                      return;
                    }
                    if (!context.mounted) return;
                    await socialAction(context, () => api.endPartner(userId));
                    _refreshFriends(ref);
                  },
                )
              else if (theyAsked)
                ListTile(
                  leading: const Icon(Symbols.favorite_rounded),
                  title: Text(l.tgPartnerAsked(f.displayName)),
                  trailing: FilledButton.tonal(
                    onPressed: () async {
                      await socialAction(
                        context,
                        () => api.respondPartner(userId, true),
                        success: l.tgPartnerDone,
                      );
                      _refreshFriends(ref);
                    },
                    child: Text(l.tgAccept),
                  ),
                )
              else if (iAsked)
                ListTile(
                  leading: const Icon(Symbols.favorite_rounded),
                  title: Text(l.tgPartnerPending),
                )
              else
                ListTile(
                  leading: const Icon(Symbols.favorite_rounded),
                  title: Text(l.tgAskPartner),
                  subtitle: Text(
                    hasOtherPartner
                        ? l.tgAskPartnerBlocked
                        : l.tgAskPartnerBody,
                  ),
                  enabled: !hasOtherPartner,
                  onTap: () async {
                    await socialAction(
                      context,
                      () => api.requestPartner(userId),
                      success: l.tgPartnerRequested,
                    );
                    _refreshFriends(ref);
                  },
                ),
              SwitchListTile(
                secondary: const Icon(Symbols.visibility_rounded),
                title: Text(l.tgShowFull),
                subtitle: Text(l.tgShowFullBody),
                value: fullForThem,
                onChanged: (v) async {
                  await socialAction(
                    context,
                    () => api.setVisibility(
                      level: v ? 'full' : null,
                      viewerId: userId,
                    ),
                  );
                  ref.invalidate(visibilityRulesProvider);
                },
              ),
              SectionTitle(l.tgSafety),
              ListTile(
                leading: const Icon(Symbols.person_remove_rounded),
                title: Text(l.tgRemoveFriend),
                onTap: () async {
                  if (!await confirmAction(
                    context,
                    title: l.tgRemoveFriend,
                    body: l.tgRemoveFriendBody(f.displayName),
                    confirm: l.tgRemoveFriend,
                  )) {
                    return;
                  }
                  if (!context.mounted) return;
                  if (await socialAction(
                    context,
                    () => api.removeFriend(userId),
                  )) {
                    _refreshFriends(ref);
                    if (context.mounted) context.pop();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Symbols.block_rounded),
                title: Text(l.tgBlock),
                onTap: () => blockUser(context, ref, userId, f.displayName),
              ),
              ListTile(
                leading: const Icon(Symbols.report_rounded),
                title: Text(l.tgReport),
                onTap: () =>
                    context.push('/together/report?type=user&user=$userId'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Engelle: onay ister; engel arkadaşlığı, partnerliği ve sohbeti keser.
Future<void> blockUser(
  BuildContext context,
  WidgetRef ref,
  String userId,
  String name,
) async {
  final l = context.l10n;
  if (!await confirmAction(
    context,
    title: l.tgBlockTitle(name),
    body: l.tgBlockBody,
    confirm: l.tgBlock,
  )) {
    return;
  }
  if (!context.mounted) return;
  if (await socialAction(
    context,
    () => ref.read(socialApiProvider)!.block(userId),
    success: l.tgBlocked1,
  )) {
    _refreshFriends(ref);
    ref.invalidate(conversationsProvider);
    if (context.mounted) context.go('/together');
  }
}

/// Davet: kod ve QR oluştur, kod kullan (yaz ya da tara), tam kullanıcı adıyla istek.
class InviteScreen extends ConsumerStatefulWidget {
  const InviteScreen({super.key});

  @override
  ConsumerState<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends ConsumerState<InviteScreen> {
  final _code = TextEditingController();
  final _username = TextEditingController();
  var _kind = 'friend';

  @override
  void dispose() {
    _code.dispose();
    _username.dispose();
    super.dispose();
  }

  Future<void> _redeem() async {
    final l = context.l10n;
    final code = _code.text.trim().toUpperCase();
    if (code.length != 10) return showSnack(context, l.tgCodeRule);
    try {
      final r = await ref.read(socialApiProvider)!.redeemInvite(code);
      _code.clear();
      _refreshFriends(ref);
      if (mounted) {
        showSnack(
          context,
          r.partner ? l.tgRedeemedPartner(r.name) : l.tgRedeemed(r.name),
        );
      }
    } on Object catch (e) {
      if (mounted) showSnack(context, socialErrorText(l, e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final api = ref.watch(socialApiProvider)!;
    final invites =
        ref.watch(friendsProvider).value?.invites ?? const <Invite>[];
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.tgInvite)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.l),
        children: [
          Text(l.tgInviteTitle, style: theme.textTheme.titleMedium),
          const SizedBox(height: Gap.xs),
          Text(l.tgInviteBody),
          const SizedBox(height: Gap.m),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'friend', label: Text(l.tgKindFriend)),
              ButtonSegment(value: 'partner', label: Text(l.tgKindPartner)),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.first),
          ),
          const SizedBox(height: Gap.m),
          BusyButton(
            label: l.tgCreateCode,
            onPressed: () async {
              await socialAction(context, () => api.createInvite(_kind));
              ref.invalidate(friendsProvider);
            },
          ),
          for (final i in invites) _InviteCard(invite: i),
          const Divider(height: Gap.xxl * 2),
          Text(l.tgHaveCode, style: theme.textTheme.titleMedium),
          const SizedBox(height: Gap.m),
          TextField(
            controller: _code,
            maxLength: 10,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]')),
            ],
            decoration: InputDecoration(
              labelText: l.tgCode,
              suffixIcon: IconButton(
                tooltip: l.tgScan,
                icon: const Icon(Symbols.qr_code_scanner_rounded),
                onPressed: () async {
                  final code = await context.push<String>('/together/scan');
                  if (code != null) {
                    _code.text = code;
                    await _redeem();
                  }
                },
              ),
            ),
          ),
          BusyButton(label: l.tgUseCode, tonal: true, onPressed: _redeem),
          const Divider(height: Gap.xxl * 2),
          Text(l.tgByUsername, style: theme.textTheme.titleMedium),
          const SizedBox(height: Gap.xs),
          Text(l.tgByUsernameBody),
          const SizedBox(height: Gap.m),
          TextField(
            controller: _username,
            maxLength: 20,
            decoration: InputDecoration(
              labelText: l.tgUsername,
              prefixText: '@',
            ),
          ),
          BusyButton(
            label: l.tgSendRequest,
            tonal: true,
            onPressed: () async {
              final u = _username.text.trim();
              if (u.isEmpty) return;
              if (await socialAction(
                context,
                () => api.requestFriend(u),
                success: l.tgRequestSent,
              )) {
                _username.clear();
                _refreshFriends(ref);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _InviteCard extends ConsumerWidget {
  const _InviteCard({required this.invite});
  final Invite invite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card.outlined(
      margin: const EdgeInsets.only(top: Gap.l),
      child: Padding(
        padding: const EdgeInsets.all(Gap.l),
        child: Column(
          children: [
            Text(
              invite.kind == 'partner' ? l.tgKindPartner : l.tgKindFriend,
              style: theme.textTheme.labelLarge,
            ),
            const SizedBox(height: Gap.s),
            // QR koyu modülü her temada beyaz zeminde: okuyucular ters renkte zorlanır.
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(Gap.s),
              child: Semantics(
                label: l.tgQrLabel(invite.code),
                child: QrImageView(
                  data: invite.code,
                  size: 180,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: Gap.m),
            SelectableText(
              invite.code,
              style: theme.textTheme.headlineSmall?.copyWith(
                letterSpacing: 4,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              l.tgExpires(
                MaterialLocalizations.of(context)
                    .formatMediumDate(invite.expiresAt),
              ),
            ),
            const SizedBox(height: Gap.s),
            Wrap(
              spacing: Gap.s,
              children: [
                TextButton.icon(
                  icon: const Icon(Symbols.content_copy_rounded),
                  label: Text(l.tgCopy),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: invite.code));
                    if (context.mounted) showSnack(context, l.tgCopied);
                  },
                ),
                TextButton(
                  onPressed: () async {
                    await socialAction(
                      context,
                      () =>
                          ref.read(socialApiProvider)!.revokeInvite(invite.id),
                    );
                    ref.invalidate(friendsProvider);
                  },
                  child: Text(l.tgRevoke),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Davet QR kodunu okur; yalnız 10 karakterlik davet kodunu kabul eder.
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  var _done = false;
  static final _pattern = RegExp(r'^[A-HJ-KM-NP-Z2-9]{10}$');

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.tgScan)),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                if (_done) return;
                for (final b in capture.barcodes) {
                  final v = b.rawValue?.trim().toUpperCase();
                  if (v != null && _pattern.hasMatch(v)) {
                    _done = true;
                    context.pop(v);
                    return;
                  }
                }
              },
              errorBuilder: (context, error) => MessageState(
                icon: Symbols.no_photography_rounded,
                title: l.tgCameraTitle,
                body: l.tgCameraBody,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Gap.l),
            child: Text(l.tgScanHint),
          ),
        ],
      ),
    );
  }
}
