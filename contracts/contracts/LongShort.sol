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

  mapping(uint32 => mapping(bool => uint256)) public batchedAmountOfTokensToDeposit;
  mapping(uint32 => mapping(bool => uint256)) public batchedAmountOfSynthTokensToRedeem;
  mapping(uint32 => mapping(bool => uint256)) public batchedAmountOfSynthTokensToShiftMarketSide;

  // User specific
  mapping(uint32 => mapping(address => uint256)) public userCurrentNextPriceUpdateIndex;

  mapping(uint32 => mapping(bool => mapping(address => uint256))) public userNextPriceDepositAmount;
  mapping(uint32 => mapping(bool => mapping(address => uint256)))
    public userNextPriceRedemptionAmount;
  mapping(uint32 => mapping(bool => mapping(address => uint256)))
    public userNextPriceShiftMarketSideAmount;

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
    bool shiftingFromLong,
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

  event ExecuteNextPriceSettlementsUser(address user, uint32 marketIndex);

  /*╔═════════════════════════════╗
    ║          MODIFIERS          ║
    ╚═════════════════════════════╝*/

  /**
   * Necessary to update system state before any contract actions (deposits / withdraws)
   */

  modifier adminOnly() virtual {
    require(msg.sender == admin, "only admin");
    _;
  }

  modifier assertMarketExists(uint32 marketIndex) virtual {
    require(marketExists[marketIndex], "market doesn't exist");
    _;
  }

  modifier executeOutstandingNextPriceSettlements(address user, uint32 marketIndex) virtual {
    _executeOutstandingNextPriceSettlements(user, marketIndex);
    _;
  }

  modifier updateSystemStateMarket(uint32 marketIndex) virtual {
    _updateSystemStateInternal(marketIndex);

    _;
  }

  /*╔═════════════════════════════╗
    ║       CONTRACT SET-UP       ║
    ╚═════════════════════════════╝*/

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

  function changeAdmin(address _admin) external adminOnly {
    admin = _admin;
  }

  function changeTreasury(address _treasury) external adminOnly {
    treasury = _treasury;
  }

  /**
   * Update oracle for a market
   */
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

  function _getSyntheticTokenPrice(uint256 amountPaymentToken, uint256 amountSynthToken)
    internal
    pure
    virtual
    returns (uint256 syntheticTokenPrice)
  {
    return (amountPaymentToken * 1e18) / amountSynthToken;
  }

  function _getAmountPaymentToken(uint256 amountSynthToken, uint256 price)
    internal
    pure
    virtual
    returns (uint256 amountPaymentToken)
  {
    return (amountSynthToken * price) / 1e18;
  }

  function _getAmountSynthToken(uint256 amountPaymentToken, uint256 price)
    internal
    pure
    virtual
    returns (uint256 amountSynthToken)
  {
    return (amountPaymentToken * 1e18) / price;
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
  function getUsersConfirmedButNotSettledBalance(
    address user,
    uint32 marketIndex,
    bool isLong
  )
    external
    view
    virtual
    override
    assertMarketExists(marketIndex)
    returns (uint256 pendingBalance)
  {
    if (
      userCurrentNextPriceUpdateIndex[marketIndex][user] != 0 &&
      userCurrentNextPriceUpdateIndex[marketIndex][user] <= marketUpdateIndex[marketIndex]
    ) {
      // Update is still nextPrice but not past the next oracle update - display the
      // amount the user would get if they executed immediately.
      uint256 amountPaymentTokenDeposited = userNextPriceDepositAmount[marketIndex][isLong][user];

      uint256 syntheticTokenPrice = syntheticTokenPriceSnapshot[marketIndex][isLong][
        marketUpdateIndex[marketIndex]
      ];

      uint256 tokens = _getAmountSynthToken(amountPaymentTokenDeposited, syntheticTokenPrice);

      return tokens;
    } else {
      return 0;
    }
  }

  /**
   * Return the minimum of the 2 parameters. If they are equal return the first parameter.
   */
  function _getMin(uint256 a, uint256 b) internal pure virtual returns (uint256) {
    if (a > b) {
      return b;
    } else {
      return a;
    }
  }

  /**
   * Returns the amount of accrued value that should go to each side of the
   * market. To incentivise balance, more value goes to the weaker side in
   * proportion to how imbalanced the market is.
   */
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

  /**
   * Controls what happens with accrued yield manager interest.
   */
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

  /**
   * Updates the value of the long and short sides within the system.
   */
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
      IStaker(staker).addNewStateForFloatRewards(
        marketIndex,
        syntheticTokenPriceLong,
        syntheticTokenPriceShort,
        syntheticTokenPoolValue[marketIndex][true],
        syntheticTokenPoolValue[marketIndex][false]
      );

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

  function updateSystemState(uint32 marketIndex) external override {
    _updateSystemStateInternal(marketIndex);
  }

  function updateSystemStateMulti(uint32[] calldata marketIndexes) external override {
    for (uint256 i = 0; i < marketIndexes.length; i++) {
      _updateSystemStateInternal(marketIndexes[i]);
    }
  }

  /*╔════════════════════════════════╗
    ║      DEPOSIT + WITHDRAWAL      ║
    ╚════════════════════════════════╝*/

  function _depositFunds(uint32 marketIndex, uint256 amount) internal virtual {
    require(IERC20(paymentTokens[marketIndex]).transferFrom(msg.sender, address(this), amount));
  }

  // NOTE: Only used in seeding the market.
  function _lockFundsInMarket(uint32 marketIndex, uint256 amount) internal virtual {
    _depositFunds(marketIndex, amount);
    IYieldManager(yieldManagers[marketIndex]).depositPaymentToken(amount);
  }

  /*╔═══════════════════════════╗
    ║       MINT POSITION       ║
    ╚═══════════════════════════╝*/

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

    batchedAmountOfTokensToDeposit[marketIndex][isLong] += amount;
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

  function mintLongNextPrice(uint32 marketIndex, uint256 amount) external {
    _mintNextPrice(marketIndex, amount, true);
  }

  function mintShortNextPrice(uint32 marketIndex, uint256 amount) external {
    _mintNextPrice(marketIndex, amount, false);
  }

  /*╔═══════════════════════════╗
    ║      REDEEM POSITION      ║
    ╚═══════════════════════════╝*/

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

  function redeemLongNextPrice(uint32 marketIndex, uint256 tokensToRedeem) external {
    _redeemNextPrice(marketIndex, tokensToRedeem, true);
  }

  function redeemShortNextPrice(uint32 marketIndex, uint256 tokensToRedeem) external {
    _redeemNextPrice(marketIndex, tokensToRedeem, false);
  }

  /*╔═══════════════════════════╗
    ║       SHIFT POSITION      ║
    ╚═══════════════════════════╝*/

  function _shiftPositionNextPrice(
    uint32 marketIndex,
    uint256 synthTokensToShift,
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
        synthTokensToShift
      )
    );

    userNextPriceShiftMarketSideAmount[marketIndex][isLong][msg.sender] += synthTokensToShift;
    userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] = marketUpdateIndex[marketIndex] + 1;

    batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][isLong] += synthTokensToShift;

    emit NextPriceRedeem(
      marketIndex,
      isLong,
      synthTokensToShift,
      msg.sender,
      marketUpdateIndex[marketIndex] + 1
    );
  }

  function shiftPositionFromLongNextPrice(uint32 marketIndex, uint256 synthTokensToShift) external {
    _shiftPositionNextPrice(marketIndex, synthTokensToShift, true);
  }

  function shiftPositionFromShortNextPrice(uint32 marketIndex, uint256 synthTokensToShift)
    external
  {
    _shiftPositionNextPrice(marketIndex, synthTokensToShift, false);
  }

  /*╔════════════════════════════════╗
    ║     NEXT PRICE SETTLEMENTS     ║
    ╚════════════════════════════════╝*/

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

      userCurrentNextPriceUpdateIndex[marketIndex][user] = 0;

      emit ExecuteNextPriceSettlementsUser(user, marketIndex);
    }
  }

  function executeOutstandingNextPriceSettlementsUser(address user, uint32 marketIndex)
    external
    override
  {
    _executeOutstandingNextPriceSettlements(user, marketIndex);
  }

  /*╔═══════════════════════════════════════════╗
    ║   BATCHED NEXT PRICE SETTLEMENT ACTIONS   ║
    ╚═══════════════════════════════════════════╝*/

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
  function _performOustandingBatchedSettlements(
    uint32 marketIndex,
    uint256 syntheticTokenPriceLong,
    uint256 syntheticTokenPriceShort
  ) internal virtual returns (int256 valueChangeForLong, int256 valueChangeForShort) {
    int256 longChangeInSynthTokensTotalSupply;
    int256 shortChangeInSynthTokensTotalSupply;

    // NOTE: These variables currently only includes the amount to deposit
    //       to save variable space (precious EVM stack) we share and update the same variable later to include the shift.
    uint256 batchedAmountOfTokensToDepositOrShiftedLong = batchedAmountOfTokensToDeposit[
      marketIndex
    ][true];
    uint256 batchedAmountOfTokensToDepositOrShiftedShort = batchedAmountOfTokensToDeposit[
      marketIndex
    ][false];

    // NOTE: These variables currently only includes the amount to shift
    //       to save variable space (precious EVM stack) we share and update the same variable later to include the reedem.


      uint256 batchedAmountOfSynthTokensToRedeemOrShiftFromLong
     = batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][true];


      uint256 batchedAmountOfSynthTokensToRedeemOrShiftFromShort
     = batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][false];

    // Handle shift tokens from LONG to SHORT
    if (batchedAmountOfSynthTokensToRedeemOrShiftFromLong > 0) {
      batchedAmountOfTokensToDepositOrShiftedShort += _getAmountPaymentToken(
        batchedAmountOfSynthTokensToRedeemOrShiftFromLong,
        syntheticTokenPriceLong
      );

      batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][true] = 0;
    }

    // Handle shift tokens from SHORT to LONG
    if (batchedAmountOfSynthTokensToRedeemOrShiftFromShort > 0) {
      batchedAmountOfTokensToDepositOrShiftedLong += _getAmountPaymentToken(
        batchedAmountOfSynthTokensToRedeemOrShiftFromShort,
        syntheticTokenPriceShort
      );

      batchedAmountOfSynthTokensToShiftMarketSide[marketIndex][false] = 0;
    }

    // Handle batched deposits LONG
    if (batchedAmountOfTokensToDepositOrShiftedLong > 0) {
      valueChangeForLong += int256(batchedAmountOfTokensToDepositOrShiftedLong);

      batchedAmountOfTokensToDeposit[marketIndex][true] = 0;

      longChangeInSynthTokensTotalSupply += int256(
        _getAmountSynthToken(batchedAmountOfTokensToDepositOrShiftedLong, syntheticTokenPriceLong)
      );
    }

    // Handle batched deposits SHORT
    if (batchedAmountOfTokensToDepositOrShiftedShort > 0) {
      valueChangeForShort += int256(batchedAmountOfTokensToDepositOrShiftedShort);

      batchedAmountOfTokensToDeposit[marketIndex][false] = 0;

      shortChangeInSynthTokensTotalSupply += int256(
        _getAmountSynthToken(batchedAmountOfTokensToDepositOrShiftedShort, syntheticTokenPriceShort)
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
