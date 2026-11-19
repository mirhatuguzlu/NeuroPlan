// BodyParts3D OBJ dosyalarından mobil beyin modelini üretir (docs/BRAIN_MODEL.md §1).
//   node build_model.mjs <obj klasörü> [regions.json]   → model/brain.glb
// Girdi: BodyParts3D 4.0 partof + isa %99 OBJ arşivlerinden çıkarılan FJ*.obj dosyaları.
// Çıktı düğümleri: region_<key> (üçgen kabuk), points_<key> (nöron aday noktaları, bölge
// hacminin içinde), lines_boundaries (lob sınırları). Ham OBJ repoya girmez.
import fs from 'node:fs';
import path from 'node:path';
import { Document, NodeIO } from '@gltf-transform/core';
import { EXTMeshoptCompression, KHRMeshQuantization } from '@gltf-transform/extensions';
import { meshopt } from '@gltf-transform/functions';
import { MeshoptEncoder, MeshoptSimplifier } from 'meshoptimizer';

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/(\w:)/, '$1'));
const objDir = process.argv[2];
if (!objDir) throw new Error('kullanım: node build_model.mjs <obj klasörü>');
const { regions } = JSON.parse(fs.readFileSync(process.argv[3] ?? path.join(here, 'regions.json'), 'utf8'));

const TRI_BUDGET = 60000; // toplam üçgen
const MIN_TRIS = 400;
const POOL = 1500; // bölge başına nöron aday noktası (iç yapılarda yarısı)
const BOUNDARY_EPS = 0.03; // ≈ 2,5 mm: komşu lob kabuklarının arasındaki boşluk
const INNER = new Set(['corpus_callosum', 'cingulate', 'insula', 'striatum', 'hippocampus', 'amygdala']);

// Deterministik örnekleme için (model sabit; kullanıcıya özel tohum sahnede uygulanır).
function mulberry32(a) {
  return () => {
    a |= 0; a = (a + 0x6d2b79f5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

// OBJ: yalnız v ve f. BodyParts3D ekseni (x sol+, y arka+, z yukarı, mm) → three (x, z, -y).
function readObj(file) {
  const pos = [];
  const idx = [];
  for (const line of fs.readFileSync(file, 'utf8').split('\n')) {
    if (line.startsWith('v ')) {
      const [, x, y, z] = line.trim().split(/\s+/).map(Number);
      pos.push(x, z, -y);
    } else if (line.startsWith('f ')) {
      const f = line.trim().split(/\s+/).slice(1).map((t) => parseInt(t, 10) - 1);
      for (let i = 1; i + 1 < f.length; i++) idx.push(f[0], f[i], f[i + 1]);
    }
  }
  return { pos, idx };
}

// "FJ1793?L": hangi yarıda olduğu adda yok; x işaretine göre doğrulanır (sol = +x).
function loadRegion(key, ids) {
  const pos = [];
  const idx = [];
  for (const raw of ids) {
    const [id, side] = raw.split('?');
    const file = path.join(objDir, `${id}.obj`);
    if (!fs.existsSync(file)) throw new Error(`${key}: ${file} yok`);
    const m = readObj(file);
    if (side) {
      let sx = 0;
      for (let i = 0; i < m.pos.length; i += 3) sx += m.pos[i];
      if ((sx > 0) !== (side === 'L')) throw new Error(`${key}: ${id} beklenen yarıda değil`);
    }
    const base = pos.length / 3;
    pos.push(...m.pos);
    for (const i of m.idx) idx.push(i + base);
  }
  return weld(new Float32Array(pos), new Uint32Array(idx));
}

// Aynı konumdaki köşeleri birleştirir (OBJ parçaları ve normal ayrımı yüzünden çoğalırlar).
function weld(pos, idx) {
  const map = new Map();
  const remap = new Uint32Array(pos.length / 3);
  const out = [];
  for (let i = 0; i < remap.length; i++) {
    const k = `${pos[3 * i].toFixed(2)},${pos[3 * i + 1].toFixed(2)},${pos[3 * i + 2].toFixed(2)}`;
    let j = map.get(k);
    if (j === undefined) {
      j = out.length / 3;
      map.set(k, j);
      out.push(pos[3 * i], pos[3 * i + 1], pos[3 * i + 2]);
    }
    remap[i] = j;
  }
  const tris = [];
  for (let t = 0; t < idx.length; t += 3) {
    const a = remap[idx[t]], b = remap[idx[t + 1]], c = remap[idx[t + 2]];
    if (a !== b && b !== c && a !== c) tris.push(a, b, c);
  }
  return { pos: new Float32Array(out), idx: new Uint32Array(tris) };
}

function compact(pos, idx) {
  const remap = new Map();
  const out = [];
  const tris = new Uint32Array(idx.length);
  for (let i = 0; i < idx.length; i++) {
    let j = remap.get(idx[i]);
    if (j === undefined) {
      j = out.length / 3;
      remap.set(idx[i], j);
      out.push(pos[3 * idx[i]], pos[3 * idx[i] + 1], pos[3 * idx[i] + 2]);
    }
    tris[i] = j;
  }
  return { pos: new Float32Array(out), idx: tris };
}

function bounds(pos) {
  const min = [Infinity, Infinity, Infinity];
  const max = [-Infinity, -Infinity, -Infinity];
  for (let i = 0; i < pos.length; i += 3) {
    for (let a = 0; a < 3; a++) {
      min[a] = Math.min(min[a], pos[i + a]);
      max[a] = Math.max(max[a], pos[i + a]);
    }
  }
  return { min, max };
}

// Işın paritesi: +x ve +y yönündeki ışınların ikisi de tek sayıda üçgen kesiyorsa nokta
// içeridedir (delikli parçalarda tek eksen yanılabilir). Üçgenler 2B ızgarada tutulur.
function insideTester(pos, idx) {
  const b = bounds(pos);
  const N = 24;
  const grids = [
    [1, 2, 0], // x ışını: (y, z) ızgarası
    [0, 2, 1], // y ışını: (x, z) ızgarası
  ].map(([u, v, w]) => {
    const cells = Array.from({ length: N * N }, () => []);
    const cu = (b.max[u] - b.min[u]) / N || 1;
    const cv = (b.max[v] - b.min[v]) / N || 1;
    const cell = (val, a, c) => Math.min(N - 1, Math.max(0, Math.floor((val - b.min[a]) / c)));
    for (let t = 0; t < idx.length; t += 3) {
      const p = [idx[t], idx[t + 1], idx[t + 2]];
      const us = p.map((i) => pos[3 * i + u]);
      const vs = p.map((i) => pos[3 * i + v]);
      for (let i = cell(Math.min(...us), u, cu); i <= cell(Math.max(...us), u, cu); i++) {
        for (let j = cell(Math.min(...vs), v, cv); j <= cell(Math.max(...vs), v, cv); j++) cells[i * N + j].push(t);
      }
    }
    return (q) => {
      const list = cells[cell(q[u], u, cu) * N + cell(q[v], v, cv)];
      let hits = 0;
      for (const t of list) {
        const [i0, i1, i2] = [idx[t], idx[t + 1], idx[t + 2]];
        const ax = pos[3 * i0 + u], ay = pos[3 * i0 + v];
        const bx = pos[3 * i1 + u], by = pos[3 * i1 + v];
        const cx = pos[3 * i2 + u], cy = pos[3 * i2 + v];
        const d = (by - cy) * (ax - cx) + (cx - bx) * (ay - cy);
        if (d === 0) continue;
        const l1 = ((by - cy) * (q[u] - cx) + (cx - bx) * (q[v] - cy)) / d;
        const l2 = ((cy - ay) * (q[u] - cx) + (ax - cx) * (q[v] - cy)) / d;
        const l3 = 1 - l1 - l2;
        if (l1 < 0 || l2 < 0 || l3 < 0) continue;
        const depth = l1 * pos[3 * i0 + w] + l2 * pos[3 * i1 + w] + l3 * pos[3 * i2 + w];
        if (depth > q[w]) hits++;
      }
      return hits % 2 === 1;
    };
  });
  return { b, inside: (q) => grids.every((g) => g(q)) };
}

function samplePool(key, mesh, count) {
  const { b, inside } = insideTester(mesh.pos, mesh.idx);
  const rnd = mulberry32([...key].reduce((h, c) => Math.imul(h ^ c.charCodeAt(0), 16777619), 2166136261));
  const out = [];
  for (let tries = 0; out.length < count * 3 && tries < count * 400; tries++) {
    const q = [0, 1, 2].map((a) => b.min[a] + rnd() * (b.max[a] - b.min[a]));
    if (inside(q)) out.push(...q);
  }
  if (out.length < count * 3) console.warn(`${key}: ${out.length / 3}/${count} iç nokta`);
  return new Float32Array(out);
}

function vertexNormals(pos, idx) {
  const n = new Float32Array(pos.length);
  for (let t = 0; t < idx.length; t += 3) {
    const [a, b, c] = [idx[t], idx[t + 1], idx[t + 2]];
    const e1 = [0, 1, 2].map((k) => pos[3 * b + k] - pos[3 * a + k]);
    const e2 = [0, 1, 2].map((k) => pos[3 * c + k] - pos[3 * a + k]);
    const f = [e1[1] * e2[2] - e1[2] * e2[1], e1[2] * e2[0] - e1[0] * e2[2], e1[0] * e2[1] - e1[1] * e2[0]];
    for (const v of [a, b, c]) for (let k = 0; k < 3; k++) n[3 * v + k] += f[k];
  }
  return n;
}

// Lob sınırı: bir kabuk bölgesinin, başka bir kabuk bölgesine eps'ten yakın ve dışa bakan
// köşelerini birleştiren kenarları.
function boundaryLines(meshes, eps) {
  const cellOf = (x, y, z) => `${Math.floor(x / eps)},${Math.floor(y / eps)},${Math.floor(z / eps)}`;
  const owner = new Map();
  for (const [key, m] of meshes) {
    for (let i = 0; i < m.pos.length; i += 3) {
      const c = cellOf(m.pos[i], m.pos[i + 1], m.pos[i + 2]);
      let s = owner.get(c);
      if (!s) owner.set(c, (s = []));
      s.push([key, m.pos[i], m.pos[i + 1], m.pos[i + 2]]);
    }
  }
  const near = (key, x, y, z) => {
    const [cx, cy, cz] = [x, y, z].map((v) => Math.floor(v / eps));
    for (let dx = -1; dx <= 1; dx++) for (let dy = -1; dy <= 1; dy++) for (let dz = -1; dz <= 1; dz++) {
      for (const [k, px, py, pz] of owner.get(`${cx + dx},${cy + dy},${cz + dz}`) ?? []) {
        if (k !== key && (px - x) ** 2 + (py - y) ** 2 + (pz - z) ** 2 < eps * eps) return true;
      }
    }
    return false;
  };
  const lines = [];
  for (const [key, m] of meshes) {
    const n = vertexNormals(m.pos, m.idx);
    const ok = new Uint8Array(m.pos.length / 3);
    for (let v = 0; v < ok.length; v++) {
      const [x, y, z] = [m.pos[3 * v], m.pos[3 * v + 1], m.pos[3 * v + 2]];
      const out = n[3 * v] * x + n[3 * v + 1] * y + n[3 * v + 2] * z > 0; // merkez başlangıçta
      ok[v] = out && near(key, x, y, z) ? 1 : 0;
    }
    const seen = new Set();
    for (let t = 0; t < m.idx.length; t += 3) {
      for (const [a, b] of [[0, 1], [1, 2], [2, 0]]) {
        const i = m.idx[t + a], j = m.idx[t + b];
        const e = i < j ? `${i},${j}` : `${j},${i}`;
        if (ok[i] && ok[j] && !seen.has(e)) {
          seen.add(e);
          lines.push(m.pos[3 * i], m.pos[3 * i + 1], m.pos[3 * i + 2], m.pos[3 * j], m.pos[3 * j + 1], m.pos[3 * j + 2]);
        }
      }
    }
  }
  return new Float32Array(lines);
}

await MeshoptSimplifier.ready;
await MeshoptEncoder.ready;

const raw = new Map(Object.entries(regions).map(([k, ids]) => [k, loadRegion(k, ids)]));

// Ortak merkez ve ölçek: bütün beyin [-1, 1] küpüne sığar.
const all = bounds(new Float32Array([...raw.values()].flatMap((m) => [...bounds(m.pos).min, ...bounds(m.pos).max])));
const center = [0, 1, 2].map((a) => (all.min[a] + all.max[a]) / 2);
const scale = 1 / Math.max(...[0, 1, 2].map((a) => (all.max[a] - all.min[a]) / 2));
for (const m of raw.values()) {
  for (let i = 0; i < m.pos.length; i += 3) for (let a = 0; a < 3; a++) m.pos[i + a] = (m.pos[i + a] - center[a]) * scale;
}

// Bütçe üçgen sayısının 0,7 kuvvetiyle paylaştırılır: çok ayrıntılı beyincik ve beyin sapı
// kabuğun gözle görülen kısımlarından pay çalmasın.
const share = (m) => (m.idx.length / 3) ** 0.7;
const totalShare = [...raw.values()].reduce((s, m) => s + share(m), 0);
const simplified = new Map();
const pools = new Map();
for (const [key, m] of raw) {
  const target = Math.max(MIN_TRIS, Math.round((TRI_BUDGET * share(m)) / totalShare));
  const [idx] = MeshoptSimplifier.simplify(m.idx, m.pos, 3, Math.min(m.idx.length, target * 3), 0.01, []);
  simplified.set(key, compact(m.pos, idx));
  pools.set(key, samplePool(key, m, INNER.has(key) ? POOL / 2 : POOL));
  console.log(`${key.padEnd(17)} ${m.idx.length / 3} → ${idx.length / 3} üçgen, ${pools.get(key).length / 3} nokta`);
}
const shells = [...simplified].filter(([k]) => !INNER.has(k) && k !== 'brainstem' && k !== 'cerebellum');
const lines = boundaryLines(shells, BOUNDARY_EPS);
console.log(`sınır çizgisi: ${lines.length / 6} kenar`);

const doc = new Document();
const buffer = doc.createBuffer();
const scene = doc.createScene('brain');
const material = doc.createMaterial('shell');
const add = (name, mode, pos, idx) => {
  const prim = doc.createPrimitive().setMode(mode).setMaterial(material)
    .setAttribute('POSITION', doc.createAccessor().setType('VEC3').setArray(pos).setBuffer(buffer));
  if (idx) prim.setIndices(doc.createAccessor().setType('SCALAR').setArray(idx).setBuffer(buffer));
  scene.addChild(doc.createNode(name).setMesh(doc.createMesh(name).addPrimitive(prim)));
};
for (const [key, m] of simplified) add(`region_${key}`, 4, m.pos, m.idx);
for (const [key, p] of pools) add(`points_${key}`, 0, p);
add('lines_boundaries', 1, lines);
scene.setExtras({ inner: [...INNER], source: 'BodyParts3D 4.0, DBCLS, CC BY 4.0' });

doc.createExtension(EXTMeshoptCompression).setRequired(true);
doc.createExtension(KHRMeshQuantization).setRequired(true);
await doc.transform(meshopt({ encoder: MeshoptEncoder, level: 'medium' }));

const io = new NodeIO().registerExtensions([EXTMeshoptCompression, KHRMeshQuantization]).registerDependencies({ 'meshopt.encoder': MeshoptEncoder });
fs.mkdirSync(path.join(here, 'model'), { recursive: true });
const glb = await io.writeBinary(doc);
fs.writeFileSync(path.join(here, 'model', 'brain.glb'), glb);
console.log(`model/brain.glb ${(glb.length / 1024).toFixed(0)} KB, ${[...simplified.values()].reduce((s, m) => s + m.idx.length / 3, 0)} üçgen`);
