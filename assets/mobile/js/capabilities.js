/**
 * capabilities.js — Detecção de RECURSOS (nunca de user-agent).
 *
 * Princípio do projeto: decidir por o que a plataforma FAZ, não por quem ela
 * afirma ser. Um iPad Pro reporta "Macintosh" no UA; um Chrome em modo desktop
 * reporta "Windows". Só a medição de comportamento é confiável.
 */

export const Capability = Object.freeze({
  TOUCH: 'touch',
  POINTER_FINE: 'pointerFine',
  HOVER: 'hover',
  FULLSCREEN: 'fullscreen',
  SCREEN_ORIENTATION_LOCK: 'screenOrientationLock',
  VIBRATION: 'vibration',
  CLIPBOARD: 'clipboard',
  WEBSOCKET: 'websocket',
  WASM: 'wasm',
  EXTERNAL_INTERFACE_HOST: 'externalInterfaceHost',
});

function hasTouch(doc, nav) {
  return ('ontouchstart' in (doc.documentElement || {}) && nav.maxTouchPoints > 0)
    || nav.maxTouchPoints > 1;
}

export function detectCapabilities({ win = globalThis, doc = globalThis.document } = {}) {
  const nav = win.navigator || {};
  const coarse = (win.matchMedia || (() => ({ matches: false })))('(pointer: coarse)').matches;
  const fine = (win.matchMedia || (() => ({ matches: false })))('(pointer: fine)').matches;
  const noHover = (win.matchMedia || (() => ({ matches: false })))('(hover: none)').matches;

  return {
    [Capability.TOUCH]: hasTouch(doc, nav) || coarse,
    [Capability.POINTER_FINE]: Boolean(fine),
    [Capability.HOVER]: !noHover && Boolean(fine),
    [Capability.FULLSCREEN]:
      Boolean(doc.fullscreenEnabled ?? doc.webkitFullscreenEnabled),
    [Capability.SCREEN_ORIENTATION_LOCK]:
      Boolean(nav.screen?.orientation?.lock),
    [Capability.VIBRATION]: typeof nav.vibrate === 'function',
    [Capability.CLIPBOARD]: Boolean(nav.clipboard?.writeText),
    [Capability.WEBSOCKET]: typeof win.WebSocket === 'function',
    [Capability.WASM]: typeof win.WebAssembly === 'object' && Boolean(nav.userAgent),
    [Capability.EXTERNAL_INTERFACE_HOST]: true,
    // derivados
    coarse,
    touchPoints: nav.maxTouchPoints || 0,
    dpr: win.devicePixelRatio || 1,
    viewport: { width: win.innerWidth || 0, height: win.innerHeight || 0 },
  };
}

/**
 * Decide se o painel tátil deve ser exibido.
 * Regra: mostra quando há toque E NÃO há cursor fino (desktop com touchscreen
 * não ganha dois painéis sobrepostos). `?ui=force|auto|off` sobrepõe.
 */
export function shouldShowTouchControls(caps, { search = '' } = {}) {
  const forced = new URLSearchParams(search).get('ui');
  if (forced === 'force') return true;
  if (forced === 'off') return false;
  return caps[Capability.TOUCH] && !caps[Capability.POINTER_FINE];
}

/** Detecta se o SO exige pedido de tela cheia com gesto (iOS/Safari). */
export function requiresUserGestureForFullscreen(win = globalThis) {
  const nav = win.navigator || {};
  const ua = String(nav.userAgent || '');
  const iOSLike = /iPad|iPhone|iPod/.test(ua)
    || (nav.platform === 'MacIntel' && (nav.maxTouchPoints || 0) > 1);
  return iOSLike;
}