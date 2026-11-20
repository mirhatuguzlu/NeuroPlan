import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/env.dart';

enum AccountKind { none, guest, google }

/// Google bağlanırken sonuç: aynı kullanıcı kalıcı oldu ya da var olan hesaba geçildi.
enum ConnectResult { linked, switched, cancelled }

/// Giriş (D17): misafir = Supabase anonim kullanıcısı; Google bağlanınca aynı kullanıcı
/// kalıcı olur (`linkIdentity`). Google hesabı başka bir kullanıcıya bağlıysa o hesaba
/// geçilir; yerel veri yeni kullanıcıya gönderilir (SyncEngine.adoptUser).
class AuthService {
  AuthService(this._client);

  /// null: `.env` yok, uygulama yalnız cihazda çalışır.
  final SupabaseClient? _client;

  /// `GoogleSignIn.initialize` uygulama ömründe bir kez çağrılır.
  static Future<void>? _googleReady;

  bool get available => _client != null;
  User? get user => _client?.auth.currentUser;

  AccountKind get kind => switch (user) {
    null => AccountKind.none,
    final u when u.isAnonymous => AccountKind.guest,
    _ => AccountKind.google,
  };

  Stream<User?> get changes =>
      _client?.auth.onAuthStateChange.map((e) => e.session?.user) ??
      const Stream.empty();

  /// Oturum yoksa misafir oturumu açar; ağ yoksa ya da kapalıysa sessizce geçer.
  Future<void> ensureGuest() async {
    final c = _client;
    if (c == null || c.auth.currentSession != null) return;
    try {
      await c.auth.signInAnonymously();
    } on Object catch (e) {
      debugPrint('[auth] misafir oturumu açılamadı: $e');
    }
  }

  Future<ConnectResult> connectGoogle() async {
    final c = _client!;
    final google = GoogleSignIn.instance;
    await (_googleReady ??= google.initialize(
      serverClientId: Env.googleWebClientId,
    ));
    final GoogleSignInAccount account;
    try {
      account = await google.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return ConnectResult.cancelled;
      }
      rethrow;
    }
    final idToken = account.authentication.idToken!;
    if (c.auth.currentUser?.isAnonymous ?? false) {
      try {
        await c.auth.linkIdentityWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
        );
        return ConnectResult.linked;
      } on AuthException catch (e) {
        if (e.code != 'identity_already_exists') rethrow;
      }
    }
    final guestToken = (c.auth.currentUser?.isAnonymous ?? false)
        ? c.auth.currentSession?.accessToken
        : null;
    await c.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
    );
    // Misafirin verisi cihazdan yeni kullanıcıya gönderilir (SyncEngine.adoptUser); sunucudaki
    // eski misafir hesabı artık sahipsiz kalır ve kendi (henüz geçerli) belirteciyle silinir.
    if (guestToken != null) {
      unawaited(
        c.functions
            .invoke(
              'delete_account',
              headers: {'Authorization': 'Bearer $guestToken'},
            )
            .then<void>(
              (_) {},
              onError: (Object e) =>
                  debugPrint('[auth] eski misafir silinemedi: $e'),
            ),
      );
    }
    return ConnectResult.switched;
  }

  /// `delete_account` Edge Function'ı auth kullanıcısını siler; tablolar cascade ile gider.
  Future<void> deleteAccount() async {
    final c = _client!;
    await c.functions.invoke('delete_account');
    await c.auth.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } on Object {
      // Google oturumu hiç açılmamış olabilir.
    }
  }
}
