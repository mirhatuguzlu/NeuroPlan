import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../core/drag.dart';
import '../../core/format.dart';
import '../../core/states.dart';

/// Proje: ilerleme, kalan süre, otomatik / elle bölme (SLOT-3, SLOT-5).
class ProjectScreen extends ConsumerWidget {
  const ProjectScreen({super.key, required this.activityId});

  final String activityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final plan = ref.watch(horizonProvider);
    final title = plan.value?.data.activities[activityId]?.title;
    return Scaffold(
      appBar: AppBar(title: Text(title ?? '')),
      body: AsyncView<PlanView?>(
        value: plan,
        onRetry: () => ref.invalidate(planDataProvider),
        data: (view) {
          if (view == null) return const SkeletonList();
          final project = view.data.projectOf(activityId);
          if (project == null || view.data.activities[activityId] == null) {
            return MessageState(
              icon: Symbols.flag_rounded,
              title: l.projectNotFound,
              body: '',
            );
          }
          return _ProjectBody(view: view, project: project);
        },
      ),
    );
  }
}

class _ProjectBody extends ConsumerWidget {
  const _ProjectBody({required this.view, required this.project});

  final PlanView view;
  final Project project;

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    ProjectsCompanion c,
  ) => guard(
    context,
    () =>
        ref.read(activityRepositoryProvider).saveProject(project.activityId, c),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final cal = view.calendar;
    final id = project.activityId;
    final chunks = [
      for (final i in view.data.instances)
        if (i.activityId == id &&
            i.ruleId == null &&
            i.startAt != null &&
            i.endAt != null)
          i,
    ]..sort((a, b) => a.startAt!.compareTo(b.startAt!));
    int len(PlanInstance i) => i.endAt!.difference(i.startAt!).inMinutes;
    final done = chunks
        .where((i) => i.status == 'done')
        .fold(0, (s, i) => s + len(i));
    final upcoming = [
      for (final i in chunks)
        if (i.status == 'planned' && i.endAt!.isAfter(view.now)) i,
    ];
    final booked = upcoming.fold(0, (s, i) => s + len(i));
    final total = project.totalMinutes;
    final remaining = total == null
        ? null
        : (total - done - booked).clamp(0, total);
    final proposals = [
      for (final p in view.output.proposals)
        if (p.activityId == id) p,
    ];
    final risk = view.output.risks.where((r) => r.activityId == id).firstOrNull;
    final auto = project.splitMode == 'auto';
    final deadlineDay = project.deadlineAt == null
        ? null
        : cal.dayOf(project.deadlineAt!.millisecondsSinceEpoch ~/ 60000).iso;

    return ListView(
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, Gap.xxl),
      children: [
        Text(l.projectProgress, style: theme.textTheme.titleMedium),
        const SizedBox(height: Gap.s),
        if (total == null)
          Text(l.projectNoTotal)
        else ...[
          LinearProgressIndicator(
            value: total == 0 ? 0 : (done / total).clamp(0, 1),
            semanticsLabel: l.projectProgress,
          ),
          const SizedBox(height: Gap.s),
          Text(l.projectDoneOf(durationText(l, done), durationText(l, total))),
          Text(l.projectRemaining(durationText(l, remaining!))),
        ],
        const SizedBox(height: Gap.s),
        Text(
          deadlineDay == null
              ? l.projectNoDeadline
              : l.projectDeadline(dateText(context, deadlineDay)),
        ),
        const SizedBox(height: Gap.l),
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: true,
              label: Text(l.projectModeAuto),
              enabled: deadlineDay != null && total != null,
            ),
            ButtonSegment(value: false, label: Text(l.projectModeManual)),
          ],
          selected: {auto && deadlineDay != null && total != null},
          onSelectionChanged: (s) => _save(
            context,
            ref,
            ProjectsCompanion(splitMode: Value(s.first ? 'auto' : 'manual')),
          ),
        ),
        if (risk != null && auto) ...[
          const SizedBox(height: Gap.l),
          _RiskCard(
            view: view,
            project: project,
            risk: risk,
            onSave: (c) => _save(context, ref, c),
          ),
        ],
        if (upcoming.isNotEmpty) ...[
          const SizedBox(height: Gap.xl),
          Text(l.projectScheduled, style: theme.textTheme.titleMedium),
          for (final c in upcoming)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(dateText(context, c.occurrenceDate)),
              subtitle: Text(
                l.timeRange(
                  clockText(
                    context,
                    cal,
                    c.startAt!.millisecondsSinceEpoch ~/ 60000,
                  ),
                  clockText(
                    context,
                    cal,
                    c.endAt!.millisecondsSinceEpoch ~/ 60000,
                  ),
                ),
              ),
              trailing: IconButton(
                tooltip: l.chunkRemove,
                icon: const Icon(Symbols.delete_rounded),
                onPressed: () => guard(
                  context,
                  () => ref.read(planRepositoryProvider).remove(c.id),
                ),
              ),
            ),
        ],
        const SizedBox(height: Gap.xl),
        if (auto && deadlineDay != null && total != null)
          ..._proposals(context, ref, proposals, remaining ?? 0)
        else
          _ManualSlots(
            view: view,
            project: project,
            chunk: [
              project.maxChunkMinutes ?? 60,
              if (remaining != null && remaining > 0) remaining,
            ].reduce((a, b) => a < b ? a : b),
          ),
      ],
    );
  }

  List<Widget> _proposals(
    BuildContext context,
    WidgetRef ref,
    List<ChunkProposal> proposals,
    int remaining,
  ) {
    final l = context.l10n;
    final cal = view.calendar;
    Future<void> accept(List<ChunkProposal> list) async {
      final ok = await guard(context, () async {
        for (final p in list) {
          await ref
              .read(planRepositoryProvider)
              .addChunk(
                activityId: p.activityId,
                date: p.date,
                start: utcOf(p.start),
                end: utcOf(p.end),
              );
        }
      });
      if (ok && context.mounted) {
        showSnack(context, l.projectAccepted(list.length));
      }
    }

    return [
      Row(
        children: [
          Expanded(
            child: Text(
              l.projectProposals,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (proposals.length > 1)
            TextButton(
              onPressed: () => accept(proposals),
              child: Text(l.projectAcceptAll),
            ),
        ],
      ),
      if (proposals.isEmpty)
        Text(remaining == 0 ? l.projectComplete : l.projectNoProposals),
      for (final p in proposals)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(dateText(context, p.date)),
          subtitle: Text(
            '${l.timeRange(clockText(context, cal, p.start), clockText(context, cal, p.end))}'
            ' · ${durationText(l, p.minutes)}',
          ),
          trailing: TextButton(
            onPressed: () => accept([p]),
            child: Text(l.proposalAccept),
          ),
        ),
    ];
  }
}

class _RiskCard extends ConsumerWidget {
  const _RiskCard({
    required this.view,
    required this.project,
    required this.risk,
    required this.onSave,
  });

  final PlanView view;
  final Project project;
  final DeadlineRisk risk;
  final Future<void> Function(ProjectsCompanion) onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final cal = view.calendar;
    final profileCap = view.data.profile.dailyFocusCapMinutes;
    Future<void> apply(Future<void> Function() change) async {
      await change();
      if (context.mounted) showSnack(context, l.riskApplied);
    }

    return Card(
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(Gap.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Icon(
                    Symbols.warning_rounded,
                    color: scheme.onErrorContainer,
                  ),
                ),
                const SizedBox(width: Gap.m),
                Expanded(
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      l.riskTitle(
                        dateText(context, cal.dayOf(risk.deadline).iso),
                        durationText(l, risk.missingMinutes),
                      ),
                      style: TextStyle(color: scheme.onErrorContainer),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Gap.m),
            Wrap(
              spacing: Gap.s,
              runSpacing: Gap.s,
              children: [
                FilledButton.tonal(
                  onPressed: () => apply(
                    () => onSave(
                      ProjectsCompanion(
                        maxChunkMinutes: Value(
                          (project.maxChunkMinutes ?? defaultMaxChunk) + 30,
                        ),
                      ),
                    ),
                  ),
                  child: Text(l.riskExtendChunk),
                ),
                if (project.dailyCapMinutes != null || profileCap != null)
                  FilledButton.tonal(
                    onPressed: () => apply(
                      () => project.dailyCapMinutes != null
                          ? onSave(
                              ProjectsCompanion(
                                dailyCapMinutes: Value(
                                  project.dailyCapMinutes! + 60,
                                ),
                              ),
                            )
                          : ref
                                .read(profileRepositoryProvider)
                                .update(
                                  ProfilesCompanion(
                                    dailyFocusCapMinutes: Value(
                                      profileCap! + 60,
                                    ),
                                  ),
                                ),
                    ),
                    child: Text(l.riskRaiseCap),
                  ),
                FilledButton.tonal(
                  onPressed: () async {
                    final current = project.deadlineAt!.toLocal();
                    final d = await showDatePicker(
                      context: context,
                      initialDate: current.add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(
                        const Duration(days: 365 * 3),
                      ),
                    );
                    if (d == null) return;
                    final day = Day.parse(d.toIso8601String().substring(0, 10));
                    await apply(
                      () => onSave(
                        ProjectsCompanion(
                          deadlineAt: Value(
                            utcOf(cal.wallToUtc(day, 23 * 60 + 59)),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(l.riskMoveDeadline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Elle bölme: parça boş dilime sürüklenir ya da dilime dokunulur.
class _ManualSlots extends ConsumerWidget {
  const _ManualSlots({
    required this.view,
    required this.project,
    required this.chunk,
  });

  final PlanView view;
  final Project project;
  final int chunk;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final cal = view.calendar;
    final slots = [
      for (final e in view.output.freeSlots.entries)
        for (final s in e.value)
          if (s.end > view.nowMinute && s.minutes >= chunk.clamp(1, 1440))
            (
              e.key,
              TimeSlot(
                s.start < view.nowMinute ? view.nowMinute : s.start,
                s.end,
              ),
            ),
    ]..sort((a, b) => a.$2.start.compareTo(b.$2.start));

    Future<void> place(String date, TimeSlot s) async {
      final end = s.start + chunk > s.end ? s.end : s.start + chunk;
      final ok = await guard(
        context,
        () => ref
            .read(planRepositoryProvider)
            .addChunk(
              activityId: project.activityId,
              date: date,
              start: utcOf(s.start),
              end: utcOf(end),
              manual: true,
            ),
      );
      if (ok && context.mounted) showSnack(context, l.manualPlaced);
    }

    final label = l.manualChunk(durationText(l, chunk));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.manualTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: Gap.xs),
        Text(l.manualHint, style: theme.textTheme.bodyMedium),
        const SizedBox(height: Gap.m),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: DragItem<int>(
            data: chunk,
            label: label,
            builder: (context, handle) => Card.outlined(
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  handle,
                  Flexible(child: Text(label)),
                  const SizedBox(width: Gap.l),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: Gap.m),
        if (slots.isEmpty) Text(l.manualNoSlots),
        for (final (date, s) in slots.take(30))
          DragTarget<int>(
            onAcceptWithDetails: (_) => place(date, s),
            builder: (context, candidates, _) => Card(
              color: candidates.isEmpty
                  ? null
                  : theme.colorScheme.secondaryContainer,
              child: ListTile(
                leading: const ExcludeSemantics(
                  child: Icon(Symbols.hourglass_empty_rounded),
                ),
                title: Text(dateText(context, date)),
                subtitle: Text(
                  '${l.timeRange(clockText(context, cal, s.start), clockText(context, cal, s.end))}'
                  ' · ${durationText(l, s.minutes)}',
                ),
                trailing: const ExcludeSemantics(
                  child: Icon(Symbols.add_rounded),
                ),
                onTap: () => place(date, s),
              ),
            ),
          ),
      ],
    );
  }
}
