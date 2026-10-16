# Source — decompilação de `2.swf`

## O que é isto

Este diretório contém o **código-fonte ActionScript 3** extraído do arquivo `2.swf`.

> **Atenção:** o arquivo `2.png` da pasta raiz **não é uma imagem**. Ele é um SWF
> (assinatura `CWS`, SWF versão 38) apenas renomeado para `.png` — o jogo usa a
> extensão `.png` para o arquivo principal. O `2.swf` foi gerado como cópia
> idêntica do `2.png` para permitir a leitura pelos decompiladores.

## Como foi gerado

| Item | Valor |
|---|---|
| Origem | `2.png` → cópia para `2.swf` |
| Decompilador | FFDec / JPEXS `version26.3.0` |
| Runtime | OpenJDK Temurin JRE 21.0.12.1 (portátil) |
| Comando | `java -Xmx4g -jar ffdec-cli.jar -export script ".\source" ".\2.swf"` |
| Tempo | ~1min32s |

## Estrutura

```
source/
├── README.md
└── scripts/                 <- raiz dos pacotes ActionScript
    ├── App.as               <- classe principal / bootstrap
    ├── Config.as
    ├── CharacterFactory.as
    ├── ddt/                 <- núcleo do jogo (data, manager, loader, view...)
    ├── road7th/             <- comunicação com o servidor (ByteSocket, PackageIn)
    ├── com/pickgliss/       <- framework de UI
    ├── room/ roomList/      <- salas e partidas
    ├── pet/ petsBag/        <- sistema de mascotes
    └── ... (767 pastas no total)
```

- **3.497 arquivos `.as`** · **767 pastas** · ~19,5 MB
- **0 erros de decompilação** (nenhum marcador `$ERR` / `Could not decompile`)
- O SWF **não contém mídia embutida** (`characterCount = 0`): apenas código.
  Imagens, sons e shapes vêm dos SWFs separados na raiz (`shape.swf`,
  `monster.swf`, `audio.swf`, `DDT_Loading_Air.swf`, etc.).

## Classe principal

A classe de documento usa nome ofuscado (hash):

```
_cb6a80a7adc8f3e6dd3da6624b713d056d8ba7e3aadf3d5eda2dfa1c98a29810_flash_display_Sprite.as
```

## Para recompilar

É necessário o **Flex SDK** (ou AIR SDK) correspondente. Referências úteis:

- `ddt/manager/SocketManager.as` — gerenciador de socket (entrada/saída de pacotes)
- `ddt/manager/GameSocketOut.as` — serialização de pacotes para o servidor
- `road7th/comm/ByteSocket.as` — socket TCP bruto
- `ddt/loader/StartupResourceLoader.as` — carregamento de assets externos

Para re-decompilar após alterar o SWF:

```powershell
$java = "C:\Users\gonfa\AppData\Local\Temp\opencode\ffdec\jre\jdk-21.0.12.1+1-jre\bin\java.exe"
& $java -Xmx4g -jar "C:\Users\gonfa\AppData\Local\Temp\opencode\ffdec\ffdec\ffdec-cli.jar" `
       -export script ".\source" ".\2.swf"
```