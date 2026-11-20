import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/feature_flags.dart';
import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/remote/social_api.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../focus/focus_controller.dart';
import 'cofocus_controller.dart';
import 'together_providers.dart';
import 'together_widgets.dart';

final _savedSettingsProvider = FutureProvider.autoDispose(
  (ref) => savedFocusSettings(ref.watch(prefsRepositoryProvider)),
);

/// Ortak odak başlat: en çok 3 arkadaş davet edilir, ses isteğe bağlı (mikrofon kapalı başlar).
class CofocusNewScreen extends ConsumerStatefulWidget {
  const CofocusNewScreen({super.key});

  @override
  ConsumerState<CofocusNewScreen> createState() => _CofocusNewScreenState();
}

class _CofocusNewScreenState extends ConsumerState<CofocusNewScreen> {
  var _with = <String>{};
  var _voice = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final friends =
        ref.watch(friendsProvider).value?.friends ?? const <Friend>[];
    return Scaffold(
      appBar: AppBar(title: Text(l.tgCofocusNew)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.l),
        children: [
          Text(l.tgCofocusIntro),
          SectionTitle(l.tgCofocusWho),
          if (friends.isEmpty)
            Text(l.tgEmptyBody)
          else
            FriendPicker(
              friends: friends,
              selected: _with,
              max: 3,
              onChanged: (s) => setState(() => _with = s),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: const Icon(Symbols.mic_rounded),
            title: Text(l.tgVoice),
            subtitle: Text(l.tgVoiceBody),
            value: _voice,
            onChanged: (v) => setState(() => _voice = v),
          ),
          const SizedBox(height: Gap.l),
          BusyButton(
            label: l.tgCofocusInviteAction,
            onPressed: _with.isEmpty
                ? null
                : () async {
                    try {
                      final id = await ref
                          .read(cofocusControllerProvider.notifier)
                          .create(_with.toList(), voice: _voice);
                      if (context.mounted) {
                        context.pushReplacement('/together/cofocus/$id');
                      }
                    } on Object catch (e) {
                      if (context.mounted) {
                        showSnack(context, socialErrorText(l, e));
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }
}

/// Lobi: kim geldi, herkes kendi işini ve modunu seçer; başlatan başlatınca sayaçlar sunucu
/// anından birlikte işler ve odak ekranı açılır.
class CofocusLobbyScreen extends ConsumerStatefulWidget {
  const CofocusLobbyScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<CofocusLobbyScreen> createState() => _CofocusLobbyScreenState();
}

class _CofocusLobbyScreenState extends ConsumerState<CofocusLobbyScreen> {
  String? _instanceId;
  FocusMode? _mode;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(cofocusControllerProvider.notifier).open(widget.id),
    );
  }

  void _choose(
    PlannedInstance i,
    FocusMode mode,
    Map<FocusMode, FocusSettings> saved,
  ) {
    setState(() {
      _instanceId = i.id;
      _mode = mode;
    });
    ref.read(cofocusControllerProvider.notifier).choose(i, saved[mode]!);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final st = ref.watch(cofocusControllerProvider);
    final ctl = ref.read(cofocusControllerProvider.notifier);
    final s = st.session;
    final me = ref.watch(socialApiProvider)?.myId;
    final view = ref.watch(horizonProvider).value;
    final saved = ref.watch(_savedSettingsProvider).value;
    if (s == null || view == null || saved == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l.tgCofocus)),
        body: const SkeletonList(),
      );
    }
    final host = s.hostId == me;
    final ended = s.status == 'ended';
    final today = [
      for (final i in view.on(view.today))
        if (i.status == InstanceStatus.planned) i,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l.tgCofocus)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.l),
        children: [
          Text(
            ended
                ? l.tgCofocusEnded
                : s.status == 'live'
                ? l.tgCofocusLive
                : host
                ? l.tgCofocusHostHint
                : l.tgCofocusGuestHint,
          ),
          SectionTitle(l.tgCofocusWho),
          for (final p in s.participants)
            if (p.status != 'declined')
              _ParticipantTile(
                p: p,
                online: st.online[p.userId],
                voice: st.voice,
                me: p.userId == me,
              ),
          if (s.voice && !ended && featureOn(ref, Feature.voice)) ...[
            SectionTitle(l.tgVoice),
            _VoiceControls(voice: st.voice),
          ],
          if (!ended && st.focusSessionId == null) ...[
            SectionTitle(l.tgCofocusMine),
            if (today.isEmpty) ...[
              Text(l.tgCofocusNoTasks),
              const SizedBox(height: Gap.s),
              FilledButton.tonal(
                onPressed: () => context.push('/add'),
                child: Text(l.actionAdd),
              ),
            ] else
              RadioGroup<String>(
                groupValue: _instanceId,
                onChanged: (id) {
                  final i = view.byId[id];
                  if (i == null) return;
                  _choose(
                    i,
                    _mode ??
                        FocusMode.fromJson(view.data.focusMode(i.activityId)),
                    saved,
                  );
                },
                child: Column(
                  children: [
                    for (final i in today)
                      RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        value: i.id,
                        title: Text(
                          view.data.activities[i.activityId]?.title ?? '',
                        ),
                      ),
                  ],
                ),
              ),
            if (_instanceId != null) ...[
              const SizedBox(height: Gap.s),
              SegmentedButton<FocusMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: FocusMode.free, label: Text(l.modeFree)),
                  ButtonSegment(
                    value: FocusMode.pomodoro,
                    label: Text(l.modePomodoro),
                  ),
                  ButtonSegment(value: FocusMode.deep, label: Text(l.modeDeep)),
                ],
                selected: {_mode!},
                onSelectionChanged: (m) =>
                    _choose(view.byId[_instanceId]!, m.first, saved),
              ),
            ],
            const SizedBox(height: Gap.xl),
            if (_instanceId == null && today.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: Gap.s),
                child: Text(l.tgCofocusChooseFirst),
              ),
            if (host && s.status == 'scheduled')
              BusyButton(
                label: l.tgCofocusStart,
                onPressed: _instanceId == null
                    ? null
                    : () => socialAction(context, ctl.startAll),
              )
            else if (s.status == 'live')
              BusyButton(
                label: l.tgCofocusJoinNow,
                onPressed: _instanceId == null ? null : ctl.refresh,
              ),
          ],
          const SizedBox(height: Gap.m),
          OutlinedButton(
            onPressed: () async {
              await ctl.leave();
              if (context.mounted) context.pop();
            },
            child: Text(
              st.focusSessionId == null ? l.tgCofocusLeave : l.commonClose,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParticipantTile extends ConsumerWidget {
  const _ParticipantTile({
    required this.p,
    required this.online,
    required this.voice,
    required this.me,
  });
  final CofocusParticipant p;
  final String? online;
  final VoiceView voice;
  final bool me;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final speaking = voice.speaking.contains(p.userId);
    final status = switch ((p.status, p.outcome, online)) {
      (_, 'completed', _) => l.tgPhaseDone,
      (_, 'broken', _) => l.tgPhaseBroken,
      ('left', _, _) => l.tgPhaseLeft,
      ('invited', _, _) => l.tgPhaseInvited,
      (_, _, 'focus') => l.tgPhaseFocus,
      (_, _, 'break') => l.tgPhaseBreak,
      (_, _, 'paused') => l.tgPhasePaused,
      (_, _, null) => l.tgPhaseAway,
      _ => l.tgPhaseLobby,
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Initials(p.displayName, highlight: speaking),
      title: Text(me ? '${p.displayName} (${l.tgYou})' : p.displayName),
      subtitle: Text(speaking ? '$status · ${l.tgSpeaking}' : status),
      trailing: !me && voice.connected
          ? IconButton(
              tooltip: voice.muted.contains(p.userId)
                  ? l.tgUnmutePerson(p.displayName)
                  : l.tgMutePerson(p.displayName),
              icon: Icon(
                voice.muted.contains(p.userId)
                    ? Symbols.volume_off_rounded
                    : Symbols.volume_up_rounded,
              ),
              onPressed: () => ref
                  .read(cofocusControllerProvider.notifier)
                  .toggleMute(p.userId),
            )
          : null,
    );
  }
}

class _VoiceControls extends ConsumerWidget {
  const _VoiceControls({required this.voice});
  final VoiceView voice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ctl = ref.read(cofocusControllerProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.tgVoiceNoRecording,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: Gap.s),
        if (!voice.connected)
          BusyButton(
            tonal: true,
            label: l.tgVoiceConnect,
            onPressed: voice.connecting ? null : ctl.connectVoice,
          )
        else
          MicButton(on: voice.micOn, onToggle: () => ctl.setMic(!voice.micOn)),
        if (voice.error != null)
          Padding(
            padding: const EdgeInsets.only(top: Gap.s),
            child: Text(switch (voice.error) {
              'permission' => l.tgVoiceErrPermission,
              'unavailable' => l.tgVoiceErrUnavailable,
              _ => l.tgErrNetwork,
            }, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
      ],
    );
  }
}

/// Tek dokunuşla mikrofon (varsayılan kapalı).
class MicButton extends StatelessWidget {
  const MicButton({super.key, required this.on, required this.onToggle});
  final bool on;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Semantics(
      toggled: on,
      child: IconButton.filledTonal(
        tooltip: on ? l.tgMicOff : l.tgMicOn,
        isSelected: on,
        iconSize: 28,
        onPressed: onToggle,
        icon: const Icon(Symbols.mic_off_rounded),
        selectedIcon: const Icon(Symbols.mic_rounded),
      ),
    );
  }
}

/// Odak ekranındaki ortak odak şeridi: kim hangi evrede, kim konuşuyor, mikrofon ve sakin
/// bildirimler (biri planı bozarsa satır içinde yazar; pop-up yok).
class CofocusStrip extends ConsumerWidget {
  const CofocusStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(cofocusControllerProvider);
    final focus = ref.watch(focusControllerProvider);
    if (!st.active ||
        st.focusSessionId == null ||
        st.focusSessionId != focus.session?.id) {
      return const SizedBox.shrink();
    }
    final l = context.l10n;
    final me = ref.watch(socialApiProvider)?.myId;
    final others = [
      for (final p in st.session?.participants ?? const <CofocusParticipant>[])
        if (p.userId != me && (p.status == 'joined' || p.outcome != null)) p,
    ];
    final notice = st.notices.lastOrNull;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: Gap.m,
                  runSpacing: Gap.xs,
                  children: [
                    for (final p in others)
                      Semantics(
                        label:
                            '${p.displayName}: ${switch ((p.outcome, st.online[p.userId])) {
                              ('completed', _) => l.tgPhaseDone,
                              ('broken', _) => l.tgPhaseBroken,
                              (_, 'focus') => l.tgPhaseFocus,
                              (_, 'break') => l.tgPhaseBreak,
                              (_, null) => l.tgPhaseAway,
                              _ => l.tgPhasePaused,
                            }}',
                        excludeSemantics: true,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox.square(
                              dimension: 28,
                              child: Initials(
                                p.displayName,
                                highlight: st.voice.speaking.contains(p.userId),
                              ),
                            ),
                            const SizedBox(width: Gap.xs),
                            Text(
                              p.displayName,
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (st.session?.voice ?? false)
                MicButton(
                  on: st.voice.micOn,
                  onToggle: () => ref
                      .read(cofocusControllerProvider.notifier)
                      .setMic(!st.voice.micOn),
                ),
            ],
          ),
          if (notice != null)
            Semantics(
              liveRegion: true,
              child: Padding(
                padding: const EdgeInsets.only(top: Gap.s),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        switch (notice.kind) {
                          'broken' => l.tgNoticeBroken(notice.name),
                          'completed' => l.tgNoticeCompleted(notice.name),
                          _ => l.tgNoticeLeft(notice.name),
                        },
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: l.commonClose,
                      icon: const Icon(Symbols.close_rounded),
                      onPressed: () => ref
                          .read(cofocusControllerProvider.notifier)
                          .dismissNotice(notice),
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
