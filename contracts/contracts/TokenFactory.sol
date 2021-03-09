// SPDX-License-Identifier: MIT

pragma solidity 0.8.2;

import "@openzeppelin/contracts-upgradeable/utils/Initializable.sol";

import "./SyntheticToken.sol";

contract TokenFactory is Initializable {
    ////////////////////////////////////
    /////////////// STATE //////////////
    ////////////////////////////////////

    address public admin;
    address public floatContract;

    bytes32 public constant DEFAULT_ADMIN_ROLE =
        keccak256("DEFAULT_ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    ////////////////////////////////////
    /////////// MODIFIERS //////////////
    ////////////////////////////////////

    modifier adminOnly() {
        require(msg.sender == admin);
        _;
    }

    modifier onlyFLOAT() {
        require(msg.sender == floatContract);
        _;
    }

    ////////////////////////////////////
    //////////// SET-UP ////////////////
    ////////////////////////////////////

    function setup(address _admin, address _floatContract) public initializer {
        admin = _admin;
        floatContract = _floatContract;
    }

    ////////////////////////////////////
    /// MULTISIG ADMIN FUNCTIONS ///////
    ////////////////////////////////////

    function changeAdmin(address _admin) external adminOnly {
        admin = _admin;
    }

    function changeFloatAddress(address _floatContract) external adminOnly {
        floatContract = _floatContract;
    }

    ////////////////////////////////////
    ///////// TOKEN CREATION ///////////
    ////////////////////////////////////

    function setupPermissions(SyntheticToken tokenContract) internal {
        // Give minter roles
        tokenContract.grantRole(DEFAULT_ADMIN_ROLE, floatContract);
        tokenContract.grantRole(MINTER_ROLE, floatContract);
        tokenContract.grantRole(PAUSER_ROLE, floatContract);

        // Revoke roles
        tokenContract.revokeRole(DEFAULT_ADMIN_ROLE, address(this));
        tokenContract.revokeRole(MINTER_ROLE, address(this));
        tokenContract.revokeRole(PAUSER_ROLE, address(this));
    }

    function createTokenLong(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address staker
    ) external onlyFLOAT returns (SyntheticToken) {
        SyntheticToken tokenContract;
        tokenContract = new SyntheticToken();
        tokenContract.initialize(
            string(abi.encodePacked("FLOAT UP", syntheticName)),
            string(abi.encodePacked("fu", syntheticSymbol)),
            floatContract,
            staker
        );
        setupPermissions(tokenContract);
        return tokenContract;
    }

    function createTokenShort(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address staker
    ) external onlyFLOAT returns (SyntheticToken) {
        SyntheticToken tokenContract;
        tokenContract = new SyntheticToken();
        tokenContract.initialize(
            string(abi.encodePacked("FLOAT DOWN ", syntheticName)),
            string(abi.encodePacked("fd", syntheticSymbol)),
            floatContract,
            staker
        );

        setupPermissions(tokenContract);
        return tokenContract;
    }
}
