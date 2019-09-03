pragma solidity 0.5.2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../modules/license/ILicenseController.sol";
import "../modules/registry/IRegistryController.sol";
import "../modules/query/IQueryController.sol";
import "../shared/WithRegistry.sol";
import "../shared/IModuleController.sol";
import "../shared/IModuleStorage.sol";

contract InstanceOperatorService is WithRegistry, Ownable {
    bytes32 public constant NAME = "InstanceOperator";

    constructor(address _registry) public WithRegistry(_registry) {}

    function assignController(address _storage, address _controller) external onlyOwner {
        IModuleStorage(_storage).assignController(_controller);
    }

    function assingStorage(address _controller, address _storage) external onlyOwner {
        IModuleController(_controller).assignStorage(_storage);
    }

    /* License */
    function approveProduct(uint256 _productId) external onlyOwner {
        license().approveProduct(_productId);
    }

    function disapproveProduct(uint256 _productId) external onlyOwner {
        license().disapproveProduct(_productId);
    }

    function pauseProduct(uint256 _productId) external onlyOwner {
        license().pauseProduct(_productId);
    }

    function unpauseProduct(uint256 _productId) external onlyOwner {
        license().unpauseProduct(_productId);
    }

    /* Registry */
    function registerInRelease(
        uint256 _release,
        bytes32 _contractName,
        address _contractAddress
    ) external onlyOwner {
        registry.registerInRelease(_release, _contractName, _contractAddress);
    }

    function register(bytes32 _contractName, address _contractAddress)
        external
        onlyOwner
    {
        registry.register(_contractName, _contractAddress);
    }

    function deregisterInRelease(uint256 _release, bytes32 _contractName)
        external
        onlyOwner
    {
        registry.deregisterInRelease(_release, _contractName);
    }

    function deregister(bytes32 _contractName) external onlyOwner {
        registry.deregister(_contractName);
    }

    function prepareRelease() external onlyOwner returns (uint256 _release) {
        _release = registry.prepareRelease();
    }

    function registerService(bytes32 _name, address _addr) external {
        registry.registerService(_name, _addr);
    }

    /* Query */
    function activateOracleType(bytes32 _oracleTypeName) external onlyOwner {
        query().activateOracleType(_oracleTypeName);
    }

    function activateOracle(uint256 _oracleId) external onlyOwner {
        query().activateOracle(_oracleId);
    }

    function assignOracleToOracleType(
        bytes32 _oracleTypeName,
        uint256 _oracleId
    ) external onlyOwner {
        query().assignOracleToOracleType(_oracleTypeName, _oracleId);
    }

    /* Lookup */
    function license() internal view returns (ILicenseController) {
        return ILicenseController(registry.getContract("License"));
    }

    function query() internal view returns (IQueryController) {
        return IQueryController(registry.getContract("Query"));
    }
}
