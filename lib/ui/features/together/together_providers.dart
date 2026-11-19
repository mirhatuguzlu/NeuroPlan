import 'dart:async';

import 'package:drift/drift.dart' show BooleanExpressionOperators, Value;
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show RealtimeChannel;

import '../../../app/notifications.dart';
import '../../../app/providers.dart';
import '../../../data/local/app_database.dart';
import '../../../data/remote/social_api.dart';
import '../focus/focus_controller.dart';

/// null: arka uç yapılandırılmamış (`.env` yok) ya da test.
final socialApiProvider = Provider<SocialApi?>((ref) {
  final client = ref.watch(supabaseProvider);
  return client == null ? null : SocialApi(client);
});

/// Birlikte bölümünün kapısı (SOCIAL_SAFETY §5). Profil (doğum yılı) önce eşitlenir ki
/// sunucu yaşı bilsin.
final socialStatusProvider = FutureProvider<SocialStatus?>((ref) async {
  final api = ref.watch(socialApiProvider);
  final user = ref.watch(authUserProvider).value;
  if (api == null || user == null) return null;
  if (user.isAnonymous) {
    return const SocialStatus(
      anonymous: true,
      age: null,
      tier: SocialTier.none,
    );
  }
  await ref.read(syncSchedulerProvider)?.syncNow();
  return api.status();
});

SocialTier _tier(Ref ref) =>
    ref.watch(socialStatusProvider).value?.tier ?? SocialTier.none;

/// Sosyal açıkken çağrılır; değilse veri yok sayılır (ekranlar kapıdan geçmeden açılmaz).
Future<T> _social<T>(Ref ref, Future<T> Function(SocialApi api) f) {
  final api = ref.watch(socialApiProvider);
  if (api == null || _tier(ref) == SocialTier.none) {
    return Future.error(const SocialException(SocialError.notEligible));
  }
  return f(api);
}

final friendsProvider = FutureProvider<FriendOverview>(
  (ref) => _social(ref, (a) => a.friends()),
);
final badgesProvider = FutureProvider<TogetherBadges>(
  (ref) => _social(ref, (a) => a.badges()),
);
final conversationsProvider = FutureProvider<List<ConversationSummary>>(
  (ref) => _social(ref, (a) => a.conversations()),
);
final sharedProvider = FutureProvider<List<SharedActivity>>(
  (ref) => _social(ref, (a) => a.shared()),
);
final friendsBoardProvider = FutureProvider<List<LeaderRow>>(
  (ref) => _social(ref, (a) => a.friendsLeaderboard()),
);
final globalBoardProvider = FutureProvider<List<LeaderRow>>(
  (ref) => _social(ref, (a) => a.globalLeaderboard()),
);
final chatProvider = FutureProvider.family<List<ChatMessage>, String>(
  (ref, conversationId) => _social(ref, (a) => a.messages(conversationId)),
);
final visibilityRulesProvider = FutureProvider<List<Json>>(
  (ref) => _social(ref, (a) => a.myVisibility()),
);

/// Arkadaşın bugünden itibaren 7 günlük takvimi (görünürlük sunucuda uygulanmış).
final friendCalendarProvider =
    FutureProvider.family<List<CalendarEntry>, String>((ref, friendId) {
      final now = DateTime.now();
      final from = DateTime(now.year, now.month, now.day);
      return _social(
        ref,
        (a) =>
            a.friendCalendar(friendId, from, from.add(const Duration(days: 7))),
      );
    });

/// Sunucuda oturum kayıtlarından hesaplanan arkadaş beyni.
final friendBrainProvider = FutureProvider.family<BrainState, String>(
  (ref, friendId) => _social(ref, (a) => a.brainOf(friendId)),
);

/// Sosyal açıkken: canlı değişiklikleri dinler, takvimi yayınlar, ortak etkinlikleri plana
/// kopyalar, mesaj bildirimlerini gösterir. Uygulama kabuğu bunu canlı tutar.
final togetherLiveProvider = Provider<void>((ref) {
  final api = ref.watch(socialApiProvider);
  if (api == null || _tier(ref) == SocialTier.none) return;
  final live = _TogetherLive(ref, api);
  ref.onDispose(live.dispose);
  live.start();
});

class _TogetherLive with WidgetsBindingObserver {
  _TogetherLive(this.ref, this.api);

  final Ref ref;
  final SocialApi api;
  RealtimeChannel? _channel;
  Timer? _refresh;
  Timer? _publish;
  final _dirty = <String>{};
  var _foreground = true;
  var _heldMessages = 0;

  static const _messageChannel = 'together_messages';
  static const _messageNoticeId = 950;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    _channel = api.watchChanges(_onChange);
    ref.listen(horizonProvider, (_, _) => _schedulePublish());
    ref.listen(sharedProvider, (_, next) {
      if (next.value case final list?) unawaited(_mirror(list));
    });
    // Odak bitince bekleyen mesajlar tek özet bildirimle gelir.
    ref.listen(focusControllerProvider.select((s) => s.active), (was, now) {
      if (was == true && now == false && _heldMessages > 0) {
        unawaited(_notify(_heldMessages));
        _heldMessages = 0;
      }
    });
    _schedulePublish();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refresh?.cancel();
    _publish?.cancel();
    if (_channel case final ch?) unawaited(api.removeChannel(ch));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (_foreground) {
      ref.invalidate(badgesProvider);
      ref.invalidate(conversationsProvider);
    }
  }

  void _onChange(String table, Json row) {
    _dirty.add(table);
    if (table == 'messages' &&
        row['user_id'] != api.myId &&
        row['deleted_at'] == null) {
      _onIncomingMessage();
    }
    _refresh?.cancel();
    _refresh = Timer(const Duration(milliseconds: 400), _flush);
  }

  void _flush() {
    final t = {..._dirty};
    _dirty.clear();
    ref.invalidate(badgesProvider);
    if (t.contains('messages')) {
      ref.invalidate(conversationsProvider);
      ref.invalidate(chatProvider);
    }
    if (t.contains('friendships')) ref.invalidate(friendsProvider);
    if (t.any((x) => x.startsWith('shared'))) ref.invalidate(sharedProvider);
  }

  void _onIncomingMessage() {
    // Odak oturumu sırasında mesaj bildirimi gösterilmez (talimat §3); sonra özetlenir.
    if (ref.read(focusControllerProvider).active) {
      _heldMessages++;
      return;
    }
    if (!_foreground) unawaited(_notify(1));
  }

  Future<void> _notify(int count) async {
    final texts = ref.read(togetherTextsProvider).value;
    if (texts == null) return;
    final n = ref.read(notificationsProvider);
    await n.ensure();
    await n.plugin.show(
      id: _messageNoticeId,
      title: texts.title,
      body: texts.body(count),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _messageChannel,
          texts.channel,
          importance: Importance.defaultImportance,
        ),
      ),
    );
  }

  // ------------------------------------------------------------ takvim yayını (D44)

  void _schedulePublish() {
    _publish?.cancel();
    _publish = Timer(const Duration(seconds: 20), () => unawaited(publish()));
  }

  /// Önümüzdeki 14 günün saatli oluşumları; içerik yok, yalnız zaman ve aktivite kimliği.
  Future<void> publish() async {
    final view = ref.read(horizonProvider).value;
    if (view == null) return;
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from.add(const Duration(days: 14));
    final blocks = <PublishedBlock>[
      for (final i in view.output.instances)
        if (i.start != null &&
            i.end != null &&
            i.end! > i.start! &&
            (i.status == InstanceStatus.planned ||
                i.status == InstanceStatus.done))
          (
            activityId: i.activityId,
            start: DateTime.fromMillisecondsSinceEpoch(
              i.start! * 60000,
              isUtc: true,
            ),
            end: DateTime.fromMillisecondsSinceEpoch(
              i.end! * 60000,
              isUtc: true,
            ),
          ),
    ].where((b) => b.end.isAfter(from) && b.start.isBefore(to)).toList();
    try {
      await api.publishCalendar(from, to, blocks);
    } on Object catch (e) {
      debugPrint('[together] takvim yayınlanamadı: $e');
    }
  }

  // ------------------------------------------------------------ ortak etkinlik kopyası

  /// Onaylanmış ve benim kabul ettiğim ortak etkinlik planıma sabit iş olarak düşer; iptal
  /// edilen ya da ayrıldığım etkinliğin kopyası silinir. İlerleme kendi odak dakikamdır.
  Future<void> _mirror(List<SharedActivity> list) async {
    final me = api.myId;
    final data = ref.read(planDataProvider).value;
    if (me == null || data == null) return;
    final repo = ref.read(activityRepositoryProvider);
    final db = ref.read(databaseProvider);
    for (final s in list) {
      final id = sharedMirrorActivityId(s.id);
      final mine = s.participant(me)?.status == 'accepted';
      final keep = mine && s.status == 'confirmed';
      final existing = await repo.get(id);
      try {
        if (!keep) {
          if (existing != null && existing.deletedAt == null) {
            await repo.delete(id);
          }
          continue;
        }
        final fields = ActivitiesCompanion(
          kind: Value(s.kind == 'project' ? 'project' : 'one_off'),
          title: Value(s.title),
          notes: Value(s.notes),
          rootCategoryKey: Value(s.rootCategoryKey),
          deletedAt: const Value(null),
        );
        if (existing == null) {
          await repo.create(fields.copyWith(id: Value(id)));
        } else if (existing.title != s.title ||
            existing.notes != s.notes ||
            existing.rootCategoryKey != s.rootCategoryKey ||
            existing.deletedAt != null) {
          await repo.update(id, fields);
        }
        await _mirrorTime(s, id, data.calendar);
        if (s.kind == 'project' && s.totalMinutes != null) {
          await repo.saveProject(
            id,
            ProjectsCompanion(
              totalMinutes: Value(s.totalMinutes),
              deadlineAt: Value(s.end?.toUtc()),
            ),
          );
        }
        final minutes = await _focusedMinutes(db, id);
        if (minutes != (s.participant(me)?.progressMinutes ?? 0)) {
          await api.reportProgress(s.id, minutes);
        }
      } on Object catch (e) {
        debugPrint('[together] ortak etkinlik kopyalanamadı: $e');
      }
    }
  }

  Future<void> _mirrorTime(
    SharedActivity s,
    String activityId,
    PlanCalendar cal,
  ) async {
    if (s.kind == 'project' || s.start == null || s.end == null) return;
    final repo = ref.read(activityRepositoryProvider);
    final ruleId = sharedMirrorRuleId(s.id);
    final startMin = s.start!.millisecondsSinceEpoch ~/ 60000;
    final minuteOfDay = cal.minuteOfDay(startMin);
    final duration = s.end!.difference(s.start!).inMinutes;
    final rule = ScheduleRulesCompanion(
      recurrence: Value(OnceRecurrence(cal.dayOf(startMin).iso)),
      timing: Value(
        Timing(
          start: [
            TimeConstraint(
              ConstraintOp.at,
              ClockRef(minuteOfDay ~/ 60, minuteOfDay % 60),
            ),
          ],
        ),
      ),
      durationMinMinutes: Value(duration),
      durationMaxMinutes: Value(duration),
      flexibility: const Value('fixed'),
      deletedAt: const Value(null),
    );
    final db = ref.read(databaseProvider);
    final existing = await ref
        .read(writerProvider)
        .find(db.scheduleRules, ruleId);
    if (existing == null) {
      await repo.addRule(
        rule.copyWith(id: Value(ruleId), activityId: Value(activityId)),
      );
    } else {
      await repo.updateRule(ruleId, rule);
    }
  }

  Future<int> _focusedMinutes(AppDatabase db, String activityId) async {
    final rows =
        await (db.select(db.focusSessions)..where(
              (f) =>
                  f.activityId.equals(activityId) &
                  f.outcome.equals('completed') &
                  f.deletedAt.isNull(),
            ))
            .get();
    return rows.fold<int>(0, (t, r) => t + r.focusedSeconds) ~/ 60;
  }
}

/// Bildirim metinleri (ARB'den; uygulama kökü yerelleştirme hazır olunca doldurur).
class TogetherTexts {
  const TogetherTexts({
    required this.title,
    required this.channel,
    required this.body,
  });
  final String title;
  final String channel;
  final String Function(int count) body;
}

/// Uygulama kökü her derlemede günceller; bildirim gösterirken okunur.
class TogetherTextsHolder {
  TogetherTexts? value;
}

final togetherTextsProvider = Provider((ref) => TogetherTextsHolder());
