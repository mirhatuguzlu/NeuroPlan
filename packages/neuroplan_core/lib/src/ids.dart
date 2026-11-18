import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Deterministik kimliklerin ad alanı. Değişirse eski oluşumlar çoğalır; değiştirme.
const neuroplanNamespace = 'b3c1f6d2-5a4e-4f7b-9c8d-2e6a1f0b7c94';

/// Yeni satır kimliği (UUIDv7, zaman sıralı).
String newId() => _uuid.v7();

/// Kural oluşumunun kimliği: iki cihaz aynı oluşumu çevrimdışı üretse de
/// sunucuda tek satır olur (docs/DB_SCHEMA.md §3.8).
String ruleInstanceId(String ruleId, String occurrenceDate) =>
    _uuid.v5(neuroplanNamespace, 'rule:$ruleId:$occurrenceDate');

/// "Dönem başına N kez" oluşumunun kimliği: dönemin ilk günü + sıra (DB_SCHEMA §3.8).
String perPeriodInstanceId(String ruleId, String periodStart, int index) =>
    _uuid.v5(neuroplanNamespace, 'period:$ruleId:$periodStart:$index');
