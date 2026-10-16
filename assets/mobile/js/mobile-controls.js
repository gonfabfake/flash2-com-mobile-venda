/**
 * mobile-controls.js — Camada VISUAL do painel tátil.
 *
 * Regra de arquitetura (ETAPA 6): a UI não conhece teclas, não conhece Ruffle,
 * não conhece Flash. Ela só chama `input.press(ACTION.X)` / `input.release(...)`.
 * Toda a lógica de entrega é do `InputCore` + adaptadores.
 *
 * Interações implementadas por botão:
 *   - pointerdown / pointerup / pointercancel / pointerleave
 *   - setPointerCapture: o dedo pode sair do botão sem travar o comando
 *   - multi-toque real: dois botões simultâneos (andar + carregar força)
 *   - 'keydown/keyup' no próprio botão: acessibilidade (Enter/Espaço) e teste
 *     automatizado por teclado
 */

import { ACTION } from './keymap.js';
import { ForceMeter } from './force-meter.js';

const SVG_NS = 'http://www.w3.org/2000/svg';

function el(tag, className, parent) {
  const node = document.createElement(tag);
  if (className) node.className = className;
  if (parent) parent.appendChild(node);
  return node;
}

function svgIcon(pathData, parent) {
  const svg = document.createElementNS(SVG_NS, 'svg');
  svg.setAttribute('viewBox', '0 0 24 24');
  svg.setAttribute('aria-hidden', 'true');
  const path = document.createElementNS(SVG_NS, 'path');
  path.setAttribute('d', pathData);
  path.setAttribute('fill', 'currentColor');
  svg.appendChild(path);
  parent.appendChild(svg);
  return svg;
}

const ICONS = {
  left: 'M15.4 7.4 14 6l-6 6 6 6 1.4-1.4-4.6-4.6 4.6-4.6z',
  right: 'M8.6 7.4 10 6l6 6-6 6-1.4-1.4 4.6-4.6-4.6-4.6z',
  plus: 'M11 5h2v6h6v2h-6v6h-2v-6H5v-2h6V5z',
  minus: 'M5 11h14v2H5z',
  fire: 'M12 2c.6 3.2 2.4 4.3 3.7 6.1A7.4 7.4 0 0 1 17.6 13 5.6 5.6 0 0 1 12 18.6 5.6 5.6 0 0 1 6.4 13c0-2 .9-3.6 2.3-5.2.3 1 .9 1.9 1.8 2.4C9.9 8 9.4 4.6 12 2z',
  arrow: 'M12 4 3 12h4v8h10v-8h4L12 4z',
};

export class MobileControls {
  /**
   * @param {HTMLElement} root
   * @param {{input: import('./input-core.js').InputCore, forceMeter?: ForceMeter, onExit?: Function}} opts
   */
  constructor({ root, input, forceMeter, onExit = null, vibrate = null }) {
    this.root = root;
    this.input = input;
    this.force = forceMeter || new ForceMeter();
    this.onExit = onExit;
    this.vibrate = vibrate;
    this._buttons = new Map();
    this._pointerOwners = new Map(); // pointerId -> ACTION
    this._keyOwners = new Map();     // action -> 'keyboard'
    this._lastTs = 0;
    this._build();
  }

  _build() {
    const root = this.root;
    root.classList.add('mc-root');

    /* ── topo: informação de batalha (não obstrui o campo) ────────────── */
    const top = el('div', 'mc-top', root);
    const info = el('div', 'mc-info', top);
    el('span', 'mc-info__title', info).textContent = 'DDTank';
    const status = el('span', 'mc-info__status', info);
    status.textContent = 'aguardando batalha';
    this.statusEl = status;

    const actions = el('div', 'mc-top-actions', top);
    this._makeButton(actions, ACTION.TOGGLE_ARROW, 'mc-btn mc-btn--ghost', 'Mira', 'arrow');
    const exit = el('button', 'mc-btn mc-btn--ghost', actions);
    exit.type = 'button';
    exit.title = 'Menu / sair';
    exit.setAttribute('aria-label', 'Menu');
    exit.textContent = '☰';
    exit.addEventListener('click', () => this.onExit?.());

    /* ── inferior esquerdo: movimento + ângulo ─────────────────────────── */
    const left = el('div', 'mc-cluster mc-cluster--left', root);

    const move = el('div', 'mc-group', left);
    this._makeButton(move, ACTION.MOVE_LEFT, 'mc-btn mc-btn--dir', 'Mover para a esquerda', 'left', '◀');
    this._makeButton(move, ACTION.MOVE_RIGHT, 'mc-btn mc-btn--dir', 'Mover para a direita', 'right', '▶');

    const angle = el('div', 'mc-group', left);
    // Mesmo formato para os dois; só o símbolo e a ação mudam (ETAPA 3).
    this._makeButton(angle, ACTION.ANGLE_DOWN, 'mc-btn mc-btn--angle', 'Diminuir ângulo', 'minus', '−');
    this._makeButton(angle, ACTION.ANGLE_UP, 'mc-btn mc-btn--angle', 'Aumentar ângulo', 'plus', '+');

    /* ── inferior direito: força + disparo ─────────────────────────────── */
    const right = el('div', 'mc-cluster mc-cluster--right', root);

    const meter = el('div', 'mc-meter', right);
    this.meterFill = el('div', 'mc-meter__fill', meter);
    this.meterLabel = el('div', 'mc-meter__label', meter);
    this.meterLabel.textContent = '0';
    el('div', 'mc-meter__caption', meter).textContent = 'força (estimativa)';

    this._makeButton(right, ACTION.SHOOT, 'mc-btn mc-btn--fire', 'Segurar para carregar a força, soltar para disparar', 'fire', '🔥');

    /* rótulos auxiliar de movimento contínuo */
    const hint = el('div', 'mc-hint', root);
    hint.textContent = 'segure ◀ ▶ para andar · segure 🔥 e solte para disparar';
  }

  _makeButton(parent, action, className, label, iconName, glyph) {
    const btn = el('button', className, parent);
    btn.type = 'button';
    btn.dataset.action = action;
    btn.setAttribute('aria-label', label);
    btn.title = label;
    if (glyph) {
      el('span', 'mc-btn__glyph', btn).textContent = glyph;
    } else {
      svgIcon(ICONS[iconName] || '', btn);
    }
    this._bind(btn, action);
    this._buttons.set(action, btn);
    return btn;
  }

  _bind(btn, action) {
    const press = (source) => {
      btn.classList.add('is-pressed');
      btn.setAttribute('aria-pressed', 'true');
      this.input.press(action, source);
      if (action === ACTION.SHOOT) this.force.start();
      this._buzz(12);
    };
    const release = (source) => {
      btn.classList.remove('is-pressed');
      btn.setAttribute('aria-pressed', 'false');
      if (action === ACTION.SHOOT) this.force.release();
      this.input.release(action, source);
    };

    btn.addEventListener('pointerdown', (ev) => {
      ev.preventDefault();
      try { btn.setPointerCapture(ev.pointerId); } catch { /* mouse legado */ }
      this._pointerOwners.set(ev.pointerId, action);
      press(`pointer:${ev.pointerId}`);
    }, { passive: false });

    const endPointer = (ev) => {
      if (!this._pointerOwners.has(ev.pointerId)) return;
      this._pointerOwners.delete(ev.pointerId);
      try { btn.releasePointerCapture(ev.pointerId); } catch { /* já liberado */ }
      release(`pointer:${ev.pointerId}`);
    };
    btn.addEventListener('pointerup', endPointer);
    btn.addEventListener('pointercancel', endPointer);
    btn.addEventListener('lostpointercapture', endPointer);

    // acessibilidade / teste por teclado
    btn.addEventListener('keydown', (ev) => {
      if (ev.repeat || (ev.key !== 'Enter' && ev.key !== ' ')) return;
      ev.preventDefault();
      this._keyOwners.set(action, true);
      press('keyboard');
    });
    btn.addEventListener('keyup', (ev) => {
      if (ev.key !== 'Enter' && ev.key !== ' ') return;
      ev.preventDefault();
      this._keyOwners.delete(action);
      release('keyboard');
    });
    btn.addEventListener('blur', () => { if (this._keyOwners.delete(action)) release('keyboard'); });
  }

  _buzz(ms) {
    if (this.vibrate) { try { this.vibrate(ms); } catch { /* sem permissão */ } }
  }

  /** Chamado a cada frame pelo loop principal. */
  tick(ts) {
    const dt = this._lastTs ? Math.min(ts - this._lastTs, 250) : 0;
    this._lastTs = ts;

    this.force.tick(dt);
    this.meterFill.style.width = `${(this.force.ratio * 100).toFixed(1)}%`;
    this.meterLabel.textContent = String(this.force.display);
    // cor muda com a força: dá feedback visual sem poluir o campo de batalha
    this.meterFill.dataset.level =
      this.force.ratio > 0.75 ? 'max' : this.force.ratio > 0.4 ? 'mid' : 'low';
    const fire = this._buttons.get(ACTION.SHOOT);
    if (fire) fire.classList.toggle('is-charging', this.force.charging);
  }

  /** Solta tudo (blur, mudança de aba, desmontagem, reinício). */
  releaseAll() {
    this._pointerOwners.clear();
    this._keyOwners.clear();
    this.force.cancel();
    for (const btn of this._buttons.values()) {
      btn.classList.remove('is-pressed', 'is-charging');
      btn.setAttribute('aria-pressed', 'false');
    }
  }

  setStatus(text) {
    if (this.statusEl) this.statusEl.textContent = text;
  }

  show() {
    this.root.removeAttribute('hidden');
    // ETAPA 5: no desktop (pointer:fine) o CSS esconde o painel por padrão
    // e só o reexibe com data-force="1". show() é chamado apenas quando
    // shouldShowTouchControls() foi verdadeiro (incluindo ?ui=force), então
    // marcamos o flag aqui para que o painel apareça sob demanda no desktop.
    this.root.dataset.force = '1';
  }
  hide() {
    this.root.setAttribute('hidden', '');
    delete this.root.dataset.force;
  }
}