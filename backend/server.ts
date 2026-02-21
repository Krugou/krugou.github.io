/* eslint-disable no-console */
import createApp from './app.js';
import fs from 'fs';
import https from 'https';
import path from 'path';

const useHttps = process.argv.includes('--https');

const CERT_DIR = path.join(process.cwd(), 'certs');
const CERT_KEY = path.join(CERT_DIR, 'localhost-key.pem');
const CERT_FILE = path.join(CERT_DIR, 'localhost.pem');

const startServer = () => {
  const app = createApp();

  const port = Number(process.env.PORT ?? 3000);
  const httpsPort = Number(process.env.HTTPS_PORT ?? 3443);

  if (!useHttps) {
    app.listen(port, () => {
      console.log('\n  API server ready');
      console.log(`     Local:   http://localhost:${port}`);
      console.log('     Health:  /health\n');
    });
  }

  if (useHttps || (fs.existsSync(CERT_KEY) && fs.existsSync(CERT_FILE))) {
    if (!fs.existsSync(CERT_KEY) || !fs.existsSync(CERT_FILE)) {
      console.error(
        '\n  HTTPS requested but certificates not found.\n' + '     Run: npm run certs:generate\n',
      );
    } else {
      const sslOptions = { key: fs.readFileSync(CERT_KEY), cert: fs.readFileSync(CERT_FILE) };
      https.createServer(sslOptions, app).listen(httpsPort, () => {
        console.log('\n  HTTPS API server ready');
        console.log(`     Local:   https://localhost:${httpsPort}`);
        console.log('     Health:  /health\n');
      });
    }
  }
};

startServer();
