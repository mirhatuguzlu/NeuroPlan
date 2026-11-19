// Ortak odak sesli sohbeti için LiveKit erişim token'ı (SOCIAL_SAFETY §4.4).
// Kayıt yok: token'a kayıt/egress yetkisi verilmez; yalnız odaya katılma, ses yayınlama ve dinleme.
import { caller, cors, json } from '../_shared/clients.ts';

const enc = new TextEncoder();
const b64url = (bytes: Uint8Array) =>
  btoa(String.fromCharCode(...bytes)).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');

async function sign(payload: Record<string, unknown>, secret: string): Promise<string> {
  const head = b64url(enc.encode(JSON.stringify({ alg: 'HS256', typ: 'JWT' })));
  const body = b64url(enc.encode(JSON.stringify(payload)));
  const key = await crypto.subtle.importKey('raw', enc.encode(secret), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const sig = new Uint8Array(await crypto.subtle.sign('HMAC', key, enc.encode(`${head}.${body}`)));
  return `${head}.${body}.${b64url(sig)}`;
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: cors });
  const me = await caller(req);
  if (!me) return json({ error: 'unauthorized' }, 401);
  const { cofocus_id } = await req.json().catch(() => ({}));
  if (typeof cofocus_id !== 'string') return json({ error: 'cofocus_id' }, 400);
  // Katılmış katılımcı, ses açık, sosyal uygun: veritabanı karar verir.
  const { data: room, error } = await me.client.rpc('voice_room', { p_id: cofocus_id });
  if (error) return json({ error: error.message }, 400);
  if (!room) return json({ error: 'forbidden' }, 403);
  const url = Deno.env.get('LIVEKIT_URL');
  const apiKey = Deno.env.get('LIVEKIT_API_KEY');
  const secret = Deno.env.get('LIVEKIT_API_SECRET');
  if (!url || !apiKey || !secret) return json({ error: 'voice_not_configured' }, 503);
  const now = Math.floor(Date.now() / 1000);
  const token = await sign({
    iss: apiKey,
    sub: me.user.id,
    nbf: now - 10,
    exp: now + 3 * 3600,
    video: { room, roomJoin: true, canPublish: true, canSubscribe: true, canPublishData: false, canUpdateOwnMetadata: false },
  }, secret);
  return json({ url, token });
});
