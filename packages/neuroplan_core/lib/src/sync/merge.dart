/// Alan bazlı "son yazan kazanır" birleştirmesi (docs/ARCHITECTURE.md §5.2).
///
/// [localVersions] / [remoteVersions]: sütun → HLC metni. Kural:
/// - İki tarafta da sürüm varsa büyük HLC kazanır (eşitlikte yerel kalır; değer aynıdır).
/// - Yalnız yerelde sürüm varsa yerel kalır (gönderilmeyi bekleyen değişiklik).
/// - Yerelde sürüm yoksa uzak (sunucu) kazanır; `updated_at` gibi sunucu alanları da böyle.
({Map<String, Object?> values, Map<String, String> versions}) mergeFields({
  required Map<String, Object?> local,
  required Map<String, String> localVersions,
  required Map<String, Object?> remote,
  required Map<String, String> remoteVersions,
}) {
  final values = Map<String, Object?>.of(local);
  final versions = Map<String, String>.of(localVersions);
  for (final MapEntry(:key, :value) in remote.entries) {
    final l = localVersions[key];
    final r = remoteVersions[key];
    if (l == null || (r != null && r.compareTo(l) > 0)) {
      values[key] = value;
      if (r != null) versions[key] = r;
    }
  }
  return (values: values, versions: versions);
}
