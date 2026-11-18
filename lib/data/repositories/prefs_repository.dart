import '../local/app_database.dart';

/// Cihaza özel, eşitlenmeyen tercihler (bildirim süresi, tam zamanlı bildirim).
/// `sync_state` anahtar-değer tablosunda `pref.` önekiyle tutulur (D27).
class PrefsRepository {
  PrefsRepository(this._db);

  final AppDatabase _db;

  static const notifyLead = 'pref.notify_lead_minutes';
  static const exactAlarms = 'pref.exact_alarms';

  /// Odakta Rahatsız Etmeyin ('1' = açık).
  static const focusDnd = 'pref.focus_dnd';

  /// Son kullanılan Pomodoro / derin çalışma ayarları: `{"pomodoro":{…},"deep":{…}}`.
  static const focusSettings = 'pref.focus_settings';

  /// Süren oturumun cihaza özel durumu: `{"session":id,"pause":"normal"|"emergency"|null,
  /// "guard":{…}}` (D32).
  static const focusRuntime = 'focus.runtime';

  /// Bugün kullanılan acil durum hakkı: `YYYY-MM-DD:n` (D34).
  static const focusEmergency = 'focus.emergency';

  Stream<String?> watch(String key) =>
      (_db.select(_db.syncState)..where((s) => s.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row?.value);

  Future<String?> get(String key) async => (await (_db.select(
    _db.syncState,
  )..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  /// null değer anahtarı siler.
  Future<void> set(String key, String? value) => value == null
      ? (_db.delete(_db.syncState)..where((s) => s.key.equals(key))).go()
      : _db
            .into(_db.syncState)
            .insertOnConflictUpdate(
              SyncStateCompanion.insert(key: key, value: value),
            );
}
