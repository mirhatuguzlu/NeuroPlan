import 'package:supabase_flutter/supabase_flutter.dart';

import '../sync/sync_engine.dart';

/// `sync_push` / `sync_pull` RPC'leri (supabase/migrations/20261118120000_sync_core.sql).
class SupabaseSyncRemote implements SyncRemote {
  SupabaseSyncRemote(this._client);

  final SupabaseClient _client;

  @override
  Future<List<PushRejection>> push(List<Map<String, Object?>> changes) async {
    final res =
        await _client.rpc('sync_push', params: {'p_changes': changes}) as Map;
    return [
      for (final r in (res['rejected'] as List).cast<Map>())
        PushRejection(r['index'] as int, r['code'] as String, '${r['error']}'),
    ];
  }

  @override
  Future<PullPage> pull(int cursor) async {
    final res =
        await _client.rpc('sync_pull', params: {'p_cursor': cursor}) as Map;
    return PullPage(res['cursor'] as int, {
      for (final MapEntry(:key, :value)
          in (res['changes'] as Map).cast<String, List>().entries)
        key: value.cast<Map>().map((m) => m.cast<String, Object?>()).toList(),
    }, hasMore: res['has_more'] as bool);
  }
}
