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

    // Seri paylaşan temalar (D55, D56); rampa ve kök renkleri yine kendilerinin.
    const sharing = [
      {AppTheme.calm, AppTheme.minimal, AppTheme.paper},
      {AppTheme.serious, AppTheme.night},
    ];

    test('her temanın grafik paleti kendine özgü (yalnız belgelenen temalar seri paylaşır)', () {
      for (final b in Brightness.values) {
        final seen = <String, AppTheme>{};
        for (final t in AppTheme.values) {
          final key = _colors(t, b).series.map((c) => c.toARGB32()).join(',');
          final other = seen[key];
          expect(
            other == null || sharing.any((g) => g.containsAll({other, t})),
            isTrue,
            reason: '${t.name} ve ${other?.name} aynı paleti kullanıyor',
          );
          seen[key] = t;
        }
      }
    });

    test('rampa da temaya göre değişir; seri paylaşanlar rampada ayrışır', () {
      for (final g in sharing) {
        final ramps = {
          for (final t in g)
            _colors(t, Brightness.light).ramp.map((c) => c.toARGB32()).join(),
        };
        expect(ramps, hasLength(g.length));
      }
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
      expect(
        AppTheme.values.map((t) => t.look).toSet(),
        hasLength(AppTheme.values.length),
      );
    });
  });

  group('tema tokenları (D56)', () {
    test(
      'Kâğıt anlık, diğerleri ölçekli; azaltılmış hareket her zaman sıfır',
      () {
        expect(
          const AppTokens(theme: AppTheme.paper).scaled(Durations.medium2),
          Duration.zero,
        );
        expect(
          const AppTokens(theme: AppTheme.calm).scaled(Durations.medium2),
          greaterThan(
            const AppTokens(theme: AppTheme.serious).scaled(Durations.medium2),
          ),
        );
      },
    );

    test(
      'Kodcu ve Gece sistem görünümünde koyu açılır, açık seçim korunur',
      () {
        for (final t in AppTheme.values) {
          expect(
            t.brightnessFor('system', Brightness.light),
            t.darkFirst ? Brightness.dark : Brightness.light,
          );
          expect(t.brightnessFor('light', Brightness.dark), Brightness.light);
        }
        expect(AppTheme.values.where((t) => t.darkFirst).toSet(), {
          AppTheme.coder,
          AppTheme.night,
        });
      },
    );

    test(
      'Gece koyuda gerçek siyah; Eğlenceli dokunma alanı ve yazı daha iri',
      () {
        expect(
          buildTheme(
            Brightness.dark,
            theme: AppTheme.night,
          ).colorScheme.surface,
          const Color(0xFF000000),
        );
        final fun = buildTheme(Brightness.light, theme: AppTheme.playful);
        expect(
          fun.textTheme.bodyLarge!.fontSize!,
          greaterThan(16),
        ); // M3 gövde 16
        expect(
          fun.filledButtonTheme.style!.minimumSize!.resolve({})!.height,
          greaterThanOrEqualTo(56),
        );
      },
    );

    test('renkler tema geçişinde ara değer alır', () {
      final a = _colors(AppTheme.serious, Brightness.light);
      final b = _colors(AppTheme.playful, Brightness.light);
      final mid = a.lerp(b, 0.5);
      expect(mid.series.first, isNot(a.series.first));
      expect(mid.series.first, isNot(b.series.first));
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
      expect(AppTheme.paper.tone, AppTheme.serious.tone);
      expect(AppTheme.night.tone, AppTheme.serious.tone);
      expect(AppTheme.nature.tone, AppTheme.calm.tone);
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
