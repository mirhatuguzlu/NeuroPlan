// 3D beyin sahnesi (docs/BRAIN_MODEL.md §4, ARCHITECTURE §8). İş kuralı yoktur: Flutter'ın
// gönderdiği çizim planını çizer, dokunuşu ve fps'i bildirir.
import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { MeshoptDecoder } from 'three/addons/libs/meshopt_decoder.module.js';
import { EffectComposer } from 'three/addons/postprocessing/EffectComposer.js';
import { OutputPass } from 'three/addons/postprocessing/OutputPass.js';
import { RenderPass } from 'three/addons/postprocessing/RenderPass.js';
import { UnrealBloomPass } from 'three/addons/postprocessing/UnrealBloomPass.js';
import glb from '../model/brain.glb';
import { SCENE_VERSION, encodeMessage, hexToRgb, layoutPoints, mulberry32, parseMessage, strandCount } from './core.js';

const post = (type, payload) => {
  const text = encodeMessage(type, payload);
  if (window.NeuroBridge) window.NeuroBridge.postMessage(text);
  else console.log('[bridge]', text);
};
window.addEventListener('error', (e) => post('error', { message: String(e.message ?? e) }));

const HOME = new THREE.Vector3(2.3, 0.7, 2.6);
const QUALITY = {
  low: { pixelRatio: 1, bloom: 0, antialias: false },
  mid: { pixelRatio: 1.5, bloom: 1, antialias: true },
  high: { pixelRatio: 2, bloom: 2, antialias: true },
};

const state = {
  theme: {
    background: '#0b0b14', shell: '#8f8cff', glow: '#b9b6ff', signal: '#ffffff', dim: '#55557a', line: '#8f8cff', penalty: '#ff6b6b',
  },
  rootColors: {},
  reducedMotion: false,
  tier: 'mid',
  seed: 'neuroplan',
  plan: { regions: [], links: [] },
  highlight: null,
  mode: 'overview',
  visible: true,
};

let renderer;
let composer;
let bloomPass;
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(38, 1, 0.05, 30);
camera.position.copy(HOME);
const root = new THREE.Group();
root.rotation.y = 0; // model önden bakar (+z = ön)
scene.add(root);

const regions = new Map(); // key → { mesh, material, pool, center, inner }
let boundaries;
let neurons;
let links;
let pulses;
let controls;
const flashes = new Map(); // key → { until, color }
const linkSegments = []; // [ax, ay, az, bx, by, bz, level]
const activePulses = [];

// ---------------------------------------------------------------- malzemeler

function shellMaterial(inner) {
  return new THREE.ShaderMaterial({
    uniforms: {
      uColor: { value: new THREE.Color(state.theme.shell) },
      uIntensity: { value: 1 },
      uBase: { value: inner ? 0.03 : 0.0 },
      uPower: { value: inner ? 2.0 : 3.2 },
      uGain: { value: inner ? 0.35 : 0.42 },
    },
    vertexShader: /* glsl */ `
      varying vec3 vN; varying vec3 vV;
      void main() {
        vec4 mv = modelViewMatrix * vec4(position, 1.0);
        vN = normalize(normalMatrix * normal);
        vV = normalize(-mv.xyz);
        gl_Position = projectionMatrix * mv;
      }`,
    fragmentShader: /* glsl */ `
      uniform vec3 uColor; uniform float uIntensity; uniform float uBase; uniform float uPower; uniform float uGain;
      varying vec3 vN; varying vec3 vV;
      void main() {
        float f = pow(1.0 - abs(dot(normalize(vN), normalize(vV))), uPower);
        float a = (uBase + f * uGain) * uIntensity;
        gl_FragColor = vec4(uColor * a, a);
      }`,
    transparent: true,
    depthWrite: false,
    side: inner ? THREE.DoubleSide : THREE.FrontSide,
    blending: THREE.AdditiveBlending,
  });
}

const pointMaterial = new THREE.ShaderMaterial({
  uniforms: {
    uPixel: { value: 1 },
    uFocus: { value: -1 },
    uFocusAlpha: { value: 0.12 },
    uTime: { value: 0 },
    uMotion: { value: 1 },
    uBoost: { value: 1 },
  },
  vertexShader: /* glsl */ `
    attribute vec3 color; attribute float aSize; attribute float aRegion;
    uniform float uPixel; uniform float uFocus; uniform float uFocusAlpha; uniform float uTime; uniform float uMotion; uniform float uBoost;
    varying vec3 vColor; varying float vAlpha;
    void main() {
      vec4 mv = modelViewMatrix * vec4(position, 1.0);
      float twinkle = 0.85 + 0.15 * sin(uTime * 1.7 + position.x * 40.0 + position.y * 23.0) * uMotion;
      vColor = color * twinkle * uBoost;
      vAlpha = (uFocus < 0.0 || abs(aRegion - uFocus) < 0.5) ? 1.0 : uFocusAlpha;
      gl_PointSize = aSize * uPixel * (2.2 / -mv.z);
      gl_Position = projectionMatrix * mv;
    }`,
  fragmentShader: /* glsl */ `
    varying vec3 vColor; varying float vAlpha;
    void main() {
      vec2 p = gl_PointCoord - 0.5;
      float d = length(p);
      if (d > 0.5) discard;
      float a = smoothstep(0.5, 0.0, d) * vAlpha;
      gl_FragColor = vec4(vColor * a, a);
    }`,
  transparent: true,
  depthWrite: false,
  blending: THREE.AdditiveBlending,
});

// ---------------------------------------------------------------- model

function floatPositions(mesh) {
  mesh.updateWorldMatrix(true, false);
  const src = mesh.geometry.getAttribute('position');
  const out = new Float32Array(src.count * 3);
  const v = new THREE.Vector3();
  for (let i = 0; i < src.count; i++) {
    v.fromBufferAttribute(src, i).applyMatrix4(mesh.matrixWorld);
    out[3 * i] = v.x;
    out[3 * i + 1] = v.y;
    out[3 * i + 2] = v.z;
  }
  return out;
}

async function loadModel() {
  const loader = new GLTFLoader();
  loader.setMeshoptDecoder(MeshoptDecoder);
  await MeshoptDecoder.ready;
  const gltf = await loader.parseAsync(glb.buffer.slice(glb.byteOffset, glb.byteOffset + glb.byteLength), '');
  const inner = new Set(gltf.scene.userData?.inner ?? []);
  const objects = [];
  gltf.scene.traverse((o) => objects.push(o));
  for (const o of objects) {
    if (!o.isMesh && !o.isPoints && !o.isLineSegments) continue;
    const pos = floatPositions(o);
    if (o.name.startsWith('region_')) {
      const key = o.name.slice(7);
      const geom = new THREE.BufferGeometry();
      geom.setAttribute('position', new THREE.BufferAttribute(pos, 3));
      geom.setIndex(o.geometry.getIndex());
      geom.computeVertexNormals();
      geom.computeBoundingSphere();
      const material = shellMaterial(inner.has(key));
      const mesh = new THREE.Mesh(geom, material);
      mesh.name = key;
      mesh.renderOrder = inner.has(key) ? 1 : 2;
      root.add(mesh);
      const r = regions.get(key) ?? {};
      regions.set(key, { ...r, key, mesh, material, inner: inner.has(key), center: geom.boundingSphere.center.clone(), radius: geom.boundingSphere.radius });
    } else if (o.name.startsWith('points_')) {
      const key = o.name.slice(7);
      regions.set(key, { ...(regions.get(key) ?? {}), pool: pos });
    } else if (o.name === 'lines_boundaries') {
      const geom = new THREE.BufferGeometry();
      geom.setAttribute('position', new THREE.BufferAttribute(pos, 3));
      boundaries = new THREE.LineSegments(
        geom,
        new THREE.LineBasicMaterial({ color: state.theme.line, transparent: true, opacity: 0.32, depthWrite: false, blending: THREE.AdditiveBlending }),
      );
      boundaries.renderOrder = 3;
      root.add(boundaries);
    }
  }
  const keys = [...regions.keys()];
  regions.forEach((r) => (r.index = keys.indexOf(r.key)));

  neurons = new THREE.Points(new THREE.BufferGeometry(), pointMaterial);
  neurons.renderOrder = 4;
  root.add(neurons);
  links = new THREE.LineSegments(
    new THREE.BufferGeometry(),
    new THREE.LineBasicMaterial({ vertexColors: true, transparent: true, depthWrite: false, blending: THREE.AdditiveBlending }),
  );
  links.renderOrder = 5;
  root.add(links);
  pulses = new THREE.Points(new THREE.BufferGeometry(), pointMaterial.clone());
  pulses.renderOrder = 6;
  root.add(pulses);
}

// ---------------------------------------------------------------- çizim planı

function regionColor(r, plan) {
  const hex = plan?.root ? state.rootColors[plan.root] : null;
  return hexToRgb(hex ?? state.theme.glow);
}

function rebuildNeurons() {
  if (!neurons) return;
  const plan = state.plan.regions;
  const total = plan.reduce((s, r) => s + r.points + r.dimPoints, 0);
  const pos = new Float32Array(total * 3);
  const col = new Float32Array(total * 3);
  const size = new Float32Array(total);
  const reg = new Float32Array(total);
  const dim = hexToRgb(state.theme.dim);
  let k = 0;
  for (const p of plan) {
    const r = regions.get(p.key);
    if (!r?.pool) continue;
    const n = p.points + p.dimPoints;
    const xyz = layoutPoints(r.pool, n, state.seed, p.key);
    const [cr, cg, cb] = regionColor(r, p);
    const glow = 0.35 + 0.65 * (p.glow / 1000);
    for (let i = 0; i < n; i++, k++) {
      pos.set(xyz.subarray(3 * i, 3 * i + 3), 3 * k);
      const lit = i < p.points;
      const c = lit ? [cr * glow, cg * glow, cb * glow] : [dim[0] * 0.35, dim[1] * 0.35, dim[2] * 0.35];
      col.set(c, 3 * k);
      size[k] = lit ? 5 + 4 * (p.glow / 1000) : 3.2;
      reg[k] = r.index;
    }
  }
  const g = new THREE.BufferGeometry();
  g.setAttribute('position', new THREE.BufferAttribute(pos.subarray(0, 3 * k), 3));
  g.setAttribute('color', new THREE.BufferAttribute(col.subarray(0, 3 * k), 3));
  g.setAttribute('aSize', new THREE.BufferAttribute(size.subarray(0, k), 1));
  g.setAttribute('aRegion', new THREE.BufferAttribute(reg.subarray(0, k), 1));
  neurons.geometry.dispose();
  neurons.geometry = g;

  // Bölge kabuğunun parlaklığı: büyüdükçe ve parladıkça kenarı daha görünür.
  for (const r of regions.values()) {
    const p = plan.find((x) => x.key === r.key);
    r.glow = p ? p.glow / 1000 : 0;
    r.material.uniforms.uColor.value.setRGB(...regionColor(r, p));
  }
  rebuildLinks();
  applyHighlight();
}

function rebuildLinks() {
  if (!links) return;
  linkSegments.length = 0;
  const signal = hexToRgb(state.theme.signal);
  for (const l of state.plan.links) {
    const a = regions.get(l.a);
    const b = regions.get(l.b);
    if (!a?.pool || !b?.pool) continue;
    const rnd = mulberry32(([...`${state.seed}:${l.a}:${l.b}`].reduce((h, c) => Math.imul(h ^ c.charCodeAt(0), 16777619), 2166136261)) >>> 0);
    for (let s = 0; s < strandCount(l.strength); s++) {
      const i = Math.floor(rnd() * (a.pool.length / 3)) * 3;
      const j = Math.floor(rnd() * (b.pool.length / 3)) * 3;
      linkSegments.push([a.pool[i], a.pool[i + 1], a.pool[i + 2], b.pool[j], b.pool[j + 1], b.pool[j + 2], l.strength / 1000, l.a, l.b]);
    }
  }
  const pos = new Float32Array(linkSegments.length * 6);
  const col = new Float32Array(linkSegments.length * 6);
  linkSegments.forEach((s, i) => {
    pos.set(s.slice(0, 6), 6 * i);
    const a = 0.08 + 0.42 * s[6];
    col.set([signal[0] * a, signal[1] * a, signal[2] * a, signal[0] * a, signal[1] * a, signal[2] * a], 6 * i);
  });
  const g = new THREE.BufferGeometry();
  g.setAttribute('position', new THREE.BufferAttribute(pos, 3));
  g.setAttribute('color', new THREE.BufferAttribute(col, 3));
  links.geometry.dispose();
  links.geometry = g;
}

// ---------------------------------------------------------------- vurgu ve kamera

const camTarget = { pos: HOME.clone(), look: new THREE.Vector3(), until: 0 };

function applyHighlight() {
  const sel = state.highlight ? regions.get(state.highlight) : null;
  const focus = state.mode === 'focus';
  for (const r of regions.values()) {
    const base = (state.boost ?? 1) * (r.inner ? 0.9 : 1) * (0.55 + 0.6 * (r.glow ?? 0));
    r.material.uniforms.uIntensity.value = !sel ? base : r === sel ? base * 2.2 : base * (focus ? 0.14 : 0.28);
    r.mesh.visible = !(focus && sel && r !== sel && r.inner);
  }
  if (boundaries) boundaries.material.opacity = sel ? (focus ? 0.04 : 0.12) : 0.32;
  pointMaterial.uniforms.uFocus.value = sel ? sel.index : -1;
  pointMaterial.uniforms.uFocusAlpha.value = focus ? 0.06 : 0.15;
  if (links) links.visible = !(focus && sel);
  if (sel && focus) {
    const dir = sel.center.clone().normalize();
    if (dir.lengthSq() < 0.01) dir.copy(HOME).normalize();
    camTarget.look.copy(sel.center);
    camTarget.pos.copy(sel.center).addScaledVector(dir.add(new THREE.Vector3(0, 0.25, 0.4)).normalize(), 1.2 + sel.radius * 2.2);
    camTarget.until = performance.now() + 900;
  } else if (!sel || state.mode === 'overview') {
    camTarget.look.set(0, 0, 0);
  }
}

function resetCamera() {
  camTarget.pos.copy(HOME);
  camTarget.look.set(0, 0, 0);
  camTarget.until = performance.now() + 700;
}

// ---------------------------------------------------------------- olay animasyonu

function spawnPulse(seg) {
  activePulses.push({ seg, t: 0, speed: 0.35 + Math.random() * 0.4 });
}

function playEvent({ kind, regions: keys = [] }) {
  const color = kind === 'penalty' ? state.theme.penalty : state.theme.glow;
  const until = performance.now() + 1600;
  for (const k of keys) flashes.set(k, { until, color: new THREE.Color(color), penalty: kind === 'penalty' });
  if (kind === 'gain' && !state.reducedMotion) {
    for (const s of linkSegments) if (keys.includes(s[7]) || keys.includes(s[8])) spawnPulse(s);
  }
}

// ---------------------------------------------------------------- döngü

let raf = 0;
let last = performance.now();
let nextPulse = 0;
const perf = { frames: 0, since: performance.now(), worst: 0 };

function frame(now) {
  raf = requestAnimationFrame(frame);
  const dt = Math.min(0.1, (now - last) / 1000);
  last = now;
  perf.frames++;
  perf.worst = Math.max(perf.worst, dt * 1000);
  if (now - perf.since >= 5000) {
    post('perf', { fps: Math.round((perf.frames * 10000) / (now - perf.since)) / 10, frameMs: Math.round(perf.worst * 10) / 10, tier: state.tier });
    perf.frames = 0;
    perf.since = now;
    perf.worst = 0;
  }

  if (now < camTarget.until) {
    const k = 1 - Math.pow(0.001, dt);
    camera.position.lerp(camTarget.pos, k);
    controls.target.lerp(camTarget.look, k);
  }
  controls.update();
  pointMaterial.uniforms.uTime.value = now / 1000;

  // Ara sıra bir bağ boyunca sinyal darbesi.
  if (!state.reducedMotion && linkSegments.length && now > nextPulse) {
    spawnPulse(linkSegments[Math.floor(Math.random() * linkSegments.length)]);
    nextPulse = now + 1200 + Math.random() * 2600;
  }
  for (let i = activePulses.length - 1; i >= 0; i--) {
    activePulses[i].t += dt * activePulses[i].speed;
    if (activePulses[i].t >= 1) activePulses.splice(i, 1);
  }
  const pp = new Float32Array(activePulses.length * 3);
  const pc = new Float32Array(activePulses.length * 3);
  const sig = hexToRgb(state.theme.signal);
  activePulses.forEach((p, i) => {
    const s = p.seg;
    for (let a = 0; a < 3; a++) pp[3 * i + a] = s[a] + (s[a + 3] - s[a]) * p.t;
    const fade = Math.sin(Math.PI * p.t);
    pc.set([sig[0] * fade, sig[1] * fade, sig[2] * fade], 3 * i);
  });
  const pg = pulses.geometry;
  pg.setAttribute('position', new THREE.BufferAttribute(pp, 3));
  pg.setAttribute('color', new THREE.BufferAttribute(pc, 3));
  pg.setAttribute('aSize', new THREE.BufferAttribute(new Float32Array(activePulses.length).fill(11), 1));
  pg.setAttribute('aRegion', new THREE.BufferAttribute(new Float32Array(activePulses.length).fill(-1), 1));

  // Kazanç / ceza parlaması.
  for (const [k, f] of flashes) {
    const r = regions.get(k);
    if (!r) continue;
    const left = (f.until - now) / 1600;
    if (left <= 0) {
      flashes.delete(k);
      r.material.uniforms.uColor.value.setRGB(...regionColor(r, state.plan.regions.find((x) => x.key === k)));
      applyHighlight();
      continue;
    }
    const pulse = Math.sin(left * Math.PI);
    r.material.uniforms.uColor.value.copy(f.color);
    r.material.uniforms.uIntensity.value = 0.6 + 1.8 * pulse;
  }

  if (composer) composer.render(dt);
  else renderer.render(scene, camera);
}

function setVisible(v) {
  state.visible = v;
  cancelAnimationFrame(raf);
  if (v) {
    last = performance.now();
    perf.frames = 0;
    perf.since = last;
    raf = requestAnimationFrame(frame);
  }
}

// ---------------------------------------------------------------- kurulum

function setupRenderer() {
  const q = QUALITY[state.tier] ?? QUALITY.mid;
  if (renderer) {
    renderer.domElement.remove();
    renderer.dispose();
  }
  renderer = new THREE.WebGLRenderer({ antialias: q.antialias, powerPreference: 'high-performance' });
  renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, q.pixelRatio));
  renderer.setClearColor(state.theme.background, 1);
  // Efekt zincirinde temizleme rengi iki kez sRGB'ye çevriliyor (gri zemin); sahne arka planı
  // renk yönetiminden doğru geçer.
  scene.background = new THREE.Color(state.theme.background);
  document.body.appendChild(renderer.domElement);
  pointMaterial.uniforms.uPixel.value = renderer.getPixelRatio();
  state.boost = q.bloom > 0 ? 1 : 1.7;
  pointMaterial.uniforms.uBoost.value = state.boost;
  if (pulses) pulses.material.uniforms.uPixel.value = renderer.getPixelRatio();

  composer = null;
  if (q.bloom > 0) {
    composer = new EffectComposer(renderer);
    composer.addPass(new RenderPass(scene, camera));
    const scale = q.bloom === 1 ? 0.5 : 1;
    bloomPass = new UnrealBloomPass(new THREE.Vector2(innerWidth * scale, innerHeight * scale), 0.85, 0.0, 0.2);
    // Büyük (bulanık) katmanların payı düşük: ışıma beyne yakın kalsın, bütün kareyi pusla örtmesin.
    bloomPass.compositeMaterial.uniforms.bloomFactors.value = [1.0, 0.55, 0.22, 0.06, 0.0];
    composer.addPass(bloomPass);
    composer.addPass(new OutputPass());
  }
  const prev = controls;
  controls = new OrbitControls(camera, renderer.domElement);
  if (prev) {
    controls.target.copy(prev.target);
    prev.dispose();
  }
  controls.enablePan = false;
  controls.enableDamping = true;
  controls.dampingFactor = 0.08;
  controls.minDistance = 1.2;
  controls.maxDistance = 7;
  controls.rotateSpeed = 0.7;
  controls.touches = { ONE: THREE.TOUCH.ROTATE, TWO: THREE.TOUCH.DOLLY_ROTATE };
  controls.autoRotate = !state.reducedMotion;
  controls.autoRotateSpeed = 0.35;
  controls.addEventListener('start', () => {
    controls.autoRotate = false;
    camTarget.until = 0;
  });
  bindTaps(renderer.domElement);
  resize();
}

function resize() {
  const w = innerWidth;
  const h = innerHeight;
  camera.aspect = w / Math.max(1, h);
  camera.updateProjectionMatrix();
  renderer.setSize(w, h);
  if (composer) composer.setSize(w, h);
}
window.addEventListener('resize', () => renderer && resize());

// Tek dokunuş bölge seçer, çift dokunuş görünümü sıfırlar. Sürükleme dokunuş sayılmaz.
function bindTaps(el) {
  let down = null;
  let lastTap = 0;
  let pending = 0;
  const ray = new THREE.Raycaster();
  el.addEventListener('pointerdown', (e) => {
    if (e.isPrimary) down = { x: e.clientX, y: e.clientY, t: performance.now() };
  });
  el.addEventListener('pointerup', (e) => {
    if (!down || !e.isPrimary) return;
    const moved = Math.hypot(e.clientX - down.x, e.clientY - down.y);
    const quick = performance.now() - down.t < 300;
    down = null;
    if (moved > 10 || !quick) return;
    const now = performance.now();
    if (now - lastTap < 320) {
      clearTimeout(pending);
      lastTap = 0;
      resetCamera();
      post('reset', {});
      return;
    }
    lastTap = now;
    const ndc = new THREE.Vector2((e.clientX / innerWidth) * 2 - 1, -(e.clientY / innerHeight) * 2 + 1);
    pending = setTimeout(() => {
      ray.setFromCamera(ndc, camera);
      const meshes = [...regions.values()].filter((r) => r.mesh.visible).map((r) => r.mesh);
      const hit = ray.intersectObjects(meshes, false)[0];
      post('regionTapped', { key: hit ? hit.object.name : null });
    }, 330);
  });
}

// ---------------------------------------------------------------- köprü

function receive(text) {
  const m = parseMessage(text);
  if (m.error) {
    console.warn('[bridge] yok sayıldı:', m.error);
    return;
  }
  const p = m.payload;
  switch (m.type) {
    case 'init':
      Object.assign(state.theme, p.theme ?? {});
      state.rootColors = p.rootColors ?? {};
      state.reducedMotion = !!p.reducedMotion;
      state.seed = p.seed ?? state.seed;
      state.tier = p.tier ?? state.tier;
      pointMaterial.uniforms.uMotion.value = state.reducedMotion ? 0 : 1;
      setupRenderer();
      if (boundaries) boundaries.material.color.set(state.theme.line);
      rebuildNeurons();
      setVisible(state.visible);
      break;
    case 'state':
      state.plan = { regions: p.regions ?? [], links: p.links ?? [] };
      rebuildNeurons();
      break;
    case 'highlight':
      state.highlight = p.key ?? null;
      state.mode = p.mode === 'focus' ? 'focus' : 'overview';
      if (!state.highlight) resetCamera();
      applyHighlight();
      break;
    case 'event':
      playEvent(p);
      break;
    case 'quality':
      if (p.tier && p.tier !== state.tier) {
        state.tier = p.tier;
        setupRenderer();
      }
      break;
    case 'visibility':
      setVisible(!!p.visible);
      break;
    case 'reset':
      resetCamera();
      break;
  }
}

window.brain = { receive, ping: () => post('ready', { scene: SCENE_VERSION, regions: [...regions.keys()], hints: hints() }) };

function hints() {
  let gpu = '';
  try {
    const gl = document.createElement('canvas').getContext('webgl');
    const ext = gl?.getExtension('WEBGL_debug_renderer_info');
    gpu = ext ? gl.getParameter(ext.UNMASKED_RENDERER_WEBGL) : gl?.getParameter(gl.RENDERER) ?? '';
    if (!gl) return null;
  } catch {
    return null;
  }
  return { cores: navigator.hardwareConcurrency ?? null, memoryGb: navigator.deviceMemory ?? null, renderer: String(gpu) };
}

(async () => {
  const h = hints();
  if (!h) {
    post('error', { message: 'webgl' });
    return;
  }
  try {
    await loadModel();
    post('ready', { scene: SCENE_VERSION, regions: [...regions.keys()], hints: h });
  } catch (e) {
    post('error', { message: String(e?.message ?? e) });
  }
})();
