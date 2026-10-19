/**
 * input-core.js — Núcleo semântico de entrada. SEM DOM, SEM dependências.
 *
 * Responsabilidade única: manter o estado "quais ações estão ativas" e gerar
 * eventos de borda (press / release). Nenhuma regra do jogo é replicada aqui —
 * o núcleo apenas diz "o usuário está segurando MOVER_ESQUERDA". Quem decide
 * o que isso significa no jogo é o próprio SWF (via teclado ou bridge).
 *
 * Pensado para:
 *   - ser testável em Node (node:test) sem browser;
 *   - ser compartilhado entre mouse, toque, teclado e gamepad;
 *   - garantir que NENHUM comando fique preso (blur, visibilidade, cancelamento).
 */

import { ACTION } from './keymap.js';

/** Teclas com comportamento de "segurar" (exigem keyup para cancelar). */
export const HOLD_ACTIONS = Object.freeze([
  ACTION.MOVE_LEFT,
  ACTION.MOVE_RIGHT,
  ACTION.ANGLE_UP,
  ACTION.ANGLE_DOWN,
  ACTION.SHOOT,
]);

/** Ações instantâneas (disparam no press e liberam sozinhas). */
export const TAP_ACTIONS = Object.freeze([ACTION.TOGGLE_ARROW]);

/**
 * Estado de segurança: se uma ação ficar presa por mais que isso sem um
 * "release" correspondente, forçamos a liberação. Protege contra
 * pointercancel perdido, troca de aba no celular e abort do navegador.
 */
export const DEFAULT_STUCK_TIMEOUT_MS = 4000;

export class InputCore {
  /**
   * @param {object}   opts
   * @param {Function} opts.onChange        (action, pressed, source) => void
   * @param {number}   [opts.stuckTimeoutMs]
   * @param {Function} [opts.now]           injetável para testes determinísticos
   */
  constructor({ onChange = () => {}, stuckTimeoutMs = DEFAULT_STUCK_TIMEOUT_MS, now = null } = {}) {
    this._onChange = onChange;
    this._stuckTimeoutMs = stuckTimeoutMs;
    this._now = now || (() => Date.now());
    /** @type {Map<string, {source: string, since: number}>} */
    this._active = new Map();
    /** @type {Set<Function>} */
    this._listeners = new Set();
    /** @type {Map<string, number>} */
    this._stuckWatch = new Map();
  }

  /** Assina mudanças de estado (usado pela UI para atualizar classes CSS). */
  subscribe(fn) {
    this._listeners.add(fn);
    return () => this._listeners.delete(fn);
  }

  _emit(action, pressed, source) {
    this._onChange(action, pressed, source);
    for (const fn of this._listeners) {
      try { fn(action, pressed, source); } catch (err) { console.error('[input-core]', err); }
    }
  }

  isActive(action) {
    return this._active.has(action);
  }

  /** Snapshot serializável (diagnóstico / HUD / testes). */
  snapshot() {
    return Object.fromEntries([...this._active.entries()].map(([k, v]) => [k, { ...v }]));
  }

  get activeCount() {
    return this._active.size;
  }

  /**
   * Pressiona uma ação. Idempotente — pressionar duas vezes não duplica.
   * Uma ação já ativa por outra fonte (ex.: dedo + gamepad) troca de dono.
   */
  press(action, source = 'unknown') {
    if (!ACTION[action.toUpperCase()] && !Object.values(ACTION).includes(action)) return false;
    const previous = this._active.get(action);
    if (previous && previous.source === source) return false;

    this._active.set(action, { source, since: this._now() });
    this._stuckWatch.set(action, this._now() + this._stuckTimeoutMs);
    this._emit(action, true, source);

    if (TAP_ACTIONS.includes(action)) {
      // Ação instantânea: solta no próximo tick para não ficar presa.
      queueMicrotask(() => this.release(action, source));
    }
    return true;
  }

  /**
   * Solta uma ação. Só solta se `source` for o dono atual — evita que um
   * "pointerup" tardio de um dedo cancele o comando de outro dispositivo.
   */
  release(action, source = null) {
    const current = this._active.get(action);
    if (!current) return false;
    if (source && current.source !== source) return false;

    this._active.delete(action);
    this._stuckWatch.delete(action);
    this._emit(action, false, current.source);
    return true;
  }

  /** Solta tudo. Usado em blur, mudança de visibilidade e desmontagem. */
  releaseAll(reason = 'release-all') {
    const items = [...this._active.entries()];
    this._active.clear();
    this._stuckWatch.clear();
    for (const [action, info] of items) {
      this._emit(action, false, `${info.source}:${reason}`);
    }
    return items.length;
  }

  /**
   * Varredura anti-comando-PRESO. Deve ser chamada periodicamente
   * (requestAnimationFrame). Retorna as ações que foram liberadas.
   */
  sweep() {
    const now = this._now();
    const freed = [];
    for (const [action, deadline] of [...this._stuckWatch.entries()]) {
      if (now >= deadline) {
        freed.push(action);
        this.release(action);
      }
    }
    return freed;
  }
}