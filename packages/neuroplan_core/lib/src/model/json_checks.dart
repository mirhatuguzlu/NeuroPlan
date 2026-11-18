final _dateRe = RegExp(r'^\d{4}-\d{2}-\d{2}$');
final _uuidRe = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
  caseSensitive: false,
);

/// `YYYY-MM-DD` biçiminde gerçek bir takvim günü mü (2026-02-30 geçersiz).
bool isIsoDate(Object? v) {
  if (v is! String || !_dateRe.hasMatch(v)) return false;
  final d = DateTime.tryParse('${v}T00:00:00Z');
  return d != null && d.toIso8601String().startsWith(v);
}

bool isUuid(Object? v) => v is String && _uuidRe.hasMatch(v);

Never fail(String message) => throw FormatException(message);

void check(bool ok, String message) {
  if (!ok) fail(message);
}

/// JSON listesini tamsayı listesine çevirir; tamsayı olmayan öğede hata verir.
List<int> intList(List<Object?> list, String field) => [
  for (final e in list) e is int ? e : fail('$field tamsayı listesi olmalı'),
];

List<String> stringList(List<Object?> list, String field) => [
  for (final e in list) e is String ? e : fail('$field metin listesi olmalı'),
];
