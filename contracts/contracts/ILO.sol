// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";

import "./interfaces/ILongShort.sol";

/** @title ILO Contract */
contract ILO is Initializable, UUPSUpgradeable, AccessControlUpgradeable {
  //Using Open Zeppelin safe transfer library for token transfers
  using SafeERC20 for IERC20;

  bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
  bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

  address public longShort;

  // whitelist of participants
  mapping(address => mapping(uint32 => uint256)) public whitelistAllocation;

  // timestamp at which user added liquidity....
  mapping(address => mapping(uint32 => uint256)) public providerInitialTimestamp;

  // user deposited amount
  mapping(address => mapping(uint32 => uint256)) public providerDepositedAmount;

  /*╔═════════════════════════════╗
    ║       CONTRACT SETUP        ║
    ╚═════════════════════════════╝*/

  function initialize(address _longShort) external initializer {
    __AccessControl_init();
    __UUPSUpgradeable_init();

    longShort = _longShort;

    _setupRole(UPGRADER_ROLE, msg.sender);
    _setupRole(ADMIN_ROLE, msg.sender);
  }

  function _authorizeUpgrade(address newImplementation) internal override onlyRole(UPGRADER_ROLE) {}

  function setAllocationAmount(
    address whitelistedAddress,
    uint32 marketIndex,
    uint256 allocatedAmount
  ) external onlyRole(ADMIN_ROLE) {
    whitelistAllocation[whitelistedAddress][marketIndex] = allocatedAmount;
  }

  // add liquidity
  // this will accept an amount of dai (payment token) and equally deposit it into the market of long short
  function addLiquidityToMarket(
    uint32 marketIndex,
    uint256 amount,
    address paymentToken
  ) external {
    require(whitelistAllocation[msg.sender][marketIndex] == amount, "not whitelisted");
    whitelistAllocation[msg.sender][marketIndex] = 0;
    //need to get the payment Token for the market still
    IERC20(paymentToken).safeTransferFrom(msg.sender, address(this), amount);

    //Any whitelisted provider should deposit at least 1e18
    uint256 splitAmount = amount / 2;
    providerInitialTimestamp[msg.sender][marketIndex] = block.timestamp;

    ILongShort(longShort).mintLongNextPrice(marketIndex, splitAmount);
    ILongShort(longShort).mintShortNextPrice(marketIndex, splitAmount);

    providerDepositedAmount[msg.sender][marketIndex] = amount;
    //Have the timestamp and the amount deposited, need to still stake the amounts and calculate equity float distribution

    // checking whitelistAllocation amount. and updating this.
    // erc20 interface to transfer the tokens from user to our ILO contract.
    // on marketIndex in LongShort, call mintNextPrice for both long or short in equal amounts.
  }

  // Function to stake to all supplied capital

  // rebalance liquidity. calling shift tokens on staker contract.
}
