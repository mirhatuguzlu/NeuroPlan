import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/app/theme.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/ui/features/stats/stats_page.dart';

import 'harness.dart';
import 'sample_data.dart';

/// Her tema × görünüm × ekran (D55): kontrast, dokunma alanı, etiket ve taşma.
const _screens = [
  '/today',
  '/plan',
  '/brain',
  '/together',
  '/profile',
  '/profile/settings',
  '/profile/settings/theme',
  '/profile/sources',
  '/profile/about',
  '/brain/categories',
  '/brain/list',
  '/add',
];

Future<void> _visit(Harness h, String path, {bool a11y = true}) async {
  h.read(routerProvider).go(path);
  await h.settle();
  if (a11y) await h.expectAccessible();
}

void main() {
  for (final theme in AppTheme.values) {
    for (final mode in const ['light', 'dark']) {
      testWidgets('${theme.name} · $mode: bütün ekranlar erişilebilir', (
        t,
      ) async {
        final h = await pumpApp(
          t,
          seed: (c) async {
            await seedSample(c);
            await c
                .read(profileRepositoryProvider)
                .update(
                  ProfilesCompanion(
                    theme: Value(theme.name),
                    themeMode: Value(mode),
                  ),
                );
          },
        );
        final ctx = t.element(find.byType(Scaffold).first);
        expect(AppTokens.of(ctx).theme, theme);
        expect(
          Theme.of(ctx).brightness,
          mode == 'dark' ? Brightness.dark : Brightness.light,
        );
        for (final p in _screens) {
          await _visit(h, p);
        }
        for (final p in StatPage.values) {
          await _visit(h, '/profile/stats/${p.name}');
        }
      });
    }
  }

  // Taşma (RenderFlex overflow) test çerçevesinde hata sayılır: her boyutta ekranlar gezilir.
  for (final (name, size, scale) in const [
    ('küçük telefon', Size(320, 640), 1.0),
    ('küçük telefon, yazı 1.6', Size(360, 740), 1.6),
    ('yatay telefon', Size(915, 412), 1.0),
    ('tablet', Size(1024, 1366), 1.0),
    ('katlanabilir açık', Size(884, 1104), 1.3),
  ]) {
    // Eğlenceli: iri yazı ve dokunma alanı (D56).
    for (final theme in const [
      AppTheme.serious,
      AppTheme.young,
      AppTheme.playful,
    ]) {
      testWidgets('düzen: $name · ${theme.name}', (t) async {
        final h = await pumpApp(
          t,
          seed: (c) async {
            await seedSample(c);
            await c
                .read(profileRepositoryProvider)
                .update(ProfilesCompanion(theme: Value(theme.name)));
          },
        );
        await t.binding.setSurfaceSize(size);
        t.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
        await h.settle();
        for (final p in _screens) {
          await _visit(h, p, a11y: false);
        }
        for (final p in StatPage.values) {
          await _visit(h, '/profile/stats/${p.name}', a11y: false);
        }
      });
    }
  }
}
