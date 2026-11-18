import 'dart:math' as math;

import 'calendar.dart';
import 'plan_types.dart';

const defaultMinChunk = 30;
const defaultMaxChunk = 120;
const defaultChunkBuffer = 10;

/// Proje bölme isteği. [slots] otomatik yerleştirmeye açık günlerin boş dilimleri,
/// "şimdi"den sonrası, zaman sırasıyla.
final class ChunkRequest {
  const ChunkRequest({
    required this.projects,
    required this.slots,
    required this.calendar,
    required this.usedMinutes,
    required this.bookedByDay,
    this.minChunk = defaultMinChunk,
    this.maxChunk = defaultMaxChunk,
    this.buffer = defaultChunkBuffer,
    this.dailyFocusCap,
  });

  final List<PlanProject> projects;
  final List<TimeSlot> slots;
  final PlanCalendar calendar;

  /// Proje → yapılmış + onaylanmış (gelecekteki) parçaların toplamı.
  final Map<String, int> usedMinutes;

  /// Proje → gün → o güne zaten konmuş parça dakikası (günlük sınır için).
  final Map<String, Map<Day, int>> bookedByDay;
  final int minChunk;
  final int maxChunk;

  /// Parçalar arası boş bırakılacak süre (SLOT-4).
  final int buffer;

  /// Tüm projeler için günlük azami odak süresi; null = sınır yok.
  final int? dailyFocusCap;
}

final class ChunkPlan {
  const ChunkPlan(this.proposals, this.risks);
  final List<ChunkProposal> proposals;
  final List<DeadlineRisk> risks;
}

/// Proje parçalarını boşluklara dağıtan algoritma. İleride akıllı bir planlayıcı
/// aynı arayüzle değiştirilebilir; motor yalnız bunu bilir.
abstract interface class ChunkPlanner {
  ChunkPlan plan(ChunkRequest request);
}

/// İlk sürüm: son tarihi en yakın proje önce, en erken uygun boşluğa (SLOT-3).
/// Tercih edilen pencereler önce doldurulur; son tarihten önce güvenlik payı kalır.
/// Son tarihi olmayan ya da elle bölünen projelere öneri üretmez.
final class EarliestDeadlinePlanner implements ChunkPlanner {
  const EarliestDeadlinePlanner();

  @override
  ChunkPlan plan(ChunkRequest req) {
    final cal = req.calendar;
    final free = [for (final s in req.slots) _Slot(s.start, s.end)];
    final proposals = <ChunkProposal>[];
    final risks = <DeadlineRisk>[];
    final dayTotal = <Day, int>{};
    for (final byDay in req.bookedByDay.values) {
      byDay.forEach((d, m) => dayTotal[d] = (dayTotal[d] ?? 0) + m);
    }

    final projects =
        [
          for (final p in req.projects)
            if (p.autoSplit && p.deadline != null && p.totalMinutes != null) p,
        ]..sort((a, b) {
          final c = a.deadline!.compareTo(b.deadline!);
          return c != 0 ? c : a.activityId.compareTo(b.activityId);
        });

    for (final p in projects) {
      var remaining = p.totalMinutes! - (req.usedMinutes[p.activityId] ?? 0);
      if (remaining <= 0) continue;
      final minLen = p.minChunk ?? req.minChunk;
      final maxLen = math.max(p.maxChunk ?? req.maxChunk, minLen);
      final latestEnd = p.deadline! - (p.safetyMargin ?? 0);
      final projDay = {...?req.bookedByDay[p.activityId]};

      int capLeft(Day day) {
        var left = 1 << 30;
        if (p.dailyCap != null) left = p.dailyCap! - (projDay[day] ?? 0);
        if (req.dailyFocusCap != null) {
          left = math.min(left, req.dailyFocusCap! - (dayTotal[day] ?? 0));
        }
        return left;
      }

      // 1. geçiş: yalnız tercih edilen pencereler; 2. geçiş: kalan her yer.
      for (final preferredOnly in [
        if (p.preferredWindows.isNotEmpty) true,
        false,
      ]) {
        // Kopya üzerinde dönülür; alınan parça + tampon, sonraki dilimin başını kesebilir.
        var reserved = -1 << 40;
        for (final slot in [...free]) {
          if (remaining <= 0 || slot.start >= latestEnd) break;
          final day = cal.dayOf(slot.start);
          final parts = preferredOnly
              ? _preferred(slot, p.preferredWindows, day, cal)
              : [slot];
          for (final part in parts) {
            var cursor = math.max(part.start, reserved);
            final end = math.min(part.end, latestEnd);
            while (remaining > 0) {
              final len = [
                maxLen,
                remaining,
                capLeft(day),
                end - cursor,
              ].reduce(math.min);
              if (len <= 0 || (len < minLen && len < remaining)) break;
              proposals.add(
                ChunkProposal(
                  activityId: p.activityId,
                  date: day.iso,
                  start: cursor,
                  end: cursor + len,
                ),
              );
              remaining -= len;
              projDay[day] = (projDay[day] ?? 0) + len;
              dayTotal[day] = (dayTotal[day] ?? 0) + len;
              _take(free, cursor, cursor + len + req.buffer);
              cursor += len + req.buffer;
              reserved = cursor;
            }
          }
        }
      }
      if (remaining > 0) {
        risks.add(
          DeadlineRisk(
            activityId: p.activityId,
            deadline: p.deadline!,
            missingMinutes: remaining,
          ),
        );
      }
    }
    proposals.sort((a, b) => a.start.compareTo(b.start));
    return ChunkPlan(proposals, risks);
  }

  static List<_Slot> _preferred(
    _Slot slot,
    List<PreferredWindow> windows,
    Day day,
    PlanCalendar cal,
  ) {
    final out = <_Slot>[];
    for (final w in windows) {
      if (w.weekdays.isNotEmpty && !w.weekdays.contains(day.weekday)) continue;
      final s = math.max(slot.start, cal.wallToUtc(day, w.from));
      final e = math.min(slot.end, cal.wallToUtc(day, w.to));
      if (e > s) out.add(_Slot(s, e));
    }
    out.sort((a, b) => a.start.compareTo(b.start));
    // Kesişen pencereler birleşir; yoksa aynı dakikaya iki parça düşer.
    final merged = <_Slot>[];
    for (final w in out) {
      if (merged.isNotEmpty && w.start <= merged.last.end) {
        merged.last = _Slot(
          merged.last.start,
          math.max(merged.last.end, w.end),
        );
      } else {
        merged.add(w);
      }
    }
    return merged;
  }

  /// [s, e) aralığını boş listeden çıkarır (dilimi böler).
  static void _take(List<_Slot> free, int s, int e) {
    for (var i = 0; i < free.length; i++) {
      final f = free[i];
      if (f.end <= s || f.start >= e) continue;
      final pieces = [
        if (f.start < s) _Slot(f.start, s),
        if (f.end > e) _Slot(e, f.end),
      ];
      free.replaceRange(i, i + 1, pieces);
      i += pieces.length - 1;
    }
  }
}

final class _Slot {
  _Slot(this.start, this.end);
  final int start;
  final int end;
}
