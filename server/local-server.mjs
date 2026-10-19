/**
 * local-server.mjs — Servidor local completo: jogo + endpoints + socket TCP.
 *
 * Substitui `tests/server.mjs` no `npm start`. Serve:
 *   • os arquivos do jogo (HTML/JS/SWF/XML/PNG)
 *   • /quest/*.xml e /quest/*.ashx (mocks já existentes)
 *   • /quest/ServerList.ashx GERADO DINAMICAMENTE, cifrado com AES-256-ECB e
 *     apontando para o socket TCP desta própria instância
 *   • um socket TCP de jogo em /api/socket (veja socket-server.mjs)
 */

import http from 'node:http';
import fs from 'node:fs';
import fsp from 'node:fs/promises';
import crypto from 'node:crypto';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { GameSocketServer } from './socket-server.mjs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const __filename = fileURLToPath(import.meta.url);
export const ROOT = path.resolve(__dirname, '..');

/** Chave do AES usada pelo ddt/utils/CryptoUtil.as:12 (ASCII, 32 bytes). */
const SERVERLIST_KEY = Buffer.from('7A8B9C2D15F01E381F91A0B6C6D68E4F', 'ascii');

/** Cifra exatamente como CryptoUtil.decrypt espera (AES-256-ECB + PKCS5). */
export function encryptServerList(xml) {
  const c = crypto.createCipheriv('aes-256-ecb', SERVERLIST_KEY, null);
  c.setAutoPadding(true);
  return Buffer.concat([c.update(Buffer.from(xml, 'utf8')), c.final()]).toString('base64');
}

export function buildServerListXml({ ip, port, area = 'Local' }) {
  return (
    `<result value="true" agentId="1" AreaName="${area}" message="">` +
    `<Item ID="1" Name="Local" IP="${ip}" Port="${port}" Remark="local" ` +
    `State="0" MustLevel="1" LowestLevel="1" Online="1"/>` +
    `</result>`
  );
}

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.mjs': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.wasm': 'application/wasm',
  '.swf': 'application/x-shockwave-flash',
  '.xml': 'application/xml; charset=utf-8',
  '.txt': 'text/plain; charset=utf-8',
  '.ui': 'application/xml; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.md': 'text/markdown; charset=utf-8',
  '.map': 'application/json; charset=utf-8',
  '.ashx': 'text/plain; charset=utf-8',
  '.mp3': 'audio/mpeg',
  '.flv': 'video/x-flv',
};

/**
 * @param {object} opts
 * @param {number} [opts.port]
 * @param {boolean}[opts.withSocket]  sobe também o servidor de jogo TCP
 */
export async function startLocalServer({ port = 0, root = ROOT, withSocket = true, log = console.log } = {}) {
  let gameSocket = null;

  const server = http.createServer(async (req, res) => {
    try {
      const url = new URL(req.url, 'http://localhost');
      let pathname = decodeURIComponent(url.pathname);
      if (pathname === '/') pathname = '/player.html';

      // ServerList.ashx é gerado: aponta para o socket TCP local.
      if (/^\/(quest\/)?serverlist\.ashx$/i.test(pathname)) {
        const ip = '127.0.0.1';
        const p = gameSocket ? gameSocket.port : 0;
        const body = encryptServerList(buildServerListXml({ ip, port: p }));
        res.writeHead(200, {
          'content-type': 'text/plain; charset=utf-8',
          'cache-control': 'no-store',
        }).end(body);
        return;
      }

      const filePath = path.join(root, pathname);
      if (!filePath.startsWith(root)) { res.writeHead(403).end('403'); return; }

      let stat;
      try { stat = await fsp.stat(filePath); }
      catch { res.writeHead(404, { 'content-type': 'text/plain; charset=utf-8' }).end(`404 ${pathname}`); return; }
      if (stat.isDirectory()) { res.writeHead(301, { location: `${pathname.replace(/\/?$/, '/')}player.html` }).end(); return; }

      const type = MIME[path.extname(filePath).toLowerCase()] || 'application/octet-stream';
      res.writeHead(200, {
        'content-type': type,
        'content-length': stat.size,
        'cache-control': 'no-store',
        'access-control-allow-origin': '*',
      });
      // createReadStream(path) gerencia o próprio descritor e o fecha ao
      // terminar. Usar fsp.open() sem fechar vazava um fd por requisição
      // (e mantinha o processo do Node vivo para sempre).
      const stream = fs.createReadStream(filePath);
      stream.on('error', () => { try { res.destroy(); } catch { /* noop */ } });
      res.on('close', () => stream.destroy());
      stream.pipe(res);
    } catch (err) {
      res.writeHead(500).end(String(err && err.message));
    }
  });

  await new Promise((r) => server.listen(port, '127.0.0.1', r));
  const actual = server.address().port;
  const url = `http://127.0.0.1:${actual}`;

  if (withSocket) {
    gameSocket = await new GameSocketServer({ log }).start();
  }

  return {
    server, url, port: actual, gameSocket,
    close: async () => {
      await gameSocket?.stop();
      await new Promise((r) => server.close(r));
    },
  };
}

if (process.argv[1] && path.resolve(process.argv[1]) === path.resolve(__filename)) {
  const port = Number(process.argv[2] || 8080);
  startLocalServer({ port }).then(({ url, gameSocket }) => {
    console.log('');
    console.log('  DDTank Mobile — servidor local');
    console.log('  ────────────────────────────────────────────────');
    console.log(`  jogo          ${url}/player.html`);
    console.log(`  painel mobile ${url}/player.html?config=config.local.xml&ui=force&debug=1`);
    console.log(`  diagnóstico   ${url}/mobile/player.html`);
    console.log(`  socket de jogo 127.0.0.1:${gameSocket?.port}`);
    console.log('');
    console.log('  Ctrl+C para encerrar.');
  });
}