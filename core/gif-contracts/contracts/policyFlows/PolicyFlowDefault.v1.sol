pragma solidity 0.5.2;

import "../shared/WithRegistry.sol";
import "../modules/policy/IPolicy.sol";
import "../modules/policy/IPolicyController.v1.sol";
import "../modules/license/ILicenseController.sol";
import "../modules/query/IQueryController.sol";

contract PolicyFlowDefault is WithRegistry {
    bytes32 public constant NAME = "PolicyFlowDefault";

    constructor(address _registry) public WithRegistry(_registry) {}

    function newApplication(
        bytes32 _customerExternalId,
        uint256 _premium,
        bytes32 _currency,
        uint256[] calldata _payoutOptions
    ) external returns (uint256 _applicationId) {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        uint256 _matadataId = policy().createPolicyFlow(insuranceProductId);

        uint256 applicationId = policy().createApplication(
            insuranceProductId,
            _matadataId,
            _customerExternalId,
            _premium,
            _currency,
            _payoutOptions
        );

        _applicationId = applicationId;
    }

    function newClaim(uint256 _policyId) external returns (uint256 _claimId) {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        uint256 claimId = policy().createClaim(
            insuranceProductId,
            _policyId,
            ""
        );

        _claimId = claimId;
    }

    function confirmClaim(uint256 _claimId, uint256 _sum)
        external
        returns (uint256 _payoutId)
    {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        policy().setClaimState(
            insuranceProductId,
            _claimId,
            IPolicy.ClaimState.Confirmed
        );

        uint256 payoutId = policy().createPayout(
            insuranceProductId,
            _claimId,
            _sum
        );

        _payoutId = payoutId;
    }

    function declineClaim(uint256 _claimId) external {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        policy().setClaimState(
            insuranceProductId,
            _claimId,
            IPolicy.ClaimState.Declined
        );
    }

    function decline(uint256 _applicationId) external {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        policy().setApplicationState(
            insuranceProductId,
            _applicationId,
            IPolicy.ApplicationState.Declined
        );
    }

    function expire(uint256 _policyId) external {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        policy().setPolicyState(
            insuranceProductId,
            _policyId,
            IPolicy.PolicyState.Expired
        );
    }

    function payout(uint256 _payoutId, uint256 _amount)
        external
        returns (uint256 _remainder)
    {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        _remainder = policy().payOut(insuranceProductId, _payoutId, _amount);
    }

    function register(bytes32 _insuranceProductName, bytes32 _policyFlow)
        external
    {
        license().register(_insuranceProductName, msg.sender, _policyFlow);
    }

    function underwrite(uint256 _applicationId)
        external
        returns (uint256 _policyId)
    {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        policy().setApplicationState(
            insuranceProductId,
            _applicationId,
            IPolicy.ApplicationState.Underwritten
        );

        (uint256 metadataId, , , , ) = policy().getApplicationData(
            insuranceProductId,
            _applicationId
        );

        uint256 policyId = policy().createPolicy(
            insuranceProductId,
            metadataId
        );

        _policyId = policyId;
    }

    function request(
        bytes calldata _input,
        string calldata _callbackMethodName,
        address _callabackContractAddress,
        bytes32 _oracleTypeName,
        uint256 _responsibleOracleId
    ) external returns (uint256 _requestId) {
        _requestId = query().request(
            _input,
            _callbackMethodName,
            _callabackContractAddress,
            _oracleTypeName,
            _responsibleOracleId
        );
    }

    function getPayoutOptions(uint256 _applicationId)
        external
        view
        returns (uint256[] memory _payoutOptions)
    {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        _payoutOptions = policy().getPayoutOptions(
            insuranceProductId,
            _applicationId
        );
    }

    function getPremium(uint256 _applicationId)
        external
        view
        returns (uint256 _premium)
    {
        uint256 insuranceProductId = license().getInsuranceProductId(
            msg.sender
        );

        _premium = policy().getPremium(insuranceProductId, _applicationId);
    }

    function license() internal view returns (ILicenseController) {
        return ILicenseController(getContract("License"));
    }

    function policy() internal view returns (IPolicyController) {
        return IPolicyController(getContract("Policy"));
    }

    function query() internal view returns (IQueryController) {
        return IQueryController(getContract("Query"));
    }
}
