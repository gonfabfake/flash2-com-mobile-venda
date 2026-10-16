# INSTALACAO.md

## Requisitos

| Item | Versão | Observação |
|---|---|---|
| Navegador | Chrome/Edge/Firefox/Safari **atual** | O plugin Adobe Flash está morto; usamos Ruffle |
| Node.js | ≥ 18 (validado em **24.21**) | só para servir a pasta e rodar os testes |
| Servidor web | qualquer | **obrigatório** — o jogo não funciona em `file://` |
| Disco | ~120 MB | 4,5 MB do núcleo + 389 SWFs + 2 WASM do Ruffle |

> **Não é necessário** Java, Flash Player, Adobe AIR nem Flex SDK para **rodar** o jogo.
> Flex SDK só é necessário se você quiser recompilar o `2.png` (ver §6).

---

## 1. Rodar localmente (desenvolvimento)

```powershell
cd "C:\Users\gonfa\OneDrive\Desktop\flash - Copia (2)"
npm start
```

Abre em <http://127.0.0.1:8080/player.html>.

O servidor de desenvolvimento (`tests/server.mjs`) já envia os MIME types corretos —
**`.wasm → application/wasm`**, que é obrigatório para o Ruffle. Em outro servidor
web, garanta isso.

### Endereços úteis

| URL | Para quê |
|---|---|
| `/player.html` | jogo normal (painel tátil aparece sozinho em celular) |
| `/player.html?ui=force&debug=1` | força o painel no desktop + abre o log de diagnóstico |
| `/mobile/player.html` | mesmo player a partir da subpasta `mobile/` |
| `/player.html?swf=DDT_Loading.swf` | carrega outro SWF |

### Parâmetros

| Parâmetro | Efeito |
|---|---|
| `?swf=` | qual SWF carregar (default `DDT_Loading_Air.swf`) |
| `?ui=force` / `?ui=off` | força / proíbe o painel tátil |
| `?debug=1` | painel de diagnóstico |
| `?gate=1` | força a tela de início no desktop |
| `?desktop=1` | faz o host responder `IsDesktop() === true` |
| `?auto=0` | não executa o bootstrap automático |

Qualquer outro parâmetro é repassado como **flashvars**, como no player original.

---

## 2. Publicar em produção (IIS / Windows Server)

O `web.config` já está configurado. Três requisitos **não negociáveis**:

### 2.1 MIME type de `.wasm` — obrigatório

```xml
<staticContent>
    <remove fileExtension=".wasm" />
    <mimeMap fileExtension=".wasm" mimeType="application/wasm" />
</staticContent>
```

Já aplicado em `web.config`. Sem isso o navegador responde
*Incorrect response MIME type* e o jogo **não abre**.

### 2.2 Documento padrão — obrigatório

```xml
<defaultDocument>
    <files><clear /><add value="player.html" /> ...</files>
</defaultDocument>
```

Já aplicado. Sem isso `GET /` devolve **404** (nenhum `index.*` existe nesta pasta).

### 2.3 HTTPS — recomendado

Todo o `config.xml` já aponta para `https://`. Abrir a página por `http://` gera
*mixed content* e o navegador bloqueia recursos. O `web.config` fornecido não força
redirecionamento para HTTPS porque isso depende da topologia do seu servidor — adicione
o módulo de URL Rewrite se precisar.

### 2.4 Crossdomain

`crossdomain.xml` precisa ser servido em `https://sitemoderno.ddns.net/cdn/` — é o que
o jogo baixa (`config.xml` → `<POLICY_FILES>`).

---

## 3. Nginx (alternativa ao IIS)

```nginx
server {
    listen 443 ssl http2;
    server_name  seu-dominio;

    root /caminho/para/flash;

    location / {
        try_files $uri $uri/ /player.html;
        index player.html;
    }

    # OBRIGATÓRIO para o Ruffle
    types { application/wasm wasm; application/x-shockwave-flash swf; }
    default_type application/octet-stream;

    location ~* \.(wasm|js|json)$ {
        add_header Cache-Control "public, max-age=31536000, immutable";
    }
}
```

Não adicione `add_header X-Frame-Options DENY` sem `Content-Security-Policy frame-ancestors`:
o `LeavePageManager` injeta `top.location.href` e alguns wrappers usam `top`.

---

## 4. Ruffle — o que foi instalado

| Item | Valor |
|---|---|
| Versão | **0.7.1** (`v0.7.1`, build 2026-10-07) |
| Pacote | `ruffle-0.7.1-web-selfhosted.zip` |
| Licença | MIT + Apache-2.0 (`LICENSE_MIT`, `LICENSE_APACHE` incluídos) |
| Local | `vendor/ruffle/` |
| Tamanho | ~29 MB (2 WASM + 2 glue JS) |

Atualizar: baixar o novo `*-web-selfhosted.zip` e substituir o conteúdo de `vendor/ruffle/`.
**Não** é preciso mudar nada no código.

### Configuração do Ruffle e por quê

| Opção | Valor | Motivo |
|---|---|---|
| `allowScriptAccess` | `true` | **Obrigatório.** Sem isso `ExternalInterface.available` é `false` e todo o `DesktopManager`/bridge do jogo morre. |
| `scale` | `exactfit` | `App.as:52` já fixa `stage.scaleMode = "exactFit"`. |
| `letterbox` | `off` | O jogo desenha o próprio fundo (`SHOW_BACKGROUND=true`). |
| `backgroundColor` | `#000000` | evita flash branco na troca de cena. |
| `setShowMenu` | `false` | o menu nativo do Ruffle cobre a UI. |
| `ruffleLogLevel` | `warn` | `debug` é útil para diagnosticar AVM2, mas polui muito. |

---

## 5. Testes

```powershell
npm install          # uma única vez
npx playwright install chromium

npm run test:unit    # 49 testes, sem browser, ~0,6 s
npm run test:e2e     # 13 testes em Chromium real
npm test             # os dois
```

Resultados, cobertura e limitações: **`TESTES.md`**.

---

## 6. (Opcional) Recompilar o core com Flex SDK

Só é necessário se você quiser aplicar as correções internas do SWF listadas em
`AUDITORIA.md` §6, ou ativar a `MobileInputBridge`.

```powershell
# 1. Baixe o Flex SDK (Apache 2.0) — requer JDK; atencao ao volume (~1 GB)
# 2. Copie source/scripts para um projeto Flex vazio
# 3. Adicione assets/mobile/as3/MobileInputBridge.as ao src
# 4. Em ddt/DDT.as:321, acrescente:
#      if(ExternalInterface.available) MobileInputBridge.install();
# 5. Publique para 2.png e 2.swf
```

**Aviso honesto:** recompilar este projeto é um trabalho grande. São 3.497 classes
decompiladas + UI Morn gerada pelo Flash CC + 389 bibliotecas SWF. O código
decompilado **não** recompila sem ajustes. Antes disso, a alternativa honesta é
corrigir apenas a camada web (que foi o que fizemos) e conviver com os 12 patches
documentados em `AUDITORIA.md` §6.

---

## 7. Checklist de diagnóstico quando algo não abre

| Sintoma | Causa provável | O que fazer |
|---|---|---|
| Página em branco | `.wasm` sem MIME `application/wasm` | ajustar servidor (IIS/nginx) |
| "Incorrect response MIME type" | idem | idem |
| 404 em `/` | falta `player.html` no `defaultDocument` | ajustar `web.config` |
| Tela preta, sem mensagem | `DDT_Loading_Air.swf` não baixou | abrir `?debug=1` e ver o log |
| Erros AVM2 `#1010` no console | **bug pré-existente** em `NormalLuncher` | ver `AUDITORIA.md` §3 / `TESTES.md` |
| Botões não respondem | painel não apareceu | usar `?ui=force`; conferir `capabilities.touch` em `?debug=1` |
| Botão responde mas o jogo ignora | regra de batalha bloqueia | é correto: `_isShooting`/`isAttacking` bloqueiam |
| Sem áudio | política de autoplay do browser | toque na tela (o gate faz isso sozinho em celular) |
| Só funciona uma vez e trava ao recarregar | `Error #1010` do loader | ver acima; recarregar a página limpa o estado |

---

## 8. Estrutura do projeto após a modernização

```
flash - Copia (2)/
├── AUDITORIA.md            ← bugs encontrados, com evidência
├── CORRECOES.md            ← o que foi alterado e por quê
├── CONTROLES_MOBILE.md     ← como o painel funciona
├── TESTES.md               ← o que foi testado (e o que não)
├── INSTALACAO.md           ← este arquivo
│
├── player.html             ← entrypoint (reescrito)
├── mobile/player.html      ← entrypoint mobile (base ../ corrigido)
├── config.xml              ← B3 e B4 corrigidos
├── crossdomain.xml         ← B5 corrigido
├── web.config              ← B6 corrigido (.wasm + default document)
│
├── assets/mobile/
│   ├── css/mobile-controls.css
│   ├── js/                 ← 10 módulos (ver CORRECOES.md §4.1)
│   └── as3/MobileInputBridge.as   ← bridge pronta para compilar
│
├── vendor/ruffle/          ← Ruffle 0.7.1 selfhosted
├── source/scripts/         ← 3.497 .as decompilados (referência)
├── tests/                  ← unit + e2e + server
├── _backup/                ← backups movidos (nada foi apagado)
│
├── 2.png / 2.swf           ← núcleo (SWF disfarçado de PNG)
├── DDT_Loading_Air.swf     ← loader
├── ui/{portugal,spain}/    ← recursos de UI
└── *.swf, *.xml, *.png     ← recursos
```