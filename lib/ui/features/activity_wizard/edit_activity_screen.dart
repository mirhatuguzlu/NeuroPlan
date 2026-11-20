import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/plan/plan_source.dart';
import '../../../data/repositories/sleep_window.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'activity_wizard_screen.dart';
import 'draft.dart';

/// Kayıtlı işin özeti; satıra dokununca yalnız o soru açılır, Kaydet onu yazar (D64).
class EditActivityScreen extends ConsumerWidget {
  const EditActivityScreen({super.key, required this.activityId});

  final String activityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    void close() => context.canPop() ? context.pop() : context.go('/plan');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l.commonClose,
          icon: const Icon(Symbols.close_rounded),
          onPressed: close,
        ),
        title: Text(l.editTitle),
      ),
      body: AsyncView<PlanData?>(
        value: ref.watch(planDataProvider),
        onRetry: () => ref.invalidate(planDataProvider),
        data: (data) {
          if (data == null) return const SkeletonList();
          final now = ref.watch(nowProvider).value ?? DateTime.now();
          final today = data.calendar
              .dayOf(now.millisecondsSinceEpoch ~/ 60000)
              .iso;
          final d = ActivityDraft.edit(data, activityId, today);
          if (d == null) {
            return MessageState(
              icon: Symbols.info_rounded,
              title: l.focusMissingTitle,
              body: l.editMissing,
              actionLabel: l.commonBack,
              onAction: close,
            );
          }
          // Uyku penceresinin saatleri Ayarlar'da düzenlenir (D30); sihirbaz onu bozmasın.
          final sleep = SleepWindow.find(data)?.activityId == activityId;
          return ListView(
            padding: const EdgeInsets.fromLTRB(Gap.xl, Gap.l, Gap.xl, Gap.xxl),
            children: [
              ActivitySummary(
                draft: d,
                data: data,
                onEdit: (step) => sleep && step == 'time'
                    ? context.push('/profile/settings')
                    : context.push('/edit/$activityId/$step'),
              ),
              if (!d.isProject) ...[
                const SizedBox(height: Gap.s),
                Text(
                  l.editHistoryNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: Gap.xl),
              BusyButton(
                tonal: true,
                label: l.commonDelete,
                onPressed: () async {
                  final repo = ref.read(activityRepositoryProvider);
                  final title = d.title.trim();
                  final ok = await guard(
                    context,
                    () => repo.delete(activityId),
                  );
                  if (!ok || !context.mounted) return;
                  showSnack(
                    context,
                    l.itemDeleted(title),
                    actionLabel: l.commonUndo,
                    onAction: () => repo.update(
                      activityId,
                      const ActivitiesCompanion(deletedAt: Value(null)),
                    ),
                  );
                  close();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
