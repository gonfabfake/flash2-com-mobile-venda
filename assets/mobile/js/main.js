/**
 * main.js — Bootstrap do runtime: Ruffle + bridge + entrada + painel.
 *
 * Ordem importa:
 *   1. instalar o host de ExternalInterface  → o SWF já chama `IsDesktop`
 *      no primeiro frame; se a função não existir, o log fica com erro.
 *   2. sondar capacidades                   → escolher UI e adaptador.
 *   3. montar o Ruffle                      → obter o elemento do player.
 *   4. sondar o adaptador de entrada        → só habilita o painel se passar.
 *   5. instalar proteções de foco           → impede comando preso.
 *
 * Tudo é opcional: sem painel tátil, o jogo continua funcionando no teclado,
 * exatamente como antes (ETAPA 5).
 */

import { installFlashHostBridge } from './flash-host-bridge.js';
import { RuffleRuntime, parseMovieParams } from './ruffle-runtime.js';
import { InputCore } from './input-core.js';
import { KeyEventAdapter } from './adapters/key-event-adapter.js';
import { ExternalInterfaceAdapter } from './adapters/external-interface-adapter.js';
import { MobileControls } from './mobile-controls.js';
import { ForceMeter } from './force-meter.js';
import { detectCapabilities, shouldShowTouchControls, Capability } from './capabilities.js';
import { ZoomPan } from './zoom-pan.js';
import { ZoomPan } from './zoom-pan.js';

const qs = (sel) => document.querySelector(sel);

/** Coletor de diagnóstico — vira o painel de logs em `?debug=1`. */
class Diagnostics {
  constructor(limit = 400) { this.entries = []; this.limit = limit; }
  record(entry) {
    this.entries.push({ ...entry, at: Date.now() });
    if (this.entries.length > this.limit) this.entries.shift();
    const sink = qs('#diagPanel');
    if (sink && !sink.hasAttribute('hidden')) {
      const line = document.createElement('div');
      line.className = 'diag-line';
      line.textContent = `[${entry.source}] ${entry.event} ${JSON.stringify(
        Object.fromEntries(Object.entries(entry).filter(([k]) => k !== 'source' && k !== 'event')))}`;
      sink.appendChild(line);
      sink.scrollTop = sink.scrollHeight;
    }
  }
  render() {
    const sink = qs('#diagPanel');
    if (!sink) return;
    sink.innerHTML = '';
    for (const e of this.entries.slice(-150)) {
      const line = document.createElement('div');
      line.className = 'diag-line';
      line.textContent = `[${e.source}] ${e.event} ${JSON.stringify(
        Object.fromEntries(Object.entries(e).filter(([k]) => k !== 'source' && k !== 'event')))}`;
      sink.appendChild(line);
    }
  }
}

export async function bootstrap({ location = globalThis.location, document: doc = document } = {}) {
  const diag = new Diagnostics();
  const log = (msg, extra) => diag.record({ source: 'app', event: msg, ...extra });

  /* 1 ── host de ExternalInterface */
  const forcedDesktop = new URLSearchParams(location.search).get('desktop') === '1';
  const bridge = installFlashHostBridge({
    scope: globalThis,
    diagnostics: diag,
    isDesktop: forcedDesktop,
  });
  bridge.onInterruption = (url, message) => {
    showModal({
      title: 'Conexão encerrada',
      body: message || 'A sessão foi encerrada pelo servidor ou a conexão caiu.',
      actions: [{ label: 'Voltar ao login', primary: true, onClick: () => bridge._navigate(url || location.href, 'interruption') }],
    });
  };
  bridge.onAlert = (message) => showToast(message);

  log('bridge instalado', { funcoes: bridge.installedNames.length });

  /* 2 ── capacidades */
  const caps = detectCapabilities();
  const showTouch = shouldShowTouchControls(caps, { search: location.search });
  log('capacidades', { touch: caps[Capability.TOUCH], pointerFino: caps[Capability.POINTER_FINE], painel: showTouch });

  /* 3 ── Ruffle */
  const { swf, vars } = parseMovieParams(location.search);
  const runtime = new RuffleRuntime({ scope: globalThis, log });
  const stage = qs('#stage');

  let bootError = null;
  try {
    await runtime.mount(stage, { url: swf, parameters: vars });
  } catch (err) {
    bootError = err;
    log('falha ao carregar o SWF', { erro: String(err && err.message) });
    showFatal(err);
  }

  /* 4 ── adaptador de entrada (precedência: bridge AS3 > teclado) */
  const ei = new ExternalInterfaceAdapter().detect();
  const adapter = ei.available
    ? ei
    : new KeyEventAdapter({ target: runtime.playerElement, targetType: 'ruffle' });

  const probe = adapter.probe();
  log('adaptador de entrada', { tipo: ei.available ? 'external-interface' : 'key-event', ...probe });

  const input = new InputCore({
    onChange: (action, pressed, source) => {
      adapter[pressed ? 'press' : 'release'](action, source);
      log(pressed ? 'press' : 'release', { action, source });
    },
  });

  // Zoom/pan sobre a área do jogo: torna os botões INTERNOS do SWF tocáveis.
  const stageWrap = qs('#stageWrap');
  const zoomPan = new ZoomPan({
    target: stageWrap,
    onChange: (scale) => {
      const el = qs('#zoomIndicator');
      if (el) { el.textContent = scale > 1.01 ? `${scale.toFixed(1)}×` : ''; el.toggleAttribute('hidden', scale <= 1.01); }
    },
  });

  const controls = showTouch && !bootError
    ? new MobileControls({
      root: qs('#touchControls'),
      input,
      forceMeter: new ForceMeter(),
      zoomPan,
      vibrate: caps[Capability.VIBRATION] ? (ms) => navigator.vibrate(ms) : null,
      onExit: () => showExitMenu(bridge, location),
    })
    : null;
  if (controls) controls.show();
  else qs('#touchControls')?.setAttribute('hidden', '');

  /* 5 ── proteções contra comando preso */
  const panicRelease = (reason) => {
    const n = input.releaseAll(reason);
    adapter.releaseAll?.();
    controls?.releaseAll();
    if (n) log('liberação forçada', { motivo: reason, acoes: n });
  };
  globalThis.addEventListener('blur', () => panicRelease('blur'));
  globalThis.addEventListener('pagehide', () => panicRelease('pagehide'));
  doc.addEventListener('visibilitychange', () => { if (doc.hidden) panicRelease('hidden'); });
  // rede de segurança: varredura periódica
  setInterval(() => input.sweep(), 1000);

  /* 6 ── loop */
  const frame = (ts) => { controls?.tick(ts); requestAnimationFrame(frame); };
  requestAnimationFrame(frame);

  /* 7 ── tela cheia / orientação */
  installFullscreenAndOrientation({ caps, doc, log });
  installStartGate({ runtime, caps, log });

  /* 8 ── diagnóstico (?debug=1) */
  const params = new URLSearchParams(location.search);
  if (params.get('debug') === '1') {
    const panel = qs('#diagPanel');
    panel.removeAttribute('hidden');
    diag.render();
  }

  // Superfície para testes automatizados e diagnóstico manual.
  globalThis.__ddt = { runtime, bridge, adapter, input, controls, caps, diag, panicRelease, zoomPan };
  log('bootstrap concluído', { swf, toque: showTouch });
  return globalThis.__ddt;
}

/* ─────────────────────────── UI auxiliar ─────────────────────────────── */

function showToast(message) {
  const host = qs('#toastHost') || document.body;
  const node = document.createElement('div');
  node.className = 'toast';
  node.textContent = message;
  host.appendChild(node);
  setTimeout(() => node.remove(), 4200);
}

function showModal({ title, body, actions = [] }) {
  const host = qs('#modalHost') || document.body;
  host.innerHTML = '';
  const back = document.createElement('div');
  back.className = 'modal-backdrop';
  const box = document.createElement('div');
  box.className = 'modal';
  const h = document.createElement('h2');
  h.textContent = title;
  const p = document.createElement('p');
  p.textContent = body;
  box.append(h, p);
  for (const a of actions) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = a.primary ? 'modal__btn modal__btn--primary' : 'modal__btn';
    btn.textContent = a.label;
    btn.addEventListener('click', () => { host.innerHTML = ''; a.onClick?.(); });
    box.appendChild(btn);
  }
  back.appendChild(box);
  host.appendChild(back);
  return back;
}

function showExitMenu(bridge, location) {
  showModal({
    title: 'Menu',
    body: 'O que deseja fazer?',
    actions: [
      { label: 'Tela cheia', onClick: () => toggleFullscreen() },
      { label: 'Recarregar', onClick: () => location.reload() },
      { label: 'Voltar ao início', primary: true, onClick: () => bridge._navigate(location.href, 'menu') },
    ],
  });
}

function showFatal(err) {
  showModal({
    title: 'Não foi possível iniciar o jogo',
    body: String(err && err.message ? err.message : err),
    actions: [{ label: 'Recarregar', primary: true, onClick: () => location.reload() }],
  });
}

async function toggleFullscreen() {
  try {
    if (document.fullscreenElement) await document.exitFullscreen();
    else await document.documentElement.requestFullscreen({ navigationUI: 'hide' });
  } catch { /* gesto não permitido */ }
}

function installFullscreenAndOrientation({ caps, doc, log }) {
  const stage = doc.getElementById('stageWrap');
  const applyOrientation = async () => {
    // Landscape só pode ser travado dentro de fullscreen + gesto do usuário.
    if (!doc.fullscreenElement) return;
    if (!caps[Capability.SCREEN_ORIENTATION_LOCK]) return;
    try { await screen.orientation.lock('landscape'); log('orientação travada em landscape'); }
    catch (e) { log('orientation.lock negado', { erro: String(e && e.name) }); }
  };
  doc.addEventListener('fullscreenchange', applyOrientation);
  doc.addEventListener('click', () => {
    if (!doc.fullscreenElement && caps[Capability.FULLSCREEN]) toggleFullscreen();
  });
  // aviso de rotação em retrato
  const rotateHint = doc.getElementById('rotateHint');
  const checkOrientation = () => {
    if (!rotateHint) return;
    const portrait = window.innerHeight > window.innerWidth;
    const small = Math.min(window.innerWidth, window.innerHeight) < 560;
    rotateHint.toggleAttribute('hidden', !(portrait && small));
  };
  window.addEventListener('resize', checkOrientation);
  window.addEventListener('orientationchange', () => setTimeout(checkOrientation, 250));
  checkOrientation();
  if (stage) stage.addEventListener('contextmenu', (e) => e.preventDefault());
}

function installStartGate({ runtime, caps, log }) {
  // Política de autoplay: o áudio só destrava com gesto do usuário.
  // No desktop não mostramos gate — seria uma tela desnecessária e mudaria
  // o comportamento do player original (ETAPA 5). Em touch, o gate é
  // obrigatório: sem o primeiro toque o navegador bloqueia o áudio e o
  // fullscreen é negado.
  const gate = document.getElementById('startGate');
  if (!gate) return;
  const forced = new URLSearchParams(location.search).get('gate');
  const shouldShow = caps[Capability.TOUCH] || forced === '1';
  if (!shouldShow) { gate.remove(); return; }

  gate.removeAttribute('hidden');
  const go = async () => {
    gate.remove();
    runtime.focus();
    try {
      await document.documentElement.requestFullscreen({ navigationUI: 'hide' });
      log('fullscreen após gesto');
    } catch { /* sem gesto válido: segue em janela */ }
  };
  gate.addEventListener('click', go, { once: true });
  if (!caps[Capability.VIBRATION]) gate.dataset.haptic = 'off';
}

/* Arranque automático quando carregado como módulo. */
if (typeof document !== 'undefined' && document.currentScript === null) {
  const auto = new URLSearchParams(location.search).get('auto');
  if (auto !== '0') {
    bootstrap().catch((err) => console.error('[ddt] bootstrap falhou', err));
  }
}