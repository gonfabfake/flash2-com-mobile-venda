/**
 * tests/unit/protocol.test.mjs
 *
 * Verifica o codec do protocolo contra uma implementação de REFERÊNCIA
 * transcrita literalmente do ActionScript decompilado. Se as duas divergirem,
 * o servidor local não conversa com o cliente.
 */

import test from 'node:test';
import assert from 'node:assert/strict';

import {
  MAGIC, HEADER_SIZE, DEFAULT_KEY, P, ByteBuf,
  makeKey, encryptInPlace, decryptInPlace,
  buildPacket, readHeader, PacketDecoder, buildLoginBody,
} from '../../server/protocol.mjs';

// ── Referência: ByteSocket.as:147-163 (encode) ─────────────────────────────
function as3Encrypt(data, key) {
  const d = Buffer.from(data);
  const k = Buffer.from(key);
  for (let i = 0; i < d.length; i++) {
    if (i > 0) {
      k[i % 8] = (k[i % 8] + d[i - 1]) ^ i;
      d[i] = ((d[i] ^ k[i % 8]) + d[i - 1]) & 0xff;
    } else {
      d[i] = (d[i] ^ k[0]) & 0xff;
    }
  }
  return d;
}

// ── Referência: PackageIn.as:39-62 (decode) ────────────────────────────────
function as3Decrypt(data, key) {
  const c = Buffer.from(data);
  const k = Buffer.from(key);
  const out = Buffer.alloc(c.length);
  for (let i = 0; i < c.length; i++) {
    if (i > 0) {
      k[i % 8] = (k[i % 8] + c[i - 1]) ^ i;
      out[i] = ((c[i] - c[i - 1]) ^ k[i % 8]) & 0xff;
    } else {
      out[i] = (c[i] ^ k[0]) & 0xff;
    }
  }
  return out;
}

test('a cifra reproduz exatamente a implementação AS3', () => {
  for (const len of [1, 7, 8, 9, 20, 21, 64, 257]) {
    const plain = Buffer.from(
      Array.from({ length: len }, (_, i) => (i * 37 + 11) & 0xff),
    );
    const mine = encryptInPlace(Buffer.from(plain), makeKey());
    const ref = as3Encrypt(plain, DEFAULT_KEY);
    assert.deepEqual(mine, ref, `encode divergiu com len=${len}`);
  }
});

test('decifra o que a referência cifrou (round-trip entre implementações)', () => {
  for (const len of [1, 20, 33, 128]) {
    const plain = Buffer.from(Array.from({ length: len }, (_, i) => (i * 91 + 7) & 0xff));
    const ct = as3Encrypt(plain, DEFAULT_KEY);
    const mine = decryptInPlace(Buffer.from(ct), makeKey());
    assert.deepEqual(mine, plain, `decode divergiu com len=${len}`);
  }
});

test('round-trip cifrar->decifrar preserva os bytes', () => {
  const plain = Buffer.from('package ddt { /* DDTank */ }'.repeat(9));
  const key = makeKey();
  const ct = encryptInPlace(Buffer.from(plain), Buffer.from(key));
  const back = decryptInPlace(ct, Buffer.from(key));
  assert.deepEqual(back, plain);
});

test('checksum segue 119 + soma(bytes[6..]) & 0x7F7F', () => {
  const pkt = buildPacket({ code: P.LOGIN, body: Buffer.from('abcd') });
  let sum = 119;
  for (let i = 6; i < pkt.length; i++) sum += pkt[i];
  const expected = (sum & 0x7f7f) & 0xffff;
  assert.equal(pkt.readUInt16BE(4), expected);
  assert.equal(pkt.readUInt16BE(2), pkt.length, 'len = total do pacote');
});

test('header tem 20 bytes e o magic correto (PackageOut.as:8 / PackageIn.as:8)', () => {
  const pkt = buildPacket({ code: P.SCENE_LOGIN, clientId: 7, extend1: 8, extend2: 9 });
  assert.equal(pkt.length, HEADER_SIZE);
  assert.equal(pkt.readUInt16BE(0), MAGIC);
  assert.equal(MAGIC, 29099);
  const h = readHeader(pkt);
  assert.equal(h.code, P.SCENE_LOGIN);
  assert.equal(h.clientId, 7);
  assert.equal(h.extend1, 8);
  assert.equal(h.extend2, 9);
});

test('writeUTF usa short de comprimento em BYTES (não caracteres)', () => {
  const b = new ByteBuf(Buffer.alloc(16));
  b.utf('ação');
  const { value, size } = ByteBuf.readUTF(b.toBuffer(), 0);
  assert.equal(value, 'ação');
  // 'ação' = a(1) + ç(2) + ã(2) + o(1) = 6 bytes em UTF-8
  assert.equal(b.toBuffer().readUInt16BE(0), 6, 'o comprimento e em BYTES');
  assert.equal(size, 8);
});

test('a chave é rolling ENTRE pacotes, mas o índice i reinicia em cada um', () => {
  // ByteSocket.send cifra `while (_loc2_ < param1.length)` — o índice `_loc2_`
  // reinicia em 0 a CADA pacote, mas os BYTES da chave (SEND_KEY) continuam
  // evoluindo de um pacote para o outro (nunca são resetados entre envios).
  // Cifrar o stream inteiro numa passada só (índice global) produz lixo — e é
  // exatamente por isso que este teste falhou na primeira versão.
  const k = makeKey();
  const a = buildPacket({ code: P.PING });
  const b = buildPacket({ code: P.SCENE_LOGIN, body: Buffer.from([1, 2, 3]) });

  const stream = Buffer.concat([
    encryptInPlace(Buffer.from(a), k),      // usa k e o AVANÇA
    encryptInPlace(Buffer.from(b), k),      // continua de onde parou
  ]);

  const dec = new PacketDecoder({ encrypted: true });
  const got = dec.push(stream);
  assert.equal(got.length, 2, 'decodificou apenas ' + got.length + ' pacote(s)');
  assert.equal(got[0].header.code, P.PING);
  assert.equal(got[1].header.code, P.SCENE_LOGIN);
  assert.deepEqual([...got[1].body], [1, 2, 3]);
});

test('PacketDecoder remontando pacotes fragmentados', () => {
  const k = makeKey();
  const a = buildPacket({ code: P.PING });
  const b = buildPacket({ code: P.SCENE_LOGIN, body: Buffer.from([1, 2, 3]) });
  const stream = Buffer.concat([
    encryptInPlace(Buffer.from(a), k),
    encryptInPlace(Buffer.from(b), k),
  ]);

  const dec = new PacketDecoder({ encrypted: true });
  let got = [];
  for (let i = 0; i < stream.length; i += 7) {      // chega em pedaços de 7 bytes
    got = got.concat(dec.push(stream.subarray(i, i + 7)));
  }
  assert.equal(got.length, 2);
  assert.equal(got[0].header.code, P.PING);
  assert.equal(got[1].header.code, P.SCENE_LOGIN);
  assert.deepEqual([...got[1].body], [1, 2, 3]);
});

test('PacketDecoder em modo não-criptografado', () => {
  const a = buildPacket({ code: P.LOGIN, body: Buffer.from('x') });
  const dec = new PacketDecoder({ encrypted: false });
  const [pkt] = dec.push(a);
  assert.equal(pkt.header.code, P.LOGIN);
  assert.equal(pkt.body.toString(), 'x');
});

test('corpo do LOGIN começa com byte 0 (senão o cliente trata como falha)', () => {
  // ServerManager.as:215 -> if (_loc6_.readByte() == 0) { ...sucesso... }
  const body = buildLoginBody({ loginName: 'Tester' });
  assert.equal(body.readUInt8(0), 0);
});

test('corpo do LOGIN tem tamanho estável e multiplo de plausivel', () => {
  const a = buildLoginBody({ loginName: 'A' });
  const b = buildLoginBody({ loginName: 'NomeBemMaisLongo' });
  assert.ok(a.length > 100, 'login curto demais');
  // diferenca = apenas o tamanho da string UTF
  assert.equal(b.length - a.length, 'NomeBemMaisLongo'.length - 1);
});

test('valores customizados do SelfInfo chegam no corpo na posicao correta', () => {
  // Percorre o corpo com o MESMO leitor que ServerManager.__onLoginComplete usa
  // (ServerManager.as:210-290). Se um campo mudar de tamanho, tudo depois
  // quebra silenciosamente — este teste existe para travar os offsets.
  const body = buildLoginBody({ loginName: 'Ze', gold: 777 });
  let o = 0;
  const u8 = () => { const v = body.readUInt8(o); o += 1; return v; };
  const i32 = () => { const v = body.readInt32BE(o); o += 4; return v; };
  const utf = () => { const r = ByteBuf.readUTF(body, o); o += r.size; return r.value; };
  // PackageIn.readDate / PackageOut.writeDate = readShort + 5×readByte = 7 bytes
  // (NÃO são 8 — um off-by-one aqui desalinha todos os campos seguintes).
  const date = () => { o += 7; };

  assert.equal(u8(), 0, 'byte de resultado (0 = sucesso)');
  assert.equal(i32(), 1, 'zoneId');
  assert.equal(i32(), 50, 'attack');
  assert.equal(i32(), 50, 'defence');
  assert.equal(i32(), 50, 'agility');
  assert.equal(i32(), 50, 'luck');
  assert.equal(i32(), 10, 'gp');
  assert.equal(i32(), 0, 'repute');
  assert.equal(i32(), 777, 'gold  <-- customizado');

  i32(); i32(); i32(); i32(); i32();        // money, medal, score, hide, fightPower
  i32(); i32();                             // apprenticeshipState, masterID
  utf();                                    // masterName
  i32();                                    // graduatesCount
  utf();                                    // honourOfMaster
  date();                                   // freezesDate
  u8();                                     // typeVIP
  i32(); i32();                             // VIPLevel, VIPExp
  date(); date();                           // VIPExpireDay, LastDate
  i32();                                    // VIPNextLevelDaysNeeded
  date();                                   // systemDate
  u8();                                     // canTakeVipReward
  i32(); i32();                             // OptionOnOff, AchievementPoint
  utf();                                    // honor
  i32();                                    // totalGameTime
  u8();                                     // Sex
  assert.equal(utf(), '61,62&0,0,0', 'Style & Colors');
  utf();                                    // Skin
  i32(); utf();                             // ConsortiaID, ConsortiaName
  i32(); i32(); utf(); i32();               // badgeID, DutyLevel, DutyName, Right
  utf(); i32(); i32();                      // ChairmanName, Honor, Riches
  u8();                                     // bagPwdState
  utf(); utf();                             // questionOne, questionTwo
  i32();                                    // leftTimes
  assert.equal(utf(), 'Ze', 'loginName  <-- customizado');
  i32();                                    // Nimbus
  utf(); utf();                             // PvePermission, fightLibMission
  i32();                                    // userGuildProgress
  i32(); i32(); i32();                      // receiebox, receieGrade, needGetBoxTime
  date();                                   // LastSpaDate
  assert.equal(o, body.length, 'o corpo acabou exatamente no fim dos campos lidos');
});