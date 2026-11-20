import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../core/format.dart';
import 'charts.dart';
import 'stats_page.dart';
import 'stats_providers.dart';
import 'weekly_report.dart';

/// Rota: `/profile/stats/:page`.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key, required this.page});
  final StatPage page;

  @override
  Widget build(BuildContext context) => StatsScaffold(
    page: page,
    body: (c, s, r) => [
      switch (page) {
        StatPage.time => _TimeBody(key: ValueKey(r), s: s, range: r),
        StatPage.adherence => _AdherenceBody(key: ValueKey(r), s: s, range: r),
        StatPage.bestHours => _BestHoursBody(key: ValueKey(r), s: s, range: r),
        StatPage.consistency => _ConsistencyBody(s: s),
        StatPage.quality => _QualityBody(key: ValueKey(r), s: s, range: r),
        StatPage.interruptions => _InterruptionsBody(
          key: ValueKey(r),
          s: s,
          range: r,
        ),
        StatPage.modes => _ModesBody(s: s, range: r),
        StatPage.brain => _BrainBody(key: ValueKey(r), s: s, range: r),
        StatPage.projects => _ProjectsBody(s: s),
        StatPage.sleep => _SleepBody(key: ValueKey(r), s: s, range: r),
        StatPage.balance => _BalanceBody(key: ValueKey(r), s: s, range: r),
        StatPage.weekly => WeeklyReportBody(s: s),
      },
    ],
  );
}

Map<String, RootCategory> _roots(WidgetRef ref) => {
  for (final r
      in ref.watch(rootCategoriesProvider).value ?? const <RootCategory>[])
    r.key: r,
};

String _rootName(BuildContext c, Map<String, RootCategory> roots, String key) =>
    roots[key]?.name(c) ?? c.l10n.stNoCategory;

Widget _rootBadge(Map<String, RootCategory> roots, String key) =>
    RootBadge(icon: roots[key]?.icon, color: roots[key]?.color, size: 32);

/// Kovalı grafiklerin ortak x etiketi.
String Function(int) _x(BuildContext c, List<DayRange> b, DayRange r) {
  final g = granularityFor(r);
  return (i) => bucketLabel(c, b[i], g);
}

// ---------------------------------------------------------------------------
// 1 · Zamanım nereye gidiyor?
// ---------------------------------------------------------------------------

class _TimeBody extends ConsumerStatefulWidget {
  const _TimeBody({super.key, required this.s, required this.range});
  final StatsContext s;
  final DayRange range;

  @override
  ConsumerState<_TimeBody> createState() => _TimeBodyState();
}

class _TimeBodyState extends ConsumerState<_TimeBody> {
  /// Gezinme yolu: [] kökler, ['root:x'] kökün kategorileri, sonra kategori kimlikleri.
  final _path = <String>[];
  String? _leaf;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = widget.s;
    final roots = _roots(ref);
    final t = timeByCategory(s.sessions, widget.range, s.cal);
    if (t.total == 0) return EmptyChart.focus(context);
    final cats = s.data.categories;
    final total = rollUp(t.byCategory, {
      for (final c in cats.values) c.id: c.parentId,
    });
    final node = _path.lastOrNull;
    final rows = <RankedRow>[];
    String pct(int m, int of) =>
        l.stPercent(of == 0 ? 0 : (m * 100 / of).round());
    if (node == null) {
      final list = t.byRoot.entries.toList()..sort((a, b) => b.value - a.value);
      for (final e in list) {
        rows.add(
          RankedRow(
            key: 'root:${e.key}',
            label: _rootName(context, roots, e.key),
            value: e.value.toDouble(),
            valueText: '${durationText(l, e.value)} · ${pct(e.value, t.total)}',
            leading: _rootBadge(roots, e.key),
          ),
        );
      }
    } else {
      final root = node.startsWith('root:') ? node.substring(5) : null;
      final parent = root == null ? node : null;
      final children = [
        for (final c in cats.values)
          if (c.parentId == parent &&
              (root == null || c.rootCategoryKey == root) &&
              (total[c.id] ?? 0) > 0)
            c,
      ]..sort((a, b) => total[b.id]! - total[a.id]!);
      final of = root != null ? t.byRoot[root] ?? 0 : total[node] ?? 0;
      for (final c in children) {
        final hasKids = cats.values.any(
          (k) => k.parentId == c.id && (total[k.id] ?? 0) > 0,
        );
        rows.add(
          RankedRow(
            key: c.id,
            label: c.name,
            value: total[c.id]!.toDouble(),
            valueText:
                '${durationText(l, total[c.id]!)} · ${pct(total[c.id]!, of)}',
            leading: Icon(
              hasKids ? Symbols.folder_rounded : Symbols.circle_rounded,
            ),
          ),
        );
      }
      final own = root != null
          ? t.rootOnly[root] ?? 0
          : t.byCategory[node] ?? 0;
      if (own > 0) {
        rows.add(
          RankedRow(
            key: 'own:$node',
            label: root != null ? l.stUncategorized : l.stDirectly,
            value: own.toDouble(),
            valueText: '${durationText(l, own)} · ${pct(own, of)}',
          ),
        );
      }
    }
    final top = t.byRoot.entries.reduce((a, b) => a.value >= b.value ? a : b);
    String title(String key) => key.startsWith('root:')
        ? _rootName(context, roots, key.substring(5))
        : key.startsWith('own:')
        ? l.stDirectly
        : cats[key]?.name ?? '';
    List<StatSession> leafSessions(String key) {
      final xs = inRange(s.sessions, widget.range, s.cal);
      if (key.startsWith('own:')) {
        final n = key.substring(4);
        return n.startsWith('root:')
            ? [
                for (final x in xs)
                  if ((x.rootKey ?? noCategory) == n.substring(5) &&
                      x.categoryId == null)
                    x,
              ]
            : [
                for (final x in xs)
                  if (x.categoryId == n) x,
              ];
      }
      final under = <String>{key};
      var grew = true;
      while (grew) {
        grew = false;
        for (final c in cats.values) {
          if (under.contains(c.parentId) && under.add(c.id)) grew = true;
        }
      }
      return [
        for (final x in xs)
          if (under.contains(x.categoryId)) x,
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Insight(
          l.stTimeInsight(
            _rootName(context, roots, top.key),
            durationText(l, top.value),
            (top.value * 100 / t.total).round(),
          ),
        ),
        if (_path.isNotEmpty)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton.icon(
              icon: const Icon(Symbols.arrow_back_rounded),
              label: Text(l.stUpLevel),
              onPressed: () => setState(() {
                _path.removeLast();
                _leaf = null;
              }),
            ),
          ),
        if (_path.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.s),
            child: Text(
              _path.map(title).join(' › '),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ChartCard(
          caption: l.stTimeTotal(durationText(l, t.total)),
          child: RankedBars(
            rows: rows,
            onTap: (k) => setState(() {
              final drill =
                  k.startsWith('root:') ||
                  (!k.startsWith('own:') &&
                      cats.values.any(
                        (c) => c.parentId == k && (total[c.id] ?? 0) > 0,
                      ));
              if (drill) {
                _path.add(k);
                _leaf = null;
              } else {
                _leaf = k;
              }
            }),
          ),
        ),
        if (_leaf != null)
          SelectionDetail(
            title: title(_leaf!),
            value: durationText(
              l,
              leafSessions(_leaf!).fold(0, (a, x) => a + x.minutes),
            ),
            sessions: leafSessions(_leaf!),
            s: s,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 2 · Plana ne kadar uyuyorum?
// ---------------------------------------------------------------------------

class _AdherenceBody extends ConsumerStatefulWidget {
  const _AdherenceBody({super.key, required this.s, required this.range});
  final StatsContext s;
  final DayRange range;

  @override
  ConsumerState<_AdherenceBody> createState() => _AdherenceBodyState();
}

class _AdherenceBodyState extends ConsumerState<_AdherenceBody> {
  int? _sel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = widget.s;
    final colors = ChartColors.from(context);
    final hist = ref.watch(planHistoryProvider(widget.range));
    return hist.when(
      loading: () => const _ChartLoading(),
      error: (_, _) => _ChartError(
        onRetry: () => ref.invalidate(planHistoryProvider(widget.range)),
      ),
      data: (h) {
        final a = adherence(h.items, widget.range, s.today);
        if (a.planned == 0) {
          return EmptyChart(
            icon: Symbols.calendar_month_rounded,
            body: l.stEmptyPlan,
            actionLabel: l.stEmptyPlanAction,
            onAction: () => context.push('/add'),
          );
        }
        final b = bucketsOf(
          DayRange(a.days.first.day, a.days.last.day),
          granularityFor(widget.range),
        );
        final planned = ChartSeries(l.stPlanned, [
          for (final x in a.buckets) x.planned.toDouble(),
        ], colors.series[0]);
        final done = ChartSeries(l.stDone, [
          for (final x in a.buckets) x.done.toDouble(),
        ], colors.series[1]);
        final daily = ChartSeries(l.stAdherence, [
          for (final d in a.days) d.percent,
        ], colors.series[0]);
        final sel = _sel == null ? null : a.buckets[_sel!];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Insight(
              l.stAdherenceInsight(a.done, a.planned, a.percent!.round()),
            ),
            ChartCard(
              legend: ChartLegend(series: [planned, done]),
              table: [
                for (var i = 0; i < a.buckets.length; i++)
                  (
                    bucketTitle(context, b[i]),
                    l.stDoneOf(a.buckets[i].done, a.buckets[i].planned),
                  ),
              ],
              child: ColumnChart(
                series: [planned, done],
                xLabel: _x(context, b, widget.range),
                yLabel: (v) => '${v.round()}',
                semantics: l.stAdherenceInsight(
                  a.done,
                  a.planned,
                  a.percent!.round(),
                ),
                selected: _sel,
                onSelect: (i) => setState(() => _sel = i),
              ),
            ),
            const SizedBox(height: Gap.l),
            Text(
              l.stDailyAdherence,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: Gap.s),
            ChartCard(
              child: TrendChart(
                series: [daily],
                maxY: 100,
                xLabel: (i) => '${a.days[i].day.utc.day}',
                yLabel: (v) => l.stPercent(v.round()),
                semantics: l.stDailyAdherence,
              ),
            ),
            if (sel != null)
              SelectionDetail(
                title: bucketTitle(context, b[_sel!]),
                value: l.stDoneOf(sel.done, sel.planned),
                sessions: sessionsIn(s, b[_sel!]).toList(),
                s: s,
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 3 · Ne zaman en iyi odaklanıyorum?
// ---------------------------------------------------------------------------

class _BestHoursBody extends StatefulWidget {
  const _BestHoursBody({super.key, required this.s, required this.range});
  final StatsContext s;
  final DayRange range;

  @override
  State<_BestHoursBody> createState() => _BestHoursBodyState();
}

class _BestHoursBodyState extends State<_BestHoursBody> {
  (int, int)? _sel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = widget.s;
    final h = focusHeat(s.sessions, widget.range, s.cal);
    if (h.rated == 0) {
      return EmptyChart.focus(context, body: l.stEmptyRated);
    }
    final best = h.bestWindow();
    final insight = best == null
        ? l.stBestNeedMore
        : l.stBestInsight(
            clockOfDay(context, best.start * 60),
            clockOfDay(context, (best.end % 24) * 60),
            scoreText(context, best.average),
          );
    final sel = _sel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Insight(insight),
        ChartCard(
          legend: RampLegend(low: '1', high: '5'),
          caption: l.stHeatCaption,
          table: [
            for (var hr = 0; hr < 24; hr++)
              if (h.hour(hr).count > 0)
                (
                  clockOfDay(context, hr * 60),
                  l.stScoreCount(
                    scoreText(context, h.hour(hr).average!),
                    h.hour(hr).count,
                  ),
                ),
          ],
          child: HeatGrid(
            semantics: insight,
            value: (d, hr) => switch (h.average(d, hr)) {
              null => null,
              final v => (v - 1) / 4,
            },
            selected: sel,
            onSelect: (d, hr) => setState(() => _sel = (d, hr)),
          ),
        ),
        if (sel != null)
          SelectionDetail(
            title:
                '${weekdayLong(context, sel.$1)} ${clockOfDay(context, sel.$2 * 60)}',
            value: switch (h.average(sel.$1, sel.$2)) {
              null => l.stNoRating,
              final v => l.stScoreCount(
                scoreText(context, v),
                h.count(sel.$1, sel.$2),
              ),
            },
            sessions: [
              for (final x in inRange(s.sessions, widget.range, s.cal))
                if (x.focusRating != null &&
                    s.cal.dayOf(x.start).weekday == sel.$1 &&
                    s.cal.minuteOfDay(x.start) ~/ 60 == sel.$2)
                  x,
            ],
            s: s,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 4 · Tutarlı mıyım?
// ---------------------------------------------------------------------------

class _ConsistencyBody extends StatefulWidget {
  const _ConsistencyBody({required this.s});
  final StatsContext s;

  @override
  State<_ConsistencyBody> createState() => _ConsistencyBodyState();
}

class _ConsistencyBodyState extends State<_ConsistencyBody> {
  Day? _sel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = widget.s;
    final st = streaks(s.sessions, s.cal, s.today);
    if (st.minutesByDay.isEmpty) return EmptyChart.focus(context);
    const weeks = 53;
    final lastWeek = DayRange.weekOf(s.today).from;
    Day dayAt(int w, int d) => lastWeek.add((w - (weeks - 1)) * 7 + d - 1);
    final peak = st.minutesByDay.values.fold(1, math.max);
    final yearDays = [
      for (var w = 0; w < weeks; w++)
        for (var d = 1; d <= 7; d++)
          if (!dayAt(w, d).isAfter(s.today) &&
              st.minutesByDay.containsKey(dayAt(w, d)))
            dayAt(w, d),
    ];
    final insight = l.stStreakInsight(st.current, st.longest);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Insight(insight, icon: Symbols.local_fire_department_rounded),
        Row(
          children: [
            Expanded(
              child: _Stat(
                label: l.stStreakCurrent,
                value: l.stDays(st.current),
              ),
            ),
            const SizedBox(width: Gap.m),
            Expanded(
              child: _Stat(
                label: l.stStreakLongest,
                value: l.stDays(st.longest),
              ),
            ),
          ],
        ),
        const SizedBox(height: Gap.l),
        ChartCard(
          legend: RampLegend(low: l.stLess, high: l.stMore),
          caption: l.stCalendarCaption(yearDays.length),
          // Hücreler 48 dp'den küçük: aynı bilgi aylık liste olarak da var (UX_RULES §9).
          table: [
            for (final m in bucketsOf(
              DayRange(dayAt(0, 1), s.today),
              Granularity.month,
            ).reversed)
              (
                '${monthShort(context, m.from.utc.month)} ${m.from.utc.year}',
                l.stDays(yearDays.where(m.contains).length),
              ),
          ],
          child: YearCalendar(
            weeks: weeks,
            semantics: l.stCalendarCaption(yearDays.length),
            level: (w, d) {
              final day = dayAt(w, d);
              if (day.isAfter(s.today)) return -1;
              final m = st.minutesByDay[day];
              return m == null ? null : math.max(0.2, m / peak);
            },
            selected: _sel == null
                ? null
                : (
                    weeks -
                        1 -
                        (lastWeek.index - _sel!.add(1 - _sel!.weekday).index) ~/
                            7,
                    _sel!.weekday,
                  ),
            onSelect: (w, d) => setState(() => _sel = dayAt(w, d)),
          ),
        ),
        if (_sel != null)
          SelectionDetail(
            title: dateText(context, _sel!.iso),
            value: durationText(l, st.minutesByDay[_sel!] ?? 0),
            sessions: sessionsIn(s, DayRange(_sel!, _sel!)).toList(),
            s: s,
          ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MergeSemantics(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Gap.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelLarge),
              const SizedBox(height: Gap.xs),
              Text(value, style: theme.textTheme.headlineSmall),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5 · Odak kalitem nasıl değişiyor?
// ---------------------------------------------------------------------------

class _QualityBody extends StatefulWidget {
  const _QualityBody({super.key, required this.s, required this.range});
  final StatsContext s;
  final DayRange range;

  @override
  State<_QualityBody> createState() => _QualityBodyState();
}

class _QualityBodyState extends State<_QualityBody> {
  int? _sel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = widget.s;
    final colors = ChartColors.from(context);
    final q = qualityTrend(s.sessions, widget.range, s.cal);
    if (q.every((p) => p.count == 0)) {
      return EmptyChart.focus(context, body: l.stEmptyRated);
    }
    final focus = ChartSeries(l.stFocusScore, [
      for (final p in q) p.focus,
    ], colors.series[0]);
    final fatigue = ChartSeries(l.stFatigueScore, [
      for (final p in q) p.fatigue,
    ], colors.series[1]);
    final delta = halfDelta(focus.values);
    final insight = switch (delta) {
      null => l.stQualityNeedMore,
      final d when d >= 0.3 => l.stQualityUp(scoreText(context, d)),
      final d when d <= -0.3 => l.stQualityDown(scoreText(context, -d)),
      _ => l.stQualityStable,
    };
    final buckets = [for (final p in q) p.bucket];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Insight(insight),
        ChartCard(
          legend: ChartLegend(series: [focus, fatigue]),
          caption: l.stQualityCaption,
          table: [
            for (final p in q)
              if (p.count > 0)
                (
                  bucketTitle(context, p.bucket),
                  l.stFocusFatigue(
                    p.focus == null ? '–' : scoreText(context, p.focus!),
                    p.fatigue == null ? '–' : scoreText(context, p.fatigue!),
                  ),
                ),
          ],
          child: TrendChart(
            series: [focus, fatigue],
            minY: 1,
            maxY: 5,
            xLabel: _x(context, buckets, widget.range),
            yLabel: (v) => scoreText(context, v),
            semantics: insight,
            selected: _sel,
            onSelect: (i) => setState(() => _sel = i),
          ),
        ),
        if (_sel != null)
          SelectionDetail(
            title: bucketTitle(context, q[_sel!].bucket),
            value: l.stFocusFatigue(
              q[_sel!].focus == null
                  ? '–'
                  : scoreText(context, q[_sel!].focus!),
              q[_sel!].fatigue == null
                  ? '–'
                  : scoreText(context, q[_sel!].fatigue!),
            ),
            sessions: sessionsIn(s, q[_sel!].bucket).toList(),
            s: s,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 6 · Ne beni bölüyor?
// ---------------------------------------------------------------------------

String reasonText(BuildContext c, String r) => switch (r) {
  'app_left' => c.l10n.stReasonAppLeft,
  'notification_shade' => c.l10n.stReasonShade,
  'screen_off' => c.l10n.stReasonScreenOff,
  'phone_call' => c.l10n.stReasonCall,
  'alarm' => c.l10n.stReasonAlarm,
  _ => c.l10n.stReasonOther,
};

class _InterruptionsBody extends StatefulWidget {
  const _InterruptionsBody({super.key, required this.s, required this.range});
  final StatsContext s;
  final DayRange range;

  @override
  State<_InterruptionsBody> createState() => _InterruptionsBodyState();
}

class _InterruptionsBodyState extends State<_InterruptionsBody> {
  String? _reason;
  int? _hour;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = widget.s;
    final st = interruptionStats(
      s.source.interruptions,
      s.sessions,
      widget.range,
      s.cal,
    );
    if (st.sessions == 0) return EmptyChart.focus(context);
    if (st.total == 0) {
      return Insight(l.stNoInterruptions, icon: Symbols.check_circle_rounded);
    }
    final reasons = st.byReason.entries.toList()
      ..sort((a, b) => b.value - a.value);
    final hours = ChartSeries(l.stInterruptions, [
      for (final n in st.byHour) n.toDouble(),
    ], ChartColors.from(context).series[0]);
    final insight = l.stInterruptInsight(
      reasonText(context, st.topReason!),
      clockOfDay(context, st.peakHour! * 60),
      st.total,
    );
    final ids = <String>{
      for (final i in s.source.interruptions)
        if (widget.range.contains(s.cal.dayOf(i.at)) &&
            (_reason == null || i.reason == _reason) &&
            (_hour == null || s.cal.minuteOfDay(i.at) ~/ 60 == _hour))
          i.sessionId,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Insight(insight),
        Row(
          children: [
            Expanded(
              child: _Stat(label: l.stInterruptions, value: '${st.total}'),
            ),
            const SizedBox(width: Gap.m),
            Expanded(
              child: _Stat(
                label: l.stPerSession,
                value: scoreText(context, st.perSession),
              ),
            ),
          ],
        ),
        const SizedBox(height: Gap.l),
        Text(l.stByReason, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: Gap.s),
        ChartCard(
          child: RankedBars(
            rows: [
              for (final e in reasons)
                RankedRow(
                  key: e.key,
                  label: reasonText(context, e.key),
                  value: e.value.toDouble(),
                  valueText: '${e.value}',
                ),
            ],
            onTap: (k) => setState(() {
              _reason = k;
              _hour = null;
            }),
          ),
        ),
        const SizedBox(height: Gap.l),
        Text(l.stByHour, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: Gap.s),
        ChartCard(
          table: [
            for (var h = 0; h < 24; h++)
              if (st.byHour[h] > 0)
                (clockOfDay(context, h * 60), '${st.byHour[h]}'),
          ],
          child: ColumnChart(
            series: [hours],
            xLabel: (i) => '$i',
            yLabel: (v) => '${v.round()}',
            semantics: insight,
            selected: _hour,
            onSelect: (i) => setState(() {
              _hour = i;
              _reason = null;
            }),
          ),
        ),
        if (_reason != null || _hour != null)
          SelectionDetail(
            title: _reason != null
                ? reasonText(context, _reason!)
                : clockOfDay(context, _hour! * 60),
            value: _reason != null
                ? '${st.byReason[_reason] ?? 0}'
                : '${st.byHour[_hour!]}',
            sessions: [
              for (final x in s.sessions)
                if (ids.contains(x.id)) x,
            ],
            s: s,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 7 · Pomodoro mu derin çalışma mı?
// ---------------------------------------------------------------------------

class _ModesBody extends StatelessWidget {
  const _ModesBody({required this.s, required this.range});
  final StatsContext s;
  final DayRange range;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final colors = ChartColors.from(context);
    final c = compareModes(s.sessions, range, s.cal);
    final note = Padding(
      padding: const EdgeInsets.only(top: Gap.l),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(
              Symbols.science_rounded,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: Gap.m),
          Expanded(
            child: Text(l.stModesScience, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
    if (!c.enough) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Insight(l.stModesNeedMore(c.pomodoroMissing, c.deepMissing)),
          for (final (label, st) in [
            (l.modePomodoro, c.pomodoro),
            (l.modeDeep, c.deep),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.m),
              child: MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.stModeProgress(label, math.min(st.sessions, 5)),
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: Gap.xs),
                    LinearProgressIndicator(
                      value:
                          math.min(st.sessions, 5) / ModeComparison.minSessions,
                    ),
                  ],
                ),
              ),
            ),
          EmptyChart.focus(context, body: l.stModesHow),
          note,
        ],
      );
    }
    final pom = ChartSeries(l.modePomodoro, [
      c.pomodoro.avgFocus,
      c.pomodoro.avgFatigue,
    ], colors.series[0]);
    final deep = ChartSeries(l.modeDeep, [
      c.deep.avgFocus,
      c.deep.avgFatigue,
    ], colors.series[1]);
    String sc(double? v) => v == null ? '–' : scoreText(context, v);
    String rate(double? v) => v == null ? '–' : l.stPercent((v * 100).round());
    final insight = switch (c.higherFocus) {
      'pomodoro' => l.stModesPomodoroHigher(
        sc(c.pomodoro.avgFocus),
        sc(c.deep.avgFocus),
      ),
      'deep' => l.stModesDeepHigher(
        sc(c.deep.avgFocus),
        sc(c.pomodoro.avgFocus),
      ),
      _ => l.stModesClose,
    };
    final xs = inRange(s.sessions, range, s.cal);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Insight(insight),
        ChartCard(
          legend: ChartLegend(series: [pom, deep]),
          table: [
            (
              l.stFocusScore,
              '${sc(c.pomodoro.avgFocus)} · ${sc(c.deep.avgFocus)}',
            ),
            (
              l.stFatigueScore,
              '${sc(c.pomodoro.avgFatigue)} · ${sc(c.deep.avgFatigue)}',
            ),
          ],
          child: ColumnChart(
            series: [pom, deep],
            xLabel: (i) => i == 0 ? l.stFocusScore : l.stFatigueScore,
            yLabel: (v) => scoreText(context, v),
            semantics: insight,
          ),
        ),
        const SizedBox(height: Gap.l),
        for (final (label, a, b) in [
          (
            l.stCompletion,
            rate(c.pomodoro.completionRate),
            rate(c.deep.completionRate),
          ),
          (
            l.stAvgLength,
            durationText(l, (c.pomodoro.avgMinutes ?? 0).round()),
            durationText(l, (c.deep.avgMinutes ?? 0).round()),
          ),
          (l.stSessions, '${c.pomodoro.sessions}', '${c.deep.sessions}'),
        ])
          MergeSemantics(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label),
              subtitle: Text('${l.modePomodoro}: $a · ${l.modeDeep}: $b'),
            ),
          ),
        for (final (label, mode) in [
          (l.modePomodoro, 'pomodoro'),
          (l.modeDeep, 'deep'),
        ])
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(l.stModeSessions(label)),
            children: [
              for (final x in xs.where((x) => x.mode == mode).take(20))
                SessionTile(session: x, s: s),
            ],
          ),
        note,
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 8 · Beynim nasıl gelişiyor?
// ---------------------------------------------------------------------------

class _BrainBody extends StatefulWidget {
  const _BrainBody({super.key, required this.s, required this.range});
  final StatsContext s;
  final DayRange range;

  @override
  State<_BrainBody> createState() => _BrainBodyState();
}

class _BrainBodyState extends State<_BrainBody> {
  int? _sel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = widget.s;
    final colors = ChartColors.from(context);
    String name(String k) => s.regions[k]?.name(context) ?? k;
    final g = brainGrowth(
      s.history.events,
      widget.range,
      s.cal,
      s.regions.keys.toList(),
    );
    final fading = [
      for (final r in s.brain.regions.values)
        if (isFading(r.total ~/ unitsPerNeuron, r.brightness)) r,
    ]..sort((a, b) => a.brightness - b.brightness);
    if (s.history.events.isEmpty) return EmptyChart.focus(context);
    final top = g.top();
    final series = [
      for (var i = 0; i < top.length; i++)
        ChartSeries(name(top[i]), [
          for (final v in g.neurons[top[i]]!) v.toDouble(),
        ], colors.series[i]),
    ];
    final insight = top.isEmpty
        ? l.stBrainNoGrowth
        : l.stBrainInsight(name(top.first), g.gained[top.first]!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Insight(insight, icon: Symbols.psychology_rounded),
        if (series.isNotEmpty)
          ChartCard(
            legend: ChartLegend(series: series),
            caption: l.stBrainCaption(g.connectionsGained),
            table: [
              for (final k in top) (name(k), l.stNeuronsGained(g.gained[k]!)),
            ],
            child: TrendChart(
              series: series,
              xLabel: _x(context, g.buckets, widget.range),
              yLabel: (v) => '${v.round()}',
              semantics: insight,
              selected: _sel,
              onSelect: (i) => setState(() => _sel = i),
            ),
          ),
        if (_sel != null)
          SelectionDetail(
            title: bucketTitle(context, g.buckets[_sel!]),
            value: [for (final k in top) '${name(k)} ${g.neurons[k]![_sel!]}']
                .join(' · '),
            sessions: sessionsIn(s, g.buckets[_sel!]).toList(),
            s: s,
          ),
        const SizedBox(height: Gap.l),
        Text(l.stFadingTitle, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: Gap.xs),
        if (fading.isEmpty)
          Text(l.stFadingNone)
        else ...[
          Text(l.stFadingBody, style: Theme.of(context).textTheme.bodySmall),
          for (final r in fading)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Symbols.psychology_rounded),
              title: Text(name(r.key)),
              subtitle: Text(l.stBrightness((r.brightness / 10).round())),
              trailing: const Icon(Symbols.chevron_right_rounded),
              onTap: () => context.push('/brain/region/${r.key}'),
            ),
        ],
        const SizedBox(height: Gap.m),
        Text(l.stBrainMetaphor, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 9 · Projelerim yetişecek mi?
// ---------------------------------------------------------------------------

class _ProjectsBody extends ConsumerWidget {
  const _ProjectsBody({required this.s});
  final StatsContext s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final projects = [
      for (final p in s.data.projects)
        if (s.data.activities[p.activityId] != null) p,
    ];
    if (projects.isEmpty) {
      return EmptyChart(
        icon: Symbols.flag_rounded,
        body: l.stEmptyProjects,
        actionLabel: l.stEmptyProjectsAction,
        onAction: () => context.push('/add'),
      );
    }
    final view = ref.watch(horizonProvider);
    return switch (view) {
      AsyncData(value: final v?) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in projects)
            Padding(
              padding: const EdgeInsets.only(bottom: Gap.l),
              child: _ProjectBurn(s: s, project: p, view: v),
            ),
        ],
      ),
      AsyncError() => _ChartError(
        onRetry: () => ref.invalidate(planDataProvider),
      ),
      _ => const _ChartLoading(),
    };
  }
}

class _ProjectBurn extends StatefulWidget {
  const _ProjectBurn({
    required this.s,
    required this.project,
    required this.view,
  });
  final StatsContext s;
  final Project project;
  final PlanView view;

  @override
  State<_ProjectBurn> createState() => _ProjectBurnState();
}

class _ProjectBurnState extends State<_ProjectBurn> {
  int? _sel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final s = widget.s;
    final p = widget.project;
    final a = s.data.activities[p.activityId]!;
    final total = p.totalMinutes;
    final header = Row(
      children: [
        const ExcludeSemantics(child: Icon(Symbols.flag_rounded)),
        const SizedBox(width: Gap.s),
        Expanded(child: Text(a.title, style: theme.textTheme.titleMedium)),
        IconButton(
          tooltip: l.stOpenProject,
          icon: const Icon(Symbols.chevron_right_rounded),
          onPressed: () => context.push('/project/${a.id}'),
        ),
      ],
    );
    if (total == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(Gap.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [header, Text(l.stProjectNoTotal)],
          ),
        ),
      );
    }
    // Proje ekranıyla aynı ölçü: yapılan ve planlanan parçalar (ruleId yok).
    final chunks = [
      for (final i in s.data.instances)
        if (i.activityId == a.id &&
            i.ruleId == null &&
            i.startAt != null &&
            i.endAt != null)
          i,
    ];
    int len(PlanInstance i) => i.endAt!.difference(i.startAt!).inMinutes;
    Day dayOf(DateTime t) => s.cal.dayOf(t.millisecondsSinceEpoch ~/ 60000);
    final start = dayOf(a.createdAt);
    final b = burndown(
      totalMinutes: total,
      start: start.isAfter(s.today) ? s.today : start,
      today: s.today,
      work: [
        for (final i in chunks)
          if (i.status == 'done') (day: dayOf(i.startAt!), minutes: len(i)),
      ],
      planned: [
        for (final i in chunks)
          if (i.status == 'planned' && i.endAt!.isAfter(s.now))
            (day: dayOf(i.startAt!), minutes: len(i)),
        for (final c in widget.view.output.proposals)
          if (c.activityId == a.id)
            (day: Day.parse(c.date), minutes: c.minutes),
      ],
    );
    final deadline = p.deadlineAt == null ? null : dayOf(p.deadlineAt!);
    final ok = b.onTime(deadline);
    final finishText = b.remaining == 0
        ? l.stProjectDone
        : b.finish == null
        ? l.stProjectNoForecast
        : (b.byPlan ? l.stProjectFinishPlan : l.stProjectFinishPace)(
            dateText(context, b.finish!.iso),
          );
    // Uzun projede noktalar seyreltilir (en çok ~60).
    final step = math.max(1, (b.points.length / 60).ceil());
    final pts = [
      for (var i = 0; i < b.points.length; i += step) b.points[i],
      if ((b.points.length - 1) % step != 0) b.points.last,
    ];
    final series = ChartSeries(l.stRemaining, [
      for (final x in pts) x.remaining / 60,
    ], ChartColors.from(context).series[0]);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.m, Gap.s, Gap.l, Gap.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Text(
              l.stRemainingOf(
                durationText(l, b.remaining),
                durationText(l, total),
              ),
            ),
            const SizedBox(height: Gap.xs),
            Semantics(
              liveRegion: true,
              child: Row(
                children: [
                  ExcludeSemantics(
                    child: Icon(
                      deadline == null || ok
                          ? Symbols.check_circle_rounded
                          : Symbols.warning_rounded,
                      color: deadline == null || ok
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(width: Gap.s),
                  Expanded(
                    child: Text(
                      deadline == null
                          ? finishText
                          : '$finishText · ${ok ? l.stProjectOnTime(dateText(context, deadline.iso)) : l.stProjectLate(dateText(context, deadline.iso))}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Gap.m),
            TrendChart(
              series: [series],
              height: 180,
              xLabel: (i) => '${pts[i].day.utc.day}.${pts[i].day.utc.month}',
              yLabel: (v) => l.hoursShort(v.round()),
              semantics: '${a.title}: $finishText',
              selected: _sel,
              onSelect: (i) => setState(() => _sel = i),
            ),
            if (_sel != null)
              Padding(
                padding: const EdgeInsets.only(top: Gap.s),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    '${dateText(context, pts[_sel!].day.iso)} · '
                    '${l.stRemainingOf(durationText(l, pts[_sel!].remaining), durationText(l, total))}',
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10 · Uykum yeterli mi?
// ---------------------------------------------------------------------------

class _SleepBody extends ConsumerStatefulWidget {
  const _SleepBody({super.key, required this.s, required this.range});
  final StatsContext s;
  final DayRange range;

  @override
  ConsumerState<_SleepBody> createState() => _SleepBodyState();
}

class _SleepBodyState extends ConsumerState<_SleepBody> {
  int? _sel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final s = widget.s;
    final hist = ref.watch(planHistoryProvider(widget.range));
    return hist.when(
      loading: () => const _ChartLoading(),
      error: (_, _) => _ChartError(
        onRetry: () => ref.invalidate(planHistoryProvider(widget.range)),
      ),
      data: (h) {
        final st = sleepStats(
          h.sleep,
          widget.range,
          s.data.profile.sleepGoalMinutes,
        );
        if (st.average == null) {
          return EmptyChart(
            icon: Symbols.bedtime_rounded,
            body: l.stEmptySleep,
            actionLabel: l.stEmptySleepAction,
            onAction: () => context.push('/profile/settings'),
          );
        }
        final b = bucketsOf(widget.range);
        final avg = [
          for (final x in b)
            () {
              final v = [for (final d in x.days) ?st.nights[d]];
              return v.isEmpty
                  ? null
                  : v.reduce((p, q) => p + q) / v.length / 60;
            }(),
        ];
        final series = ChartSeries(
          l.stSleepPlanned,
          avg,
          ChartColors.from(context).series[0],
        );
        final diff = st.difference!.round();
        final insight = l.stSleepInsight(
          durationText(l, st.average!.round()),
          diff == 0
              ? l.stSleepOnGoal
              : diff > 0
              ? l.stSleepAbove(durationText(l, diff))
              : l.stSleepBelow(durationText(l, -diff)),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Insight(insight, icon: Symbols.bedtime_rounded),
            if (st.belowNotice)
              Card(
                color: theme.colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(Gap.l),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const ExcludeSemantics(
                            child: Icon(Symbols.info_rounded),
                          ),
                          const SizedBox(width: Gap.s),
                          Expanded(child: Text(l.stSleepNotice)),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () => context.push('/profile/settings'),
                          child: Text(l.stEmptySleepAction),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: Gap.m),
            ChartCard(
              caption: l.stSleepGoalLine(durationText(l, st.goal)),
              table: [
                for (var i = 0; i < b.length; i++)
                  if (avg[i] != null)
                    (
                      bucketTitle(context, b[i]),
                      durationText(l, (avg[i]! * 60).round()),
                    ),
              ],
              child: ColumnChart(
                series: [series],
                reference: st.goal / 60,
                xLabel: _x(context, b, widget.range),
                yLabel: (v) => l.hoursShort(v.round()),
                semantics: insight,
                selected: _sel,
                onSelect: (i) => setState(() => _sel = i),
              ),
            ),
            if (_sel != null && avg[_sel!] != null)
              Padding(
                padding: const EdgeInsets.only(top: Gap.l),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    '${bucketTitle(context, b[_sel!])} · ${durationText(l, (avg[_sel!]! * 60).round())}',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// 11 · Dengeli miyim?
// ---------------------------------------------------------------------------

class _BalanceBody extends ConsumerStatefulWidget {
  const _BalanceBody({super.key, required this.s, required this.range});
  final StatsContext s;
  final DayRange range;

  @override
  ConsumerState<_BalanceBody> createState() => _BalanceBodyState();
}

class _BalanceBodyState extends ConsumerState<_BalanceBody> {
  String? _sel;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = widget.s;
    final roots = _roots(ref);
    final keys =
        (roots.values.toList()..sort((a, b) => a.sortOrder - b.sortOrder))
            .map((r) => r.key)
            .toList();
    final t = timeByCategory(s.sessions, widget.range, s.cal);
    if (t.total == 0) return EmptyChart.focus(context);
    final b = balance(t, keys);
    final insight = b.neglected.isEmpty
        ? l.stBalanceAll
        : l.stBalanceNeglected(
            b.neglected.length,
            b.neglected.map((k) => _rootName(context, roots, k)).join(', '),
          );
    final sorted = [...keys]..sort((a, c) => b.minutes[c]! - b.minutes[a]!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Insight(insight, icon: Symbols.balance_rounded),
        ChartCard(
          caption: l.stBalanceCaption,
          child: RankedBars(
            rows: [
              for (final k in sorted)
                RankedRow(
                  key: k,
                  label: _rootName(context, roots, k),
                  value: b.minutes[k]!.toDouble(),
                  valueText: b.minutes[k] == 0
                      ? l.stNone
                      : '${durationText(l, b.minutes[k]!)} · ${l.stPercent((b.share(k) * 100).round())}',
                  leading: _rootBadge(roots, k),
                  tappable: b.minutes[k]! > 0,
                ),
            ],
            onTap: (k) => setState(() => _sel = k),
          ),
        ),
        if (_sel != null)
          SelectionDetail(
            title: _rootName(context, roots, _sel!),
            value: durationText(l, b.minutes[_sel!]!),
            sessions: [
              for (final x in inRange(s.sessions, widget.range, s.cal))
                if (x.rootKey == _sel) x,
            ],
            s: s,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------

class _ChartLoading extends StatelessWidget {
  const _ChartLoading();

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.stLoading,
    child: const SizedBox(
      height: 240,
      child: Center(child: CircularProgressIndicator()),
    ),
  );
}

class _ChartError extends StatelessWidget {
  const _ChartError({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => EmptyChart(
    icon: Symbols.warning_rounded,
    body: context.l10n.errorBody,
    actionLabel: context.l10n.commonRetry,
    onAction: onRetry,
  );
}
