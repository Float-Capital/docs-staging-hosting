// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "./SyntheticToken.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/ITokenFactory.sol";

contract TokenFactory is ITokenFactory {
    ////////////////////////////////////
    /////////////// STATE //////////////
    ////////////////////////////////////

    address public admin;
    ILongShort public longShort;

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

    modifier onlyLongShort() {
        require(msg.sender == address(longShort));
        _;
    }

    ////////////////////////////////////
    //////////// SET-UP ////////////////
    ////////////////////////////////////

    constructor(address _admin, ILongShort _longShort) {
        admin = _admin;
        longShort = _longShort;
    }

    ////////////////////////////////////
    /// MULTISIG ADMIN FUNCTIONS ///////
    ////////////////////////////////////

    function changeAdmin(address _admin) external adminOnly {
        admin = _admin;
    }

    function changeFloatAddress(ILongShort _longShort) external adminOnly {
        longShort = _longShort;
    }

    ////////////////////////////////////
    ///////// TOKEN CREATION ///////////
    ////////////////////////////////////

    function setupPermissions(SyntheticToken tokenContract) internal {
        // Give minter roles
        tokenContract.grantRole(DEFAULT_ADMIN_ROLE, address(longShort));
        tokenContract.grantRole(MINTER_ROLE, address(longShort));
        tokenContract.grantRole(PAUSER_ROLE, address(longShort));

        // Revoke roles
        tokenContract.revokeRole(DEFAULT_ADMIN_ROLE, address(this));
        tokenContract.revokeRole(MINTER_ROLE, address(this));
        tokenContract.revokeRole(PAUSER_ROLE, address(this));
    }

    function createTokenLong(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        IStaker staker,
        uint32 marketIndex
    ) external override onlyLongShort returns (SyntheticToken) {
        SyntheticToken tokenContract =
            new SyntheticToken(
                string(abi.encodePacked("FLOAT UP", syntheticName)),
                string(abi.encodePacked("fu", syntheticSymbol)),
                longShort,
                staker,
                marketIndex,
                true /*long*/
            );
        setupPermissions(tokenContract);
        return tokenContract;
    }

    function createTokenShort(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        IStaker staker,
        uint32 marketIndex
    ) external override onlyLongShort returns (SyntheticToken) {
        SyntheticToken tokenContract =
            new SyntheticToken(
                string(abi.encodePacked("FLOAT DOWN ", syntheticName)),
                string(abi.encodePacked("fd", syntheticSymbol)),
                longShort,
                staker,
                marketIndex,
                false /*short*/
            );

        setupPermissions(tokenContract);
        return tokenContract;
    }
}
