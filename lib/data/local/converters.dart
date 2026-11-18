import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

/// Eşitleme yamaları ve sunucu satırları için JSON biçimi: zaman damgaları ISO metin.
const syncSerializer = ValueSerializer.defaults(
  serializeDateTimeValuesAsString: true,
);

/// Sunucudaki jsonb sütunları yerelde TEXT; JSON'a nesne olarak çıkar (metin değil).
class RecurrenceConverter extends TypeConverter<Recurrence, String>
    with JsonTypeConverter2<Recurrence, String, Map<String, Object?>> {
  const RecurrenceConverter();

  @override
  Recurrence fromSql(String fromDb) =>
      Recurrence.fromJson(jsonDecode(fromDb) as Map<String, Object?>);

  @override
  String toSql(Recurrence value) => jsonEncode(value.toJson());

  @override
  Recurrence fromJson(Map<String, Object?> json) => Recurrence.fromJson(json);

  @override
  Map<String, Object?> toJson(Recurrence value) => value.toJson();
}

class TimingConverter extends TypeConverter<Timing, String>
    with JsonTypeConverter2<Timing, String, Map<String, Object?>> {
  const TimingConverter();

  @override
  Timing fromSql(String fromDb) =>
      Timing.fromJson(jsonDecode(fromDb) as Map<String, Object?>);

  @override
  String toSql(Timing value) => jsonEncode(value.toJson());

  @override
  Timing fromJson(Map<String, Object?> json) => Timing.fromJson(json);

  @override
  Map<String, Object?> toJson(Timing value) => value.toJson();
}

/// Ham JSON değeri (nesne ya da dizi): ayarlar, segmentler, tercih edilen pencereler.
/// shortcut: tipsiz tutuluyor; motor aşamasında core'da tipli modele çevrilir.
class JsonValueConverter<T extends Object> extends TypeConverter<T, String>
    with JsonTypeConverter2<T, String, Object?> {
  const JsonValueConverter();

  @override
  T fromSql(String fromDb) => jsonDecode(fromDb) as T;

  @override
  String toSql(T value) => jsonEncode(value);

  @override
  T fromJson(Object? json) => json as T;

  @override
  Object? toJson(T value) => value;
}

/// `date[]` / `text[]` sütunları.
class StringListConverter extends TypeConverter<List<String>, String>
    with JsonTypeConverter2<List<String>, String, Object?> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) => fromJson(jsonDecode(fromDb));

  @override
  String toSql(List<String> value) => jsonEncode(value);

  @override
  List<String> fromJson(Object? json) => [
    for (final e in json as List) e as String,
  ];

  @override
  Object? toJson(List<String> value) => value;
}

/// Sütun → HLC (alan bazlı son yazan kazanır).
class FieldVersionsConverter extends TypeConverter<Map<String, String>, String>
    with JsonTypeConverter2<Map<String, String>, String, Object?> {
  const FieldVersionsConverter();

  @override
  Map<String, String> fromSql(String fromDb) => fromJson(jsonDecode(fromDb));

  @override
  String toSql(Map<String, String> value) => jsonEncode(value);

  @override
  Map<String, String> fromJson(Object? json) =>
      json == null ? {} : (json as Map).cast<String, String>();

  @override
  Object? toJson(Map<String, String> value) => value;
}
