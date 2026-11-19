// Sahneyi tek klasik betik olarak paketler: assets/brain/brain.js (Three.js + sahne + gömülü
// GLB + meshopt çözücü). WebView sahneyi file:// altında açar; orada ES modülü ve fetch
// çalışmadığı için her şey tek dosyadadır (DECISIONS D40).
import { build } from 'esbuild';

await build({
  entryPoints: ['src/main.js'],
  bundle: true,
  format: 'iife',
  minify: true,
  target: ['chrome90'],
  loader: { '.glb': 'binary' },
  legalComments: 'eof',
  outfile: '../../assets/brain/brain.js',
  logLevel: 'info',
});
