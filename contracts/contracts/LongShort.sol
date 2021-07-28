// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/ITokenFactory.sol";
import "./interfaces/ISyntheticToken.sol";
import "./interfaces/IStaker.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/IYieldManager.sol";
import "./interfaces/IOracleManager.sol";

/**
 **** visit https://float.capital *****
 */

/// @title Core logic of Float Protocal markets
/// @author float.capital
/// @notice visit https://float.capital for more info
/// @dev All functions in this file are currently `virtual`. This is NOT to encourage inheritance. It is merely for convenince when unit testing.
/// @custom:auditors This contract balances long and short sides.
contract LongShort is ILongShort, Initializable {
  /*╔═════════════════════════════╗
    ║          VARIABLES          ║
    ╚═════════════════════════════╝*/

  // Fixed-precision constants
  address public constant DEAD_ADDRESS = 0xf10A7_F10A7_f10A7_F10a7_F10A7_f10a7_F10A7_f10a7;
  uint256[45] private __constantsGap;

  // Global state
  address public admin;
  address public treasury;
  uint32 public latestMarket;

  address public staker;
  address public tokenFactory;
  uint256[45] private __globalStateGap;

  // Market specific
  mapping(uint32 => bool) public marketExists;
  mapping(uint32 => uint256) public assetPrice;
  mapping(uint32 => uint256) public marketUpdateIndex;
  mapping(uint32 => address) public paymentTokens;
  mapping(uint32 => address) public yieldManagers;
  mapping(uint32 => address) public oracleManagers;

  // Market + position (long/short) specific
  mapping(uint32 => mapping(bool => address)) public syntheticTokens;
  mapping(uint32 => mapping(bool => uint256)) public syntheticTokenPoolValue;

  mapping(uint32 => mapping(bool => mapping(uint256 => uint256)))
    public syntheticTokenPriceSnapshot;

  mapping(uint32 => mapping(bool => uint256)) public batchedAmountOfPaymentTokenToDeposit;
  mapping(uint32 => mapping(bool => uint256)) public batchedAmountOfSynthTokensToRedeem;
  mapping(uint32 => mapping(bool => uint256)) public batchedAmountOfSynthTokensToShiftMarketSide;

  // User specific
  mapping(uint32 => mapping(address => uint256)) public userCurrentNextPriceUpdateIndex;

  mapping(uint32 => mapping(bool => mapping(address => uint256))) public userNextPriceDepositAmount;
  mapping(uint32 => mapping(bool => mapping(address => uint256)))
    public userNextPriceRedemptionAmount;
  mapping(uint32 => mapping(bool => mapping(address => uint256)))
    public userNextPrice_amountSynthToShiftFromMarketSide;

  /*╔════════════════════════════╗
    ║           EVENTS           ║
    ╚════════════════════════════╝*/

  event LongShortV1(address admin, address treasury, address tokenFactory, address staker);

  event SystemStateUpdated(
    uint32 marketIndex,
    uint256 updateIndex,
    int256 underlyingAssetPrice,
    uint256 longValue,
    uint256 shortValue,
    uint256 longPrice,
    uint256 shortPrice
  );

  event SyntheticTokenCreated(
    uint32 marketIndex,
    address longTokenAddress,
    address shortTokenAddress,
    address paymentToken,
    uint256 initialAssetPrice,
    string name,
    string symbol,
    address oracleAddress,
    address yieldManagerAddress
  );

  event NextPriceRedeem(
    uint32 marketIndex,
    bool isLong,
    uint256 synthRedeemed,
    address user,
    uint256 oracleUpdateIndex
  );

  event NextPriceSyntheticPositionShift(
    uint32 marketIndex,
    bool isShiftFromLong,
    uint256 synthShifted,
    address user,
    uint256 oracleUpdateIndex
  );

  event NextPriceDeposit(
    uint32 marketIndex,
    bool isLong,
    uint256 depositAdded,
    address user,
    uint256 oracleUpdateIndex
  );

  event OracleUpdated(uint32 marketIndex, address oldOracleAddress, address newOracleAddress);

  event NewMarketLaunchedAndSeeded(uint32 marketIndex, uint256 initialSeed);

  event ExecuteNextPriceMintSettlementUser(
    address user,
    uint32 marketIndex,
    bool isLong,
    uint256 amount
  );

  event ExecuteNextPriceRedeemSettlementUser(
    address user,
    uint32 marketIndex,
    bool isLong,
    uint256 amount
  );

  event ExecuteNextPriceMarketSideShiftSettlementUser(
    address user,
    uint32 marketIndex,
    bool isShiftFromLong,
    uint256 amount
  );

  event ExecuteNextPriceSettlementsUser(address user, uint32 marketIndex);

  /*╔═════════════════════════════╗
    ║          MODIFIERS          ║
    ╚═════════════════════════════╝*/

  /**
   * Necessary to update system state before any contract actions (deposits / withdraws)
   */

  function adminOnlyModifierLogic() internal virtual {
    require(msg.sender == admin, "only admin");
  }

  modifier adminOnly() {
    adminOnlyModifierLogic();
    _;
  }

  function assertMarketExistsModifierLogic(uint32 marketIndex) internal view virtual {
    require(marketExists[marketIndex], "market doesn't exist");
  }

  modifier assertMarketExists(uint32 marketIndex) {
    assertMarketExistsModifierLogic(marketIndex);
    _;
  }

  modifier executeOutstandingNextPriceSettlements(address user, uint32 marketIndex) {
    _executeOutstandingNextPriceSettlements(user, marketIndex);
    _;
  }

  modifier updateSystemStateMarket(uint32 marketIndex) {
    _updateSystemStateInternal(marketIndex);

    _;
  }

  /*╔═════════════════════════════╗
    ║       CONTRACT SET-UP       ║
    ╚═════════════════════════════╝*/

  /// @notice Initializes the contract.
  /// @dev Calls OpenZeppelin's initializer modifier.
  /// @param _admin Address of the admin role.
  /// @param _treasury Address of the treasury.
  /// @param _tokenFactory Address of the contract which creates synthetic asset tokens.
  /// @param _staker Address of the contract which handles synthetic asset stakes.
  function initialize(
    address _admin,
    address _treasury,
    address _tokenFactory,
    address _staker
  ) public virtual initializer {
    admin = _admin;
    treasury = _treasury;
    tokenFactory = _tokenFactory;
    staker = _staker;

    emit LongShortV1(_admin, address(treasury), address(_tokenFactory), address(_staker));
  }

  /*╔═════════════════════════════╗
    ║       MULTI-SIG ADMIN       ║
    ╚═════════════════════════════╝*/

  /// @notice Changes the admin address for this contract.
  /// @dev Can only be called by the current admin.
  /// @param _admin Address of the new admin.
  function changeAdmin(address _admin) external adminOnly {
    admin = _admin;
  }

  /// @notice Changes the treasury contract address for this contract.
  /// @dev Can only be called by the current admin.
  /// @param _treasury TODO
  function changeTreasury(address _treasury) external adminOnly {
    treasury = _treasury;
  }

  /// @notice Update oracle for a market
  /// @dev Can only be called by the current admin.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param _newOracleManager TODO
  function updateMarketOracle(uint32 marketIndex, address _newOracleManager) external adminOnly {
    // If not a oracle contract this would break things.. Test's arn't validating this
    // Ie require isOracle interface - ERC165
    address previousOracleManager = oracleManagers[marketIndex];
    oracleManagers[marketIndex] = _newOracleManager;
    emit OracleUpdated(marketIndex, previousOracleManager, _newOracleManager);
  }

  /*╔═════════════════════════════╗
    ║       MARKET CREATION       ║
    ╚═════════════════════════════╝*/

  /// @notice Creates an entirely new long/short market tracking an underlying oracle price. Make sure the synthetic names/symbols are unique.
  /// @dev This does not make the market active. That `initializeMarket` function was split out separately to this function to reduce costs.
  /// @param syntheticName Name of the synthetic asset
  /// @param syntheticSymbol Symbol for the synthetic asset
  /// @param _paymentToken The address of the erc20 token used to buy this synthetic asset
  /// @param _oracleManager The address of the oracle manager that provides the price feed for this market
  /// @param _yieldManager The contract that manages depositing the paymentToken into a yield bearing protocol
  function newSyntheticMarket(
    string calldata syntheticName,
    string calldata syntheticSymbol,
    address _paymentToken,
    address _oracleManager,
    address _yieldManager
  ) external adminOnly {
    latestMarket++;

    // Create new synthetic long token.
    syntheticTokens[latestMarket][true] = ITokenFactory(tokenFactory).createTokenLong(
      syntheticName,
      syntheticSymbol,
      staker,
      latestMarket
    );

    // Create new synthetic short token.
    syntheticTokens[latestMarket][false] = ITokenFactory(tokenFactory).createTokenShort(
      syntheticName,
      syntheticSymbol,
      staker,
      latestMarket
    );

    // Initial market state.
    paymentTokens[latestMarket] = _paymentToken;
    yieldManagers[latestMarket] = _yieldManager;
    oracleManagers[latestMarket] = _oracleManager;
    assetPrice[latestMarket] = uint256(IOracleManager(oracleManagers[latestMarket]).updatePrice());

    // Approve tokens for aave lending pool maximally.
    IERC20(paymentTokens[latestMarket]).approve(_yieldManager, type(uint256).max);

    emit SyntheticTokenCreated(
      latestMarket,
      syntheticTokens[latestMarket][true],
      syntheticTokens[latestMarket][false],
      _paymentToken,
      assetPrice[latestMarket],
      syntheticName,
      syntheticSymbol,
      _oracleManager,
      _yieldManager
    );
  }

  /// @notice Seeds a new market with initial capital.
  /// @dev Only called when initializing a market.
  /// @param initialMarketSeed Amount in wei for which to seed both sides of the market.
  /// @param marketIndex An int32 which uniquely identifies a market.
  function _seedMarketInitially(uint256 initialMarketSeed, uint32 marketIndex) internal virtual {
    require(
      // You require at least 10^17 of the underlying payment token to seed the market.
      initialMarketSeed > 0.1 ether,
      "Insufficient market seed"
    );

    _lockFundsInMarket(marketIndex, initialMarketSeed * 2);

    ISyntheticToken(syntheticTokens[latestMarket][true]).mint(DEAD_ADDRESS, initialMarketSeed);
    ISyntheticToken(syntheticTokens[latestMarket][false]).mint(DEAD_ADDRESS, initialMarketSeed);

    syntheticTokenPoolValue[marketIndex][true] = initialMarketSeed;
    syntheticTokenPoolValue[marketIndex][false] = initialMarketSeed;

    emit NewMarketLaunchedAndSeeded(marketIndex, initialMarketSeed);
  }

  /// @notice Sets a market as active once it has already been setup by newMarket.
  /// @dev Seperated from newMarket due to gas considerations.
  /// @param marketIndex An int32 which uniquely identifies the market.
  /// @param kInitialMultiplier Linearly decreasing multiplier for Float token issuance for the market when staking synths.
  /// @param kPeriod Time which kInitialMultiplier will last
  /// @param unstakeFeeBasisPoints Base 1e18 percentage fee levied when unstaking for the market.
  /// @param balanceIncentiveCurveExponent Sets the degree to which Float token issuance differs for market sides in unbalanced markets. See Staker.sol
  /// @param balanceIncentiveCurveEquilibriumOffset An offset to acocunt for naturally imbalanced markets when Float token issuance should differ for market sides. See Staker.sol
  /// @param initialMarketSeed Amount of ether that will be deposited in each market side to seed the market.
  function initializeMarket(
    uint32 marketIndex,
    uint256 kInitialMultiplier,
    uint256 kPeriod,
    uint256 unstakeFeeBasisPoints,
    uint256 initialMarketSeed,
    uint256 balanceIncentiveCurveExponent,
    int256 balanceIncentiveCurveEquilibriumOffset
  ) external adminOnly {
    require(!marketExists[marketIndex], "already initialized");
    require(marketIndex <= latestMarket, "index too highh");

    marketExists[marketIndex] = true;

    // Add new staker funds with fresh synthetic tokens.
    IStaker(staker).addNewStakingFund(
      latestMarket,
      syntheticTokens[latestMarket][true],
      syntheticTokens[latestMarket][false],
      kInitialMultiplier,
      kPeriod,
      unstakeFeeBasisPoints,
      balanceIncentiveCurveExponent,
      balanceIncentiveCurveEquilibriumOffset
    );

    _seedMarketInitially(initialMarketSeed, marketIndex);
  }

  /*╔══════════════════════════════╗
    ║       GETTER FUNCTIONS       ║
    ╚══════════════════════════════╝*/

  /// @notice Calculates the conversion rate from synthetic tokens to payment tokens.
  /// @dev Synth tokens have a fixed 18 decimals.
  /// @param amountPaymentToken Amount of payment tokens in that token's lowest denomination.
  /// @param amountSynthToken Amount of synth token in wei.
  /// @return syntheticTokenPrice The calculated conversion rate in base 1e18.
  function _getSyntheticTokenPrice(uint256 amountPaymentToken, uint256 amountSynthToken)
    internal
    pure
    virtual
    returns (uint256 syntheticTokenPrice)
  {
    return (amountPaymentToken * 1e18) / amountSynthToken;
  }

  /// @notice Converts synth token amounts to payment token amounts at a synth token price.
  /// @dev Price assumed base 1e18.
  /// @param amountSynthToken Amount of synth token in wei.
  /// @param price The conversion rate from synth to payment tokens in base 1e18.
  /// @return amountPaymentToken The calculated amount of payment tokens in token's lowest denomination.
  function _getAmountPaymentToken(uint256 amountSynthToken, uint256 price)
    internal
    pure
    virtual
    returns (uint256 amountPaymentToken)
  {
    return (amountSynthToken * price) / 1e18;
  }

  /// @notice Converts payment token amounts to synth token amounts at a synth token price.
  /// @dev  Price assumed base 1e18.
  /// @param amountPaymentToken Amount of payment tokens in that token's lowest denomination.
  /// @param price The conversion rate from synth to payment tokens in base 1e18.
  /// @return amountSynthToken The calculated amount of synthetic token in wei.
  function _getAmountSynthToken(uint256 amountPaymentToken, uint256 price)
    internal
    pure
    virtual
    returns (uint256 amountSynthToken)
  {
    return (amountPaymentToken * 1e18) / price;
  }

  /// @notice Given an executed next price shift from tokens on one market side to the other, determines how many other side tokens the shift was worth.
  /// @dev Intended for use primarily by Staker.sol
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param amountSynthTokenShifted Amount of synth token in wei.
  /// @param isShiftFromLong Whether the token shift is from long to short (true), or short to long (false).
  /// @param priceSnapshotIndex Index which identifies which synth prices to use.
  /// @return amountSynthShiftedToOtherSide The amount in wei of tokens for the other side that the shift was worth.
  function getAmountSynthTokenShifted(
    uint32 marketIndex,
    uint256 amountSynthTokenShifted,
    bool isShiftFromLong,
    uint256 priceSnapshotIndex
  ) public view virtual override returns (uint256 amountSynthShiftedToOtherSide) {
    uint256 paymentTokensToShift = _getAmountPaymentToken(
      amountSynthTokenShifted,
      syntheticTokenPriceSnapshot[marketIndex][isShiftFromLong][priceSnapshotIndex]
    );

    amountSynthShiftedToOtherSide = _getAmountSynthToken(
      paymentTokensToShift,
      syntheticTokenPriceSnapshot[marketIndex][!isShiftFromLong][priceSnapshotIndex]
    );
  }

  /*
    4 possible states for next price actions:
        - "Pending" - means the next price update hasn't happened or been enacted on by the updateSystemState function.
        - "Confirmed" - means the next price has been updated by the updateSystemState function. There is still
        -               outstanding (lazy) computation that needs to be executed per user in the batch.
        - "Settled" - there is no more computation left for the user.
        - "Non-existant" - user has no next price actions.
    This function returns a calculated value only in the case of 'confirmed' next price actions.
    It should return zero for all other types of next price actions.
    */

  /// @notice The amount of a synth token a user is owed following a batch execution.
  /// @dev Used in SyntheticToken.sol balanceOf to allow for automatic reflection of next price actions.
  /// @param user The address of the user for whom to execute the function for.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param isLong Whether it is for the long synthetic asset or the short synthetic asset.
  /// @return confirmedButNotSettledBalance The amount in wei of tokens that the user is owed.
  function getUsersConfirmedButNotSettledSynthBalance(
    address user,
    uint32 marketIndex,
    bool isLong
  )
    external
    view
    virtual
    override
    assertMarketExists(marketIndex)
    returns (uint256 confirmedButNotSettledBalance)
  {
    uint256 currentMarketUpdateIndex = marketUpdateIndex[marketIndex];
    if (
      userCurrentNextPriceUpdateIndex[marketIndex][user] != 0 &&
      userCurrentNextPriceUpdateIndex[marketIndex][user] <= currentMarketUpdateIndex
    ) {
      // Update is still nextPrice but not past the next oracle update - display the
      // amount the user would get if they executed immediately.
      uint256 amountPaymentTokenDeposited = userNextPriceDepositAmount[marketIndex][isLong][user];

      if (amountPaymentTokenDeposited > 0) {
        uint256 syntheticTokenPrice = syntheticTokenPriceSnapshot[marketIndex][isLong][
          currentMarketUpdateIndex
        ];

        confirmedButNotSettledBalance += _getAmountSynthToken(
          amountPaymentTokenDeposited,
          syntheticTokenPrice
        );
      }

      uint256 synthTokensShiftedAwayFromOtherSide = userNextPrice_amountSynthToShiftFromMarketSide[
        marketIndex
      ][!isLong][user];

      if (synthTokensShiftedAwayFromOtherSide > 0) {
        uint256 paymentTokensToShift = _getAmountPaymentToken(
          synthTokensShiftedAwayFromOtherSide,
          syntheticTokenPriceSnapshot[marketIndex][!isLong][currentMarketUpdateIndex]
        );

        confirmedButNotSettledBalance += _getAmountSynthToken(
          paymentTokensToShift,
          syntheticTokenPriceSnapshot[marketIndex][isLong][currentMarketUpdateIndex]
        );
      }

      return confirmedButNotSettledBalance;
    } else {
      return 0;
    }
  }

  /// @notice Return the minimum of the 2 parameters. If they are equal return the first parameter.
  /// @param a Any uint256
  /// @param b Any uint256
  /// @return min The minimum of the 2 parameters.
  function _getMin(uint256 a, uint256 b) internal pure virtual returns (uint256) {
    if (a > b) {
      return b;
    } else {
      return a;
    }
  }

  /// @notice Calculates the percentage in base 1e18 of how much of the accrued yield for a market should be allocated to treasury.
  /// @dev For gas considerations also returns whether the long side is imbalanced.
  /// @param longValue The current total payment token value of the long side of the market.
  /// @param shortValue The current total payment token value of the short side of the market.
  /// @param totalValueLockedInMarket Total payment token value of both sides of the market.
  /// @return isLongSideUnderbalanced Whether the long side initially had less value than the short side.
  /// @return treasuryPercentE18 The percentage in base 1e18 of how much of the accrued yield for a market should be allocated to treasury.
  function _getYieldSplit(
    uint256 longValue,
    uint256 shortValue,
    uint256 totalValueLockedInMarket
  ) internal pure virtual returns (bool isLongSideUnderbalanced, uint256 treasuryPercentE18) {
    isLongSideUnderbalanced = longValue < shortValue;
    uint256 imbalance;
    if (isLongSideUnderbalanced) {
      imbalance = shortValue - longValue;
    } else {
      imbalance = longValue - shortValue;
    }

    // This gradient/slope can be adjusted, it is in base 10^18
    uint256 marketTreasurySplitGradientE18 = 1e18;

    uint256 marketPercentCalculatedE18 = (imbalance * marketTreasurySplitGradientE18) /
      totalValueLockedInMarket;

    uint256 marketPercentE18 = _getMin(marketPercentCalculatedE18, 1e18);

    treasuryPercentE18 = 1e18 - marketPercentE18;
  }

  /*╔══════════════════════════════╗
    ║       HELPER FUNCTIONS       ║
    ╚══════════════════════════════╝*/

  /// @notice First gets yield from the yield manager and allocates it markets, then reallocates the total market value to each side. The side with less value has full exposure.
  /// @dev In one function as yield should be allocated before rebalancing. This prevents an attack whereby the user imbalances a side to capture all accrued yield.
  /// @param marketIndex The market for which to execute the function for.
  /// @param newAssetPrice The new asset price.
  /// @param oldAssetPrice The old asset price.
  /// @return longValue The value of the long side after rebalancing.
  /// @return shortValue The value of the short side after rebalancing.
  function _claimAndDistributeYieldThenRebalanceMarket(
    uint32 marketIndex,
    int256 newAssetPrice,
    int256 oldAssetPrice
  ) internal virtual returns (uint256 longValue, uint256 shortValue) {
    longValue = syntheticTokenPoolValue[marketIndex][true];
    shortValue = syntheticTokenPoolValue[marketIndex][false];
    uint256 totalValueLockedInMarket = longValue + shortValue;

    (bool isLongSideUnderbalanced, uint256 treasuryYieldPercentE18) = _getYieldSplit(
      longValue,
      shortValue,
      totalValueLockedInMarket
    );

    uint256 marketAmount = IYieldManager(yieldManagers[marketIndex]).claimYieldAndGetMarketAmount(
      totalValueLockedInMarket,
      treasuryYieldPercentE18
    );

    if (marketAmount > 0) {
      if (isLongSideUnderbalanced) {
        longValue += marketAmount;
      } else {
        shortValue += marketAmount;
      }
    }

    int256 unbalancedSidePoolValue = int256(_getMin(longValue, shortValue));

    int256 percentageChangeE18 = ((newAssetPrice - oldAssetPrice) * 1e18) / oldAssetPrice;

    int256 valueChange = (percentageChangeE18 * unbalancedSidePoolValue) / 1e18;
    // TODO: try refactor? Seems to be the same but have issues on edge cases,
    //       but removes need to multiply then divide by 1e18
    // int256 valueChangeRefactorAttempt = ((newAssetPrice - oldAssetPrice) * unbalancedSidePoolValue) /
    //   oldAssetPrice;

    if (valueChange > 0) {
      longValue += uint256(valueChange);
      shortValue -= uint256(valueChange);
    } else {
      longValue -= uint256(valueChange * -1);
      shortValue += uint256(valueChange * -1);
    }
  }

  /*╔═══════════════════════════════╗
    ║     UPDATING SYSTEM STATE     ║
    ╚═══════════════════════════════╝*/

  /// @notice Updates the value of the long and short sides to account for latest oracle price all batched next price actions.
  /// @dev To prevent front-running only executes on price change from an oracle. We assume the function will be called for each market at least once per price update.
  /// @param marketIndex The market index for which to update.
  function _updateSystemStateInternal(uint32 marketIndex)
    internal
    virtual
    assertMarketExists(marketIndex)
  {
    // If a negative int is return this should fail.
    int256 newAssetPrice = IOracleManager(oracleManagers[marketIndex]).updatePrice();
    int256 oldAssetPrice = int256(assetPrice[marketIndex]);

    bool assetPriceChanged = oldAssetPrice != newAssetPrice;

    if (assetPriceChanged || msg.sender == staker) {
      uint256 syntheticTokenPriceLong = syntheticTokenPriceSnapshot[marketIndex][true][
        marketUpdateIndex[marketIndex]
      ];
      uint256 syntheticTokenPriceShort = syntheticTokenPriceSnapshot[marketIndex][false][
        marketUpdateIndex[marketIndex]
      ];
      // if there is a price change and the 'staker' contract has pending updates, pusht the stakers price snapshot index to the staker
      // (so the staker can handle its internal accounting)
      if (userCurrentNextPriceUpdateIndex[marketIndex][staker] > 0 && assetPriceChanged) {
        IStaker(staker).addNewStateForFloatRewards(
          marketIndex,
          syntheticTokenPriceLong,
          syntheticTokenPriceShort,
          syntheticTokenPoolValue[marketIndex][true],
          syntheticTokenPoolValue[marketIndex][false],
          // This variable could allow users to do any next price actions in the future (not just synthetic side shifts)
          userCurrentNextPriceUpdateIndex[marketIndex][staker]
        );
      } else {
        IStaker(staker).addNewStateForFloatRewards(
          marketIndex,
          syntheticTokenPriceLong,
          syntheticTokenPriceShort,
          syntheticTokenPoolValue[marketIndex][true],
          syntheticTokenPoolValue[marketIndex][false],
          0
        );
      }

      if (!assetPriceChanged) {
        return;
      }

      (
        uint256 newLongPoolValue,
        uint256 newShortPoolValue
      ) = _claimAndDistributeYieldThenRebalanceMarket(marketIndex, newAssetPrice, oldAssetPrice);

      syntheticTokenPriceLong = _getSyntheticTokenPrice(
        newLongPoolValue,
        ISyntheticToken(syntheticTokens[marketIndex][true]).totalSupply()
      );
      syntheticTokenPriceShort = _getSyntheticTokenPrice(
        newShortPoolValue,
        ISyntheticToken(syntheticTokens[marketIndex][false]).totalSupply()
      );

      assetPrice[marketIndex] = uint256(newAssetPrice);
      marketUpdateIndex[marketIndex] += 1;

      syntheticTokenPriceSnapshot[marketIndex][true][
        marketUpdateIndex[marketIndex]
      ] = syntheticTokenPriceLong;

      syntheticTokenPriceSnapshot[marketIndex][false][
        marketUpdateIndex[marketIndex]
      ] = syntheticTokenPriceShort;

      (
        int256 valueChangeForLong,
        int256 valueChangeForShort
      ) = _performOustandingBatchedSettlements(
        marketIndex,
        syntheticTokenPriceLong,
        syntheticTokenPriceShort
      );

      newLongPoolValue = uint256(int256(newLongPoolValue) + valueChangeForLong);
      newShortPoolValue = uint256(int256(newShortPoolValue) + valueChangeForShort);
      syntheticTokenPoolValue[marketIndex][true] = newLongPoolValue;
      syntheticTokenPoolValue[marketIndex][false] = newShortPoolValue;

      emit SystemStateUpdated(
        marketIndex,
        marketUpdateIndex[marketIndex],
        newAssetPrice,
        newLongPoolValue,
        newShortPoolValue,
        syntheticTokenPriceLong,
        syntheticTokenPriceShort
      );
    }
  }

  /// @notice Updates the state of a market to account for the latest oracle price update.
  /// @param marketIndex An int32 which uniquely identifies a market.
  function updateSystemState(uint32 marketIndex) external override {
    _updateSystemStateInternal(marketIndex);
  }

  /// @notice Updates the state of multiples markets to account for their latest oracle price updates.
  /// @param marketIndexes An array of int32s which uniquely identify markets.
  function updateSystemStateMulti(uint32[] calldata marketIndexes) external override {
    for (uint256 i = 0; i < marketIndexes.length; i++) {
      _updateSystemStateInternal(marketIndexes[i]);
    }
  }

  /*╔════════════════════════════════╗
    ║      DEPOSIT + WITHDRAWAL      ║
    ╚════════════════════════════════╝*/

  /// @notice Transfers payment tokens for a market from msg.sender to this contract.
  /// @dev Transferred to this contract to be deposited to the yield manager on batch execution of next price actions.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param amount Amount of payment tokens in that token's lowest denominationto deposit.
  function _depositFunds(uint32 marketIndex, uint256 amount) internal virtual {
    require(IERC20(paymentTokens[marketIndex]).transferFrom(msg.sender, address(this), amount));
  }

  /// @notice Transfer payment tokens to the contract then lock them in yield manager.
  /// @dev Only used in seeding a market.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param amount Amount of payment tokens in that token's lowest denominationto deposit.
  function _lockFundsInMarket(uint32 marketIndex, uint256 amount) internal virtual {
    _depositFunds(marketIndex, amount);
    IYieldManager(yieldManagers[marketIndex]).depositPaymentToken(amount);
  }

  /*╔═══════════════════════════╗
    ║       MINT POSITION       ║
    ╚═══════════════════════════╝*/

  /// @notice Allows users to mint synthetic assets for a market. To prevent front-running these mints are executed on the next price update from the oracle.
  /// @dev Called by external functions to mint either long or short. If a user mints multiple times before a price update, these are treated as a single mint.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param amount Amount of payment tokens in that token's lowest denominationfor which to mint synthetic assets at next price.
  /// @param isLong Whether the mint is for a long or short synth.
  function _mintNextPrice(
    uint32 marketIndex,
    uint256 amount,
    bool isLong
  )
    internal
    virtual
    updateSystemStateMarket(marketIndex)
    executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
  {
    _depositFunds(marketIndex, amount);

    batchedAmountOfPaymentTokenToDeposit[marketIndex][isLong] += amount;
    userNextPriceDepositAmount[marketIndex][isLong][msg.sender] += amount;
    userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] = marketUpdateIndex[marketIndex] + 1;

    emit NextPriceDeposit(
      marketIndex,
      isLong,
      amount,
      msg.sender,
      marketUpdateIndex[marketIndex] + 1
    );
  }

  /// @notice Allows users to mint long synthetic assets for a market. To prevent front-running these mints are executed on the next price update from the oracle.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param amount Amount of payment tokens in that token's lowest denominationfor which to mint synthetic assets at next price.
  function mintLongNextPrice(uint32 marketIndex, uint256 amount) external {
    _mintNextPrice(marketIndex, amount, true);
  }

  /// @notice Allows users to mint short synthetic assets for a market. To prevent front-running these mints are executed on the next price update from the oracle.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param amount Amount of payment tokens in that token's lowest denominationfor which to mint synthetic assets at next price.
  function mintShortNextPrice(uint32 marketIndex, uint256 amount) external {
    _mintNextPrice(marketIndex, amount, false);
  }

  /*╔═══════════════════════════╗
    ║      REDEEM POSITION      ║
    ╚═══════════════════════════╝*/

  /// @notice Allows users to redeem their synthetic tokens for payment tokens. To prevent front-running these redeems are executed on the next price update from the oracle.
  /// @dev Called by external functions to redeem either long or short. Payment tokens are actually transferred to the user when executeOutstandingNextPriceSettlements is called from a function call by the user.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param tokensToRedeem Amount in wei of synth tokens to redeem.
  /// @param isLong Whether this redeem is for a long or short synth.
  function _redeemNextPrice(
    uint32 marketIndex,
    uint256 tokensToRedeem,
    bool isLong
  )
    internal
    virtual
    updateSystemStateMarket(marketIndex)
    executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
  {
    require(
      ISyntheticToken(syntheticTokens[marketIndex][isLong]).transferFrom(
        msg.sender,
        address(this),
        tokensToRedeem
      )
    );

    userNextPriceRedemptionAmount[marketIndex][isLong][msg.sender] += tokensToRedeem;
    userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] = marketUpdateIndex[marketIndex] + 1;

    batchedAmountOfSynthTokensToRedeem[marketIndex][isLong] += tokensToRedeem;

    emit NextPriceRedeem(
      marketIndex,
      isLong,
      tokensToRedeem,
      msg.sender,
      marketUpdateIndex[marketIndex] + 1
    );
  }

  /// @notice  Allows users to redeem long synthetic assets for a market. To prevent front-running these redeems are executed on the next price update from the oracle.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param tokensToRedeem Amount in wei of synth tokens to redeem at the next oracle price.
  function redeemLongNextPrice(uint32 marketIndex, uint256 tokensToRedeem) external {
    _redeemNextPrice(marketIndex, tokensToRedeem, true);
  }

  /// @notice  Allows users to redeem short synthetic assets for a market. To prevent front-running these redeems are executed on the next price update from the oracle.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param tokensToRedeem Amount in wei of synth tokens to redeem at the next oracle price.
  function redeemShortNextPrice(uint32 marketIndex, uint256 tokensToRedeem) external {
    _redeemNextPrice(marketIndex, tokensToRedeem, false);
  }

  /*╔═══════════════════════════╗
    ║       SHIFT POSITION      ║
    ╚═══════════════════════════╝*/

  /// @notice  Allows users to shift their position from one side of the market to the other in a single transaction. To prevent front-running these shifts are executed on the next price update from the oracle.
  /// @dev Called by external functions to shift either way. Intended for primary use by Staker.sol
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param synthTokensToShift Amount in wei of synthetic tokens to shift from the one side to the other at the next oracle price update.
  /// @param isShiftFromLong Whether the token shift is from long to short (true), or short to long (false).
  function _shiftPositionNextPrice(
    uint32 marketIndex,
    uint256 synthTokensToShift,
    bool isShiftFromLong
  )
    internal
    virtual
    updateSystemStateMarket(marketIndex)
    executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
  {
    require(
      ISyntheticToken(syntheticTokens[marketIndex][isShiftFromLong]).transferFrom(
        msg.sender,
        address(this),
        synthTokensToShift
      )
    );

    userNextPrice_amountSynthToShiftFromMarketSide[marketIndex][isShiftFromLong][
      msg.sender
    ] += synthTokensToShift;
    userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] = marketUpdateIndex[marketIndex] + 1;

    batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][isShiftFromLong] += synthTokensToShift;

    emit NextPriceSyntheticPositionShift(
      marketIndex,
      isShiftFromLong,
      synthTokensToShift,
      msg.sender,
      marketUpdateIndex[marketIndex] + 1
    );
  }

  /// @notice Allows users to shift their position from long to short in a single transaction. To prevent front-running these shifts are executed on the next price update from the oracle.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param synthTokensToShift Amount in wei of synthetic tokens to shift from long to short the next oracle price update.
  function shiftPositionFromLongNextPrice(uint32 marketIndex, uint256 synthTokensToShift)
    external
    override
  {
    _shiftPositionNextPrice(marketIndex, synthTokensToShift, true);
  }

  /// @notice Allows users to shift their position from short to long in a single transaction. To prevent front-running these shifts are executed on the next price update from the oracle.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param synthTokensToShift Amount in wei of synthetic tokens to shift from the short to long at the next oracle price update.
  function shiftPositionFromShortNextPrice(uint32 marketIndex, uint256 synthTokensToShift)
    external
    override
  {
    _shiftPositionNextPrice(marketIndex, synthTokensToShift, false);
  }

  /*╔════════════════════════════════╗
    ║     NEXT PRICE SETTLEMENTS     ║
    ╚════════════════════════════════╝*/

  /// @notice Transfers outstanding synth tokens from a next price mint to the user.
  /// @dev The outstanding synths should already be reflected for the user due to balanceOf in SyntheticToken.sol, this just does the accounting.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param user The address of the user for whom to execute the function for.
  /// @param isLong Whether this is for the long or short synth for the market.
  function _executeOutstandingNextPriceMints(
    uint32 marketIndex,
    address user,
    bool isLong
  ) internal virtual {
    uint256 currentDepositAmount = userNextPriceDepositAmount[marketIndex][isLong][user];
    if (currentDepositAmount > 0) {
      userNextPriceDepositAmount[marketIndex][isLong][user] = 0;
      uint256 tokensToTransferToUser = _getAmountSynthToken(
        currentDepositAmount,
        syntheticTokenPriceSnapshot[marketIndex][isLong][
          userCurrentNextPriceUpdateIndex[marketIndex][user]
        ]
      );
      require(
        ISyntheticToken(syntheticTokens[marketIndex][isLong]).transfer(user, tokensToTransferToUser)
      );

      emit ExecuteNextPriceMintSettlementUser(user, marketIndex, isLong, tokensToTransferToUser);
    }
  }

  /// @notice Transfers outstanding payment tokens from a next price redemption to the user.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param user The address of the user for whom to execute the function for.
  /// @param isLong Whether this is for the long or short synth for the market.
  function _executeOutstandingNextPriceRedeems(
    uint32 marketIndex,
    address user,
    bool isLong
  ) internal virtual {
    uint256 currentRedemptions = userNextPriceRedemptionAmount[marketIndex][isLong][user];
    if (currentRedemptions > 0) {
      userNextPriceRedemptionAmount[marketIndex][isLong][user] = 0;
      uint256 amountToRedeem = _getAmountPaymentToken(
        currentRedemptions,
        syntheticTokenPriceSnapshot[marketIndex][isLong][
          userCurrentNextPriceUpdateIndex[marketIndex][user]
        ]
      );
      // This means all erc20 tokens we use as payment tokens must return a boolean
      require(IERC20(paymentTokens[marketIndex]).transfer(user, amountToRedeem));

      emit ExecuteNextPriceRedeemSettlementUser(user, marketIndex, isLong, amountToRedeem);
    }
  }

  /// @notice Transfers outstanding synth tokens from a next price position shift to the user.
  /// @dev The outstanding synths should already be reflected for the user due to balanceOf in SyntheticToken.sol, this just does the accounting.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param user The address of the user for whom to execute the function for.
  /// @param isShiftFromLong Whether the token shift was from long to short (true), or short to long (false).
  function _executeOutstandingNextPriceTokenShifts(
    uint32 marketIndex,
    address user,
    bool isShiftFromLong
  ) internal virtual {
    uint256 synthTokensShiftedAwayFromMarketSide = userNextPrice_amountSynthToShiftFromMarketSide[
      marketIndex
    ][isShiftFromLong][user];
    if (synthTokensShiftedAwayFromMarketSide > 0) {
      uint256 amountSynthTokenRecievedOnOtherSide = getAmountSynthTokenShifted(
        marketIndex,
        synthTokensShiftedAwayFromMarketSide,
        isShiftFromLong,
        userCurrentNextPriceUpdateIndex[marketIndex][user]
      );

      userNextPrice_amountSynthToShiftFromMarketSide[marketIndex][isShiftFromLong][user] = 0;

      require(
        ISyntheticToken(syntheticTokens[marketIndex][!isShiftFromLong]).transfer(
          user,
          amountSynthTokenRecievedOnOtherSide
        )
      );

      emit ExecuteNextPriceMarketSideShiftSettlementUser(
        user,
        marketIndex,
        isShiftFromLong,
        amountSynthTokenRecievedOnOtherSide
      );
    }
  }

  /// @notice After markets have been batched updated on a new oracle price, transfers any owed tokens to a user from their next price actions for that update to that user.
  /// @dev Once the market has updated for the next price, should be guaranteed (through modifiers) to execute for a user before user initiation of new next price actions.
  /// @param user The address of the user for whom to execute the function for.
  /// @param marketIndex An int32 which uniquely identifies a market.
  function _executeOutstandingNextPriceSettlements(address user, uint32 marketIndex)
    internal
    virtual
  {
    uint256 userCurrentUpdateIndex = userCurrentNextPriceUpdateIndex[marketIndex][user];
    if (userCurrentUpdateIndex != 0 && userCurrentUpdateIndex <= marketUpdateIndex[marketIndex]) {
      _executeOutstandingNextPriceMints(marketIndex, user, true);
      _executeOutstandingNextPriceMints(marketIndex, user, false);
      _executeOutstandingNextPriceRedeems(marketIndex, user, true);
      _executeOutstandingNextPriceRedeems(marketIndex, user, false);
      _executeOutstandingNextPriceTokenShifts(marketIndex, user, true);
      _executeOutstandingNextPriceTokenShifts(marketIndex, user, false);

      userCurrentNextPriceUpdateIndex[marketIndex][user] = 0;

      emit ExecuteNextPriceSettlementsUser(user, marketIndex);
    }
  }

  /// @notice After markets have been batched updated on a new oracle price, transfers any owed tokens to a user from their next price actions for that update to that user.
  /// @param user The address of the user for whom to execute the function for.
  /// @param marketIndex An int32 which uniquely identifies a market.
  function executeOutstandingNextPriceSettlementsUser(address user, uint32 marketIndex)
    external
    override
  {
    _executeOutstandingNextPriceSettlements(user, marketIndex);
  }

  /// @notice Executes outstanding next price settlements for a user for multiple markets.
  /// @param user The address of the user for whom to execute the function for.
  /// @param marketIndexes An array of int32s which each uniquely identify a market.
  function executeOutstandingNextPriceSettlementsUserMulti(
    address user,
    uint32[] memory marketIndexes
  ) external {
    for (uint256 i = 0; i < marketIndexes.length; i++) {
      _executeOutstandingNextPriceSettlements(user, marketIndexes[i]);
    }
  }

  /*╔═══════════════════════════════════════════╗
    ║   BATCHED NEXT PRICE SETTLEMENT ACTIONS   ║
    ╚═══════════════════════════════════════════╝*/

  /// @notice Either transfers funds to the yield manager, or deposits them, based on whether market value has increased or decreased.
  /// @dev When all batched next price actions are handled the total value in the market can either increase or decrease based on the value of mints and redeems.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param totalValueChangeForMarket An int256 which indicates the magnitude and direction of the change in market value.
  function _handleTotalValueChangeForMarketWithYieldManager(
    uint32 marketIndex,
    int256 totalValueChangeForMarket
  ) internal virtual {
    if (totalValueChangeForMarket > 0) {
      IYieldManager(yieldManagers[marketIndex]).depositPaymentToken(
        uint256(totalValueChangeForMarket)
      );
    } else if (totalValueChangeForMarket < 0) {
      // NB there will be issues here if not enough liquidity exists to withdraw
      // Boolean should be returned from yield manager and think how to appropriately handle this
      IYieldManager(yieldManagers[marketIndex]).withdrawPaymentToken(
        uint256(-totalValueChangeForMarket)
      );
    }
  }

  /// @notice Given a desired change in synth token supply, either mints or burns tokens to achieve that desired change.
  /// @dev When all batched next price actions are executed total supply for a synth can either increase or decrease.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param isLong Whether this function should execute for the long or short synth for the market.
  /// @param changeInSynthTokensTotalSupply The amount in wei by which synth token supply should change.
  function _handleChangeInSynthTokensTotalSupply(
    uint32 marketIndex,
    bool isLong,
    int256 changeInSynthTokensTotalSupply
  ) internal virtual {
    if (changeInSynthTokensTotalSupply > 0) {
      ISyntheticToken(syntheticTokens[marketIndex][isLong]).mint(
        address(this),
        uint256(changeInSynthTokensTotalSupply)
      );
    } else if (changeInSynthTokensTotalSupply < 0) {
      ISyntheticToken(syntheticTokens[marketIndex][isLong]).burn(
        uint256(-changeInSynthTokensTotalSupply)
      );
    }
  }

  // QUESTION: is the word "Settlements" confusing, since after this function the users are only
  //           "confirmed" not "settled"

  /// @notice Performs all batched next price actions on an oracle price update.
  /// @dev Mints or burns all synthetic tokens for this contract. Users are transferred their owed tokens when _executeOutstandingNexPriceSettlements is called for that user.
  /// @param marketIndex An int32 which uniquely identifies a market.
  /// @param syntheticTokenPriceLong The long synthetic token price for this oracle price update.
  /// @param syntheticTokenPriceShort The short synthetic token price for this oracle price update.
  /// @return valueChangeForLong The total value change for the long side after all batched actions are executed.
  /// @return valueChangeForShort The total value change for the short side after all batched actions are executed.
  function _performOustandingBatchedSettlements(
    uint32 marketIndex,
    uint256 syntheticTokenPriceLong,
    uint256 syntheticTokenPriceShort
  ) internal virtual returns (int256 valueChangeForLong, int256 valueChangeForShort) {
    int256 longChangeInSynthTokensTotalSupply;
    int256 shortChangeInSynthTokensTotalSupply;

    // NOTE: These variables currently only includes the amount to deposit
    //       to save variable space (precious EVM stack) we share and update the same variable later to include the shift.


      uint256 batchedAmountOfPaymentTokensToDepositOrShiftToLong
     = batchedAmountOfPaymentTokenToDeposit[marketIndex][true];


      uint256 batchedAmountOfPaymentTokensToDepositOrShiftToShort
     = batchedAmountOfPaymentTokenToDeposit[marketIndex][false];

    // NOTE: These variables currently only includes the amount to shift
    //       to save variable space (precious EVM stack) we share and update the same variable later to include the reedem.


      uint256 batchedAmountOfSynthTokensToRedeemOrShiftFromLong
     = batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][true];


      uint256 batchedAmountOfSynthTokensToRedeemOrShiftFromShort
     = batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][false];

    // Handle shift tokens from LONG to SHORT
    if (batchedAmountOfSynthTokensToRedeemOrShiftFromLong > 0) {
      batchedAmountOfPaymentTokensToDepositOrShiftToShort += _getAmountPaymentToken(
        batchedAmountOfSynthTokensToRedeemOrShiftFromLong,
        syntheticTokenPriceLong
      );

      batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][true] = 0;
    }

    // Handle shift tokens from SHORT to LONG
    if (batchedAmountOfSynthTokensToRedeemOrShiftFromShort > 0) {
      batchedAmountOfPaymentTokensToDepositOrShiftToLong += _getAmountPaymentToken(
        batchedAmountOfSynthTokensToRedeemOrShiftFromShort,
        syntheticTokenPriceShort
      );

      batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][false] = 0;
    }

    // Handle batched deposits LONG
    if (batchedAmountOfPaymentTokensToDepositOrShiftToLong > 0) {
      valueChangeForLong += int256(batchedAmountOfPaymentTokensToDepositOrShiftToLong);

      batchedAmountOfPaymentTokenToDeposit[marketIndex][true] = 0;

      longChangeInSynthTokensTotalSupply += int256(
        _getAmountSynthToken(
          batchedAmountOfPaymentTokensToDepositOrShiftToLong,
          syntheticTokenPriceLong
        )
      );
    }

    // Handle batched deposits SHORT
    if (batchedAmountOfPaymentTokensToDepositOrShiftToShort > 0) {
      valueChangeForShort += int256(batchedAmountOfPaymentTokensToDepositOrShiftToShort);

      batchedAmountOfPaymentTokenToDeposit[marketIndex][false] = 0;

      shortChangeInSynthTokensTotalSupply += int256(
        _getAmountSynthToken(
          batchedAmountOfPaymentTokensToDepositOrShiftToShort,
          syntheticTokenPriceShort
        )
      );
    }

    // Handle batched redeems LONG
    batchedAmountOfSynthTokensToRedeemOrShiftFromLong += batchedAmountOfSynthTokensToRedeem[
      marketIndex
    ][true];
    if (batchedAmountOfSynthTokensToRedeemOrShiftFromLong > 0) {
      valueChangeForLong -= int256(
        _getAmountPaymentToken(
          batchedAmountOfSynthTokensToRedeemOrShiftFromLong,
          syntheticTokenPriceLong
        )
      );
      longChangeInSynthTokensTotalSupply -= int256(
        batchedAmountOfSynthTokensToRedeemOrShiftFromLong
      );

      batchedAmountOfSynthTokensToRedeem[marketIndex][true] = 0;
    }

    // Handle batched redeems SHORT
    batchedAmountOfSynthTokensToRedeemOrShiftFromShort += batchedAmountOfSynthTokensToRedeem[
      marketIndex
    ][false];
    if (batchedAmountOfSynthTokensToRedeemOrShiftFromShort > 0) {
      valueChangeForShort -= int256(
        _getAmountPaymentToken(
          batchedAmountOfSynthTokensToRedeemOrShiftFromShort,
          syntheticTokenPriceShort
        )
      );
      shortChangeInSynthTokensTotalSupply -= int256(
        batchedAmountOfSynthTokensToRedeemOrShiftFromShort
      );

      batchedAmountOfSynthTokensToRedeem[marketIndex][false] = 0;
    }

    int256 totalValueChangeForMarket = valueChangeForLong + valueChangeForShort;
    _handleTotalValueChangeForMarketWithYieldManager(marketIndex, totalValueChangeForMarket);

    _handleChangeInSynthTokensTotalSupply(marketIndex, true, longChangeInSynthTokensTotalSupply);
    _handleChangeInSynthTokensTotalSupply(marketIndex, false, shortChangeInSynthTokensTotalSupply);
  }
}
