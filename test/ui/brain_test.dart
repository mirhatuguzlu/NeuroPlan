import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/ui/features/brain/bridge.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import 'harness.dart';

/// Tamamlanmış bir Duygusal ve Sosyal Zeka oturumu (amigdala dahil beş bölge).
Future<void> seedSession(ProviderContainer c) async {
  final focus = c.read(focusRepositoryProvider);
  final end = testNow.subtract(const Duration(hours: 1));
  final s = await focus.start(
    mode: 'free',
    rootCategoryKey: 'emotional_social',
    startedAt: end.subtract(const Duration(minutes: 50)),
  );
  await focus.finish(
    s.id,
    outcome: 'completed',
    focusedSeconds: 50 * 60,
    endedAt: end,
  );
  await c.read(brainRepositoryProvider).deriveFor(s.id);
}

Future<void> ready(Harness h) async {
  h.brain.emit(
    const SceneReady(
      sceneVersion: 1,
      regions: [],
      cores: 8,
      memoryGb: 8,
      renderer: 'Adreno (TM) 740',
    ),
  );
  await h.settle();
}

void main() {
  group('köprü', () {
    test('Flutter → sahne mesajı sürümlü ve tipli', () {
      final m = jsonDecode(
        const SceneHighlight('amygdala', focus: true).encode(),
      );
      expect(m, {
        'v': 1,
        'type': 'highlight',
        'payload': {'key': 'amygdala', 'mode': 'focus'},
      });
      final init = jsonDecode(
        const SceneInit(
          theme: SceneTheme(
            background: '#000000',
            shell: '#111111',
            glow: '#222222',
            signal: '#333333',
            dim: '#444444',
            line: '#555555',
            penalty: '#666666',
          ),
          rootColors: {'rest_sleep': '#4EA8DE'},
          reducedMotion: true,
          tier: QualityTier.low,
          seed: 'u1',
        ).encode(),
      ) as Map;
      expect(init['type'], 'init');
      expect((init['payload'] as Map)['tier'], 'low');
      expect((init['payload'] as Map)['reducedMotion'], true);
    });

    test('sahne → Flutter: bilinen türler çözülür, bilinmeyen yok sayılır', () {
      final r = FromScene.decode(
        '{"v":1,"type":"ready","payload":{"scene":1,"regions":["amygdala"],'
        '"hints":{"cores":8,"memoryGb":4,"renderer":"Mali-G57"}}}',
      );
      expect(r, isA<SceneReady>());
      expect((r! as SceneReady).memoryGb, 4.0);
      expect(
        (FromScene.decode(
                  '{"v":1,"type":"regionTapped","payload":{"key":"insula"}}',
                )!
                as RegionTapped)
            .key,
        'insula',
      );
      expect(
        (FromScene.decode(
                  '{"v":1,"type":"perf","payload":{"fps":58.5,"frameMs":21}}',
                )!
                as ScenePerf)
            .fps,
        58.5,
      );
      expect(FromScene.decode('{"v":2,"type":"ready"}'), isNull);
      expect(FromScene.decode('{"v":1,"type":"boom"}'), isNull);
      expect(FromScene.decode('bozuk'), isNull);
    });
  });

  testWidgets('Beyin: hazır olunca init + durum gider; boşken açıklama', (
    t,
  ) async {
    final h = await pumpApp(t);
    await h.tap(find.text('Beyin').last);
    expect(find.bySemanticsLabel('Beyin hazırlanıyor'), findsOneWidget);
    expect(h.brain.sentOf<SceneInit>(), isEmpty);

    await ready(h);
    final init = h.brain.sentOf<SceneInit>().single;
    expect(init.tier, QualityTier.high);
    expect(init.rootColors['rest_sleep'], '#4EA8DE');
    expect(h.brain.sentOf<SceneState>(), isNotEmpty);
    expect(h.brain.sentOf<SceneVisibility>().last.visible, isTrue);
    expect(find.text('Henüz yanan nöron yok'), findsOneWidget);
    await h.expectAccessible();
  });

  testWidgets('Beyin: oturum nöron olarak çizilir, zaman çizelgesi görünür', (
    t,
  ) async {
    final h = await pumpApp(t, seed: seedSession);
    await h.tap(find.text('Beyin').last);
    await ready(h);
    final plan = h.brain.sentOf<SceneState>().last.plan;
    final amygdala = plan.regions.firstWhere((r) => r.key == 'amygdala');
    expect(amygdala.points, 10); // 50 dk / 5 bölge
    expect(amygdala.rootKey, 'emotional_social');
    expect(find.text('Henüz yanan nöron yok'), findsNothing);
  });

  testWidgets(
    'Beyin: bölgeye dokununca bölge sayfası açılır, geri gelince vurgu kalkar',
    (t) async {
      final h = await pumpApp(t, seed: seedSession);
      await h.tap(find.text('Beyin').last);
      await ready(h);
      h.brain.emit(const RegionTapped('amygdala'));
      await h.settle();
      final hl = h.brain.sentOf<SceneHighlight>().last;
      expect((hl.key, hl.focus), ('amygdala', true));
      expect(find.text('Amigdala'), findsOneWidget);
      expect(find.textContaining('50 dakika ayırdın'), findsOneWidget);
      expect(find.text('Duygusal ve Sosyal Zeka'), findsWidgets);
      await h.expectAccessible();

      await h.tap(find.byTooltip('Geri'));
      expect(h.brain.sentOf<SceneHighlight>().last.key, isNull);
      expect(find.text('Amigdala'), findsNothing);
    },
  );

  testWidgets('Beyin: düşük fps iki kez gelince kalite düşer', (t) async {
    final h = await pumpApp(t);
    await h.tap(find.text('Beyin').last);
    await ready(h);
    for (var i = 0; i < 2; i++) {
      h.brain.emit(const ScenePerf(fps: 31, frameMs: 40, tier: 'high'));
      await h.settle();
    }
    expect(h.brain.sentOf<SceneQuality>().single.tier, QualityTier.mid);
  });

  testWidgets('Beyin: başka sekmeye geçince çizim durur', (t) async {
    final h = await pumpApp(t);
    await h.tap(find.text('Beyin').last);
    await ready(h);
    await h.tap(find.text('Bugün').last);
    expect(h.brain.sentOf<SceneVisibility>().last.visible, isFalse);
  });

  testWidgets('Beyin: WebGL yoksa liste görünümüne yönlendirir', (t) async {
    final h = await pumpApp(t);
    await h.tap(find.text('Beyin').last);
    h.brain.emit(const SceneError('webgl'));
    await h.settle();
    expect(find.text('3D beyin bu cihazda açılamadı'), findsOneWidget);
    await h.tap(find.text('Liste görünümü'));
    expect(find.text('Beyin bölgeleri'), findsOneWidget);
  });

  testWidgets('liste görünümü: bölgeler ve bölge sayfasında kanıt', (t) async {
    final h = await pumpApp(t, seed: seedSession);
    h.read(routerProvider).push('/brain/list');
    await h.settle();
    expect(find.text('Kategoriler'), findsOneWidget);
    await t.scrollUntilVisible(find.text('Amigdala'), 200);
    expect(find.textContaining('10 nöron'), findsWidgets);
    await h.tap(find.text('Amigdala'));
    await t.scrollUntilVisible(
      find.textContaining('Orta düzey kanıt'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.textContaining('S10'), findsOneWidget);
    await h.expectAccessible();
  });

  testWidgets('ekran okuyucu açıkken Beyin sekmesi listeyi gösterir', (
    t,
  ) async {
    final h = await pumpApp(t);
    t.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(accessibleNavigation: true);
    addTearDown(t.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await h.tap(find.text('Beyin').last);
    expect(find.text('Beyin bölgeleri'), findsOneWidget);
    expect(find.byKey(const ValueKey('fake-brain-scene')), findsNothing);
  });

  testWidgets('Hakkında: BodyParts3D atfı ve lisanslar', (t) async {
    final h = await pumpApp(t);
    h.read(routerProvider).push('/profile/about');
    await h.settle();
    expect(
      find.textContaining(
        'BodyParts3D, © The Database Center for Life Science licensed under CC Attribution 4.0 International',
      ),
      findsOneWidget,
    );
    expect(find.text('Bütün lisansları göster'), findsOneWidget);
    await h.expectAccessible();
  });
}
