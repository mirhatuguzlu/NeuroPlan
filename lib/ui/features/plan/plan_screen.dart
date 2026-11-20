import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/plan/plan_source.dart';
import '../../core/app_shell.dart';
import '../../core/format.dart';
import '../../core/instance_actions.dart';
import '../../core/states.dart';
import '../../core/summaries.dart';

/// Plan: haftanın oluşumları ya da işlerin kuralları (bölümlü seçici).
class PlanScreen extends ConsumerStatefulWidget {
  const PlanScreen({super.key});

  @override
  ConsumerState<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends ConsumerState<PlanScreen> {
  var _tab = 0;
  var _weekOffset = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final data = ref.watch(planDataProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.navPlan),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Gap.l, 0, Gap.l, Gap.m),
            child: SegmentedButton<int>(
              expandedInsets: EdgeInsets.zero,
              segments: [
                ButtonSegment(value: 0, label: Text(l.planWeek)),
                ButtonSegment(value: 1, label: Text(l.planRules)),
              ],
              selected: {_tab},
              onSelectionChanged: (s) => setState(() => _tab = s.first),
            ),
          ),
        ),
      ),
      body: AsyncView<PlanData?>(
        value: data,
        onRetry: () => ref.invalidate(planDataProvider),
        data: (d) {
          if (d == null) return const SkeletonList();
          if (d.activities.isEmpty) {
            return MessageState(
              icon: Symbols.calendar_month_rounded,
              title: l.rulesEmptyTitle,
              body: l.rulesEmptyBody,
              actionLabel: l.todayEmptyAction(context.tone),
              onAction: () => context.push('/add'),
            );
          }
          if (_tab == 1) return _Rules(data: d);
          final today = d.calendar.dayOf(
            DateTime.now().millisecondsSinceEpoch ~/ 60000,
          );
          final monday = today.add(1 - today.weekday + 7 * _weekOffset);
          return _Week(
            monday: monday,
            offset: _weekOffset,
            onShift: (delta) => setState(
              () => _weekOffset = delta == 0 ? 0 : _weekOffset + delta,
            ),
          );
        },
      ),
    );
  }
}

class _Week extends ConsumerWidget {
  const _Week({
    required this.monday,
    required this.offset,
    required this.onShift,
  });

  final Day monday;
  final int offset;
  final ValueChanged<int> onShift;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final plan = ref.watch(weekPlanProvider(monday.iso));
    final nav = Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.s),
      child: Row(
        children: [
          IconButton(
            tooltip: l.prevWeek,
            icon: const Icon(Symbols.chevron_left_rounded),
            onPressed: () => onShift(-1),
          ),
          Expanded(
            child: Text(
              '${dateText(context, monday.iso, weekday: false)} – '
              '${dateText(context, monday.add(6).iso, weekday: false)}',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
          ),
          if (offset != 0)
            TextButton(onPressed: () => onShift(0), child: Text(l.thisWeek)),
          IconButton(
            tooltip: l.nextWeek,
            icon: const Icon(Symbols.chevron_right_rounded),
            onPressed: () => onShift(1),
          ),
        ],
      ),
    );
    return AsyncView<PlanView?>(
      value: plan,
      onRetry: () => ref.invalidate(planDataProvider),
      data: (view) {
        if (view == null) return const SkeletonList();
        final actions = InstanceActions(context, ref, view);
        return ListView(
          padding: EdgeInsets.only(bottom: AppShell.bottomInset(context)),
          children: [
            nav,
            for (var d = 0; d < 7; d++)
              ..._day(context, view, actions, monday.add(d)),
          ],
        );
      },
    );
  }

  List<Widget> _day(
    BuildContext context,
    PlanView view,
    InstanceActions actions,
    Day day,
  ) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final cal = view.calendar;
    final items = view.on(day.iso);
    final free = view.output.freeSlots[day.iso];
    final freeMinutes = free?.fold(0, (s, g) => s + g.minutes);
    final isToday = day.iso == view.today;
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.xs),
        child: Semantics(
          header: true,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  dateText(context, day.iso),
                  style: () {
                    final s = theme.textTheme.titleMedium!.copyWith(
                      color: isToday ? theme.colorScheme.primary : null,
                    );
                    return isToday ? weighted(s, FontWeight.w700) : s;
                  }(),
                ),
              ),
              Text(
                freeMinutes == null
                    ? l.dayUnplanned
                    : l.dayFree(durationText(l, freeMinutes)),
                style: theme.textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
      if (items.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.l),
          child: Text(l.dayEmpty, style: theme.textTheme.bodyMedium),
        ),
      for (final i in items)
        ListTile(
          leading: Text(
            i.isTimed ? clockText(context, cal, i.start!) : '—',
            softWrap: false,
            style: theme.textTheme.titleSmall,
          ),
          title: Text(
            actions.title(i),
            style: i.status == InstanceStatus.planned
                ? null
                : TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
          ),
          subtitle: i.isTimed ? Text(durationText(l, i.end! - i.start!)) : null,
          trailing: i.status == InstanceStatus.planned
              ? IconButton(
                  tooltip: l.actionChangeTime,
                  icon: const Icon(Symbols.schedule_rounded),
                  onPressed: () => actions.changeTime(i),
                )
              : null,
        ),
    ];
  }
}

class _Rules extends ConsumerWidget {
  const _Rules({required this.data});

  final PlanData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final byActivity = <String, List<ScheduleRule>>{};
    for (final r in data.rules) {
      (byActivity[r.activityId] ??= []).add(r);
    }
    final activities = data.activities.values.toList()
      ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    final projects = [
      for (final a in activities)
        if (data.projectOf(a.id) != null) a,
    ];
    final scheduled = [
      for (final a in activities)
        if (byActivity.containsKey(a.id) && data.projectOf(a.id) == null) a,
    ];
    final inbox = [
      for (final a in activities)
        if (!byActivity.containsKey(a.id) && data.projectOf(a.id) == null) a,
    ];
    String titleOf(String id) => data.activities[id]?.title ?? '';

    Widget tile(Activity a, {String? subtitle, VoidCallback? onTap}) =>
        ListTile(
          title: Text(a.title),
          subtitle: subtitle == null ? null : Text(subtitle),
          onTap: onTap,
          trailing: IconButton(
            tooltip: l.commonDelete,
            icon: const Icon(Symbols.delete_rounded),
            onPressed: () async {
              final repo = ref.read(activityRepositoryProvider);
              final ok = await guard(context, () => repo.delete(a.id));
              if (ok && context.mounted) {
                showSnack(
                  context,
                  l.itemDeleted(a.title),
                  actionLabel: l.commonUndo,
                  onAction: () => repo.update(
                    a.id,
                    const ActivitiesCompanion(deletedAt: Value(null)),
                  ),
                );
              }
            },
          ),
        );

    Widget section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.s),
      child: Semantics(
        header: true,
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      ),
    );

    return ListView(
      padding: EdgeInsets.only(bottom: AppShell.bottomInset(context)),
      children: [
        if (scheduled.isNotEmpty) section(l.routinesSection),
        for (final a in scheduled)
          tile(
            a,
            subtitle: [
              for (final r in byActivity[a.id]!)
                '${recurrenceText(context, r.recurrence)} · '
                    '${timingText(context, r.timing, titleOf)}',
            ].join('\n'),
          ),
        if (projects.isNotEmpty) section(l.projectsSection),
        for (final a in projects)
          tile(
            a,
            subtitle: switch (data.projectOf(a.id)!.deadlineAt) {
              final d? => l.projectDeadline(
                dateText(
                  context,
                  data.calendar.dayOf(d.millisecondsSinceEpoch ~/ 60000).iso,
                ),
              ),
              null => l.projectNoDeadline,
            },
            onTap: () => context.push('/project/${a.id}'),
          ),
        if (inbox.isNotEmpty) section(l.inboxSection),
        for (final a in inbox) tile(a),
      ],
    );
  }
}
