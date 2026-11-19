// Arkadaşın (ya da kendi) beyni, sunucuda oturum kayıtlarından yeniden hesaplanır
// (ARCHITECTURE §7). İstemcinin gönderdiği olaylara güvenilmez; hesap neuroplan_core'un
// `dart compile js` çıktısıdır (server_brain.js, packages/neuroplan_core/tool/server_brain_js.dart).
// shortcut: her istekte yeniden hesaplanır, önbellek yok; oturum sayısı büyüyünce brain_snapshots'a yazılacak.
import './server_brain.js';
import { admin, caller, cors, json } from '../_shared/clients.ts';

declare global {
  // deno-lint-ignore no-var
  var neuroplanServerBrain: (input: string) => string;
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });
  const me = await caller(req);
  if (!me) return json({ error: 'unauthorized' }, 401);
  const { user_id } = await req.json().catch(() => ({}));
  if (typeof user_id !== 'string') return json({ error: 'user_id' }, 400);
  const { data: allowed, error } = await me.client.rpc('can_view_brain', { p_friend: user_id });
  if (error) return json({ error: error.message }, 400);
  if (!allowed) return json({ error: 'forbidden' }, 403);
  const { data: input, error: e2 } = await admin().rpc('brain_input', { p_user: user_id });
  if (e2) return json({ error: e2.message }, 500);
  return new Response(globalThis.neuroplanServerBrain(JSON.stringify(input)), {
    headers: { ...cors, 'Content-Type': 'application/json' },
  });
});
