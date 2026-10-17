/**
 * tests/unit/zoom-pan.test.mjs
 * ZoomPan só deve "tomar" a entrada quando há pinch ou quando já ampliado.
 * Em 1×, um toque simples precisa passar para o jogo.
 */

import test from 'node:test';
import assert from 'node:assert/strict';

// Duplo mínimo de DOM (sem browser).
class FakeEl {
  constructor() {
    this.listeners = {};
    this.style = {};
    this.clientWidth = 800;
    this.clientHeight = 400;
    this._captured = new Set();
  }
  addEventListener(type, fn, opts) { (this.listeners[type] ||= []).push(fn); }
  setPointerCapture(id) { this._captured.add(id); }
  releasePointerCapture(id) { this._captured.delete(id); }
  dispatch(type, ev) { for (const fn of this.listeners[type] || []) fn(ev); }
  getBoundingClientRect() { return { left: 0, top: 0, width: 800, height: 400 }; }
}

function mkPointer(id, x, y) {
  return { pointerId: id, clientX: x, clientY: y, preventDefault() { this._pd = true; } };
}

import { ZoomPan } from '../../assets/mobile/js/zoom-pan.js';

test('começa em 1× e não captura toque simples', () => {
  const el = new FakeEl();
  const zp = new ZoomPan({ target: el });
  assert.equal(zp.scale, 1);
  assert.equal(zp.zoomed, false);

  const ev = mkPointer(1, 100, 100);
  el.dispatch('pointerdown', ev);
  assert.equal(ev._pd, undefined, 'em 1× não deve preventDefault');
  assert.equal(el._captured.has(1), false, 'em 1× não deve capturar');
});

test('pinch com 2 dedos amplia', () => {
  const el = new FakeEl();
  const zp = new ZoomPan({ target: el });
  const a = mkPointer(1, 300, 200);
  const b = mkPointer(2, 500, 200);
  el.dispatch('pointerdown', a);
  el.dispatch('pointerdown', b);
  // move: afasta os dedos
  const a2 = mkPointer(1, 200, 200);
  const b2 = mkPointer(2, 600, 200);
  el.dispatch('pointermove', a2);
  el.dispatch('pointermove', b2);
  assert.ok(zp.scale > 1, `scale deveria > 1, got ${zp.scale}`);
  assert.ok(zp.scale <= 4, 'não deve passar de 4×');
});

test('duplo toque alterna 1× ↔ 2×', async () => {
  const el = new FakeEl();
  const zp = new ZoomPan({ target: el });
  const tap = (t) => {
    const ev = mkPointer(1, 100, 100);
    ev.timeStamp = t;
    el.dispatch('pointerdown', ev);
    const up = mkPointer(1, 100, 100);
    el.dispatch('pointerup', up);
  };
  tap(0);
  tap(100);
  assert.equal(zp.scale, 2, 'duplo toque deve ir para 2×');
});

test('reset() volta a 1×', () => {
  const el = new FakeEl();
  const zp = new ZoomPan({ target: el });
  zp.scale = 3; zp.tx = -100; zp.ty = -50;
  zp.reset();
  assert.equal(zp.scale, 1);
  assert.equal(zp.tx, 0);
  assert.equal(zp.ty, 0);
});

test('zoomIn/zoomOut respeitam os limites', () => {
  const el = new FakeEl();
  const zp = new ZoomPan({ target: el, min: 1, max: 2 });
  zp.zoomIn(); zp.zoomIn(); zp.zoomIn();
  assert.ok(zp.scale <= 2, `scale ${zp.scale} passou do max 2`);
  zp.reset();
  zp.zoomOut();
  assert.equal(zp.scale, 1, 'não deve ir abaixo de min');
});

test('pan só acontece quando ampliado', () => {
  const el = new FakeEl();
  const zp = new ZoomPan({ target: el });
  // força zoom
  zp.scale = 2; zp._apply();
  const ev = mkPointer(1, 100, 100);
  el.dispatch('pointerdown', ev);
  assert.equal(ev._pd, true, 'em zoom deve preventDefault');
  assert.equal(el._captured.has(1), true, 'em zoom deve capturar');
});