/**
 * tests/server.mjs — Servidor estático mínimo para desenvolvimento e testes.
 *
 * Existe porque o jogo NÃO funciona em file://:
 *   · o Ruffle carrega .wasm (fetch exige HTTP por causa de MIME/CORS);
 *   · módulos ES exigem HTTP;
 *   · o próprio SWF busca config.xml, crossdomain.xml e *.ashx do servidor.
 *
 * Uso:  node tests/server.mjs [porta]
 */

import http from 'node:http';
import fs from 'node:fs';
import fsp from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
export const ROOT = path.resolve(__dirname, '..');

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.mjs': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.wasm': 'application/wasm',                       // OBRIGATÓRIO para o Ruffle
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
};

export function createServer({ root = ROOT } = {}) {
  return http.createServer(async (req, res) => {
    try {
      const url = new URL(req.url, 'http://localhost');
      let pathname = decodeURIComponent(url.pathname);
      if (pathname.endsWith('/')) pathname += 'player.html'; // default document

      const filePath = path.join(root, pathname);
      // Impede escapar da raiz (path traversal).
      if (!filePath.startsWith(root)) {
        res.writeHead(403).end('403');
        return;
      }

      let stat;
      try {
        stat = await fsp.stat(filePath);
      } catch {
        res.writeHead(404, { 'content-type': 'text/plain; charset=utf-8' })
          .end(`404 ${pathname}`);
        return;
      }
      if (stat.isDirectory()) {
        res.writeHead(301, { location: `${pathname.replace(/\/?$/, '/')}player.html` }).end();
        return;
      }

      const type = MIME[path.extname(filePath).toLowerCase()] || 'application/octet-stream';
      res.writeHead(200, {
        'content-type': type,
        'content-length': stat.size,
        'cache-control': 'no-store',
        // Necessário para SharedObject/LocalStorage do Flash/Ruffle em alguns browsers
        'access-control-allow-origin': '*',
      });
      fs.createReadStream(filePath).pipe(res);
    } catch (err) {
      res.writeHead(500).end(String(err && err.message));
    }
  });
}

/** Sobe o servidor e devolve { server, url, close }. */
export function startServer({ port = 0, root = ROOT } = {}) {
  return new Promise((resolve) => {
    const server = createServer({ root });
    server.listen(port, '127.0.0.1', () => {
      const { port: actual } = server.address();
      resolve({
        server,
        port: actual,
        url: `http://127.0.0.1:${actual}`,
        close: () => new Promise((r) => server.close(r)),
      });
    });
  });
}

// Execução direta: `node tests/server.mjs 8080`
if (process.argv[1] && path.resolve(process.argv[1]) === path.resolve(__dirname, 'server.mjs')) {
  const port = Number(process.argv[2] || 8080);
  startServer({ port }).then(({ url }) => {
    console.log(`DDTank Mobile rodando em ${url}/player.html`);
    console.log(`  painel mobile : ${url}/player.html?ui=force&debug=1`);
    console.log(`  entrada mob.  : ${url}/mobile/player.html`);
  });
}