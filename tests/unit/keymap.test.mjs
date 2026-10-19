/**
 * tests/unit/keymap.test.mjs
 * Garante que o mapa de teclas do painel mobile continua EXATAMENTE igual ao
 * que o ActionScript decompilado escuta. Se alguém "otimizar" uma tecla aqui,
 * o painel passa a mandar um comando que o jogo ignora em silêncio.
 */

import test from 'node:test';
import assert from 'node:assert/strict';

import {
  ACTION, ACTION_KEYS, ACTION_PRIMARY_KEY, KEY_SPECS, FORCE,
  actionForKeyCode, actionForCode, clamp,
} from '../../assets/mobile/js/keymap.js';

test('mapeamento de teclas reproduz o código decompilado', () => {
  // GameLocalPlayer.as:139-142 / SelfPlayerWalkAction.as:49-51
  assert.deepEqual(ACTION_KEYS[ACTION.MOVE_LEFT], [37, 65]);
  assert.deepEqual(ACTION_KEYS[ACTION.MOVE_RIGHT], [39, 68]);
  // ArrowView.as:386 (S/DOWN subtrai) e :398 (W/UP soma)
  assert.deepEqual(ACTION_KEYS[ACTION.ANGLE_UP], [38, 87]);
  assert.deepEqual(ACTION_KEYS[ACTION.ANGLE_DOWN], [40, 83]);
  // EnergyView.as:167
  assert.deepEqual(ACTION_KEYS[ACTION.SHOOT], [32]);
});

test('tecla primária usa sempre Keyboard.* (setas/espaço)', () => {
  // O polling em ENTER_FRAME usa as setas/espaço; as letras são aliases de
  // KEY_DOWN. Escolher a primária como seta cobre ambos os caminhos.
  assert.equal(ACTION_PRIMARY_KEY[ACTION.MOVE_LEFT], 37);
  assert.equal(ACTION_PRIMARY_KEY[ACTION.MOVE_RIGHT], 39);
  assert.equal(ACTION_PRIMARY_KEY[ACTION.ANGLE_UP], 38);
  assert.equal(ACTION_PRIMARY_KEY[ACTION.ANGLE_DOWN], 40);
  assert.equal(ACTION_PRIMARY_KEY[ACTION.SHOOT], 32);
});

test('todas as teclas primárias têm KEY_SPECS com key e code', () => {
  for (const [action, code] of Object.entries(ACTION_PRIMARY_KEY)) {
    const spec = KEY_SPECS[code];
    assert.ok(spec, `falta KEY_SPECS para ${action} (${code})`);
    // O Ruffle 0.7 lê key/code — o glue JS não contém a string "keyCode".
    assert.ok(spec.key, `key ausente em ${code}`);
    assert.ok(spec.code, `code ausente em ${code}`);
    assert.equal(spec.action, action);
  }
});

test('KeyboardManager só aceita keyCode < 139', () => {
  // org/aswing/KeyboardManager.as:134 ignora keyCode >= 139.
  for (const [action, code] of Object.entries(ACTION_PRIMARY_KEY)) {
    assert.ok(code < 139, `${action} usa ${code}, que o KeyboardManager descarta`);
  }
});

test('resolução de teclas e ações', () => {
  assert.equal(actionForKeyCode(37), ACTION.MOVE_LEFT);
  assert.equal(actionForKeyCode(65), ACTION.MOVE_LEFT);
  assert.equal(actionForKeyCode(39), ACTION.MOVE_RIGHT);
  assert.equal(actionForKeyCode(38), ACTION.ANGLE_UP);
  assert.equal(actionForKeyCode(40), ACTION.ANGLE_DOWN);
  assert.equal(actionForKeyCode(32), ACTION.SHOOT);
  assert.equal(actionForKeyCode(13), null, 'ENTER não é comando de batalha');
  assert.equal(actionForKeyCode(27), null, 'ESC não é comando de batalha');
  assert.equal(actionForCode('ArrowLeft'), ACTION.MOVE_LEFT);
  assert.equal(actionForCode('Space'), ACTION.SHOOT);
  assert.equal(actionForCode('KeyQ'), null);
});

test('clamp', () => {
  assert.equal(clamp(5, 0, 10), 5);
  assert.equal(clamp(-5, 0, 10), 0);
  assert.equal(clamp(50, 0, 10), 10);
});

test('parâmetros de força batem com EnergyView.as', () => {
  assert.equal(FORCE.MAX, 2000);   // EnergyView.as:30 FORCE_MAX
  assert.equal(FORCE.STEP, 20);    // EnergyView.as:45 _forceSpeed
  assert.ok(Math.abs(FORCE.FRAME_MS - 40) < 0.001); // Config.GAME_FPS = 25 (Config.as:6)
});