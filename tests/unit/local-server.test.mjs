/**
 * tests/unit/local-server.test.mjs
 *
 * Verifica o servidor local de ponta a ponta, incluindo a parte criptográfica
 * que o cliente não tem como trivializar: o AES-256-ECB com chave ASCII que
 * ddt/utils/CryptoUtil.as:12 usa para decifrar o ServerList.ashx.
 */

import test from 'node:test';
import assert from 'node:assert/strict';
import net from 'node:net';
import crypto from 'node:crypto';

import {
  startLocalServer, encryptServerList, buildServerListXml,
} from '../../server/local-server.mjs';
import { DEFAULT_KEY, buildPacket, encryptInPlace, makeKey, PacketDecoder, P, HEADER_SIZE } from '../../server/protocol.mjs';

let ctx;

test.before(async () => { ctx = await startLocalServer({ port: 0, log: () => {} }); });
test.after(async () => { await ctx?.close(); });

test('o servidor sobe e serve o player', async () => {
  const r = await fetch(`${ctx.url}/player.html`);
  assert.equal(r.status, 200);
  const html = await r.text();
  assert.ok(html.includes('ruffle'), 'o player nao referencia o Ruffle');
});

test('config.local.xml e servido', async () => {
  const r = await fetch(`${ctx.url}/config.local.xml`);
  assert.equal(r.status, 200);
  assert.ok((await r.text()).includes('<root>'));
});

test('as 3 rotas do jogo respondem 200', async () => {
  for (const p of ['/DDT_Loading_Air.swf', '/2.png', '/config.xml']) {
    const r = await fetch(`${ctx.url}${p}`);
    assert.equal(r.status, 200, `${p} respondeu ${r.status}`);
  }
});

test('ServerList.ashx e AES-256-ECB cifrado com a chave do CryptoUtil', async () => {
  const r = await fetch(`${ctx.url}/quest/ServerList.ashx`);
  assert.equal(r.status, 200);
  const b64 = (await r.text()).trim();
  assert.ok(/^[A-Za-z0-9+/=]+$/.test(b64));

  // O MESMO decrypt que o AS3 faz: CryptoUtil.decrypt -> Base64 -> aes-ecb
  const key = Buffer.from('7A8B9C2D15F01E381F91A0B6C6D68E4F', 'ascii');
  const d = crypto.createDecipheriv('aes-256-ecb', key, null);
  d.setAutoPadding(true);
  const xml = Buffer.concat([d.update(Buffer.from(b64, 'base64')), d.final()]).toString('utf8');

  assert.ok(xml.startsWith('<result value="true"'), 'o XML nao tem value="true"');
  assert.ok(xml.includes('IP="127.0.0.1"'), 'o servidor nao aponta para o socket local');
});

test('o XML do ServerList aponta para a porta real do socket', async () => {
  const key = Buffer.from('7A8B9C2D15F01E381F91A0B6C6D68E4F', 'ascii');
  const r = await fetch(`${ctx.url}/quest/ServerList.ashx`);
  const d = crypto.createDecipheriv('aes-256-ecb', key, null);
  d.setAutoPadding(true);
  const xml = Buffer.concat([d.update(Buffer.from((await r.text()).trim(), 'base64')), d.final()]).toString();

  const m = xml.match(/Port="(\d+)"/);
  assert.ok(m, 'sem atributo Port');
  assert.equal(Number(m[1]), ctx.gameSocket.port, 'Port != porta do socket');
});

test('o socket TCP aceita uma conexao e responde PING', async () => {
  const socket = net.connect(ctx.gameSocket.port, '127.0.0.1');
  const received = [];
  const dec = new PacketDecoder({ encrypted: true, key: DEFAULT_KEY });
  const sendKey = makeKey();

  socket.on('data', (chunk) => {
    for (const p of dec.push(chunk)) received.push(p.header.code);
  });

  await new Promise((res, rej) => {
    socket.once('connect', res);
    socket.once('error', rej);
  });

  const ping = buildPacket({ code: P.PING });
  socket.write(encryptInPlace(ping, sendKey));

  await new Promise((r) => setTimeout(r, 250));
  assert.ok(received.includes(P.PING), `esperava PING de volta, veio ${received}`);

  socket.destroy();
});

test('o socket responde LOGIN com um payload bem formado', async () => {
  const socket = net.connect(ctx.gameSocket.port, '127.0.0.1');
  const dec = new PacketDecoder({ encrypted: true, key: DEFAULT_KEY });
  const sendKey = makeKey();
  let got = null;

  socket.on('data', (chunk) => {
    for (const p of dec.push(chunk)) if (p.header.code === P.LOGIN) got = p;
  });

  await new Promise((res, rej) => { socket.once('connect', res); socket.once('error', rej); });

  // corpo minimo no formato de GameSocketOut.sendLogin: build | desktop | blob
  const body = Buffer.concat([Buffer.alloc(8), Buffer.from([1, 2, 3, 4])]);
  socket.write(encryptInPlace(buildPacket({ code: P.LOGIN, body }), sendKey));

  await new Promise((r) => setTimeout(r, 250));
  assert.ok(got, 'nao veio resposta de LOGIN');
  assert.equal(got.body.readUInt8(0), 0, 'byte 0 != 0 => o cliente trata como falha');
  assert.ok(got.body.length > 100, 'payload de login curto demais');
  socket.destroy();
});

test('buildServerListXml monta o formato que o ServerListAnalyzer le', () => {
  const xml = buildServerListXml({ ip: '10.0.0.1', port: 9000 });
  assert.match(xml, /value="true"/);
  assert.match(xml, /<Item /);
  assert.match(xml, /IP="10\.0\.0\.1"/);
  assert.match(xml, /Port="9000"/);
});

test('encryptServerList produz base64 cujo tamanho e multiplo do bloco AES', () => {
  const b64 = encryptServerList('<result value="true"/>');
  assert.equal(Buffer.from(b64, 'base64').length % 16, 0);
});