// Hesabı ve tüm verileri kalıcı siler (AUTH-3, DB_SCHEMA §6.3). Tablolar auth.users'a
// ON DELETE CASCADE ile bağlı; şikâyetlerde reported_user_id null olur, kayıt moderasyon için kalır.
import { admin, caller, cors, json } from '../_shared/clients.ts';

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });
  const me = await caller(req);
  if (!me) return json({ error: 'unauthorized' }, 401);
  const { error } = await admin().auth.admin.deleteUser(me.user.id);
  if (error) return json({ error: error.message }, 500);
  return json({ deleted: true });
});
