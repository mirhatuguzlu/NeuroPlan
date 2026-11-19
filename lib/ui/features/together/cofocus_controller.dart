import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart' as lk;
import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show RealtimeChannel, RealtimeSubscribeStatus;

import '../../../app/focus_platform.dart';
import '../../../app/providers.dart';
import '../../../data/remote/social_api.dart';
import '../focus/focus_controller.dart';
import 'together_providers.dart';

/// Diğer katılımcının sakin bildirimi: plan bozuldu, bitirdi, ayrıldı (talimat §3).
typedef CofocusNotice = ({String name, String kind, DateTime at});

/// Ses durumu. Mikrofon varsayılan kapalı; kayıt yok (SOCIAL_SAFETY §4.4).
class VoiceView {
  const VoiceView({
    this.connected = false,
    this.connecting = false,
    this.micOn = false,
    this.speaking = const {},
    this.muted = const {},
    this.error,
  });

  final bool connected;
  final bool connecting;
  final bool micOn;

  /// Konuşan katılımcıların kullanıcı kimlikleri.
  final Set<String> speaking;

  /// Bu cihazda sesi kapatılan katılımcılar (yalnız benim duymam etkilenir).
  final Set<String> muted;

  /// `permission` · `unavailable` · `network`
  final String? error;

  VoiceView copyWith({
    bool? connected,
    bool? connecting,
    bool? micOn,
    Set<String>? speaking,
    Set<String>? muted,
    String? Function()? error,
  }) => VoiceView(
    connected: connected ?? this.connected,
    connecting: connecting ?? this.connecting,
    micOn: micOn ?? this.micOn,
    speaking: speaking ?? this.speaking,
    muted: muted ?? this.muted,
    error: error == null ? this.error : error(),
  );
}

class CofocusView {
  const CofocusView({
    this.id,
    this.session,
    this.online = const {},
    this.notices = const [],
    this.voice = const VoiceView(),
    this.focusSessionId,
  });

  final String? id;
  final CofocusState? session;

  /// Şu an kanalda olanlar: kullanıcı → evre (`lobby` · `focus` · `break` · `paused` · `done`).
  final Map<String, String> online;
  final List<CofocusNotice> notices;
  final VoiceView voice;

  /// Bu ortak oturumda başlattığım kendi odak oturumum.
  final String? focusSessionId;

  bool get active => id != null;
}

final cofocusControllerProvider =
    NotifierProvider<CofocusController, CofocusView>(CofocusController.new);

class CofocusController extends Notifier<CofocusView> {
  RealtimeChannel? _channel;
  lk.Room? _room;
  lk.EventsListener<lk.RoomEvent>? _roomEvents;
  ({PlannedInstance instance, FocusSettings settings})? _choice;
  var _starting = false;

  static const _pendingKey = 'cofocus.pending';

  SocialApi get _api => ref.read(socialApiProvider)!;

  @override
  CofocusView build() {
    ref.listen(focusControllerProvider, (prev, next) {
      final id = state.focusSessionId;
      if (id == null) return;
      if (next.ended case (id: final ended, :final outcome) when ended == id) {
        unawaited(_finished(outcome));
      } else if (next.active) {
        _track(switch (next.clock?.phase) {
          FocusPhase.working when next.pause == null => 'focus',
          FocusPhase.onBreak => 'break',
          _ => 'paused',
        });
      }
    });
    ref.onDispose(() => unawaited(_close()));
    unawaited(_settlePending());
    return const CofocusView();
  }

  // ------------------------------------------------------------ oturum

  Future<String> create(List<String> invitees, {required bool voice}) async {
    final id = await _api.createCofocus(invitees, voice: voice);
    await open(id);
    return id;
  }

  Future<void> join(String id) async {
    await _api.respondCofocus(id, true);
    await open(id);
  }

  Future<void> decline(String id) => _api.respondCofocus(id, false);

  Future<void> open(String id) async {
    if (state.id == id) return refresh();
    await _close();
    state = CofocusView(id: id);
    await refresh();
    final ch = _api.cofocusChannel(id);
    ch
      ..onPresenceSync((_) => _readPresence(ch))
      ..onBroadcast(event: 'notice', callback: _onNotice)
      ..onBroadcast(event: 'state', callback: (_) => unawaited(refresh()))
      ..subscribe((status, _) {
        if (status == RealtimeSubscribeStatus.subscribed) _track('lobby');
      });
    _channel = ch;
  }

  Future<void> refresh() async {
    final id = state.id;
    if (id == null) return;
    final s = await _api.cofocusState(id);
    if (state.id != id) return;
    state = CofocusView(
      id: id,
      session: s,
      online: state.online,
      notices: state.notices,
      voice: state.voice,
      focusSessionId: state.focusSessionId,
    );
    if (s != null && s.status == 'live') unawaited(_startMine());
  }

  /// Lobide seçilen kendi işim ve modum; başlatan başlatınca sayacım bununla başlar.
  void choose(PlannedInstance instance, FocusSettings settings) =>
      _choice = (instance: instance, settings: settings);

  bool get hasChoice => _choice != null;

  /// Yalnız başlatan: sunucu anı herkesin başlangıcıdır.
  Future<void> startAll() async {
    final id = state.id!;
    await _api.startCofocus(id);
    await _broadcast('state', {});
    await refresh();
  }

  Future<void> _startMine() async {
    final s = state.session;
    final me = _api.myId;
    final c = _choice;
    if (_starting || state.focusSessionId != null || s == null || c == null) {
      return;
    }
    final mine = s.participants.where((p) => p.userId == me).firstOrNull;
    if (mine?.status != 'joined' || mine?.outcome != null) return;
    _starting = true;
    try {
      final focus = ref.read(focusControllerProvider.notifier);
      await focus.start(
        instance: c.instance,
        settings: c.settings,
        startAt: s.localStart,
      );
      final session = ref.read(focusControllerProvider).session;
      if (session == null) return;
      state = CofocusView(
        id: state.id,
        session: s,
        online: state.online,
        notices: state.notices,
        voice: state.voice,
        focusSessionId: session.id,
      );
      await ref
          .read(prefsRepositoryProvider)
          .set(
            _pendingKey,
            jsonEncode({'cofocus': s.id, 'session': session.id}),
          );
      await _api.setCofocusFocus(s.id, session.id, c.settings.mode.name);
      _track('focus');
    } finally {
      _starting = false;
    }
  }

  Future<void> _finished(String outcome) async {
    final id = state.id;
    if (id == null) return;
    try {
      await _api.finishCofocus(id, outcome);
      await _broadcast('notice', {'kind': outcome});
    } on Object catch (e) {
      debugPrint('[cofocus] bitiş bildirilemedi: $e');
    }
    _track('done');
    await setMic(false);
    await refresh();
    await _settlePending();
  }

  /// Ortak tamamlanan oturumun bonusu: başkası da tamamladıysa bağlantı kazanılır
  /// (docs/BRAIN_MODEL.md §2.1). Uygulama açılışında da bekleyen varsa yeniden denenir.
  Future<void> _settlePending() async {
    final api = ref.read(socialApiProvider);
    if (api == null) return;
    final prefs = ref.read(prefsRepositoryProvider);
    final raw = await prefs.get(_pendingKey);
    if (raw == null) return;
    final p = (jsonDecode(raw) as Map).cast<String, String>();
    try {
      final s = await api.cofocusState(p['cofocus']!);
      if (s == null) {
        await prefs.set(_pendingKey, null);
        return;
      }
      final mine = s.participants
          .where((x) => x.userId == api.myId)
          .firstOrNull;
      if (mine?.outcome != 'completed') {
        if (mine?.outcome != null) await prefs.set(_pendingKey, null);
        return;
      }
      final peers = s.participants
          .where((x) => x.userId != api.myId && x.outcome == 'completed')
          .length;
      if (peers > 0) {
        await ref
            .read(brainRepositoryProvider)
            .recordCofocusPeers(p['session']!, peers);
      }
      if (s.status == 'ended') await prefs.set(_pendingKey, null);
    } on Object catch (e) {
      debugPrint('[cofocus] bonus kontrolü: $e');
    }
  }

  /// Lobiden ya da oturumdan ayrıl; odak sürüyorsa o kendi kuralıyla sürer.
  Future<void> leave() async {
    final id = state.id;
    if (id != null && state.focusSessionId == null) {
      try {
        await _api.finishCofocus(id, 'left');
        await _broadcast('notice', {'kind': 'left'});
      } on Object catch (e) {
        debugPrint('[cofocus] ayrılma: $e');
      }
    }
    await _close();
    state = const CofocusView();
  }

  void dismissNotice(CofocusNotice n) => state = CofocusView(
    id: state.id,
    session: state.session,
    online: state.online,
    notices: [...state.notices]..remove(n),
    voice: state.voice,
    focusSessionId: state.focusSessionId,
  );

  // ------------------------------------------------------------ canlı kanal

  void _track(String phase) {
    final me = _api.myId;
    if (_channel == null || me == null) return;
    unawaited(_channel!.track({'user_id': me, 'phase': phase}));
  }

  void _readPresence(RealtimeChannel ch) {
    final online = <String, String>{};
    for (final s in ch.presenceState()) {
      for (final p in s.presences) {
        final uid = p.payload['user_id'];
        if (uid is String) {
          online[uid] = p.payload['phase'] as String? ?? 'lobby';
        }
      }
    }
    state = CofocusView(
      id: state.id,
      session: state.session,
      online: online,
      notices: state.notices,
      voice: state.voice,
      focusSessionId: state.focusSessionId,
    );
  }

  void _onNotice(Map<String, dynamic> payload) {
    final uid = payload['user_id'] as String?;
    final kind = payload['kind'] as String?;
    if (uid == null || kind == null || uid == _api.myId) return;
    final name =
        state.session?.participants
            .where((p) => p.userId == uid)
            .firstOrNull
            ?.displayName ??
        '';
    state = CofocusView(
      id: state.id,
      session: state.session,
      online: state.online,
      notices: [...state.notices, (name: name, kind: kind, at: DateTime.now())],
      voice: state.voice,
      focusSessionId: state.focusSessionId,
    );
    unawaited(refresh());
    unawaited(_settlePending());
  }

  Future<void> _broadcast(String event, Map<String, Object?> payload) async {
    final ch = _channel;
    if (ch == null) return;
    await ch.sendBroadcastMessage(
      event: event,
      payload: {...payload, 'user_id': _api.myId},
    );
  }

  // ------------------------------------------------------------ ses (LiveKit)

  void _setVoice(VoiceView v) => state = CofocusView(
    id: state.id,
    session: state.session,
    online: state.online,
    notices: state.notices,
    voice: v,
    focusSessionId: state.focusSessionId,
  );

  /// Odaya bağlanır; mikrofon kapalı başlar.
  Future<void> connectVoice() async {
    final id = state.id;
    if (id == null || state.voice.connected || state.voice.connecting) return;
    _setVoice(state.voice.copyWith(connecting: true, error: () => null));
    try {
      final t = await _api.voiceToken(id);
      final room = lk.Room(
        roomOptions: const lk.RoomOptions(
          adaptiveStream: false,
          dynacast: false,
        ),
      );
      await room.connect(t.url, t.token);
      _room = room;
      _roomEvents = room.createListener()
        ..on<lk.ActiveSpeakersChangedEvent>(
          (e) => _setVoice(
            state.voice.copyWith(
              speaking: {for (final p in e.speakers) p.identity},
            ),
          ),
        )
        ..on<lk.TrackSubscribedEvent>((e) async {
          // Sessize aldığım kişi yeniden yayın açsa da duyulmaz.
          if (state.voice.muted.contains(e.participant.identity)) {
            await e.publication.disable();
          }
        });
      _setVoice(state.voice.copyWith(connected: true, connecting: false));
    } on SocialException catch (e) {
      _setVoice(
        state.voice.copyWith(
          connecting: false,
          error: () =>
              e.kind == SocialError.network ? 'network' : 'unavailable',
        ),
      );
    } on Object catch (e) {
      debugPrint('[voice] $e');
      _setVoice(
        state.voice.copyWith(connecting: false, error: () => 'network'),
      );
    }
  }

  /// Tek dokunuşla mikrofon. Android 14: mikrofon türlü ön plan servisi uygulama öndeyken açılır.
  Future<void> setMic(bool on) async {
    final room = _room;
    if (room == null) {
      if (!on) return;
      await connectVoice();
      if (_room == null) return;
      return setMic(true);
    }
    try {
      await room.localParticipant?.setMicrophoneEnabled(on);
      await ref.read(focusPlatformProvider).setMicrophoneInUse(on);
      _setVoice(state.voice.copyWith(micOn: on, error: () => null));
    } on Object catch (e) {
      debugPrint('[voice] mikrofon: $e');
      _setVoice(state.voice.copyWith(micOn: false, error: () => 'permission'));
    }
  }

  /// Kişiyi yalnız bu cihazda sessize alır / açar.
  Future<void> toggleMute(String userId) async {
    final muted = {...state.voice.muted};
    final mute = !muted.remove(userId);
    if (mute) muted.add(userId);
    for (final pub
        in _room?.remoteParticipants[userId]?.audioTrackPublications ??
            const <lk.RemoteTrackPublication>[]) {
      mute ? await pub.disable() : await pub.enable();
    }
    _setVoice(state.voice.copyWith(muted: muted));
  }

  Future<void> _close() async {
    await _roomEvents?.dispose();
    _roomEvents = null;
    final room = _room;
    _room = null;
    if (room != null) {
      await room.disconnect();
      await room.dispose();
      await ref.read(focusPlatformProvider).setMicrophoneInUse(false);
    }
    final ch = _channel;
    _channel = null;
    _choice = null;
    if (ch != null) await ref.read(socialApiProvider)?.removeChannel(ch);
  }
}
