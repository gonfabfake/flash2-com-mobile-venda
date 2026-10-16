/**
 * tests/unit/flash-host-bridge.test.mjs
 *
 * Regressão do BUG: o player.html original (SHA-256 7EE30DE1...) não definia
 * NENHUMA função que o ActionScript chama via ExternalInterface.call(...).
 * Estes testes travam o contrato para que o bug não volte.
 */

import test from 'node:test';
import assert from 'node:assert/strict';

import {
  FlashHostBridge, FLASH_CALLED_FUNCTIONS, FLASH_REGISTERED_CALLBACKS,
} from '../../assets/mobile/js/flash-host-bridge.js';

const scope = () => ({ location: { href: 'http://x/player.html' }, document: { title: '' } });

test('todas as funções chamadas pelo AS3 existem após install()', () => {
  const s = scope();
  new FlashHostBridge({ scope: s }).install();
  const missing = FLASH_CALLED_FUNCTIONS.filter((n) => typeof s[n] !== 'function');
  assert.deepEqual(missing, [], `funções ausentes: ${missing.join(', ')}`);
});

test('os callbacks registrados pelo AS3 não são sobrescritos', () => {
  const s = scope();
  let as3Called = false;
  // simula o SWF registrando o callback antes do install
  for (const n of FLASH_REGISTERED_CALLBACKS) s[n] = () => { as3Called = true; };
  new FlashHostBridge({ scope: s }).install();
  s.SetIsDesktop();
  assert.equal(as3Called, true, 'o bridge sobrescreveu um addCallback do SWF');
});

test('IsDesktop respeita o feature flag ?desktop=1', () => {
  const a = scope();
  new FlashHostBridge({ scope: a, isDesktop: false }).install();
  assert.equal(a.IsDesktop(), false);

  const b = scope();
  new FlashHostBridge({ scope: b, isDesktop: true }).install();
  assert.equal(b.IsDesktop(), true, 'sem isso o SWF trava em modo desktop');
});

test('game_interruption é acionado em queda de sessão', () => {
  const s = scope();
  const bridge = new FlashHostBridge({ scope: s, onNavigate: () => {} }).install();
  let seen = null;
  bridge.onInterruption = (url, message) => { seen = { url, message }; };
  s.game_interruption('http://x/login', 'sessão encerrada');
  assert.deepEqual(seen, { url: 'http://x/login', message: 'sessão encerrada' });
});

test('title_effect.tickerBegin/Stop existe (PageInterfaceManager.as:17,25)', () => {
  const s = scope();
  const bridge = new FlashHostBridge({ scope: s }).install();
  assert.equal(typeof s.title_effect.tickerBegin, 'function');
  assert.equal(typeof s.title_effect.tickerStop, 'function');
  s.title_effect.tickerBegin('sua vez');
  assert.equal(s.title_effect.ticker.running, true);
  assert.ok(bridge._tickerTimer, 'ticker ativo cria o intervalo');
  s.title_effect.tickerStop();
  assert.equal(s.title_effect.ticker.running, false);
  bridge.stop();
  assert.equal(bridge._tickerTimer, null, 'stop() libera o setInterval');
});

test('tickerBegin repetido não acumula timers', () => {
  const s = scope();
  const bridge = new FlashHostBridge({ scope: s }).install();
  s.title_effect.tickerBegin('a');
  const first = bridge._tickerTimer;
  s.title_effect.tickerBegin('b');
  assert.notEqual(bridge._tickerTimer, first, 'o intervalo anterior foi destruído');
  bridge.stop();
});

test('nenhuma função lança exceção com argumentos inesperados', () => {
  const s = scope();
  new FlashHostBridge({ scope: s, onNavigate: () => {} }).install();
  for (const name of FLASH_CALLED_FUNCTIONS) {
    assert.doesNotThrow(() => s[name](), 'chamada vazia de ' + name);
    assert.doesNotThrow(() => s[name](undefined, null, 0), 'chamada com args de ' + name);
  }
});

test('registered callbacks listados não colidem com as called functions', () => {
  const overlap = FLASH_REGISTERED_CALLBACKS.filter((n) => FLASH_CALLED_FUNCTIONS.includes(n));
  // ExternalLoadStop é registrada; ExternalLoadStart é chamada. Não podem
  // ser a mesma função.
  assert.deepEqual(overlap, []);
});