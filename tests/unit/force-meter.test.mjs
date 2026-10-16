/**
 * tests/unit/force-meter.test.mjs
 * O espelho local da barra de força precisa reproduzir o algoritmo de
 * game/view/EnergyView.as — se divergir, a barra mente para o jogador.
 */

import test from 'node:test';
import assert from 'node:assert/strict';

import { ForceMeter } from '../../assets/mobile/js/force-meter.js';

test('start zera a força e marca carregando', () => {
  const m = new ForceMeter();
  m.start();
  assert.equal(m.value, 0);
  assert.equal(m.charging, true);
  assert.equal(m.ratio, 0);
});

test('sobe de 20 em 20, um passo por frame (25 fps)', () => {
  const m = new ForceMeter();
  m.start();
  m.tick(40);               // 1 frame de Config.GAME_FPS = 25
  assert.equal(m.value, 20);
  m.tick(40);
  assert.equal(m.value, 40);
  m.tick(40);               // tick grande deve limitar a 1 passo por frame
  assert.equal(m.value, 60);
});

test('ping-pong: sobe até FORCE_MAX e inverte a direção', () => {
  const m = new ForceMeter();
  m.start();
  m.tick(40 * 100);          // 100 frames x 20 = 2000
  assert.equal(m.value, 2000, 'atinge FORCE_MAX');
  assert.equal(m.dir, 1, 'inverte só no frame seguinte');
  m.tick(40);
  assert.equal(m.dir, -1, 'EnergyView inverte ao bater no teto');
  assert.equal(m.value, 1980);
  m.tick(40 * 5);
  assert.equal(m.value, 1980 - 5 * 20);
  assert.ok(m.value < 2000, 'nunca passa de FORCE_MAX');
});

test('release devolve a força que seria enviada ao servidor', () => {
  const m = new ForceMeter();
  m.start();
  m.tick(40 * 10);          // 200
  const shot = m.release();
  assert.equal(shot, 200);
  assert.equal(m.lastShot, 200);
  assert.equal(m.charging, false);
});

test('zerar a força dispara skip(), como EnergyView.as:221', () => {
  const m = new ForceMeter();
  m.start();
  m.tick(40 * 200);         // sobe até 2000 e volta até 0
  assert.equal(m.value, 0);
  assert.equal(m.charging, true, 'ainda não skipeou: o zero só é avaliado no frame seguinte');
  m.tick(40);
  assert.equal(m.charging, false);
  assert.equal(m.skipped, true);
  assert.equal(m.value, 0);
  assert.equal(m.release(), 0, 'o tiro vira skip, não disparo');
});

test('cancel volta ao estado inicial (pointercancel / blur)', () => {
  const m = new ForceMeter();
  m.start();
  m.tick(40 * 7);
  m.cancel();
  assert.equal(m.value, 0);
  assert.equal(m.dir, 1);
  assert.equal(m.charging, false);
  assert.equal(m.skipped, false);
});

test('ratio e display são coerentes', () => {
  const m = new ForceMeter();
  m.start();
  m.tick(40 * 50);          // 1000 de 2000
  assert.equal(m.ratio, 0.5);
  assert.equal(m.display, 1000);
});