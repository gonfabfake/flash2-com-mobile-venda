/**
 * tests/e2e/player.e2e.mjs — Testes end-to-end em Chromium real.
 *
 * Uso exclusivo de `config.local.xml` (ver config.local.xml) para que o núcleo
 * de 4,45 MB seja servido LOCALMENTE e não dependa do CDN remoto. Isso torna
 * os testes rápidos e determinísticos.
 */

import test from 'node:test';
import assert from 'node:assert/strict';
import { chromium } from 'playwright';

import { startServer } from '../server.mjs';

let server;
let browser;

const PHONE = {
  viewport: { width: 844, height: 390 },
  deviceScaleFactor: 3,
  isMobile: true,
  hasTouch: true,
};

const URL_BASE = () => `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`;

async function newPage(ctxOpts = {}) {
  const context = await browser.newContext({ ...PHONE, ...ctxOpts });
  const page = await context.newPage();
  page.consoleErrors = [];
  page.pageErrors = [];
  page.on('console', (m) => { if (m.type() === 'error') page.consoleErrors.push(m.text()); });
  page.on('pageerror', (e) => page.pageErrors.push(String(e && e.message)));
  return page;
}

async function waitBoot(page, url, timeout = 60_000) {
  await page.goto(url, { waitUntil: 'domcontentloaded', timeout });
  await page.waitForFunction(() => globalThis.__ddt !== undefined, null, { timeout });
  await page.waitForSelector('#flashPlayer', { timeout });
  await page.waitForTimeout(1500);
  return page;
}

function criticalErrors(page) {
  const noise = [/sitemoderno/i, /net::ERR_/i, /ERR_NAME_NOT_RESOLVED/i, /Failed to load resource/i];
  return page.pageErrors.concat(page.consoleErrors.filter((e) => !noise.some((n) => n.test(e))));
}

/** Pressiona um botão via PointerEvent (o que o browser realmente faz). */
async function pressButton(page, action, holdMs = 0) {
  const sel = `button[data-action="${action}"]`;
  await page.waitForSelector(sel, { state: 'visible', timeout: 10_000 });
  await page.evaluate((sel) => {
    const btn = document.querySelector(sel);
    const r = btn.getBoundingClientRect();
    const ev = new PointerEvent('pointerdown', {
      bubbles: true, cancelable: true, composed: true,
      pointerId: 7, pointerType: 'touch', isPrimary: true,
      clientX: r.left + r.width / 2, clientY: r.top + r.height / 2,
    });
    btn.dispatchEvent(ev);
  }, sel);
  if (holdMs > 0) await page.waitForTimeout(holdMs);
  await page.evaluate((sel) => {
    const btn = document.querySelector(sel);
    const r = btn.getBoundingClientRect();
    const ev = new PointerEvent('pointerup', {
      bubbles: true, cancelable: true, composed: true,
      pointerId: 7, pointerType: 'touch', isPrimary: true,
      clientX: r.left + r.width / 2, clientY: r.top + r.height / 2,
    });
    btn.dispatchEvent(ev);
  }, sel);
}

test.before(async () => {
  server = await startServer({ port: 0 });
  browser = await chromium.launch();
});

test.after(async () => {
  await browser?.close();
  await server?.close();
});

/* ───────────────────────── 1. inicialização ──────────────────────────── */

test('1. o player carrega, o Ruffle inicializa e o SWF é interpretado', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  const info = await page.evaluate(() => ({
    temPlayer: !!document.getElementById('flashPlayer'),
    tagPlayer: document.getElementById('flashPlayer')?.tagName.toLowerCase(),
    ready: globalThis.__ddt.runtime.ready,
    started: globalThis.__ddt.runtime.started,
    erro: globalThis.__ddt.runtime.error ? String(globalThis.__ddt.runtime.error.message) : null,
    temCanvas: !!document.getElementById('flashPlayer')?.shadowRoot?.querySelector('canvas'),
    probe: globalThis.__ddt.adapter.probe(),
    tipoAdaptador: globalThis.__ddt.adapter.constructor.name,
  }));

  assert.equal(info.temPlayer, true);
  assert.equal(info.tagPlayer, 'ruffle-player');
  assert.equal(info.erro, null);
  assert.equal(info.started, true);
  assert.equal(info.temCanvas, true);
  assert.equal(info.probe.ok, true);

  await page.context().close();
});

/* ─────────────── 1b. o núcleo carrega da ORIGEM LOCAL ─────────────── */

test('1b. ?config=config.local.xml faz o core 2.png ser buscado localmente', async () => {
  const page = await newPage();
  const reqs = [];
  const statuses = [];
  page.on('request', (r) => { if (/\/(2\.png|config\.local\.xml)/.test(r.url())) reqs.push(r.url()); });
  page.on('response', (r) => { if (/\/2\.png/.test(r.url())) statuses.push(r.status()); });

  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);
  await page.waitForTimeout(4000);

  assert.ok(reqs.some((u) => u.includes('config.local.xml')), 'o SWF não recebeu a flashvar config');
  assert.ok(reqs.some((u) => u.endsWith('2.png?lv=795') || u.endsWith('2.png')), 'o core 2.png não foi pedido na origem local');
  assert.ok(statuses.includes(200), `o core respondeu com erro (statuses: ${statuses.join(',')})`);
  assert.ok(!reqs.some((u) => u.includes('sitemoderno')), 'o jogo ainda busca no CDN remoto');

  await page.context().close();
});

/* ───────── 2. PROVA: o Ruffle escuta teclado no window ───────────── */

test('2. PROVA: o Ruffle registrou listeners keydown/keyup (no window)', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  const cdp = await page.context().newCDPSession(page);
  const { result } = await cdp.send('Runtime.evaluate', { expression: 'window' });
  const { listeners } = await cdp.send('DOMDebugger.getEventListeners', { objectId: result.objectId });
  const types = listeners.map((l) => l.type);

  assert.ok(types.includes('keydown'), `Ruffle não registrou keydown. Listeners: ${types.join(', ')}`);
  assert.ok(types.includes('keyup'), `Ruffle não registrou keyup. Listeners: ${types.join(', ')}`);
  await cdp.detach();
  await page.context().close();
});

/* ───────── 3. botões geram as teclas do jogo ─────────────────────── */

test('3. os botões geram exatamente as teclas que o AS3 escuta', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  await page.evaluate(() => {
    globalThis.__keylog = [];
    for (const t of ['keydown', 'keyup']) {
      window.addEventListener(t, (e) => globalThis.__keylog.push({ type: t, key: e.key, code: e.code, keyCode: e.keyCode }), true);
    }
  });

  const esperado = [
    ['move_left', 37, 'ArrowLeft', 'ArrowLeft'],
    ['move_right', 39, 'ArrowRight', 'ArrowRight'],
    ['angle_up', 38, 'ArrowUp', 'ArrowUp'],
    ['angle_down', 40, 'ArrowDown', 'ArrowDown'],
    ['shoot', 32, ' ', 'Space'],
  ];

  for (const [action, keyCode, key, code] of esperado) {
    await pressButton(page, action);
    await page.waitForTimeout(80);
    const log = await page.evaluate(() => globalThis.__keylog.splice(0));
    const down = log.find((e) => e.type === 'keydown' && e.keyCode === keyCode);
    const up = log.find((e) => e.type === 'keyup' && e.keyCode === keyCode);
    assert.ok(down, `sem keydown(${keyCode}) para ${action}. log=${JSON.stringify(log)}`);
    assert.ok(up, `sem keyup(${keyCode}) para ${action}. log=${JSON.stringify(log)}`);
    assert.equal(down.key, key, `key divergente para ${action}`);
    assert.equal(down.code, code, `code divergente para ${action}`);
  }

  await page.context().close();
});

/* ───────── 4. movimento contínuo e interrupção ───────────────────── */

test('4. movimento contínuo gera 1 keydown e PARA no keyup', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  await page.evaluate(() => {
    globalThis.__keylog = [];
    for (const t of ['keydown', 'keyup']) {
      window.addEventListener(t, (e) => globalThis.__keylog.push({ type: t, keyCode: e.keyCode }), true);
    }
  });

  const sel = 'button[data-action="move_left"]';
  await page.waitForSelector(sel, { state: 'visible' });

  await page.evaluate((sel) => {
    const btn = document.querySelector(sel);
    const r = btn.getBoundingClientRect();
    const down = new PointerEvent('pointerdown', { bubbles: true, cancelable: true, composed: true, pointerId: 9, pointerType: 'touch', isPrimary: true, clientX: r.left + r.width / 2, clientY: r.top + r.height / 2 });
    btn.dispatchEvent(down);
  }, sel);
  await page.waitForTimeout(400);

  await page.evaluate((sel) => {
    const btn = document.querySelector(sel);
    const r = btn.getBoundingClientRect();
    const up = new PointerEvent('pointerup', { bubbles: true, cancelable: true, composed: true, pointerId: 9, pointerType: 'touch', isPrimary: true, clientX: r.left + r.width / 2, clientY: r.top + r.height / 2 });
    btn.dispatchEvent(up);
  }, sel);
  await page.waitForTimeout(200);

  const log = await page.evaluate(() => globalThis.__keylog);
  const downs = log.filter((e) => e.type === 'keydown' && e.keyCode === 37);
  const ups = log.filter((e) => e.type === 'keyup' && e.keyCode === 37);
  assert.equal(downs.length, 1, `segurar deve produzir exatamente 1 keydown. Obtido: ${downs.length} (log=${JSON.stringify(log)})`);
  assert.equal(ups.length, 1, `soltar deve produzir 1 keyup. Obtido: ${ups.length} (log=${JSON.stringify(log)})`);

  await page.context().close();
});

/* ───────── 5. barra de força ─────────────────────────────────────── */

test('5. segurar o botão de disparo carrega a força; soltar libera', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  const sel = 'button[data-action="shoot"]';
  await page.waitForSelector(sel, { state: 'visible' });
  const box = await page.locator(sel).boundingBox();

  const largura = () => page.evaluate(() => document.querySelector('.mc-meter__fill').style.width);
  assert.equal(await largura(), '0%', 'a barra começa zerada');

  await page.evaluate(({ sel }) => {
    const btn = document.querySelector(sel);
    const r = btn.getBoundingClientRect();
    const down = new PointerEvent('pointerdown', { bubbles: true, cancelable: true, composed: true, pointerId: 11, pointerType: 'touch', isPrimary: true, clientX: r.left + r.width / 2, clientY: r.top + r.height / 2 });
    btn.dispatchEvent(down);
  }, { sel });
  await page.waitForTimeout(700);

  const carregada = await largura();
  const rotulo = await page.locator('.mc-meter__label').textContent();
  assert.notEqual(carregada, '0%', 'a barra não avançou durante o carregamento');
  assert.ok(Number(rotulo) > 0, `rótulo não atualizou (valor=${rotulo})`);
  assert.ok(Number(rotulo) <= 2000, `força passou de FORCE_MAX (valor=${rotulo})`);
  assert.equal(await page.locator(sel).getAttribute('aria-pressed'), 'true');

  await page.evaluate(({ sel }) => {
    const btn = document.querySelector(sel);
    const r = btn.getBoundingClientRect();
    const up = new PointerEvent('pointerup', { bubbles: true, cancelable: true, composed: true, pointerId: 11, pointerType: 'touch', isPrimary: true, clientX: r.left + r.width / 2, clientY: r.top + r.height / 2 });
    btn.dispatchEvent(up);
  }, { sel });
  await page.waitForTimeout(150);
  assert.equal(await page.locator(sel).getAttribute('aria-pressed'), 'false');

  await page.context().close();
});

/* ───────── 6. nenhum comando fica preso ─────────────────────────── */

test('6. perda de foco libera todos os comandos', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  await page.evaluate(() => {
    globalThis.__keylog = [];
    for (const t of ['keydown', 'keyup']) {
      window.addEventListener(t, (e) => globalThis.__keylog.push({ type: t, keyCode: e.keyCode }), true);
    }
  });

  for (const action of ['move_left', 'shoot']) {
    const sel = `button[data-action="${action}"]`;
    await page.evaluate((sel) => {
      const btn = document.querySelector(sel);
      const r = btn.getBoundingClientRect();
      const down = new PointerEvent('pointerdown', { bubbles: true, cancelable: true, composed: true, pointerId: 1, pointerType: 'touch', isPrimary: true, clientX: r.left + r.width / 2, clientY: r.top + r.height / 2 });
      btn.dispatchEvent(down);
    }, sel);
  }
  await page.waitForTimeout(200);

  const ativos = await page.evaluate(() => Object.keys(globalThis.__ddt.input.snapshot()));
  assert.equal(ativos.length, 2, 'os dois comandos deveriam estar ativos');

  await page.evaluate(() => { window.dispatchEvent(new Event('blur')); });
  await page.waitForTimeout(200);

  const depois = await page.evaluate(() => ({
    snapshot: globalThis.__ddt.input.snapshot(),
    seguras: globalThis.__ddt.adapter.heldKeys,
    keyups: globalThis.__keylog.filter((e) => e.type === 'keyup').map((e) => e.keyCode),
  }));
  assert.deepEqual(depois.snapshot, {}, 'comandos continuam presos após blur');
  assert.deepEqual(depois.seguras, [], 'o adaptador ainda segura teclas');
  assert.ok(depois.keyups.includes(37), 'não foi enviado keyup de LEFT');
  assert.ok(depois.keyups.includes(32), 'não foi enviado keyup de SPACE');

  await page.context().close();
});

/* ───────── 7. host de ExternalInterface ──────────────────────────── */

test('7. o host JS implementa tudo que o ActionScript chama', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  const missing = await page.evaluate(() => {
    const called = ['IsDesktop', 'WindowReturn', 'setFlashCall', 'game_interruption', 'game_pay',
      'AddFavorite', 'setFavorite', 'getLocationUrl', 'addToFavorite', 'ExternalLoadStart',
      'alert', 'sendWeiboFeed', 'showInviteBox', 'facebookSend', 'setDailyTask',
      'setDailyActivity', 'ExitGameToLogin', 'closeWindow'];
    return called.filter((n) => typeof window[n] !== 'function');
  });
  assert.deepEqual(missing, []);

  const desktop = await page.evaluate(() => window.IsDesktop());
  assert.equal(desktop, false);

  const ticker = await page.evaluate(() => {
    window.title_effect.tickerBegin('sua vez');
    const running = window.title_effect.ticker.running;
    window.title_effect.tickerStop();
    return { running, parado: window.title_effect.ticker.running };
  });
  assert.deepEqual(ticker, { running: true, parado: false });

  await page.context().close();
});

/* ───────── 8. versão desktop preservada ──────────────────────────── */

test('8. no desktop o painel NÃO aparece e o teclado segue nativo', async () => {
  const page = await newPage({ hasTouch: false, isMobile: false, viewport: { width: 1280, height: 800 } });
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&gate=0`);

  const caps = await page.evaluate(() => globalThis.__ddt.caps);
  assert.equal(caps.touch, false);

  const visivel = await page.locator('#touchControls').isVisible();
  assert.equal(visivel, false);

  await page.context().close();
});

test('8b. ?ui=force mostra o painel no desktop sob demanda', async () => {
  const page = await newPage({ hasTouch: false, isMobile: false, viewport: { width: 1280, height: 800 } });
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  const visivel = await page.locator('#touchControls').isVisible();
  assert.equal(visivel, true);

  await page.context().close();
});

/* ───────── 9. responsividade ─────────────────────────────────────── */

test('9. layout responsivo: os controles não saem da tela em landscape', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  for (const vp of [
    { width: 844, height: 390 },
    { width: 740, height: 360 },
    { width: 1024, height: 768 },
    { width: 667, height: 375 },
  ]) {
    await page.setViewportSize(vp);
    await page.waitForTimeout(120);
    const boxes = await page.evaluate(() =>
      [...document.querySelectorAll('#touchControls .mc-btn')].map((b) => {
        const r = b.getBoundingClientRect();
        return { a: b.dataset.action, x: r.x, y: r.y, w: r.width, h: r.height, r: r.right, bt: r.bottom };
      }));
    for (const b of boxes) {
      assert.ok(b.x >= -1, `${b.a} saiu pela esquerda em ${vp.width}x${vp.height}`);
      assert.ok(b.r <= vp.width + 1, `${b.a} saiu pela direita em ${vp.width}x${vp.height}`);
      assert.ok(b.y >= -1, `${b.a} saiu pelo topo em ${vp.width}x${vp.height}`);
      assert.ok(b.bt <= vp.height + 1, `${b.a} saiu pela base em ${vp.width}x${vp.height}`);
      assert.ok(b.w >= 44 && b.h >= 44, `${b.a} tem alvo de toque pequeno demais (${b.w}x${b.h})`);
    }
  }

  await page.context().close();
});

/* ───────── 10. reinicialização ───────────────────────────────────── */

test('10. recarregar a página reinicializa sem estado residual', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  const sel = 'button[data-action="move_right"]';
  await page.evaluate((sel) => {
    const btn = document.querySelector(sel);
    const r = btn.getBoundingClientRect();
    const down = new PointerEvent('pointerdown', { bubbles: true, cancelable: true, composed: true, pointerId: 5, pointerType: 'touch', isPrimary: true, clientX: r.left + r.width / 2, clientY: r.top + r.height / 2 });
    btn.dispatchEvent(down);
  }, sel);
  await page.waitForTimeout(150);
  await page.evaluate((sel) => {
    const btn = document.querySelector(sel);
    const r = btn.getBoundingClientRect();
    const up = new PointerEvent('pointerup', { bubbles: true, cancelable: true, composed: true, pointerId: 5, pointerType: 'touch', isPrimary: true, clientX: r.left + r.width / 2, clientY: r.top + r.height / 2 });
    btn.dispatchEvent(up);
  }, sel);

  await page.reload({ waitUntil: 'domcontentloaded' });
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);

  const limpo = await page.evaluate(() => ({
    snapshot: globalThis.__ddt.input.snapshot(),
    seguras: globalThis.__ddt.adapter.heldKeys,
  }));
  assert.deepEqual(limpo.snapshot, {});
  assert.deepEqual(limpo.seguras, []);

  await page.context().close();
});

/* ───────── 11. sem erros críticos no console ─────────────────────── */

test('11. nenhum erro de JavaScript não tratado na console', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/player.html?config=config.local.xml&ui=force&gate=0`);
  await page.waitForTimeout(2500);
  const criticos = criticalErrors(page);
  assert.deepEqual(criticos, [], `erros de JS: ${criticos.join(' | ')}`);
  await page.context().close();
});

/* ───────── 12. caminho mobile/player.html ────────────────────────── */

test('12. mobile/player.html acha o SWF (bug do caminho relativo corrigido)', async () => {
  const page = await newPage();
  await waitBoot(page, `${server.url}/mobile/player.html?config=config.local.xml&ui=force&gate=0`);
  const info = await page.evaluate(() => ({
    started: globalThis.__ddt.runtime.started,
    erro: globalThis.__ddt.runtime.error ? String(globalThis.__ddt.runtime.error.message) : null,
    base: document.baseURI,
  }));
  assert.equal(info.erro, null);
  assert.equal(info.started, true);
  assert.equal(new URL(info.base).pathname, '/');
  await page.context().close();
});