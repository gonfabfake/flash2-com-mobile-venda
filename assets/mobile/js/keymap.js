/**
 * keymap.js — Mapa de teclas do DDTank Mobile.
 *
 * FONTE DA VERDADE: código ActionScript decompilado em `source/scripts/`.
 * Cada entrada abaixo tem evidência `arquivo:linha`. Este arquivo é a ÚNICA
 * fonte de verdade compartilhada entre desktop e mobile — o painel mobile
 * NÃO inventa teclas, ele reproduz exatamente as que o jogo já escuta.
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * EVIDÊNCIAS (ActionScript decompilado)
 * ─────────────────────────────────────────────────────────────────────────────
 *  MOVIMENTO ESQUERDA/DIREITA
 *    game/objects/GameLocalPlayer.as:139-142  registra KeyStroke.VK_LEFT/VK_A/VK_RIGHT/VK_D
 *    game/actions/SelfPlayerWalkAction.as:49  KeyboardManager.isDown(VK_A=65) || isDown(Keyboard.LEFT=37)
 *    game/actions/SelfPlayerWalkAction.as:51  idem para D=68 / RIGHT=39
 *    -> enquanto a tecla estiver DOWN o personagem anda (com consumicao de energia).
 *
 *  ÂNGULO
 *    game/view/arrow/ArrowView.as:382-398  (ENTER_FRAME, contínuo)
 *        DOWN/KeyStroke.VK_S -> manuallySetGunAngle(gunAngle - ROTATITON_SPEED * reverse)
 *        UP  /KeyStroke.VK_W -> manuallySetGunAngle(gunAngle + ROTATITON_SPEED * reverse)
 *    game/view/arrow/ArrowView.as:416-437  (KEY_DOWN, passo único)
 *    game/view/arrow/ArrowView.as:52       ANGLE_NEXTCHANGE_TIME = 100 ms (throttle)
 *    room/model/WeaponInfo.as:9            ROTATITON_SPEED = 1  (1 grau por passo)
 *    game/model/LocalPlayer.as:200-205     manuallySetGunAngle() — clamp em armMin/armMax
 *
 *  FORÇA / DISPARO
 *    game/view/EnergyView.as:167  if (KeyboardManager.isDown(Keyboard.SPACE))  -> carrega
 *    game/view/EnergyView.as:177  this._self.beginShoot()                        -> trava o turno
 *    game/view/EnergyView.as:187  else if (this._keyDown)                        -> SOLTOU
 *    game/view/EnergyView.as:194  this._self.sendShootAction(this._force)        -> dispara
 *    game/view/EnergyView.as:211-228  calcForce(): ping-pong, _forceSpeed = 20, se <=0 => skip()
 *    game/model/Player.as:44      FORCE_MAX = 2000
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * SOBRE O RUFFLE: a tecla precisa chegar como `KeyboardEvent` DOM no elemento do
 * player. O Ruffle 0.7 lê `event.key` e `event.code` (o binário WASM NÃO lê o
 * campo legado `keyCode` — 0 ocorrências no glue JS). Por isso despachamos
 * `key` E `code`, e anexamos `keyCode`/`which` por defineProperty apenas como
 * compatibilidade extra para players baseados no plugin Adobe.
 * ─────────────────────────────────────────────────────────────────────────────
 */

/** Identificadores semânticos das ações do jogo (independentes de teclado). */
export const ACTION = Object.freeze({
  MOVE_LEFT: 'move_left',
  MOVE_RIGHT: 'move_right',
  ANGLE_UP: 'angle_up',
  ANGLE_DOWN: 'angle_down',
  SHOOT: 'shoot',
  TOGGLE_ARROW: 'toggle_arrow',
});

/** Teclas de oportunidade/atalho que o jogo já trata em batalha. */
export const ACTION_KEYS = Object.freeze({
  [ACTION.MOVE_LEFT]: [37, 65],   // Keyboard.LEFT, KeyStroke.VK_A
  [ACTION.MOVE_RIGHT]: [39, 68],  // Keyboard.RIGHT, KeyStroke.VK_D
  [ACTION.ANGLE_UP]: [38, 87],    // Keyboard.UP, KeyStroke.VK_W
  [ACTION.ANGLE_DOWN]: [40, 83],  // Keyboard.DOWN, KeyStroke.VK_S
  [ACTION.SHOOT]: [32],           // Keyboard.SPACE
  [ACTION.TOGGLE_ARROW]: [84],    // KeyStroke.VK_T
});

/**
 * Representação canônica de uma tecla para `new KeyboardEvent(...)`.
 * `key` e `code` seguem DOM; `keyCode`/`which` reproduzem o Flash KeyboardEvent.
 */
export const KEY_SPECS = Object.freeze({
  37: { key: 'ArrowLeft',  code: 'ArrowLeft',  action: ACTION.MOVE_LEFT },
  65: { key: 'a',         code: 'KeyA',       action: ACTION.MOVE_LEFT },
  39: { key: 'ArrowRight', code: 'ArrowRight', action: ACTION.MOVE_RIGHT },
  68: { key: 'd',         code: 'KeyD',       action: ACTION.MOVE_RIGHT },
  38: { key: 'ArrowUp',    code: 'ArrowUp',    action: ACTION.ANGLE_UP },
  87: { key: 'w',         code: 'KeyW',       action: ACTION.ANGLE_UP },
  40: { key: 'ArrowDown',  code: 'ArrowDown',  action: ACTION.ANGLE_DOWN },
  83: { key: 's',         code: 'KeyS',       action: ACTION.ANGLE_DOWN },
  32: { key: ' ',         code: 'Space',      action: ACTION.SHOOT },
  84: { key: 't',         code: 'KeyT',       action: ACTION.TOGGLE_ARROW },
});

/**
 * Tecla "canônica" usada pelo painel mobile para cada ação.
 * Escolhemos sempre o `Keyboard.*` (seta/espaço) em vez das letras WASD,
 * porque é o caminho exercitado pelo polling em ENTER_FRAME
 * (SelfPlayerWalkAction / ArrowView / EnergyView) e independe do layout físico.
 */
export const ACTION_PRIMARY_KEY = Object.freeze({
  [ACTION.MOVE_LEFT]: 37,
  [ACTION.MOVE_RIGHT]: 39,
  [ACTION.ANGLE_UP]: 38,
  [ACTION.ANGLE_DOWN]: 40,
  [ACTION.SHOOT]: 32,
  [ACTION.TOGGLE_ARROW]: 84,
});

/** Parâmetros de física da barra de força — espelham game/view/EnergyView.as. */
export const FORCE = Object.freeze({
  MAX: 2000,      // EnergyView.FORCE_MAX  (EnergyView.as:30 / Player.as:44)
  STEP: 20,       // EnergyView._forceSpeed = 20 (EnergyView.as:45)
  FRAME_MS: 1000 / 25, // Config.GAME_FPS = 25 (Config.as:6)
});

/** Desloca um valor para dentro de [min, max]. */
export function clamp(value, min, max) {
  return value < min ? min : value > max ? max : value;
}

/**
 * Resolve o action semântico de um `KeyboardEvent` DOM.
 * Retorna `null` quando a tecla não é comando do jogo — nesse caso o evento
 * deve seguir o fluxo normal (campos de texto do chat, login, etc.).
 */
export function actionForKeyCode(keyCode) {
  for (const [action, codes] of Object.entries(ACTION_KEYS)) {
    if (codes.includes(keyCode)) return action;
  }
  return null;
}

/** Atalho inverso: código de tecla -> action (mesmo mapa, outras consultas). */
const CODE_TO_ACTION = Object.freeze(
  Object.fromEntries(
    Object.entries(ACTION_KEYS).flatMap(([action, codes]) => codes.map((c) => [c, action])),
  ),
);

/** Resolve a ação a partir de `event.code` (usado como fallback). */
export function actionForCode(domCode) {
  for (const [code, spec] of Object.entries(KEY_SPECS)) {
    if (spec.code === domCode) return spec.action;
  }
  return null;
}

export { CODE_TO_ACTION };