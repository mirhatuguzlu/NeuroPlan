import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../data/local/app_database.dart';
import '../../../app/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'stats_providers.dart';

/// Analiz sayfaları; her biri tek soruya cevap verir (Aşama 5 §2).
enum StatPage {
  time(Symbols.donut_large_rounded),
  adherence(Symbols.task_alt_rounded),
  bestHours(Symbols.schedule_rounded),
  consistency(Symbols.local_fire_department_rounded),
  quality(Symbols.monitoring_rounded),
  interruptions(Symbols.notifications_paused_rounded),
  modes(Symbols.difference_rounded),
  brain(Symbols.psychology_rounded),
  projects(Symbols.flag_rounded),
  sleep(Symbols.bedtime_rounded),
  balance(Symbols.balance_rounded),
  weekly(Symbols.summarize_rounded);

  const StatPage(this.icon);
  final IconData icon;

  static StatPage? of(String name) =>
      values.where((p) => p.name == name).firstOrNull;

  String question(L10n l) => switch (this) {
    time => l.stQTime,
    adherence => l.stQAdherence,
    bestHours => l.stQBestHours,
    consistency => l.stQConsistency,
    quality => l.stQQuality,
    interruptions => l.stQInterruptions,
    modes => l.stQModes,
    brain => l.stQBrain,
    projects => l.stQProjects,
    sleep => l.stQSleep,
    balance => l.stQBalance,
    weekly => l.stQWeekly,
  };

  /// Haftalık rapor ve seri kendi aralığını kullanır.
  bool get hasPeriod =>
      this != weekly && this != consistency && this != projects;
}

/// Analiz sayfasının iskeleti: soru başlık, aralık seçici, içerik. İçerik bir kez
/// hesaplanır; seçim (dokunulan değer) içeriğin kendi durumundadır.
class StatsScaffold extends ConsumerWidget {
  const StatsScaffold({super.key, required this.page, required this.body});

  final StatPage page;
  final List<Widget> Function(
    BuildContext context,
    StatsContext s,
    DayRange range,
  )
  body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final ctx = ref.watch(statsContextProvider);
    final period = ref.watch(statPeriodProvider);
    return Scaffold(
      appBar: AppBar(),
      body: AsyncView<StatsContext>(
        value: ctx,
        onRetry: () {
          ref.invalidate(planDataProvider);
          ref.invalidate(statsSourceProvider);
        },
        data: (s) => ListView(
          padding: const EdgeInsets.fromLTRB(Gap.l, 0, Gap.l, Gap.xxl),
          children: [
            Semantics(
              header: true,
              child: Text(
                page.question(l),
                style: theme.textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: Gap.l),
            if (page.hasPeriod) ...[
              const PeriodPicker(),
              const SizedBox(height: Gap.l),
            ],
            ...body(context, s, s.range(period)),
          ],
        ),
      ),
    );
  }
}

class PeriodPicker extends ConsumerWidget {
  const PeriodPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final p = ref.watch(statPeriodProvider);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<StatPeriod>(
        showSelectedIcon: false,
        segments: [
          for (final v in StatPeriod.values)
            ButtonSegment(
              value: v,
              label: Text(switch (v) {
                StatPeriod.week => l.stPeriodWeek,
                StatPeriod.month => l.stPeriodMonth,
                StatPeriod.quarter => l.stPeriodQuarter,
                StatPeriod.year => l.stPeriodYear,
                StatPeriod.all => l.stPeriodAll,
              }),
            ),
        ],
        selected: {p},
        onSelectionChanged: (s) =>
            ref.read(statPeriodProvider.notifier).set(s.single),
      ),
    );
  }
}

/// Grafiğin tek cümlelik yorumu; değişince ekran okuyucu okur.
class Insight extends StatelessWidget {
  const Insight(this.text, {super.key, this.icon = Symbols.lightbulb_rounded});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: Gap.l),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: Gap.m),
            Expanded(child: Text(text, style: theme.textTheme.titleMedium)),
          ],
        ),
      ),
    );
  }
}

/// Grafik kartı: grafik, lejant ve "liste olarak göster" (tablo görünümü, dataviz §6).
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.child,
    this.legend,
    this.table = const [],
    this.caption,
  });

  final Widget child;
  final Widget? legend;

  /// (etiket, değer) satırları; boşsa liste görünümü yok.
  final List<(String, String)> table;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Gap.m, Gap.l, Gap.l, Gap.s),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            if (legend != null) ...[const SizedBox(height: Gap.m), legend!],
            if (caption != null) ...[
              const SizedBox(height: Gap.s),
              Text(
                caption!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (table.isNotEmpty)
              Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(l.stShowList, style: theme.textTheme.labelLarge),
                  children: [
                    for (final (k, v) in table)
                      MergeSemantics(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Gap.xs),
                          child: Row(
                            children: [
                              Expanded(child: Text(k)),
                              Text(
                                v,
                                style: const TextStyle(
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Boş durum: ne olduğunu anlatan cümle + tek birincil eylem (UX_RULES §4).
class EmptyChart extends StatelessWidget {
  const EmptyChart({
    super.key,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.icon = Symbols.timer_rounded,
  });

  final String body;
  final String actionLabel;
  final VoidCallback onAction;
  final IconData icon;

  /// En yaygın boş durum: henüz odak oturumu yok → Bugün'e git.
  factory EmptyChart.focus(BuildContext context, {String? body}) => EmptyChart(
    body: body ?? context.l10n.stEmptyFocus,
    actionLabel: context.l10n.stEmptyFocusAction,
    onAction: () => context.go('/today'),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Gap.xl),
        child: Column(
          children: [
            ExcludeSemantics(
              child: Icon(icon, size: 40, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: Gap.m),
            Text(
              body,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: Gap.l),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

/// Dokunulan değerin açıklaması + ilgili oturumlar.
class SelectionDetail extends StatelessWidget {
  const SelectionDetail({
    super.key,
    required this.title,
    required this.value,
    required this.sessions,
    required this.s,
  });

  final String title;
  final String value;
  final List<StatSession> sessions;
  final StatsContext s;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final shown = (sessions.toList()..sort((a, b) => b.end - a.end))
        .take(20)
        .toList();
    return Padding(
      padding: const EdgeInsets.only(top: Gap.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            liveRegion: true,
            child: Text('$title · $value', style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: Gap.s),
          if (shown.isEmpty)
            Text(l.stNoSessionsHere, style: theme.textTheme.bodyMedium)
          else ...[
            for (final x in shown) SessionTile(session: x, s: s),
            if (sessions.length > shown.length)
              Text(
                l.stMoreSessions(sessions.length - shown.length),
                style: theme.textTheme.bodySmall,
              ),
          ],
        ],
      ),
    );
  }
}

class SessionTile extends ConsumerWidget {
  const SessionTile({super.key, required this.session, required this.s});

  final StatSession session;
  final StatsContext s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final x = session;
    final roots = {
      for (final r
          in ref.watch(rootCategoriesProvider).value ?? const <RootCategory>[])
        r.key: r,
    };
    final title =
        s.data.activities[x.activityId]?.title ??
        s.data.categories[x.categoryId]?.name ??
        roots[x.rootKey]?.name(context) ??
        l.stFreeSession;
    final mode = switch (x.mode) {
      'pomodoro' => l.modePomodoro,
      'deep' => l.modeDeep,
      _ => l.modeFree,
    };
    final day = sessionDay(x, s.cal).iso;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        x.completed ? Symbols.check_circle_rounded : Symbols.warning_rounded,
      ),
      title: Text(title),
      subtitle: Text(
        [
          '${dateText(context, day, weekday: false)} ${clockText(context, s.cal, x.start)}',
          durationText(l, x.minutes),
          mode,
          if (x.focusRating != null) l.stFocusScoreShort(x.focusRating!),
          if (!x.completed) l.stBroken,
        ].join(' · '),
      ),
    );
  }
}

/// Kısa x ekseni etiketi: gün kovasında "12", hafta kovasında "12 Kas", ayda "Kas".
String bucketLabel(BuildContext context, DayRange b, Granularity g) {
  final d = b.from.utc;
  return switch (g) {
    Granularity.day => '${d.day}',
    Granularity.week => '${d.day}.${d.month}',
    Granularity.month => monthShort(context, d.month),
  };
}

/// Kova adı (seçim başlığı ve liste görünümü).
String bucketTitle(BuildContext context, DayRange b) => b.length == 1
    ? dateText(context, b.from.iso)
    : '${dateText(context, b.from.iso, weekday: false)} – '
          '${dateText(context, b.to.iso, weekday: false)}';

String percentText(BuildContext context, double v) =>
    context.l10n.stPercent(v.round());

String scoreText(BuildContext context, double v) =>
    NumberFormat('0.0', context.localeName).format(v);

Iterable<StatSession> sessionsIn(StatsContext s, DayRange b) =>
    inRange(s.sessions, b, s.cal);
