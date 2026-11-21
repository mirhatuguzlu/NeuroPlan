import 'dart:math' as math;

import '../ids.dart';
import '../model/recurrence.dart';
import '../model/timing.dart';
import 'astro.dart';
import 'calendar.dart';
import 'chunk_planner.dart';
import 'plan_types.dart';
import 'timeline.dart';

/// Algoritma değişince artar (docs/ARCHITECTURE.md §6, determinizm kuralı 5).
const planEngineVersion = 3;

/// Deterministik plan motoru: aynı girdi aynı planı üretir (SLOT-6).
///
/// Yerleştirme sırası: (0) kullanıcının sabitlediği oluşumlar, (1) sabit saatli ve
/// astronomik çapalı işler, (2) göreli işler (çapalarından sonra), (3) zaman pencereliler,
/// (4) saatsiz işler ve "dönem başına N kez", (5) proje parçaları, (6) kalan boş zaman.
final class PlanEngine {
  const PlanEngine({this.chunkPlanner = const EarliestDeadlinePlanner()});

  final ChunkPlanner chunkPlanner;

  PlanOutput plan(PlanInput input) => _Run(input, chunkPlanner).run();
}

final class _Occ {
  _Occ({
    required this.id,
    required this.activityId,
    required this.day,
    required this.flex,
    required this.timing,
    this.rule,
    this.dMin,
    this.dMax,
    this.variantId,
    this.persisted,
    this.source = InstanceSource.rule,
    this.parentInstanceId,
  });

  final String id;
  final String activityId;
  final Day day;
  final Flexibility flex;
  final Timing timing;
  final PlanRule? rule;
  final int? dMin;
  final int? dMax;
  final String? variantId;
  final PersistedInstance? persisted;
  final InstanceSource source;
  String? parentInstanceId;

  /// Gün içine dağıtılan derin çalışma bloğu (D66): sırası, sayısı ve önceki blok.
  int? block;
  int? blocks;
  String? after;
  int afterGap = 0;

  int? start;
  int? end;
  bool suggested = false;
  String? anchorActivityId;
  int? rank;
  int depth = 0;

  InstanceStatus get status => persisted?.status ?? InstanceStatus.planned;
  bool get active =>
      status == InstanceStatus.planned || status == InstanceStatus.done;

  /// Kullanıcının sabitlediği oluşum: motor saatini değiştirmez.
  bool get pinned =>
      persisted != null &&
      (persisted!.isManual ||
          persisted!.source != InstanceSource.rule ||
          persisted!.status == InstanceStatus.done) &&
      persisted!.start != null &&
      persisted!.end != null;
}

final class _DayRule {
  var keep = DayKeep.all;
  var auto = true;
  var hasOverride = false;

  /// Plansız gün: boş zaman hesaplanmaz, proje yerleşmez (DB_SCHEMA §3.7).
  bool get unplanned => hasOverride && !auto;
}

final class _Run {
  _Run(this.input, this.planner)
    : cal = PlanCalendar(input.settings.timezone),
      astro = AstroClock(
        latitude: input.settings.latitude,
        longitude: input.settings.longitude,
        prayerMethod: input.settings.prayerMethod,
        madhab: input.settings.prayerMadhab,
      );

  final PlanInput input;
  final ChunkPlanner planner;
  final PlanCalendar cal;
  final AstroClock astro;
  final timeline = Timeline();
  final issues = <PlanIssue>[];
  final choices = <VariantChoice>[];
  final occs = <_Occ>[];

  late final Day from = Day.parse(input.from);
  late final Day to = Day.parse(input.to);
  late final Day today = cal.dayOf(input.asOf);
  late Day wFrom;
  late Day wTo;
  late final RecurrenceDays days;

  late final Map<String, PlanActivity> activities;
  late final Map<String, PlanVariant> variants;
  late final Map<String, PlanVariantGroup> groupsById;
  late final Map<String, PlanVariantGroup> groupByActivity;
  late final Map<String, PersistedInstance> persistedById;
  final _consumed = <String>{};
  final _dayRules = <int, _DayRule>{};
  final _byActDay = <String, List<_Occ>>{};
  final _byId = <String, _Occ>{};

  /// "aktivite|gün" → (uygulanan varyant, oluşum kimliği): varyanta özel alt aktiviteler için.
  final _variantOnDay = <String, (String, String)>{};
  final _missingReported = <String>{};

  static String _key(String activityId, Day day) => '$activityId|${day.index}';

  PlanOutput run() {
    final rules = [...input.rules]..sort((a, b) => a.id.compareTo(b.id));
    activities = {for (final a in input.activities) a.id: a};
    variants = {for (final v in input.variants) v.id: v};
    groupsById = {for (final g in input.variantGroups) g.id: g};
    groupByActivity = {
      for (final g in [
        ...input.variantGroups,
      ]..sort((a, b) => b.id.compareTo(a.id)))
        g.activityId: g,
    };
    persistedById = {for (final p in input.instances) p.id: p};

    // Çalışma aralığı: önceki gün (gece yarısını aşan işler bugünü doldurur) ve
    // "dönem başına N kez" kurallarının tam dönemleri.
    wFrom = from.add(-1);
    wTo = to;
    for (final r in rules) {
      if (r.recurrence case PerPeriodRecurrence(:final unit)) {
        final (s, _) = _period(unit, from);
        final (_, e) = _period(unit, to);
        if (s.isBefore(wFrom)) wFrom = s;
        if (e.isAfter(wTo)) wTo = e;
      }
    }
    days = RecurrenceDays(wFrom, wTo);

    _generate(rules);
    _addPersistedExtras();
    final cyclic = _detectCycles(rules);

    final ordered = [
      for (final o in occs)
        if (!o.pinned && o.active) o,
    ];
    for (final o in occs.where((o) => o.pinned)) {
      _put(o, o.persisted!.start!, o.persisted!.end!);
    }
    for (final o in ordered) {
      _rankOf(o, cyclic);
    }
    int cmp(_Occ a, _Occ b) {
      for (final c in [
        a.rank!.compareTo(b.rank!),
        a.depth.compareTo(b.depth),
        a.flex.index.compareTo(b.flex.index),
        a.day.index.compareTo(b.day.index),
        (activities[a.activityId]?.priority ?? 2).compareTo(
          activities[b.activityId]?.priority ?? 2,
        ),
        a.activityId.compareTo(b.activityId),
        a.id.compareTo(b.id),
      ]) {
        if (c != 0) return c;
      }
      return 0;
    }

    ordered.sort(cmp);
    for (final o in ordered.where((o) => o.rank! < 4)) {
      _place(o, cyclic);
    }
    final perPeriod = _distributePerPeriod(rules)
      ..forEach((o) {
        _rankOf(o, cyclic);
        o.rank = math.max(o.rank!, 4);
      });
    final late = [...ordered.where((o) => o.rank! >= 4), ...perPeriod]
      ..sort(cmp);
    for (final o in late) {
      _place(o, cyclic);
    }

    final chunks = _planProjects();
    return _output(chunks);
  }

  // ------------------------------------------------------------ takvim

  (Day, Day) _period(PeriodUnit unit, Day d) => switch (unit) {
    PeriodUnit.day => (d, d),
    PeriodUnit.week => (d.add(1 - d.weekday), d.add(7 - d.weekday)),
    PeriodUnit.month => (
      Day.parse('${d.iso.substring(0, 7)}-01'),
      Day(
        DateTime.utc(d.utc.year, d.utc.month + 1).millisecondsSinceEpoch ~/
            86400000,
      ).add(-1),
    ),
  };

  bool _inRange(Day d, String? validFrom, String? validUntil) =>
      (validFrom == null || !d.isBefore(Day.parse(validFrom))) &&
      (validUntil == null || !d.isAfter(Day.parse(validUntil)));

  _DayRule _dayRule(Day d) => _dayRules.putIfAbsent(d.index, () {
    final r = _DayRule();
    for (final o in input.dayOverrides) {
      final matches = o.date != null
          ? Day.parse(o.date!) == d
          : _inRange(d, o.validFrom, o.validUntil) &&
                days.occurs(o.recurrence!, d);
      if (!matches) continue;
      r.hasOverride = true;
      if (o.keep.index > r.keep.index) r.keep = o.keep;
      r.auto = r.auto && o.autoPlacement;
    }
    return r;
  });

  bool _keepAllows(Flexibility flex, Day d) => switch (_dayRule(d).keep) {
    DayKeep.all => true,
    DayKeep.fixedOnly => flex == Flexibility.fixed,
    DayKeep.none => false,
  };

  int _floor(Day d) =>
      d == today ? math.max(cal.dayStart(d), input.asOf) : cal.dayStart(d);

  Iterable<Day> _span(Day a, Day b) sync* {
    for (var d = a; !d.isAfter(b); d = d.add(1)) {
      yield d;
    }
  }

  // ------------------------------------------------------------ genişletme

  void _generate(List<PlanRule> rules) {
    bool isSub(PlanRule r) => activities[r.activityId]?.variantId != null;
    final base = [
      for (final r in rules)
        if (r.recurrence is! FollowRecurrence &&
            r.recurrence is! PerPeriodRecurrence)
          r,
    ];
    // Varyant grubu olan aktiviteler önce: alt aktiviteler seçimi bilmeli.
    for (final r in [...base.where((r) => !isSub(r)), ...base.where(isSub)]) {
      final exceptions = {for (final d in r.exceptionDates) Day.parse(d).index};
      for (final d in _span(wFrom, wTo)) {
        if (!_inRange(d, r.validFrom, r.validUntil) ||
            exceptions.contains(d.index) ||
            !days.occurs(r.recurrence, d)) {
          continue;
        }
        _emit(r, d, ruleInstanceId(r.id, d.iso));
      }
    }

    _prepassPerPeriod(rules);

    // follow: çapaların hepsi o gün oluşursa oluşur; zincirler için sabit noktaya kadar.
    final follows = [
      for (final r in rules)
        if (r.recurrence is FollowRecurrence) r,
    ];
    var changed = true;
    while (changed) {
      changed = false;
      for (final r in follows) {
        final anchors = r.timing.anchorActivityIds;
        if (anchors.isEmpty) continue;
        final exceptions = {
          for (final d in r.exceptionDates) Day.parse(d).index,
        };
        for (final d in _span(wFrom, wTo)) {
          final id = ruleInstanceId(r.id, d.iso);
          if (_consumed.contains(id) ||
              !_inRange(d, r.validFrom, r.validUntil) ||
              exceptions.contains(d.index) ||
              !anchors.every(
                (a) => _byActDay[_key(a, d)]?.any((o) => o.active) ?? false,
              )) {
            continue;
          }
          final o = _emit(r, d, id);
          if (o != null) {
            o.parentInstanceId ??= _byActDay[_key(anchors.first, d)]!.first.id;
            changed = true;
          }
        }
      }
    }
  }

  /// Kuraldan oluşum üretir: gün kuralı, varyanta özel alt aktivite ve varyant uygulanır.
  _Occ? _emit(PlanRule r, Day d, String id) {
    _consumed.add(id);
    final act = activities[r.activityId];
    if (act == null || !_keepAllows(r.flexibility, d)) return null;
    String? parent;
    if (act.variantId case final vid?) {
      final applied = _variantOnDay[_key(_groupActivityOf(vid) ?? '', d)];
      if (applied == null || applied.$1 != vid) return null;
      parent = applied.$2;
    }
    final persisted = persistedById[id];
    var timing = r.timing;
    var dMin = r.durationMin;
    var dMax = r.durationMax;
    String? variantId;
    final group = groupByActivity[act.id];
    if (group != null &&
        (group.appliesOn == null || days.occurs(group.appliesOn!, d))) {
      final selected = persisted?.variantId ?? group.defaultVariantId;
      choices.add(
        VariantChoice(
          instanceId: id,
          activityId: act.id,
          ruleId: r.id,
          date: d.iso,
          groupId: group.id,
          selectedVariantId: selected,
          explicit: persisted?.variantId != null,
        ),
      );
      final v = variants[selected];
      if (v != null && v.groupId == group.id) {
        variantId = v.id;
        _variantOnDay[_key(act.id, d)] = (v.id, id);
        if (v.cancelsOccurrence) return null;
        timing = v.timing ?? timing;
        dMin = v.durationMin ?? dMin;
        dMax = v.durationMax ?? dMax;
      }
    }
    // Kesin olmayan, gün içine dağıtılan derin çalışma: her blok ayrı oluşum (D66).
    final blocks = act.blocks;
    final focus = dMax ?? dMin ?? act.estimatedMinutes;
    final parts =
        blocks != null &&
            blocks.spread &&
            r.flexibility != Flexibility.fixed &&
            focus != null
        ? blocks.parts(focus)
        : const <int>[];
    if (parts.length > 1) dMin = dMax = parts.first;
    final o = _Occ(
      id: id,
      activityId: act.id,
      day: d,
      flex: r.flexibility,
      timing: timing,
      rule: r,
      dMin: dMin,
      dMax: dMax,
      variantId: variantId,
      persisted: persisted,
      parentInstanceId: parent,
    );
    _add(o);
    if (parts.length > 1) {
      o
        ..block = 1
        ..blocks = parts.length;
      var prev = o;
      for (var k = 2; k <= parts.length; k++) {
        final childId = blockInstanceId(id, k);
        _consumed.add(childId);
        final child =
            _Occ(
                id: childId,
                activityId: act.id,
                day: d,
                flex: r.flexibility,
                timing: Timing.none,
                rule: r,
                dMin: parts[k - 1],
                dMax: parts[k - 1],
                variantId: variantId,
                persisted: persistedById[childId],
                parentInstanceId: parent,
              )
              ..block = k
              ..blocks = parts.length
              ..after = prev.id
              ..afterGap = blocks!.restAfter(k - 1);
        _add(child);
        prev = child;
      }
    }
    return o;
  }

  String? _groupActivityOf(String variantId) =>
      groupsById[variants[variantId]?.groupId]?.activityId;

  void _add(_Occ o) {
    occs.add(o);
    _byId[o.id] = o;
    (_byActDay[_key(o.activityId, o.day)] ??= []).add(o);
  }

  /// Kurala bağlı olmayan kalıcı oluşumlar: elle eklenenler, proje parçaları, taşınanlar.
  void _addPersistedExtras() {
    for (final p in [
      ...input.instances,
    ]..sort((a, b) => a.id.compareTo(b.id))) {
      if (_consumed.contains(p.id) || !activities.containsKey(p.activityId)) {
        continue;
      }
      final d = Day.parse(p.date);
      if (d.isBefore(wFrom) || d.isAfter(wTo)) continue;
      _add(
        _Occ(
          id: p.id,
          activityId: p.activityId,
          day: d,
          flex: Flexibility.fixed,
          timing: Timing.none,
          persisted: p,
          source: p.source,
        ),
      );
    }
  }

  // ------------------------------------------------------------ dönem başına N kez

  Iterable<(PlanRule, int, Day, Day)> _periods(List<PlanRule> rules) sync* {
    for (final r in rules) {
      if (r.recurrence case PerPeriodRecurrence(:final count, :final unit)) {
        var (s, e) = _period(unit, wFrom);
        while (!s.isAfter(wTo)) {
          yield (r, count, s, e);
          (s, e) = _period(unit, e.add(1));
        }
      }
    }
  }

  void _prepassPerPeriod(List<PlanRule> rules) {
    for (final (r, count, s, _) in _periods(rules)) {
      for (var i = 0; i < count; i++) {
        final id = perPeriodInstanceId(r.id, s.iso, i);
        final p = persistedById[id];
        if (p != null) _emit(r, Day.parse(p.date), id);
      }
    }
  }

  /// Kalan oluşumları boş zamanı en çok olan günlere dağıtır; eşitlikte erken gün (S5).
  List<_Occ> _distributePerPeriod(List<PlanRule> rules) {
    final out = <_Occ>[];
    final free = <int, int>{};
    for (final (r, count, s, e) in _periods(rules)) {
      final act = activities[r.activityId];
      if (act == null) continue;
      final exceptions = {for (final d in r.exceptionDates) Day.parse(d).index};
      final candidates = [
        for (final d in _span(
          [s, today, wFrom].reduce((a, b) => a.isAfter(b) ? a : b),
          e.isAfter(wTo) ? wTo : e,
        ))
          if (_inRange(d, r.validFrom, r.validUntil) &&
              !exceptions.contains(d.index) &&
              _keepAllows(r.flexibility, d))
            d,
      ];
      final used = <int, int>{};
      for (var i = 0; i < count; i++) {
        final id = perPeriodInstanceId(r.id, s.iso, i);
        if (persistedById[id] case final p?) {
          final d = Day.parse(p.date).index;
          used[d] = (used[d] ?? 0) + 1;
        }
      }
      final d = r.durationMax ?? r.durationMin ?? act.estimatedMinutes ?? 0;
      for (var i = 0; i < count && candidates.isNotEmpty; i++) {
        final id = perPeriodInstanceId(r.id, s.iso, i);
        if (_consumed.contains(id)) continue;
        int freeOf(Day day) => free.putIfAbsent(
          day.index,
          () => timeline.freeMinutes(_floor(day), cal.dayEnd(day)),
        );
        final best = candidates.reduce((a, b) {
          final ua = used[a.index] ?? 0, ub = used[b.index] ?? 0;
          if (ua != ub) return ua < ub ? a : b;
          final fa = freeOf(a), fb = freeOf(b);
          if (fa != fb) return fa > fb ? a : b;
          return a.isBefore(b) ? a : b;
        });
        used[best.index] = (used[best.index] ?? 0) + 1;
        free[best.index] = freeOf(best) - d;
        final o = _emit(r, best, id);
        if (o != null) out.add(o);
      }
    }
    return out;
  }

  // ------------------------------------------------------------ bağımlılık

  /// Göreli çapalardaki döngüler (Tarjan); döngüdeki aktivitelerin oluşumları saatsiz kalır.
  Set<String> _detectCycles(List<PlanRule> rules) {
    final edges = <String, Set<String>>{};
    for (final r in rules) {
      edges
          .putIfAbsent(r.activityId, () => {})
          .addAll(r.timing.anchorActivityIds);
    }
    for (final v in input.variants) {
      final a = groupsById[v.groupId]?.activityId;
      if (a != null && v.timing != null) {
        edges.putIfAbsent(a, () => {}).addAll(v.timing!.anchorActivityIds);
      }
    }
    var counter = 0;
    final index = <String, int>{}, low = <String, int>{};
    final stack = <String>[], onStack = <String>{}, cyclic = <String>{};
    void strong(String v) {
      index[v] = low[v] = counter++;
      stack.add(v);
      onStack.add(v);
      for (final w in edges[v] ?? const <String>{}) {
        if (!index.containsKey(w)) {
          strong(w);
          low[v] = math.min(low[v]!, low[w]!);
        } else if (onStack.contains(w)) {
          low[v] = math.min(low[v]!, index[w]!);
        }
      }
      if (low[v] == index[v]) {
        final scc = <String>[];
        String w;
        do {
          w = stack.removeLast();
          onStack.remove(w);
          scc.add(w);
        } while (w != v);
        if (scc.length > 1 || (edges[v]?.contains(v) ?? false)) {
          cyclic.addAll(scc);
          issues.add(DependencyCycle(scc..sort()));
        }
      }
    }

    for (final v in edges.keys.toList()..sort()) {
      if (!index.containsKey(v)) strong(v);
    }
    return cyclic;
  }

  _Occ? _anchor(String activityId, Day d) {
    final list = _byActDay[_key(activityId, d)];
    if (list == null) return null;
    for (final o in list) {
      if (o.active) return o;
    }
    return null;
  }

  int _classOf(Timing t) {
    var cls = 4;
    for (final c in [...t.start, ...t.end]) {
      if (c.ref is ActivityRef) continue;
      cls = math.min(cls, c.op == ConstraintOp.at ? 1 : 3);
    }
    return cls;
  }

  /// Sıra: 0 sabitlenmiş, 1 saat/astronomik, 2+ göreli (çapasından sonra), 3 pencere ve
  /// esnek işler, 4 saatsiz.
  int _rankOf(_Occ o, Set<String> cyclic) {
    if (o.rank != null) return o.rank!;
    if (o.pinned) return o.rank = 0;
    if (cyclic.contains(o.activityId)) return o.rank = 4;
    var rank = _classOf(o.timing);
    var depth = 0;
    for (final a in o.timing.anchorActivityIds) {
      final anchor = _anchor(a, o.day);
      if (anchor == null) continue;
      rank = math.max(
        rank == 4 ? 2 : rank,
        math.max(2, _rankOf(anchor, cyclic)),
      );
      depth = math.max(depth, anchor.depth + 1);
    }
    // Esnek işler kesinlerin hepsinden sonra yerleşir; yoksa kesin işle çakışıp taşınamaz.
    if (o.flex != Flexibility.fixed && rank < 3) rank = 3;
    o.depth = depth;
    return o.rank = rank;
  }

  // ------------------------------------------------------------ yerleştirme

  void _put(_Occ o, int s, int e) {
    o.start = s;
    o.end = e;
    for (final other in timeline.overlapping(s, e)) {
      issues.add(Overlap(other, o.id));
    }
    timeline.add(s, e, o.id);
  }

  void _overflow(_Occ o) {
    o.start = o.end = null;
    issues.add(Overflow(o.id, dropped: o.flex == Flexibility.optional));
  }

  int? _refTime(_Occ o, TimeRef ref) {
    switch (ref) {
      case ClockRef(:final hour, :final minute, :final dayOffset):
        return cal.wallToUtc(o.day.add(dayOffset), hour * 60 + minute);
      case AstroRef(:final event, :final dayOffset):
        final t = astro.at(event, o.day.add(dayOffset));
        if (t == null && o.rule != null && _missingReported.add(o.rule!.id)) {
          issues.add(
            MissingAnchorData(
              o.rule!.id,
              astro.hasLocation
                  ? MissingData.prayerMethod
                  : MissingData.location,
            ),
          );
        }
        return t;
      case ActivityRef(:final activityId, :final edge):
        final a = _anchor(activityId, o.day);
        if (a == null) return null;
        if (a.start == null) {
          o.anchorActivityId = activityId;
          return null;
        }
        return edge == Edge.start ? a.start : a.end;
    }
  }

  void _place(_Occ o, Set<String> cyclic) {
    if (cyclic.contains(o.activityId)) return;
    int? sAt, eAt, sLo, sHi, eLo, eHi;
    int? pick(int? cur, int v, bool max) =>
        cur == null ? v : (max ? math.max(cur, v) : math.min(cur, v));
    for (final (isStart, list) in [
      (true, o.timing.start),
      (false, o.timing.end),
    ]) {
      for (final c in list) {
        final base = _refTime(o, c.ref);
        if (base == null) continue;
        final v = base + c.offsetMinutes;
        switch ((isStart, c.op)) {
          case (true, ConstraintOp.at):
            sAt = v;
          case (true, ConstraintOp.notBefore):
            sLo = pick(sLo, v, true);
          case (true, ConstraintOp.notAfter):
            sHi = pick(sHi, v, false);
          case (false, ConstraintOp.at):
            eAt = v;
          case (false, ConstraintOp.notBefore):
            eLo = pick(eLo, v, true);
          case (false, ConstraintOp.notAfter):
            eHi = pick(eHi, v, false);
        }
      }
    }
    // Çapası saatsiz kalan göreli iş de saatsiz kalır ("yemekten sonra" etiketiyle).
    if (o.anchorActivityId != null) return;

    // Üst üste derin çalışmada süre saf odaktır; aradaki molalar da yer kaplar (D66).
    final blocks = o.blocks == null ? activities[o.activityId]?.blocks : null;
    int? span(int? m) => m == null || blocks == null ? m : blocks.span(m);
    final d = span(
      o.dMax ?? o.dMin ?? activities[o.activityId]?.estimatedMinutes,
    );
    final dShort = span(o.dMin) ?? d;
    final dayEnd = cal.dayEnd(o.day);

    if (sAt != null || eAt != null) {
      int s, e;
      if (sAt != null && eAt != null) {
        s = sAt;
        e = s + span((eAt > sAt ? eAt : eAt + 1440) - sAt)!;
      } else if (sAt != null) {
        s = sAt;
        e = s + (d ?? 0);
      } else {
        e = eAt!;
        // Bitiş kesin, başlangıç aralıklı: süre varsa geri say ve kısıta kırp, yoksa en geç an.
        s = d != null ? e - d : (sHi ?? e);
        if (sHi != null && s > sHi) s = sHi;
        if (sLo != null && s < sLo) s = sLo;
        if (s > e) s = e;
      }
      if (o.flex == Flexibility.fixed || timeline.overlapping(s, e).isEmpty) {
        _put(o, s, e);
        return;
      }
      final len = e - s;
      final limit = eHi ?? dayEnd;
      final lo = math.max(sLo ?? cal.dayStart(o.day), _floor(o.day));
      final at = timeline.nearestFit(s, lo, sHi ?? limit - len, len, limit);
      at == null ? _overflow(o) : _put(o, at, at + len);
      return;
    }

    final isWindow = sLo != null || sHi != null || eLo != null || eHi != null;
    // Süresiz pencere, süresiz sabit saat gibi sıfır dakikayla ilk boş ana yerleşir (D62).
    if (d == null && !isWindow) return; // saatsiz iş saatsiz kalır
    for (final len in {d ?? 0, ?dShort}) {
      final limit = eHi ?? math.max(dayEnd, (sHi ?? 0) + len);
      var lo = math.max(sLo ?? cal.dayStart(o.day), _floor(o.day));
      if (eLo != null) lo = math.max(lo, eLo - len);
      // Dağıtılan blok öncekinden en az bir mola sonra başlar.
      if (_byId[o.after]?.end case final prevEnd?) {
        lo = math.max(lo, prevEnd + o.afterGap);
      }
      final at = timeline.earliestFit(lo, sHi ?? limit - len, len, limit);
      if (at != null) {
        o.suggested = !isWindow;
        _put(o, at, at + len);
        return;
      }
    }
    _overflow(o);
  }

  // ------------------------------------------------------------ projeler

  ChunkPlan _planProjects() {
    final projects = [
      for (final p in input.projects)
        if (activities.containsKey(p.activityId)) p,
    ];
    if (projects.isEmpty) return const ChunkPlan([], []);
    final ids = {for (final p in projects) p.activityId};
    final used = <String, int>{};
    final booked = <String, Map<Day, int>>{};
    for (final i in input.instances) {
      if (!ids.contains(i.activityId) ||
          i.ruleId != null ||
          i.start == null ||
          i.end == null) {
        continue;
      }
      final counts =
          i.status == InstanceStatus.done ||
          (i.status == InstanceStatus.planned && i.end! > input.asOf);
      if (!counts) continue;
      final m = i.end! - i.start!;
      used[i.activityId] = (used[i.activityId] ?? 0) + m;
      final byDay = booked[i.activityId] ??= {};
      final d = Day.parse(i.date);
      byDay[d] = (byDay[d] ?? 0) + m;
    }
    final s = input.settings;
    final plan = planner.plan(
      ChunkRequest(
        projects: projects,
        slots: [
          for (final d in _span(today.isAfter(from) ? today : from, to))
            if (_dayRule(d).auto) ...timeline.gaps(_floor(d), cal.dayEnd(d)),
        ],
        calendar: cal,
        usedMinutes: used,
        bookedByDay: booked,
        minChunk: s.minChunk ?? defaultMinChunk,
        buffer: s.chunkBuffer ?? defaultChunkBuffer,
        dailyFocusCap: s.dailyFocusCap,
      ),
    );
    for (final c in plan.proposals) {
      timeline.add(c.start, c.end, 'proposal:${c.activityId}');
    }
    return plan;
  }

  // ------------------------------------------------------------ çıktı

  PlanOutput _output(ChunkPlan chunks) {
    final rangeStart = cal.dayStart(from);
    final visible = [
      for (final o in occs)
        if ((!o.day.isBefore(from) && !o.day.isAfter(to)) ||
            (o.day == from.add(-1) && (o.end ?? 0) > rangeStart))
          o,
    ];
    visible.sort((a, b) {
      for (final c in [
        a.day.index.compareTo(b.day.index),
        (a.start ?? 1 << 40).compareTo(b.start ?? 1 << 40),
        (activities[a.activityId]?.priority ?? 2).compareTo(
          activities[b.activityId]?.priority ?? 2,
        ),
        a.activityId.compareTo(b.activityId),
        a.id.compareTo(b.id),
      ]) {
        if (c != 0) return c;
      }
      return 0;
    });
    final visibleIds = {for (final o in visible) o.id};
    final free = <String, List<TimeSlot>>{};
    final unplanned = <String>{};
    for (final d in _span(from, to)) {
      if (_dayRule(d).unplanned) {
        unplanned.add(d.iso);
      } else {
        free[d.iso] = timeline.gaps(cal.dayStart(d), cal.dayEnd(d));
      }
    }
    return PlanOutput(
      instances: [
        for (final o in visible)
          PlannedInstance(
            id: o.id,
            activityId: o.activityId,
            ruleId: o.rule?.id ?? o.persisted?.ruleId,
            date: o.day.iso,
            start: o.start ?? (o.active ? null : o.persisted?.start),
            end: o.end ?? (o.active ? null : o.persisted?.end),
            status: o.status,
            source: o.source,
            flexibility: o.flex,
            variantId: o.variantId ?? o.persisted?.variantId,
            parentInstanceId: o.parentInstanceId,
            anchorActivityId: o.anchorActivityId,
            persisted: o.persisted != null,
            isManual: o.persisted?.isManual ?? false,
            suggested: o.suggested,
            block: o.block,
            blocks: o.blocks,
          ),
      ],
      freeSlots: free,
      unplannedDays: unplanned,
      issues: [
        for (final i in issues)
          if (switch (i) {
            Overlap(:final a, :final b) =>
              visibleIds.contains(a) || visibleIds.contains(b),
            Overflow(:final instanceId) => visibleIds.contains(instanceId),
            _ => true,
          })
            i,
      ],
      proposals: chunks.proposals,
      risks: chunks.risks,
      variantChoices: [
        for (final c in choices)
          if (!Day.parse(c.date).isBefore(from) &&
              !Day.parse(c.date).isAfter(to))
            c,
      ]..sort((a, b) => a.date.compareTo(b.date)),
      engineVersion: planEngineVersion,
    );
  }
}
