const { bootstrap, isDockerHost } = require('@etherisc/microservice');
const DipEventListener = require('./DipEventListener');


bootstrap(DipEventListener, {
  httpPort: isDockerHost() && !process.env.CI ? 3000 : 3011,
  rpcNode: process.env.RPC_NODE || 'ws://localhost:8545',
  networkName: process.env.NETWORK_NAME || 'development',
});
