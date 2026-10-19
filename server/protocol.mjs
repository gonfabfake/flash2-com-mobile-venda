/**
 * protocol.mjs — Codec do protocolo DDTank (road7th.comm), reimplementado em Node.
 *
 * FIDELIDADE: cada regra abaixo foi extraída do ActionScript decompilado e está
 * referenciada com `arquivo:linha`. A cifra é simétrica e usa a chave padrão
 * que está *hardcoded no cliente*, então é reproduzível.
 *
 * ── Framing (PackageOut.as:14-24) ──────────────────────────────────────────
 *   offset 0  short  MAGIC = 29099
 *   offset 2  short  len    = tamanho TOTAL do pacote (inclui o header)
 *   offset 4  short  checksum
 *   offset 6  short  code
 *   offset 8  int    clientId
 *   offset 12 int    extend1
 *   offset 16 int    extend2
 *   = 20 bytes (PackageIn.HEADER_SIZE, PackageIn.as:8)
 *
 * ── Checksum (PackageOut.as:45-54) ─────────────────────────────────────────
 *   119 + soma(bytes[6..len)) & 0x7F7F
 *
 * ── Cifra (ByteSocket.as:147-163 / PackageIn.as:39-62) ────────────────────
 *   A chave tem 8 bytes e EVOLUI a cada byte (rolling key).
 *   Precedência em AS3: `+` > `^`, então o agrupamento é:
 *
 *     encode:  k[i%8] = (k[i%8] + ct[i-1]) ^ i
 *              ct[i]   = (pt[i] ^ k[i%8]) + ct[i-1]
 *              ct[0]   = pt[0] ^ k[0]
 *
 *     decode:  k[i%8] = (k[i%8] + ct[i-1]) ^ i
 *              pt[i]   = (ct[i] - ct[i-1]) ^ k[i%8]
 *              pt[0]   = ct[0] ^ k[0]
 *
 * ── Cifragem é do PACOTE INTEIRO (header incluído) ──────────────────────────
 *   ByteSocket.send cifra `param1.length` bytes do PackageOut já empacotado.
 */

export const MAGIC = 29099;
export const HEADER_SIZE = 20;

/** Chave padrão — ByteSocket.as:23 (pública, presente no cliente). */
export const DEFAULT_KEY = [174, 191, 86, 120, 171, 205, 239, 241];

// ── Tipos de pacote relevantes (ddt/data/socket/ePackageType.as) ────────────
export const P = {
  LOGIN: 1,
  KIT_USER: 2,
  SYS_MESSAGE: 3,
  PING: 4,
  RSAKEY: 7,
  SCENE_LOGIN: 16,
  SCENE_ADD_USER: 18,
  SCENE_CHAT: 19,
  SCENE_REMOVE_USER: 21,
  USER_RANK: 34,
  SCENE_USERS_LIST: 69,
  GAME_CMD: 91,
  GAME_ROOM: 94,
};

/** ByteArray do Flash: big-endian. */
export class ByteBuf {
  constructor(buf = Buffer.alloc(0)) {
    this.buf = Buffer.from(buf);
    this.pos = 0;
  }

  static alloc(n = 256) { return new ByteBuf(Buffer.alloc(n)); }

  get length() { return this.buf.length; }

  ensure(n) {
    if (this.buf.length < n) {
      const bigger = Buffer.alloc(Math.max(n, this.buf.length * 2 || 256));
      this.buf.copy(bigger);
      this.buf = bigger;
    }
    return this;
  }

  u8(v) { this.ensure(this.pos + 1); this.buf.writeUInt8(v & 0xff, this.pos); this.pos += 1; return this; }
  u16(v) { this.ensure(this.pos + 2); this.buf.writeUInt16BE(v & 0xffff, this.pos); this.pos += 2; return this; }
  i32(v) { this.ensure(this.pos + 4); this.buf.writeInt32BE(v | 0, this.pos); this.pos += 4; return this; }
  u32(v) { this.ensure(this.pos + 4); this.buf.writeUInt32BE(v >>> 0, this.pos); this.pos += 4; return this; }
  b(v) { return this.u8(v ? 1 : 0); }

  /** writeUTF: short(comprimento em bytes) + bytes UTF-8 (sem \0). */
  utf(s) {
    const data = Buffer.from(String(s ?? ''), 'utf8');
    this.u16(data.length);
    this.ensure(this.pos + data.length);
    data.copy(this.buf, this.pos);
    this.pos += data.length;
    return this;
  }

  /** readUTF usado pelo cliente (PackageIn.readUTF herdado do ByteArray). */
  static readUTF(b, offset) {
    const len = b.readUInt16BE(offset);
    return { value: b.toString('utf8', offset + 2, offset + 2 + len), size: 2 + len };
  }

  bytes(n) {
    const out = this.buf.subarray(this.pos, this.pos + n);
    this.pos += n;
    return out;
  }

  /** writeDate (PackageOut.as:56-63) — readShort + 5×readByte = 7 bytes.
   *  NÃO são 8: um off-by-one aqui desalinha todos os campos seguintes do LOGIN. */
  date(d) {
    this.u16(d.getUTCFullYear());
    this.u8(d.getUTCMonth() + 1);
    this.u8(d.getUTCDate());
    this.u8(d.getUTCHours());
    this.u8(d.getUTCMinutes());
    this.u8(d.getUTCSeconds());
    return this;
  }

  toBuffer() { return this.buf.subarray(0, this.pos); }
}

// ── Cifra ──────────────────────────────────────────────────────────────────

export function makeKey(bytes = DEFAULT_KEY) { return Buffer.from(bytes); }

/** Cifra um buffer NO LUGAR (como o ByteArray do Flash faz). */
export function encryptInPlace(data, key) {
  for (let i = 0; i < data.length; i++) {
    if (i > 0) {
      key[i % 8] = (key[i % 8] + data[i - 1]) ^ i;
      data[i] = ((data[i] ^ key[i % 8]) + data[i - 1]) & 0xff;
    } else {
      data[i] = data[i] ^ key[0];
    }
  }
  return data;
}

/** Decifra um buffer NO LUGAR (equivalente a decrptBytes / PackageIn.loadE). */
export function decryptInPlace(data, key) {
  const out = Buffer.alloc(data.length);
  for (let i = 0; i < data.length; i++) {
    if (i > 0) {
      key[i % 8] = (key[i % 8] + data[i - 1]) ^ i;
      out[i] = ((data[i] - data[i - 1]) ^ key[i % 8]) & 0xff;
    } else {
      out[i] = (data[i] ^ key[0]) & 0xff;
    }
  }
  return out;
}

// ── Pacotes ────────────────────────────────────────────────────────────────

/** Monta um pacote, calcula o checksum e devolve o Buffer (ainda em claro). */
export function buildPacket({ code, clientId = 0, extend1 = 0, extend2 = 0, body = Buffer.alloc(0) }) {
  const total = HEADER_SIZE + body.length;
  const buf = new ByteBuf(Buffer.alloc(total));
  buf.u16(MAGIC);
  buf.u16(total);
  buf.u16(0);            // checksum placeholder
  buf.u16(code);
  buf.i32(clientId);
  buf.i32(extend1);
  buf.i32(extend2);
  body.copy(buf.buf, HEADER_SIZE);

  // checksum sobre os bytes a partir do offset 6
  let sum = 119;
  for (let i = 6; i < total; i++) sum += buf.buf[i];
  buf.buf.writeUInt16BE(sum & 0x7f7f, 4);
  return buf.buf;
}

/** Lê os campos de cabeçalho de um pacote em claro. */
export function readHeader(buf) {
  return {
    magic: buf.readUInt16BE(0),
    len: buf.readUInt16BE(2),
    checksum: buf.readUInt16BE(4),
    code: buf.readUInt16BE(6),
    clientId: buf.readInt32BE(8),
    extend1: buf.readInt32BE(12),
    extend2: buf.readInt32BE(16),
  };
}

/**
 * Stream decoder: acumula bytes, procura o MAGIC em passos de 4 (como o
 * ByteSocket.readPackage faz) e emite pacotes já decifrados.
 */
export class PacketDecoder {
  constructor({ encrypted = true, key = DEFAULT_KEY } = {}) {
    this.encrypted = encrypted;
    this.receiveKey = makeKey(key);
    this.buf = Buffer.alloc(0);
  }

  setKey(bytes) { this.receiveKey = makeKey(bytes); }

  push(chunk) {
    this.buf = Buffer.concat([this.buf, chunk]);
    const out = [];
    for (;;) {
      const found = this._findPacket();
      if (!found) break;
      const { start, len } = found;
      let packet = this.buf.subarray(start, start + len);
      if (this.encrypted) packet = decryptInPlace(Buffer.from(packet), this.receiveKey);
      const header = readHeader(packet);
      out.push({ header, body: packet.subarray(HEADER_SIZE), raw: packet });
      this.buf = Buffer.concat([this.buf.subarray(0, start), this.buf.subarray(start + len)]);
    }
    return out;
  }

  _findPacket() {
    for (let i = 0; i + 4 <= this.buf.length; i += 1) {
      let head = this.buf.subarray(i, i + 4);
      if (this.encrypted) head = decryptInPlace(Buffer.from(head), Buffer.from(this.receiveKey));
      if (head.readUInt16BE(0) === MAGIC) {
        const len = head.readUInt16BE(2);
        if (len >= HEADER_SIZE && i + len <= this.buf.length) return { start: i, len };
      }
    }
    return null;
  }
}

/**
 * Resposta de LOGIN — o formato exato que ServerManager.__onLoginComplete
 * consome (ServerManager.as:210-290). TODOS os campos são lidos em ordem; um
 * deslocamento errado quebra a sessão, então a ordem abaixo é normativa.
 */
export function buildLoginBody(self = {}) {
  const b = new ByteBuf(Buffer.alloc(512));
  const d = new Date(2026, 0, 1, 12, 0, 0);

  b.u8(0);                                  // byte 0 != 0 => falha de login
  b.i32(self.zoneId ?? 1);
  b.i32(self.attack ?? 50);
  b.i32(self.defence ?? 50);
  b.i32(self.agility ?? 50);
  b.i32(self.luck ?? 50);
  b.i32(self.gp ?? 10);
  b.i32(self.repute ?? 0);
  b.i32(self.gold ?? 100000);
  b.i32(self.money ?? 50000);
  b.i32(self.medal ?? 0);
  b.i32(self.score ?? 0);
  b.i32(self.hide ?? 0);
  b.i32(self.fightPower ?? 1000);
  b.i32(self.apprenticeshipState ?? 0);
  b.i32(self.masterID ?? 0);
  b.utf('');                               // masterName
  b.i32(self.graduatesCount ?? 0);
  b.utf('');                               // honourOfMaster
  b.date(d);                               // freezesDate
  b.u8(self.typeVIP ?? 0);
  b.i32(self.vipLevel ?? 0);
  b.i32(self.vipExp ?? 0);
  b.date(d);                               // vipExpireDay
  b.date(d);                               // lastDate
  b.i32(self.vipNextLevelDaysNeeded ?? 0);
  b.date(d);                               // systemDate
  b.b(self.canTakeVipReward ?? false);
  b.i32(self.optionOnOff ?? 0);
  b.i32(self.achievementPoint ?? 0);
  b.utf('');                               // honor
  b.i32(self.totalGameTime ?? 0);
  b.b(self.sex ?? true);
  b.utf('61,62&0,0,0');                    // Style & Colors
  b.utf('skin.png');
  b.i32(self.consortiaId ?? 0);
  b.utf('');                               // consortiaName
  b.i32(self.badgeId ?? 0);
  b.i32(self.dutyLevel ?? 0);
  b.utf('');                               // dutyName
  b.i32(self.right ?? 0);
  b.utf('');                               // chairmanName
  b.i32(self.consortiaHonor ?? 0);
  b.i32(self.consortiaRiches ?? 0);
  b.b(false);                              // bagPwdState
  b.utf('');                               // questionOne
  b.utf('');                               // questionTwo
  b.i32(self.leftTimes ?? 5);
  b.utf(self.loginName ?? 'Player');
  b.i32(self.nimbus ?? 0);
  b.utf('');                               // pvePermission
  b.utf('');                               // fightLibMission
  b.i32(self.userGuildProgress ?? 0);
  b.i32(0);                                // receiebox
  b.i32(0);                                // receieGrade
  b.i32(0);                                // needGetBoxTime
  b.date(d);                               // lastSpaDate
  return b.toBuffer();
}