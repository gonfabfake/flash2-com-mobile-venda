/**
 * external-interface-adapter.js — Adaptador preferencial via bridge AS3.
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * ESTADO ATUAL: INATIVO por ausência de bridge no SWF publicado.
 * ─────────────────────────────────────────────────────────────────────────────
 * O `2.swf`/`2.png` publicado NÃO registra nenhum callback de controle de
 * batalha. Auditoria completa: as únicas funções expostas pelo AS3 são
 * `SetIsDesktop`, `sendSwfNowUrl`, `setLoginType`, `checkComplete`,
 * `deleteComplete`, `flashGotoAndPlay`, `setSound`, `sinaCallBack`,
 * `swfExitPrompt`, `SetFlashLoadExternal` e `ExternalLoadStop`
 * — nenhuma delas é um comando de batalha (ver AUDITORIA.md §4).
 *
 * QUANDO ATIVAR: recompile o core incluindo `assets/mobile/as3/MobileInputBridge.as`
 * (já fornecido neste projeto) e chame-o a partir de `ddt/DDT.setup()`.
 * Aí este adaptador assume automaticamente, com precedência sobre o teclado,
 * e o painel mobile passa a chamar MÉTODOS DO PRÓPRIO JOGO
 * (LocalPlayer.manuallySetGunAngle / beginShoot / sendShootAction),
 * sem duplicar regra nenhuma e sem depender de evento de teclado.
 *
 * A implementação aqui é completa e testável: basta expor
 * `window.__ddt_mobile_bridge__ = true` (ou registrar o callback no SWF).
 */

export class ExternalInterfaceAdapter {
  constructor({ bridge = globalThis, actions = null } = {}) {
    this.bridge = bridge;
    this.actions = actions; // callbacks: { moveLeft, moveRight, angleUp, ... }
    this.available = false;
    this._down = new Set();
  }

  /** Instala um objeto de callbacks vindo do AS3. */
  connect(actions) {
    this.actions = actions;
    this.available = typeof actions?.moveLeft === 'function'
      && typeof actions?.angleUp === 'function'
      && typeof actions?.beginShoot === 'function';
    return this;
  }

  /** Só fica disponível se o SWF tiver registrado a bridge. Retorna boolean. */
  detect() {
    if (globalThis.__ddt_mobile_bridge__ && typeof this.bridge.ddtMoveLeft === 'function') {
      this.connect({
        moveLeft: (...a) => this.bridge.ddtMoveLeft(...a),
        moveRight: (...a) => this.bridge.ddtMoveRight(...a),
        angleUp: (...a) => this.bridge.ddtAngleUp(...a),
        angleDown: (...a) => this.bridge.ddtAngleDown(...a),
        releaseAngle: (...a) => (this.bridge.ddtReleaseAngle
          ? this.bridge.ddtReleaseAngle(...a) : undefined),
        beginShoot: (...a) => this.bridge.ddtBeginShoot(...a),
        releaseShoot: (...a) => this.bridge.ddtReleaseShoot(...a),
        getState: () => (this.bridge.ddtGetState ? this.bridge.ddtGetState() : null),
      });
      return this.available;
    }
    return false;
  }

  press(action) {
    if (!this.available) return false;
    const fn = this._resolve(action, 'press');
    if (!fn) return false;
    this._down.add(action);
    fn();
    return true;
  }

  release(action) {
    if (!this.available) return false;
    const fn = this._resolve(action, 'release');
    this._down.delete(action);
    if (!fn) return false;
    fn();
    return true;
  }

  _resolve(action, phase) {
    switch (action) {
      case 'move_left':  return phase === 'press' ? this.actions.moveLeft : null;
      case 'move_right': return phase === 'press' ? this.actions.moveRight : null;
      case 'angle_up':   return phase === 'press' ? this.actions.angleUp : this.actions.releaseAngle;
      case 'angle_down': return phase === 'press' ? this.actions.angleDown : this.actions.releaseAngle;
      case 'shoot':      return phase === 'press' ? this.actions.beginShoot : this.actions.releaseShoot;
      default:           return null;
    }
  }

  releaseAll() {
    const freed = [];
    for (const action of [...this._down]) {
      // movimento é contínuo no jogo; ao soltar, o adapter de teclado resolve.
      if (action === 'move_left' || action === 'move_right') continue;
      if (this.release(action)) freed.push(action);
    }
    return freed;
  }

  /** Estado autoritativo lido do próprio SWF (usado pela barra de força). */
  getState() {
    if (!this.available || typeof this.actions?.getState !== 'function') return null;
    try { return this.actions.getState(); } catch { return null; }
  }

  probe() {
    return this.available
      ? { ok: true, reason: 'bridge ExternalInterface registrada pelo AS3' }
      : { ok: false, reason: 'SWF publicado não expõe bridge de batalha' };
  }
}