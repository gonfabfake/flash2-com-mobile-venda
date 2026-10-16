# AUDITORIA.md — flash2-com-mobile-venda

> **Escopo:** pasta `flash - Copia (2)` (commit `6e291d0`, branch `feat/mobile-controls`)
> **Data da auditoria:** 16/10/2026
> **Método:** análise estática integral do código ActionScript decompilado (3.497 classes),
> leitura de `config.xml` / `web.config` / `crossdomain.xml`, inspeção binária do runtime
> Ruffle 0.7.1 (glue JS + exports do WASM) e execução em navegador real (Chromium).

---

## 1. Resumo executivo

O projeto é o **DDTank Mobile**, um cliente de jogo em Flash (ActionScript 3) distribuído
como SWF disfarçado de PNG. A auditoria encontrou **1 bloqueio absoluto**, **11 bugs
críticos/altos** e **20+ bugs médios/baixos**. A maioria está dentro do SWF e **não é
corrigível sem recompilar o binário**; foram documentadas com evidência e proposta de
correção.

**O bloqueio absoluto:** `player.html` usava `<object type="application/x-shockwave-flash">`.
O plugin Adobe Flash foi descontinuado em 31/12/2020 e removido dos navegadores. Em
qualquer navegador atual a página renderiza um retângulo vazio **sem erro visível**. O jogo
literalmente não abre.

| Severidade | Quantidade | Onde |
|---|---|---|
| 🔴 Bloqueador | 1 | HTML/player |
| 🔴 Crítico | 6 | HTML, XML, config, JS |
| 🟠 Alto | 8 | SWF + config |
| 🟡 Médio | 14 | SWF + config |
| ⚪ Baixo | 9 | higiene do repositório |

---

## 2. Inventário técnico

### 2.1 Linguagens e technologies

| Item | Detalhe | Evidência |
|---|---|---|
| ActionScript 3 | 3.497 arquivos `.as`, 3.497 tags ABC | `source/scripts/` (decompilado de `2.png`) |
| XML | `config.xml`, `characterdefine.xml`, `partical.xml`, 389 `.ui` Morn | raiz + `ui/{portugal,spain}/` |
| HTML/JS/CSS | `player.html` (embutidor), `web.config` (IIS) | raiz |
| **SWF** | **389 arquivos**, núcleo de 4,45 MB | `*.swf`, `*.png` (ver §2.4) |
| Framework UI | **Morn** (`morn.core.managers.*`) + **ASWing** (`org.aswing.*`) | `App.as:27-39` |
| Player | Flash Player (morto) → **Ruffle 0.7.1** (adicionado) | `vendor/ruffle/` |

### 2.2 Dependências externas

| Dependência | Valor | Nota |
|---|---|---|
| Servidor de jogo | `https://sitemoderno.ddns.net/` | `config.xml:4-14` |
| CDN de recursos | `https://sitemoderno.ddns.net/cdn/` | `config.xml:7-8` |
| Endpoints | `quest/*.ashx`, `quest/*.xml` (86 arquivos) | `StartupResourceLoader.as:595-669` |
| Ruffle | 0.7.1 (MIT/Apache-2.0) | **adicionado** em `vendor/ruffle/` |
| Fontes de código | 17173, duowan, kaixin, baidu, changyou | **mortos**, `ddt/view/enthrall/Validate17173.as:60-76` |

### 2.3 Ponto de entrada e cadeia de boot

```
player.html  (GET /)
  └─ DDT_Loading_Air.swf            ← classe de documento DDT_Loading (273 classes)
       │  DDT_Loading.as:58   lê "config.xml" (caminho RELATIVO ao SWF)
       │  DDT_Loading.as:184  LoaderManager.creatLoader(_configURL, TEXT_LOADER)
       │  DDT_Loading.as:216  changeRequestMethod: http→https
       │  DDT_Loading.as:225  UIModuleLoader.setup(FLASHSITE, BACKUP_FLASHSITE)
       │  DDT_Loading.as:258  ComponentSetting.LANGUAGE = "portugal"
       │  DDT_Loading.as:301  lunchNormal() → new NormalLuncher()
       └─ NormalLuncher.as:130   CorePath = FLASHSITE + "2.png"   ← 4,45 MB
          NormalLuncher.as:363   ClassUtils.CreatInstance("ddt.DDT")
              └─ ddt/DDT.as:228   App.init(StageReferance.stage, appDomain)
                 ddt/DDT.as:248   ConfigParaser.paras(config.xml)
                 ddt/DDT.as:301   gera chave RSA do cliente (pública hardcoded)
                 ddt/DDT.as:318   RoomManager.setup()
                 ddt/DDT.as:321   KeyboardManager.getInstance().init(stage)   ◄── ENTRADA
                 ddt/DDT.as:322   StartupResourceLoader.start(2)
                    StartupResourceLoader.as:325  ui/portugal/language.txt + zhancode.txt
                    StartupResourceLoader.as:376  ui/portugal/swf/expression.swf
                    StartupResourceLoader.as:571  __onUIMoudleComplete → fila de ~62 loaders
                    StartupResourceLoader.as:509  finishLoadingProgress → Event.COMPLETE
                 ddt/DDT.as:275   StateManager.setState(LOGIN)
                    login/LoginStateView.as:54   GET Login.ashx?p=<RSA>&...
                    ddt/manager/ServerManager.as:118  ByteSocket.connect(IP, Port)
                    ddt/manager/GameSocketOut.as:87   PackageOut(LOGIN) com RSA
```

**Verificado como NÃO participate do boot:** `1.png` (só aparece no bloco `<update>`),
`3.png` (**0 referências** em todo o projeto), `gm1.swf`, `characterdefine.xml`,
`Loading.swf` (cadeia alternativa legada).

### 2.4 O truque do "PNG"

Todos os arquivos `.png` grandes da raiz são **SWF comprimidos** (assinatura `CWS`):

| Arquivo | Tamanho | SHA-256 (início) | Veredito |
|---|---|---|---|
| `1.png` | 273.365 | `43 57 53 0a 08 52 0a` | SWF v10 |
| `2.png` | 4.452.139 | `21F9B8E2…` | **SWF v38 — núcleo atual** |
| `3.png` | 225.021 | `43 57 53 0a 94 ac 08` | SWF v10 — **órfão** |
| `2.png.bak` | 4.383.640 | `060D3543…` | SWF v38 — build antigo |
| `2 - Copia.png` | 4.383.640 | `060D3543…` | idêntico ao `.bak` |
| `2.png.bak_…005427` | 4.452.403 | `E1D52D5F…` | SWF v38 — **3º build distinto** |

Existem **três builds diferentes** do núcleo na raiz. `2.swf` foi gerado como cópia
byte-a-byte do `2.png` (hash `21F9B8E2…`) para permitir a leitura pelos decompiladores.

### 2.5 Comunicação com o servidor

| Camada | Arquivo | Detalhe |
|---|---|---|
| Transporte | `road7th/comm/ByteSocket.as` | `flash.net.Socket` TCP, **cifra própria de 8 bytes** |
| Pacote | `PackageOut.as` / `PackageIn.as` | header 20 B: `magic 29099 \| len \| checksum \| code \| clientId \| ext1 \| ext2` |
| Despacho | `ddt/manager/SocketManager.as` | `switch` com **218 `case`, 0 `default`** |
| Replay | `ddt/manager/QueueManager.as` | atrasa pacotes por `extend2` (contagem de frames do servidor) |
| Host/IP | `ServerList.ashx` | resposta **AES-ECB** com chave **hardcoded no cliente** |
| Autenticação | `Login.ashx?p=<RSA>` + `PackageOut(LOGIN)` | `key` = `MD5(senha)`, sem sal, em **GET** |

**Endereço/porta** vêm do servidor, não do cliente: `ServerListAnalyzer.as:40-42`.
Não há **nenhum** host de socket em `config.xml`.

### 2.6 Funcionalidades: implementadas vs. incompletas

| Funcionalidade | Estado | Evidência |
|---|---|---|
| Login / sessão | ✅ implementada | `login/LoginStateView.as`, `GameSocketOut.as:65-94` |
| Salas e partidas | ✅ | `room/`, `roomList/`, `roomLoading/` |
| Batalha (mira/força/tiro) | ✅ | `game/view/GameView.as`, `ArrowView.as`, `EnergyView.as` |
| Inventário / equipar | ✅ | `bagAndInfo/`, `PlayerManager.as` |
| Mascotes | ✅ | `pet/`, `petsBag/` |
| Guilda / Casino / Consórcio | ✅ | `consortion/`, `casino` via `shop/` |
| Chat / IM | ✅ | `ChatManager.as`, `im/` |
| Loja / recharge | ✅ | `shop/`, `ConRechargeManager.as` |
| Tutorial | ⚠️ condicional | `TRAINER_STANDALONE=true`; `TrainerGameView.as:261-277` usa keyCodes **crus** |
| Webcam / `MonsterDebugger` | ⚠️ socket debugger no build | `com/demonsters/debugger/` (`xmlsocket://`) |
| CodeModules (`4.png`) | ❌ arquivo ausente | `CodeModuleLoader.as:29` referencia; sem downloader |
| `COUNT_PATH` / `StatisticPage` | ❌ código morto | 0 call-sites de `solveCountPath()` / `StatisticPage` |
| `Resize` / `orientation` | ❌ **inexistente** | 0 ocorrências de `stageWidth`, `landscape`, `portrait` |

---

## 3. Bugs encontrados (priorizados)

### 🔴 B0 — BLOQUEADOR: o player não executa Flash

**Evidência:** `player.html` (versão original, SHA-256 `7EE30DE1…`) linhas 60-98:
```html
<object id="ddtSwf" type="application/x-shockwave-flash" data="DDT_Loading_Air.swf" ...>
```
**Impacto:** o plugin Adobe Flash EOL em 31/12/2020. Em Chrome/Edge/Firefox/Safari atuais
isso é um `<object>` desconhecido → retângulo vazio. **O jogo não abre em nenhum navegador.**

**Correção aplicada:** Ruffle 0.7.1 em `vendor/ruffle/` + `assets/mobile/js/ruffle-runtime.js`.
Configuração crítica: `allowScriptAccess: true` — sem ele `ExternalInterface.available`
é `false` e todo o `DesktopManager`/bridge morre.

---

### 🔴 B1 — CRÍTICO: `player.html` não define nenhuma função do `ExternalInterface`

O AS3 chama 18 funções JS; a página **não definia nenhuma**. Como
`ExternalInterface.available` é verdadeiro (o player responde), o SWF recebia `TypeError`
silencioso em vez de um erro visível.

| Impacto | Evidência |
|---|---|
| **Queda de sessão não mostra nada** | `LeavePageManager.as:51-63` — `forcedToLoginPath()` só faz `ExternalInterface.call("game_interruption")`. Sem a função, o jogador fica numa **tela morta**. |
| `DesktopManager` nunca detecta desktop | `DesktopManager.as:26-33` |
| Ticker de turno nunca funciona | `PageInterfaceManager.as:17` → `title_effect.tickerBegin` |
| Erros de loader nunca aparecem | `BaseLoader.as:99`, `UIModuleLoader.as:143` → `alert` |

**Correção aplicada:** `assets/mobile/js/flash-host-bridge.js` (18 funções + 16 stubs de
social SDKs legados), com teste de regressão `tests/unit/flash-host-bridge.test.mjs`.

---

### 🔴 B2 — CRÍTICO: `mobile/player.html` busca o SWF no caminho errado

`mobile/` contém **apenas** `player.html`. O player montava
`data="DDT_Loading_Air.swf"` → `/mobile/DDT_Loading_Air.swf` → **404**. O jogo abria uma
tela preta sem mensagem.

**Correção aplicada:** `<base href="../">` em `mobile/player.html` + resolução por
`document.baseURI` em `ruffle-runtime.js`. Testado em `tests/e2e/player.e2e.mjs` teste 12.

---

### 🔴 B3 — CRÍTICO: `config.xml` com versão inválida no último passo

```xml
<version from="794" to="80">   <!-- 80 <= 794 -->
```
`LoaderSavingManager.applyUpdate` tem `if(param2 <= param1) return;`
(`LoaderSavingManager.as:86-89`) → o passo é ignorado, `1.png` nunca é invalidado e a
versão final fica presa em **794** para sempre.

**Correção aplicada:** `to="795"`.

---

### 🟠 B4 — ALTO: `STYLE_PATH` ausente gera URLs `.../cdn/nullm/...`

`ConfigParaser.as:58` faz `_loc5_.STYLE_PATH = param1.STYLE_PATH.@value;` **incondicionalmente**.
`config.xml` não tinha `<STYLE_PATH>` → `@value` = `null` → `PathManager.solveStylePath()`
(`PathManager.as:175`) produz `https://…/cdn/nullm/<tipo>/<item>.png` → **404 em todos os
itens de estilo** (boné, arma, fundo de personagem).

**Correção aplicada:** `<STYLE_PATH value="style/" />` (o default do próprio AS3,
`PathInfo.as:40`).

---

### 🟠 B5 — ALTO: `crossdomain.xml` com domínios inválidos

O atributo `domain` aceita **apenas nome de host**. As linhas antigas traziam caminho junto:
```xml
<allow-access-from domain=".sitemoderno.ddns.net/cdn" secure="false" />   <!-- inválido -->
<allow-access-from domain="sitemoderno.ddns.net/quest" secure="false" />   <!-- inválido -->
```
Someadas a **linhas duplicadas** (5/6 e 10/11 eram cópias literais).

**Correção aplicada:** hosts corrigidos + curinga `*.sitemoderno.ddns.net`, duplicatas
removidas. Documentado em `CORRECOES.md`.

---

### 🟠 B6 — ALTO: `web.config` sem MIME de `.wasm` e sem documento padrão

Sem `application/wasm`, o IIS responde *Incorrect response MIME type* e o Ruffle não
inicia. E `<defaultDocument>` listava `index.php`/`Default.htm`/… — **nenhum existe na
raiz**, então `GET /` devolvia **404**.

**Correção aplicada:** seção `<staticContent>` com `.wasm`/`.js`/`.json` e
`player.html` como primeiro documento padrão.

---

### 🟠 B7 — ALTO: `CoreManager.show()` re-baixa o core inteiro (4,45 MB)

`CoreManager.as:21,30-31` — o guard `CodeLoader.loaded("2.png")` **nunca é verdadeiro**,
porque o único `addLoadURL` é para `"4.png"` (`CodeModuleLoader.as:29`).
Chamado por 7 telas (`AnotherDimensionManager`, `ConRechargeManager`, `BattleGroudManager`,
`LotteryManager`, `MoneyTreeManager`, `PetIslandManager`, `VIPCouponsManager`) →
cada acesso baixa o core de novo.

> **Não corrigível sem recompilar o SWF.** Proposta em §6.

---

### 🟠 B8 — ALTO: `DisplayLoader` trava a fila com resposta de 0 bytes

`DisplayLoader.as:52-62`: se `_loader.data.length == 0`, o método retorna **sem** `_isLoading=false`,
**sem** `LOAD_ERROR` e **sem** `COMPLETE` → `QueueLoader.tryLoadNext` nunca avança →
`CORE_SETUP_COMPLETE` nunca dispara → **jogo preso na tela de loading para sempre**.

> **Não corrigível sem recompilar.** Proposta em §6.

---

### 🟠 B9 — ALTO: regex de cache do SharedObject só reconhece `http://`

`LoaderSavingManager.as:36`: `_reg1 = /http:\/\/[\w|.|:]+\//i`. O `config.xml` é 100% HTTPS
→ `getPath()` não remove o host → a chave fica `https---sitemoderno-ddns-net-flash-2-png`
e o `RegExp("^flash-2-png")` do `applyUpdate` **nunca casa** → **o cache nunca é purgado
em troca de versão**.

> **Não corrigível sem recompilar.** Proposta em §6.

---

### 🟠 B10 — ALTO: `ByteSocket.close()` remove os listeners ANTES de fechar

`ByteSocket.as:178-185`: `removeEvent(_socket)` (linha 180) antes de `_socket.close()`
(linha 183) → o `Event.CLOSE` **nunca chega** a `SocketManager.__socketClose`
(`SocketManager.as:118-122`) → **sem alerta e sem redirecionamento**.

Caso real: `bagAndInfo/bag/BagView.as:2159` fecha o socket após `changeSex` → a UI fica
morta sem aviso ao usuário.

> **Mitigação parcial aplicada:** `game_interruption` agora existe no host (B1), mas o
> caminho de fechamento programático continua perdido dentro do SWF.

---

### 🟠 B11 — ALTO: URL de recurso com dois `?`

`StartupResourceLoader.as:1510` monta `…/quest/GoodsCollect.xml?type=LightRoadPath`;
`LoaderManager.fixedVariablesURL` (`LoaderManager.as:291`) concatena `param1 + "?" + vars`
→ `…GoodsCollect.xml?type=lightroadpath?rnd=0.123`.

> **Não corrigível sem recompilar.**

---

### 🟠 B12 — ALTO: sem timeout de conexão nem de HTTP

`ServerManager.as:33` declara `CONNENT_TIME_OUT = 30000` e `:43` declara `_connentTimer` —
**nenhum dos dois é usado** (só 3 ocorrências no arquivo inteiro). Sem timeout, um SYN sem
resposta trava a tela de loading indefinidamente.

`BaseLoader.as:263-264` cria `URLRequest` **sem `.timeout`**; `_starTime` (`:129,268`) é
gravado e nunca lido.

> **Não corrigível sem recompilar.**

---

### 🟡 B13 — MÉDIO: `toLowerCase()` em todas as URLs quebra filesystem case-sensitive

`LoaderManager.as:96` aplica `toLowerCase()` na URL. Disco tem `chickActivation.swf`,
`NewChickenBox.swf`, `NewYearRice.swf`, `explorerManual.swf`, `prayIndiana.swf`,
`levelFund.swf`, `serverList.swf`… Em Linux/Nginx isso dá **404**.

> **Não corrigível sem recompilar.** No IIS (Windows) funciona.

---

### 🟡 B14 — MÉDIO: 42 `catch(e:Error){}` vazios engolindo erro de socket

Incluindo `ByteSocket.as:197-199` (`handleConnect`), `:209-211` (`handleClose`),
`:220-222` (`handleIoError`) e `:377-379` (`handlePackage` — **pacotes corrompidos
morrem sem log**).

### 🟡 B15 — MÉDIO: `switch` de 218 casos sem `default`

`SocketManager.as:155-844` — pacotes novos do servidor são **ignorados em silêncio**.

### 🟡 B16 — MÉDIO: `readPackage()` sem try/catch nem validação de tamanho

`ByteSocket.as:245-299` lê `len` do header (`:267`) e chama `loadE()` sem validar
`len >= 18` → um `len` corrompido lança `RangeError #2070` não tratado e **dessincroniza
o stream** (DoS remoto).

### 🟡 B17 — MÉDIO: `QueueManager.setLifeTime()` é no-op

`QueueManager.as:64-68`: `_executable.concat(_waitlist);` — o resultado é descartado;
pacotes atrasados nunca são liberados.

### 🟡 B18 — MÉDIO: vazamento massivo de listeners no `SocketManager`

```
SocketManager.Instance.addEventListener    → 477 ocorrências / 186 arquivos
SocketManager.Instance.removeEventListener → 209 ocorrências /  84 arquivos
```
Como é singleton, cada view fechada fica retida. Ex.: `ConsortionModelControl.as:110-128`
registra **19** listeners no construtor e **nenhum** remove.

### 🟡 B19 — MÉDIO: `littleGame/clock/Clock` nunca inicia e vaza listener

`Clock.start()` **não tem call-site** → `_lockedInServerTime`, `_latency` e `time` ficam
inúteis (`GameScene.as:391` usa `_game.clock.time` = 0). `removeEvent()`/`dispose()`
(`Clock.as:195-201`) têm **corpo vazio**, mas `addEvent()` (`:77`) registra listener no
singleton.

### 🟡 B20 — MÉDIO: `LittleGamePacketQueue.addQueue()` pode dar NPE

`_waitlist` (`:16`) só é alocado em `reset()`, chamado apenas em `SocketManager.as:1379`.

### 🟡 B21 — MÉDIO: `Security.loadPolicyFile` fora de try/catch

`ConfigParaser.as:107-111` — se a policy falhar, o erro **sobe e aborta `paras()` inteiro**,
deixando todos os `PathInfo` vazios → NPE em todos os `PathManager.solve*`.

### 🟡 B22 — MÉDIO: `LoaderSavingManager` é chamado por 2 vias diferentes

`DDT_Loading.as:205` e `RegisterLuncher.as:235` — mas `DDT_Loading_Air.swf` (o SWF servido)
e `DDT_Loading.swf` (citado no `<update>`) contêm **a mesma classe `DDT_Loading`** com
builds diferentes (7.366 B vs 14.347 B decompilado).

### 🟡 B23 — MÉDIO: `<update>` não cobre o SWF realmente servido

`config.xml:108-109,134-135` manda atualizar `DDT_Loading.swf`, mas `player.html` serve
`DDT_Loading_Air.swf`, que **não aparece** em nenhum `<version>`.

### ⚪ B24-B32 — BAIXO

| # | Bug | Evidência |
|---|---|---|
| B24 | Backups de 26 MB commitados na raiz (`.bak`, `.rar`, `.zip`, `2 - Copia.png`) | `git ls-tree -r HEAD` |
| B25 | `3.png` órfão (225 KB, 0 referências) | grep em todo o projeto |
| B26 | `gm1.swf` + `gm1.swf.md5` sem referência (o mecanismo MD5 lê `md5.xml`) | `Loading.as:180` |
| B27 | `characterdefine.xml` sem referência | grep |
| B28 | `codeCatharine.swf` vs `catharine.swf` (maiúsculas) | `PathManager.as:605-607` |
| B29 | `braveDoorDuplicate.xml` vs `bravedoorduplicate.xml` | `PathManager.as:1155-1157` |
| B30 | `levelReward.xml` vs `levelreward.xml` (funciona só pelo `toLowerCase`) | `PathManager.as:876-879` |
| B31 | Mensagem de erro trocada: `ddt.loader.LoadingDailyLeagueLevelFailure` em `creatServerConfigReloader` | `StartupResourceLoader.as:1898` |
| B32 | `App.loadAssets()` reutiliza `base` sem reset e sem `else` → `addLoader(null)` → TypeError #1009 | `App.as:91,106-128` |

---

## 4. Auditoria da entrada (para o painel mobile)

### 4.1 O jogo NÃO tem nenhuma entrada por toque

| Verificação | Resultado |
|---|---|
| `TouchEvent` em 3.497 arquivos `.as` | **0 ocorrências** |
| `MouseEvent` em `ArrowView.as` (mira) | **0 ocorrências** |
| `MouseEvent` em `EnergyView.as` (força) | apenas `CLICK` no slider (`:255`) |
| Único mouse em batalha | `GameLocalPlayer.as:342` — só **pós-morte** (alvo fantasma) |
| `stage.stageWidth` / orientação | **0 ocorrências** |
| `isMobile` / `isIpad` / `landscape` | **0 ocorrências** |

### 4.2 O caminho de entrada real

Central: `org/aswing/KeyboardManager.as`, inicializado em **um único lugar**
(`ddt/DDT.as:321`) sobre o `Stage`. Mantém `keySequence` e expõe `isKeyDown(uint)`.
Reinicia sozinho em `DEACTIVATE` (`:167-170`).

**Restrição crítica:** `KeyboardManager.as:134` — `if(!keySequence.contains(k) && k < 139)`.
Teclas ≥ 139 são silenciosamente descartadas.

### 4.3 Comandos de batalha (com evidência)

| Comando | Teclas | keyCode | Consumidor | Evidência |
|---|---|---|---|---|
| Andar ← | ← , A | 37, 65 | `SelfPlayerWalkAction` | `GameLocalPlayer.as:139-140`; `SelfPlayerWalkAction.as:49` |
| Andar → | → , D | 39, 68 | `SelfPlayerWalkAction` | `GameLocalPlayer.as:141-142`; `SelfPlayerWalkAction.as:51` |
| Ângulo + | ↑ , W | 38, 87 | `ArrowView` | `ArrowView.as:394-398`; `:427-429` |
| Ângulo − | ↓ , S | 40, 83 | `ArrowView` | `ArrowView.as:382-386`; `:422-424` |
| Carregar/disparar | ESPAÇO | 32 | `EnergyView` | `EnergyView.as:167`, `:177`, `:187`, `:194` |
| Mostrar/ocultar mira | T | 84 | `ArrowView` | `ArrowView.as:443-446` |

**Mecânica de força confirmada** — segurar ESPAÇO carrega, soltar dispara:
```actionscript
// game/view/EnergyView.as:165-202
if (KeyboardManager.isDown(Keyboard.SPACE)) {   // :167
    if (this._keyDown) this.calcForce();        // :171  acumula
    else if (!this._self.isMoving) {
        this._keyDown = true; this._onProcess = true;
        this._self.beginShoot();                // :177  trava o turno
        this._self.setCenter(x, y - 150, true);
    }
} else if (this._keyDown) {                     // :187  SOLTOU
    SoundManager.instance.stop("020"); SoundManager.instance.play("019");
    if (this._self.shootType == 0) this._self.sendShootAction(this._force);        // :194
    else                         this._self.sendShootAction(this._force - this._hitX); // :198
}
```

Parâmetros: `FORCE_MAX = 2000` (`EnergyView.as:30`), `_forceSpeed = 20` (`:45`),
`ROTATITON_SPEED = 1` (`WeaponInfo.as:9`), `ANGLE_NEXTCHANGE_TIME = 100 ms`
(`ArrowView.as:52`), `GAME_FPS = 25` (`Config.as:6`).

### 4.4 Pontos de `ExternalInterface` (o "host" que faltava)

**11 `addCallback` (AS3 → JS precisa registro):**
`SetIsDesktop`, `sendSwfNowUrl`, `setLoginType`, `checkComplete`, `deleteComplete`,
`flashGotoAndPlay`, `setSound`, `sinaCallBack`, `swfExitPrompt`, `SetFlashLoadExternal`,
`ExternalLoadStop`.

**18 `call` (AS3 → JS precisa existir):**
`IsDesktop`, `WindowReturn`, `setFlashCall`, `game_interruption`, `game_pay`,
`AddFavorite`, `setFavorite`, `getLocationUrl`, `addToFavorite`, `ExternalLoadStart`,
`alert`, `sendWeiboFeed`, `showInviteBox`, `facebookSend`, `setDailyTask`,
`setDailyActivity`, `ExitGameToLogin`, `closeWindow`, `title_effect.tickerBegin/Stop`.

**Nenhuma delas é um comando de batalha.** → Não existe bridge para injetar comandos.

---

## 5. Risco de segurança (informativo — nenhum item foi "corrigido" sem sua palavra)

| # | Achado | Evidência |
|---|---|---|
| S1 | Chave **AES do ServerList hardcoded no cliente** | `ddt/utils/CryptoUtil.as:12` `KEY = "7A8B9C2D15F01E381F91A0B6C6D68E4F"` |
| S2 | Chave RSA pública hardcoded (pinning do servidor) | `ddt/DDT.as:301-306` |
| S3 | `key` = `MD5(senha)` sem sal, em **GET** | `RequestVairableCreater.as:19`, `LoginStateView.as:74` |
| S4 | Cifra do socket é caseira; chave inicial **pública** e compartilhada por todos | `ByteSocket.as:23,74-77` |
| S5 | 5 URLs `http://` de terceiros **mortos** | `Validate17173.as:60-76` |
| S6 | Telemetria com `qid`=conta em HTTP claro (flag `enable="false"`) | `ExternalInterfaceManager.as:61,65` |
| S7 | 7 endpoints `http://` legados no `config.xml` (mixed content) | `config.xml:36-41,60` |
| S8 | `KIT_USER` pode **apagar cache de imagens** | `SocketManager.as:1218-1221` |
| S9 | JS injection: AS3 monta string JS com valor do config | `LeavePageManager.as:24,38` |

> **Nota sobre S6/S9:** `COUNT_PATH` (`assayerhandler.7road.com`) **não é usado** —
> 0 call-sites de `solveCountPath()`. O que realmente sai da máquina é
> `ExternalInterfaceManager` e `WeakGuildManager.timeStatistics` (POST de `id/grade/serverID`
> com `URLLoader` órfão, sem handler e sem timeout).

---

## 6. Correções **não** aplicáveis sem recompilar o SWF

Nenhuma destas foi alterada — para todas, a correção exige compilar o ActionScript com
Flex/AIR SDK e republicar `2.png`. Continuam **documentadas e priorizadas**:

| # | Correção proposta | Arquivo | Risco |
|---|---|---|---|
| P1 | Preencher o guard de cache em `CodeModuleLoader` (`addLoadURL("2.png")`) | `CodeModuleLoader.as:29` | baixo |
| P2 | Em resposta 0 bytes, emitir `LOAD_ERROR` + `COMPLETE` | `DisplayLoader.as:52-62` | médio |
| P3 | Envolver `Security.loadPolicyFile` em try/catch | `ConfigParaser.as:107-111` | baixo |
| P4 | Implementar `CONNENT_TIME_OUT` com `Timer` | `ServerManager.as:33,43` | médio |
| P5 | `.timeout` em todos os `URLRequest` | `BaseLoader.as:263` | baixo |
| P6 | Trocar regex do cache por `^https?://` | `LoaderSavingManager.as:36` | baixo |
| P7 | `close()` **depois** de remover listener (ordem invertida) | `ByteSocket.as:178-185` | médio |
| P8 | try/catch + validação `len >= 18` em `readPackage` | `ByteSocket.as:245-299` | baixo |
| P9 | `default:` no switch + log de pacote desconhecido | `SocketManager.as:155-844` | baixo |
| P10 | Atribuir o resultado em `setLifeTime()` | `QueueManager.as:64-68` | baixo |
| P11 | Corrigir a URL com dois `?` | `StartupResourceLoader.as:1510` | baixo |
| P12 | **Adicionar `MobileInputBridge.as`** (já escrito — ver `CONTROLES_MOBILE.md` §5) | novo | baixo |

---

## 7. O que NÃO foi validado (e por quê)

| Item | Motivo |
|---|---|
| Login real / sessão com o servidor | `sitemoderno.ddns.net` é um host dinâmico de terceiros; sem credenciais e sem garantia de disponibilidade |
| Batalha de ponta a ponta (mira → tiro → dano) | depende de login |
| Áudio e música | o navegador bloqueia autoplay; só destrava com gesto — e o `sound/*.flv` não existe localmente |
| Comportamento em iOS/Safari real | sem dispositivo iOS no ambiente; testado apenas com emulação de toque no Chromium |
| `screen.orientation.lock()` | não funciona no Chromium headless nem no desktop |
| Ruffle em produção com 4,45 MB de SWF + 389 SWFs | validado só o carregamento inicial; o volume de assets não foi exercitado até o login |

---

## 8. Conclusão

O projeto **não estava pronto para rodar** — não por causa do jogo, mas da camada web.
Os três bloqueadores (B0 player Flash morto, B1 host de ExternalInterface inexistente,
B2 caminho do `mobile/player.html`) estão **corrigidos e testados**.

O painel mobile foi construído sobre o **único caminho de entrada que o jogo realmente
possui** (teclado), sem duplicar regra de jogo, e com **sondagem de capacidade em runtime** —
não assumindo que o browser entrega o evento. O teclado do desktop não é interceptado em
nenhum momento.

Permanecem 12 correções de dentro do SWF (`§6`), todas de risco baixo a médio, que só
podem ser aplicadas recompilando o core com Flex SDK.