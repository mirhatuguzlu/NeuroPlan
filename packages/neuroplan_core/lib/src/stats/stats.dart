/// Profil ve analiz hesapları (PRODUCT STATS, Aşama 5). Saf ve deterministik: girdi düz
/// kayıtlardır, veritabanı ve Flutter yoktur. Grafik yalnız bu sonuçları gösterir.
library;

import 'dart:math' as math;

import '../brain/brain_config.dart';
import '../brain/brain_engine.dart';
import '../brain/render_plan.dart' show unitsPerNeuron;
import '../plan/calendar.dart';

// ---------------------------------------------------------------------------
// Girdiler
// ---------------------------------------------------------------------------

/// Biten (tamamlanan ya da bozulan) odak oturumu. Zamanlar UTC dakika.
final class StatSession {
  const StatSession({
    required this.id,
    required this.mode,
    required this.outcome,
    required this.start,
    required this.end,
    required this.focusedSeconds,
    this.rootKey,
    this.categoryId,
    this.activityId,
    this.focusRating,
    this.fatigueRating,
  });

  final String id;

  /// `free` · `pomodoro` · `deep`
  final String mode;

  /// `completed` · `broken`
  final String outcome;
  final int start;
  final int end;
  final int focusedSeconds;
  final String? rootKey;
  final String? categoryId;
  final String? activityId;

  /// 1–5, kullanıcının bildirdiği.
  final int? focusRating;
  final int? fatigueRating;

  bool get completed => outcome == 'completed';
  int get minutes => focusedSeconds ~/ 60;
}

final class StatInterruption {
  const StatInterruption({
    required this.sessionId,
    required this.at,
    required this.reason,
    required this.counted,
  });

  final String sessionId;

  /// Uygulamadan çıkış anı, UTC dakika.
  final int at;
  final String reason;

  /// Kaçış kuralına sayıldı mı (izinli arama vb. sayılmaz).
  final bool counted;
}

/// Plan motorunun bir oluşumu (geçmiş ya da gelecek). Uyku ve boş zaman uyuma girmez;
/// süzmeyi çağıran yapar.
final class StatPlanItem {
  const StatPlanItem({
    required this.activityId,
    required this.day,
    required this.status,
    this.minutes,
    this.rootKey,
  });

  final String activityId;
  final Day day;

  /// `planned` · `done` · `skipped` · `moved` · `failed`
  final String status;
  final int? minutes;
  final String? rootKey;
}

// ---------------------------------------------------------------------------
// Aralık ve kovalar
// ---------------------------------------------------------------------------

/// Zaman aralığı seçici: son 7 / 30 / 91 / 365 gün ya da ilk veriden bugüne.
enum StatPeriod {
  week(7),
  month(30),
  quarter(91),
  year(365),
  all(null);

  const StatPeriod(this.days);
  final int? days;
}

/// İki ucu dahil gün aralığı.
final class DayRange {
  const DayRange(this.from, this.to);

  final Day from;
  final Day to;

  int get length => to.index - from.index + 1;
  bool contains(Day d) => !d.isBefore(from) && !d.isAfter(to);
  Iterable<Day> get days sync* {
    for (var d = from; !d.isAfter(to); d = d.add(1)) {
      yield d;
    }
  }

  /// Aynı uzunlukta bir önceki aralık.
  DayRange get previous => DayRange(from.add(-length), from.add(-1));

  /// [first]: kullanıcının ilk verisinin günü (`all` için); yoksa son 7 gün.
  factory DayRange.of(StatPeriod p, Day today, {Day? first}) {
    final days = p.days;
    if (days != null) return DayRange(today.add(1 - days), today);
    return DayRange(
      first != null && first.isBefore(today.add(-6)) ? first : today.add(-6),
      today,
    );
  }

  /// [day]ı içeren pazartesi–pazar haftası.
  factory DayRange.weekOf(Day day) =>
      DayRange(day.add(1 - day.weekday), day.add(7 - day.weekday));

  @override
  bool operator ==(Object other) =>
      other is DayRange && other.from == from && other.to == to;
  @override
  int get hashCode => Object.hash(from, to);
  @override
  String toString() => '${from.iso}..${to.iso}';
}

enum Granularity { day, week, month }

/// Bir ayda gün, üç ayda hafta, daha uzunda ay (grafikte ~7–60 nokta).
Granularity granularityFor(DayRange r) => r.length <= 31
    ? Granularity.day
    : r.length <= 120
    ? Granularity.week
    : Granularity.month;

/// Aralığı ardışık kovalara böler; ilk ve son kova aralıkla kırpılır.
List<DayRange> bucketsOf(DayRange r, [Granularity? g]) {
  final out = <DayRange>[];
  var start = r.from;
  while (!start.isAfter(r.to)) {
    final Day end = switch (g ?? granularityFor(r)) {
      Granularity.day => start,
      Granularity.week => start.add(7 - start.weekday),
      Granularity.month => () {
        final u = start.utc;
        return Day.parse(_iso(DateTime.utc(u.year, u.month + 1, 1))).add(-1);
      }(),
    };
    final e = end.isAfter(r.to) ? r.to : end;
    out.add(DayRange(start, e));
    start = e.add(1);
  }
  return out;
}

String _iso(DateTime d) => d.toIso8601String().substring(0, 10);

/// Günden kova sırasına (ikili arama); aralık dışıysa null.
int? bucketIndex(List<DayRange> buckets, Day d) {
  var lo = 0, hi = buckets.length - 1;
  while (lo <= hi) {
    final mid = (lo + hi) >> 1;
    final b = buckets[mid];
    if (d.isBefore(b.from)) {
      hi = mid - 1;
    } else if (d.isAfter(b.to)) {
      lo = mid + 1;
    } else {
      return mid;
    }
  }
  return null;
}

/// Oturumun günü: bitişin yerel günü (beyin ve sıralamayla aynı, D47).
Day sessionDay(StatSession s, PlanCalendar cal) => cal.dayOf(s.end);

Iterable<StatSession> inRange(
  Iterable<StatSession> sessions,
  DayRange r,
  PlanCalendar cal,
) => sessions.where((s) => r.contains(sessionDay(s, cal)));

double? _avg(Iterable<int> xs) {
  var n = 0, sum = 0;
  for (final x in xs) {
    n++;
    sum += x;
  }
  return n == 0 ? null : sum / n;
}

// ---------------------------------------------------------------------------
// 1. Zamanım nereye gidiyor?
// ---------------------------------------------------------------------------

/// Kategori anahtarı yoksa kökü, kök de yoksa [noCategory].
const noCategory = '';

final class CategoryTime {
  const CategoryTime(this.byRoot, this.byCategory, this.rootOnly);

  /// Kök → odak dakikası (oturumu olmayan kök yer almaz).
  final Map<String, int> byRoot;

  /// Kullanıcı kategorisi → kendisine doğrudan yazılan dakika (alt kategoriler hariç).
  final Map<String, int> byCategory;

  /// Kök → kategorisiz (yalnız köke bağlı) dakika.
  final Map<String, int> rootOnly;

  int get total => byRoot.values.fold(0, (a, b) => a + b);
}

/// Bozulan oturumun odak süresi de harcanmış zamandır; ikisi de sayılır.
CategoryTime timeByCategory(
  Iterable<StatSession> sessions,
  DayRange r,
  PlanCalendar cal,
) {
  final byRoot = <String, int>{},
      byCat = <String, int>{},
      rootOnly = <String, int>{};
  for (final s in inRange(sessions, r, cal)) {
    final m = s.minutes;
    if (m == 0) continue;
    final root = s.rootKey ?? noCategory;
    byRoot[root] = (byRoot[root] ?? 0) + m;
    if (s.categoryId != null) {
      byCat[s.categoryId!] = (byCat[s.categoryId!] ?? 0) + m;
    } else {
      rootOnly[root] = (rootOnly[root] ?? 0) + m;
    }
  }
  return CategoryTime(byRoot, byCat, rootOnly);
}

/// Her düğümün kendisi + bütün alt düğümleri ([parentOf]: kategori → üst, köke bağlıysa null).
/// Döngülü veri (olmamalı) sonsuz döngüye girmez.
Map<String, int> rollUp(
  Map<String, int> direct,
  Map<String, String?> parentOf,
) {
  final out = <String, int>{};
  for (final MapEntry(:key, :value) in direct.entries) {
    final seen = <String>{};
    for (String? c = key; c != null && seen.add(c); c = parentOf[c]) {
      out[c] = (out[c] ?? 0) + value;
    }
  }
  return out;
}

// ---------------------------------------------------------------------------
// 2. Plana ne kadar uyuyorum?
// ---------------------------------------------------------------------------

final class AdherenceDay {
  const AdherenceDay(this.day, this.planned, this.done);
  final Day day;
  final int planned;
  final int done;

  /// 0–100; planlı iş yoksa null.
  double? get percent => planned == 0 ? null : done * 100 / planned;
}

final class Adherence {
  const Adherence(this.days, this.buckets);

  /// Aralığın bugünden önceki her günü (bugün henüz bitmedi).
  final List<AdherenceDay> days;

  /// Grafik kovaları (planlanan / yapılan toplamı); [AdherenceDay.day] kovanın ilk günü.
  final List<AdherenceDay> buckets;

  int get planned => days.fold(0, (a, d) => a + d.planned);
  int get done => days.fold(0, (a, d) => a + d.done);
  double? get percent => planned == 0 ? null : done * 100 / planned;
}

/// İş sayısına göre uyum (D54): planlanan = taşınmamış her oluşum; yapılan = `done`.
/// Taşınan oluşumun yenisi kendi gününde sayılır.
Adherence adherence(Iterable<StatPlanItem> items, DayRange r, Day today) {
  final last = today.add(-1);
  final range = DayRange(r.from, r.to.isAfter(last) ? last : r.to);
  final planned = <int, int>{}, done = <int, int>{};
  for (final i in items) {
    if (i.status == 'moved' || !range.contains(i.day)) continue;
    planned[i.day.index] = (planned[i.day.index] ?? 0) + 1;
    if (i.status == 'done') done[i.day.index] = (done[i.day.index] ?? 0) + 1;
  }
  final days = [
    for (final d in range.days)
      AdherenceDay(d, planned[d.index] ?? 0, done[d.index] ?? 0),
  ];
  final buckets = range.length <= 0
      ? <AdherenceDay>[]
      : [
          for (final b in bucketsOf(range, granularityFor(r)))
            AdherenceDay(
              b.from,
              b.days.fold(0, (a, d) => a + (planned[d.index] ?? 0)),
              b.days.fold(0, (a, d) => a + (done[d.index] ?? 0)),
            ),
        ];
  return Adherence(days, buckets);
}

// ---------------------------------------------------------------------------
// 3. Ne zaman en iyi odaklanıyorum?
// ---------------------------------------------------------------------------

final class FocusHeat {
  FocusHeat._(this._sum, this._count, this.rated);

  final List<int> _sum, _count;

  /// Puanlanmış oturum sayısı.
  final int rated;

  /// [weekday] 1 = pazartesi; [hour] 0–23 (oturumun yerel başlangıcı).
  double? average(int weekday, int hour) {
    final i = (weekday - 1) * 24 + hour;
    return _count[i] == 0 ? null : _sum[i] / _count[i];
  }

  int count(int weekday, int hour) => _count[(weekday - 1) * 24 + hour];

  /// Bütün günlerde [hour] saatinin ortalaması ve oturum sayısı.
  ({double? average, int count}) hour(int hour) {
    var s = 0, n = 0;
    for (var d = 0; d < 7; d++) {
      s += _sum[d * 24 + hour];
      n += _count[d * 24 + hour];
    }
    return (average: n == 0 ? null : s / n, count: n);
  }

  /// En yüksek ortalamalı ardışık [hours] saatlik dilim (haftanın bütün günleri birlikte).
  /// En az [minSessions] puanlı oturum ister; eşitlikte daha çok oturumlu, sonra erken olan.
  ({int start, int end, double average})? bestWindow({
    int hours = 2,
    int minSessions = 3,
  }) {
    final sum = List.filled(24, 0), n = List.filled(24, 0);
    for (var i = 0; i < _sum.length; i++) {
      sum[i % 24] += _sum[i];
      n[i % 24] += _count[i];
    }
    ({int start, int end, double average})? best;
    var bestN = 0;
    for (var h = 0; h + hours <= 24; h++) {
      var s = 0, c = 0;
      for (var k = h; k < h + hours; k++) {
        s += sum[k];
        c += n[k];
      }
      if (c < minSessions) continue;
      final avg = s / c;
      if (best == null ||
          avg > best.average + 1e-9 ||
          ((avg - best.average).abs() < 1e-9 && c > bestN)) {
        best = (start: h, end: h + hours, average: avg);
        bestN = c;
      }
    }
    return best;
  }
}

FocusHeat focusHeat(
  Iterable<StatSession> sessions,
  DayRange r,
  PlanCalendar cal,
) {
  final sum = List.filled(7 * 24, 0), count = List.filled(7 * 24, 0);
  var rated = 0;
  for (final s in inRange(sessions, r, cal)) {
    final f = s.focusRating;
    if (f == null) continue;
    final i =
        (cal.dayOf(s.start).weekday - 1) * 24 + cal.minuteOfDay(s.start) ~/ 60;
    sum[i] += f;
    count[i]++;
    rated++;
  }
  return FocusHeat._(sum, count, rated);
}

// ---------------------------------------------------------------------------
// 4. Tutarlı mıyım?
// ---------------------------------------------------------------------------

final class Streaks {
  const Streaks(this.minutesByDay, this.current, this.longest);

  /// Aktif gün (en az bir tamamlanan odak, D54) → o günün tamamlanan odak dakikası.
  final Map<Day, int> minutesByDay;

  /// Bugün ya da dün biten seri (bugün henüz oturum yoksa seri kopmuş sayılmaz).
  final int current;
  final int longest;
}

Streaks streaks(Iterable<StatSession> sessions, PlanCalendar cal, Day today) {
  final byDay = <Day, int>{};
  for (final s in sessions) {
    if (!s.completed) continue;
    final d = sessionDay(s, cal);
    if (d.isAfter(today)) continue;
    byDay[d] = (byDay[d] ?? 0) + s.minutes;
  }
  final days = byDay.keys.map((d) => d.index).toList()..sort();
  var longest = 0, run = 0;
  for (var i = 0; i < days.length; i++) {
    run = i > 0 && days[i] == days[i - 1] + 1 ? run + 1 : 1;
    longest = math.max(longest, run);
  }
  var current = 0;
  var d = byDay.containsKey(today) ? today : today.add(-1);
  while (byDay.containsKey(d)) {
    current++;
    d = d.add(-1);
  }
  return Streaks(byDay, current, longest);
}

// ---------------------------------------------------------------------------
// 5. Odak kalitem nasıl değişiyor?
// ---------------------------------------------------------------------------

final class QualityPoint {
  const QualityPoint(this.bucket, this.focus, this.fatigue, this.count);
  final DayRange bucket;
  final double? focus;
  final double? fatigue;

  /// Puanlanmış oturum sayısı.
  final int count;
}

List<QualityPoint> qualityTrend(
  Iterable<StatSession> sessions,
  DayRange r,
  PlanCalendar cal,
) {
  final buckets = bucketsOf(r);
  final focus = [for (final _ in buckets) <int>[]];
  final fatigue = [for (final _ in buckets) <int>[]];
  final count = List.filled(buckets.length, 0);
  for (final s in sessions) {
    if (s.focusRating == null && s.fatigueRating == null) continue;
    final i = bucketIndex(buckets, sessionDay(s, cal));
    if (i == null) continue;
    count[i]++;
    if (s.focusRating != null) focus[i].add(s.focusRating!);
    if (s.fatigueRating != null) fatigue[i].add(s.fatigueRating!);
  }
  return [
    for (var i = 0; i < buckets.length; i++)
      QualityPoint(buckets[i], _avg(focus[i]), _avg(fatigue[i]), count[i]),
  ];
}

/// İlk ve son yarının ortalama farkı (eğilim yönü için); veri yetmezse null.
double? halfDelta(List<double?> xs) {
  final v = [for (final x in xs) ?x];
  if (v.length < 2) return null;
  final h = v.length ~/ 2;
  double mean(Iterable<double> a) => a.reduce((x, y) => x + y) / a.length;
  return mean(v.skip(v.length - h)) - mean(v.take(h));
}

// ---------------------------------------------------------------------------
// 6. Ne beni bölüyor?
// ---------------------------------------------------------------------------

final class InterruptionStats {
  const InterruptionStats(
    this.total,
    this.byReason,
    this.byHour,
    this.sessions,
  );

  final int total;
  final Map<String, int> byReason;

  /// Yerel saat 0–23.
  final List<int> byHour;

  /// Aralıktaki biten oturum sayısı (oturum başına kesinti için).
  final int sessions;

  double get perSession => sessions == 0 ? 0 : total / sessions;

  /// En sık sebep; kesinti yoksa null.
  String? get topReason => byReason.isEmpty
      ? null
      : (byReason.entries.toList()..sort((a, b) => b.value - a.value))
            .first
            .key;

  /// En çok kesinti olan saat; kesinti yoksa null.
  int? get peakHour {
    if (total == 0) return null;
    var best = 0;
    for (var h = 1; h < 24; h++) {
      if (byHour[h] > byHour[best]) best = h;
    }
    return best;
  }
}

InterruptionStats interruptionStats(
  Iterable<StatInterruption> list,
  Iterable<StatSession> sessions,
  DayRange r,
  PlanCalendar cal,
) {
  final byReason = <String, int>{};
  final byHour = List.filled(24, 0);
  var total = 0;
  for (final i in list) {
    if (!r.contains(cal.dayOf(i.at))) continue;
    total++;
    byReason[i.reason] = (byReason[i.reason] ?? 0) + 1;
    byHour[cal.minuteOfDay(i.at) ~/ 60]++;
  }
  return InterruptionStats(
    total,
    byReason,
    byHour,
    inRange(sessions, r, cal).length,
  );
}

// ---------------------------------------------------------------------------
// 7. Pomodoro mu derin çalışma mı?
// ---------------------------------------------------------------------------

final class ModeStats {
  const ModeStats({
    required this.sessions,
    required this.completed,
    required this.avgFocus,
    required this.avgFatigue,
    required this.avgMinutes,
  });

  final int sessions;
  final int completed;
  final double? avgFocus;
  final double? avgFatigue;
  final double? avgMinutes;

  double? get completionRate => sessions == 0 ? null : completed / sessions;
}

final class ModeComparison {
  const ModeComparison(this.pomodoro, this.deep);

  /// SCIENCE §4: genel bir "daha iyi" iddiası yok; kıyas yalnız kullanıcının verisi.
  static const minSessions = 5;

  final ModeStats pomodoro;
  final ModeStats deep;

  bool get enough =>
      pomodoro.sessions >= minSessions && deep.sessions >= minSessions;
  int get pomodoroMissing => math.max(0, minSessions - pomodoro.sessions);
  int get deepMissing => math.max(0, minSessions - deep.sessions);

  /// Odak puanı ortalaması belirgin (≥ 0,3) yüksek olan mod; yakınsa ya da veri azsa null.
  String? get higherFocus {
    final p = pomodoro.avgFocus, d = deep.avgFocus;
    if (!enough || p == null || d == null || (p - d).abs() < 0.3) return null;
    return p > d ? 'pomodoro' : 'deep';
  }
}

ModeComparison compareModes(
  Iterable<StatSession> sessions,
  DayRange r,
  PlanCalendar cal,
) {
  ModeStats of(String mode) {
    final xs = [
      for (final s in inRange(sessions, r, cal))
        if (s.mode == mode) s,
    ];
    return ModeStats(
      sessions: xs.length,
      completed: xs.where((s) => s.completed).length,
      avgFocus: _avg([for (final s in xs) ?s.focusRating]),
      avgFatigue: _avg([for (final s in xs) ?s.fatigueRating]),
      avgMinutes: _avg([for (final s in xs) s.minutes]),
    );
  }

  return ModeComparison(of('pomodoro'), of('deep'));
}

// ---------------------------------------------------------------------------
// 8. Beynim nasıl gelişiyor?
// ---------------------------------------------------------------------------

final class BrainGrowth {
  const BrainGrowth(
    this.buckets,
    this.neurons,
    this.gained,
    this.connectionsGained,
  );

  final List<DayRange> buckets;

  /// Bölge → her kovanın sonundaki toplam nöron (birikimli; nöron hiç silinmez, BRAIN-3).
  final Map<String, List<int>> neurons;

  /// Bölge → aralıkta kazanılan nöron.
  final Map<String, int> gained;

  /// Aralıkta kazanılan bağlantı gücü (nöron birimiyle).
  final int connectionsGained;

  /// Aralıkta en çok büyüyen [n] bölge (kazancı olmayan yok).
  List<String> top([int n = 3]) =>
      ([
            for (final e in gained.entries)
              if (e.value > 0) e,
          ]..sort(
            (a, b) =>
                b.value != a.value ? b.value - a.value : a.key.compareTo(b.key),
          ))
          .take(n)
          .map((e) => e.key)
          .toList();
}

BrainGrowth brainGrowth(
  Iterable<BrainEventDraft> events,
  DayRange r,
  PlanCalendar cal,
  List<String> regionKeys,
) {
  final buckets = bucketsOf(r);
  final before = <String, int>{};
  final per = {for (final k in regionKeys) k: List.filled(buckets.length, 0)};
  var conn = 0;
  for (final e in events) {
    final d = cal.dayOf(e.occurredAt.millisecondsSinceEpoch ~/ 60000);
    if (d.isAfter(r.to)) continue;
    final inside = !d.isBefore(r.from);
    if (e.type == 'connection_gain') {
      if (inside) conn += e.amount;
      continue;
    }
    if (e.type != 'neuron_gain' || !per.containsKey(e.regionKey)) continue;
    if (!inside) {
      before[e.regionKey] = (before[e.regionKey] ?? 0) + e.amount;
    } else {
      per[e.regionKey]![bucketIndex(buckets, d)!] += e.amount;
    }
  }
  final neurons = <String, List<int>>{}, gained = <String, int>{};
  for (final k in regionKeys) {
    var acc = before[k] ?? 0;
    neurons[k] = [for (final a in per[k]!) (acc += a) ~/ unitsPerNeuron];
    gained[k] = per[k]!.fold(0, (a, b) => a + b) ~/ unitsPerNeuron;
  }
  return BrainGrowth(buckets, neurons, gained, conn ~/ unitsPerNeuron);
}

/// Sönen bölge: nöronu var, parlaklığı bir yarılanmadan fazla düşmüş (D39).
bool isFading(int neurons, int brightness, [BrainConfig c = brainConfig]) =>
    neurons > 0 && brightness < (c.brightnessFloorPermille + 1000) ~/ 2;

// ---------------------------------------------------------------------------
// 9. Projelerim yetişecek mi?
// ---------------------------------------------------------------------------

final class Burndown {
  const Burndown(
    this.points,
    this.remaining,
    this.finish,
    this.byPlan,
    this.pace,
  );

  /// Başlangıçtan bugüne her gün sonunda kalan dakika.
  final List<({Day day, int remaining})> points;
  final int remaining;

  /// Tahmini bitiş; tempo yoksa ve plan yetmiyorsa null. Bitmişse son çalışma günü.
  final Day? finish;

  /// Tahmin planlanmış parçalardan mı (yoksa son 14 günün temposundan).
  final bool byPlan;

  /// Son 14 günün günlük ortalama dakikası.
  final double pace;

  bool onTime(Day? deadline) =>
      deadline == null || (finish != null && !finish!.isAfter(deadline));
}

/// [work]: projeye giden odak dakikaları (gün, dakika). [planned]: bugünden sonraki
/// planlanmış parçalar. Önce plan, plan yetmezse tempo kullanılır (D54).
Burndown burndown({
  required int totalMinutes,
  required Day start,
  required Day today,
  required Iterable<({Day day, int minutes})> work,
  Iterable<({Day day, int minutes})> planned = const [],
}) {
  final byDay = <int, int>{};
  var lastWork = start;
  for (final w in work) {
    if (w.day.isAfter(today)) continue;
    final d = w.day.isBefore(start) ? start : w.day;
    byDay[d.index] = (byDay[d.index] ?? 0) + w.minutes;
    if (w.minutes > 0 && d.isAfter(lastWork)) lastWork = d;
  }
  var left = totalMinutes;
  final points = <({Day day, int remaining})>[];
  for (var d = start; !d.isAfter(today); d = d.add(1)) {
    left = math.max(0, left - (byDay[d.index] ?? 0));
    points.add((day: d, remaining: left));
  }
  var recent = 0;
  for (var i = 0; i < 14; i++) {
    recent += byDay[today.add(-i).index] ?? 0;
  }
  final pace = recent / 14;
  if (left == 0) return Burndown(points, 0, lastWork, false, pace);
  var acc = 0;
  for (final p in [
    for (final p in planned)
      if (p.day.isAfter(today)) p,
  ]..sort((a, b) => a.day.index - b.day.index)) {
    acc += p.minutes;
    if (acc >= left) return Burndown(points, left, p.day, true, pace);
  }
  final finish = pace <= 0 ? null : today.add((left / pace).ceil());
  return Burndown(points, left, finish, false, pace);
}

// ---------------------------------------------------------------------------
// 10. Uykum yeterli mi?
// ---------------------------------------------------------------------------

/// Uyarı eşiği (7 saat). Tıbbi iddia değil; yalnız sakin bir hatırlatma.
const sleepNoticeMinutes = 7 * 60;
const defaultSleepGoalMinutes = 8 * 60;

final class SleepStats {
  const SleepStats(this.nights, this.average, this.goal);

  /// Gece → planlanan uyku dakikası (planı olmayan gece yok).
  final Map<Day, int> nights;
  final double? average;
  final int goal;

  double? get difference => average == null ? null : average! - goal;
  bool get belowNotice => average != null && average! < sleepNoticeMinutes;
}

/// [windows]: uyku penceresinin oluşumları; pencere başladığı güne yazılır.
SleepStats sleepStats(
  Iterable<({Day day, int minutes})> windows,
  DayRange r,
  int? goalMinutes,
) {
  final nights = <Day, int>{};
  for (final w in windows) {
    if (r.contains(w.day)) nights[w.day] = (nights[w.day] ?? 0) + w.minutes;
  }
  return SleepStats(
    nights,
    _avg(nights.values),
    goalMinutes ?? defaultSleepGoalMinutes,
  );
}

// ---------------------------------------------------------------------------
// 11. Dengeli miyim?
// ---------------------------------------------------------------------------

final class Balance {
  const Balance(this.minutes, this.neglected);

  /// Bütün kökler (sırasıyla) → dakika; zamanı olmayan kök 0.
  final Map<String, int> minutes;

  /// Aralıkta hiç zaman ayrılmayan kökler (Dinlenme ve Uyku hariç: odakla ölçülmez).
  final List<String> neglected;

  int get total => minutes.values.fold(0, (a, b) => a + b);
  double share(String root) => total == 0 ? 0 : (minutes[root] ?? 0) / total;
}

Balance balance(CategoryTime t, List<String> rootKeys) => Balance(
  {for (final k in rootKeys) k: t.byRoot[k] ?? 0},
  [
    for (final k in rootKeys)
      if ((t.byRoot[k] ?? 0) == 0 && k != 'rest_sleep') k,
  ],
);

// ---------------------------------------------------------------------------
// 12. Haftalık rapor
// ---------------------------------------------------------------------------

final class WeekSummary {
  const WeekSummary({
    required this.range,
    required this.focusMinutes,
    required this.completedSessions,
    required this.activeDays,
    required this.adherencePercent,
    required this.avgFocus,
    required this.topRoot,
  });

  final DayRange range;
  final int focusMinutes;
  final int completedSessions;
  final int activeDays;
  final double? adherencePercent;
  final double? avgFocus;
  final String? topRoot;
}

WeekSummary weekSummary(
  Iterable<StatSession> sessions,
  Iterable<StatPlanItem> items,
  DayRange week,
  Day today,
  PlanCalendar cal,
) {
  final xs = inRange(sessions, week, cal).toList();
  final t = timeByCategory(xs, week, cal);
  final top = t.byRoot.entries.where((e) => e.key != noCategory).toList()
    ..sort(
      (a, b) => b.value != a.value ? b.value - a.value : a.key.compareTo(b.key),
    );
  return WeekSummary(
    range: week,
    focusMinutes: t.total,
    completedSessions: xs.where((s) => s.completed).length,
    activeDays: {
      for (final s in xs)
        if (s.completed) sessionDay(s, cal),
    }.length,
    adherencePercent: adherence(items, week, today).percent,
    avgFocus: _avg([for (final s in xs) ?s.focusRating]),
    topRoot: top.firstOrNull?.key,
  );
}

/// Bu hafta ve geçen hafta (pazartesi–pazar).
({WeekSummary current, WeekSummary previous}) weeklyReport(
  Iterable<StatSession> sessions,
  Iterable<StatPlanItem> items,
  Day today,
  PlanCalendar cal,
) {
  final week = DayRange.weekOf(today);
  return (
    current: weekSummary(sessions, items, week, today, cal),
    previous: weekSummary(sessions, items, week.previous, today, cal),
  );
}
