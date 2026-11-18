import 'package:material_ui/material_ui.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../app/theme.dart';
import 'format.dart';
import 'wizard.dart';

/// Namaz vakti modülü: aç/kapa, hesap yöntemi, ikindi hesabı (kurulum ve Profil).
class PrayerFields extends StatelessWidget {
  const PrayerFields({
    super.key,
    required this.method,
    required this.madhab,
    required this.hasLocation,
    required this.onChanged,
  });

  /// null = kapalı.
  final String? method;
  final String madhab;
  final bool hasLocation;
  final void Function(String? method, String madhab) onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          title: Text(l.prayerEnable),
          value: method != null,
          onChanged: (on) => onChanged(on ? defaultPrayerMethod : null, madhab),
        ),
        if (method != null) ...[
          if (!hasLocation)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Gap.l,
                vertical: Gap.s,
              ),
              child: Text(
                l.prayerNeedsLocation,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: Gap.m),
          DropdownMenu<String>(
            expandedInsets: EdgeInsets.zero,
            label: Text(l.prayerMethod),
            initialSelection: method,
            onSelected: (m) => m == null ? null : onChanged(m, madhab),
            dropdownMenuEntries: [
              for (final key in prayerMethods.keys)
                DropdownMenuEntry(value: key, label: l.prayerMethodName(key)),
            ],
          ),
          const SizedBox(height: Gap.l),
          Text(l.prayerMadhab, style: Theme.of(context).textTheme.titleSmall),
          ChoiceList<String>(
            value: madhab,
            options: [
              ('shafi', l.madhabShafi, null),
              ('hanafi', l.madhabHanafi, null),
            ],
            onChanged: (m) => onChanged(method, m),
          ),
        ],
      ],
    );
  }
}
