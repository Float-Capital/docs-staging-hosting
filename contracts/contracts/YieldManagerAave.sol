// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

import "./interfaces/IYieldManager.sol";
import "./interfaces/aave/ILendingPool.sol";
import "./interfaces/aave/IAaveIncentivesController.sol";

/** @title YieldManagerAave
  @notice contract is used to manage the yield generated by the underlying tokens. 
  YieldManagerAave is an implementation of a yield manager that earns APY from the Aave protocol. 
  Each fund's payment token (such as DAI) has a corresponding aToken (such as aDAI) that 
  continuously accrues interest based on a lend/borrow liquidity ratio.
  @dev https://docs.aave.com/portal/
  */
contract YieldManagerAave is IYieldManager {
  /*╔═════════════════════════════╗
    ║          VARIABLES          ║
    ╚═════════════════════════════╝*/

  /// @notice address of longShort contract
  address public longShort;
  /// @notice address of treasury contract - this is the address that can claim aave incentives rewards
  address public treasury;

  /// @notice The payment token the yield manager supports
  /// @dev DAI token
  ERC20 public paymentToken;
  /// @notice The token representing the interest accruing payment token position from Aave
  /// @dev ADAI token
  IERC20Upgradeable public aToken;
  /// @notice The specific Aave lending pool contract
  ILendingPool public lendingPool;
  /// @notice The specific Aave incentives controller contract
  IAaveIncentivesController public aaveIncentivesController;

  /// @dev An aave specific referralCode that has been a depricated feature. This will be set to 0 for "no referral" at deployment
  uint16 referralCode;

  /// @notice distributed yield not yet transferred to the treasury
  uint256 public override totalReservedForTreasury;

  /*╔═════════════════════════════╗
    ║           EVENTS            ║
    ╚═════════════════════════════╝*/

  event ClaimAaveRewardTokenToTreasury(uint256 amount);

  /*╔═════════════════════════════╗
    ║          MODIFIERS          ║
    ╚═════════════════════════════╝*/

  /// @dev only allow longShort contract to execute modified functions
  modifier longShortOnly() {
    require(msg.sender == longShort, "Not longShort");
    _;
  }

  /*╔═════════════════════════════╗
    ║       CONTRACT SET-UP       ║
    ╚═════════════════════════════╝*/

  /** 
    @notice Constructor for initializing the aave yield manager with a given payment token and corresponding Aave contracts
    @param _longShort address of the longShort contract
    @param _treasury address of the treasury contract
    @param _paymentToken address of the payment token
    @param _aToken address of the interest accruing token linked to the payment token
    @param _lendingPool address of the aave lending pool contract
    @param _aaveReferralCode unique code for aave referrals
    @dev referral code will be set to 0, depricated Aave feature
  */
  constructor(
    address _longShort,
    address _treasury,
    address _paymentToken,
    address _aToken,
    address _lendingPool,
    address _aaveIncentivesController,
    uint16 _aaveReferralCode
  ) {
    longShort = _longShort;
    treasury = _treasury;

    referralCode = _aaveReferralCode;

    paymentToken = ERC20(_paymentToken);
    aToken = IERC20Upgradeable(_aToken);
    lendingPool = ILendingPool(_lendingPool);
    aaveIncentivesController = IAaveIncentivesController(_aaveIncentivesController);

    // Approve tokens for aave lending pool maximally.
    paymentToken.approve(address(lendingPool), type(uint256).max);
  }

  /*╔════════════════════════╗
    ║     IMPLEMENTATION     ║
    ╚════════════════════════╝*/

  /** 
   @notice Allows the LongShort contract to deposit tokens into the aave pool
   @param amount Amount of payment token to deposit
  */
  function depositPaymentToken(uint256 amount) public override longShortOnly {
    // Transfer tokens to manager contract.
    paymentToken.transferFrom(longShort, address(this), amount);

    // Deposit the desired amount of tokens into the aave pool
    lendingPool.deposit(address(paymentToken), amount, address(this), referralCode);
  }

  /// @notice Allows the LongShort contract to redeem aTokens for the payment token
  /// @param amount Amount of payment token to withdraw
  function withdrawPaymentToken(uint256 amount) public override longShortOnly {
    lendingPool.withdraw(address(paymentToken), amount, address(this));

    // Transfer payment tokens back to LongShort contract.
    paymentToken.transfer(longShort, amount);
  }

  /**  
    @notice Allows for withdrawal of aave rewards to the treasury contract    
    @dev This is specifically implemented to allow withdrawal of aave reward wMatic tokens accrued    
  */
  function claimAaveRewardsToTreasury() external {
    uint256 amount = IAaveIncentivesController(aaveIncentivesController).getUserUnclaimedRewards(
      address(this)
    );

    address[] memory rewardsDepositedAssets = new address[](1);
    rewardsDepositedAssets[0] = address(paymentToken);

    IAaveIncentivesController(aaveIncentivesController).claimRewards(
      rewardsDepositedAssets,
      amount,
      treasury
    );

    emit ClaimAaveRewardTokenToTreasury(amount);
  }

  /**    
    @notice Calculates and updates the yield allocation to the treasury and the market
    @dev treasuryPercent = 1 - marketPercent
    @param totalValueRealizedForMarket total value of long and short side of the market
    @param treasuryYieldPercent_e18 Percentage of yield in base 1e18 that is allocated to the treasury
    @return The market allocation of the yield
  */
  function distributeYieldForTreasuryAndReturnMarketAllocation(
    uint256 totalValueRealizedForMarket,
    uint256 treasuryYieldPercent_e18
  ) public override longShortOnly returns (uint256) {
    uint256 totalHeld = aToken.balanceOf(address(this));

    uint256 totalRealized = totalValueRealizedForMarket + totalReservedForTreasury;

    if (totalRealized == totalHeld) {
      return 0;
    }

    // will revert in case totalRealized > totalHeld which should be never.
    uint256 unrealizedYield = totalHeld - totalRealized;

    uint256 amountForTreasury = (unrealizedYield * treasuryYieldPercent_e18) / 1e18;
    uint256 amountForMarketIncentives = unrealizedYield - amountForTreasury;

    totalReservedForTreasury += amountForTreasury;

    emit YieldDistributed(unrealizedYield, treasuryYieldPercent_e18);

    return amountForMarketIncentives;
  }

  /// @notice Withdraw treasury allocated accrued yield from the lending pool to the treasury contract
  function withdrawTreasuryFunds() external override {
    uint256 amountToWithdrawForTreasury = totalReservedForTreasury;
    totalReservedForTreasury = 0;

    // Redeem aToken for payment tokens.
    lendingPool.withdraw(address(paymentToken), amountToWithdrawForTreasury, treasury);

    emit WithdrawTreasuryFunds();
  }
}
