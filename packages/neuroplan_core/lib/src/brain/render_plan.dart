/// Beyin durumundan sahnenin çizeceği değerler: kaç nokta, ne kadar ışıma, hangi bağlar
/// (docs/BRAIN_MODEL.md §4). JS yalnız bunu çizer; karar burada verilir.
library;

import 'dart:math' as math;

import 'brain_engine.dart' show distribute;
import 'brain_fold.dart';

/// Cihaz gücüne göre kalite kademesi.
enum QualityTier {
  low(maxPoints: 1200, maxLinks: 40, bloom: 0, targetFps: 30),
  mid(maxPoints: 3000, maxLinks: 80, bloom: 1, targetFps: 60),
  high(maxPoints: 6000, maxLinks: 150, bloom: 2, targetFps: 60);

  const QualityTier({
    required this.maxPoints,
    required this.maxLinks,
    required this.bloom,
    required this.targetFps,
  });

  /// Ekranda en çok bu kadar nöron noktası.
  final int maxPoints;
  final int maxLinks;

  /// 0 kapalı · 1 yarım çözünürlük · 2 tam
  final int bloom;
  final int targetFps;

  QualityTier? get lower => index == 0 ? null : values[index - 1];
}

final class RegionRender {
  const RegionRender(
    this.key, {
    required this.points,
    required this.dimPoints,
    required this.glow,
    this.rootKey,
  });

  final String key;

  /// Yanan ve sönük nokta sayısı (görünür).
  final int points;
  final int dimPoints;

  /// 0–1000: parlaklık × üst sınır taşması. Sınıra ulaşınca kazanç buraya yansır.
  final int glow;

  /// Bölgeyi en çok besleyen kök kategori (renk); yoksa null.
  final String? rootKey;

  Map<String, Object?> toJson() => {
    'key': key,
    'points': points,
    'dimPoints': dimPoints,
    'glow': glow,
    if (rootKey != null) 'root': rootKey,
  };
}

final class LinkRender {
  const LinkRender(this.a, this.b, this.level);
  final String a;
  final String b;

  /// 0–1000: kalınlık ve parlaklık.
  final int level;

  Map<String, Object?> toJson() => {'a': a, 'b': b, 'strength': level};
}

final class RenderPlan {
  const RenderPlan(this.regions, this.links);
  final List<RegionRender> regions;
  final List<LinkRender> links;
}

/// Bir nöron = 1000 binde bir birim (bir odak dakikası).
const unitsPerNeuron = 1000;

RenderPlan renderPlan(BrainState s, QualityTier tier) {
  final totals = {
    for (final r in s.regions.values) r.key: r.total ~/ unitsPerNeuron,
  };
  final sum = totals.values.fold(0, (a, b) => a + b);
  // Sınır aşılırsa noktalar bölgelere orantılı dağıtılır; taşma ışımaya döner.
  final shown = sum <= tier.maxPoints
      ? totals
      : distribute(tier.maxPoints, {
          for (final MapEntry(:key, :value) in totals.entries)
            key: value.toDouble(),
        });
  final overflow = sum <= tier.maxPoints ? 1.0 : sum / tier.maxPoints;
  final regions = [
    for (final r in s.regions.values)
      () {
        final n = shown[r.key] ?? 0;
        final dim = r.total == 0 ? 0 : (n * r.dimmed / r.total).round();
        final boost = 1 + 0.25 * (math.log(overflow) / math.ln2);
        return RegionRender(
          r.key,
          points: n - dim,
          dimPoints: dim,
          glow: n == 0 ? 0 : math.min(1000, (r.brightness * boost).round()),
          rootKey: _dominant(r.byRoot),
        );
      }(),
  ];

  // En güçlü bağlar; güç logaritmik ölçekte 0–1000'e (100 dakikalık bağ ≈ tam).
  final entries = s.connections.entries.toList()
    ..sort((a, b) {
      final c = b.value.compareTo(a.value);
      return c != 0 ? c : a.key.compareTo(b.key);
    });
  final links = [
    for (final e in entries.take(tier.maxLinks))
      () {
        final i = e.key.indexOf('|');
        final a = e.key.substring(0, i);
        final b = e.key.substring(i + 1);
        final fade = math.min(
          s.regions[a]?.brightness ?? 0,
          s.regions[b]?.brightness ?? 0,
        );
        final level = math.min(
          1000.0,
          1000 * math.log(1 + e.value / 100) / math.log(1 + 1000),
        );
        return LinkRender(a, b, (level * fade / 1000).round());
      }(),
  ];
  return RenderPlan(regions, links);
}

String? _dominant(Map<String, int> byRoot) {
  String? best;
  for (final MapEntry(:key, :value) in byRoot.entries) {
    final cur = best == null ? -1 : byRoot[best]!;
    if (value > cur || (value == cur && key.compareTo(best!) < 0)) best = key;
  }
  return best;
}

/// fps raporlarından kalite kademesini düşürür (BRAIN-5). Kademe yalnız iner: titremeyi
/// önlemek için oturum boyunca geri yükselmez.
final class QualityGovernor {
  QualityGovernor(this.tier);

  /// Sahnenin bildirdiği donanım ipuçlarından başlangıç kademesi.
  factory QualityGovernor.fromHints({
    int? cores,
    double? memoryGb,
    String renderer = '',
  }) {
    final weakGpu = RegExp(r'Mali-(4|T6)|Adreno \(TM\) [345]\d\d|PowerVR SGX')
        .hasMatch(renderer);
    if (weakGpu || (cores ?? 8) <= 4 || (memoryGb ?? 8) <= 2) {
      return QualityGovernor(QualityTier.low);
    }
    if ((cores ?? 8) <= 6 || (memoryGb ?? 8) <= 4) {
      return QualityGovernor(QualityTier.mid);
    }
    return QualityGovernor(QualityTier.high);
  }

  QualityTier tier;
  int _strikes = 0;

  /// Hedefin %90'ının altındaki iki rapor üst üste bir kademe düşürür. Değiştiyse yeni
  /// kademeyi döndürür.
  QualityTier? report(double fps) {
    if (fps >= tier.targetFps * 0.9) {
      _strikes = 0;
      return null;
    }
    if (++_strikes < 2) return null;
    _strikes = 0;
    final next = tier.lower;
    if (next == null) return null;
    tier = next;
    return next;
  }
}
