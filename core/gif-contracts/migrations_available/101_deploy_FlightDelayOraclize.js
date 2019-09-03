const { info } = require('../io/logger');


const FlightDelayOraclize = artifacts.require('examples/FlightDelayManual/FlightDelayOraclize.sol');
const ProductService = artifacts.require('services/ProductService.sol');
const InstanceOperatorService = artifacts.require('services/InstanceOperatorService.sol');


module.exports = async (deployer) => {
  const productService = await ProductService.deployed();
  const instanceOperator = await InstanceOperatorService.deployed();

  await deployer.deploy(FlightDelayOraclize, productService.address, { gas: 3500000 });
  const productId = 2;

  info('Approve product');
  await instanceOperator.approveProduct(productId, { gas: 200000 })
    .on('transactionHash', txHash => info(`transaction hash: ${txHash}\n`));
};
