const localtunnel = require('localtunnel');
const fs = require('fs');
const path = require('path');

(async () => {
  try {
    const tunnel = await localtunnel({ port: 5000 });
    const url = tunnel.url;
    console.log('TUNNEL_OPENED_URL=' + url);
    fs.writeFileSync(path.join(__dirname, 'tunnel_url.txt'), url, 'utf8');

    tunnel.on('close', () => {
      console.log('Tunnel closed');
    });

    tunnel.on('error', (err) => {
      console.error('Tunnel error:', err);
    });
  } catch (err) {
    console.error('Failed to create tunnel:', err);
  }
})();
