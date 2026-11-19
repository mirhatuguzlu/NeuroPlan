/// Kanıt düzeyi ve ağırlık tavanı (docs/SCIENCE.md §1 ilke 2, DB_SCHEMA §2.3).
enum EvidenceLevel {
  strong('strong', 1.0),
  moderate('moderate', 0.6),
  weak('weak', 0.3),
  noSource('no_source', 0.1);

  const EvidenceLevel(this.json, this.ceiling);
  final String json;
  final double ceiling;

  static EvidenceLevel fromJson(Object? v) => values.firstWhere(
    (e) => e.json == v,
    orElse: () => throw FormatException('Geçersiz kanıt düzeyi: $v'),
  );
}

final class RootCategoryDef {
  RootCategoryDef.fromJson(Map<String, Object?> j)
    : key = j['key'] as String,
      sortOrder = j['sort_order'] as int,
      nameTr = j['name_tr'] as String,
      nameEn = j['name_en'] as String,
      descriptionTr = j['description_tr'] as String,
      descriptionEn = j['description_en'] as String,
      icon = j['icon'] as String,
      color = j['color'] as String;

  final String key;
  final int sortOrder;
  final String nameTr;
  final String nameEn;
  final String descriptionTr;
  final String descriptionEn;
  final String icon;
  final String color;
}

final class BrainRegionDef {
  BrainRegionDef.fromJson(Map<String, Object?> j)
    : key = j['key'] as String,
      sortOrder = j['sort_order'] as int,
      nameTr = j['name_tr'] as String,
      nameEn = j['name_en'] as String,
      hemisphere = j['hemisphere'] as String,
      isInner = j['is_inner'] as bool? ?? false;

  final String key;
  final int sortOrder;
  final String nameTr;
  final String nameEn;

  /// `left` · `right` · `bilateral`
  final String hemisphere;

  /// Yarı saydam iç yapı (hipokampüs, amigdala…); kabuğun içinde çizilir.
  final bool isInner;

  /// 3D modeldeki düğüm adı (`assets/brain`, tool/brain/regions.json).
  String get meshName => 'region_$key';
}

final class RegionWeightDef {
  RegionWeightDef.fromJson(Map<String, Object?> j)
    : rootCategoryKey = j['root_category_key'] as String,
      regionKey = j['region_key'] as String,
      weight = (j['weight'] as num).toDouble(),
      evidence = EvidenceLevel.fromJson(j['evidence_level']),
      sourceIds = [for (final s in j['source_ids'] as List) s as String],
      detailTr = j['detail_tr'] as String? ?? '',
      detailEn = j['detail_en'] as String? ?? '';

  final String rootCategoryKey;
  final String regionKey;
  final double weight;
  final EvidenceLevel evidence;
  final List<String> sourceIds;

  /// Kaynaktaki işlevsel alt bölge (ör. "Dorsolateral prefrontal korteks"); D38.
  final String detailTr;
  final String detailEn;
}

/// Sistem tablolarının tek kaynağı: `assets/seed/system.json`.
/// Hem Drift seed'i hem de `tool/gen_seed_sql.dart` bunu okur.
final class SystemData {
  SystemData.fromJson(Map<String, Object?> j)
    : sources = (j['sources'] as Map).cast<String, String>(),
      rootCategories = [
        for (final e in j['root_categories'] as List)
          RootCategoryDef.fromJson(e as Map<String, Object?>),
      ],
      regions = [
        for (final e in j['brain_regions'] as List)
          BrainRegionDef.fromJson(e as Map<String, Object?>),
      ],
      weights = [
        for (final e in j['category_region_weights'] as List)
          RegionWeightDef.fromJson(e as Map<String, Object?>),
      ];

  /// Kaynak kimliği (S2…) → `https://doi.org/...`
  final Map<String, String> sources;
  final List<RootCategoryDef> rootCategories;
  final List<BrainRegionDef> regions;
  final List<RegionWeightDef> weights;

  List<String> sourceUrls(RegionWeightDef w) => [
    for (final id in w.sourceIds) sources[id]!,
  ];
}
