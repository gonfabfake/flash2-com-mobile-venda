# 🖥️ Servidor local do DDTank

Implementação do backend em Node para rodar o jogo **100% na sua máquina**,
sem depender de nenhum servidor externo.

```powershell
npm start
```

```
  DDTank Mobile — servidor local
  ────────────────────────────────────────────────
  jogo            http://127.0.0.1:8080/player.html
  painel mobile   http://127.0.0.1:8080/player.html?config=config.local.xml&ui=force&debug=1
  diagnóstico     http://127.0.0.1:8080/mobile/player.html
  socket de jogo  127.0.0.1:PORT
```

---

## O que ele faz

| Parte | Arquivo | O que resolve |
|---|---|---|
| HTTP estático | `local-server.mjs` | serve o jogo, o Ruffle e os assets com os MIME certos (`.wasm`!) |
| `ServerList.ashx` | `local-server.mjs` | **gerado em tempo real**, cifrado com AES-256-ECB e apontando para o socket TCP local |
| Socket de jogo | `socket-server.mjs` | protocolo `road7th.comm` completo (framing, checksum, cifra) |
| Codec | `protocol.mjs` | traduz o `ByteArray` do Flash para Node, com evidência `arquivo:linha` |

O ponto central: `ServerList.ashx` era um arquivo estático, então apontava para
um servidor que não existe. Agora ele é **gerado** com a porta real do socket,
cifrado com a mesma chave que `ddt/utils/CryptoUtil.as:12` usa, e o cliente
decifra sem reclamar.

---

## O protocolo, verificado campo a campo

Cada regra foi extraída do ActionScript decompilado:

| Elemento | Valor | Fonte |
|---|---|---|
| magic | `29099` | `PackageOut.as:8` |
| header | 20 bytes | `PackageIn.as:8` |
| checksum | `119 + Σ(bytes[6..]) & 0x7F7F` | `PackageOut.as:45-54` |
| chave padrão | `[174,191,86,120,171,205,239,241]` | `ByteSocket.as:23` |
| cifra | rolling de 8 bytes, pacote inteiro | `ByteSocket.as:147-163` |
| `readDate` | **7 bytes** (short + 5×byte) | `PackageIn.as:99-108` |
| resposta LOGIN | 57 campos, byte 0 = 0 | `ServerManager.as:210-290` |

Dois detalhes que quebram qualquer implementação ingênua, ambos cobertos por teste:

1. **A chave é rolling entre pacotes, mas o índice `i` reinicia em 0 a cada
   pacote.** Cifrar o stream inteiro numa passada só (índice global) produz lixo.
2. **`readDate` são 7 bytes, não 8.** Um off-by-one aqui desalinha todos os
   campos seguintes do LOGIN silenciosamente.

---

## ⚠️ Onde para, e por quê

O login **não fecha** num servidor novo, e isso é criptográfico, não um bug:

```
ddt/DDT.as:300        modulus RSA-1024 hardcoded no cliente
ddt/DDT.as:301        e = 65537 ("AQAB")
GameSocketOut.as:85   blob = RSA(pubKey, timestamp + 8 bytes aleatórios + "user,pass")
GameSocketOut.as:92   socket.setKey(8 bytes aleatórios)   ← TROCA a chave depois
```

Para cifrar a resposta de login o servidor precisa dos **8 bytes aleatórios**,
que estão dentro do blob RSA. Só a chave **privada** os revela — e ela está no
servidor original, não no cliente. Fatorar um modulus de 1024 bits não é
factível.

Ou seja: **para jogar de verdade é obrigatório o backend original.** O que este
servidor entrega é a infraestrutura verificada e pronta, mais o diagnóstico
exato de onde para.

---

## Testes

```powershell
npm run test:unit
```

| Arquivo | Testes | Cobre |
|---|---|---|
| `tests/unit/protocol.test.mjs` | 12 | cifra contra implementação AS3 de referência, checksum, framing, rolling key, offsets do LOGIN |
| `tests/unit/local-server.test.mjs` | 9 | HTTP, `ServerList.ashx` decifrado com a chave do `CryptoUtil`, socket PING e LOGIN |

**86 testes no total, todos passando.**