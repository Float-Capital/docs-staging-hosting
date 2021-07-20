// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "./SyntheticToken.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/ITokenFactory.sol";

contract TokenFactory is ITokenFactory {
  /*╔═══════════════════════════╗
    ║           STATE           ║
    ╚═══════════════════════════╝*/
  address public admin;
  address public longShort;

  bytes32 public constant DEFAULT_ADMIN_ROLE = keccak256("DEFAULT_ADMIN_ROLE");
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  /*╔═══════════════════════════╗
    ║         MODIFIERS         ║
    ╚═══════════════════════════╝*/

  modifier adminOnly() {
    require(msg.sender == admin);
    _;
  }

  modifier onlyLongShort() {
    require(msg.sender == address(longShort));
    _;
  }

  /*╔════════════════════════════╗
    ║           SET-UP           ║
    ╚════════════════════════════╝*/

  constructor(address _admin, address _longShort) {
    admin = _admin;
    longShort = _longShort;
  }

  /*╔════════════════════════════════╗
    ║    MULTISIG ADMIN FUNCTIONS    ║
    ╚════════════════════════════════╝*/

  function changeAdmin(address _admin) external adminOnly {
    admin = _admin;
  }

  function changeFloatAddress(address _longShort) external adminOnly {
    longShort = _longShort;
  }

  /*╔════════════════════════════╗
    ║       TOKEN CREATION       ║
    ╚════════════════════════════╝*/

  function setupPermissions(address tokenContract) internal {
    // Give minter roles
    SyntheticToken(tokenContract).grantRole(DEFAULT_ADMIN_ROLE, longShort);
    SyntheticToken(tokenContract).grantRole(MINTER_ROLE, longShort);
    SyntheticToken(tokenContract).grantRole(PAUSER_ROLE, longShort);

    // Revoke roles
    SyntheticToken(tokenContract).revokeRole(DEFAULT_ADMIN_ROLE, address(this));
    SyntheticToken(tokenContract).revokeRole(MINTER_ROLE, address(this));
    SyntheticToken(tokenContract).revokeRole(PAUSER_ROLE, address(this));
  }

  function createTokenLong(
    string calldata syntheticName,
    string calldata syntheticSymbol,
    address staker,
    uint32 marketIndex
  ) external override onlyLongShort returns (address syntheticToken) {
    syntheticToken = address(
      new SyntheticToken(
        string(abi.encodePacked("FLOAT UP", syntheticName)),
        string(abi.encodePacked("fu", syntheticSymbol)),
        longShort,
        staker,
        marketIndex,
        true /*long*/
      )
    );

    setupPermissions(syntheticToken);
  }

  function createTokenShort(
    string calldata syntheticName,
    string calldata syntheticSymbol,
    address staker,
    uint32 marketIndex
  ) external override onlyLongShort returns (address syntheticToken) {
    syntheticToken = address(
      new SyntheticToken(
        string(abi.encodePacked("FLOAT DOWN ", syntheticName)),
        string(abi.encodePacked("fd", syntheticSymbol)),
        longShort,
        staker,
        marketIndex,
        false /*short*/
      )
    );

    setupPermissions(syntheticToken);
  }
}
