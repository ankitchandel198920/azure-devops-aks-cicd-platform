const http = require('node:http');

function createApp({ serviceName = 'orders-api', version = process.env.APP_VERSION || '1.0.0' } = {}) {
  const orders = [
    { id: 'ORD-1001', item: 'AKS Compute Node Pool', status: 'provisioned', amountUsd: 420 },
    { id: 'ORD-1002', item: 'ACR Premium Replication', status: 'active', amountUsd: 150 },
  ];

  return http.createServer((req, res) => {
    const url = new URL(req.url, 'http://localhost');

    if (req.method === 'GET' && url.pathname === '/healthz') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'ok', service: serviceName, version }));
      return;
    }

    if (req.method === 'GET' && url.pathname === '/readyz') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ ready: true, service: serviceName }));
      return;
    }

    if (req.method === 'GET' && url.pathname === '/api/v1/orders') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ service: serviceName, count: orders.length, data: orders }));
      return;
    }

    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Not Found', path: url.pathname }));
  });
}

module.exports = { createApp };
