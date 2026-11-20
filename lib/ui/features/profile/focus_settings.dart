import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/focus_platform.dart';
import '../../../app/next_up.dart';
import '../../../app/providers.dart';
import '../../../data/repositories/prefs_repository.dart';
import '../../core/format.dart';
import '../../core/states.dart';

final _dndPrefProvider = StreamProvider<bool>(
  (ref) => ref
      .watch(prefsRepositoryProvider)
      .watch(PrefsRepository.focusDnd)
      .map((v) => v == '1'),
);

final _phonePermissionProvider = FutureProvider.autoDispose<bool>(
  (ref) => ref.watch(focusPlatformProvider).hasPhonePermission(),
);

/// Odak tercihleri (cihaza özel): otomatik başlatma, Rahatsız Etmeyin, aramalar.
/// İzin, anahtar açıldığı anda istenir.
class FocusSettingsTiles extends ConsumerWidget {
  const FocusSettingsTiles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final platform = ref.read(focusPlatformProvider);
    final prefs = ref.read(prefsRepositoryProvider);
    final dnd = ref.watch(_dndPrefProvider).value ?? false;
    final phone = ref.watch(_phonePermissionProvider).value;
    final auto = ref.watch(autoRunProvider).value ?? true;
    return Column(
      children: [
        SwitchListTile(
          secondary: const Icon(Symbols.play_circle_rounded),
          title: Text(l.settingAutoRun),
          subtitle: Text(l.settingAutoRunBody),
          value: auto,
          onChanged: (on) => guard(
            context,
            () => prefs.set(PrefsRepository.autoRun, on ? null : '0'),
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Symbols.do_not_disturb_on_rounded),
          title: Text(l.settingFocusDnd),
          subtitle: Text(l.settingFocusDndBody),
          value: dnd,
          onChanged: (on) => guard(context, () async {
            if (on &&
                !await platform.hasDndAccess() &&
                !await platform.requestDndAccess()) {
              if (context.mounted) showSnack(context, l.focusDndDenied);
              return;
            }
            await prefs.set(PrefsRepository.focusDnd, on ? '1' : null);
          }),
        ),
        SwitchListTile(
          secondary: const Icon(Symbols.call_rounded),
          title: Text(l.settingFocusCalls),
          // İzin uygulamadan geri alınamaz; kapatmak için sistem ayarı.
          subtitle: Text(
            phone == true ? l.settingFocusCallsOn : l.settingFocusCallsBody,
          ),
          value: phone == true,
          onChanged: phone == null || phone
              ? null
              : (_) => guard(context, () async {
                  if (!await platform.requestPhonePermission() &&
                      context.mounted) {
                    showSnack(context, l.focusPhoneDenied);
                  }
                  ref.invalidate(_phonePermissionProvider);
                }),
        ),
      ],
    );
  }
}
