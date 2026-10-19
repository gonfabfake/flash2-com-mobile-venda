/**
 * tests/unit/capabilities.test.mjs
 * Regra do projeto: detectar por CAPACIDADE medida, nunca por user-agent.
 */

import test from 'node:test';
import assert from 'node:assert/strict';

import {
  detectCapabilities, shouldShowTouchControls, requiresUserGestureForFullscreen,
  Capability,
} from '../../assets/mobile/js/capabilities.js';

function fakeWindow({ coarse = true, fine = false, noHover = true, touchPoints = 5 } = {}) {
  const media = (q) => ({
    matches: q.includes('coarse') ? coarse : q.includes('fine') ? fine : noHover,
  });
  return {
    navigator: { maxTouchPoints: touchPoints, userAgent: 'fake', platform: 'Linux armv8l' },
    matchMedia: media,
    innerWidth: 844, innerHeight: 390,
    devicePixelRatio: 3,
  };
}

const fakeDoc = { documentElement: {}, fullscreenEnabled: true };

test('detecta toque em celular', () => {
  const c = detectCapabilities({ win: fakeWindow(), doc: fakeDoc });
  assert.equal(c[Capability.TOUCH], true);
  assert.equal(c[Capability.POINTER_FINE], false);
});

test('não detecta toque em desktop com mouse', () => {
  const c = detectCapabilities({
    win: fakeWindow({ coarse: false, fine: true, noHover: false, touchPoints: 0 }),
    doc: fakeDoc,
  });
  assert.equal(c[Capability.TOUCH], false);
  assert.equal(c[Capability.POINTER_FINE], true);
});

test('painel tátil aparece em celular e some no desktop', () => {
  const phone = detectCapabilities({ win: fakeWindow(), doc: fakeDoc });
  const desk = detectCapabilities({
    win: fakeWindow({ coarse: false, fine: true, noHover: false, touchPoints: 0 }),
    doc: fakeDoc,
  });
  assert.equal(shouldShowTouchControls(phone, { search: '' }), true);
  assert.equal(shouldShowTouchControls(desk, { search: '' }), false);
});

test('?ui=force e ?ui=off sobrepõem a detecção (ETAPA 5: teste sob demanda)', () => {
  const desk = detectCapabilities({
    win: fakeWindow({ coarse: false, fine: true, noHover: false, touchPoints: 0 }),
    doc: fakeDoc,
  });
  assert.equal(shouldShowTouchControls(desk, { search: '?ui=force' }), true);
  assert.equal(shouldShowTouchControls(desk, { search: '?ui=off' }), false);
});

test('tablet com teclado (touch + pointer fino) não duplica o painel', () => {
  const tablet = detectCapabilities({
    win: fakeWindow({ coarse: true, fine: true, noHover: false, touchPoints: 10 }),
    doc: fakeDoc,
  });
  assert.equal(shouldShowTouchControls(tablet, { search: '' }), false);
});

test('iPad Pro se declara Macintosh: só a medição salva', () => {
  // userAgent mente ("Macintosh"), maxTouchPoints e pointer:coarse não.
  const win = {
    navigator: { maxTouchPoints: 5, userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X)', platform: 'MacIntel' },
    matchMedia: (q) => ({ matches: q.includes('coarse') }),
    innerWidth: 1024, innerHeight: 768, devicePixelRatio: 2,
  };
  const c = detectCapabilities({ win, doc: fakeDoc });
  assert.equal(c[Capability.TOUCH], true);
  assert.equal(requiresUserGestureForFullscreen(win), true);
});