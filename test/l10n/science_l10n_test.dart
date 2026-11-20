import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Kök kategori, bölge ve bilimsel açıklamalar iki dilde de var (I18N-1, D57).
/// Metin tek kaynaktan gelir: assets/seed/system.json (SCIENCE.md'den).
void main() {
  final data = jsonDecode(
    File('assets/seed/system.json').readAsStringSync(),
  ) as Map<String, dynamic>;

  void bilingual(String table, List<String> fields) {
    final rows = (data[table] as List).cast<Map<String, dynamic>>();
    expect(rows, isNotEmpty, reason: table);
    for (final r in rows) {
      for (final f in fields) {
        for (final lang in ['tr', 'en']) {
          final v = r['${f}_$lang'];
          expect(
            v is String && v.trim().isNotEmpty,
            isTrue,
            reason: '$table ${r['key'] ?? r['region_key']}: ${f}_$lang boş',
          );
        }
      }
    }
  }

  test('kök kategoriler: ad ve açıklama TR + EN', () {
    bilingual('root_categories', ['name', 'description']);
  });

  test('beyin bölgeleri: ad TR + EN', () {
    bilingual('brain_regions', ['name']);
  });

  test(
    'kategori–bölge bağları: ayrıntı TR + EN, kaynak ya da "kaynak yok"',
    () {
      bilingual('category_region_weights', ['detail']);
      final sources = (data['sources'] as Map).keys.toSet();
      for (final w in (data['category_region_weights'] as List).cast<Map>()) {
        for (final id in (w['source_ids'] as List)) {
          expect(sources, contains(id), reason: '${w['region_key']}: $id');
        }
      }
    },
  );
}
