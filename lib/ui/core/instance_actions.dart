import 'feedback.dart';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../app/auto_start.dart';
import '../../app/providers.dart';
import '../../data/local/app_database.dart';
import 'format.dart';
import 'states.dart';

/// Bir oluşuma dokunulduğunda yapılanlar (D22: satır yalnız bu anda yazılır).
class InstanceActions {
  InstanceActions(this.context, this.ref, this.view);

  final BuildContext context;
  final WidgetRef ref;
  final PlanView view;

  String title(PlannedInstance i) =>
      view.data.activities[i.activityId]?.title ?? '';

  Future<void> complete(PlannedInstance i) async {
    final ok = await guard(
      context,
      () => ref.read(planRepositoryProvider).complete(i, DateTime.now()),
    );
    if (ok && context.mounted) {
      Haptics.success(context);
      showSnack(
        context,
        context.l10n.snackDone(title(i)),
        actionLabel: context.l10n.commonUndo,
        onAction: () => _restore(i),
      );
    }
  }

  /// Saati hiç belli olmayan odak işi için "Şimdi başla" (D66); saatli işler bildirimle.
  Future<void> startFocus(PlannedInstance i) =>
      guard(context, () => ref.read(focusStarterProvider).start(view, i));

  Future<void> skip(PlannedInstance i) async {
    final ok = await guard(
      context,
      () => ref.read(planRepositoryProvider).skip(i),
    );
    if (ok && context.mounted) {
      showSnack(
        context,
        context.l10n.snackSkipped(title(i)),
        actionLabel: context.l10n.commonUndo,
        onAction: () => _restore(i),
      );
    }
  }

  /// Geri al: oluşumu dokunulmadan önceki haline döndürür.
  Future<void> _restore(PlannedInstance before) => ref
      .read(planRepositoryProvider)
      .touch(
        before,
        PlanInstancesCompanion(
          status: Value(before.status.name),
          isManual: Value(before.isManual),
          startAt: Value(before.isManual ? utcOf(before.start!) : null),
          endAt: Value(before.isManual ? utcOf(before.end!) : null),
        ),
      );

  /// Saat seçilir; kurala bağlıysa "yalnız bu sefer / her zaman" sorulur (UX_RULES §3:
  /// akışı durduran, iki seçenekli karar).
  Future<void> changeTime(PlannedInstance i) async {
    final cal = view.calendar;
    final current = i.start != null
        ? cal.minuteOfDay(i.start!)
        : cal.minuteOfDay(view.nowMinute);
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked == null || !context.mounted) return;
    final minute = picked.hour * 60 + picked.minute;
    final length = i.isTimed ? i.end! - i.start! : _ruleLength(i) ?? 30;
    final rule = view.data.rules.where((r) => r.id == i.ruleId).firstOrNull;
    final always = rule != null && rule.recurrence is! FollowRecurrence
        ? await _askScope()
        : false;
    if (always == null || !context.mounted) return;
    await guard(context, () async {
      if (always) {
        await ref
            .read(activityRepositoryProvider)
            .updateRule(
              rule.id,
              ScheduleRulesCompanion(
                timing: Value(
                  Timing(
                    start: [
                      TimeConstraint(
                        ConstraintOp.at,
                        ClockRef(minute ~/ 60, minute % 60),
                      ),
                    ],
                  ),
                ),
                durationMinMinutes: Value(length),
                durationMaxMinutes: Value(length),
              ),
            );
      } else {
        final start = cal.wallToUtc(Day.parse(i.date), minute);
        await ref
            .read(planRepositoryProvider)
            .moveOnce(i, utcOf(start), utcOf(start + length));
      }
    });
  }

  int? _ruleLength(PlannedInstance i) {
    final r = view.data.rules.where((r) => r.id == i.ruleId).firstOrNull;
    return r?.durationMaxMinutes ??
        r?.durationMinMinutes ??
        view.data.activities[i.activityId]?.estimatedMinutes;
  }

  Future<bool?> _askScope() {
    final l = context.l10n;
    return showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(l.changeScopeTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: Text(l.changeScopeOnce),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: Text(l.changeScopeAlways),
          ),
        ],
      ),
    );
  }
}
