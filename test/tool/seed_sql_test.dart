import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/gen_seed_sql.dart';
import '../data/test_support.dart';

/// Seed migration'ı assets/seed/system.json ile aynı olmalı (tek kaynak).
void main() {
  test('seed migration JSON ile güncel', () {
    final current = File(seedSqlPath)
        .readAsStringSync()
        .replaceAll('\r\n', '\n');
    expect(
      current,
      generateSeedSql(systemData),
      reason: 'dart run tool/gen_seed_sql.dart',
    );
  });
}
