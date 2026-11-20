import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Kullanıcıya görünen metin yalnız ARB'den gelir (CLAUDE.md kural 8, D57). Bu test
/// arayüz kodunda harf içeren düz dize arar: `Text('…')` ve metin taşıyan parametreler
/// (`tooltip:`, `label:`, `hintText:` …). `${…}` ve `$ad` ara değerleri çıkarıldıktan
/// sonra harf kalıyorsa sabit metin sayılır.
// shortcut: düzenli ifade taraması; birden çok satıra bölünmüş dize ya da yardımcı
// fonksiyonla kurulan metin kaçabilir. Kaçan çıkarsa analyzer eklentisine geçilir.
void main() {
  // Özel adlar ve adresler çevrilmez.
  const allowed = {'Three.js'};
  final call = RegExp(
    r'''(?:\bText|SelectableText|Tooltip|SnackBar)\(\s*(?:'([^'\n]*)'|"([^"\n]*)")''',
  );
  final param = RegExp(
    r'''\b(?:tooltip|label|labelText|hintText|helperText|errorText|semanticLabel|semanticsLabel|message|title|subtitle|text):\s*(?:'([^'\n]*)'|"([^"\n]*)")''',
  );
  final interpolation = RegExp(r'\$\{[^}]*\}|\$[A-Za-z_]\w*');
  final letter = RegExp(r'\p{L}', unicode: true);

  test('arayüz kodunda sabit kullanıcı metni yok', () {
    final hits = <String>[];
    final files = [
      for (final dir in ['lib/ui', 'lib/app'])
        ...Directory(dir)
            .listSync(recursive: true)
            .whereType<File>()
            .where(
              (f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'),
            ),
    ];
    for (final f in files) {
      final lines = f.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        for (final re in [call, param]) {
          for (final m in re.allMatches(line)) {
            final raw = m.group(1) ?? m.group(2)!;
            final text = raw.replaceAll(interpolation, '');
            if (raw.contains('://') || allowed.contains(raw)) continue;
            if (letter.hasMatch(text)) hits.add('${f.path}:${i + 1}: $raw');
          }
        }
        // Boş metin de bir hatadır: ekranda boş satır bırakır.
        if (RegExp(r'''\bText\(\s*(''|"")''').hasMatch(line)) {
          hits.add('${f.path}:${i + 1}: (boş Text)');
        }
      }
    }
    expect(hits, isEmpty, reason: hits.join('\n'));
  });

  test('tarama gerçekten yakalıyor (öz-denetim)', () {
    expect(call.hasMatch("Text('Merhaba')"), isTrue);
    expect(param.hasMatch("tooltip: 'Kapat'"), isTrue);
    expect(
      letter.hasMatch(r"'${l.a} · $b'".replaceAll(interpolation, '')),
      isFalse,
    );
  });
}
