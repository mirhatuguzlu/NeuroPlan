import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

import '../../../app/providers.dart';
import '../../../data/repositories/brain_repository.dart';
import 'brain_scene.dart';
import 'bridge.dart';

/// Yalnız fps ölçümü (docs/BRAIN_MODEL.md §6): `--dart-define=BRAIN_BENCH=<nöron>` sahneye gerçek
/// durum yerine bu kadar nöron ve bağ gönderir, veritabanına dokunmaz. `BRAIN_TIER`
/// kademeyi sabitler (otomatik düşürme kapanır). İkisi de varsayılan olarak kapalıdır.
const _benchNeurons = int.fromEnvironment('BRAIN_BENCH');
const _benchTier = String.fromEnvironment('BRAIN_TIER');

/// Olaylar + oturum kökleri; olay yazıldıkça yenilenir.
final brainHistoryProvider = StreamProvider<BrainHistory>(
  (ref) => ref.watch(brainRepositoryProvider).watchHistory(),
);

@immutable
class BrainViewState {
  const BrainViewState({
    this.ready = false,
    this.error,
    this.asOf,
    this.selected,
    this.tier = QualityTier.mid,
    this.fps,
  });

  /// Sahne modeli yükledi.
  final bool ready;

  /// Sahne açılamadı (ör. `webgl`); ekran metin alternatifine düşer.
  final String? error;

  /// Zaman çizelgesinde seçilen an; null = şimdi.
  final DateTime? asOf;

  /// Bölge sayfası açık olan bölge.
  final String? selected;
  final QualityTier tier;
  final double? fps;

  BrainViewState copyWith({
    bool? ready,
    String? Function()? error,
    DateTime? Function()? asOf,
    String? Function()? selected,
    QualityTier? tier,
    double? fps,
  }) => BrainViewState(
    ready: ready ?? this.ready,
    error: error != null ? error() : this.error,
    asOf: asOf != null ? asOf() : this.asOf,
    selected: selected != null ? selected() : this.selected,
    tier: tier ?? this.tier,
    fps: fps ?? this.fps,
  );
}

/// Beyin ekranının durumu ve sahneyle konuşan tek yer. Hesap çekirdektedir
/// (`foldBrain`, `renderPlan`, `QualityGovernor`); burada yalnız bağlanır.
final brainControllerProvider =
    NotifierProvider<BrainController, BrainViewState>(BrainController.new);

class BrainController extends Notifier<BrainViewState> {
  late BrainScene _scene;
  QualityGovernor? _governor;
  ({SceneTheme theme, Map<String, String> colors, bool reducedMotion})? _look;
  bool _visible = false;
  bool _initSent = false;
  bool _played = false;

  @override
  BrainViewState build() {
    _scene = ref.watch(brainSceneProvider);
    final sub = _scene.messages.listen(_onMessage);
    ref.onDispose(sub.cancel);
    ref.listen(brainHistoryProvider, (_, _) => _push());
    ref.listen(brainRegionsProvider, (_, _) => _push());
    return const BrainViewState();
  }

  /// O anki durum (zaman çizelgesindeki an ya da şimdi).
  BrainState? get brainState {
    final h = ref.read(brainHistoryProvider).value;
    final regions = ref.read(brainRegionsProvider).value;
    if (h == null || regions == null) return null;
    final keys = regions.values.toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return foldBrain(
      h.events,
      state.asOf ?? DateTime.now().toUtc(),
      regionKeys: [for (final r in keys) r.key],
      sessionRoots: h.sessionRoots,
    );
  }

  /// Tema, kök kategori renkleri ve hareket tercihi (ekran her kurulduğunda verir).
  void configure(
    SceneTheme theme,
    Map<String, String> rootColors,
    bool reducedMotion,
  ) {
    final look = (
      theme: theme,
      colors: rootColors,
      reducedMotion: reducedMotion,
    );
    if (_look != null &&
        _look!.theme == theme &&
        mapEquals(_look!.colors, rootColors) &&
        _look!.reducedMotion == reducedMotion) {
      return;
    }
    _look = look;
    _initSent = false;
    unawaited(_init());
  }

  /// Sekme görünür mü (sekme değişimi, uygulama arka planı). Görünmezken çizim durur.
  void setVisible(bool visible) {
    if (_visible == visible) return;
    _visible = visible;
    _scene.send(SceneVisibility(visible));
    if (visible) unawaited(_playUnseen());
  }

  /// Zaman çizelgesi; null = şimdi.
  void scrub(DateTime? asOf) {
    state = state.copyWith(asOf: () => asOf);
    _push();
  }

  /// Bölge sayfasını açar (focus) ya da kapatır (null).
  void select(String? key) {
    state = state.copyWith(selected: () => key);
    _scene.send(SceneHighlight(key, focus: key != null));
  }

  void resetView() => _scene.send(const SceneReset());

  void _onMessage(FromScene m) {
    switch (m) {
      case SceneReady():
        _governor = _benchTier.isNotEmpty
            ? QualityGovernor(QualityTier.values.byName(_benchTier))
            : QualityGovernor.fromHints(
                cores: m.cores,
                memoryGb: m.memoryGb,
                renderer: m.renderer,
              );
        state = state.copyWith(ready: true, tier: _governor!.tier);
        final db = ref.read(brainRegionsProvider).value?.keys.toSet();
        if (db != null && !setEquals(db, m.regions.toSet())) {
          debugPrint(
            '[brain] model bölgeleri seed ile uyuşmuyor: ${m.regions}',
          );
        }
        unawaited(_init());
      case RegionTapped(:final key):
        if (key != null) select(key);
      case ScenePerf(:final fps):
        state = state.copyWith(fps: fps);
        final next = _benchTier.isNotEmpty ? null : _governor?.report(fps);
        if (next != null) {
          state = state.copyWith(tier: next);
          _scene.send(SceneQuality(next));
          _push();
        }
      case SceneWasReset():
        if (state.selected != null) select(null);
      case SceneError(:final message):
        state = state.copyWith(error: () => message);
    }
  }

  Future<void> _init() async {
    final look = _look;
    if (look == null || !state.ready || _initSent) return;
    _initSent = true;
    _scene.send(
      SceneInit(
        theme: look.theme,
        rootColors: look.colors,
        reducedMotion: look.reducedMotion,
        tier: state.tier,
        seed: await ref.read(brainRepositoryProvider).seed(),
      ),
    );
    _scene.send(SceneVisibility(_visible));
    _push();
    if (state.selected case final key?) {
      _scene.send(SceneHighlight(key, focus: true));
    }
    if (_visible) unawaited(_playUnseen());
  }

  void _push() {
    if (!_initSent) return;
    final s = _benchNeurons > 0 ? _benchState() : brainState;
    if (s == null) return;
    _scene.send(SceneState(s.asOf, renderPlan(s, state.tier)));
    final h = ref.read(brainHistoryProvider).value;
    if (state.asOf == null && h != null) {
      unawaited(ref.read(brainRepositoryProvider).cache(s, h));
    }
  }

  /// Ölçüm durumu: bütün bölgelere eşit nöron, komşu bölgeler arasında güçlü bağ.
  BrainState? _benchState() {
    final regions = ref.read(brainRegionsProvider).value?.keys.toList();
    if (regions == null || regions.isEmpty) return null;
    final at = DateTime.now().toUtc();
    final per = _benchNeurons * unitsPerNeuron ~/ regions.length;
    final events = [
      for (final (i, k) in regions.indexed) ...[
        BrainEventDraft(
          type: 'neuron_gain',
          regionKey: k,
          amount: per,
          occurredAt: at,
          dedupeKey: 'bench:$k',
        ),
        BrainEventDraft(
          type: 'connection_gain',
          regionKey: k,
          regionBKey: regions[(i + 1) % regions.length],
          amount: 20000,
          occurredAt: at,
          dedupeKey: 'bench:$k:link',
        ),
      ],
    ];
    return foldBrain(events, at, regionKeys: regions);
  }

  /// Son görülenden sonraki kazanç ve ceza, sekme açılınca bir kez oynatılır.
  Future<void> _playUnseen() async {
    final h = ref.read(brainHistoryProvider).value;
    if (!_initSent || h == null || state.asOf != null) return;
    final repo = ref.read(brainRepositoryProvider);
    final unseen = await repo.unseen(h);
    if (!_played || unseen.isNotEmpty) {
      _played = true;
      final gain = {
        for (final e in unseen)
          if (e.type == 'neuron_gain') e.regionKey,
      };
      final penalty = {
        for (final e in unseen)
          if (e.type == 'penalty') e.regionKey,
      };
      if (penalty.isNotEmpty) {
        _scene.send(SceneEvent(SceneEventKind.penalty, penalty.toList()));
      }
      if (gain.isNotEmpty) {
        _scene.send(SceneEvent(SceneEventKind.gain, gain.toList()));
      }
    }
    await repo.markSeen(DateTime.now());
  }
}
