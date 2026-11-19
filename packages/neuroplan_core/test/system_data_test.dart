import 'dart:convert';
import 'dart:io';

import 'package:neuroplan_core/neuroplan_core.dart';
import 'package:test/test.dart';

/// assets/seed/system.json'un SCIENCE.md ile tutarlılığı (CLAUDE.md kural 5).
void main() {
  final data = SystemData.fromJson(
    jsonDecode(File('../../assets/seed/system.json').readAsStringSync())
        as Map<String, Object?>,
  );
  final science = File('../../docs/SCIENCE.md')
      .readAsStringSync()
      .toLowerCase();

  test('9 kök kategori, 18 anatomik bölge, tekil anahtarlar', () {
    expect(data.rootCategories, hasLength(9));
    expect(data.regions, hasLength(18));
    expect(data.rootCategories.map((c) => c.key).toSet(), hasLength(9));
    expect(data.regions.map((r) => r.key).toSet(), hasLength(18));
  });

  test('kök kategori adları SCIENCE.md başlıklarıyla aynı', () {
    for (final c in data.rootCategories) {
      expect(science, contains(c.nameTr.toLowerCase()), reason: c.key);
      expect(c.color, matches(RegExp(r'^#[0-9A-F]{6}$')), reason: c.key);
      expect(c.icon, isNotEmpty);
    }
  });

  test('bölge yarımküresi geçerli', () {
    for (final r in data.regions) {
      expect(['left', 'right', 'bilateral'], contains(r.hemisphere));
    }
  });

  test('ağırlık kanıt tavanını aşmaz, her kökün en az bir bölgesi var', () {
    final roots = {for (final c in data.rootCategories) c.key};
    final regions = {for (final r in data.regions) r.key};
    for (final w in data.weights) {
      expect(roots, contains(w.rootCategoryKey));
      expect(regions, contains(w.regionKey));
      expect(w.weight, greaterThan(0));
      expect(
        w.weight,
        lessThanOrEqualTo(w.evidence.ceiling),
        reason: '${w.rootCategoryKey}/${w.regionKey}',
      );
      expect(
        w.sourceIds.isEmpty,
        w.evidence == EvidenceLevel.noSource,
        reason: 'kaynaksız satır yalnız no_source olabilir',
      );
    }
    expect({for (final w in data.weights) w.rootCategoryKey}, roots);
  });

  test('her kaynak SCIENCE.md §5\'te aynı DOI ile var', () {
    for (final MapEntry(:key, :value) in data.sources.entries) {
      final doi = value.replaceFirst('https://doi.org/', '').toLowerCase();
      expect(science, contains('| $key |'.toLowerCase()), reason: key);
      expect(science, contains('doi:$doi'), reason: key);
    }
    for (final w in data.weights) {
      expect(data.sources.keys, containsAll(w.sourceIds));
    }
  });

  test(
    'yan bölgenin yarımküresi adıyla uyumlu, mesh adı kurala uyar (D38)',
    () {
      for (final r in data.regions) {
        expect(r.meshName, 'region_${r.key}');
        if (r.key.endsWith('_left')) expect(r.hemisphere, 'left');
        if (r.key.endsWith('_right')) expect(r.hemisphere, 'right');
      }
      expect(
        {
          for (final r in data.regions)
            if (r.isInner) r.key,
        },
        {
          'corpus_callosum',
          'cingulate',
          'insula',
          'striatum',
          'hippocampus',
          'amygdala',
        },
      );
    },
  );

  test('her ağırlık satırının işlevsel alt bölge açıklaması var', () {
    for (final w in data.weights) {
      expect(
        w.detailTr,
        isNotEmpty,
        reason: '${w.rootCategoryKey}/${w.regionKey}',
      );
      expect(w.detailEn, isNotEmpty);
    }
  });

  test('model bölgeleri seed ile birebir (tool/brain/regions.json)', () {
    final model =
        (jsonDecode(File('../../tool/brain/regions.json').readAsStringSync())
                as Map<String, Object?>)['regions']
            as Map<String, Object?>;
    expect(model.keys.toSet(), {for (final r in data.regions) r.key});
  });
}
