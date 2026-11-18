import 'dart:math';

import 'package:neuroplan_core/neuroplan_core.dart';

import '../local/app_database.dart';

/// Cihazın HLC'si; son damga `sync_state`'te saklanır, düğüm adı cihaz kimliğidir.
class HlcClock {
  HlcClock(this._db, {int Function()? now})
    : _now = now ?? (() => DateTime.now().millisecondsSinceEpoch);

  final AppDatabase _db;
  final int Function() _now;
  Hlc? _last;

  static const _key = 'hlc';

  /// Yerel yazma için yeni damga.
  Future<Hlc> send() async => _store((await _load()).send(_now()));

  /// Sunucudan gelen damgayı görür; sonraki yerel damgalar ondan büyük olur.
  Future<void> receive(Hlc remote) async =>
      _store((await _load()).receive(remote, _now()));

  Future<Hlc> _load() async {
    if (_last case final last?) return last;
    final saved = await (_db.select(
      _db.syncState,
    )..where((s) => s.key.equals(_key))).getSingleOrNull();
    return _last = saved == null
        ? Hlc.zero(_randomNode())
        : Hlc.parse(saved.value);
  }

  Future<Hlc> _store(Hlc h) async {
    _last = h;
    await _db
        .into(_db.syncState)
        .insertOnConflictUpdate(
          SyncStateCompanion.insert(key: _key, value: h.toString()),
        );
    return h;
  }

  static String _randomNode() {
    final r = Random.secure();
    return List.generate(16, (_) => r.nextInt(16).toRadixString(16)).join();
  }
}
