// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

/** @title ILO Contract */
contract ILO is Initializable, UUPSUpgradeable, AccessControlUpgradeable {
  bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

  // whitlist of partipants
  mapping(address => uint256) public whitelistAllocation;

  // timestamp at which user added liquidity....

  /*╔═════════════════════════════╗
    ║       CONTRACT SETUP        ║
    ╚═════════════════════════════╝*/

  function initialize() external initializer {
    __AccessControl_init();
    __UUPSUpgradeable_init();

    _setupRole(UPGRADER_ROLE, msg.sender);
  }

  function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}

  // add liquidity
  // this will accept an amount of dai (apyment token) and equally deposit it into the market of long short
  function addLiquidityToMarket(
    uint256 marketIndex,
    uint256 amount,
    address paymentToken
  ) external {
    // checking whitelistAllocation amount. and updating this.
    // erc20 interface to transfer the tokens from user to our ILO contract.
    // on marketIndex in LongShort, call mintNextPrice for both long or short in equal amounts.
  }

  // Function to stake to all supplied capital

  // rebalance liquidity. calling shift tokens on staker contract.
}
