import os from 'node:os';
import path from 'node:path';
import QRCode from 'qrcode';
import { startTunnel } from 'untun';

export function getLocalIP() {
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

const port = process.argv[2] || 8080;
const localIP = getLocalIP();
const localUrl = `http://${localIP}:${port}`;

async function run() {
  console.log(`Starting Cloudflare zero-config tunnel on port ${port}...`);
  const tunnel = await startTunnel({ port: Number(port) });
  const cloudflareUrl = await tunnel.getURL();

  console.log(`\n======================================================`);
  console.log(`  📱 RAINBOW EYE HOSPITAL — PHONE PREVIEW READY`);
  console.log(`======================================================\n`);
  console.log(`  🔗 Instant Cloudflare URL (No Password Needed):`);
  console.log(`     ${cloudflareUrl}\n`);
  console.log(`  📶 Local LAN URL (if AP isolation disabled):`);
  console.log(`     ${localUrl}\n`);
  console.log(`  📷 Scan this QR code with your phone camera to open:\n`);

  const qrTerminal = await QRCode.toString(cloudflareUrl, { type: 'terminal', small: true });
  console.log(qrTerminal);

  const qrImagePath = path.resolve('tool/phone_qr.png');
  await QRCode.toFile(qrImagePath, cloudflareUrl, {
    width: 320,
    margin: 2,
    color: {
      dark: '#0891B2',
      light: '#FFFFFF',
    },
  });

  console.log(`\n  ✅ Ready! Point your phone camera at the QR code above.`);
}

run();
