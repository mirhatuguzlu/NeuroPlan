import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../core/app_shell.dart';
import '../../core/format.dart';
import '../../core/instance_actions.dart';
import '../../core/states.dart';

/// Bugün: zaman çizelgesi; şu anki ve sıradaki iş öne çıkar, boş dilimler görünür.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(horizonProvider);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: AsyncView<PlanView?>(
          value: plan,
          onRetry: () => ref.invalidate(planDataProvider),
          data: (view) =>
              view == null ? const SkeletonList() : _TodayBody(view: view),
        ),
      ),
    );
  }
}

class _TodayBody extends ConsumerWidget {
  const _TodayBody({required this.view});

  final PlanView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final today = view.today;
    final out = view.output;
    final cal = view.calendar;
    final dayStart = cal.dayStart(Day.parse(today));
    final dayEnd = cal.dayEnd(Day.parse(today));
    final now = view.nowMinute;
    final actions = InstanceActions(context, ref, view);

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.l, Gap.l, Gap.s),
      child: Semantics(
        header: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.navToday, style: theme.textTheme.headlineMedium),
            Text(dateText(context, today), style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );

    if (view.data.activities.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          Expanded(
            child: MessageState(
              icon: Symbols.today_rounded,
              title: l.todayEmptyTitle(context.tone),
              body: l.todayEmptyBody(context.tone),
              actionLabel: l.todayEmptyAction(context.tone),
              onAction: () => context.push('/add'),
            ),
          ),
        ],
      );
    }

    final overflow = {for (final o in out.overflow) o.instanceId: o.dropped};
    final overlaps = <String, String>{};
    for (final o in out.issues.whereType<Overlap>()) {
      overlaps[o.a] = o.b;
      overlaps[o.b] = o.a;
    }
    final cyclic = {
      for (final c in out.issues.whereType<DependencyCycle>()) ...c.activityIds,
    };
    final missing = {
      for (final m in out.issues.whereType<MissingAnchorData>()) m.ruleId,
    };
    final todays = [
      for (final i in out.instances)
        if (i.date == today ||
            (i.isTimed && i.end! > dayStart && i.start! < dayEnd))
          i,
    ];
    final timed = [
      for (final i in todays)
        if (i.isTimed && !overflow.containsKey(i.id)) i,
    ];
    final untimed = [
      for (final i in todays)
        if (!i.isTimed && !overflow.containsKey(i.id) && i.date == today) i,
    ];
    final overflowed = [
      for (final i in todays)
        if (overflow.containsKey(i.id)) i,
    ];
    final proposals = [
      for (final p in out.proposals)
        if (p.date == today) p,
    ];
    final current = timed
        .where(
          (i) =>
              i.status == InstanceStatus.planned &&
              i.start! <= now &&
              i.end! > now,
        )
        .firstOrNull;
    final next = timed
        .where((i) => i.status == InstanceStatus.planned && i.start! > now)
        .firstOrNull;
    final rows = <(int, Widget)>[
      for (final i in timed)
        (
          i.start!,
          _InstanceTile(
            view: view,
            instance: i,
            actions: actions,
            highlight: i.id == current?.id || i.id == next?.id,
            conflictWith: overlaps[i.id],
            cyclic: cyclic.contains(i.activityId),
            missingAnchor: missing.contains(i.ruleId),
          ),
        ),
      for (final s in out.freeSlots[today] ?? const <TimeSlot>[])
        (s.start, _FreeTile(view: view, slot: s)),
      for (final p in proposals)
        (p.start, _ProposalTile(view: view, proposal: p)),
    ]..sort((a, b) => a.$1.compareTo(b.$1));

    final choices = [
      for (final c in out.variantChoices)
        if (c.date == today) c,
    ];

    return ListView(
      padding: EdgeInsets.only(bottom: AppShell.bottomInset(context)),
      children: [
        header,
        if (out.unplannedDays.contains(today))
          _Banner(icon: Symbols.event_busy_rounded, text: l.todayUnplanned),
        for (final c in choices) _VariantChooser(view: view, choice: c),
        if (current != null || next != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Gap.l,
              vertical: Gap.s,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (current != null)
                  Expanded(
                    child: _FocusCard(
                      label: l.todayNow,
                      title: actions.title(current),
                      detail: l.todayEnds(
                        clockText(context, cal, current.end!),
                      ),
                      strong: true,
                    ),
                  ),
                if (current != null && next != null)
                  const SizedBox(width: Gap.m),
                if (next != null)
                  Expanded(
                    child: _FocusCard(
                      label: l.todayNext,
                      title: actions.title(next),
                      detail:
                          '${clockText(context, cal, next.start!)} · '
                          '${l.inDuration(durationText(l, next.start! - now))}',
                      strong: current == null,
                    ),
                  ),
              ],
            ),
          ),
        if (timed.isEmpty && untimed.isEmpty && proposals.isEmpty)
          Padding(
            padding: const EdgeInsets.all(Gap.l),
            child: Text(l.todayNothing, style: theme.textTheme.bodyLarge),
          ),
        for (final (_, w) in rows) w,
        if (untimed.isNotEmpty) ...[
          _SectionTitle(l.untimedSection),
          for (final i in untimed)
            _InstanceTile(
              view: view,
              instance: i,
              actions: actions,
              cyclic: cyclic.contains(i.activityId),
              missingAnchor: missing.contains(i.ruleId),
            ),
        ],
        if (overflowed.isNotEmpty) ...[
          _SectionTitle(l.overflowSection),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Gap.l),
            child: Text(l.overflowBody, style: theme.textTheme.bodyMedium),
          ),
          for (final i in overflowed)
            _InstanceTile(
              view: view,
              instance: i,
              actions: actions,
              dropped: overflow[i.id]!,
            ),
        ],
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.s),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.l, vertical: Gap.s),
      child: Card(
        color: scheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(Gap.l),
          child: Row(
            children: [
              ExcludeSemantics(
                child: Icon(icon, color: scheme.onSecondaryContainer),
              ),
              const SizedBox(width: Gap.m),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: scheme.onSecondaryContainer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard({
    required this.label,
    required this.title,
    required this.detail,
    required this.strong,
  });

  final String label;
  final String title;
  final String detail;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = strong ? scheme.onPrimaryContainer : scheme.onSurface;
    return MergeSemantics(
      child: Card(
        color: strong ? scheme.primaryContainer : scheme.surfaceContainerHigh,
        child: Padding(
          padding: const EdgeInsets.all(Gap.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(color: fg),
              ),
              const SizedBox(height: Gap.xs),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(color: fg),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Gap.xs),
              Text(
                detail,
                style: theme.textTheme.bodyMedium?.copyWith(color: fg),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FreeTile extends StatelessWidget {
  const _FreeTile({required this.view, required this.slot});

  final PlanView view;
  final TimeSlot slot;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final cal = view.calendar;
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Gap.l,
          vertical: Gap.xs,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: scheme.outlineVariant),
            borderRadius: BorderRadius.circular(AppTokens.of(context).radius),
          ),
          child: ListTile(
            leading: ExcludeSemantics(
              child: Icon(
                Symbols.hourglass_empty_rounded,
                color: scheme.primary,
              ),
            ),
            title: Text(l.freeSlot(durationText(l, slot.minutes))),
            subtitle: Text(
              l.timeRange(
                clockText(context, cal, slot.start),
                clockText(context, cal, slot.end),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProposalTile extends ConsumerWidget {
  const _ProposalTile({required this.view, required this.proposal});

  final PlanView view;
  final ChunkProposal proposal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final cal = view.calendar;
    final p = proposal;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.l, vertical: Gap.xs),
      child: Card(
        child: ListTile(
          leading: const ExcludeSemantics(child: Icon(Symbols.flag_rounded)),
          title: Text(view.data.activities[p.activityId]?.title ?? ''),
          subtitle: Text(
            '${l.proposalLabel} · '
            '${l.timeRange(clockText(context, cal, p.start), clockText(context, cal, p.end))}',
          ),
          onTap: () => context.push('/project/${p.activityId}'),
          trailing: TextButton(
            onPressed: () async {
              final ok = await guard(
                context,
                () => ref
                    .read(planRepositoryProvider)
                    .addChunk(
                      activityId: p.activityId,
                      date: p.date,
                      start: utcOf(p.start),
                      end: utcOf(p.end),
                    ),
              );
              if (ok && context.mounted) showSnack(context, l.proposalAccepted);
            },
            child: Text(l.proposalAccept),
          ),
        ),
      ),
    );
  }
}

class _VariantChooser extends ConsumerWidget {
  const _VariantChooser({required this.view, required this.choice});

  final PlanView view;
  final VariantChoice choice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final variants = [
      for (final v in view.data.variants)
        if (v.groupId == choice.groupId) v,
    ]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final title = view.data.activities[choice.activityId]?.title ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.l, vertical: Gap.s),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Gap.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const ExcludeSemantics(
                    child: Icon(Symbols.alt_route_rounded),
                  ),
                  const SizedBox(width: Gap.s),
                  Expanded(
                    child: Text(
                      l.variantPrompt(title),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Gap.m),
              Wrap(
                spacing: Gap.s,
                runSpacing: Gap.s,
                children: [
                  for (final v in variants)
                    ChoiceChip(
                      label: Text(v.name),
                      selected: v.id == choice.selectedVariantId,
                      onSelected: (_) => guard(
                        context,
                        () => ref
                            .read(planRepositoryProvider)
                            .selectVariant(choice, v.id),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bir iş satırı; dokununca satır içinde eylemler açılır (UX_RULES §3: önce satır içi).
class _InstanceTile extends StatefulWidget {
  const _InstanceTile({
    required this.view,
    required this.instance,
    required this.actions,
    this.highlight = false,
    this.conflictWith,
    this.cyclic = false,
    this.missingAnchor = false,
    this.dropped,
  });

  final PlanView view;
  final PlannedInstance instance;
  final InstanceActions actions;
  final bool highlight;
  final String? conflictWith;
  final bool cyclic;
  final bool missingAnchor;

  /// Tampondaki iş: true = isteğe bağlıydı ve düştü.
  final bool? dropped;

  @override
  State<_InstanceTile> createState() => _InstanceTileState();
}

class _InstanceTileState extends State<_InstanceTile> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final view = widget.view;
    final i = widget.instance;
    final cal = view.calendar;
    final activity = view.data.activities[i.activityId];
    final done = i.status == InstanceStatus.done;
    final skipped = i.status == InstanceStatus.skipped;
    final labels = <(IconData, String, bool)>[
      if (view.data.requiresFocus(i.activityId))
        (Symbols.timer_rounded, l.focusLabel, false),
      if (i.suggested) (Symbols.lightbulb_rounded, l.suggestedLabel, false),
      if (i.anchorActivityId != null)
        (
          Symbols.link_rounded,
          l.afterAnchor(view.data.activities[i.anchorActivityId]?.title ?? ''),
          false,
        ),
      if (widget.conflictWith case final other?)
        (
          Symbols.warning_rounded,
          l.conflictLabel(
            view.data.activities[view.byId[other]?.activityId]?.title ?? '',
          ),
          true,
        ),
      if (widget.cyclic) (Symbols.warning_rounded, l.cycleLabel, true),
      if (widget.missingAnchor)
        (Symbols.warning_rounded, l.missingAnchorLabel, true),
      if (widget.dropped == true) (Symbols.info_rounded, l.droppedLabel, false),
      if (done) (Symbols.check_circle_rounded, l.statusDone, false),
      if (skipped) (Symbols.skip_next_rounded, l.statusSkipped, false),
    ];
    final range = i.isTimed
        ? '${l.timeRange(clockText(context, cal, i.start!), clockText(context, cal, i.end!))}'
              ' · ${durationText(l, i.end! - i.start!)}'
        : null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Gap.l, vertical: Gap.xs),
      // Sakin zaman çizelgesi: satırlar kart değil; yalnız şu anki / sıradaki iş tonla öne çıkar.
      child: Material(
        // Renkli temalarda satır işin kök rengiyle boyanır (D55).
        color: widget.highlight
            ? scheme.surfaceContainerHigh
            : AppTokens.tintOf(
                    context,
                    rootColor(context, activity?.rootCategoryKey, null),
                  ) ??
                  Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.of(context).radius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            MergeSemantics(
              child: Semantics(
                expanded: done || skipped ? null : _open,
                child: ListTile(
                  onTap: done || skipped
                      ? null
                      : () => setState(() => _open = !_open),
                  leading: Text(
                    i.isTimed ? clockText(context, cal, i.start!) : '—',
                    softWrap: false,
                    style: theme.textTheme.titleSmall,
                  ),
                  title: Text(
                    activity?.title ?? '',
                    style: done || skipped
                        ? TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: scheme.onSurfaceVariant,
                          )
                        : null,
                  ),
                  subtitle: range == null && labels.isEmpty
                      ? null
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (range != null) Text(range),
                            if (labels.isNotEmpty)
                              Wrap(
                                spacing: Gap.m,
                                runSpacing: Gap.xs,
                                children: [
                                  for (final (icon, text, warn) in labels)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ExcludeSemantics(
                                          child: Icon(
                                            icon,
                                            size: 16,
                                            color: warn
                                                ? scheme.error
                                                : scheme.onSurfaceVariant,
                                          ),
                                        ),
                                        const SizedBox(width: Gap.xs),
                                        Flexible(
                                          child: Text(
                                            text,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: warn
                                                      ? scheme.error
                                                      : null,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                          ],
                        ),
                  trailing: done || skipped
                      ? null
                      : ExcludeSemantics(
                          child: Icon(
                            _open
                                ? Symbols.expand_less_rounded
                                : Symbols.expand_more_rounded,
                          ),
                        ),
                ),
              ),
            ),
            AnimatedSize(
              duration: AppTokens.duration(context, Durations.medium2),
              curve: AppTokens.of(context).standardCurve,
              child: !_open || done || skipped
                  ? const SizedBox(width: double.infinity)
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(
                        Gap.s,
                        0,
                        Gap.s,
                        Gap.s,
                      ),
                      child: Wrap(
                        spacing: Gap.s,
                        children: [
                          // Odak gerektiren bugünkü iş (D25 kapanışı).
                          if (view.data.requiresFocus(i.activityId) &&
                              i.date == view.today)
                            TextButton.icon(
                              icon: const Icon(Symbols.timer_rounded),
                              label: Text(l.actionFocus),
                              onPressed: () =>
                                  context.push('/focus/new/${i.id}'),
                            ),
                          TextButton.icon(
                            icon: const Icon(Symbols.check_circle_rounded),
                            label: Text(l.actionDone),
                            onPressed: () => widget.actions.complete(i),
                          ),
                          TextButton.icon(
                            icon: const Icon(Symbols.skip_next_rounded),
                            label: Text(l.actionSkip),
                            onPressed: () => widget.actions.skip(i),
                          ),
                          TextButton.icon(
                            icon: const Icon(Symbols.schedule_rounded),
                            label: Text(l.actionChangeTime),
                            onPressed: () => widget.actions.changeTime(i),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
