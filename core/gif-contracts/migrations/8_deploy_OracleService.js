const Registry = artifacts.require('modules/registry/Registry.sol');
const RegistryController = artifacts.require('modules/registry/RegistryController.sol');
const OracleService = artifacts.require('controllers/OracleService.sol');


module.exports = async (deployer) => {
  const registryStorage = await Registry.deployed();
  const registry = await RegistryController.at(registryStorage.address);

  await deployer.deploy(OracleService, registry.address);

  const oracleService = await OracleService.deployed();
  const oracleServiceName = await oracleService.NAME.call();

  await registry.registerService(oracleServiceName, oracleService.address);
};
