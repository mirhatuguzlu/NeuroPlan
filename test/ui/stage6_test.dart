import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/feature_flags.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/app/theme.dart';

import 'harness.dart';

/// Aşama 6: özellik bayrakları (D58) ve tema seçici (D56).
void main() {
  group('özellik bayrakları', () {
    test('satır yoksa ya da önbellek bozuksa kod varsayılanı (açık)', () {
      expect(FeatureFlags.decode(null).on(Feature.voice), isTrue);
      expect(FeatureFlags.decode('bozuk').on(Feature.voice), isTrue);
      expect(FeatureFlags.decode('[1]').on(Feature.voice), isTrue);
      final f = FeatureFlags.decode('{"voice": false, "together": "x"}');
      expect(f.on(Feature.voice), isFalse);
      expect(
        f.on(Feature.together),
        isTrue,
        reason: 'bool olmayan değer yok sayılır',
      );
    });

    testWidgets('Birlikte kapalıysa açıklayan boş durum görünür', (t) async {
      final h = await pumpApp(
        t,
        seed: (c) => c
            .read(prefsRepositoryProvider)
            .set(featureFlagsKey, '{"together": false}'),
      );
      h.read(routerProvider).go('/together');
      await h.settle();
      expect(find.text('Bu bölüm şu an kapalı'), findsOneWidget);
      await h.expectAccessible();
    });
  });

  group('tema seçici', () {
    testWidgets(
      'her tema önizlemesiyle listelenir; dokununca anında uygulanır',
      (t) async {
        final h = await pumpApp(t);
        h.read(routerProvider).go('/profile/settings/theme');
        await h.settle();
        expect(find.text('Gece'), findsOneWidget);
        await h.tap(find.text('Gece'));
        expect(h.read(profileProvider).value?.theme, 'night');
        expect(
          AppTokens.of(t.element(find.text('Gece'))).theme,
          AppTheme.night,
        );
        // Kodcu ve Gece "sistem" görünümünde koyu açılır.
        expect(
          Theme.of(t.element(find.text('Gece'))).brightness,
          Brightness.dark,
        );
        await h.expectAccessible();

        await h.tap(find.text('Ciddi'));
        expect(h.read(profileProvider).value?.theme, isNull);
      },
    );

    testWidgets('yazı ölçeği 2.0: kartlar taşmaz', (t) async {
      final h = await pumpApp(t);
      t.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
      h.read(routerProvider).go('/profile/settings/theme');
      await h.settle();
      expect(t.takeException(), isNull);
    });
  });
}
