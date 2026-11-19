import assert from 'node:assert/strict';
import { test } from 'node:test';
import { encodeMessage, hashString, layoutPoints, mulberry32, parseMessage, strandCount } from '../src/core.js';

test('tohumlu rastgelelik deterministik', () => {
  const a = mulberry32(42);
  const b = mulberry32(42);
  for (let i = 0; i < 5; i++) assert.equal(a(), b());
  assert.notEqual(mulberry32(1)(), mulberry32(2)());
  assert.equal(hashString('abc'), hashString('abc'));
});

test('nöron i, sayı artınca yerinden oynamaz; tohum değişince değişir', () => {
  const pool = new Float32Array([0, 0, 0, 1, 1, 1, -1, 0.5, 0.2]);
  const few = layoutPoints(pool, 3, 'user-1', 'hippocampus');
  const many = layoutPoints(pool, 10, 'user-1', 'hippocampus');
  assert.deepEqual([...many.slice(0, 9)], [...few]);
  const other = layoutPoints(pool, 3, 'user-2', 'hippocampus');
  assert.notDeepEqual([...other], [...few]);
  assert.equal(layoutPoints(new Float32Array(), 4, 's', 'k').length, 12);
});

test('köprü: sürüm ve tür denetlenir', () => {
  assert.deepEqual(parseMessage(encodeMessage('highlight', { key: 'amygdala' })), {
    type: 'highlight',
    payload: { key: 'amygdala' },
  });
  assert.equal(parseMessage('{"v":2,"type":"state"}').error, 'version');
  assert.equal(parseMessage('{"v":1,"type":"nope"}').error, 'type:nope');
  assert.equal(parseMessage('{bozuk').error, 'json');
});

test('güçlü bağ daha çok şerit', () => {
  assert.equal(strandCount(0), 1);
  assert.equal(strandCount(600), 3);
  assert.equal(strandCount(1000), 5);
});
