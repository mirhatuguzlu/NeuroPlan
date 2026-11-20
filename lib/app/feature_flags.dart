import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'providers.dart';

/// Tek yerden kapatılabilen özellikler (D58). Ad, sunucudaki `feature_flags.key`'dir.
/// Kod varsayılanı: hepsi açık. Sunucu yoksa, ulaşılamıyorsa ya da satır yoksa geçerli.
enum Feature {
  /// Birlikte sekmesinin tamamı.
  together,
  messages,
  cofocus,

  /// Ortak odakta sesli sohbet.
  voice,
  leaderboard,
  brainCompare,

  /// Çökme raporları (Crashlytics, D59).
  crashReports,
}

@immutable
class FeatureFlags {
  const FeatureFlags([this._server = const {}]);

  final Map<String, bool> _server;

  bool on(Feature f) => _server[f.name] ?? true;

  /// Önbellekteki JSON; bozuksa kod varsayılanı.
  static FeatureFlags decode(String? json) {
    if (json == null) return const FeatureFlags();
    try {
      final m = jsonDecode(json) as Map<String, dynamic>;
      return FeatureFlags({
        for (final e in m.entries)
          if (e.value is bool) e.key: e.value as bool,
      });
    } on FormatException {
      return const FeatureFlags();
    } on TypeError {
      return const FeatureFlags();
    }
  }
}

/// Cihazdaki önbellek (`sync_state`, eşitlenmez).
const featureFlagsKey = 'flags.remote';

final featureFlagsProvider = StreamProvider<FeatureFlags>(
  (ref) => ref
      .watch(prefsRepositoryProvider)
      .watch(featureFlagsKey)
      .map(FeatureFlags.decode),
);

/// Widget içinde: bayrak açık mı (yüklenirken açık sayılır; kapatma sunucudan gelir).
bool featureOn(WidgetRef ref, Feature f) =>
    ref.watch(featureFlagsProvider).value?.on(f) ?? true;

/// Sunucudaki bayrakları açılışta ve ön plana dönüşte okuyup önbelleğe yazar. Ağ hatasında
/// son bilinen değerler kalır.
final featureFlagsSyncProvider = Provider<void>((ref) {
  final client = ref.watch(supabaseProvider);
  if (client == null) return;
  Future<void> pull() async {
    try {
      final rows = await client.from('feature_flags').select('key, enabled');
      await ref
          .read(prefsRepositoryProvider)
          .set(
            featureFlagsKey,
            jsonEncode({for (final r in rows) r['key']: r['enabled']}),
          );
    } catch (e) {
      debugPrint('[flags] $e');
    }
  }

  pull();
  final listener = AppLifecycleListener(onResume: pull);
  ref.onDispose(listener.dispose);
});
