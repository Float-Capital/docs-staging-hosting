// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "./SyntheticToken.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/ITokenFactory.sol";

/// @title TokenFactory
/// @notice TODO
/// @dev
contract TokenFactory is ITokenFactory {
  /*╔═══════════════════════════╗
    ║           STATE           ║
    ╚═══════════════════════════╝*/
  /// @notice TODO
  address public admin;
  /// @notice TODO
  address public longShort;

  /// @notice TODO
  bytes32 public constant DEFAULT_ADMIN_ROLE = keccak256("DEFAULT_ADMIN_ROLE");
  /// @notice TODO
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  /// @notice TODO
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  /*╔═══════════════════════════╗
    ║         MODIFIERS         ║
    ╚═══════════════════════════╝*/

  /// @dev
  modifier adminOnly() {
    require(msg.sender == admin);
    _;
  }

  /// @dev
  modifier onlyLongShort() {
    require(msg.sender == address(longShort));
    _;
  }

  /*╔════════════════════════════╗
    ║           SET-UP           ║
    ╚════════════════════════════╝*/

  /// @notice TODO
  /// @dev TODO
  /// @param _admin TODO
  /// @param _longShort TODO

  constructor(address _admin, address _longShort) {
    admin = _admin;
    longShort = _longShort;
  }

  /*╔════════════════════════════════╗
    ║    MULTISIG ADMIN FUNCTIONS    ║
    ╚════════════════════════════════╝*/

  /// @notice TODO
  /// @dev TODO
  /// @param _admin TODO
  function changeAdmin(address _admin) external adminOnly {
    admin = _admin;
  }

  /// @notice TODO
  /// @dev TODO
  /// @param _longShort TODO
  function changeFloatAddress(address _longShort) external adminOnly {
    longShort = _longShort;
  }

  /*╔════════════════════════════╗
    ║       TOKEN CREATION       ║
    ╚════════════════════════════╝*/

  /// @notice TODO
  /// @dev TODO
  /// @param tokenContract TODO
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

  /// @notice TODO
  /// @dev TODO
  /// @param syntheticName TODO
  /// @param syntheticSymbol TODO
  /// @param staker TODO
  /// @param marketIndex TODO
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

  /// @notice TODO
  /// @dev TODO
  /// @param syntheticName TODO
  /// @param syntheticSymbol TODO
  /// @param staker TODO
  /// @param marketIndex TODO
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
