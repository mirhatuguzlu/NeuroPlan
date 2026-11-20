import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:neuroplan/app/theme.dart';
import 'package:neuroplan/l10n/app_localizations.dart';

/// İki dil eşit ve tutarlı (I18N-1/3, D57).
void main() {
  Map<String, dynamic> load(String lang) =>
      jsonDecode(File('lib/l10n/app_$lang.arb').readAsStringSync())
          as Map<String, dynamic>;
  final tr = load('tr'), en = load('en');
  Iterable<String> keys(Map<String, dynamic> m) =>
      m.keys.where((k) => !k.startsWith('@'));
  // ICU: bağımsız değişkenler çift derinlikte açılır (`{tone, select, a{… {n} …}}`).
  Set<String> args(String s) {
    final out = <String>{};
    var depth = 0;
    for (var i = 0; i < s.length; i++) {
      if (s[i] == '{') {
        if (depth.isEven) {
          final m = RegExp(r'\w+').matchAsPrefix(s, i + 1);
          if (m != null) out.add(m.group(0)!);
        }
        depth++;
      } else if (s[i] == '}') {
        depth--;
      }
    }
    return out;
  }

  test('TR ve EN aynı anahtarları taşır', () {
    expect(keys(en).toSet(), keys(tr).toSet());
  });

  test('yer tutucular iki dilde aynı', () {
    for (final k in keys(tr)) {
      expect(args(en[k] as String), args(tr[k] as String), reason: k);
    }
  });

  test('tonlu metinler beş tonun hepsini iki dilde de taşır (D55)', () {
    final tones = {for (final t in AppTheme.values) t.tone};
    final toned = keys(tr)
        .where((k) => (tr[k] as String).contains('{tone, select'));
    expect(toned, isNotEmpty);
    for (final k in toned) {
      for (final m in [tr, en]) {
        final s = m[k] as String;
        expect(s, contains('{tone, select'), reason: k);
        for (final t in tones.where((t) => t != 'serious')) {
          expect(s, contains('$t{'), reason: '$k: $t dalı yok');
        }
        expect(s, contains('other{'), reason: '$k: nötr dal yok');
      }
    }
  });

  test('Eğlenceli tema metinleri çocuklara yönelik görünmez (13+)', () {
    final child = RegExp(r'çocuk|kid|child', caseSensitive: false);
    for (final m in [tr, en]) {
      for (final k in keys(m).where((k) => k.startsWith('theme'))) {
        expect(child.hasMatch(m[k] as String), isFalse, reason: k);
      }
      for (final k in keys(m)) {
        final playful = RegExp(r'playful\{([^}]*)\}')
            .firstMatch(m[k] as String);
        if (playful != null) {
          expect(child.hasMatch(playful.group(1)!), isFalse, reason: k);
        }
      }
    }
  });

  test('tarih, saat ve sayı biçimleri dile göre', () async {
    await initializeDateFormatting();
    final trL = await L10n.delegate.load(const Locale('tr'));
    final enL = await L10n.delegate.load(const Locale('en'));
    expect(trL.localeName, 'tr');
    expect(enL.localeName, 'en');
    final d = DateTime(2026, 11, 20, 14, 5);
    expect(DateFormat.yMMMMd('tr').format(d), '20 Kasım 2026');
    expect(DateFormat.yMMMMd('en').format(d), 'November 20, 2026');
    expect(DateFormat.jm('en').format(d), contains('PM'));
    expect(DateFormat.Hm('tr').format(d), '14:05');
    expect(NumberFormat('0.0', 'tr').format(1.5), '1,5');
    expect(NumberFormat('0.0', 'en').format(1.5), '1.5');
  });
}
