# TESTES.md — o que foi realmente testado

> **Regra do projeto:** nunca afirmar que o jogo está 100% funcional sem evidência
> de teste real. Este documento registra o que foi **executado** e o que **não foi
> possível validar**.

---

## 1. Resumo

| Suíte | Testes | Passou | Falhou |
|---|---|---|---|
| `tests/unit` (Node 24, `node:test`) | 86 | **86** | 0 |
| `tests/e2e` (Chromium 1248 real) | 14 | **14** | 0 |
| **Total** | **100** | **100** | **0** |

---

## 2. Testes de unidade (`tests/unit`) — 49/49

Execução: `npm run test:unit` (Node 24, sem browser, sem rede).

| Arquivo | Testes | O que valida |
|---|---|---|
| `keymap.test.mjs` | 7 | O mapa de teclas do painel é **idêntico** ao que o AS3 escuta (37/39/38/40/32/84, aliases 65/68/87/83), parâmetros de força (2000/20/25fps), resolução de ação, clamp. |
| `input-core.test.mjs` | 9 | Press/release, idempotência, multi-toque, soltura por fonte, `releaseAll` (blur), varredura anti-comando-preso (4 s), ações de toque, snapshot. |
| `force-meter.test.mjs` | 7 | Ping-pong 0→2000→0, 1 passo/frame, `release()` devolve a força, `skip()` quando zera, `cancel()`, ratio/display. |
| `flash-host-bridge.test.mjs` | 7 | O host implementa as 18 funções que o AS3 chama (regressão do bug B1), não sobrescreve os `addCallback`, `IsDesktop` respeita `?desktop=1`, `game_interruption`, ticker. |
| `adapters.test.mjs` | 11 | Teclado: keydown/keyup com `key`+`code`+`keyCode` legado, composição (shadow DOM), idempotência, `releaseAll`, `probe()`; bridge: inativa sem SWF, ativa com registro. |
| `capabilities.test.mjs` | 6 | Detecção sem user-agent (celular, desktop, tablet, iPad Pro declarando-se Macintosh, `?ui=force`/`off`). |

---

## 3. Testes end-to-end (`tests/e2e`) — 14/14 em Chromium real

Execução: `npm run test:e2e` (Chromium 1248, contexto mobile com toque).

| # | Teste | O que prova |
|---|---|---|
| 1 | Inicialização do Ruffle | `<ruffle-player>` criado, `instance.load()` chamado, canvas no shadow root, sondagem do adaptador OK. |
| 1b | Core local | Com `?config=config.local.xml`, o `2.png` (4,45 MB) é pedido da **origem local** (200), não do CDN. |
| 2 | **PROVA** de teclado | Via **CDP** (`DOMDebugger.getEventListeners`), o Ruffle registrou `keydown`/`keyup` no `window`. Combinado com §4.3 do CONTROLES_MOBILE.md, isso fecha a cadeia de entrega. |
| 3 | Teclas dos botões | Cada um dos 5 botões gera exatamente o `keydown`/`keyup` com `key`, `code` e `keyCode` que o AS3 escuta (37/39/38/40/32). |
| 4 | Movimento contínuo | 1 `keydown` enquanto segura; 1 `keyup` ao soltar; nada depois. |
| 5 | Barra de força | Carrega de 0, rótulo numérico > 0, ≤ 2000, `aria-pressed` correto; soltar libera. |
| 6 | Sem comando preso | 2 comandos ativos → `blur` → snapshot vazio, adaptador limpo, 2 `keyup` enviados. |
| 7 | Host de ExternalInterface | As 18 funções existem; `IsDesktop()` respeita o flag; ticker begin/stop. |
| 8 | Desktop preservado | Com `hasTouch:false`, o painel **não** aparece e o teclado segue nativo. |
| 8b | Painel sob demanda | `?ui=force` mostra o painel no desktop (para QA). |
| 9 | Responsividade | 4 viewports (844×390, 740×360, 1024×768, 667×375): nenhum botão sai da tela, alvo ≥ 44×44. |
| 10 | Reinicialização | Recarregar limpa snapshot e adaptador; runtime volta a `ready`. |
| 11 | Console limpo | Nenhum erro de JS não tratado (ruído de rede do CDN é filtrado). |
| 12 | Caminho `mobile/` | `mobile/player.html` acha o SWF (bug do caminho relativo corrigido). |

---

## 4. O que foi descoberto **durante** a implementação/teste

A suíte não apenas validou — ela **encontrou 4 bugs** (3 nossos + 1 pré-existente):

| # | Onde | Bug | Como foi encontrado |
|---|---|---|---|
| X1 | `flash-host-bridge.js` | `setInterval` do ticker **nunca destruído** — vazamento permanente; o teste travava. | Runner não terminava. |
| X2 | `force-meter.js` | Após `skip()`, `release()` devolvia `null` em vez de `0`. | Teste "zerar a força dispara skip()". |
| X3 | `key-event-adapter.js` | Usava o `KeyboardEvent` **global** em vez do construtor do próprio documento. | Teste em Node: `KeyboardEvent is not defined`. |
| **X4** | **`DDT_Loading_Air.swf`** (pré-existente) | **Condição de corrida** em `NormalLuncher.__onLoadingProgress()`: quando `getDefinitionByName("ddt.loader.StartupResourceLoader")` ainda não rodou, a linha 350 faz `this._startupLoader.Instance.progress` → **`Error #1010` a cada frame**, congelando a tela de progresso. | Smoke test em Chromium real. |

**X4 é a descoberta mais importante da auditoria.** Não é corrigível pela camada web
(está dentro do SWF) — patches propostos em `AUDITORIA.md` §6. Mitigação aplicada:
o bootstrap deixou de **bloquear** em `loadedmetadata`, que antes derrubava toda a interface.

---

## 5. O que **não** foi validado (e por quê)

| Item | Motivo |
|---|---|
| Login real / sessão com o servidor | `sitemoderno.ddns.net` é host dinâmico de terceiros; sem credenciais e sem garantia de disponibilidade. Testado só o carregamento do loader e do core. |
| Batalha de ponta a ponta (mira → tiro → dano) | Dependente de login e de outros jogadores. |
| Áudio e música | O navegador bloqueia autoplay; só destrava com gesto; os `sound/*.flv` não existem localmente. |
| Comportamento em iOS/Safari real | Sem dispositivo iOS no ambiente; testado apenas com emulação de toque no Chromium. |
| `screen.orientation.lock()` | Não funciona no Chromium headless nem em desktop. |
| Ruffle em produção com 4,45 MB + 389 SWFs | Validado só o carregamento inicial; o volume de assets não foi exercitado até o login. |
| Recompilação do core com Flex SDK | Fora do escopo desta entrega (ver `INSTALACAO.md` §6). A bridge foi **escrita e documentada**, não compilada. |

---

## 6. Comandos para reproduzir

```powershell
cd "C:\Users\gonfa\OneDrive\Desktop\flash - Copia (2)"
npm install
npx playwright install chromium

npm run test:unit     # 49 testes, ~0,6 s, sem browser
npm run test:e2e      # 14 testes, ~5,5 min, Chromium real
npm test              # os dois
```

Para reexecutar um único teste:
```powershell
node --test --test-name-pattern="^3\." "tests/e2e/*.e2e.mjs"
```