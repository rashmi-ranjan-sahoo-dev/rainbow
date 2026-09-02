import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import QRCode from 'qrcode';
import { startTunnel } from 'untun';

const PORT = 8080;
const root = path.resolve('build', 'web');

const mime = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.mjs': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.wasm': 'application/wasm',
};

const server = http.createServer((req, res) => {
  let reqPath = req.url.split('?')[0];
  if (reqPath === '/' || !reqPath) reqPath = '/index.html';
  let filePath = path.join(root, reqPath);

  fs.stat(filePath, (err, stats) => {
    if (err || !stats.isFile()) {
      filePath = path.join(root, 'index.html');
    }

    const ext = path.extname(filePath).toLowerCase();
    const contentType = mime[ext] || 'application/octet-stream';

    fs.readFile(filePath, (readErr, content) => {
      if (readErr) {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('File not found');
        return;
      }
      res.writeHead(200, {
        'Content-Type': contentType,
        'Access-Control-Allow-Origin': '*',
        'Cache-Control': 'no-cache',
      });
      res.end(content);
    });
  });
});

function getLocalIP() {
  const interfaces = os.networkInterfaces();
  for (const name of Object.keys(interfaces)) {
    for (const iface of interfaces[name] || []) {
      if (iface.family === 'IPv4' && !iface.internal) {
        return iface.address;
      }
    }
  }
  return '127.0.0.1';
}

server.listen(PORT, '0.0.0.0', async () => {
  const localIP = getLocalIP();
  const lanUrl = `http://${localIP}:${PORT}`;

  console.log(`Server listening on http://0.0.0.0:${PORT}`);

  try {
    const tunnel = await startTunnel({ port: PORT });
    const cloudflareUrl = await tunnel.getURL();

    console.log(`\n======================================================`);
    console.log(`  📱 RAINBOW EYE HOSPITAL — LIVE PHONE PREVIEW`);
    console.log(`======================================================\n`);
    console.log(`  🔗 Cloudflare URL (Zero Password, Works on Any Network):`);
    console.log(`     ${cloudflareUrl}\n`);
    console.log(`  📶 Same Wi-Fi Direct LAN:`);
    console.log(`     ${lanUrl}\n`);
    console.log(`  📷 Scan this QR code with your phone:\n`);

    const qr = await QRCode.toString(cloudflareUrl, { type: 'terminal', small: true });
    console.log(qr);
    console.log(`\n======================================================\n`);
  } catch (tunnelErr) {
    console.error('Tunnel error:', tunnelErr.message);
    console.log(`Use LAN URL: ${lanUrl}`);
  }
});
