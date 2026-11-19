// Sahnenin saf yardımcıları: köprü mesajları, tohumlu rastgelelik, nöron yerleşimi.
// Node testleri (test/) bunları doğrudan çalıştırır; three.js'e bağlı değildir.

export const BRIDGE_VERSION = 1;
export const SCENE_VERSION = 1;

/** Flutter → JS mesaj türleri (docs/ARCHITECTURE.md §8). */
export const INBOUND = new Set(['init', 'state', 'highlight', 'event', 'quality', 'visibility', 'reset']);

/** `{"v":1,"type":...,"payload":...}` çözer; bilinmeyen sürüm/tür `{error}` döner. */
export function parseMessage(text) {
  let m;
  try {
    m = typeof text === 'string' ? JSON.parse(text) : text;
  } catch {
    return { error: 'json' };
  }
  if (!m || m.v !== BRIDGE_VERSION) return { error: 'version' };
  if (!INBOUND.has(m.type)) return { error: `type:${m.type}` };
  return { type: m.type, payload: m.payload ?? {} };
}

export function encodeMessage(type, payload = {}) {
  return JSON.stringify({ v: BRIDGE_VERSION, type, payload });
}

/** FNV-1a, 32 bit. */
export function hashString(s) {
  let h = 2166136261;
  for (let i = 0; i < s.length; i++) h = Math.imul(h ^ s.charCodeAt(i), 16777619);
  return h >>> 0;
}

export function mulberry32(seed) {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

/**
 * Bölgenin ilk [count] nöronunun konumları. Nokta i her zaman aynı yerdedir (akış tohumdan
 * sırayla üretilir): yeni nöron eklenince eskiler kımıldamaz. [pool] modelin bölge hacmi
 * içindeki aday noktalarıdır; küçük bir sapma eklenir.
 */
export function layoutPoints(pool, count, seed, key, jitter = 0.012) {
  const n = pool.length / 3;
  const out = new Float32Array(count * 3);
  if (n === 0) return out;
  const rnd = mulberry32(hashString(`${seed}:${key}`));
  for (let i = 0; i < count; i++) {
    const j = Math.floor(rnd() * n) * 3;
    out[3 * i] = pool[j] + (rnd() - 0.5) * 2 * jitter;
    out[3 * i + 1] = pool[j + 1] + (rnd() - 0.5) * 2 * jitter;
    out[3 * i + 2] = pool[j + 2] + (rnd() - 0.5) * 2 * jitter;
  }
  return out;
}

/** Bağın şerit sayısı: güçlü bağ daha kalın görünür (WebGL'de çizgi kalınlığı 1 px). */
export function strandCount(level) {
  return 1 + Math.min(4, Math.floor(level / 250));
}

export function hexToRgb(hex, fallback = [1, 1, 1]) {
  const m = /^#?([0-9a-f]{6})$/i.exec(hex ?? '');
  if (!m) return fallback;
  const v = parseInt(m[1], 16);
  return [((v >> 16) & 255) / 255, ((v >> 8) & 255) / 255, (v & 255) / 255];
}
