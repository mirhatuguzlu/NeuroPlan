import 'dart:convert';

import 'package:neuroplan_core/neuroplan_core.dart';

/// Flutter ↔ WebView beyin sahnesi mesajları (docs/ARCHITECTURE.md §8, DECISIONS D40).
/// Biçim: `{"v": 1, "type": "...", "payload": {...}}`. Sahne tarafı `tool/brain/src/core.js`.
const bridgeVersion = 1;

/// Sahnenin renkleri (`#RRGGBB`): aktif temadan türetilir.
final class SceneTheme {
  const SceneTheme({
    required this.background,
    required this.shell,
    required this.glow,
    required this.signal,
    required this.dim,
    required this.line,
    required this.penalty,
  });

  final String background;
  final String shell;
  final String glow;
  final String signal;
  final String dim;
  final String line;
  final String penalty;

  Map<String, Object?> toJson() => {
    'background': background,
    'shell': shell,
    'glow': glow,
    'signal': signal,
    'dim': dim,
    'line': line,
    'penalty': penalty,
  };

  @override
  bool operator ==(Object other) =>
      other is SceneTheme && jsonEncode(other.toJson()) == jsonEncode(toJson());

  @override
  int get hashCode => jsonEncode(toJson()).hashCode;
}

/// Flutter → sahne.
sealed class ToScene {
  const ToScene();
  String get type;
  Map<String, Object?> get payload;

  String encode() =>
      jsonEncode({'v': bridgeVersion, 'type': type, 'payload': payload});
}

final class SceneInit extends ToScene {
  const SceneInit({
    required this.theme,
    required this.rootColors,
    required this.reducedMotion,
    required this.tier,
    required this.seed,
  });

  final SceneTheme theme;
  final Map<String, String> rootColors;
  final bool reducedMotion;
  final QualityTier tier;
  final String seed;

  @override
  String get type => 'init';
  @override
  Map<String, Object?> get payload => {
    'theme': theme.toJson(),
    'rootColors': rootColors,
    'reducedMotion': reducedMotion,
    'tier': tier.name,
    'seed': seed,
  };
}

final class SceneState extends ToScene {
  const SceneState(this.asOf, this.plan);

  final DateTime asOf;
  final RenderPlan plan;

  @override
  String get type => 'state';
  @override
  Map<String, Object?> get payload => {
    'asOf': asOf.toUtc().toIso8601String(),
    'regions': [for (final r in plan.regions) r.toJson()],
    'links': [for (final l in plan.links) l.toJson()],
  };
}

final class SceneHighlight extends ToScene {
  const SceneHighlight(this.key, {this.focus = false});

  /// null = vurgu yok.
  final String? key;

  /// true: bölge sayfası; yalnız bu bölge, kalanı silik ve kamera bölgeye yaklaşır.
  final bool focus;

  @override
  String get type => 'highlight';
  @override
  Map<String, Object?> get payload => {
    'key': key,
    'mode': focus ? 'focus' : 'overview',
  };
}

enum SceneEventKind { gain, penalty }

final class SceneEvent extends ToScene {
  const SceneEvent(this.kind, this.regions);

  final SceneEventKind kind;
  final List<String> regions;

  @override
  String get type => 'event';
  @override
  Map<String, Object?> get payload => {'kind': kind.name, 'regions': regions};
}

final class SceneQuality extends ToScene {
  const SceneQuality(this.tier);
  final QualityTier tier;

  @override
  String get type => 'quality';
  @override
  Map<String, Object?> get payload => {'tier': tier.name};
}

final class SceneVisibility extends ToScene {
  const SceneVisibility(this.visible);
  final bool visible;

  @override
  String get type => 'visibility';
  @override
  Map<String, Object?> get payload => {'visible': visible};
}

final class SceneReset extends ToScene {
  const SceneReset();

  @override
  String get type => 'reset';
  @override
  Map<String, Object?> get payload => const {};
}

/// Sahne → Flutter.
sealed class FromScene {
  const FromScene();

  /// Bilinmeyen sürüm ya da tür null döner (çağıran günlüğe yazar ve yok sayar).
  static FromScene? decode(String text) {
    final Object? m;
    try {
      m = jsonDecode(text);
    } on FormatException {
      return null;
    }
    if (m is! Map || m['v'] != bridgeVersion) return null;
    final p = m['payload'] is Map
        ? (m['payload'] as Map).cast<String, Object?>()
        : const <String, Object?>{};
    return switch (m['type']) {
      'ready' => SceneReady(
        sceneVersion: p['scene'] as int? ?? 0,
        regions: [for (final r in p['regions'] as List? ?? const []) '$r'],
        cores: (p['hints'] as Map?)?['cores'] as int?,
        memoryGb: ((p['hints'] as Map?)?['memoryGb'] as num?)?.toDouble(),
        renderer: (p['hints'] as Map?)?['renderer'] as String? ?? '',
      ),
      'regionTapped' => RegionTapped(p['key'] as String?),
      'perf' => ScenePerf(
        fps: (p['fps'] as num? ?? 0).toDouble(),
        frameMs: (p['frameMs'] as num? ?? 0).toDouble(),
        tier: p['tier'] as String? ?? '',
      ),
      'reset' => const SceneWasReset(),
      'error' => SceneError(p['message'] as String? ?? ''),
      _ => null,
    };
  }
}

final class SceneReady extends FromScene {
  const SceneReady({
    required this.sceneVersion,
    required this.regions,
    this.cores,
    this.memoryGb,
    this.renderer = '',
  });

  final int sceneVersion;

  /// Modeldeki bölge anahtarları (brain_regions ile birebir olmalı).
  final List<String> regions;
  final int? cores;
  final double? memoryGb;
  final String renderer;
}

final class RegionTapped extends FromScene {
  const RegionTapped(this.key);

  /// null = boşluğa dokunuldu.
  final String? key;
}

final class ScenePerf extends FromScene {
  const ScenePerf({
    required this.fps,
    required this.frameMs,
    required this.tier,
  });
  final double fps;

  /// Rapor aralığındaki en uzun kare.
  final double frameMs;
  final String tier;
}

/// Kullanıcı sahnede çift dokunuşla görünümü sıfırladı.
final class SceneWasReset extends FromScene {
  const SceneWasReset();
}

final class SceneError extends FromScene {
  const SceneError(this.message);

  /// `webgl`: cihazda WebGL yok; metin alternatifi gösterilir.
  final String message;
}
