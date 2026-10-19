/**
 * tests/unit/adapters.test.mjs
 * Cobre o adaptador de teclado (o caminho real usado hoje) e o de bridge.
 *
 * O `KeyboardEvent` do DOM não existe em Node, então usamos um duplo mínimo
 * com a mesma superfície usada pelo adaptador (type/key/code + campos legados).
 */

import test from 'node:test';
import assert from 'node:assert/strict';

import { KeyEventAdapter } from '../../assets/mobile/js/adapters/key-event-adapter.js';
import { ExternalInterfaceAdapter } from '../../assets/mobile/js/adapters/external-interface-adapter.js';
import { ACTION } from '../../assets/mobile/js/keymap.js';

/* ── duplo de DOM ─────────────────────────────────────────────────────── */

class FakeKeyboardEvent {
  constructor(type, init = {}) {
    this.type = type;
    this.key = init.key;
    this.code = init.code;
    this.location = init.location ?? 0;
    this.bubbles = !!init.bubbles;
    this.cancelable = !!init.cancelable;
    this.composed = !!init.composed;
    this.repeat = !!init.repeat;
  }
}
globalThis.KeyboardEvent = FakeKeyboardEvent;

/** Alvo falso que registra os eventos recebidos — não precisa de browser. */
function fakeTarget() {
  const events = [];
  return {
    events,
    dispatchEvent(ev) { events.push(ev); return true; },
  };
}

/* ── adaptador de teclado ─────────────────────────────────────────────── */

test('press/release despacham keydown/keyup com key e code corretos', () => {
  const t = fakeTarget();
  const a = new KeyEventAdapter({ target: t });
  a.press(ACTION.MOVE_LEFT);
  a.release(ACTION.MOVE_LEFT);
  assert.equal(t.events.length, 2);
  assert.equal(t.events[0].type, 'keydown');
  assert.equal(t.events[0].key, 'ArrowLeft');
  assert.equal(t.events[0].code, 'ArrowLeft');
  assert.equal(t.events[1].type, 'keyup');
});

test('os eventos atravessam shadow DOM (composed) — exigido pelo Ruffle', () => {
  const t = fakeTarget();
  const a = new KeyEventAdapter({ target: t });
  a.press(ACTION.SHOOT);
  assert.equal(t.events[0].composed, true);
  assert.equal(t.events[0].bubbles, true);
});

test('keyCode legado é anexado por defineProperty', () => {
  const t = fakeTarget();
  const a = new KeyEventAdapter({ target: t });
  a.press(ACTION.SHOOT);
  assert.equal(t.events[0].keyCode, 32, 'Flash precisa de keyCode=SPACE');
  assert.equal(t.events[0].code, 'Space');
  assert.equal(t.events[0].which, 32);
});

test('não despacha keydown duplicado enquanto a tecla está segurada', () => {
  const t = fakeTarget();
  const a = new KeyEventAdapter({ target: t });
  a.press(ACTION.MOVE_RIGHT);
  a.press(ACTION.MOVE_RIGHT);
  assert.equal(t.events.length, 1);
  a.release(ACTION.MOVE_RIGHT);
  assert.equal(t.events.length, 2);
});

test('release sem press é ignorado (não gera keyup fantasma)', () => {
  const t = fakeTarget();
  const a = new KeyEventAdapter({ target: t });
  assert.equal(a.release(ACTION.MOVE_LEFT), false);
  assert.equal(t.events.length, 0);
});

test('releaseAll solta todas as teclas presas', () => {
  const t = fakeTarget();
  const a = new KeyEventAdapter({ target: t });
  a.press(ACTION.MOVE_LEFT);
  a.press(ACTION.ANGLE_UP);
  a.press(ACTION.SHOOT);
  assert.equal(a.heldKeys.length, 3);
  const freed = a.releaseAll();
  assert.equal(freed.length, 3);
  assert.equal(a.heldKeys.length, 0);
  assert.equal(t.events.filter((e) => e.type === 'keyup').length, 3);
});

test('ação sem tecla no mapa é recusada', () => {
  const t = fakeTarget();
  const a = new KeyEventAdapter({ target: t });
  assert.equal(a.press('acao_inexistente'), false);
  assert.equal(t.events.length, 0);
});

test('probe() só habilita o painel se o alvo aceitar KeyboardEvent', () => {
  const good = new KeyEventAdapter({ target: fakeTarget() });
  assert.equal(good.probe().ok, true);

  const broken = new KeyEventAdapter({
    target: { dispatchEvent() { throw new Error('boom'); } },
  });
  const r = broken.probe();
  assert.equal(r.ok, false);
  assert.match(r.reason, /dispatchEvent falhou/);
});

test('adapter sem alvo fica indisponível em vez de explodir', () => {
  const a = new KeyEventAdapter({});
  assert.equal(a.available, false);
  assert.equal(a.press(ACTION.SHOOT), false);
  assert.equal(a.release(ACTION.SHOOT), false);
  assert.deepEqual(a.releaseAll(), []);
  assert.equal(a.probe().ok, false);
});

/* ── adaptador de bridge (ExternalInterface) ──────────────────────────── */

test('bridge ExternalInterface fica inativa enquanto o SWF não a registra', () => {
  const a = new ExternalInterfaceAdapter({ bridge: {} });
  assert.equal(a.detect(), false);
  assert.equal(a.probe().ok, false);
  assert.equal(a.press(ACTION.MOVE_LEFT), false);
});

test('bridge assume o controle quando o AS3 registra as funções', () => {
  const calls = [];
  const bridge = Object.fromEntries([
    'ddtMoveLeft', 'ddtMoveRight', 'ddtAngleUp', 'ddtAngleDown',
    'ddtBeginShoot', 'ddtReleaseShoot', 'ddtGetState',
  ].map((k) => [k, (...a) => calls.push([k, ...a])]));

  globalThis.__ddt_mobile_bridge__ = true;
  try {
    const a = new ExternalInterfaceAdapter({ bridge });
    assert.equal(a.detect(), true);
    assert.equal(a.probe().ok, true);

    a.press(ACTION.MOVE_LEFT);
    a.press(ACTION.SHOOT);
    a.release(ACTION.SHOOT);
    a.release(ACTION.MOVE_LEFT);
    a.getState();

    assert.deepEqual(
      calls.map((c) => c[0]),
      ['ddtMoveLeft', 'ddtBeginShoot', 'ddtReleaseShoot', 'ddtGetState'],
      'movimento não gera release: no jogo ele é contínuo enquanto a tecla está down',
    );
    assert.ok(a.getState() !== undefined);
  } finally {
    delete globalThis.__ddt_mobile_bridge__;
  }
});

test('precedência: sem bridge, press/release não fazem nada', () => {
  delete globalThis.__ddt_mobile_bridge__;
  const a = new ExternalInterfaceAdapter({ bridge: {} });
  assert.equal(a.detect(), false);
  assert.equal(a.press(ACTION.SHOOT), false);
  assert.deepEqual(a.releaseAll(), []);
  assert.equal(a.getState(), null);
});