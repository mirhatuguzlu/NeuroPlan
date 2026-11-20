@Tags(['golden'])
library;

import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart'
    show MaterialApp, debugDisableShadows;
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/app/theme.dart';
import 'package:neuroplan/data/local/app_database.dart';

import '../ui/harness.dart';
import '../ui/sample_data.dart';

/// Ana ekranların görsel referansı: her tema × açık/koyu × TR/EN (D60). Gerçek fontlar
/// yüklenir. Referanslar Windows'ta üretilir; font işleme işletim sistemine göre değiştiği
/// için CI bu etiketi atlar (`--exclude-tags golden`).
/// Güncelleme: `flutter test --tags golden --update-goldens`.
const _screens = {
  'today': '/today',
  'plan': '/plan',
  'brain': '/brain',
  'profile': '/profile',
};

/// pubspec'teki bütün fontlar (uygulama fontları + Material Symbols), Ahem yerine.
Future<void> _loadFonts() async {
  final manifest =
      jsonDecode(await rootBundle.loadString('FontManifest.json')) as List;
  for (final f in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(f['family'] as String);
    for (final a in (f['fonts'] as List).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(a['asset'] as String));
    }
    await loader.load();
  }
}

void main() {
  setUpAll(_loadFonts);

  for (final theme in AppTheme.values) {
    for (final mode in const ['light', 'dark']) {
      for (final locale in const ['tr', 'en']) {
        testWidgets('${theme.name} · $mode · $locale', (t) async {
          // 1× piksel: referanslar küçük kalsın (412×915).
          t.view.devicePixelRatio = 1;
          addTearDown(t.view.resetDevicePixelRatio);
          final h = await pumpApp(
            t,
            locale: locale,
            seed: (c) async {
              await seedSample(c);
              await c
                  .read(profileRepositoryProvider)
                  .update(
                    ProfilesCompanion(
                      theme: Value(theme.name),
                      themeMode: Value(mode),
                      locale: Value(locale),
                    ),
                  );
            },
          );
          // Test çerçevesi gölgeleri düz siyah çizer; referansta gerçek gölge görünsün.
          // Değişken test bitmeden geri alınmalı (çerçeve denetler).
          debugDisableShadows = false;
          try {
            for (final MapEntry(key: name, value: path) in _screens.entries) {
              h.read(routerProvider).go(path);
              await h.settle();
              await expectLater(
                find.byType(MaterialApp).first,
                matchesGoldenFile(
                  'goldens/${theme.name}_${mode}_${locale}_$name.png',
                ),
              );
            }
          } finally {
            debugDisableShadows = true;
          }
        });
      }
    }
  }
}
