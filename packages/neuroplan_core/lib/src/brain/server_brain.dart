import '../focus/focus_clock.dart';
import '../plan/calendar.dart';
import 'brain_config.dart';
import 'brain_engine.dart';
import 'brain_fold.dart';

/// Sunucuda beyni oturum kayıtlarından yeniden hesaplar (ARCHITECTURE §7, Aşama 4B).
/// İstemcinin gönderdiği olay ya da anlık görüntüye güvenilmez; yalnız `focus_sessions`
/// satırları, sayılan geri dönüşler ve ortak odak bilgisi kullanılır. `brain_snapshot`
/// Edge Function'ı bunu `dart compile js` çıktısından çağırır.
///
/// Girdi: `{timezone, as_of, region_keys, weights: [{root_category_key, region_key, weight}],
/// sessions: [sunucu satırı], recovered_escapes: {oturum: n}, cofocus_peers: {oturum: n}}`.
/// Çıktı: [BrainState.toJson] + `engine_version`.
Map<String, Object?> serverBrain(Map<String, Object?> input) {
  final cal = PlanCalendar(input['timezone'] as String? ?? 'Etc/UTC');
  final asOf = DateTime.parse(input['as_of']! as String).toUtc();
  final weights = <String, Map<String, double>>{};
  for (final w in (input['weights']! as List).cast<Map>()) {
    (weights[w['root_category_key'] as String] ??= {})[w['region_key']
        as String] = (w['weight'] as num)
        .toDouble();
  }
  final escapes = _counts(input['recovered_escapes']);
  final peers = _counts(input['cofocus_peers']);
  final rows = [
    for (final r in (input['sessions']! as List).cast<Map>())
      if (r['ended_at'] != null &&
          r['deleted_at'] == null &&
          (r['outcome'] == 'completed' || r['outcome'] == 'broken'))
        r,
  ];
  final sessions = [
    for (final r in rows) _session(r.cast<String, Object?>(), cal, escapes, peers),
  ]..sort((a, b) => a.endedAt.compareTo(b.endedAt));

  final events = <String, BrainEventDraft>{};
  for (final s in sessions) {
    for (final e in deriveBrainEvents(s, sessions, weights)) {
      events.putIfAbsent(e.dedupeKey, () => e);
    }
  }
  final state = foldBrain(
    events.values,
    asOf,
    regionKeys: (input['region_keys']! as List).cast<String>(),
    sessionRoots: {
      for (final s in sessions)
        if (s.rootCategoryKey != null) s.id: s.rootCategoryKey!,
    },
  );
  return {...state.toJson(), 'engine_version': BrainConfig.engineVersion};
}

Map<String, int> _counts(Object? raw) => {
  for (final MapEntry(:key, :value) in ((raw as Map?) ?? const {}).entries)
    key as String: (value as num).toInt(),
};

BrainSession _session(
  Map<String, Object?> r,
  PlanCalendar cal,
  Map<String, int> escapes,
  Map<String, int> peers,
) {
  final id = r['id']! as String;
  final mode = FocusMode.fromJson(r['mode']! as String);
  final end = DateTime.parse(r['ended_at']! as String).toUtc();
  final clock = FocusClock(
    FocusSettings.fromJson(mode, (r['settings'] as Map?)?.cast<String, Object?>()),
    FocusClock.segmentsFromJson((r['segments'] as List?) ?? const []),
  );
  return BrainSession(
    id: id,
    rootCategoryKey: r['root_category_key'] as String?,
    mode: mode,
    outcome: r['outcome']! as String,
    focusedSeconds: (r['focused_seconds']! as num).toInt(),
    endedAt: end,
    day: cal.dayOf(end.millisecondsSinceEpoch ~/ 60000).iso,
    longestRunSeconds: clock.longestRun(end).inSeconds,
    completedCycles: clock.completedCycles(end),
    recoveredEscapes: escapes[id] ?? 0,
    cofocusPeersCompleted: peers[id] ?? 0,
  );
}
