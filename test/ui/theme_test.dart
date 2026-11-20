import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/theme.dart';
import 'package:neuroplan/data/local/app_database.dart';

import '../data/test_support.dart';
import 'harness.dart';

ChartColors _colors(AppTheme t, Brightness b) =>
    buildTheme(b, theme: t).extension<ChartColors>()!;

void main() {
  group('tema paletleri (D55)', () {
    test('kök sırası sistem verisiyle aynı', () {
      final keys = [
        for (final r
            in (systemData.rootCategories.toList()
              ..sort((a, b) => a.sortOrder - b.sortOrder)))
          r.key,
      ];
      expect(ChartColors.rootKeys, keys);
    });

    test(
      'her temanın grafik paleti kendine özgü (Sakin ve Minimal seri paylaşır)',
      () {
        for (final b in Brightness.values) {
          final seen = <String, AppTheme>{};
          for (final t in AppTheme.values) {
            final key = _colors(t, b).series.map((c) => c.toARGB32()).join(',');
            final other = seen[key];
            expect(
              other == null ||
                  {other, t}.containsAll([AppTheme.calm, AppTheme.minimal]),
              isTrue,
              reason: '${t.name} ve ${other?.name} aynı paleti kullanıyor',
            );
            seen[key] = t;
          }
        }
      },
    );

    test('rampa da temaya göre değişir; Sakin ve Minimal ayrışır', () {
      final a = _colors(AppTheme.calm, Brightness.light).ramp;
      final b = _colors(AppTheme.minimal, Brightness.light).ramp;
      expect(a, isNot(b));
    });

    test(
      '9 kök rengi: Ciddi sistem renklerini kullanır, diğerlerinde dokuzu ayrı',
      () {
        final scheme = buildTheme(Brightness.light).colorScheme;
        for (final r in systemData.rootCategories) {
          expect(
            hexOf(
              _colors(
                AppTheme.serious,
                Brightness.light,
              ).root(r.key, r.color, scheme),
            ),
            r.color.toUpperCase(),
          );
        }
        for (final t in AppTheme.values.where((t) => t != AppTheme.serious)) {
          for (final b in Brightness.values) {
            final c = _colors(t, b);
            final colors = {
              for (final k in ChartColors.rootKeys)
                c.root(k, null, scheme).toARGB32(),
            };
            expect(colors, hasLength(9), reason: '${t.name} ${b.name}');
          }
        }
      },
    );

    test('görünüm dili: temalar kart biçimiyle de ayrışır', () {
      final shapes = {
        for (final t in AppTheme.values)
          t: buildTheme(Brightness.light, theme: t).cardTheme,
      };
      final kinds = {
        for (final e in shapes.entries)
          '${e.value.color?.toARGB32()}|${(e.value.shape as RoundedRectangleBorder).side.width}|'
              '${(e.value.shape as RoundedRectangleBorder).borderRadius}',
      };
      expect(kinds.length, AppTheme.values.length);
      expect(AppTheme.values.map((t) => t.look).toSet(), hasLength(7));
    });
  });

  group('metin tonu (D55)', () {
    test('beş ton; Ciddi, Yüksek Kontrast ve Minimal nötr tonu paylaşır', () {
      expect(AppTheme.values.map((t) => t.tone).toSet(), {
        'serious',
        'playful',
        'young',
        'coder',
        'calm',
      });
      expect(AppTheme.highContrast.tone, AppTheme.serious.tone);
      expect(AppTheme.minimal.tone, AppTheme.serious.tone);
    });

    for (final (theme, text) in const [
      (AppTheme.serious, 'Planın henüz boş'),
      (AppTheme.highContrast, 'Planın henüz boş'),
      (AppTheme.playful, 'Bugün bembeyaz bir sayfa'),
      (AppTheme.young, 'Günün şu an bomboş'),
      (AppTheme.coder, 'Bugün: 0 kayıt'),
      (AppTheme.calm, 'Bugün henüz sakin'),
    ]) {
      testWidgets('${theme.name}: Bugün boş durumu kendi tonunda', (t) async {
        await pumpApp(
          t,
          seed: (c) => c
              .read(profileRepositoryProvider)
              .update(ProfilesCompanion(theme: Value(theme.name))),
        );
        expect(find.text(text), findsOneWidget);
      });
    }

    testWidgets('İngilizcede de ton değişir', (t) async {
      await pumpApp(
        t,
        locale: 'en',
        seed: (c) => c
            .read(profileRepositoryProvider)
            .update(const ProfilesCompanion(theme: Value('coder'))),
      );
      expect(find.text('Today: 0 rows'), findsOneWidget);
    });
  });
}
