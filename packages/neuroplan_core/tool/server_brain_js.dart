// Sunucu beyin hesabının JS girişi: `dart compile js` → supabase/functions/brain_snapshot.
// Edge Function `globalThis.neuroplanServerBrain(json)` çağırır (docs/ARCHITECTURE.md §7).
import 'dart:convert';
import 'dart:js_interop';

import 'package:neuroplan_core/neuroplan_core.dart';

@JS('neuroplanServerBrain')
external set _export(JSFunction f);

void main() {
  _export = ((JSString input) => jsonEncode(
    serverBrain((jsonDecode(input.toDart) as Map).cast<String, Object?>()),
  ).toJS).toJS;
}
