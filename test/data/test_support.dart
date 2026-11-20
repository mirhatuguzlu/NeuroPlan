import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/data/sync/hlc_clock.dart';
import 'package:neuroplan/data/sync/local_writer.dart';
import 'package:neuroplan/data/sync/sync_engine.dart';
import 'package:neuroplan_core/neuroplan_core.dart';

/// Sistem verisi. Ana bilgisayarda dosyadan; cihazda (integration_test) dosya sistemi yoktur,
/// orada test başında [useSystemJson] ile varlık paketinden verilir.
SystemData get systemData => _system ??= SystemData.fromJson(
  jsonDecode(File('assets/seed/system.json').readAsStringSync())
      as Map<String, Object?>,
);
SystemData? _system;

void useSystemJson(String json) =>
    _system = SystemData.fromJson(jsonDecode(json) as Map<String, Object?>);

/// Bellek içi veritabanı + saat + yazıcı; [now] verilirse HLC saati sabitlenir.
class TestDevice {
  TestDevice({SyncRemote? remote, int Function()? now})
    : db = AppDatabase(NativeDatabase.memory(), systemData: systemData) {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    clock = HlcClock(db, now: now);
    writer = LocalWriter(db, clock);
    if (remote != null) sync = SyncEngine(db, remote, clock);
  }

  final AppDatabase db;
  late final HlcClock clock;
  late final LocalWriter writer;
  late final SyncEngine sync;

  Future<List<OutboxEntry>> outbox() => db.select(db.syncOutbox).get();
}

/// Sunucudaki sync_push / sync_pull'ün bellek içi karşılığı: aynı alan bazlı LWW kuralı
/// (packages/neuroplan_core mergeFields), kullanıcı başına tek sürüm sayacı.
class FakeServer implements SyncRemote {
  int _counter = 0;
  final rows = <String, Map<String, Map<String, Object?>>>{};

  /// Doluysa o sıradaki değişiklik bu kodla reddedilir.
  final rejectCodes = <int, String>{};
  bool offline = false;

  @override
  Future<List<PushRejection>> push(List<Map<String, Object?>> changes) async {
    if (offline) throw const SocketException('çevrimdışı');
    final rejected = <PushRejection>[];
    for (final (i, c) in changes.indexed) {
      if (rejectCodes[i] case final code?) {
        rejected.add(PushRejection(i, code, 'reddedildi'));
        continue;
      }
      final table = rows.putIfAbsent(c['table'] as String, () => {});
      final id = c['id'] as String;
      final hlc = c['hlc'] as String;
      final patch = Map<String, Object?>.of(c['patch'] as Map<String, Object?>);
      final incoming = {
        for (final k in patch.keys)
          if (k != 'created_at') k: hlc,
      };
      final existing = table[id];
      final Map<String, Object?> next;
      if (existing == null) {
        next = {...patch, 'id': id, 'field_versions': incoming};
      } else {
        patch.remove('created_at');
        final local = Map<String, Object?>.of(existing);
        final versions = (local.remove('field_versions') as Map)
            .cast<String, String>();
        final m = mergeFields(
          local: local,
          localVersions: versions,
          remote: patch,
          remoteVersions: incoming,
        );
        next = {...m.values, 'field_versions': m.versions};
      }
      table[id] = next
        ..['user_id'] = 'sunucu-kullanicisi'
        ..['version'] = ++_counter
        ..['updated_at'] = DateTime.now().toUtc().toIso8601String();
    }
    return rejected;
  }

  @override
  Future<PullPage> pull(int cursor) async {
    if (offline) throw const SocketException('çevrimdışı');
    return PullPage(_counter, {
      for (final MapEntry(:key, :value) in rows.entries)
        key: [
          for (final r in value.values)
            if ((r['version'] as int) > cursor) Map.of(r),
        ],
    });
  }
}
