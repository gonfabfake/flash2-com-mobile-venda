/**
 * ruffle-runtime.js — Carrega o SWF no Ruffle e expõe o player para a UI.
 *
 * ─────────────────────────────────────────────────────────────────────────────
 * BUG CRÍTICO QUE ESTE MÓDULO RESOLVE
 * ─────────────────────────────────────────────────────────────────────────────
 * O `player.html` original montava `<object type="application/x-shockwave-flash">`.
 * O plugin Adobe Flash foi descontinuado em 31/12/2020 e removido dos browsers.
 * Em qualquer navegador atual isso renderiza um retângulo vazio, sem erro
 * visível — o jogo simplesmente não abre. O Ruffle (reimplementação em
 * WebAssembly, MIT/Apache-2.0) é o único caminho suportado.
 *
 * Configuração escolhida e por quê:
 *   autostart: "on"|"off"|"muted"  -> "on"; o áudio é destravado pelo gesto
 *                                      do overlay de início (política dos
 *                                      browsers modernos).
 *   allowScriptAccess: true         -> OBRIGATÓRIO. Sem isso o
 *                                      `ExternalInterface.available` é false
 *                                      e todo o `DesktopManager`/bridge morre
 *                                      (ver flash-host-bridge.js).
 *   scale: "exactFit"               -> `App.as:52` já fixa
 *                                      `stage.scaleMode = "exactFit"`.
 *   letterbox: "off"                -> o jogo desenha o fundo dele mesmo
 *                                      (SHOW_BACKGROUND=true em config.xml).
 */

const RUFFLE_DEFAULTS = Object.freeze({
  autostart: 'on',
  allowScriptAccess: true,
  backgroundColor: '#000000',
  letterbox: 'off',
  showSwfDebug: false,
  showCtxtMenu: false,
  contextMenu: 'rightClickOnly',
  scale: 'exactFit',
  salign: 'tl',
  quality: 'high',
  ruffleLogLevel: 'warn',
  preferredRenderer: 'webgl',
  tooltip: '',
});

export class RuffleRuntime {
  constructor({ scope = globalThis, log = () => {}, settleTimeoutMs = 8000 } = {}) {
    this.scope = scope;
    this.log = log;
    this.playerElement = null;
    this.instance = null;
    this.started = false;
    this.ready = false;
    this.error = null;
    this.settleTimeoutMs = settleTimeoutMs;
    this.config = { ...RUFFLE_DEFAULTS, ...(scope.RufflePlayer?.config || {}) };
  }

  /** Verdadeiro se o script do Ruffle carregou (polyfill pode ter criado players). */
  get available() {
    return Boolean(this.scope.RufflePlayer && typeof this.scope.RufflePlayer.newest === 'function');
  }

  /**
   * Cria o <ruffle-player> e inicia o carregamento do SWF.
   * @param {HTMLElement} container
   * @param {{url: string, parameters?: object}} movie
   */
  async mount(container, movie) {
    if (!this.available) {
      this.error = new Error('RufflePlayer indisponível — verifique vendor/ruffle/ruffle.js');
      throw this.error;
    }

    const source = this.scope.RufflePlayer.newest();
    const element = source.createPlayer();
    element.id = 'flashPlayer';
    element.style.cssText = 'width:100%;height:100%;display:block;outline:none;';
    // tabindex permite que o teclado do desktop atinja o player após um clique
    element.setAttribute('tabindex', '0');
    container.appendChild(element);
    this.playerElement = element;

    const instance = element.ruffle();
    this.instance = instance;

    // Configuração em tempo de execução (o <ruffle-player> aceita só o essencial
    // no atributo; o resto é setado na instância).
    const safe = (fn, ...args) => {
      try { if (typeof instance?.[fn] === 'function') instance[fn](...args); }
      catch (e) { this.log(`ruffle.${fn} falhou: ${e?.message}`); }
    };
    safe('setAllowScriptAccess', true);
    safe('setScale', 'exactfit');
    safe('setBackgroundColor', 0x000000);
    safe('setShowMenu', false);
    safe('setAllowFullscreen', true);
    safe('setLogLevel', this.config.ruffleLogLevel);
    safe('setQuality', this.config.quality);
    // `document.baseURI` (e não location.href) para respeitar a tag <base>,
    // usada por mobile/player.html — sem isso o SWF seria procurado em /mobile/.
    const baseUrl = this.scope.document?.baseURI || this.scope.location.href;
    safe('setBaseUrl', new URL(movie.url, baseUrl).href);
    safe('setStageAlign', 'tl');

    const swfUrl = new URL(movie.url, baseUrl).href;
    this.log(`carregando ${swfUrl}`);

    // `loadedmetadata` é apenas um SINAL de progresso — nunca bloqueamos o
    // bootstrap nele. O loader deste projeto lança erros de AVM2 durante a
    // partida (ver AUDITORIA.md §3) e isso pode impedir o evento de chegar.
    // Esperar por ele deixaria a interface inteira indisponível.
    const { promise: failure, reject } = defer();
    const onError = (event) =>
      reject(new Error(`falha ao carregar ${swfUrl}: ${event?.detail || 'erro desconhecido'}`));

    element.addEventListener('error', onError, { once: true });
    element.addEventListener('loadedmetadata', () => {
      this.ready = true;
      this.log('SWF carregado (loadedmetadata)');
      document.dispatchEvent(new CustomEvent('ddt:swf-ready'));
    });

    instance.load({ url: swfUrl, parameters: movie.parameters || {} });
    this.started = true;

    // Se o player nem sinalizar erro em `settleMs`, seguimos: um erro de AVM2
    // não impede o jogo de rodar e não devemos derrubar a UI por causa disso.
    const settled = await Promise.race([
      failure.catch(() => 'failed'),
      new Promise((r) => setTimeout(() => r('timeout'), this.settleTimeoutMs)),
      new Promise((r) => element.addEventListener('loadedmetadata', () => r('ready'), { once: true })),
    ]);
    if (settled === 'failed') {
      this.error = new Error('falha ao carregar o SWF');
      throw this.error;
    }
    if (settled === 'timeout') {
      this.log(`player iniciado sem loadedmetadata em ${this.settleTimeoutMs}ms`);
    }

    element.removeEventListener('error', onError);
    return this;
  }

  /** Foca o player (necessário para o teclado do desktop chegar ao SWF). */
  focus() {
    try {
      this.playerElement?.focus({ preventScroll: true });
      // alguns players exigem foco no canvas interno
      this.playerElement?.shadowRoot?.querySelector('canvas')?.focus?.({ preventScroll: true });
      return true;
    } catch { return false; }
  }

  /** Permite sobrescrever a URL do SWF em runtime (ExternalInterfaceManager). */
  async loadSwfUrl(url) {
    this.log(`loadSwfUrl → ${url}`);
    await this.mount(this.playerElement.parentElement, { url });
  }
}

function defer() {
  let resolve, reject;
  const promise = new Promise((res, rej) => { resolve = res; reject = rej; });
  return { promise, resolve, reject };
}

/** Leitura dos parâmetros de URL no mesmo formato do player.html original. */
export function parseMovieParams(search) {
  const params = new URLSearchParams((search || '').replace(/^\?/, ''));
  const swf = params.get('swf') || 'DDT_Loading_Air.swf';
  const vars = {};
  params.forEach((value, key) => {
    if (key !== 'swf' && key !== 'ui') vars[key] = value;
  });
  return { swf, vars, search: params.get('search') || '', raw: params };
}