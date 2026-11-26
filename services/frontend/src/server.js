const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');

function createFrontendServer({ backendUrl = process.env.BACKEND_URL || 'http://orders-backend:8080' } = {}) {
  const indexPath = path.join(__dirname, '..', 'public', 'index.html');
  const indexHtml = fs.readFileSync(indexPath, 'utf8');

  return http.createServer((req, res) => {
    const url = new URL(req.url, 'http://localhost');

    if (req.method === 'GET' && url.pathname === '/healthz') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'ok', service: 'web-frontend', backendUrl }));
      return;
    }

    if (req.method === 'GET' && url.pathname === '/') {
      res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
      res.end(indexHtml.replace('__BACKEND_URL__', backendUrl));
      return;
    }

    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Not Found' }));
  });
}

if (require.main === module) {
  const port = Number(process.env.PORT || 3000);
  const server = createFrontendServer();
  server.listen(port, '0.0.0.0', () => {
    console.log(JSON.stringify({ level: 'info', msg: 'Frontend listening', port }));
  });
  process.on('SIGTERM', () => server.close(() => process.exit(0)));
}

module.exports = { createFrontendServer };
