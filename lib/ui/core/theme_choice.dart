import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../l10n/app_localizations.dart';
import 'format.dart';
import 'wizard.dart';

String themeName(L10n l, AppTheme t) => switch (t) {
  AppTheme.serious => l.themeSerious,
  AppTheme.playful => l.themePlayful,
  AppTheme.young => l.themeYoung,
  AppTheme.coder => l.themeCoder,
  AppTheme.calm => l.themeCalm,
  AppTheme.highContrast => l.themeHighContrast,
  AppTheme.minimal => l.themeMinimal,
};

String themeSpirit(L10n l, AppTheme t) => switch (t) {
  AppTheme.serious => l.themeSeriousBody,
  AppTheme.playful => l.themePlayfulBody,
  AppTheme.young => l.themeYoungBody,
  AppTheme.coder => l.themeCoderBody,
  AppTheme.calm => l.themeCalmBody,
  AppTheme.highContrast => l.themeHighContrastBody,
  AppTheme.minimal => l.themeMinimalBody,
};

/// Tema seçimi: ad + ruhu. `null` = Ciddi (varsayılan, DB_SCHEMA §3.1).
class ThemeChoice extends StatelessWidget {
  const ThemeChoice({super.key, required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return ChoiceList<String>(
      value: AppTheme.of(value).name,
      options: [
        for (final t in AppTheme.values)
          (t.name, themeName(l, t), themeSpirit(l, t)),
      ],
      onChanged: (v) => onChanged(v == AppTheme.serious.name ? null : v),
    );
  }
}
