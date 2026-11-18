import '../local/app_database.dart';
import '../sync/local_writer.dart';

/// Kullanıcı profili (docs/DB_SCHEMA.md §3.1); yerelde tek satır.
class ProfileRepository {
  ProfileRepository(this._db, this._writer);

  final AppDatabase _db;
  final LocalWriter _writer;

  Stream<Profile?> watch() => (_db.select(
    _db.profiles,
  )..where((p) => p.id.equals(localProfileId))).watchSingleOrNull();

  Future<Profile?> get() => _writer.find(_db.profiles, localProfileId);

  /// İlk açılışta profili cihazın saat dilimiyle oluşturur; varsa olduğu gibi döner.
  Future<Profile> ensure({required String timezone}) async =>
      await get() ??
      await _writer.insert(
        _db.profiles,
        ProfilesCompanion.insert(id: localProfileId, timezone: timezone),
      );

  Future<Profile> update(ProfilesCompanion changes) =>
      _writer.update(_db.profiles, localProfileId, changes);
}
