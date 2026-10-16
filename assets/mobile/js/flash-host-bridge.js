/**
 * flash-host-bridge.js — Implementa o "host" que o ActionScript espera na página.
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * BUG CORRIGIDO (crítico)
 * ─────────────────────────────────────────────────────────────────────────────
 * O `player.html` original (SHA-256 7EE30DE1...) **não definia nenhuma** das
 * funções que o AS3 chama via `ExternalInterface.call(...)`. Resultado no
 * browser: erros silenciosos "X is not a function" e, pior, caminhos de erro
 * que simplesmente NÃO FAZEM NADA — porque `ExternalInterface.available` é
 * verdadeiro (o plugin responde), mas a função não existe.
 *
 * Caso crítico comprovado no código:
 *   ddt/manager/LeavePageManager.as:51-63
 *     `forcedToLoginPath()` só chama `ExternalInterface.call("game_interruption", ...)`.
 *     Se a sessão cai (ByteSocket.as:178 remove listeners antes de fechar, então
 *     o evento CLOSE também se perde — bug A3 da auditoria), o jogador fica em
 *     uma tela morta sem qualquer aviso. Com `game_interruption` implementada
 *     aqui, o jogador recebe um modal com opção de voltar ao login.
 *
 * Toda função aqui é defensiva: nunca lança, sempre registra no log de
 * diagnóstico e retorna um valor neutro quando não há nada a fazer.
 */

/** Funções que o AS3 REGISTRA (addCallback) — a página não deve sobrescrever. */
export const FLASH_REGISTERED_CALLBACKS = Object.freeze([
  'SetIsDesktop', 'sendSwfNowUrl', 'setLoginType', 'checkComplete',
  'deleteComplete', 'flashGotoAndPlay', 'setSound', 'sinaCallBack',
  'swfExitPrompt', 'SetFlashLoadExternal', 'ExternalLoadStop',
]);

/** Funções que o AS3 CHAMA (`ExternalInterface.call`) — devem existir na página. */
export const FLASH_CALLED_FUNCTIONS = Object.freeze([
  'IsDesktop', 'WindowReturn', 'setFlashCall', 'game_interruption', 'game_pay',
  'AddFavorite', 'setFavorite', 'getLocationUrl', 'addToFavorite',
  'ExternalLoadStart', 'alert', 'sendWeiboFeed', 'showInviteBox', 'facebookSend',
  'setDailyTask', 'setDailyActivity', 'ExitGameToLogin', 'closeWindow',
]);

export class FlashHostBridge {
  /**
   * @param {object} opts
   * @param {object} [opts.scope]        onde instalar (default: window)
   * @param {object} [opts.diagnostics]  coletor de eventos/diagnóstico
   * @param {boolean}[opts.isDesktop]   força o modo desktop (?desktop=1)
   * @param {Function}[opts.onNavigate] intercepta navegações (testável)
   */
  constructor({ scope = globalThis, diagnostics = null, isDesktop = false, onNavigate = null } = {}) {
    this.scope = scope;
    this.diag = diagnostics;
    this._forcedDesktop = isDesktop;
    this._onNavigate = onNavigate;
    this._installed = new Set();
  }

  _log(event, payload) {
    if (this.diag && typeof this.diag.record === 'function') {
      this.diag.record({ source: 'flash', event, ...payload });
    }
  }

  _define(name, fn) {
    if (FLASH_REGISTERED_CALLBACKS.includes(name)) return; // o SWF sobrescreve
    this._installed.add(name);
    Object.defineProperty(this.scope, name, {
      value: fn, writable: true, configurable: true, enumerable: false,
    });
  }

  install() {
    const s = this.scope;

    // ── detecção desktop ────────────────────────────────────────────────
    // DesktopManager.as:26-33 → addCallback("SetIsDesktop") + call("IsDesktop").
    // Se retornarmos `true`, o SWF marca _desktopType=1 e muda de comportamento.
    this._define('IsDesktop', () => this._forcedDesktop);

    // ── redirecionamentos ───────────────────────────────────────────────
    const navigate = (url, reason) => {
      this._log('navigate', { url, reason });
      if (typeof this._onNavigate === 'function') return this._onNavigate(url, reason);
      try { s.location.href = url; } catch { /* ambiente de teste */ }
      return undefined;
    };
    this._navigate = navigate;

    this._define('WindowReturn', () => { this._log('WindowReturn'); return navigate(s.location.href, 'window-return'); });
    this._define('getLocationUrl', () => s.location.href);
    this._define('addToFavorite', () => { this._log('addToFavorite'); });
    this._define('AddFavorite', (url) => navigate(url, 'AddFavorite'));
    this._define('setFavorite', (url, site, type) => { this._log('setFavorite', { url, site, type }); });
    this._define('game_pay', () => { this._log('game_pay'); });
    this._define('setFlashCall', () => { this._log('setFlashCall'); });

    // ── sinalização de erro ─────────────────────────────────────────────
    this._define('alert', (message) => {
      this._log('alert', { message: String(message) });
      if (typeof this.onAlert === 'function') this.onAlert(String(message));
    });

    // ── interrupção de sessão (LeavePageManager.as:61) ──────────────────
    this._define('game_interruption', (url, message) => {
      this._log('game_interruption', { url, message });
      if (typeof this.onInterruption === 'function') {
        this.onInterruption(String(url ?? ''), String(message ?? ''));
      }
    });

    // ── micro-client / recursos ─────────────────────────────────────────
    this._define('ExternalLoadStart', () => { this._log('ExternalLoadStart'); });
    this._define('IsMicroClient', () => false);
    this._define('getMicroClientVersion', () => '');
    this._define('setMicroClient', () => { this._log('setMicroClient'); });

    // ── recursos sociais / daily (config.xml:45-60 liga vários) ─────────
    this._define('sendWeiboFeed', (...a) => { this._log('sendWeiboFeed', { args: a }); });
    this._define('showInviteBox', (...a) => { this._log('showInviteBox', { args: a }); });
    this._define('facebookSend', (...a) => { this._log('facebookSend', { args: a }); });
    this._define('setDailyTask', (...a) => { this._log('setDailyTask', { args: a }); });
    this._define('setDailyActivity', (...a) => { this._log('setDailyActivity', { args: a }); });
    this._define('ExitGameToLogin', () => navigate(s.location.href, 'exit-to-login'));
    this._define('closeWindow', () => { this._log('closeWindow'); });

    // ── Social SDKs legados (config.xml:36-41 aponta para serviços mortos) ─
    // Mantidos como no-op: sem isso o SWF lança TypeError ao chamá-los.
    this._define('sinaInit', () => {});
    this._define('sinaLogin', () => {});
    this._define('sinaShare', () => {});
    this._define('qqLogin', () => {});
    this._define('qqShare', () => {});
    this._define('renrenLogin', () => {});
    this._define('baiduLogin', () => {});
    this._define('baiduShare', () => {});
    this._define('qzoneShare', () => {});
    this._define('kaixinLogin', () => {});
    this._define('kaixinShare', () => {});
    this._define('window_close', () => {});

    // ── ticker de título ────────────────────────────────────────────────
    // PageInterfaceManager.as:17 → "title_effect.tickerBegin" / "tickerStop"
    const title = { ticker: null };
    this._define('title_effect', title);
    if (!s.title_effect || !s.title_effect.tickerBegin) {
      Object.defineProperty(s.title_effect, 'tickerBegin', {
        value: (text) => {
          this._log('tickerBegin', { text });
          title.ticker = { text, startedAt: Date.now(), running: true };
          this._startTicker(title);
          return true;
        },
        writable: true, configurable: true,
      });
      Object.defineProperty(s.title_effect, 'tickerStop', {
        value: () => { if (title.ticker) title.ticker.running = false; return true; },
        writable: true, configurable: true,
      });
    }

    // ── função injetada por LeavePageManager.as:24-25 / 38-39 ───────────
    // O AS3 injeta `function redict(){top.location.href="..."}` e chama.
    this._define('redict', () => navigate(s.location.href, 'redict'));

    return this;
  }

  _startTicker(state) {
    const labels = ['⚔ DDTank', '★ DDTank Mobile', 'DDTank ★', '⚔ DDTank Mobile'];
    let i = 0;
    // O intervalo é liberation condition: assim que o ticker para, o timer é
    // destruído. Sem isto o setInterval vazaria para sempre (o jogo pode
    // alternar seu turno milhares de vezes numa sessão).
    this.stop();
    this._tickerTimer = setInterval(() => {
      if (!state.ticker || !state.ticker.running) { this.stop(); return; }
      try { this.scope.document.title = labels[i++ % labels.length]; } catch { /* noop */ }
    }, 1600);
  }

  stop() {
    if (this._tickerTimer) { clearInterval(this._tickerTimer); this._tickerTimer = null; }
  }

  /** Handlers sobrescrevíveis pelo host (UI). */
  onAlert = null;
  onInterruption = null;

  /** Nomes efetivamente instalados — usado nos testes. */
  get installedNames() { return [...this._installed]; }
}

/**
 * Instala o bridge e devolve a instância. Idempotente.
 * `isDesktop` permite forçar o modo desktop via `?desktop=1`,
 * que é o "feature detection" pedido — não depende de user-agent.
 */
export function installFlashHostBridge(options = {}) {
  const bridge = new FlashHostBridge(options).install();
  if (globalThis.__ddtBridge) globalThis.__ddtBridge.stop();
  globalThis.__ddtBridge = bridge;
  return bridge;
}