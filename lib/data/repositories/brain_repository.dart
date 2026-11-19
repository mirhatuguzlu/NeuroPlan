import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';
import '../sync/local_writer.dart';
import 'prefs_repository.dart';

/// Bir bölgenin son 30 günü (bölge sayfası, BRAIN-4).
class RegionStats {
  const RegionStats({
    required this.days,
    required this.minutesByCategory,
    required this.totalMinutes,
  });

  /// En eskiden bugüne 30 gün: o gün bu bölgeye giden kazanç (nöron, tamsayı).
  final List<({String day, int neurons})> days;

  /// Bu bölgeyi besleyen oturumların süresi: kullanıcı kategorisi (yoksa kök) → dakika.
  /// Anahtar `cat:<id>` ya da `root:<key>`.
  final Map<String, int> minutesByCategory;
  final int totalMinutes;
}

/// Beyin olayları: türetme (v2), yeniden kurma, katlama ve önbellek (ARCHITECTURE §7).
class BrainRepository {
  BrainRepository(this._db, this._writer, this._prefs);

  final AppDatabase _db;
  final LocalWriter _writer;
  final PrefsRepository _prefs;

  static const rebuiltKey = 'brain.rebuilt_v$brainEngineVersion';
  static const seedKey = 'brain.seed';
  static const lastSeenKey = 'pref.brain_last_seen';

  Future<PlanCalendar> _calendar() async {
    final p = await _db.select(_db.profiles).getSingleOrNull();
    return PlanCalendar(p?.timezone ?? 'Etc/UTC');
  }

  /// Kök kategori → bölge → ağırlık.
  Future<Map<String, Map<String, double>>> _weights() async {
    final out = <String, Map<String, double>>{};
    for (final w in await _db.select(_db.categoryRegionWeights).get()) {
      (out[w.rootCategoryKey] ??= {})[w.regionKey] = w.weight;
    }
    return out;
  }

  Future<BrainSession> _toBrain(FocusSession s, PlanCalendar cal) async {
    final end = s.endedAt ?? s.startedAt;
    final mode = FocusMode.fromJson(s.mode);
    final clock = FocusClock(
      FocusSettings.fromJson(mode, s.settings),
      FocusClock.segmentsFromJson(s.segments),
    );
    final escapes =
        await (_db.selectOnly(_db.focusInterruptions)
              ..addColumns([_db.focusInterruptions.id.count()])
              ..where(
                _db.focusInterruptions.sessionId.equals(s.id) &
                    _db.focusInterruptions.counted.equals(true) &
                    _db.focusInterruptions.recovered.equals(true),
              ))
            .map((r) => r.read(_db.focusInterruptions.id.count()) ?? 0)
            .getSingle();
    return BrainSession(
      id: s.id,
      rootCategoryKey: s.rootCategoryKey,
      mode: mode,
      outcome: s.outcome,
      focusedSeconds: s.focusedSeconds,
      endedAt: end.toUtc(),
      day: cal.dayOf(end.millisecondsSinceEpoch ~/ 60000).iso,
      longestRunSeconds: clock.longestRun(end).inSeconds,
      completedCycles: clock.completedCycles(end),
      recoveredEscapes: escapes,
    );
  }

  /// Biten oturumların hepsi, bitiş sırasıyla.
  Future<List<FocusSession>> _ended({DateTime? from, DateTime? to}) =>
      (_db.select(_db.focusSessions)
            ..where(
              (s) =>
                  s.deletedAt.isNull() &
                  s.endedAt.isNotNull() &
                  s.outcome.isIn(const ['completed', 'broken']) &
                  (from == null
                      ? const Constant(true)
                      : s.endedAt.isBiggerOrEqualValue(from)) &
                  (to == null
                      ? const Constant(true)
                      : s.endedAt.isSmallerOrEqualValue(to)),
            )
            ..orderBy([(s) => OrderingTerm(expression: s.endedAt)]))
          .get();

  /// Biten oturumdan olayları türetir ve yazar; aynı olay ikinci kez yazılmaz.
  /// Eklenen olayları döndürür (animasyon için).
  Future<List<BrainEventDraft>> deriveFor(String sessionId) async {
    final s = await _writer.find(_db.focusSessions, sessionId);
    if (s == null || s.endedAt == null) return const [];
    final cal = await _calendar();
    final weights = await _weights();
    final end = s.endedAt!;
    final history = [
      for (final o in await _ended(
        from: end.subtract(const Duration(days: 8)),
        to: end,
      ))
        if (o.id != s.id) await _toBrain(o, cal),
    ];
    return _append(deriveBrainEvents(await _toBrain(s, cal), history, weights));
  }

  Future<List<BrainEventDraft>> _append(List<BrainEventDraft> events) async {
    final added = <BrainEventDraft>[];
    for (final e in events) {
      final ok = await _writer.append(
        _db.brainEvents,
        BrainEventsCompanion.insert(
          id: newId(),
          type: e.type,
          regionKey: Value(e.regionKey),
          regionBKey: Value(e.regionBKey),
          amount: e.amount,
          occurredAt: e.occurredAt,
          sessionId: Value(e.sessionId),
          dedupeKey: e.dedupeKey,
          engineVersion: e.engineVersion,
        ),
      );
      if (ok) added.add(e);
    }
    return added;
  }

  /// Motor sürümü değişince (Drift v2 göçü eski olayları sildi) bütün oturumlardan
  /// olayları yeniden türetir. Bir kez çalışır; tekilleştirme yeniden çalışmayı zararsız kılar.
  Future<void> rebuildIfNeeded() async {
    if (await _prefs.get(rebuiltKey) != null) return;
    final cal = await _calendar();
    final weights = await _weights();
    final sessions = [for (final s in await _ended()) await _toBrain(s, cal)];
    for (final s in sessions) {
      await _append(deriveBrainEvents(s, sessions, weights));
    }
    await _prefs.set(rebuiltKey, DateTime.now().toUtc().toIso8601String());
  }

  /// Nöron yerleşiminin tohumu. shortcut: giriş henüz yok, kurulum başına rastgele kimlik;
  /// giriş aşamasında Supabase kullanıcı kimliğine geçilecek.
  Future<String> seed() async {
    final saved = await _prefs.get(seedKey);
    if (saved != null) return saved;
    final id = newId();
    await _prefs.set(seedKey, id);
    return id;
  }

  static BrainEventDraft _draft(BrainEvent e) => BrainEventDraft(
    type: e.type,
    regionKey: e.regionKey ?? '',
    regionBKey: e.regionBKey,
    amount: e.amount,
    occurredAt: e.occurredAt.toUtc(),
    sessionId: e.sessionId,
    dedupeKey: e.dedupeKey,
    engineVersion: e.engineVersion,
  );

  /// Geçerli motor sürümünün olayları ve oturum → kök kategori eşlemesi.
  Stream<BrainHistory> watchHistory() {
    final q = _db.select(_db.brainEvents)
      ..where(
        (e) =>
            e.deletedAt.isNull() & e.engineVersion.equals(brainEngineVersion),
      );
    return q.watch().asyncMap((rows) async {
      final roots = <String, String>{};
      for (final s in await _ended()) {
        if (s.rootCategoryKey != null) roots[s.id] = s.rootCategoryKey!;
      }
      return BrainHistory([for (final r in rows) _draft(r)], roots);
    });
  }

  /// Bugünkü durumun önbelleği (`brain_snapshots`): olay özeti aynıysa yeniden yazılmaz.
  Future<void> cache(BrainState state, BrainHistory h) async {
    final hash = eventsHash([for (final e in h.events) e.dedupeKey]);
    final cur =
        await (_db.select(_db.brainSnapshots)
              ..where((s) => s.engineVersion.equals(brainEngineVersion)))
            .getSingleOrNull();
    if (cur?.eventsHash == hash) return;
    await _db
        .into(_db.brainSnapshots)
        .insertOnConflictUpdate(
          BrainSnapshotsCompanion.insert(
            engineVersion: Value(brainEngineVersion),
            asOf: state.asOf,
            eventsHash: hash,
            state: state.toJson(),
          ),
        );
  }

  Future<RegionStats> regionStats(String regionKey, DateTime now) async {
    final cal = await _calendar();
    final today = cal.dayOf(now.millisecondsSinceEpoch ~/ 60000);
    final first = today.add(-29);
    final from = now.subtract(const Duration(days: 31));
    final gains =
        await (_db.select(_db.brainEvents)..where(
              (e) =>
                  e.deletedAt.isNull() &
                  e.engineVersion.equals(brainEngineVersion) &
                  e.type.equals('neuron_gain') &
                  e.regionKey.equals(regionKey) &
                  e.occurredAt.isBiggerOrEqualValue(from),
            ))
            .get();
    final perDay = <String, int>{};
    final sessionIds = <String>{};
    for (final g in gains) {
      final d = cal.dayOf(g.occurredAt.millisecondsSinceEpoch ~/ 60000);
      if (d.isBefore(first)) continue;
      perDay[d.iso] = (perDay[d.iso] ?? 0) + g.amount;
      if (g.sessionId != null) sessionIds.add(g.sessionId!);
    }
    final byCat = <String, int>{};
    var total = 0;
    if (sessionIds.isNotEmpty) {
      final sessions = await (_db.select(
        _db.focusSessions,
      )..where((s) => s.id.isIn(sessionIds))).get();
      for (final s in sessions) {
        final key = s.categoryId != null
            ? 'cat:${s.categoryId}'
            : 'root:${s.rootCategoryKey}';
        final m = s.focusedSeconds ~/ 60;
        byCat[key] = (byCat[key] ?? 0) + m;
        total += m;
      }
    }
    return RegionStats(
      days: [
        for (var i = 0; i < 30; i++)
          (
            day: first.add(i).iso,
            neurons: (perDay[first.add(i).iso] ?? 0) ~/ unitsPerNeuron,
          ),
      ],
      minutesByCategory: byCat,
      totalMinutes: total,
    );
  }

  /// Son görülenden sonraki kazanç / ceza olayları; sekme açılınca oynatılır.
  Future<List<BrainEventDraft>> unseen(BrainHistory h) async {
    final raw = await _prefs.get(lastSeenKey);
    final since = raw == null ? null : DateTime.tryParse(raw);
    return [
      for (final e in h.events)
        if ((e.type == 'neuron_gain' || e.type == 'penalty') &&
            since != null &&
            e.occurredAt.isAfter(since))
          e,
    ];
  }

  Future<void> markSeen(DateTime at) =>
      _prefs.set(lastSeenKey, at.toUtc().toIso8601String());
}

/// Katlamanın girdisi: olaylar + oturum kökleri.
class BrainHistory {
  const BrainHistory(this.events, this.sessionRoots);
  final List<BrainEventDraft> events;
  final Map<String, String> sessionRoots;

  DateTime? get first => events.isEmpty
      ? null
      : events.map((e) => e.occurredAt).reduce((a, b) => a.isBefore(b) ? a : b);
}
