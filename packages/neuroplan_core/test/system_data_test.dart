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

  test('9 kök kategori, 20 bölge, tekil anahtarlar', () {
    expect(data.rootCategories, hasLength(9));
    expect(data.regions, hasLength(20));
    expect(data.rootCategories.map((c) => c.key).toSet(), hasLength(9));
    expect(data.regions.map((r) => r.key).toSet(), hasLength(20));
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
}
