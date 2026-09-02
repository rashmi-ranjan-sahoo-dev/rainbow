import fs from 'node:fs';
import path from 'node:path';
import { Resvg } from '@resvg/resvg-js';

const svgPath = path.resolve('web/favicon.svg');
const svg = fs.readFileSync(svgPath, 'utf8');

function renderPng(svgString, width, height) {
  const resvg = new Resvg(svgString, {
    fitTo: {
      mode: 'width',
      value: width,
    },
  });
  const pngData = resvg.render();
  return pngData.asPng();
}

const targets = [
  { path: 'web/favicon.png', size: 64 },
  { path: 'web/icons/Icon-192.png', size: 192 },
  { path: 'web/icons/Icon-512.png', size: 512 },
  { path: 'web/icons/Icon-maskable-192.png', size: 192 },
  { path: 'web/icons/Icon-maskable-512.png', size: 512 },
  { path: 'build/web/favicon.png', size: 64 },
  { path: 'build/web/icons/Icon-192.png', size: 192 },
  { path: 'build/web/icons/Icon-512.png', size: 512 },
  { path: 'build/web/icons/Icon-maskable-192.png', size: 192 },
  { path: 'build/web/icons/Icon-maskable-512.png', size: 512 },
  { path: 'android/app/src/main/res/mipmap-mdpi/ic_launcher.png', size: 48 },
  { path: 'android/app/src/main/res/mipmap-hdpi/ic_launcher.png', size: 72 },
  { path: 'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png', size: 96 },
  { path: 'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png', size: 144 },
  { path: 'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png', size: 192 },
];

for (const target of targets) {
  const fullPath = path.resolve(target.path);
  const dir = path.dirname(fullPath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  const pngBuffer = renderPng(svg, target.size, target.size);
  fs.writeFileSync(fullPath, pngBuffer);
  console.log(`Generated: ${target.path} (${target.size}x${target.size})`);
}

console.log('All icons generated successfully!');
