import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../core/app_shell.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import '../../core/theme_choice.dart';
import '../../core/wizard.dart';

/// Görünüm ve tema (tek amaç: uygulamanın nasıl görüneceğini seçmek, D56). Seçim
/// anında uygulanır; tema yeniden başlatmadan, temanın hızıyla geçer.
class ThemeScreen extends ConsumerWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final profile = ref.watch(profileProvider);
    Future<void> update(ProfilesCompanion c) =>
        guard(context, () => ref.read(profileRepositoryProvider).update(c));
    Widget header(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(Gap.l, Gap.xl, Gap.l, Gap.s),
      child: Semantics(
        header: true,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.themeScreenTitle)),
      body: AsyncView<Profile?>(
        value: profile,
        onRetry: () => ref.invalidate(profileProvider),
        data: (p) => p == null
            ? const SkeletonList()
            : ListView(
                padding: EdgeInsets.only(bottom: AppShell.bottomInset(context)),
                children: [
                  header(l.settingAppearance),
                  ChoiceList<String>(
                    value: p.themeMode,
                    options: [
                      ('system', l.modeSystem, null),
                      ('light', l.modeLight, null),
                      ('dark', l.modeDark, null),
                    ],
                    onChanged: (v) =>
                        update(ProfilesCompanion(themeMode: Value(v))),
                  ),
                  header(l.settingTheme),
                  ThemeChoice(
                    value: p.theme,
                    mode: p.themeMode,
                    onChanged: (v) =>
                        update(ProfilesCompanion(theme: Value(v))),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Ayarlar satırındaki özet: "Ciddi · Sistem".
String themeSummary(BuildContext context, Profile p) {
  final l = context.l10n;
  return l.themeRowValue(
    themeName(l, AppTheme.of(p.theme)),
    switch (p.themeMode) {
      'light' => l.modeLight,
      'dark' => l.modeDark,
      _ => l.modeSystem,
    },
  );
}
