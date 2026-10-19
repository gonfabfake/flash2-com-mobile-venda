# CORRECOES.md — arquivos alterados e justificativas

> Branch: `feat/mobile-controls`
> Base: `6e291d0` (main)
> Commit de baseline: `64a6bbf`

**Nada foi excluído.** Todos os arquivos originais estão preservados no histórico
do Git; os backups de 26 MB foram **movidos** para `_backup/`, não apagados.

---

## 1. Resumo

| Categoria | Arquivos novos | Arquivos alterados | Arquivos movidos |
|---|---|---|---|
| Runtime web | 8 | — | — |
| Player | — | 2 | — |
| Configuração | — | 3 | — |
| Dependência | 1 pasta | — | — |
| Testes | 8 | — | — |
| Documentação | 5 | — | — |
| Backups | — | — | 6 |

---

## 2. Arquivos alterados (existentes)

### 2.1 `player.html` — REESCRITO 🔴 B0 + B1

**Antes** (SHA-256 `7EE30DE17198B6D4F7FF572F5AA462BF0212D442EA670067209AD3FDCD20745D`, 3.747 B):
`<object type="application/x-shockwave-flash">` + um IIFE de 80 linhas que só montava o
`<object>` e um listener de fullscreen.

**Problemas corrigidos:**
1. **O jogo não abria em nenhum navegador moderno** — o plugin Adobe Flash foi
   descontinuado em 31/12/2020. Substituído por **Ruffle 0.7.1**.
2. **Nenhuma das 18 funções de `ExternalInterface.call()` existia** na página. Agora
   implementadas em `flash-host-bridge.js`.
3. **`allowScriptAccess`** nunca foi relevante (o `<object>` usava `always`), mas com o
   Ruffle isso precisa ser explícito em `setAllowScriptAccess(true)` — sem isso
   `ExternalInterface.available` é `false` e o `DesktopManager` morre.
4. **Sem tratamento de falha de carregamento**: agora há evento `error`, modal
   informative e o log de diagnóstico.
5. **Sem proteção de viewport em mobile**: faltavam `viewport-fit=cover`,
   `apple-mobile-web-app-status-bar-style`, `theme-color`, `referrer`.
6. **Sem prevenção de zoom/seleção/gestos**: o `user-scalable=no` sozinho não impede
   zoom por duplo toque nem seleção de texto. Agora há `touch-action`, `-webkit-user-select`,
   `-webkit-touch-callout` e `overscroll-behavior: none` no CSS.
7. **Sem tela de início**: em iOS o áudio e o fullscreen só são liberados após gesto do
   usuário; sem um gate explícito o jogo abre mudo e sem tela cheia.
8. **Sem suporte a `?debug=1` / `?ui=force` / `?desktop=1`**.

**Preservado (ETAPA 5):** o parâmetro `?swf=` continua com o mesmo default
(`DDT_Loading_Air.swf`) e **todos** os parâmetros da URL continuam virados em flashvars,
exatamente como nas linhas 50-56 do arquivo original.

### 2.2 `mobile/player.html` — REESCRITO 🔴 B2

Era **byte-a-byte idêntico** ao `player.html` da raiz (mesmo SHA-256). Isso é um bug
por si só: `mobile/` contém **apenas** o HTML, então `data="DDT_Loading_Air.swf"`
resolvia para `/mobile/DDT_Loading_Air.swf` → **404**, tela preta sem mensagem.

**Correção:** `<base href="../">` + resolução por `document.baseURI` no runtime.

### 2.3 `config.xml` 🟠 B3 + B4

| Mudança | Bug | Justificativa |
|---|---|---|
| `<version from="794" to="80">` → `to="795"` | B3 | `LoaderSavingManager.applyUpdate` (`LoaderSavingManager.as:86-89`) retorna cedo se `to <= from`; `80 <= 794` descartava o passo e a versão ficava presa em 794 para sempre. |
| **+** `<STYLE_PATH value="style/" />` | B4 | `ConfigParaser.as:58` sobrescreve `PathInfo.STYLE_PATH` incondicionalmente com `@value` do elemento ausente (= `null`). Sem a tag, `PathManager.solveStylePath()` (`:175`) gerava `…/cdn/nullm/…` → 404 em **todos** os itens de estilo. O valor é o default do próprio AS3 (`PathInfo.as:40`). |

Nada mais foi tocado: os `http://` legados (S7) foram deixados intactos porque alterá-los
pode quebrar o servidor de terceiro.

### 2.4 `crossdomain.xml` 🟠 B5 — REESCRITO

O atributo `domain` aceita **apenas nome de host**. O arquivo trazia caminho junto do
host em 4 regras, que portanto nunca eram avaliadas:

```xml
<allow-access-from domain=".sitemoderno.ddns.net/cdn" secure="false" />   <!-- inválido -->
<allow-access-from domain="api.sitemoderno.ddns.net" secure="false" />
<allow-access-from domain="sitemoderno.ddns.net/quest" secure="false" />   <!-- inválido -->
```

Havia ainda **duplicatas literais** (linhas 5/6 e 10/11).

**Correção:** hosts corrigidos, curinga `*.sitemoderno.ddns.net` cobrindo subdomínios,
duplicatas removidas. `secure="false"` mantido de propósito — é o default permissivo da
especificação (vale para http **e** https).

### 2.5 `web.config` 🟠 B6

| Mudança | Motivo |
|---|---|
| **+** `<staticContent>` com `.wasm → application/wasm` | Sem MIME correto o IIS responde *Incorrect response MIME type* e o Ruffle não inicia. Era um bloqueador silencioso. |
| **+** `.js → application/javascript`, `.json → application/json` | Evita que o IIS sirva `.js` como download em instalações antigas. |
| **+** `player.html` como primeiro `<defaultDocument>` | Nenhum dos documentos listados (`index.php`, `Default.htm`, `index.html`…) **existe na raiz** → `GET /` devolvia 404. |

### 2.6 `.gitignore` — ATUALIZADO

Cobre `_backup/`, `*.bak`, `*.bak_*`, `*.rar`, `*.zip`, `test-results/`,
`playwright-report/`, `.playwright/`. Deixa comentada a opção de excluir
`source/scripts/` (regenerável com FFDec).

### 2.7 `package.json` — RECONFIGURADO

`"type": "module"` (necessário para módulos ES), scripts `start`/`test`/`test:unit`/`test:e2e`.

---

## 3. Arquivos movidos (nenhum excluído)

| De | Para | Motivo |
|---|---|---|
| `2 - Copia.png` | `_backup/` | build antigo do núcleo, idêntico a `2.png.bak` |
| `2.png.bak` | `_backup/` | idem |
| `2.png.bak_20261015_002956` | `_backup/` | idem |
| `2.png.bak_20261015_005427` | `_backup/` | 3º build distinto do núcleo |
| `2.rar` | `_backup/` | artefato de empacotamento |
| `2.zip` | `_backup/` | artefato de empacotamento |

**Verificações feitas antes de mover:** os três primeiros têm SHA-256 idêntico
(`060D3543…`); `2.png.bak_…005427` (`E1D52D5F…`) é um build diferente e foi mantido
separado. Nenhum arquivo foi apagado — todos continuam no histórico do Git **e** em disco.

> **Atenção:** `2.png.bak_20261015_005427` (4.452.403 B) e `2.png` (4.452.139 B) são
> **builds diferentes** do núcleo, com 264 bytes de diferença. Se algum comportamento do
> jogo parecer "diferente do que eu lembrava", este é o primeiro lugar a investigar.

---

## 4. Arquivos novos

### 4.1 Runtime (`assets/mobile/js/`)

| Arquivo | Linhas | Responsabilidade |
|---|---|---|
| `keymap.js` | ~150 | **Fonte única de verdade** do mapeamento de teclas, extraído do AS3 decompilado com `arquivo:linha` em cada entrada. |
| `input-core.js` | ~150 | Estado semântico de entrada, sem DOM. Testável em Node. Garante ausência de comando preso. |
| `adapters/key-event-adapter.js` | ~150 | Entrega os comandos como `KeyboardEvent` no player do Ruffle, com **sondagem de capacidade**. |
| `adapters/external-interface-adapter.js` | ~120 | Bridge preferencial via `ExternalInterface` (ativa quando o SWF a registrar). |
| `flash-host-bridge.js` | ~290 | As 18 funções que o AS3 chama + 16 stubs de SDK social. **Corrige B1.** |
| `ruffle-runtime.js` | ~200 | Monta o `<ruffle-player>`, configura, expõe estado. **Corrige B0.** |
| `capabilities.js` | ~110 | Detecção por **capacidade medida**, nunca por user-agent. |
| `force-meter.js` | ~110 | Espelho local do algoritmo de `EnergyView.calcForce()`. |
| `mobile-controls.js` | ~260 | Camada **apenas visual** do painel (não conhece teclas nem Ruffle). |
| `main.js` | ~280 | Bootstrap e composição. |

### 4.2 Visual

| Arquivo | Linhas |
|---|---|
| `assets/mobile/css/mobile-controls.css` | ~380 |

### 4.3 AS3 (não compilado — requer Flex SDK)

`assets/mobile/as3/MobileInputBridge.as` — bridge completa e comentada, pronta para
compilação. Ver `CONTROLES_MOBILE.md` §5.

### 4.4 Dependência

`vendor/ruffle/` — **Ruffle 0.7.1** selfhosted (MIT + Apache-2.0), 2 WASM + 2 glue JS +
`ruffle.js`. Licenças incluídas.

### 4.5 Testes

| Arquivo | Cobertura |
|---|---|
| `tests/server.mjs` | servidor estático com MIME correto (`.wasm`, `.swf`, `.ashx`) |
| `tests/unit/keymap.test.mjs` | 7 testes — mapa de teclas == AS3 |
| `tests/unit/input-core.test.mjs` | 8 testes — idempotência, multi-toque, blur, stuck sweep |
| `tests/unit/force-meter.test.mjs` | 7 testes — ping-pong, skip, release |
| `tests/unit/flash-host-bridge.test.mjs` | 7 testes — contrato do host (regressão de B1) |
| `tests/unit/adapters.test.mjs` | 11 testes — teclado + bridge + probe |
| `tests/unit/capabilities.test.mjs` | 6 testes — detecção sem user-agent |
| `tests/e2e/player.e2e.mjs` | 13 testes em Chromium real |

### 4.6 Documentação

`AUDITORIA.md`, `CORRECOES.md`, `CONTROLES_MOBILE.md`, `TESTES.md`, `INSTALACAO.md`.

---

## 5. Bugs encontrados pelos testes durante a implementação

A suíte de testes não só validou o código — ela **descobriu 3 bugs reais** no que
eu mesmo havia escrito, e 1 bug pré-existente do jogo:

| # | Onde | Bug | Como foi encontrado |
|---|---|---|---|
| X1 | `flash-host-bridge.js` | O `setInterval` do `title_effect.ticker` **nunca era destruído** — vazamento permanente, e o teste travava para sempre. | O runner de testes não terminava. |
| X2 | `force-meter.js` | Após `skip()` (barra zerada), `release()` devolvia `null` em vez de `0`, fazendo a UI mostrar "tiro com força desconhecida" quando na verdade o turno foi **pulado**. | Teste "zerar a força dispara skip()". |
| X3 | `key-event-adapter.js` | Usava o `KeyboardEvent` **global** em vez do construtor do próprio documento do alvo — quebra em iframes, em contexto de polyfill e tornava o módulo não testável fora do browser. | Teste unitário em Node: `KeyboardEvent is not defined`. |
| **X4** | **`DDT_Loading_Air.swf`** | **Condição de corrida** em `NormalLuncher.__onLoadingProgress()`: quando `getDefinitionByName("ddt.loader.StartupResourceLoader")` falha (ou ainda não rodou), a linha 350 faz `this._startupLoader.Instance.progress` → **`Error #1010` a cada frame**, congelando a tela de progresso. **P pré-existente do jogo**, exposto pelo Ruffle. | Smoke test em Chromium real. Ver `AUDITORIA.md` §3. |

### Sobre X4

Não é corrigível pela camada web (está dentro do SWF). Patches propostos em
`AUDITORIA.md` §6. **Mitigação aplicada:** o bootstrap deixou de **bloquear** em
`loadedmetadata` (antes isso derrubava toda a interface). O player sobe, o painel de
controles fica utilizável e o diagnóstico expõe os erros AVM2 em `?debug=1`.

---

## 6. O que deliberadamente NÃO foi feito

| Ação | Motivo |
|---|---|
| Alterar `2.png` / `2.swf` | É o binário do jogo. Qualquer "ajuste" exigiria recompilar com Flex SDK. Ver ETAPA 8 (escopo autorizado = arquivos de texto e runtime web). |
| Recompilar o AS3 | Requer Flex/AIR SDK (~1 GB) + 3.497 classes + UI Morn gerada. Risco altíssimo de produzir um núcleo quebrado. A bridge foi **escrita e documentada**, não compilada. |
| Corrigir `http://` → `https://` no `config.xml` | Envolve domínios de terceiros. Pode quebrar o servidor de produção. Documentado em `AUDITORIA.md` §5 (S7). |
| Remover endpoints de telemetry (`COUNT_PATH`, 360 Analytics) | Configuração do operador. Descrevê-los, não decidir por ele. `COUNT_PATH` já é código morto (0 call-sites). |
| `git push` / alterar remoto | Fora do escopo. Branch e commits são **locais**. |
| Interceptar teclado no desktop | Quebraria a versão PC (ETAPA 5). O painel só aparece quando **não há cursor fino**. |