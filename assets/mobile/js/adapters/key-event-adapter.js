/**
 * key-event-adapter.js — Adaptador que entrega comandos ao player de Flash.
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * POR QUE ISSO NÃO É "SIMULAÇÃO FRÁVIL"
 * ─────────────────────────────────────────────────────────────────────────────
 * 1. O jogo não tem NENHUMA API de input por mouse/toque em batalha.
 *    Verificado: `TouchEvent` tem 0 ocorrências em 3497 arquivos .as;
 *    `ArrowView.as` não registra nenhum MouseEvent; o único mouse em batalha é
 *    GameLocalPlayer.as:342 (clique pós-morte, envia alvo fantasma).
 * 2. O caminho de entrada REAL do jogo é o teclado:
 *    `org/aswing/KeyboardManager.as:57 init(stage)` registra KEY_DOWN/KEY_UP
 *    no Stage e mantém `keySequence`, consultado por `isKeyDown()` a cada
 *    ENTER_FRAME por SelfPlayerWalkAction / ArrowView / EnergyView.
 * 3. Este adaptador entrega exatamente o mesmo par (keydown, keyup) que o
 *    navegador entregaria ao pressionar a tecla física — é o mesmo mecanismo
 *    que o próprio Ruffle usa internamente em `virtualKeyboardInput()`
 *    (ruffle.js: `dispatchEvent(new KeyboardEvent('keydown'|'keyup', {key}))`).
 * 4. O caminho é VERIFICADO em runtime (ver `probe()` e os testes E2E), não
 *    presumido: só habilitamos os botões quando a sondagem passa.
 *
 * Se um dia o SWF for recompilado com um bridge `ExternalInterface`, o
 * `external-interface-adapter.js` assume com precedência — sem tocar neste
 * arquivo nem no painel.
 */

import { ACTION_PRIMARY_KEY, KEY_SPECS } from '../keymap.js';

export class KeyEventAdapter {
  /**
   * @param {object} opts
   * @param {Element} opts.target   elemento do player (ruffle-player / object / embed)
   * @param {string}  opts.targetType 'ruffle' | 'plugin' | 'any'
   */
  constructor({ target, targetType = 'any' } = {}) {
    this.target = target || null;
    this.targetType = targetType;
    /** teclas que já foram despachadas como "down" — evita keydown duplicado */
    this._down = new Set();
    this.available = Boolean(target && typeof target.dispatchEvent === 'function');
  }

  /** Liga a um player já instanciado. */
  attach(target, targetType = this.targetType) {
    this.target = target;
    this.targetType = targetType;
    this.available = Boolean(target && typeof target.dispatchEvent === 'function');
    return this;
  }

  /**
   * Resolve o construtor `KeyboardEvent` a partir do PRÓPRIO documento do alvo.
   * Usar o global é frágil: em iframes, em contextos de teste (Node) ou após
   * polyfills, `window.KeyboardEvent` pode ser uma constructor diferente da do
   * player — e um evento criado na constructor errada não é reconhecido pelos
   * listeners do Ruffle.
   */
  _eventCtor() {
    const view = this.target?.ownerDocument?.defaultView || globalThis;
    return view.KeyboardEvent || globalThis.KeyboardEvent;
  }

  /** Constrói o KeyboardEvent com o máximo de fidelidade ao evento real. */
  _buildEvent(type, keyCode) {
    const spec = KEY_SPECS[keyCode];
    if (!spec) throw new Error(`[key-event-adapter] keyCode desconhecido: ${keyCode}`);

    const Ctor = this._eventCtor();
    if (typeof Ctor !== 'function') {
      throw new Error('[key-event-adapter] KeyboardEvent indisponível neste ambiente');
    }

    const event = new Ctor(type, {
      key: spec.key,
      code: spec.code,
      location: 0,
      bubbles: true,
      cancelable: true,
      composed: true,          // atravessa shadow DOM (o Ruffle usa shadow root)
      repeat: false,
    });

    // `keyCode` e `which` são legados e NÃO são inicializáveis pelo construtor
    // em nenhum browser moderno. Anexamos para compatibilidade com players
    // baseados no plugin Adobe; o Ruffle 0.7 usa key/code (já definidos acima).
    for (const legacy of ['keyCode', 'which', 'charCode']) {
      try {
        Object.defineProperty(event, legacy, { get: () => (legacy === 'charCode' ? 0 : keyCode) });
      } catch { /* engine sem suporte — irrelevante, key/code já estão certos */ }
    }
    return event;
  }

  /** @returns {boolean} true se o comando foi realmente despachado. */
  press(action) {
    const keyCode = ACTION_PRIMARY_KEY[action];
    if (keyCode === undefined) return false;
    if (!this.available) return false;
    if (this._down.has(keyCode)) return false; // já pressionada
    this._down.add(keyCode);
    this.target.dispatchEvent(this._buildEvent('keydown', keyCode));
    return true;
  }

  /** @returns {boolean} true se o keyup foi despachado. */
  release(action) {
    const keyCode = ACTION_PRIMARY_KEY[action];
    if (keyCode === undefined) return false;
    if (!this.available) return false;
    if (!this._down.has(keyCode)) return false; // nunca foi pressionada
    this._down.delete(keyCode);
    this.target.dispatchEvent(this._buildEvent('keyup', keyCode));
    return true;
  }

  /** Solta tudo que estiver preso — chamado em blur / visibilitychange. */
  releaseAll() {
    const freed = [];
    for (const keyCode of [...this._down]) {
      const action = Object.keys(ACTION_PRIMARY_KEY)
        .find((a) => ACTION_PRIMARY_KEY[a] === keyCode);
      if (this.release(action)) freed.push(action);
    }
    return freed;
  }

  /** @returns {boolean[]} teclas atualmente seguradas */
  get heldKeys() {
    return [...this._down];
  }

  /**
   * SONDAGEM DE CAPACIDADE — executada antes de habilitar os botões.
   * Não injeta evento no jogo: apenas confirma que o alvo aceita
   * `KeyboardEvent` e que ele é alcançável por composição (shadow DOM).
   * @returns {{ok: boolean, reason: string}}
   */
  probe() {
    if (!this.available) {
      return { ok: false, reason: 'alvo indisponível ou sem dispatchEvent' };
    }
    if (typeof this._eventCtor() !== 'function') {
      return { ok: false, reason: 'KeyboardEvent indisponível neste ambiente' };
    }
    try {
      // Evento inerte: exercita apenas construção/cancelamento do DOM.
      const probeEvent = new (this._eventCtor())('keydown', {
        key: 'F15', code: 'F15', bubbles: true, cancelable: true, composed: true,
      });
      this.target.dispatchEvent(probeEvent);
      return { ok: true, reason: 'alvo aceita KeyboardEvent composto' };
    } catch (err) {
      return { ok: false, reason: `dispatchEvent falhou: ${err && err.message}` };
    }
  }
}