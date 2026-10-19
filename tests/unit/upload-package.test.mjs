/**
 * tests/unit/upload-package.test.mjs
 *
 * O APK (DDTankraiz.apk) baixa `DDT_Loading_Air.swf` de
 * `https://ddtankraiz.ddns.net/flash/`. Hoje esse caminho devolve 404 e o
 * app trava em 1/13. Este teste trava o contrato do pacote de upload:
 * todo arquivo que o APK e o jogo pedem precisa existir no pacote.
 */

import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const PKG = path.join(ROOT, '_upload_ddtankraiz');

const existe = (rel) => fs.existsSync(path.join(PKG, rel));

test('pacote de upload existe', () => {
  assert.ok(fs.existsSync(PKG), '_upload_ddtankraiz/ nao encontrado');
});

test('BLOQUEADOR 1: DDT_Loading_Air.swf em /flash/ (o que o APK baixa)', () => {
  // Bootup.as:58 -> normalizeFlashBase(URLUtil.FLASH_URL) + "DDT_Loading_Air.swf?..."
  // URLUtil.as:13 -> FLASH_URL = "https://ddtankraiz.ddns.net/flash/"
  assert.ok(existe(path.join('flash', 'DDT_Loading_Air.swf')), 'DDT_Loading_Air.swf ausente em /flash/');
});

test('BLOQUEADOR 2: nucleo 2.png em /flash/ (baixo pelo config FLASHSITE)', () => {
  // NormalLuncher.as:130 -> CorePath = FLASHSITE + "2.png"
  assert.ok(existe(path.join('flash', '2.png')), '2.png ausente em /flash/');
  assert.ok(existe(path.join('flash', '2.swf')), '2.swf ausente em /flash/');
});

test('config.xml aponta para ddtankraiz.ddns.net (nao sitemoderno)', () => {
  const cfg = fs.readFileSync(path.join(PKG, 'flash', 'config.xml'), 'utf8');
  assert.ok(cfg.includes('https://ddtankraiz.ddns.net/flash/'), 'FLASHSITE errado');
  assert.ok(cfg.includes('https://ddtankraiz.ddns.net/cdn/'), 'SITE errado');
  assert.ok(cfg.includes('https://ddtankraiz.ddns.net/quest/'), 'REQUEST_PATH errado');
  assert.ok(!cfg.includes('sitemoderno'), 'ainda referencia sitemoderno.ddns.net');
});

test('config.xml tem as correcoes de bug aplicadas', () => {
  const cfg = fs.readFileSync(path.join(PKG, 'flash', 'config.xml'), 'utf8');
  assert.ok(cfg.includes('<STYLE_PATH value="style/" />'), 'falta STYLE_PATH (bug B10)');
  assert.ok(/from="794" to="795"/.test(cfg), 'versao final deve ser 795 (bug B3)');
});

test('crossdomain.xml presente em /flash/ e /cdn/', () => {
  assert.ok(existe(path.join('flash', 'crossdomain.xml')));
  assert.ok(existe(path.join('cdn', 'crossdomain.xml')));
  const cd = fs.readFileSync(path.join(PKG, 'cdn', 'crossdomain.xml'), 'utf8');
  assert.ok(cd.includes('ddtankraiz.ddns.net'), 'crossdomain nao aponta para o dominio certo');
  assert.ok(!/domain="[^"]*\/[^"]*"/.test(cd), 'crossdomain ainda tem domain com caminho (bug B5)');
});

test('UI do jogo em /flash/ui/portugal (PathManager.getUIPath)', () => {
  assert.ok(existe(path.join('flash', 'ui', 'portugal')), 'pasta ui/portugal ausente');
  assert.ok(existe(path.join('flash', 'ui', 'portugal', 'language.txt')));
  assert.ok(existe(path.join('flash', 'ui', 'portugal', 'levelreward.xml')));
});

test('quest/ tem os 88 arquivos mock', () => {
  const n = fs.readdirSync(path.join(PKG, 'quest')).filter((f) => !f.startsWith('.')).length;
  assert.ok(n >= 85, `quest/ tem apenas ${n} arquivos (esperado >= 85)`);
});

test('ServerList.ashx e AES-valido (o analyzer descriptografa antes de usar)', () => {
  const b64 = fs.readFileSync(path.join(PKG, 'quest', 'ServerList.ashx'), 'utf8').trim();
  assert.ok(b64.length > 0, 'ServerList.ashx vazio');
  assert.ok(/^[A-Za-z0-9+/=]+$/.test(b64), 'ServerList.ashx nao parece base64');
  const len = Buffer.from(b64, 'base64').length;
  assert.equal(len % 16, 0, `bloco AES deve ser multiplo de 16, obtido ${len}`);
});

test('XMLs de quest sao zlib-comprimidos (CompressTextLoader chama uncompress())', () => {
  const dir = path.join(PKG, 'quest');
  const xmls = fs.readdirSync(dir).filter((f) => f.endsWith('.xml'));
  assert.ok(xmls.length > 50, 'poucos XMLs');
  for (const f of xmls) {
    const buf = fs.readFileSync(path.join(dir, f));
    assert.equal(buf[0], 0x78, `${f} nao comeca com header zlib 0x78`);
    assert.equal(buf[1], 0x9c, `${f} nao tem byte zlib 0x9C`);
  }
});