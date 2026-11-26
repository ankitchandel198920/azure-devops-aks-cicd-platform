const { createApp } = require('./app');

const port = Number(process.env.PORT || 8080);
const server = createApp();

server.listen(port, '0.0.0.0', () => {
  console.log(JSON.stringify({ level: 'info', msg: 'Backend listening', port }));
});

process.on('SIGTERM', () => {
  server.close(() => process.exit(0));
});
