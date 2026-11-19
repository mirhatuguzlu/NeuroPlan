import 'dart:async';

import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Sunucunun kurallarını (yaş, engel, arkadaşlık, hız sınırı) veritabanı uygular; istemci
/// yalnız sonucu gösterir (docs/SOCIAL_SAFETY.md §4). Hata kodları migration'da tanımlı.
enum SocialError {
  notEligible,
  notFound,
  conflict,
  notPublished,
  rateLimited,
  forbidden,
  invalid,
  network,
  unknown,
}

class SocialException implements Exception {
  const SocialException(this.kind, [this.detail = '']);
  final SocialError kind;

  /// Sunucunun kısa nedeni: `username_taken`, `partner_taken`, `too_young`…
  final String detail;

  static SocialException from(Object e) => switch (e) {
    SocialException() => e,
    PostgrestException(:final code, :final message) => SocialException(
      switch (code) {
        'NP001' => SocialError.notEligible,
        'NP404' => SocialError.notFound,
        'NP409' => SocialError.conflict,
        'NP412' => SocialError.notPublished,
        'NP429' => SocialError.rateLimited,
        '42501' => SocialError.forbidden,
        '22023' => SocialError.invalid,
        _ => SocialError.unknown,
      },
      message,
    ),
    FunctionException(:final status) => SocialException(
      status == 403 ? SocialError.forbidden : SocialError.unknown,
      '$status',
    ),
    AuthException() ||
    TimeoutException() => const SocialException(SocialError.network),
    _
        when '$e'.contains('SocketException') ||
            '$e'.contains('ClientException') =>
      const SocialException(SocialError.network),
    _ => SocialException(SocialError.unknown, '$e'),
  };

  @override
  String toString() => 'SocialException($kind, $detail)';
}

typedef Json = Map<String, Object?>;

DateTime? _time(Object? v) => v is String ? DateTime.parse(v).toLocal() : null;

class SocialProfile {
  const SocialProfile({
    required this.displayName,
    this.username,
    this.discoverable = false,
    this.globalLeaderboard = false,
    this.shareBrain = false,
    this.suspendedUntil,
  });

  factory SocialProfile.fromJson(Json j) => SocialProfile(
    displayName: j['display_name']! as String,
    username: j['username'] as String?,
    discoverable: j['discoverable'] as bool? ?? false,
    globalLeaderboard: j['global_leaderboard'] as bool? ?? false,
    shareBrain: j['share_brain'] as bool? ?? false,
    suspendedUntil: _time(j['suspended_until']),
  );

  final String displayName;
  final String? username;
  final bool discoverable;
  final bool globalLeaderboard;
  final bool shareBrain;
  final DateTime? suspendedUntil;
}

/// `none`: sosyal kapalı · `minor`: 15–17 sıkı mod · `adult`.
enum SocialTier { none, minor, adult }

class SocialStatus {
  const SocialStatus({
    required this.anonymous,
    required this.age,
    required this.tier,
    this.profile,
  });

  factory SocialStatus.fromJson(Json j) => SocialStatus(
    anonymous: j['anonymous'] as bool? ?? true,
    age: j['age'] as int?,
    tier: SocialTier.values.byName(j['tier'] as String? ?? 'none'),
    profile: switch (j['profile']) {
      final Map p => SocialProfile.fromJson(p.cast()),
      _ => null,
    },
  );

  final bool anonymous;

  /// En düşük olası yaş (yalnız doğum yılı tutulur); sunucu henüz bilmiyorsa null.
  final int? age;
  final SocialTier tier;
  final SocialProfile? profile;
}

class Friend {
  const Friend({
    required this.userId,
    required this.displayName,
    this.username,
    this.isPartner = false,
    this.partnerRequestedBy,
  });

  factory Friend.fromJson(Json j) => Friend(
    userId: j['user_id']! as String,
    displayName: j['display_name'] as String? ?? '',
    username: j['username'] as String?,
    isPartner: j['is_partner'] as bool? ?? false,
    partnerRequestedBy: j['partner_requested_by'] as String?,
  );

  final String userId;
  final String displayName;
  final String? username;
  final bool isPartner;
  final String? partnerRequestedBy;
}

class FriendRequest {
  const FriendRequest(this.friendshipId, this.userId, this.displayName);
  factory FriendRequest.fromJson(Json j) => FriendRequest(
    j['friendship_id']! as String,
    j['user_id']! as String,
    j['display_name'] as String? ?? '',
  );
  final String friendshipId;
  final String userId;
  final String displayName;
}

class Invite {
  const Invite(this.id, this.code, this.kind, this.expiresAt);
  factory Invite.fromJson(Json j) => Invite(
    j['id']! as String,
    j['code']! as String,
    j['kind']! as String,
    _time(j['expires_at'])!,
  );
  final String id;
  final String code;

  /// `friend` · `partner`
  final String kind;
  final DateTime expiresAt;
}

class FriendOverview {
  const FriendOverview({
    this.friends = const [],
    this.incoming = const [],
    this.outgoing = const [],
    this.blocked = const [],
    this.invites = const [],
  });

  factory FriendOverview.fromJson(Json j) {
    List<Json> list(String k) => (j[k] as List? ?? const [])
        .cast<Map>()
        .map((m) => m.cast<String, Object?>())
        .toList();
    return FriendOverview(
      friends: list('friends').map(Friend.fromJson).toList(),
      incoming: list('incoming').map(FriendRequest.fromJson).toList(),
      outgoing: list('outgoing').map(FriendRequest.fromJson).toList(),
      blocked: list('blocked').map(Friend.fromJson).toList(),
      invites: list('invites').map(Invite.fromJson).toList(),
    );
  }

  final List<Friend> friends;
  final List<FriendRequest> incoming;
  final List<FriendRequest> outgoing;
  final List<Friend> blocked;
  final List<Invite> invites;

  Friend? get partner => friends.where((f) => f.isPartner).firstOrNull;
}

class CalendarEntry {
  const CalendarEntry({
    required this.id,
    required this.start,
    required this.end,
    required this.level,
    this.title,
    this.rootCategoryKey,
    this.notes,
  });

  factory CalendarEntry.fromJson(Json j) => CalendarEntry(
    id: j['block_id']! as String,
    start: _time(j['start_at'])!,
    end: _time(j['end_at'])!,
    level: j['level']! as String,
    title: j['title'] as String?,
    rootCategoryKey: j['root_category_key'] as String?,
    notes: j['notes'] as String?,
  );

  final String id;
  final DateTime start;
  final DateTime end;

  /// `busy` · `title_time` · `full`
  final String level;
  final String? title;
  final String? rootCategoryKey;
  final String? notes;
}

class ConversationSummary {
  const ConversationSummary({
    required this.id,
    required this.friendId,
    required this.displayName,
    this.lastBody,
    this.lastDeleted = false,
    this.lastMine = false,
    this.lastAt,
    this.unread = 0,
    this.muted = false,
  });

  factory ConversationSummary.fromJson(Json j) => ConversationSummary(
    id: j['id']! as String,
    friendId: j['friend_id']! as String,
    displayName: j['display_name'] as String? ?? '',
    lastBody: j['last_body'] as String?,
    lastDeleted: j['last_deleted'] as bool? ?? false,
    lastMine: j['last_mine'] as bool? ?? false,
    lastAt: _time(j['last_at']),
    unread: (j['unread'] as num?)?.toInt() ?? 0,
    muted: j['muted'] as bool? ?? false,
  );

  final String id;
  final String friendId;
  final String displayName;
  final String? lastBody;
  final bool lastDeleted;
  final bool lastMine;
  final DateTime? lastAt;
  final int unread;
  final bool muted;
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.userId,
    required this.body,
    required this.createdAt,
    this.deleted = false,
    this.reactions = const {},
  });

  factory ChatMessage.fromJson(Json j) => ChatMessage(
    id: j['id']! as String,
    userId: j['user_id']! as String,
    body: j['body']! as String,
    createdAt: _time(j['created_at'])!,
    deleted: j['deleted_at'] != null,
    reactions: {
      for (final r in (j['reactions'] as List? ?? const []).cast<Map>())
        if (r['deleted_at'] == null)
          (r['emoji'] as String, r['user_id'] as String),
    },
  );

  final String id;
  final String userId;
  final String body;
  final DateTime createdAt;
  final bool deleted;

  /// (emoji, kullanıcı) çiftleri.
  final Set<(String, String)> reactions;
}

class SharedParticipant {
  const SharedParticipant(
    this.userId,
    this.displayName,
    this.status,
    this.progressMinutes,
  );
  factory SharedParticipant.fromJson(Json j) => SharedParticipant(
    j['user_id']! as String,
    j['display_name'] as String? ?? '',
    j['status']! as String,
    (j['progress_minutes'] as num?)?.toInt() ?? 0,
  );
  final String userId;
  final String displayName;

  /// `invited` · `accepted` · `declined`
  final String status;
  final int progressMinutes;
}

class SharedChange {
  const SharedChange(this.id, this.proposedBy, this.patch, this.approvedByMe);
  factory SharedChange.fromJson(Json j) => SharedChange(
    j['id']! as String,
    j['proposed_by']! as String,
    (j['patch']! as Map).cast(),
    j['approved'] as bool? ?? false,
  );
  final String id;
  final String proposedBy;
  final Json patch;
  final bool approvedByMe;
}

class SharedActivity {
  const SharedActivity({
    required this.id,
    required this.organizerId,
    required this.title,
    required this.kind,
    required this.status,
    this.notes,
    this.start,
    this.end,
    this.rootCategoryKey,
    this.totalMinutes,
    this.participants = const [],
    this.changes = const [],
  });

  factory SharedActivity.fromJson(Json j) => SharedActivity(
    id: j['id']! as String,
    organizerId: j['organizer_id']! as String,
    title: j['title']! as String,
    kind: j['kind'] as String? ?? 'activity',
    status: j['status']! as String,
    notes: j['notes'] as String?,
    start: _time(j['start_at']),
    end: _time(j['end_at']),
    rootCategoryKey: j['root_category_key'] as String?,
    totalMinutes: (j['total_minutes'] as num?)?.toInt(),
    participants: (j['participants'] as List? ?? const [])
        .cast<Map>()
        .map((m) => SharedParticipant.fromJson(m.cast()))
        .toList(),
    changes: (j['changes'] as List? ?? const [])
        .cast<Map>()
        .map((m) => SharedChange.fromJson(m.cast()))
        .toList(),
  );

  final String id;
  final String organizerId;
  final String title;

  /// `activity` · `project`
  final String kind;

  /// `proposed` · `confirmed` · `cancelled`
  final String status;
  final String? notes;
  final DateTime? start;
  final DateTime? end;
  final String? rootCategoryKey;
  final int? totalMinutes;
  final List<SharedParticipant> participants;
  final List<SharedChange> changes;

  SharedParticipant? participant(String userId) =>
      participants.where((p) => p.userId == userId).firstOrNull;
  int get progressMinutes =>
      participants.fold(0, (t, p) => t + p.progressMinutes);
}

class CofocusParticipant {
  const CofocusParticipant(
    this.userId,
    this.displayName,
    this.status,
    this.outcome,
    this.mode,
  );
  factory CofocusParticipant.fromJson(Json j) => CofocusParticipant(
    j['user_id']! as String,
    j['display_name'] as String? ?? '',
    j['status']! as String,
    j['outcome'] as String?,
    j['mode'] as String?,
  );
  final String userId;
  final String displayName;

  /// `invited` · `joined` · `left` · `declined`
  final String status;

  /// `completed` · `broken` · `left`
  final String? outcome;
  final String? mode;
}

class CofocusState {
  const CofocusState({
    required this.id,
    required this.hostId,
    required this.status,
    required this.voice,
    required this.serverOffset,
    this.startedAt,
    this.participants = const [],
  });

  factory CofocusState.fromJson(Json j, {required DateTime receivedAt}) =>
      CofocusState(
        id: j['id']! as String,
        hostId: j['host_id']! as String,
        status: j['status']! as String,
        voice: j['voice'] as bool? ?? false,
        startedAt: _time(j['started_at']),
        serverOffset: _time(j['server_now'])!.difference(receivedAt),
        participants: (j['participants'] as List? ?? const [])
            .cast<Map>()
            .map((m) => CofocusParticipant.fromJson(m.cast()))
            .toList(),
      );

  final String id;
  final String hostId;

  /// `scheduled` (lobi) · `live` · `ended`
  final String status;
  final bool voice;
  final DateTime? startedAt;

  /// Sunucu saati − cihaz saati; sayaç başlangıcı buna göre düzeltilir.
  final Duration serverOffset;
  final List<CofocusParticipant> participants;

  /// Sunucu başlangıç anının cihaz saatindeki karşılığı.
  DateTime? get localStart => startedAt?.subtract(serverOffset);
}

class LeaderRow {
  const LeaderRow(
    this.displayName,
    this.isMe,
    this.focusMinutes,
    this.activeDays, {
    this.rank,
  });
  final String displayName;
  final bool isMe;
  final int focusMinutes;

  /// 15–17 yaşta null (süreklilik gösterilmez).
  final int? activeDays;
  final int? rank;
}

class TogetherBadges {
  const TogetherBadges({
    this.friendRequests = 0,
    this.partnerRequestFrom,
    this.cofocusInvites = const [],
    this.sharedInvites = 0,
    this.sharedChanges = 0,
    this.unread = 0,
  });

  factory TogetherBadges.fromJson(Json j) => TogetherBadges(
    friendRequests: (j['friend_requests'] as num?)?.toInt() ?? 0,
    partnerRequestFrom: j['partner_request'] as String?,
    cofocusInvites: [
      for (final c in (j['cofocus_invites'] as List? ?? const []).cast<Map>())
        (
          id: c['id'] as String,
          hostName: c['host_name'] as String? ?? '',
          voice: c['voice'] as bool? ?? false,
        ),
    ],
    sharedInvites: (j['shared_invites'] as num?)?.toInt() ?? 0,
    sharedChanges: (j['shared_changes'] as num?)?.toInt() ?? 0,
    unread: (j['unread'] as num?)?.toInt() ?? 0,
  );

  final int friendRequests;
  final String? partnerRequestFrom;
  final List<({String id, String hostName, bool voice})> cofocusInvites;
  final int sharedInvites;
  final int sharedChanges;
  final int unread;

  int get total =>
      friendRequests +
      (partnerRequestFrom == null ? 0 : 1) +
      cofocusInvites.length +
      sharedInvites +
      sharedChanges +
      unread;
}

/// Bir yayın bloğu: plan motorunun hesapladığı saatli oluşum (DB_SCHEMA §5, D44).
typedef PublishedBlock = ({String activityId, DateTime start, DateTime end});

/// Sosyal RPC'lerin istemcisi. Testler sahtesini kullanır.
class SocialApi {
  SocialApi(this._client);

  final SupabaseClient _client;

  String? get myId => _client.auth.currentUser?.id;

  Future<T> _call<T>(Future<T> Function() f) async {
    try {
      return await f().timeout(const Duration(seconds: 20));
    } on Object catch (e) {
      throw SocialException.from(e);
    }
  }

  Future<Object?> _rpc(String fn, [Json? params]) =>
      _call(() => _client.rpc(fn, params: params));

  Future<SocialStatus> status() async =>
      SocialStatus.fromJson(((await _rpc('social_status')) as Map).cast());

  Future<void> saveProfile({
    required String displayName,
    String? username,
    bool discoverable = false,
    bool globalLeaderboard = false,
    bool shareBrain = false,
  }) => _rpc('save_social_profile', {
    'p_display_name': displayName,
    'p_username': username,
    'p_discoverable': discoverable,
    'p_global_leaderboard': globalLeaderboard,
    'p_share_brain': shareBrain,
  });

  Future<FriendOverview> friends() async =>
      FriendOverview.fromJson(((await _rpc('friend_overview')) as Map).cast());

  Future<TogetherBadges> badges() async =>
      TogetherBadges.fromJson(((await _rpc('together_badges')) as Map).cast());

  Future<Invite> createInvite(String kind) async => Invite.fromJson(
    ((await _rpc('create_invite', {'p_kind': kind})) as Map).cast(),
  );
  Future<void> revokeInvite(String id) => _rpc('revoke_invite', {'p_id': id});

  /// Dönüş: (davet edenin adı, partnerlik kuruldu mu).
  Future<({String name, bool partner})> redeemInvite(String code) async {
    final r = ((await _rpc('redeem_invite', {'p_code': code})) as Map)
        .cast<String, Object?>();
    return (
      name: r['display_name'] as String? ?? '',
      partner: r['partner'] as bool? ?? false,
    );
  }

  Future<void> requestFriend(String username) =>
      _rpc('request_friend', {'p_username': username});
  Future<void> respondFriend(String friendshipId, bool accept) => _rpc(
    'respond_friend_request',
    {'p_friendship': friendshipId, 'p_accept': accept},
  );
  Future<void> removeFriend(String userId) =>
      _rpc('remove_friend', {'p_friend': userId});
  Future<void> requestPartner(String userId) =>
      _rpc('request_partner', {'p_friend': userId});
  Future<void> respondPartner(String userId, bool accept) =>
      _rpc('respond_partner', {'p_friend': userId, 'p_accept': accept});
  Future<void> endPartner(String userId) =>
      _rpc('end_partner', {'p_friend': userId});
  Future<void> block(String userId) => _rpc('block_user', {'p_user': userId});
  Future<void> unblock(String userId) =>
      _rpc('unblock_user', {'p_user': userId});

  Future<void> report({
    required String targetType,
    String? targetId,
    String? userId,
    required String reason,
    String? details,
  }) => _rpc('report_content', {
    'p_target_type': targetType,
    'p_target_id': targetId,
    'p_reason': reason,
    'p_details': details,
    'p_user': userId,
  });

  /// Görünürlük kuralı; [level] null kuralı siler (varsayılana döner).
  Future<void> setVisibility({
    String? level,
    String? audience,
    String? viewerId,
    String? categoryId,
    String? rootKey,
  }) => _rpc('set_visibility', {
    'p_level': level,
    'p_audience': audience,
    'p_viewer': viewerId,
    'p_category': categoryId,
    'p_root': rootKey,
  });

  /// Kendi kurallarım (RLS: yalnız sahibi okur).
  Future<List<Json>> myVisibility() => _call(
    () async =>
        (await _client
                .from('visibility_settings')
                .select(
                  'audience, viewer_id, category_id, root_category_key, level',
                )
                .isFilter('deleted_at', null))
            .cast<Json>(),
  );

  Future<void> publishCalendar(
    DateTime from,
    DateTime to,
    List<PublishedBlock> blocks,
  ) => _rpc('publish_calendar', {
    'p_window_start': from.toUtc().toIso8601String(),
    'p_window_end': to.toUtc().toIso8601String(),
    'p_blocks': [
      for (final b in blocks)
        {
          'activity_id': b.activityId,
          'start_at': b.start.toUtc().toIso8601String(),
          'end_at': b.end.toUtc().toIso8601String(),
        },
    ],
  });

  Future<List<CalendarEntry>> friendCalendar(
    String friendId,
    DateTime from,
    DateTime to,
  ) async => [
    for (final r in ((await _rpc('friend_calendar', {
      'p_friend': friendId,
      'p_from': from.toUtc().toIso8601String(),
      'p_to': to.toUtc().toIso8601String(),
    })) as List).cast<Map>())
      CalendarEntry.fromJson(r.cast()),
  ];

  Future<List<({DateTime start, DateTime end})>> commonFreeTime(
    List<String> friends,
    DateTime from,
    DateTime to,
    int minMinutes,
  ) async => [
    for (final r in ((await _rpc('common_free_time', {
      'p_users': friends,
      'p_from': from.toUtc().toIso8601String(),
      'p_to': to.toUtc().toIso8601String(),
      'p_min_minutes': minMinutes,
    })) as List).cast<Map>())
      (start: _time(r['start_at'])!, end: _time(r['end_at'])!),
  ];

  Future<String> openDirect(String friendId) async =>
      (await _rpc('open_direct', {'p_friend': friendId}))! as String;

  Future<List<ConversationSummary>> conversations() async => [
    for (final r
        in ((await _rpc('conversations_overview')) as List).cast<Map>())
      ConversationSummary.fromJson(r.cast()),
  ];

  /// Son [limit] mesaj, eskiden yeniye (RLS: yalnız açık sohbet üyesi okur).
  Future<List<ChatMessage>> messages(String conversationId, {int limit = 60}) =>
      _call(() async {
        final rows = await _client
            .from('messages')
            .select(
              'id, user_id, body, created_at, deleted_at, reactions(emoji, user_id, deleted_at)',
            )
            .eq('conversation_id', conversationId)
            .order('created_at', ascending: false)
            .limit(limit);
        return [for (final r in rows.reversed) ChatMessage.fromJson(r)];
      });

  Future<void> sendMessage(String conversationId, String body) =>
      _rpc('send_message', {'p_conversation': conversationId, 'p_body': body});
  Future<void> deleteMessage(String id) =>
      _rpc('delete_message', {'p_message': id});
  Future<void> toggleReaction(String messageId, String emoji) =>
      _rpc('toggle_reaction', {'p_message': messageId, 'p_emoji': emoji});
  Future<void> registerPushToken(String token) =>
      _rpc('register_push_token', {'p_token': token, 'p_platform': 'android'});

  Future<void> markRead(String conversationId) =>
      _rpc('mark_read', {'p_conversation': conversationId});
  Future<void> setMuted(String conversationId, bool muted) => _rpc(
    'set_conversation_muted',
    {'p_conversation': conversationId, 'p_muted': muted},
  );

  Future<List<SharedActivity>> shared() async => [
    for (final r in ((await _rpc('shared_overview')) as List).cast<Map>())
      SharedActivity.fromJson(r.cast()),
  ];

  Future<String> proposeShared({
    required String title,
    required List<String> participants,
    DateTime? start,
    DateTime? end,
    String? notes,
    String? rootKey,
    String kind = 'activity',
    int? totalMinutes,
  }) async =>
      (await _rpc('propose_shared_activity', {
            'p_title': title,
            'p_participants': participants,
            'p_start_at': start?.toUtc().toIso8601String(),
            'p_end_at': end?.toUtc().toIso8601String(),
            'p_notes': notes,
            'p_root': rootKey,
            'p_kind': kind,
            'p_total_minutes': totalMinutes,
          }))!
          as String;

  Future<void> respondShared(String id, bool accept) =>
      _rpc('respond_shared_activity', {'p_id': id, 'p_accept': accept});
  Future<void> leaveShared(String id) =>
      _rpc('leave_shared_activity', {'p_id': id});
  Future<void> proposeChange(String id, Json patch) =>
      _rpc('propose_shared_change', {'p_id': id, 'p_patch': patch});
  Future<void> respondChange(String changeId, bool accept) =>
      _rpc('respond_shared_change', {'p_change': changeId, 'p_accept': accept});
  Future<void> reportProgress(String id, int minutes) =>
      _rpc('report_shared_progress', {'p_id': id, 'p_minutes': minutes});

  Future<String> createCofocus(
    List<String> invitees, {
    required bool voice,
  }) async =>
      (await _rpc('create_cofocus', {
            'p_invitees': invitees,
            'p_voice': voice,
          }))!
          as String;
  Future<void> respondCofocus(String id, bool join) =>
      _rpc('respond_cofocus', {'p_id': id, 'p_join': join});
  Future<void> startCofocus(String id) => _rpc('start_cofocus', {'p_id': id});
  Future<void> setCofocusFocus(String id, String focusSessionId, String mode) =>
      _rpc('set_cofocus_focus', {
        'p_id': id,
        'p_focus_session': focusSessionId,
        'p_mode': mode,
      });
  Future<void> finishCofocus(String id, String outcome) =>
      _rpc('finish_cofocus', {'p_id': id, 'p_outcome': outcome});

  Future<CofocusState?> cofocusState(String id) async {
    final sent = DateTime.now();
    final r = await _rpc('cofocus_state', {'p_id': id});
    if (r == null) return null;
    // Gidiş-dönüşün yarısı: sunucu anı yanıtın ortasında okundu sayılır.
    final mid = sent.add(DateTime.now().difference(sent) ~/ 2);
    return CofocusState.fromJson((r as Map).cast(), receivedAt: mid);
  }

  Future<({String url, String token})> voiceToken(String cofocusId) =>
      _call(() async {
        final r = await _client.functions.invoke(
          'voice_token',
          body: {'cofocus_id': cofocusId},
        );
        final data = (r.data as Map).cast<String, Object?>();
        return (url: data['url']! as String, token: data['token']! as String);
      });

  Future<List<LeaderRow>> friendsLeaderboard() async => [
    for (final r in ((await _rpc('friends_leaderboard')) as List).cast<Map>())
      LeaderRow(
        r['display_name'] as String? ?? '',
        r['is_me'] as bool? ?? false,
        (r['focus_minutes'] as num?)?.toInt() ?? 0,
        (r['active_days'] as num?)?.toInt(),
      ),
  ];

  Future<List<LeaderRow>> globalLeaderboard() async => [
    for (final r in ((await _rpc('global_leaderboard')) as List).cast<Map>())
      LeaderRow(
        r['display_name'] as String? ?? '',
        r['is_me'] as bool? ?? false,
        (r['focus_minutes'] as num?)?.toInt() ?? 0,
        (r['active_days'] as num?)?.toInt(),
        rank: (r['rank'] as num?)?.toInt(),
      ),
  ];

  /// Sunucuda oturum kayıtlarından hesaplanan beyin (izin yoksa forbidden).
  Future<BrainState> brainOf(String userId) => _call(() async {
    final r = await _client.functions.invoke(
      'brain_snapshot',
      body: {'user_id': userId},
    );
    return BrainState.fromJson((r.data as Map).cast(), DateTime.now().toUtc());
  });

  /// Değişiklik olunca (arkadaşlık, mesaj, ortak işler) [onChange] çağrılır.
  RealtimeChannel watchChanges(void Function(String table, Json row) onChange) {
    final ch = _client.channel('together:${myId ?? 'anon'}');
    for (final t in const [
      'messages',
      'friendships',
      'cofocus_participants',
      'shared_activity_participants',
      'shared_activity_changes',
    ]) {
      ch.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: t,
        callback: (p) =>
            onChange(t, p.newRecord.isEmpty ? p.oldRecord : p.newRecord),
      );
    }
    return ch..subscribe();
  }

  /// Ortak odak kanalı: özel (RLS'li) presence + broadcast.
  RealtimeChannel cofocusChannel(String id) => _client.channel(
    'cofocus:$id',
    opts: const RealtimeChannelConfig(private: true, self: false),
  );

  Future<void> removeChannel(RealtimeChannel ch) => _client.removeChannel(ch);
}
