const { info } = require('../io/logger');


const InstanceOperatorService = artifacts.require('services/InstanceOperatorService.sol');

module.exports = async (deployer, networks, accounts) => {
  const instanceOperator = await InstanceOperatorService.deployed();

  info('Register Sandbox account');
  await instanceOperator.registerService(web3.utils.toHex('Sandbox'), accounts[0], { gas: 200000 })
    .on('transactionHash', txHash => info(`transaction hash: ${txHash}\n`));
};
