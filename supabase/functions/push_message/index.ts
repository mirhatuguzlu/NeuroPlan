// Mesaj push bildirimi (D49). Yalnız veritabanı tetikleyicisi çağırır (paylaşılan sır başlıkta).
// Bildirim mesajın metnini içermez; kilit ekranında yalnız "X sana mesaj gönderdi" görünür.
// FCM HTTP v1: servis hesabıyla OAuth erişim belirteci (RS256 JWT, Web Crypto).
import { admin, json } from '../_shared/clients.ts';

type ServiceAccount = { client_email: string; private_key: string; project_id: string };

const enc = new TextEncoder();
const b64url = (bytes: Uint8Array) =>
  btoa(String.fromCharCode(...bytes)).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');

let cached: { token: string; until: number } | null = null;

async function accessToken(sa: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  if (cached && cached.until > now + 60) return cached.token;
  const head = b64url(enc.encode(JSON.stringify({ alg: 'RS256', typ: 'JWT' })));
  const claims = b64url(enc.encode(JSON.stringify({
    iss: sa.client_email,
    scope: 'https://www.googleapis.com/auth/firebase.messaging',
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
  })));
  const pem = sa.private_key.replace(/-----[^-]+-----/g, '').replace(/\s+/g, '');
  const der = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0));
  const key = await crypto.subtle.importKey('pkcs8', der, { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' }, false, ['sign']);
  const sig = new Uint8Array(await crypto.subtle.sign('RSASSA-PKCS1-v1_5', key, enc.encode(`${head}.${claims}`)));
  const res = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: `${head}.${claims}.${b64url(sig)}`,
    }),
  });
  if (!res.ok) throw new Error(`oauth ${res.status}`);
  const body = await res.json();
  cached = { token: body.access_token, until: now + (body.expires_in ?? 3600) };
  return cached.token;
}

const texts: Record<string, { title: string; body: (name: string) => string }> = {
  tr: { title: 'NöroPlan', body: (n) => `${n || 'Bir arkadaşın'} sana mesaj gönderdi` },
  en: { title: 'NeuroPlan', body: (n) => `${n || 'A friend'} sent you a message` },
};

Deno.serve(async (req) => {
  const secret = Deno.env.get('PUSH_WEBHOOK_SECRET');
  if (!secret || req.headers.get('x-webhook-secret') !== secret) return json({ error: 'forbidden' }, 403);
  const raw = Deno.env.get('FIREBASE_SERVICE_ACCOUNT');
  if (!raw) return json({ error: 'push_not_configured' }, 503);
  const sa: ServiceAccount = JSON.parse(raw);
  const { message_id } = await req.json().catch(() => ({}));
  if (typeof message_id !== 'string') return json({ error: 'message_id' }, 400);

  const db = admin();
  const { data: targets, error } = await db.rpc('message_push_targets', { p_message: message_id });
  if (error) return json({ error: error.message }, 500);
  if (!targets?.length) return json({ sent: 0 });

  const token = await accessToken(sa);
  let sent = 0;
  const stale: string[] = [];
  for (const t of targets) {
    const lang = texts[t.locale] ?? texts.tr;
    const res = await fetch(`https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`, {
      method: 'POST',
      headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        message: {
          token: t.token,
          notification: { title: lang.title, body: lang.body(t.sender_name) },
          android: {
            priority: 'high',
            notification: { channel_id: 'together_messages', tag: t.conversation_id },
          },
          data: {
            type: 'message',
            conversation_id: t.conversation_id,
            friend_id: t.sender_id,
            name: t.sender_name,
          },
        },
      }),
    });
    if (res.ok) {
      sent++;
    } else if (res.status === 404 || res.status === 400) {
      // UNREGISTERED / INVALID_ARGUMENT: cihaz uygulamayı kaldırmış ya da kimlik geçersiz.
      stale.push(t.token);
    }
  }
  if (stale.length) await db.from('push_tokens').delete().in('token', stale);
  return json({ sent, removed: stale.length });
});
