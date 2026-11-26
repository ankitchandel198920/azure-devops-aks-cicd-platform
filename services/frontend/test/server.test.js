const { describe, it } = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const { createFrontendServer } = require('../src/server');

function get(server, reqPath) {
  return new Promise((resolve, reject) => {
    const addr = server.address();
    http.get(`http://127.0.0.1:${addr.port}${reqPath}`, (res) => {
      let body = '';
      res.on('data', (chunk) => { body += chunk; });
      res.on('end', () => resolve({ statusCode: res.statusCode, body }));
    }).on('error', reject);
  });
}

describe('Frontend Server', () => {
  it('serves /healthz', async () => {
    const server = createFrontendServer({ backendUrl: 'http://orders:8080' }).listen(0);
    try {
      const res = await get(server, '/healthz');
      assert.equal(res.statusCode, 200);
      const parsed = JSON.parse(res.body);
      assert.equal(parsed.status, 'ok');
    } finally {
      server.close();
    }
  });

  it('serves HTML portal at /', async () => {
    const server = createFrontendServer().listen(0);
    try {
      const res = await get(server, '/');
      assert.equal(res.statusCode, 200);
      assert.match(res.body, /Enterprise AKS Microservices Portal/);
    } finally {
      server.close();
    }
  });
});
