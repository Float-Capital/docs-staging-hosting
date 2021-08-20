// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/** @title Float Capital Contract */
contract FloatCapital_v0 is Initializable, UUPSUpgradeable {
  address public admin;

  /*╔═════════════════════════════╗
    ║          MODIFIERS          ║
    ╚═════════════════════════════╝*/

  modifier onlyAdmin() {
    require(msg.sender == admin, "Not admin");
    _;
  }

  /*╔═════════════════════════════╗
    ║       CONTRACT SETUP        ║
    ╚═════════════════════════════╝*/

  function initialize(address _admin) external initializer {
    admin = _admin;
  }

  /*╔════════════════════════════════╗
    ║    MULTISIG ADMIN FUNCTIONS    ║
    ╚════════════════════════════════╝*/

  function changeAdmin(address _admin) external onlyAdmin {
    admin = _admin;
  }

  /// @notice Authorizes an upgrade to a new address.
  /// @dev Can only be called by the current admin.
  function _authorizeUpgrade(address) internal override onlyAdmin {}

  /** A percentage of float token to accrue here for project
     development */
}
