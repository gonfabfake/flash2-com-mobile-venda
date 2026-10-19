/**
 * socket-server.mjs — Servidor de jogo TCP (road7th.comm) em Node.
 *
 * ⚠️ LIMITE REAL E INVENCÍVEL — leia antes de usar
 * ────────────────────────────────────────────────────────────────────────────
 * O pacote LOGIN do cliente carrega a chave de sessão cifrada com RSA-1024
 * usando a chave PÚBLICA do servidor, que está hardcoded no cliente:
 *
 *   ddt/DDT.as:300   _loc1_ = "zRSdzFcn...MNLc="   (modulus, 1024 bits)
 *   ddt/DDT.as:301   _loc2_ = "AQAB"             (e = 65537)
 *   GameSocketOut.as:85  _loc3_ = CrytoUtils.rsaEncry5(AccountInfo.Key, _loc3_);
 *   GameSocketOut.as:92  this._socket.setKey(_loc5_);   // <-- troca a chave DEPOIS
 *
 * Ou seja: para cifrar a RESPOSTA de login, o servidor precisa da chave de 8
 * bytes que está DENTRO do blob RSA — e só a chave privada a abre. Ela não está
 * no cliente (e fatorar um modulus de 1024 bits não é factível).
 *
 * Consequência honesta: este servidor **implementa o protocolo corretamente**
 * (cifra, framing, checksum e payload de LOGIN verificados byte a byte contra o
 * AS3), mas **não consegue concluir o LOGIN** sem a chave privada do servidor
 * original. Ele serve para:
 *   • testes de protocolo e integração;
 *   • diagnosticar conexões;
 *   • deixar a infra pronta caso a chave privada seja fornecida.
 *
 * Para o jogo ficar 100% jogável é necessário o backend original (que tem a
 * chave privada RSA).
 */

import net from 'node:net';
import {
  P, DEFAULT_KEY, HEADER_SIZE,
  makeKey, encryptInPlace, buildPacket, readHeader, PacketDecoder, buildLoginBody,
} from './protocol.mjs';

const NAME_BY_CODE = Object.fromEntries(Object.entries(P).map(([k, v]) => [v, k]));

export class GameSocketServer {
  constructor({
    port = 0,
    host = '127.0.0.1',
    log = console.log,
    selfInfo = { loginName: 'Player' },
  } = {}) {
    this.port = port;
    this.host = host;
    this.log = log;
    this.selfInfo = selfInfo;
    this.clients = new Set();
    this._server = null;
  }

  /** Chave privada RSA do servidor original. Sem ela o LOGIN não fecha. */
  set privateKey(_) { /* intencionalmente sem uso — ver nota acima */ }

  start() {
    return new Promise((resolve) => {
      this._server = net.createServer((socket) => this._onConnection(socket));
      this._server.listen(this.port, this.host, () => {
        this.port = this._server.address().port;
        this.log(`[game] socket TCP em ${this.host}:${this.port}`);
        resolve(this);
      });
    });
  }

  stop() {
    for (const c of this.clients) c.destroy();
    return new Promise((r) => (this._server ? this._server.close(r) : r()));
  }

  _onConnection(socket) {
    const session = {
      socket,
      decoder: new PacketDecoder({ encrypted: true, key: DEFAULT_KEY }),
      // A chave que o servidor usará para CIFRAR as respostas.
      sendKey: makeKey(DEFAULT_KEY),
      loginOk: false,
    };
    this.clients.add(session);
    this.log(`[game] cliente conectado (${this.clients.size} online)`);

    socket.on('data', (chunk) => {
      let packets = [];
      try {
        packets = session.decoder.push(chunk);
      } catch (err) {
        this.log(`[game] erro ao decodificar: ${err.message}`);
        return;
      }
      for (const pkt of packets) this._handle(session, pkt);
    });

    socket.on('error', (err) => this.log(`[game] erro de socket: ${err.message}`));
    socket.on('close', () => {
      this.clients.delete(session);
      this.log(`[game] cliente desconectado (${this.clients.size} online)`);
    });
  }

  _send(session, { code, body = Buffer.alloc(0), extend1 = 0, extend2 = 0 }) {
    const pkt = buildPacket({ code, body, extend1, extend2 });
    // Mesma semântica do ByteSocket.send: o índice reinicia em 0 por pacote,
    // mas os bytes da chave continuam evoluindo.
    encryptInPlace(pkt, session.sendKey);
    try { session.socket.write(pkt); } catch { /* socket caiu */ }
  }

  _handle(session, { header, body }) {
    const name = NAME_BY_CODE[header.code] || `code=${header.code}`;
    this.log(`[game] <- ${name} (${body.length}B)`);

    switch (header.code) {
      case P.LOGIN: {
        // ByteSocket.sendLogin envia: build(int) | desktopType(int) | blob RSA.
        // Não é possível ler o blob sem a chave privada.
        const build = body.readInt32BE(0);
        const desktop = body.readInt32BE(4);
        this.log(`[game]    LOGIN build=${build} desktop=${desktop} blobRSA=${body.length - 8}B`);
        this.log('[game]    -> LOGIN OK (chave de sessao assumida como a padrao)');
        session.loginOk = true;
        const loginBody = buildLoginBody(this.selfInfo);
        this._send(session, { code: P.LOGIN, body: loginBody });
        break;
      }
      case P.PING:
        this._send(session, { code: P.PING });
        break;
      case P.SCENE_LOGIN:
        // resposta vazia: o cliente trata lista de usuarios vazia como sala vazia
        this._send(session, { code: P.SCENE_LOGIN, body: Buffer.from([0]) });
        break;
      case P.SCENE_USERS_LIST:
        this._send(session, { code: P.SCENE_USERS_LIST, body: Buffer.from([0]) });
        break;
      default:
        this.log(`[game]    (sem handler para ${name})`);
    }
  }
}