import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/remote/social_api.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../../core/wizard.dart';
import 'together_providers.dart';
import 'together_widgets.dart';

/// Sıralama: arkadaşlar ve isteğe bağlı genel tablo; haftalık, yalnız doğrulanan oturumlar.
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  var _global = false;
  var _streak = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final status = ref.watch(socialStatusProvider).value;
    final adult = status?.tier == SocialTier.adult;
    final joined = status?.profile?.globalLeaderboard ?? false;
    final board = _global ? globalBoardProvider : friendsBoardProvider;
    return Scaffold(
      appBar: AppBar(title: Text(l.tgLeaderboard)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.l),
        children: [
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l.tgFriends)),
              ButtonSegment(
                value: true,
                label: Text(l.tgGlobal),
                enabled: adult,
              ),
            ],
            selected: {_global},
            onSelectionChanged: (s) => setState(() => _global = s.first),
          ),
          if (adult) ...[
            const SizedBox(height: Gap.m),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(l.tgMetricFocus)),
                ButtonSegment(value: true, label: Text(l.tgMetricStreak)),
              ],
              selected: {_streak},
              onSelectionChanged: (s) => setState(() => _streak = s.first),
            ),
          ],
          if (!adult) ...[
            const SizedBox(height: Gap.s),
            Text(l.tgGlobalBoardMinor),
          ],
          const SizedBox(height: Gap.m),
          Text(l.tgBoardNote, style: Theme.of(context).textTheme.bodySmall),
          if (_global && !joined)
            Card.filled(
              margin: const EdgeInsets.only(top: Gap.l),
              child: ListTile(
                title: Text(l.tgGlobalNotJoined),
                trailing: TextButton(
                  onPressed: () => context.push('/together/privacy'),
                  child: Text(l.tgPrivacy),
                ),
              ),
            ),
          SocialAsync<List<LeaderRow>>(
            value: ref.watch(board),
            onRetry: () => ref.invalidate(board),
            data: (rows) {
              final sorted = [...rows];
              if (_streak) {
                sorted.sort(
                  (a, b) => (b.activeDays ?? 0).compareTo(a.activeDays ?? 0),
                );
              }
              if (sorted.every((r) => r.focusMinutes == 0)) {
                return Padding(
                  padding: const EdgeInsets.only(top: Gap.xl),
                  child: Text(l.tgBoardEmpty, textAlign: TextAlign.center),
                );
              }
              return Column(
                children: [
                  for (final (i, r) in sorted.indexed)
                    MergeSemantics(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${r.rank ?? i + 1}'),
                        ),
                        title: Text(
                          r.isMe
                              ? '${r.displayName} (${l.tgYou})'
                              : r.displayName,
                        ),
                        selected: r.isMe,
                        trailing: Text(
                          _streak
                              ? l.tgDays(r.activeDays ?? 0)
                              : durationText(l, r.focusMinutes),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Ortak etkinlikler: davetler, onay bekleyen değişiklikler, etkinlikler ve ilerleme.
class SharedListScreen extends ConsumerWidget {
  const SharedListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final api = ref.watch(socialApiProvider)!;
    final me = api.myId;
    void refresh() {
      ref.invalidate(sharedProvider);
      ref.invalidate(badgesProvider);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.tgShared)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/together/shared/new'),
        icon: const Icon(Symbols.add_rounded),
        label: Text(l.tgSharedNew),
      ),
      body: SocialAsync<List<SharedActivity>>(
        value: ref.watch(sharedProvider),
        onRetry: () => ref.invalidate(sharedProvider),
        data: (list) {
          if (list.isEmpty) {
            return MessageState(
              icon: Symbols.event_upcoming_rounded,
              title: l.tgSharedEmptyTitle,
              body: l.tgSharedEmptyBody,
              actionLabel: l.tgSharedNew,
              onAction: () => context.push('/together/shared/new'),
            );
          }
          String names(SharedActivity s) => s.participants
              .where((p) => p.userId != me && p.status != 'declined')
              .map((p) => p.displayName)
              .join(', ');
          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              for (final s in list)
                Card.outlined(
                  margin: const EdgeInsets.fromLTRB(Gap.l, Gap.m, Gap.l, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(Gap.l),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: Gap.xs),
                        Text(
                          [
                            if (s.start != null && s.end != null)
                              '${DateFormat.MMMEd(context.localeName).format(s.start!)} ${timeRangeText(context, s.start!, s.end!)}',
                            if (s.kind == 'project' && s.totalMinutes != null)
                              l.tgProgress(
                                durationText(l, s.progressMinutes),
                                durationText(l, s.totalMinutes!),
                              ),
                            l.tgWith(names(s)),
                            switch (s.status) {
                              'confirmed' => l.tgStatusConfirmed,
                              'cancelled' => l.tgStatusCancelled,
                              _ => l.tgStatusProposed,
                            },
                          ].join(' · '),
                        ),
                        if (s.kind == 'project' &&
                            (s.totalMinutes ?? 0) > 0) ...[
                          const SizedBox(height: Gap.s),
                          LinearProgressIndicator(
                            value: (s.progressMinutes / s.totalMinutes!)
                                .clamp(0, 1)
                                .toDouble(),
                            semanticsLabel: l.tgProgress(
                              durationText(l, s.progressMinutes),
                              durationText(l, s.totalMinutes!),
                            ),
                          ),
                        ],
                        for (final c in s.changes)
                          if (c.proposedBy != me && !c.approvedByMe)
                            Padding(
                              padding: const EdgeInsets.only(top: Gap.m),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      l.tgChangeProposed(
                                        _patchText(context, c.patch),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await socialAction(
                                        context,
                                        () => api.respondChange(c.id, false),
                                      );
                                      refresh();
                                    },
                                    child: Text(l.tgDecline),
                                  ),
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      await socialAction(
                                        context,
                                        () => api.respondChange(c.id, true),
                                      );
                                      refresh();
                                    },
                                    child: Text(l.tgAccept),
                                  ),
                                ],
                              ),
                            )
                          else
                            Padding(
                              padding: const EdgeInsets.only(top: Gap.m),
                              child: Text(
                                l.tgChangeWaiting(_patchText(context, c.patch)),
                              ),
                            ),
                        const SizedBox(height: Gap.s),
                        Wrap(
                          spacing: Gap.s,
                          alignment: WrapAlignment.end,
                          children: [
                            if (s.participant(me ?? '')?.status ==
                                'invited') ...[
                              TextButton(
                                onPressed: () async {
                                  await socialAction(
                                    context,
                                    () => api.respondShared(s.id, false),
                                  );
                                  refresh();
                                },
                                child: Text(l.tgDecline),
                              ),
                              FilledButton(
                                onPressed: () async {
                                  await socialAction(
                                    context,
                                    () => api.respondShared(s.id, true),
                                    success: l.tgSharedAccepted,
                                  );
                                  refresh();
                                },
                                child: Text(l.tgAccept),
                              ),
                            ] else if (s.status != 'cancelled') ...[
                              TextButton(
                                onPressed: () async {
                                  final organizer = s.organizerId == me;
                                  if (!await confirmAction(
                                    context,
                                    title: organizer
                                        ? l.tgSharedCancel
                                        : l.tgSharedLeave,
                                    body: organizer
                                        ? l.tgSharedCancelBody
                                        : l.tgSharedLeaveBody,
                                    confirm: organizer
                                        ? l.tgSharedCancel
                                        : l.tgSharedLeave,
                                  )) {
                                    return;
                                  }
                                  if (!context.mounted) return;
                                  await socialAction(
                                    context,
                                    () => api.leaveShared(s.id),
                                  );
                                  refresh();
                                },
                                child: Text(
                                  s.organizerId == me
                                      ? l.tgSharedCancel
                                      : l.tgSharedLeave,
                                ),
                              ),
                              FilledButton.tonal(
                                onPressed: () => context.push(
                                  '/together/shared/${s.id}/change',
                                ),
                                child: Text(l.tgSuggestChange),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

String _patchText(BuildContext context, Json patch) {
  final l = context.l10n;
  return [
    if (patch['title'] case final String t) l.tgPatchTitle(t),
    if (patch['start_at'] case final String s)
      DateFormat.MMMEd(context.localeName)
          .add_Hm()
          .format(DateTime.parse(s).toLocal()),
    if (patch['total_minutes'] case final int m) durationText(l, m),
  ].join(', ');
}

/// Ortak etkinlik ya da proje öner: tür → ad → kiminle → ne zaman → özet (UX §2 sihirbaz).
class SharedNewScreen extends ConsumerStatefulWidget {
  const SharedNewScreen({
    super.key,
    this.start,
    this.end,
    this.with_ = const [],
  });

  final DateTime? start;
  final DateTime? end;
  final List<String> with_;

  @override
  ConsumerState<SharedNewScreen> createState() => _SharedNewScreenState();
}

class _SharedNewScreenState extends ConsumerState<SharedNewScreen> {
  var _kind = 'activity';
  final _title = TextEditingController();
  final _notes = TextEditingController();
  late Set<String> _with = {...widget.with_};
  late DateTime _date =
      widget.start ?? DateTime.now().add(const Duration(days: 1));
  late int _from = widget.start == null
      ? 18 * 60
      : widget.start!.hour * 60 + widget.start!.minute;
  late int _to = widget.end == null
      ? 19 * 60
      : widget.end!.hour * 60 + widget.end!.minute;
  var _total = 120;
  String? _root;

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  DateTime _at(int minute) =>
      DateTime(_date.year, _date.month, _date.day, minute ~/ 60, minute % 60);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final friends =
        ref.watch(friendsProvider).value?.friends ?? const <Friend>[];
    final roots =
        ref.watch(rootCategoriesProvider).value ?? const <RootCategory>[];
    final project = _kind == 'project';
    return WizardScaffold(
      onClose: () => context.pop(),
      onFinish: () async {
        final ok = await socialAction(
          context,
          () => ref
              .read(socialApiProvider)!
              .proposeShared(
                title: _title.text.trim(),
                participants: _with.toList(),
                start: project ? null : _at(_from),
                end: project ? _at(24 * 60 - 1) : _at(_to),
                notes: _notes.text,
                rootKey: _root,
                kind: _kind,
                totalMinutes: project ? _total : null,
              ),
          success: l.tgSharedSent,
        );
        if (ok && context.mounted) {
          ref.invalidate(sharedProvider);
          context.pop();
        }
      },
      steps: [
        WizardStep(
          id: 'kind',
          title: l.tgSharedKindTitle,
          body: ChoiceList<String>(
            value: _kind,
            options: [
              ('activity', l.tgKindActivity, l.tgKindActivityBody),
              ('project', l.tgKindProject, l.tgKindProjectBody),
            ],
            onChanged: (v) => setState(() => _kind = v),
          ),
        ),
        WizardStep(
          id: 'name',
          title: l.tgSharedNameTitle,
          canNext: _title.text.trim().isNotEmpty,
          body: Column(
            children: [
              TextField(
                controller: _title,
                autofocus: true,
                maxLength: 200,
                decoration: InputDecoration(labelText: l.tgSharedName),
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                controller: _notes,
                maxLength: 2000,
                maxLines: 3,
                decoration: InputDecoration(labelText: l.tgSharedNotes),
              ),
            ],
          ),
        ),
        WizardStep(
          id: 'with',
          title: l.tgSharedWithTitle,
          canNext: _with.isNotEmpty,
          body: friends.isEmpty
              ? Text(l.tgEmptyBody)
              : FriendPicker(
                  friends: friends,
                  selected: _with,
                  max: 7,
                  onChanged: (s) => setState(() => _with = s),
                ),
        ),
        WizardStep(
          id: 'when',
          title: project ? l.tgSharedDeadlineTitle : l.tgSharedWhenTitle,
          canNext: project || _to > _from,
          body: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Symbols.event_rounded),
                title: Text(
                  DateFormat.yMMMMEEEEd(context.localeName).format(_date),
                ),
                onTap: () async {
                  final now = DateTime.now();
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 365)),
                  );
                  if (d != null) setState(() => _date = d);
                },
              ),
              if (project) ...[
                Text(l.tgSharedTotal(durationText(l, _total))),
                Slider(
                  value: _total.toDouble(),
                  min: 30,
                  max: 3000,
                  divisions: 99,
                  label: durationText(l, _total),
                  onChanged: (v) => setState(() => _total = v.round()),
                ),
              ] else ...[
                TimeTile(
                  label: l.tgFrom,
                  minuteOfDay: _from,
                  onChanged: (v) => setState(() => _from = v),
                ),
                TimeTile(
                  label: l.tgTo,
                  minuteOfDay: _to,
                  onChanged: (v) => setState(() => _to = v),
                ),
                if (_to <= _from)
                  Text(
                    l.tgEndAfterStart,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ],
          ),
        ),
        WizardStep(
          id: 'root',
          title: l.tgSharedRootTitle,
          subtitle: l.tgSharedRootBody,
          optional: true,
          body: ChoiceList<String?>(
            value: _root,
            options: [
              (null, l.tgNoCategory, null),
              for (final r in roots) (r.key, r.name(context), null),
            ],
            onChanged: (v) => setState(() => _root = v),
          ),
        ),
        WizardStep(
          id: 'confirm',
          title: l.tgSharedConfirmTitle,
          nextLabel: l.tgSharedSend,
          body: Text(
            [
              _title.text.trim(),
              if (project)
                l.tgSharedTotal(durationText(l, _total))
              else
                '${DateFormat.MMMEd(context.localeName).format(_date)} ${timeRangeText(context, _at(_from), _at(_to))}',
              l.tgWith(
                friends
                    .where((f) => _with.contains(f.userId))
                    .map((f) => f.displayName)
                    .join(', '),
              ),
              l.tgSharedConfirmBody,
            ].join('\n'),
          ),
        ),
      ],
    );
  }
}

/// Değişiklik öner: ad ve zaman; karşı tarafın onayına gider.
class SharedChangeScreen extends ConsumerStatefulWidget {
  const SharedChangeScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<SharedChangeScreen> createState() => _SharedChangeScreenState();
}

class _SharedChangeScreenState extends ConsumerState<SharedChangeScreen> {
  final _title = TextEditingController();
  DateTime? _date;
  int? _from;
  int? _to;
  var _loaded = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = ref
        .watch(sharedProvider)
        .value
        ?.where((x) => x.id == widget.id)
        .firstOrNull;
    if (s != null && !_loaded) {
      _loaded = true;
      _title.text = s.title;
      if (s.start != null && s.end != null) {
        _date = s.start;
        _from = s.start!.hour * 60 + s.start!.minute;
        _to = s.end!.hour * 60 + s.end!.minute;
      }
    }
    DateTime at(int m) =>
        DateTime(_date!.year, _date!.month, _date!.day, m ~/ 60, m % 60);
    return Scaffold(
      appBar: AppBar(title: Text(l.tgSuggestChange)),
      body: s == null
          ? const SkeletonList()
          : ListView(
              padding: const EdgeInsets.all(Gap.l),
              children: [
                Text(l.tgChangeBody),
                const SizedBox(height: Gap.l),
                TextField(
                  controller: _title,
                  maxLength: 200,
                  decoration: InputDecoration(labelText: l.tgSharedName),
                ),
                if (_date != null) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Symbols.event_rounded),
                    title: Text(
                      DateFormat.yMMMMEEEEd(context.localeName).format(_date!),
                    ),
                    onTap: () async {
                      final now = DateTime.now();
                      final d = await showDatePicker(
                        context: context,
                        initialDate: _date!,
                        firstDate: now,
                        lastDate: now.add(const Duration(days: 365)),
                      );
                      if (d != null) setState(() => _date = d);
                    },
                  ),
                  TimeTile(
                    label: l.tgFrom,
                    minuteOfDay: _from!,
                    onChanged: (v) => setState(() => _from = v),
                  ),
                  TimeTile(
                    label: l.tgTo,
                    minuteOfDay: _to!,
                    onChanged: (v) => setState(() => _to = v),
                  ),
                ],
                const SizedBox(height: Gap.xl),
                BusyButton(
                  label: l.tgSendChange,
                  onPressed: () async {
                    final patch = <String, Object?>{
                      if (_title.text.trim() != s.title &&
                          _title.text.trim().isNotEmpty)
                        'title': _title.text.trim(),
                      if (_date != null && _to! > _from!) ...{
                        'start_at': at(_from!).toUtc().toIso8601String(),
                        'end_at': at(_to!).toUtc().toIso8601String(),
                      },
                    };
                    if (patch.isEmpty) return;
                    final ok = await socialAction(
                      context,
                      () => ref
                          .read(socialApiProvider)!
                          .proposeChange(s.id, patch),
                      success: l.tgChangeSent,
                    );
                    if (ok && context.mounted) {
                      ref.invalidate(sharedProvider);
                      context.pop();
                    }
                  },
                ),
              ],
            ),
    );
  }
}

/// Ortak boş zaman: sunucu yalnız herkesin boş olduğu aralıkları döner.
class FreeTimeScreen extends ConsumerStatefulWidget {
  const FreeTimeScreen({super.key});

  @override
  ConsumerState<FreeTimeScreen> createState() => _FreeTimeScreenState();
}

class _FreeTimeScreenState extends ConsumerState<FreeTimeScreen> {
  var _with = <String>{};
  var _minutes = 60;
  Future<List<({DateTime start, DateTime end})>>? _result;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final friends =
        ref.watch(friendsProvider).value?.friends ?? const <Friend>[];
    return Scaffold(
      appBar: AppBar(title: Text(l.tgFreeTime)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.l),
        children: [
          Text(l.tgFreeTimeBody),
          SectionTitle(l.tgSharedWithTitle),
          FriendPicker(
            friends: friends,
            selected: _with,
            max: 7,
            onChanged: (s) => setState(() => _with = s),
          ),
          SectionTitle(l.tgFreeTimeLength),
          SegmentedButton<int>(
            segments: [
              for (final m in const [30, 60, 90, 120])
                ButtonSegment(value: m, label: Text(durationText(l, m))),
            ],
            selected: {_minutes},
            onSelectionChanged: (s) => setState(() => _minutes = s.first),
          ),
          const SizedBox(height: Gap.l),
          BusyButton(
            label: l.tgFreeTimeFind,
            onPressed: _with.isEmpty
                ? null
                : () async {
                    final now = DateTime.now();
                    final f = ref
                        .read(socialApiProvider)!
                        .commonFreeTime(
                          _with.toList(),
                          now,
                          now.add(const Duration(days: 7)),
                          _minutes,
                        );
                    setState(() => _result = f);
                    await f.then((_) {}, onError: (_) {});
                  },
          ),
          if (_result != null)
            FutureBuilder(
              future: _result,
              builder: (context, snap) {
                if (snap.hasError) {
                  return Padding(
                    padding: const EdgeInsets.only(top: Gap.l),
                    child: Text(socialErrorText(l, snap.error!)),
                  );
                }
                if (!snap.hasData) return const SkeletonList(rows: 3);
                // Gece saatleri öneri olarak sunulmaz (08:00–23:00).
                final slots = [
                  for (final s in snap.data!)
                    if (s.start.hour >= 8 && s.start.hour < 23) s,
                ];
                if (slots.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: Gap.l),
                    child: Text(l.tgFreeTimeNone),
                  );
                }
                return Column(
                  children: [
                    for (final s in slots.take(20))
                      ListTile(
                        leading: const Icon(Symbols.hourglass_empty_rounded),
                        title: Text(
                          DateFormat.MMMMEEEEd(context.localeName)
                              .format(s.start),
                        ),
                        subtitle: Text(timeRangeText(context, s.start, s.end)),
                        trailing: TextButton(
                          onPressed: () {
                            final end = s.start.add(
                              Duration(minutes: _minutes),
                            );
                            context.push(
                              '/together/shared/new?start=${s.start.toIso8601String()}&end=${end.toIso8601String()}&with=${_with.join(',')}',
                            );
                          },
                          child: Text(l.tgPlanHere),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
