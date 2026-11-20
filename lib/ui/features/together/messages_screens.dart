import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../data/remote/social_api.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'friends_screens.dart';
import 'together_providers.dart';
import 'together_widgets.dart';

/// Sunucudaki CHECK ile aynı küçük küme (fotoğraf/dosya yok, ilk sürüm).
const reactionEmojis = ['👍', '❤️', '😂', '🎉', '🔥', '💪'];

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.tgMessages)),
      body: SocialAsync<List<ConversationSummary>>(
        value: ref.watch(conversationsProvider),
        onRetry: () => ref.invalidate(conversationsProvider),
        data: (list) {
          if (list.isEmpty) {
            return MessageState(
              icon: Symbols.chat_rounded,
              title: l.tgNoMessagesTitle,
              body: l.tgNoMessagesBody,
              actionLabel: l.tgFriends,
              onAction: () => context.push('/together/friends'),
            );
          }
          return ListView(
            children: [
              for (final c in list)
                ListTile(
                  leading: Badge(
                    isLabelVisible: c.unread > 0,
                    label: Text('${c.unread}'),
                    child: Initials(c.displayName),
                  ),
                  title: Text(c.displayName),
                  subtitle: Text(
                    c.lastBody == null
                        ? l.tgNoMessagesYet
                        : c.lastDeleted
                        ? l.tgMessageDeleted
                        : '${c.lastMine ? '${l.tgYou}: ' : ''}${c.lastBody}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: c.muted
                      ? Icon(
                          Symbols.notifications_off_rounded,
                          semanticLabel: l.tgMuted,
                        )
                      : null,
                  onTap: () => context.push(
                    '/together/chat/${c.id}?name=${Uri.encodeComponent(c.displayName)}&friend=${c.friendId}',
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// Birebir sohbet: yazılı mesaj + hazır tepkiler; şikâyet ve engel her zaman erişilebilir.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.name,
    required this.friendId,
  });

  final String conversationId;
  final String name;
  final String friendId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  var _sending = false;

  @override
  void initState() {
    super.initState();
    ref.read(socialApiProvider)?.markRead(widget.conversationId).ignore();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final ok = await socialAction(
      context,
      () =>
          ref.read(socialApiProvider)!.sendMessage(widget.conversationId, text),
    );
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      _input.clear();
      ref.invalidate(chatProvider(widget.conversationId));
      ref.invalidate(conversationsProvider);
    }
  }

  Future<void> _messageActions(ChatMessage m, bool mine) async {
    final l = context.l10n;
    final api = ref.read(socialApiProvider)!;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.l),
              child: Wrap(
                spacing: Gap.s,
                children: [
                  for (final e in reactionEmojis)
                    IconButton(
                      tooltip: l.tgReactWith(e),
                      onPressed: () => Navigator.pop(c, 'react:$e'),
                      icon: Text(e, style: const TextStyle(fontSize: 24)),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Symbols.content_copy_rounded),
              title: Text(l.tgCopy),
              onTap: () => Navigator.pop(c, 'copy'),
            ),
            if (mine)
              ListTile(
                leading: const Icon(Symbols.delete_rounded),
                title: Text(l.commonDelete),
                onTap: () => Navigator.pop(c, 'delete'),
              )
            else
              ListTile(
                leading: const Icon(Symbols.report_rounded),
                title: Text(l.tgReportMessage),
                onTap: () => Navigator.pop(c, 'report'),
              ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    switch (action) {
      case 'copy':
        await Clipboard.setData(ClipboardData(text: m.body));
        if (mounted) showSnack(context, l.tgCopied);
      case 'delete':
        await socialAction(context, () => api.deleteMessage(m.id));
      case 'report':
        context.push(
          '/together/report?type=message&target=${m.id}&user=${widget.friendId}',
        );
      default:
        await socialAction(
          context,
          () => api.toggleReaction(m.id, action.substring(6)),
        );
    }
    ref.invalidate(chatProvider(widget.conversationId));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final me = ref.watch(socialApiProvider)?.myId;
    final muted =
        ref
            .watch(conversationsProvider)
            .value
            ?.where((c) => c.id == widget.conversationId)
            .firstOrNull
            ?.muted ??
        false;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          PopupMenuButton<String>(
            tooltip: l.tgMore,
            onSelected: (v) async {
              switch (v) {
                case 'mute':
                  await socialAction(
                    context,
                    () => ref
                        .read(socialApiProvider)!
                        .setMuted(widget.conversationId, !muted),
                  );
                  ref.invalidate(conversationsProvider);
                case 'report':
                  context.push(
                    '/together/report?type=user&user=${widget.friendId}',
                  );
                case 'block':
                  await blockUser(context, ref, widget.friendId, widget.name);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'mute',
                child: Text(muted ? l.tgUnmute : l.tgMute),
              ),
              PopupMenuItem(value: 'report', child: Text(l.tgReport)),
              PopupMenuItem(value: 'block', child: Text(l.tgBlock)),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SocialAsync<List<ChatMessage>>(
              value: ref.watch(chatProvider(widget.conversationId)),
              onRetry: () =>
                  ref.invalidate(chatProvider(widget.conversationId)),
              data: (messages) {
                if (messages.isEmpty) {
                  return MessageState(
                    icon: Symbols.chat_rounded,
                    title: l.tgChatEmptyTitle(widget.name),
                    body: l.tgChatEmptyBody,
                  );
                }
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(Gap.m),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final m = messages[messages.length - 1 - i];
                    final mine = m.userId == me;
                    final counts = <String, int>{};
                    for (final (e, _) in m.reactions) {
                      counts[e] = (counts[e] ?? 0) + 1;
                    }
                    return Align(
                      alignment: mine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
                        ),
                        // Dokunma da açar: uzun basma tek başına keşfedilmez (D56 denetimi).
                        child: GestureDetector(
                          onTap: m.deleted
                              ? null
                              : () => _messageActions(m, mine),
                          onLongPress: m.deleted
                              ? null
                              : () => _messageActions(m, mine),
                          child: Semantics(
                            label:
                                '${mine ? l.tgYou : widget.name}: ${m.deleted ? l.tgMessageDeleted : m.body}',
                            hint: m.deleted ? null : l.tgMessageHint,
                            excludeSemantics: true,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: Gap.xs,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: Gap.m,
                                vertical: Gap.s,
                              ),
                              decoration: BoxDecoration(
                                color: mine
                                    ? scheme.primaryContainer
                                    : scheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(
                                  AppTokens.of(context).radius,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.deleted ? l.tgMessageDeleted : m.body,
                                    style: m.deleted
                                        ? const TextStyle(
                                            fontStyle: FontStyle.italic,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: Gap.xs),
                                  Text(
                                    DateFormat.Hm(context.localeName)
                                        .format(m.createdAt),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall,
                                  ),
                                  if (counts.isNotEmpty)
                                    Text(
                                      counts.entries
                                          .map((e) => '${e.key} ${e.value}')
                                          .join('  '),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(Gap.m, Gap.s, Gap.s, Gap.s),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      maxLength: 2000,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: l.tgWriteMessage,
                        counterText: '',
                        border: const OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: Gap.s),
                  IconButton.filled(
                    tooltip: l.tgSend,
                    onPressed: _sending ? null : _send,
                    icon: _sending
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Symbols.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Şikâyet: neden + isteğe bağlı açıklama. Moderasyon Supabase'de incelenir (SOCIAL_SAFETY §4.6).
class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({
    super.key,
    required this.targetType,
    this.targetId,
    this.userId,
  });

  final String targetType;
  final String? targetId;
  final String? userId;

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  String? _reason;
  final _details = TextEditingController();

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final options = [
      ('harassment', l.tgReasonHarassment),
      ('inappropriate', l.tgReasonInappropriate),
      ('spam', l.tgReasonSpam),
      ('child_safety', l.tgReasonChildSafety),
      ('other', l.tgReasonOther),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.tgReport)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.l),
        children: [
          Text(l.tgReportBody),
          const SizedBox(height: Gap.l),
          RadioGroup<String>(
            groupValue: _reason,
            onChanged: (x) => setState(() => _reason = x),
            child: Column(
              children: [
                for (final (v, label) in options)
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    value: v,
                    title: Text(label),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Gap.m),
          TextField(
            controller: _details,
            maxLength: 2000,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: l.tgReportDetails,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: Gap.l),
          BusyButton(
            label: l.tgReportSend,
            onPressed: _reason == null
                ? null
                : () async {
                    final ok = await socialAction(
                      context,
                      () => ref
                          .read(socialApiProvider)!
                          .report(
                            targetType: widget.targetType,
                            targetId: widget.targetId,
                            userId: widget.userId,
                            reason: _reason!,
                            details: _details.text,
                          ),
                      success: l.tgReportThanks,
                    );
                    if (ok && context.mounted) context.pop();
                  },
          ),
          const SizedBox(height: Gap.l),
          Text(l.tgReportUrgent, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
