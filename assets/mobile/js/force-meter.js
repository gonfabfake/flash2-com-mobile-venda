/**
 * force-meter.js — Espelho local da barra de força do jogo.
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * POR QUE ESPELHAR E NÃO LER
 * ─────────────────────────────────────────────────────────────────────────────
 * O valor autoritativo da força mora em `game/view/EnergyView.as` (campo
 * privado `_force`). O SWF publicado não expõe nenhuma função de leitura, e
 * não podemos recompilá-lo (o core são 3497 classes + UI Morn). Logo a barra
 * do painel é uma RÉPLICA do algoritmo, não a leitura do estado real.
 *
 * Réplica fiel de EnergyView.as:
 *   :45   _forceSpeed = 20                       -> STEP
 *   :30   FORCE_MAX = 2000                       -> MAX
 *   :211  calcForce(): se _force <= 0 -> self.skip()
 *         se _force >= _maxForce -> inverte _dir
 *         _force += _dir * _forceSpeed
 *   :194  no keyup: sendShootAction(_force)       -> dispara com o valor atual
 *
 * Enquanto `ExternalInterfaceAdapter` não estiver ativo, isto é PREVISÃO e
 * isso está rotulado na UI como "estimativa". Se/ quando a bridge AS3 existir,
 * `getState()` passa a fornecer o valor real (ver CONTROLES_MOBILE.md §4).
 */

import { FORCE } from './keymap.js';

export class ForceMeter {
  constructor({ max = FORCE.MAX, step = FORCE.STEP, frameMs = FORCE.FRAME_MS } = {}) {
    this.max = max;
    this.step = step;
    this.frameMs = frameMs;
    this.value = 0;
    this.dir = 1;
    this.charging = false;
    this.lastShot = null;
    this.skipped = false;
    this._acc = 0;
  }

  start() {
    this.value = 0;
    this.dir = 1;
    this.charging = true;
    this.skipped = false;
    this.lastShot = null;
  }

  /** Avança a simulação. `dtMs` = tempo real decorrido. Retorna o novo valor. */
  tick(dtMs) {
    if (!this.charging) return this.value;
    this._acc += dtMs;
    // Replica o passo-por-frame do ENTER_FRAME: no máximo 1 passo por frame.
    while (this._acc >= this.frameMs) {
      this._acc -= this.frameMs;
      if (this.value >= this.max) this.dir = -1;
      else if (this.value <= 0) {
        if (this.dir < 0) {
          // EnergyView.as:221 -> this._self.skip()
          this.charging = false;
          this.skipped = true;
          return 0;
        }
        this.dir = 1;
      }
      this.value += this.dir * this.step;
      this.value = Math.max(0, Math.min(this.max, this.value));
    }
    return this.value;
  }

  /**
   * Solta o carregamento e devolve a força que seria enviada ao servidor.
   *
   * Caso especial: se a barra já desceu a zero, o jogo executou `skip()`
   * (EnergyView.as:221) e NÃO houve disparo. Nesse caso devolvemos 0 em vez
   * de `null`, para que a UI possa mostrar "turno pulado" em vez de um tiro
   * com força desconhecida.
   */
  release() {
    if (this.skipped) {
      this.charging = false;
      this.lastShot = 0;
      return 0;
    }
    if (!this.charging) return this.lastShot;
    this.charging = false;
    this.lastShot = this.value;
    return this.lastShot;
  }

  cancel() {
    this.charging = false;
    this.value = 0;
    this.dir = 1;
    this.skipped = false;
  }

  /** 0..1 normalizado, para a largura da barra. */
  get ratio() {
    return this.max === 0 ? 0 : this.value / this.max;
  }

  /** Valor exibido (o jogo usa inteiro). */
  get display() {
    return Math.round(this.value);
  }
}