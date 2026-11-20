import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'crash_reports.dart';
import 'feature_flags.dart';
import 'next_up.dart';
import 'providers.dart';
import 'router.dart';
import 'theme.dart';

class NeuroPlanApp extends ConsumerWidget {
  const NeuroPlanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider).value;
    listenNextUp(ref);
    ref.watch(featureFlagsSyncProvider);
    ref.watch(crashReportsProvider);
    final theme = AppTheme.of(profile?.theme);
    return MaterialApp.router(
      onGenerateTitle: (c) => L10n.of(c).appTitle,
      routerConfig: ref.watch(routerProvider),
      theme: buildTheme(Brightness.light, theme: theme),
      darkTheme: buildTheme(Brightness.dark, theme: theme),
      themeMode: switch (profile?.themeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ when theme.darkFirst => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      // Tema değişimi yeniden başlatmadan, temanın hızıyla yumuşakça geçer (D56).
      themeAnimationDuration:
          WidgetsBinding
              .instance
              .platformDispatcher
              .accessibilityFeatures
              .disableAnimations
          ? Duration.zero
          : AppTokens(theme: theme).themeSwitch,
      themeAnimationCurve: Easing.standard,
      locale: profile?.locale == null ? null : Locale(profile!.locale!),
      // Geniş ekranda içerik okunur genişlikte ortalanır (UX_RULES §7; tablet düzeni sonra).
      builder: (context, child) => ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: child,
          ),
        ),
      ),
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: const [
        L10n.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
    );
  }
}
