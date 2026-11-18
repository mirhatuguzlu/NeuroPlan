import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/next_up.dart';
import '../../../app/providers.dart';
import '../../../data/repositories/prefs_repository.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../../core/wizard.dart';

/// Sıradaki iş bildirimi: kaç dakika önce, isteğe bağlı tam zamanında (D27).
class NotificationSettings extends ConsumerWidget {
  const NotificationSettings({super.key});

  static const leads = [5, 10, 15, 30, 60];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final lead = ref.watch(notifyLeadProvider).value;
    final exact = ref.watch(exactAlarmsProvider).value ?? false;
    final prefs = ref.read(prefsRepositoryProvider);

    Future<void> setLead(int? v) async {
      if (v != null && !await ref.read(nextUpProvider).requestPermission()) {
        if (context.mounted) showSnack(context, l.notifPermissionDenied);
        return;
      }
      await prefs.set(PrefsRepository.notifyLead, v?.toString());
    }

    return Column(
      children: [
        ExpansionTile(
          leading: const Icon(Symbols.notifications_rounded),
          title: Text(l.settingNotify),
          subtitle: Text(lead == null ? l.notifyOff : l.notifyLead(lead)),
          children: [
            ChoiceList<int?>(
              value: lead,
              options: [
                (null, l.notifyOff, null),
                for (final m in leads) (m, l.notifyLead(m), null),
              ],
              onChanged: (v) => guard(context, () => setLead(v)),
            ),
          ],
        ),
        SwitchListTile(
          secondary: const Icon(Symbols.alarm_rounded),
          title: Text(l.settingExact),
          subtitle: Text(l.settingExactBody),
          value: exact,
          onChanged: lead == null
              ? null
              : (on) => guard(context, () async {
                  final granted =
                      on && await ref.read(nextUpProvider).requestExact();
                  await prefs.set(
                    PrefsRepository.exactAlarms,
                    granted ? '1' : null,
                  );
                }),
        ),
      ],
    );
  }
}
