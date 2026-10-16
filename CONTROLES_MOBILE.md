# CONTROLES_MOBILE.md — como o painel funciona

> Implementação: `assets/mobile/js/mobile-controls.js` + `assets/mobile/css/mobile-controls.css`
> Mapa de teclas: `assets/mobile/js/keymap.js`

---

## 1. Por que o painel existe

O jogo **não tem nenhuma entrada por toque**. Verificado em 3.497 arquivos `.as`:

| Verificação | Resultado |
|---|---|
| `TouchEvent` | **0 ocorrências** |
| `MouseEvent` em `ArrowView.as` (mira) | **0 ocorrências** |
| `stage.stageWidth` / `landscape` / `portrait` | **0 ocorrências** |
| `isMobile` / `isIpad` | **0 ocorrências** |
| Único `MouseEvent` em batalha | `GameLocalPlayer.as:342` — só **pós-morte** (alvo fantasma) |

O jogo é **100% teclado**. O painel é, portanto, uma camada externa que traduz
toque nas teclas que o jogo já escuta — **sem duplicar nenhuma regra do jogo**.

---

## 2. Arquitetura (separação de camadas)

```
   TOQUE / MOUSE / TECLADO
            │
            ▼
   ┌──────────────────────┐
   │  mobile-controls.js  │  camada VISUAL — não conhece teclas,
   │  (painel, ícones,    │  nem Ruffle, nem Flash.
   │   barra de força)     │  Só chama input.press(ACTION.X)
   └──────────┬───────────┘
              │  press/release(action, source)
              ▼
   ┌──────────────────────┐
   │  input-core.js       │  estado semântico + anti-comando-preso
   │  (SEM DOM)           │  testável em Node
   └──────────┬───────────┘
              │
              ▼
   ┌──────────────────────────────────────────┐
   │  adaptadores (escolha por capacidade)     │
   ├──────────────────────────────────────────┤
   │  external-interface-adapter.js  ← ativo   │  bridge AS3 (opcional)
   │  key-event-adapter.js           ← padrão  │  KeyboardEvent no Ruffle
   └──────────────────────────────────────────┘
              │
              ▼
        ruffle-player  ──►  Flash  ──►  org.aswing.KeyboardManager
                                                     │
                            ┌────────────────────────┼────────────────────────┐
                            ▼                        ▼                        ▼
                  SelfPlayerWalkAction           ArrowView               EnergyView
                  (andar)                        (ângulo)                (força/tiro)
```

**Regra da ETAPA 6 (separar visual de lógica) é respeitada:** `mobile-controls.js`
importa apenas `keymap.js` (nomes de ação) e `force-meter.js` (número puro).
Ele nunca vê um `keyCode`.

---

## 3. O mapa de teclas (extraído do AS3, não inventado)

| Controle mobile | Ação | Tecla entregue | keyCode | Onde o jogo escuta |
|---|---|---|---|---|
| ◀ | `move_left` | `ArrowLeft` | **37** | `SelfPlayerWalkAction.as:49`; `GameLocalPlayer.as:139` |
| ▶ | `move_right` | `ArrowRight` | **39** | `SelfPlayerWalkAction.as:51`; `GameLocalPlayer.as:141` |
| − | `angle_down` | `ArrowDown` | **40** | `ArrowView.as:382,386` / `:422,424` |
| + | `angle_up` | `ArrowUp` | **38** | `ArrowView.as:394,398` / `:427,429` |
| 🔥 | `shoot` | `Space` | **32** | `EnergyView.as:167,187,194` |
| ⌖ | `toggle_arrow` | `KeyT` | **84** | `ArrowView.as:443-446` |

**Aliases que o jogo também aceita** (não usados pelo painel, mas mapeados para
documentação): `A`=65, `D`=68, `W`=87, `S`=83.

### Restrição do `KeyboardManager` que moldou o projeto

```actionscript
// org/aswing/KeyboardManager.as:134
if(!this.keySequence.contains(_loc3_) && _loc3_ < 139) this.keySequence.append(_loc3_);
```
Teclas **≥ 139 são silenciosamente descartadas**. Todas as teclas do painel estão
abaixo disso — e isso é verificado por teste (`keymap.test.mjs`).

### Por que setas e não WASD

O caminho exercitado a cada `ENTER_FRAME` é `Keyboard.LEFT/RIGHT/UP/DOWN/SPACE`.
As letras (A/D/W/S) só entram em `GameLocalPlayer.registerKeyAction` (`__turnLeft`),
que **não** é chamado pelo polling de `ArrowView`/`EnergyView`. Escolher as setas
maximiza a cobertura dos três subsistemas de uma vez.

### Por que `key`/`code` e não `keyCode`

O binário WASM do Ruffle lê `KeyboardEvent.key` e `KeyboardEvent.code` — a string
`"keyCode"` aparece **0 vezes** no glue JS do Ruffle 0.7.1. Por isso o evento é
construído com `key` e `code` corretos; `keyCode`/`which` são anexados por
`defineProperty` apenas como compatibilidade extra para players baseados no plugin
Adobe.

---

## 4. Como cada controle se comporta

### 4.1 Movimento (◀ ▶) — inferior esquerdo

- **Pressionar** → 1 `keydown` e **nada mais**.
  O jogo consulta `KeyboardManager.isKeyDown(37)` a cada frame
  (`SelfPlayerWalkAction.isDirkeyDown()`), portanto o movimento é contínuo
  **sem inundar o DOM**.
- **Soltar** → 1 `keyup` → o personagem para imediatamente.
- Pressionar duas vezes não duplica nada (idempotente).
- O movimento é cancelado por: soltar, `pointercancel`, `lostpointercapture`,
  `blur`, `pagehide`, `visibilitychange`, ou 4 s sem `pointerup` (varredura de segurança).
- `direction` é invertido pelo próprio jogo (`GameLocalPlayer.__turnLeft/Right`),
  respeitando `_isShooting`, `isAttacking` e `MAX_MOVE_TIME`.

### 4.2 Ângulo (− +) — ao lado do movimento, mesma forma

- Mesmo formato, **mesmo tamanho, mesma borda** — só muda o símbolo e a ação
  (requisito explícito da ETAPA 3).
- Cada toque aplica **1 grau** (`WeaponInfo.ROTATITON_SPEED = 1`).
- Segurar aplica **1 grau a cada 100 ms** (`ArrowView.ANGLE_NEXTCHANGE_TIME = 100`),
  exatamente o mesmo throttle do jogo.
- O clamp em `armMinAngle`/`armMaxAngle` é do próprio `LocalPlayer.gunAngle` — o
  painel **não** limita nada.

### 4.3 Força e disparo (🔥) — inferior direito

A mecânica **existe** e é esta (mantida idêntica):

```
segurar 🔥  →  keydown SPACE  →  EnergyView entra em "carregando"
                                └─ LocalPlayer.beginShoot()  trava o turno
soltar  🔥  →  keyup SPACE    →  LocalPlayer.sendShootAction(forca)
```

- A barra anima de `0 → 2000` a **20 por frame a 25 fps** (ping-pong), espelhando
  `EnergyView.calcForce()` (`_forceSpeed = 20`, `FORCE_MAX = 2000`).
- Se a barra descer a zero, o jogo executa **`skip()`** (turno pulado) — o painel
  reflete isso devolvendo `0` em vez de um disparo.
- Feedback visual: a barra muda de cor (verde → amarelo → vermelho) e o botão pulsa.
- Rótulo numérico exibe o valor.

> **Ressalva honesta:** a barra é uma **réplica do algoritmo**, não a leitura do
> estado real — o `_force` do `EnergyView` é privado e o SWF publicado não expõe
> leitura. Está rotulada como **"força (estimativa)"** na própria UI.
> Quando a bridge AS3 for compilada (`§5`), `getState()` passa a devolver o valor
> autoritativo e a previsão deixa de ser necessária.

### 4.4 Áreas seguras e posicionamento

```
┌──────────────────────────────────────────────────────────────┐
│ [DDTank · status]                          [⌖] [☰]  ← topo   │
│                                                              │
│                    CAMPO DE BATALHA                          │
│                        (intocado)                            │
│                                                              │
│ ┌──────────┐ ┌────┐ ┌────┐                    ┌──────────┐  │
│ │    ◀     │ │  −  │ │  +  │   hint            │  força   │  │
│ │    ▶     │ └────┘ └────┘                    │ ▓▓▓░░░░  │  │
│ └──────────┘                                 └──────────┘  │
│  movimento      ângulo                            🔥        │
│  esquerda                                              direita│
└──────────────────────────────────────────────────────────────┘
   ↑ env(safe-area-inset-left)                          ↑ inset-right
   ↑ env(safe-area-inset-bottom)                         ↑ inset-bottom
```

- **Movimento**: inferior esquerdo.
- **Ângulo**: imediatamente à direita do movimento, **sem sobreposição** (gap via CSS).
- **Força/disparo**: inferior direito, com a barra **acima** do botão — nunca sobre
  o personagem.
- **Informações**: faixa compacta no topo, translúcida.
- **Menus**: canto superior direito, fora do campo.
- **Insets**: `env(safe-area-inset-*)` em todos os cantos (notch e barras de navegação).
- O contêiner do painel tem **`pointer-events: none`** — só os botões capturam toque.
  Tocar no meio da tela passa direto para o jogo.

### 4.5 Sem comando preso

Cinco camadas independentes de proteção:

| Camada | Gatilho | Efeito |
|---|---|---|
| `pointercancel` / `lostpointercapture` | gesto cancelado pelo SO | solta aquele botão |
| `blur` / `pagehide` | perda de foco, troca de aba | solta **tudo** |
| `visibilitychange` → `hidden` | app em background | solta **tudo** |
| `InputCore.sweep()` a cada 1 s | 4 s sem `pointerup` | solta o que ficou preso |
| `keyup` no próprio botão | `blur` do botão (acessibilidade) | solta aquele botão |

Testado em `tests/e2e/player.e2e.mjs` teste **6** e em `input-core.test.mjs`.

---

## 5. A bridge correta (`ExternalInterface`) — como ativar

O adaptador por teclado funciona **hoje**. Mas ele é uma camada de compatibilidade:
depende de o Ruffle translating eventos DOM em eventos Flash. A solução **definitiva**
é um bridge no AS3 que chama **os métodos do próprio jogo** — o painel deixa de
traduzir teclas e passa a emitir **intenções**.

### 5.1 O que já está pronto

- `assets/mobile/as3/MobileInputBridge.as` — classe completa e comentada.
- `assets/mobile/js/adapters/external-interface-adapter.js` — adaptador JS, **completo e testado**.
- A precedência é automática: se o SWF registrar a bridge, ela **assume** e o teclado é ignorado.

### 5.2 Pré-requisito: 2 linhas no core

Os handlers de movimento são **privados**:

```actionscript
// game/objects/GameLocalPlayer.as:205
private function __turnLeft() : void   →  public function turnLeft() : void
// game/objects/GameLocalPlayer.as:221
private function __turnRight() : void  →  public function turnRight() : void
```

Isso é deliberado: eles aplicam as regras do jogo (inverter `info.direction`,
respeitar `_isShooting`, `isAttacking`, `_keyDownTime`, `MAX_MOVE_TIME` e só então
disparar `SelfPlayerWalkAction`). **Não os reimplementamos** — publicar é o que
permite que desktop e mobile compartilhem exatamente o mesmo código.

### 5.3 Instalação

Em `ddt/DDT.as`, dentro de `setup()`, logo após a linha 321:

```actionscript
KeyboardManager.getInstance().init(StageReferance.stage);   // :321
if(ExternalInterface.available) MobileInputBridge.install();  // <- adicionar
```

### 5.4 Contrato

```
JS  ──▶  ddtMoveLeft()          → GameLocalPlayer.turnLeft()
JS  ──▶  ddtMoveRight()         → GameLocalPlayer.turnRight()
JS  ──▶  ddtAngleUp()           → LocalPlayer.manuallySetGunAngle(+1)
JS  ──▶  ddtAngleDown()         → LocalPlayer.manuallySetGunAngle(-1)
JS  ──▶  ddtReleaseAngle()      → fim do ajuste contínuo
JS  ──▶  ddtBeginShoot()        → LocalPlayer.beginShoot()
JS  ──▶  ddtReleaseShoot(f)     → LocalPlayer.sendShootAction(f)
JS  ◀──  ddtGetState()          → {angulo, forca, direcao, podeAndar, podeAtirar}
AS3 ─▶  ddtBridgeReady()        → JS sabe que existe bridge melhor
```

### 5.5 Ganho com a bridge ativa

| | Adaptação por teclado | Com bridge AS3 |
|---|---|---|
| Depende do browser entregar evento ao player | sim | **não** |
| Barra de força | estimativa local | **valor real** |
| RespETA | 1 frame de evento | imediato |
| Risco de o browser "engolir" o evento | existe | **zero** |

---

## 6. Compatibilidade com desktop (ETAPA 5)

| Garantia | Como é cumprida |
|---|---|
| Teclado original preservado | **Nenhum listener de teclado é instalado** pela nossa camada. O navegador entrega direto ao Ruffle. |
| Mouse original preservado | O painel usa `pointer-events: none` no contêiner; os botões capturam apenas o próprio toque. |
| Regras de batalha intactas | Nenhuma regra replicada. O painel só produz as teclas / intenções que o jogo já processa. |
| Protocolo de rede intacto | **Nenhuma alteração** em `SocketManager`, `ByteSocket`, `GameSocketOut` ou pacotes. |
| SWFs originais intactos | `2.png`, `2.swf` e os 389 `.swf` não foram modificados. |
| Código compartilhado | `keymap.js` é a **mesma** fonte para desktop e mobile. |
| Detecção por capacidade | `capabilities.js` mede `pointer`, `maxTouchPoints`, `hover`, `fullscreenEnabled` — **nunca** user-agent. |

**Quando o painel aparece:** apenas quando há toque **e** não há cursor fino.
Um tablet com caneta/teclado **não** recebe dois painéis sobrepostos.
`?ui=force` e `?ui=off` sobrepõem a detecção (útil para QA e demonstração).

---

## 7. Parametros de URL

| Parâmetro | Efeito |
|---|---|
| `?swf=DDT_Loading.swf` | carrega outro SWF (mesmo comportamento do player original) |
| `?ui=force` | mostra o painel tátil mesmo no desktop |
| `?ui=off` | esconde o painel tátil mesmo no celular |
| `?debug=1` | abre o painel de diagnóstico com o log de eventos |
| `?gate=1` | força a tela de início no desktop |
| `?desktop=1` | faz o host responder `IsDesktop() === true` ao SWF |
| `?auto=0` | não executa o bootstrap automático |

Todos os **demais** parâmetros são repassados como **flashvars**, exatamente como o
player original fazia.

---

## 8. Acessibilidade

- Cada botão tem `aria-label` descritivo e `aria-pressed` sincronizado com o estado.
- Botões são focáveis: `Enter`/`Espaço` pressionam e soltam corretamente
  (permite testar o painel só com teclado, inclusive em E2E).
- Respeita `prefers-reduced-motion: reduce` (desliga transições e animação do pulso).
- Alvos de toque ≥ 56 px em qualquer viewport (testado em 4 resoluções).