import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';

import '../local/app_database.dart';
import 'sync_engine.dart';

/// Eşitlemenin tetikleri (ARCHITECTURE §5): yazmadan 2 sn sonra, açılışta, ön plana
/// dönüşte, ön plandayken 5 dk'da bir. Hata olursa üstel bekleme (5 sn … 15 dk).
class SyncScheduler with WidgetsBindingObserver {
  SyncScheduler(this._db, this._engine, {required this.userId});

  final AppDatabase _db;
  final SyncEngine _engine;

  /// Oturum yoksa null döner; o zaman eşitleme yapılmaz.
  final String? Function() userId;

  static const debounce = Duration(seconds: 2);
  static const period = Duration(minutes: 5);
  static const minBackoff = Duration(seconds: 5);
  static const maxBackoff = Duration(minutes: 15);

  StreamSubscription<int>? _outbox;
  Timer? _debounce;
  Timer? _periodic;
  Timer? _retry;
  Duration _backoff = Duration.zero;
  Future<void>? _running;
  var _again = false;

  void start() {
    WidgetsBinding.instance.addObserver(this);
    final count = _db.syncOutbox.seq.count();
    _outbox =
        (_db.selectOnly(_db.syncOutbox)
              ..addColumns([count])
              ..where(_db.syncOutbox.dead.equals(false)))
            .map((r) => r.read(count) ?? 0)
            .watchSingle()
            .listen((n) {
              if (n > 0) _schedule(debounce);
            });
    _periodic = Timer.periodic(period, (_) => syncNow());
    unawaited(syncNow());
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _outbox?.cancel();
    _debounce?.cancel();
    _periodic?.cancel();
    _retry?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(syncNow());
  }

  void _schedule(Duration after) {
    _debounce?.cancel();
    _debounce = Timer(after, () => unawaited(syncNow()));
  }

  /// Aynı anda tek eşitleme; çalışırken gelen istek bir tur daha yaptırır.
  Future<void> syncNow() {
    if (_running != null) {
      _again = true;
      return _running!;
    }
    return _running = _loop().whenComplete(() => _running = null);
  }

  Future<void> _loop() async {
    do {
      _again = false;
      final uid = userId();
      if (uid == null) return;
      try {
        await _engine.adoptUser(uid);
        await _engine.syncOnce();
        _backoff = Duration.zero;
        _retry?.cancel();
      } on Object catch (e) {
        debugPrint('[sync] $e');
        _backoff = nextBackoff(_backoff);
        _retry?.cancel();
        _retry = Timer(_backoff, () => unawaited(syncNow()));
        return;
      }
    } while (_again);
  }

  static Duration nextBackoff(Duration current) => current == Duration.zero
      ? minBackoff
      : Duration(
          milliseconds: min(
            current.inMilliseconds * 2,
            maxBackoff.inMilliseconds,
          ),
        );
}
