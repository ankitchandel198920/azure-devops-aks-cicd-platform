const { describe, it } = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const { createApp } = require('../src/app');

function request(server, path) {
  return new Promise((resolve, reject) => {
    const addr = server.address();
    http.get(`http://127.0.0.1:${addr.port}${path}`, (res) => {
      let body = '';
      res.on('data', (chunk) => { body += chunk; });
      res.on('end', () => resolve({ statusCode: res.statusCode, body: JSON.parse(body) }));
    }).on('error', reject);
  });
}

describe('Backend API', () => {
  it('returns healthy status on /healthz', async () => {
    const server = createApp({ version: 'test-sha' }).listen(0);
    try {
      const res = await request(server, '/healthz');
      assert.equal(res.statusCode, 200);
      assert.equal(res.body.status, 'ok');
      assert.equal(res.body.version, 'test-sha');
    } finally {
      server.close();
    }
  });

  it('returns orders list on /api/v1/orders', async () => {
    const server = createApp().listen(0);
    try {
      const res = await request(server, '/api/v1/orders');
      assert.equal(res.statusCode, 200);
      assert.equal(res.body.count, 2);
      assert.ok(Array.isArray(res.body.data));
    } finally {
      server.close();
    }
  });

  it('returns 404 for unknown routes', async () => {
    const server = createApp().listen(0);
    try {
      const res = await request(server, '/unknown');
      assert.equal(res.statusCode, 404);
    } finally {
      server.close();
    }
  });
});
