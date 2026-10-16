/**
 * tests/unit/input-core.test.mjs
 * Cobre a garantia mais importante da ETAPA 3: "impedir comandos presos após
 * perda de foco" e "interromper o movimento ao soltar o botão".
 */

import test from 'node:test';
import assert from 'node:assert/strict';

import { InputCore, TAP_ACTIONS, HOLD_ACTIONS } from '../../assets/mobile/js/input-core.js';
import { ACTION } from '../../assets/mobile/js/keymap.js';

const mk = (opts = {}) => {
  const log = [];
  const core = new InputCore({ onChange: (a, p, s) => log.push([a, p, s]), ...opts });
  return { core, log };
};

test('press/release produzem bordas na ordem correta', () => {
  const { core, log } = mk();
  assert.equal(core.press(ACTION.MOVE_LEFT, 'p1'), true);
  assert.equal(core.isActive(ACTION.MOVE_LEFT), true);
  assert.equal(core.release(ACTION.MOVE_LEFT, 'p1'), true);
  assert.equal(core.isActive(ACTION.MOVE_LEFT), false);
  assert.deepEqual(log, [
    [ACTION.MOVE_LEFT, true, 'p1'],
    [ACTION.MOVE_LEFT, false, 'p1'],
  ]);
});

test('press repetido é idempotente (não duplica comando)', () => {
  const { core, log } = mk();
  core.press(ACTION.MOVE_RIGHT, 'p1');
  core.press(ACTION.MOVE_RIGHT, 'p1');
  core.press(ACTION.MOVE_RIGHT, 'p1');
  assert.equal(log.filter(([, p]) => p).length, 1);
  assert.equal(core.activeCount, 1);
});

test('release de fonte diferente não cancela o comando de outro dedo', () => {
  const { core } = mk();
  core.press(ACTION.ANGLE_UP, 'pointer:1');
  // um keyup atrasado de outro dispositivo não pode soltar
  assert.equal(core.release(ACTION.ANGLE_UP, 'pointer:2'), false);
  assert.equal(core.isActive(ACTION.ANGLE_UP), true);
  assert.equal(core.release(ACTION.ANGLE_UP, 'pointer:1'), true);
});

test('multi-toque: dois comandos simultâneos coexistem', () => {
  const { core } = mk();
  core.press(ACTION.MOVE_LEFT, 'pointer:1');
  core.press(ACTION.SHOOT, 'pointer:2');
  assert.equal(core.activeCount, 2);
  core.release(ACTION.SHOOT, 'pointer:2');
  assert.equal(core.isActive(ACTION.MOVE_LEFT), true, 'andar continua enquanto carrega força');
});

test('releaseAll (blur / visibilitychange) limpa tudo', () => {
  const { core, log } = mk();
  core.press(ACTION.MOVE_LEFT, 'p');
  core.press(ACTION.MOVE_RIGHT, 'p');
  core.press(ACTION.SHOOT, 'p');
  const freed = core.releaseAll('blur');
  assert.equal(freed, 3);
  assert.equal(core.activeCount, 0);
  assert.equal(log.filter(([, p]) => p === false).length, 3);
  assert.ok(log.at(-1)[2].includes('blur'));
});

test('sweep() libera comando preso após o timeout', () => {
  let now = 1000;
  const { core } = mk({ now: () => now, stuckTimeoutMs: 4000 });
  core.press(ACTION.MOVE_RIGHT, 'p');
  assert.deepEqual(core.sweep(), []);
  now += 3999;
  assert.deepEqual(core.sweep(), []);
  now += 2;                       // ultrapassa o deadline
  assert.deepEqual(core.sweep(), [ACTION.MOVE_RIGHT]);
  assert.equal(core.isActive(ACTION.MOVE_RIGHT), false);
});

test('ações de toque se soltam sozinhas', async () => {
  const { core, log } = mk();
  core.press(ACTION.TOGGLE_ARROW, 'p');
  await new Promise((r) => setImmediate(r));
  assert.equal(core.isActive(ACTION.TOGGLE_ARROW), false);
  assert.equal(log.filter(([a, p]) => a === ACTION.TOGGLE_ARROW && p).length, 1);
  assert.equal(log.filter(([a, p]) => a === ACTION.TOGGLE_ARROW && !p).length, 1);
  for (const a of TAP_ACTIONS) assert.equal(HOLD_ACTIONS.includes(a), false);
});

test('ações desconhecidas são ignoradas', () => {
  const { core } = mk();
  assert.equal(core.press('nao_existe', 'p'), false);
  assert.equal(core.activeCount, 0);
});

test('snapshot descreve o estado para diagnóstico', () => {
  const { core } = mk();
  core.press(ACTION.SHOOT, 'pointer:7');
  const snap = core.snapshot();
  assert.equal(snap[ACTION.SHOOT].source, 'pointer:7');
  assert.equal(typeof snap[ACTION.SHOOT].since, 'number');
});