/// Olaylardan beyin durumunu üreten katlama (docs/BRAIN_MODEL.md §3, ARCHITECTURE §7).
///
/// Saf ve deterministiktir: olaylar (an, tekilleştirme anahtarı) sırasıyla işlenir; [asOf]
/// sonrasındaki olaylar yok sayılır. Zaman çizelgesi aynı fonksiyonu geçmiş bir anla çağırır.
library;

import 'dart:math' as math;

import 'brain_config.dart';
import 'brain_engine.dart';

final class RegionState {
  RegionState(this.key);

  final String key;

  /// Yanan ve sönük nöronlar, binde bir birim. Toplamları hiç azalmaz (BRAIN-3).
  int lit = 0;
  int dimmed = 0;

  /// Son kazanç anı; sönme buna göre hesaplanır.
  DateTime? lastActive;

  /// Kök kategori → bu bölgeye verdiği kazanç (renk ve "seni besleyenler" için).
  final Map<String, int> byRoot = {};

  /// 0–1000; [foldBrain] doldurur.
  int brightness = 0;

  int get total => lit + dimmed;

  Map<String, Object?> toJson() => {
    'neurons': total,
    'lit': lit,
    'dimmed': dimmed,
    'brightness': brightness,
    'last_active': lastActive?.toUtc().toIso8601String(),
    if (byRoot.isNotEmpty) 'by_root': byRoot,
  };
}

final class BrainState {
  BrainState(this.asOf, this.regions, this.connections);

  final DateTime asOf;
  final Map<String, RegionState> regions;

  /// `a|b` (a ≤ b) → güç, binde bir birim.
  final Map<String, int> connections;

  bool get isEmpty => regions.values.every((r) => r.total == 0);

  /// `brain_snapshots.state` biçimi (DB_SCHEMA §4.4).
  Map<String, Object?> toJson() => {
    'regions': {for (final r in regions.values) r.key: r.toJson()},
    'connections': [
      for (final MapEntry(:key, :value) in connections.entries)
        {
          'a': key.substring(0, key.indexOf('|')),
          'b': key.substring(key.indexOf('|') + 1),
          'strength': value,
        },
    ],
  };
}

/// [regionKeys] bütün bölgeleri sabit sırayla verir (olayı olmayanlar da durumda yer alır).
/// [sessionRoots]: oturum → kök kategori; `byRoot` bunu kullanır.
BrainState foldBrain(
  Iterable<BrainEventDraft> events,
  DateTime asOf, {
  required List<String> regionKeys,
  Map<String, String> sessionRoots = const {},
  BrainConfig config = brainConfig,
}) {
  final regions = {for (final k in regionKeys) k: RegionState(k)};
  final connections = <String, int>{};
  final sorted =
      [
        for (final e in events)
          if (!e.occurredAt.isAfter(asOf)) e,
      ]..sort((a, b) {
        final c = a.occurredAt.compareTo(b.occurredAt);
        return c != 0 ? c : a.dedupeKey.compareTo(b.dedupeKey);
      });
  for (final e in sorted) {
    final r = regions[e.regionKey];
    if (r == null) continue; // bilinmeyen bölge (eski sürüm): yok sayılır
    switch (e.type) {
      case 'neuron_gain':
        // Önce sönükler yeniden yanar, kalan yeni nörondur.
        final relit = math.min(r.dimmed, e.amount);
        r.dimmed -= relit;
        r.lit += e.amount;
        r.lastActive = e.occurredAt;
        final root = sessionRoots[e.sessionId];
        if (root != null) r.byRoot[root] = (r.byRoot[root] ?? 0) + e.amount;
      case 'penalty':
        final moved = math.min(r.lit, e.amount);
        r.lit -= moved;
        r.dimmed += moved;
      case 'connection_gain':
        final b = e.regionBKey ?? e.regionKey;
        if (!regions.containsKey(b)) continue;
        final key = e.regionKey.compareTo(b) <= 0
            ? '${e.regionKey}|$b'
            : '$b|${e.regionKey}';
        connections[key] = (connections[key] ?? 0) + e.amount;
    }
  }
  for (final r in regions.values) {
    r.brightness = brightnessAt(r.lastActive, asOf, config);
  }
  return BrainState(asOf, regions, connections);
}

/// Sönme olaysızdır (D39): `taban + (1 − taban) × 0,5^(gün / yarılanma)`, 0–1000.
int brightnessAt(DateTime? lastActive, DateTime asOf, BrainConfig config) {
  final floor = config.brightnessFloorPermille;
  if (lastActive == null) return floor;
  final days = asOf.difference(lastActive).inMinutes / (24 * 60);
  if (days <= 0) return 1000;
  return (floor + (1000 - floor) * math.pow(0.5, days / config.halfLifeDays))
      .round();
}

/// Olay kümesinin özeti (FNV-1a, 32 bit): anlık görüntü önbelleği bununla doğrulanır.
String eventsHash(Iterable<String> dedupeKeys) {
  final keys = dedupeKeys.toList()..sort();
  // × 16777619 = × 403 + << 24; ara değerler 2^53 altında kalır (dart2js'te de aynı sonuç).
  int mix(int h, int c) {
    final x = (h ^ c) & 0xffffffff;
    return (x * 403 + ((x & 0xff) << 24)) & 0xffffffff;
  }

  var h = 0x811c9dc5;
  for (final k in keys) {
    for (final c in k.codeUnits) {
      h = mix(h, c);
    }
    h = mix(h, 10);
  }
  return '${keys.length}-${h.toRadixString(16).padLeft(8, '0')}';
}
