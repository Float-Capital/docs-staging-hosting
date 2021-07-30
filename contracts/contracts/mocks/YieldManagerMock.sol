// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

import "../interfaces/IYieldManager.sol";

// TODO: it would be better to deprecate this mock and rather mock aave and use the
//       `YieldManagerAave` to avoid duplicate code/logic that can easily go out of sync.

/*
 * YieldManagerMock is an implementation of a yield manager that supports
 * configurable, deterministic token yields for testing. Note that the mock
 * needs to be able to mint the underlying token to simulate yield.
 */
contract YieldManagerMock is IYieldManager {
  // Admin contracts.
  address public admin;
  address public longShort;
  address public treasury;

  // Fixed-precision scale for interest percentages and fees.
  uint256 public constant TEN_TO_THE_18 = 1e18;

  // Global state.
  ERC20PresetMinterPauser public token;
  ERC20PresetMinterPauser public tokenOtherRewardERC20;

  uint256 public override totalReservedForTreasury;
  uint256 public totalHeld;

  uint256 public yieldRate; // pcnt per sec
  uint256 public lastSettled; // secs after epoch

  ////////////////////////////////////
  /////////// MODIFIERS //////////////
  ////////////////////////////////////

  modifier adminOnly() {
    require(msg.sender == admin, "Not admin");
    _;
  }

  modifier longShortOnly() {
    require(msg.sender == longShort, "Not longShort");
    _;
  }

  modifier treasuryOnly() {
    require(msg.sender == treasury, "Not longShort");
    _;
  }

  ////////////////////////////////////
  ///// CONTRACT SET-UP //////////////
  ////////////////////////////////////

  constructor(
    address _admin,
    address _longShort,
    address _treasury,
    address _token
  ) {
    // Admin contracts.
    admin = _admin;
    longShort = _longShort;
    treasury = _treasury;

    // Global state.
    token = ERC20PresetMinterPauser(_token);
    lastSettled = block.timestamp;
  }

  ////////////////////////////////////
  ///// IMPLEMENTATION ///////////////
  ////////////////////////////////////

  /**
   * Adds the token's accrued yield to the token holdings.
   */
  function settle() public {
    uint256 totalYieldRate = yieldRate * (block.timestamp - lastSettled);
    uint256 totalYield = (totalHeld * totalYieldRate) / TEN_TO_THE_18;

    lastSettled = block.timestamp;
    totalHeld = totalHeld + totalYield;
    if (totalYield > 0) {
      token.mint(address(this), totalYield);
    }
  }

  /**
   * Adds the given yield percent to the token holdings.
   */
  function settleWithYieldPercent(uint256 yieldPercent) public adminOnly {
    uint256 totalYield = (totalHeld * yieldPercent) / TEN_TO_THE_18;

    lastSettled = block.timestamp;
    totalHeld = totalHeld + totalYield;
    token.mint(address(this), totalYield);
  }

  /**
   * Adds the given absolute yield to the token holdings.
   */
  function settleWithYieldAbsolute(uint256 totalYield) public adminOnly {
    lastSettled = block.timestamp;
    totalHeld = totalHeld + totalYield;
    token.mint(address(this), totalYield);
  }

  /**
   * Adds the given yield to the token holdings.
   */
  function mockHoldingAdditionalRewardYield() public adminOnly {
    tokenOtherRewardERC20.mint(address(this), TEN_TO_THE_18 * 2);
  }

  /**
   * Sets the yield percentage per second for the given token.
   */
  function setYieldRate(uint256 _yieldRate) public adminOnly {
    yieldRate = _yieldRate;
  }

  function depositPaymentToken(uint256 amount) public override longShortOnly {
    // Ensure token state is current.
    settle();

    // Transfer tokens to manager contract.
    token.transferFrom(longShort, address(this), amount);
    totalHeld = totalHeld + amount;
  }

  function withdrawPaymentToken(uint256 amount) public override longShortOnly {
    // Ensure token state is current.
    settle();
    require(amount <= totalHeld);

    // Transfer tokens back to LongShort contract.
    token.transfer(longShort, amount);
    totalHeld = totalHeld - amount;
  }

  function withdrawErc20TokenToTreasury(address erc20Token) external override treasuryOnly {
    // Redeem other erc20 tokens.
    // Transfer tokens back to Treasury contract.
    mockHoldingAdditionalRewardYield();
    uint256 amount = ERC20PresetMinterPauser(erc20Token).balanceOf(address(this));
    ERC20PresetMinterPauser(erc20Token).transfer(treasury, amount);
  }

  // TODO STENT need to change this and unit test it
  function claimYieldAndGetMarketAmount(
    uint256 totalValueRealizedForMarket,
    uint256 treasuryYieldPercentE18
  ) public override longShortOnly returns (uint256) {
    uint256 unrealizedYield = totalHeld - totalValueRealizedForMarket - totalReservedForTreasury;

    if (unrealizedYield == 0) {
      return 0;
    }

    uint256 amountForTreasury = (unrealizedYield * treasuryYieldPercentE18) / TEN_TO_THE_18;
    uint256 amountForMarketIncentives = unrealizedYield - amountForTreasury;

    totalReservedForTreasury += amountForTreasury;

    return amountForMarketIncentives;
  }

  // TODO STENT need to change this and unit test it
  function withdrawTreasuryFunds() external override longShortOnly {}
}
