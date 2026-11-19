// Sistem tablolarının seed migration'ını assets/seed/system.json'dan üretir.
//   dart run tool/gen_seed_sql.dart          → dosyayı yazar
//   dart run tool/gen_seed_sql.dart --check  → dosya JSON ile aynı değilse 1 ile çıkar
// Sistem verisi değişirse: JSON'u düzenle, bu betikle yeni bir migration üret (upsert'ler tekrar çalışabilir).
import 'dart:convert';
import 'dart:io';

import 'package:neuroplan_core/neuroplan_core.dart';

const seedJsonPath = 'assets/seed/system.json';
// İlk seed 20261118120200_system_seed.sql idi; Aşama 4'te bölgeler anatomik oldu (D38).
const seedSqlPath = 'supabase/migrations/20261119120100_system_seed_v2.sql';

String _q(String s) => "'${s.replaceAll("'", "''")}'";
String _arr(List<String> xs) =>
    xs.isEmpty ? "'{}'::text[]" : 'array[${xs.map(_q).join(', ')}]';

String generateSeedSql(SystemData d) {
  final b = StringBuffer()
    ..writeln(
      '-- ÜRETİLDİ: tool/gen_seed_sql.dart (kaynak: $seedJsonPath). Elle düzenleme.',
    )
    ..writeln()
    ..writeln(
      'insert into public.root_categories '
      '(key, sort_order, name_tr, name_en, description_tr, description_en, icon, color) values',
    );
  b.writeln(
    [
      for (final c in d.rootCategories)
        '  (${_q(c.key)}, ${c.sortOrder}, ${_q(c.nameTr)}, ${_q(c.nameEn)}, '
            '${_q(c.descriptionTr)}, ${_q(c.descriptionEn)}, ${_q(c.icon)}, ${_q(c.color)})',
    ].join(',\n'),
  );
  b
    ..writeln(
      'on conflict (key) do update set sort_order = excluded.sort_order, '
      'name_tr = excluded.name_tr, name_en = excluded.name_en, '
      'description_tr = excluded.description_tr, description_en = excluded.description_en, '
      'icon = excluded.icon, color = excluded.color;',
    )
    ..writeln()
    ..writeln(
      'insert into public.brain_regions (key, sort_order, name_tr, name_en, hemisphere, mesh_name, is_inner) values',
    );
  b.writeln(
    [
      for (final r in d.regions)
        '  (${_q(r.key)}, ${r.sortOrder}, ${_q(r.nameTr)}, ${_q(r.nameEn)}, '
            '${_q(r.hemisphere)}, ${_q(r.meshName)}, ${r.isInner})',
    ].join(',\n'),
  );
  b
    ..writeln(
      'on conflict (key) do update set sort_order = excluded.sort_order, '
      'name_tr = excluded.name_tr, name_en = excluded.name_en, '
      'hemisphere = excluded.hemisphere, mesh_name = excluded.mesh_name, '
      'is_inner = excluded.is_inner;',
    )
    ..writeln()
    ..writeln(
      'insert into public.category_region_weights '
      '(root_category_key, region_key, weight, evidence_level, source_ids, source_urls, '
      'detail_tr, detail_en) values',
    );
  b.writeln(
    [
      for (final w in d.weights)
        '  (${_q(w.rootCategoryKey)}, ${_q(w.regionKey)}, ${w.weight.toStringAsFixed(2)}, '
            '${_q(w.evidence.json)}, ${_arr(w.sourceIds)}, ${_arr(d.sourceUrls(w))}, '
            '${_q(w.detailTr)}, ${_q(w.detailEn)})',
    ].join(',\n'),
  );
  b.writeln(
    'on conflict (root_category_key, region_key) do update set weight = excluded.weight, '
    'evidence_level = excluded.evidence_level, source_ids = excluded.source_ids, '
    'source_urls = excluded.source_urls, detail_tr = excluded.detail_tr, '
    'detail_en = excluded.detail_en;',
  );
  return b.toString();
}

void main(List<String> args) {
  final data = SystemData.fromJson(
    jsonDecode(File(seedJsonPath).readAsStringSync()) as Map<String, Object?>,
  );
  final sql = generateSeedSql(data);
  final file = File(seedSqlPath);
  if (args.contains('--check')) {
    final current = file.existsSync()
        ? file.readAsStringSync().replaceAll('\r\n', '\n')
        : '';
    if (current != sql) {
      stderr.writeln(
        '$seedSqlPath güncel değil: dart run tool/gen_seed_sql.dart',
      );
      exit(1);
    }
    stdout.writeln('Seed migration güncel.');
    return;
  }
  file.writeAsStringSync(sql);
  stdout.writeln('Yazıldı: $seedSqlPath');
}
