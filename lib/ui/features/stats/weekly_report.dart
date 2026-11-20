import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../data/local/app_database.dart';
import '../../../app/share.dart';
import '../../../app/theme.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'stats_page.dart';
import 'stats_providers.dart';

/// 12 · Haftalık rapor: bu hafta ve geçen hafta; görsel olarak paylaşılabilir.
class WeeklyReportBody extends ConsumerStatefulWidget {
  const WeeklyReportBody({super.key, required this.s});
  final StatsContext s;

  @override
  ConsumerState<WeeklyReportBody> createState() => _WeeklyReportBodyState();
}

class _WeeklyReportBodyState extends ConsumerState<WeeklyReportBody> {
  final _boundary = GlobalKey();

  Future<void> _share() async {
    final l = context.l10n;
    try {
      final r =
          _boundary.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      final image = await r.toImage(pixelRatio: 3);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      await shareFile(
        png!.buffer.asUint8List(),
        'neuroplan-${widget.s.today.iso}.png',
        'image/png',
      );
    } on Object catch (e) {
      debugPrint('[report] paylaşım: $e');
      if (mounted) showSnack(context, l.stShareError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final s = widget.s;
    final week = DayRange.weekOf(s.today);
    final hist = ref.watch(
      planHistoryProvider(DayRange(week.previous.from, week.to)),
    );
    final items = hist.value?.items ?? const <StatPlanItem>[];
    final r = weeklyReport(s.sessions, items, s.today, s.cal);
    if (r.current.focusMinutes == 0 && r.previous.focusMinutes == 0) {
      return EmptyChart.focus(context, body: l.stEmptyWeekly);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RepaintBoundary(
          key: _boundary,
          child: _ReportCard(current: r.current, previous: r.previous),
        ),
        const SizedBox(height: Gap.l),
        BusyButton(label: l.stShareImage, onPressed: _share),
      ],
    );
  }
}

class _ReportCard extends ConsumerWidget {
  const _ReportCard({required this.current, required this.previous});
  final WeekSummary current;
  final WeekSummary previous;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final roots = {
      for (final r
          in ref.watch(rootCategoriesProvider).value ?? const <RootCategory>[])
        r.key: r,
    };
    String delta(num now, num before, String Function(num) fmt) {
      final d = now - before;
      if (d == 0) return l.stSameAsLastWeek;
      return d > 0 ? l.stUpBy(fmt(d)) : l.stDownBy(fmt(-d));
    }

    String pct(double? v) => v == null ? '–' : l.stPercent(v.round());
    String score(double? v) => v == null ? '–' : scoreText(context, v);
    final rows = <(IconData, String, String, String?)>[
      (
        Symbols.timer_rounded,
        l.stWeekFocus,
        durationText(l, current.focusMinutes),
        delta(
          current.focusMinutes,
          previous.focusMinutes,
          (d) => durationText(l, d.round()),
        ),
      ),
      (
        Symbols.check_circle_rounded,
        l.stWeekSessions,
        '${current.completedSessions}',
        delta(
          current.completedSessions,
          previous.completedSessions,
          (d) => '$d',
        ),
      ),
      (
        Symbols.local_fire_department_rounded,
        l.stWeekActiveDays,
        l.stDays(current.activeDays),
        delta(
          current.activeDays,
          previous.activeDays,
          (d) => l.stDays(d.round()),
        ),
      ),
      (
        Symbols.task_alt_rounded,
        l.stAdherence,
        pct(current.adherencePercent),
        current.adherencePercent == null || previous.adherencePercent == null
            ? null
            : delta(
                current.adherencePercent!.round(),
                previous.adherencePercent!.round(),
                (d) => l.stPoints(d.round()),
              ),
      ),
      (
        Symbols.monitoring_rounded,
        l.stFocusScore,
        score(current.avgFocus),
        current.avgFocus == null || previous.avgFocus == null
            ? null
            : delta(
                (current.avgFocus! * 10).round(),
                (previous.avgFocus! * 10).round(),
                (d) => scoreText(context, d / 10),
              ),
      ),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Gap.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.appTitle,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: Gap.xs),
            Text(
              bucketTitle(context, current.range),
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: Gap.l),
            for (final (icon, label, value, change) in rows)
              MergeSemantics(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Gap.s),
                  child: Row(
                    children: [
                      ExcludeSemantics(
                        child: Icon(icon, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: Gap.m),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label, style: theme.textTheme.bodyMedium),
                            if (change != null)
                              Text(
                                change,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(value, style: theme.textTheme.titleLarge),
                    ],
                  ),
                ),
              ),
            if (current.topRoot != null) ...[
              const Divider(height: Gap.xl),
              Text(
                l.stWeekTop(
                  roots[current.topRoot]?.name(context) ?? l.stNoCategory,
                ),
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
