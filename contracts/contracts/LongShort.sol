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

contract LongShort is ILongShort, Initializable {
    /*╔═════════════════════════════╗
      ║          VARIABLES          ║
      ╚═════════════════════════════╝*/

    // Fixed-precision constants
    address public constant DEAD_ADDRESS =
        0xf10A7_F10A7_f10A7_F10a7_F10A7_f10a7_F10A7_f10a7;
    uint256 public constant TEN_TO_THE_18 = 1e18;
    int256 public constant TEN_TO_THE_18_SIGNED = 1e18;
    uint256[45] private __constantsGap;

    // Global state
    address public admin;
    address public treasury;
    uint32 public latestMarket;

    IStaker public staker;
    ITokenFactory public tokenFactory;
    uint256[45] private __globalStateGap;

    // Market specific
    mapping(uint32 => bool) public marketExists;
    mapping(uint32 => uint256) public assetPrice;
    mapping(uint32 => uint256) public marketUpdateIndex;
    mapping(uint32 => IERC20) public paymentTokens;
    mapping(uint32 => IYieldManager) public yieldManagers;
    mapping(uint32 => IOracleManager) public oracleManagers;

    // Market + position (long/short) specific
    mapping(uint32 => mapping(bool => ISyntheticToken)) public syntheticTokens;
    mapping(uint32 => mapping(bool => uint256)) public syntheticTokenPoolValue;

    mapping(uint32 => mapping(bool => mapping(uint256 => uint256)))
        public syntheticTokenPriceSnapshot;

    mapping(uint32 => mapping(bool => uint256))
        public batchedAmountOfTokensToDeposit;
    mapping(uint32 => mapping(bool => uint256))
        public batchedAmountOfSynthTokensToRedeem;

    // User specific
    mapping(uint32 => mapping(address => uint256))
        public userCurrentNextPriceUpdateIndex;

    mapping(uint32 => mapping(bool => mapping(address => uint256)))
        public userNextPriceDepositAmount;
    mapping(uint32 => mapping(bool => mapping(address => uint256)))
        public userNextPriceRedemptionAmount;

    /*╔════════════════════════════╗
      ║           EVENTS           ║
      ╚════════════════════════════╝*/

    event LongShortV1(
        address admin,
        address treasury,
        address tokenFactory,
        address staker
    );

    // TODO: make sure this is emmited for batched actions too!
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
        uint256 assetPrice,
        string name,
        string symbol,
        address oracleAddress
    );

    event PriceUpdate(
        uint32 marketIndex,
        uint256 oldPrice,
        uint256 newPrice,
        address user
    );

    event NextPriceRedeem(
        uint32 marketIndex,
        bool isLong,
        uint256 synthRedeemed,
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

    event OracleUpdated(
        uint32 marketIndex,
        address oldOracleAddress,
        address newOracleAddress
    );

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

    modifier adminOnly() {
        require(msg.sender == admin, "only admin");
        _;
    }

    modifier assertMarketExists(uint32 marketIndex) {
        require(marketExists[marketIndex], "market doesn't exist");
        _;
    }

    modifier executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex
    ) virtual {
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

    function initialize(
        address _admin,
        address _treasury,
        ITokenFactory _tokenFactory,
        IStaker _staker
    ) public initializer {
        admin = _admin;
        treasury = _treasury;
        tokenFactory = _tokenFactory;
        staker = _staker;

        emit LongShortV1(
            _admin,
            address(treasury),
            address(_tokenFactory),
            address(_staker)
        );
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
    function updateMarketOracle(uint32 marketIndex, address _newOracleManager)
        external
        adminOnly
    {
        // If not a oracle contract this would break things.. Test's arn't validating this
        // Ie require isOracle interface - ERC165
        address previousOracleManager = address(oracleManagers[marketIndex]);
        oracleManagers[marketIndex] = IOracleManager(_newOracleManager);
        emit OracleUpdated(
            marketIndex,
            previousOracleManager,
            _newOracleManager
        );
    }

    /*╔═════════════════════════════╗
      ║       MARKET CREATION       ║
      ╚═════════════════════════════╝*/

    /**
     * Creates an entirely new long/short market tracking an underlying
     * oracle price. Make sure the synthetic names/symbols are unique.
     */
    function newSyntheticMarket(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address _paymentToken,
        address _oracleManager,
        address _yieldManager
    ) external adminOnly {
        latestMarket++;

        // Create new synthetic long token.
        syntheticTokens[latestMarket][true] = ISyntheticToken(
            tokenFactory.createTokenLong(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

        // Create new synthetic short token.
        syntheticTokens[latestMarket][false] = ISyntheticToken(
            tokenFactory.createTokenShort(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

        // Initial market state.
        paymentTokens[latestMarket] = IERC20(_paymentToken);
        yieldManagers[latestMarket] = IYieldManager(_yieldManager);
        oracleManagers[latestMarket] = IOracleManager(_oracleManager);
        assetPrice[latestMarket] = uint256(
            oracleManagers[latestMarket].updatePrice()
        );

        // Approve tokens for aave lending pool maximally.
        paymentTokens[latestMarket].approve(_yieldManager, type(uint256).max);

        emit SyntheticTokenCreated(
            latestMarket,
            address(syntheticTokens[latestMarket][true]),
            address(syntheticTokens[latestMarket][false]),
            _paymentToken,
            assetPrice[latestMarket],
            syntheticName,
            syntheticSymbol,
            _oracleManager
        );
    }

    function _seedMarketInitially(uint256 initialMarketSeed, uint32 marketIndex)
        internal
    {
        require(
            // You require at least 10^17 of the underlying payment token to seed the market.
            initialMarketSeed > 0.1 ether,
            "Insufficient market seed"
        );

        _lockFundsInMarket(marketIndex, initialMarketSeed * 2);

        syntheticTokens[latestMarket][true].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );
        syntheticTokens[latestMarket][false].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );

        syntheticTokenPoolValue[marketIndex][true] = initialMarketSeed;
        syntheticTokenPoolValue[marketIndex][false] = initialMarketSeed;

        emit NewMarketLaunchedAndSeeded(marketIndex, initialMarketSeed);
    }

    function initializeMarket(
        uint32 marketIndex,
        uint256 kInitialMultiplier,
        uint256 kPeriod,
        uint256 unstakeFeeBasisPoints,
        uint256 initialMarketSeed
    ) external adminOnly {
        require(!marketExists[marketIndex], "already initialized");
        require(marketIndex <= latestMarket, "index too high");

        marketExists[marketIndex] = true;

        // Add new staker funds with fresh synthetic tokens.
        staker.addNewStakingFund(
            latestMarket,
            syntheticTokens[latestMarket][true],
            syntheticTokens[latestMarket][false],
            kInitialMultiplier,
            kPeriod,
            unstakeFeeBasisPoints
        );

        _seedMarketInitially(initialMarketSeed, marketIndex);
    }

    /*╔══════════════════════════════╗
      ║       GETTER FUNCTIONS       ║
      ╚══════════════════════════════╝*/

    function _recalculateSyntheticTokenPrice(uint32 marketIndex, bool isLong)
        internal
        view
        returns (uint256 syntheticTokenPrice)
    {
        syntheticTokenPrice =
            (syntheticTokenPoolValue[marketIndex][isLong] * TEN_TO_THE_18) /
            syntheticTokens[marketIndex][isLong].totalSupply();
    }

    function _getAmountPaymentToken(uint256 amountSynth, uint256 price)
        internal
        pure
        returns (uint256)
    {
        return (amountSynth * price) / TEN_TO_THE_18;
    }

    function _getAmountSynthToken(uint256 amountPaymentToken, uint256 price)
        internal
        pure
        returns (uint256)
    {
        return (amountPaymentToken * TEN_TO_THE_18) / price;
    }

    /*
    4 possible states for next price actions:
        - "Pending" - means the next price update hasn't happened or been enacted on by the updateSystemState function.
        - "Confirmed" - means the next price has been updated by the updateSystemState function. There is still outstanding (lazy) computation that needs to be executed per user in the batch.
        - "Settled" - there is no more computation left for the user.
        - "Non-existant" - user has no next price actions.
    This function returns a calculated value only in the case of 'confirmed' next price actions. It should return zero for all other types of next price actions.
    */
    function getUsersConfirmedButNotSettledBalance(
        address user,
        uint32 marketIndex,
        bool isLong
    )
        external
        view
        override
        assertMarketExists(marketIndex)
        returns (uint256 pendingBalance)
    {
        if (
            userCurrentNextPriceUpdateIndex[marketIndex][user] != 0 &&
            userCurrentNextPriceUpdateIndex[marketIndex][user] <=
            marketUpdateIndex[marketIndex]
        ) {
            // Update is still nextPrice but not past the next oracle update - display the amount the user would get if they executed immediately
            uint256 amountPaymentTokenDeposited = userNextPriceDepositAmount[
                marketIndex
            ][isLong][user];

            uint256 syntheticTokenPrice = syntheticTokenPriceSnapshot[
                marketIndex
            ][isLong][marketUpdateIndex[marketIndex]];

            uint256 tokens = _getAmountSynthToken(
                amountPaymentTokenDeposited,
                syntheticTokenPrice
            );

            return tokens;
        } else {
            return 0;
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
    )
        internal
        view
        returns (bool underBalancedSide, uint256 treasuryPercentE18)
    {
        underBalancedSide = longValue < shortValue;
        uint256 imbalance;
        if (underBalancedSide) {
            imbalance = longValue - shortValue;
        } else {
            imbalance = shortValue - longValue;
        }
        // This is a stupid linear line... How to make this a better curve?
        uint256 marketPercentE18 = ((imbalance * TEN_TO_THE_18) /
            totalValueLockedInMarket);
        treasuryPercentE18 = TEN_TO_THE_18 - marketPercentE18;
    }

    /*╔══════════════════════════════╗
      ║       HELPER FUNCTIONS       ║
      ╚══════════════════════════════╝*/

    /**
     * Controls what happens with accrued yield manager interest.
     */
    function _claimAndDistributeYield(uint32 marketIndex) internal {
        uint256 longValue = syntheticTokenPoolValue[marketIndex][true];
        uint256 shortValue = syntheticTokenPoolValue[marketIndex][false];
        uint256 totalValueLockedInMarket = longValue + shortValue;

        (
            bool underBalancedSide,
            uint256 treasuryYieldPercentE18
        ) = _getYieldSplit(longValue, shortValue, totalValueLockedInMarket);

        uint256 marketAmount = yieldManagers[marketIndex]
        .claimYieldAndGetMarketAmount(
            totalValueLockedInMarket,
            treasuryYieldPercentE18
        );

        if (marketAmount > 0) {
            syntheticTokenPoolValue[marketIndex][
                underBalancedSide
            ] += marketAmount;
        }
    }

    function _adjustMarketBasedOnNewAssetPrice(
        uint32 marketIndex,
        int256 newAssetPrice
    ) internal {
        int256 oldAssetPrice = int256(assetPrice[marketIndex]);

        uint256 min;
        if (
            syntheticTokenPoolValue[marketIndex][true] <
            syntheticTokenPoolValue[marketIndex][false]
        ) {
            min = syntheticTokenPoolValue[marketIndex][true];
        } else {
            min = syntheticTokenPoolValue[marketIndex][false];
        }

        int256 percentageChangeE18 = ((newAssetPrice - oldAssetPrice) *
            TEN_TO_THE_18_SIGNED) / oldAssetPrice;

        int256 valueChange = (percentageChangeE18 * int256(min)) /
            TEN_TO_THE_18_SIGNED;

        if (valueChange > 0) {
            syntheticTokenPoolValue[marketIndex][true] += uint256(valueChange);
            syntheticTokenPoolValue[marketIndex][false] -= uint256(valueChange);
        } else {
            syntheticTokenPoolValue[marketIndex][true] -= uint256(
                valueChange * -1
            );
            syntheticTokenPoolValue[marketIndex][false] += uint256(
                valueChange * -1
            );
        }

        emit PriceUpdate(
            marketIndex,
            assetPrice[marketIndex],
            uint256(newAssetPrice),
            msg.sender
        );
    }

    function _saveSyntheticTokenPriceSnapshots(
        uint32 marketIndex,
        uint256 newLatestPriceStateIndex,
        uint256 syntheticTokenPriceLong,
        uint256 syntheticTokenPriceShort
    ) internal {
        syntheticTokenPriceSnapshot[marketIndex][true][
            newLatestPriceStateIndex
        ] = syntheticTokenPriceLong;

        syntheticTokenPriceSnapshot[marketIndex][false][
            newLatestPriceStateIndex
        ] = syntheticTokenPriceShort;
    }

    /*╔═══════════════════════════════╗
      ║     UPDATING SYSTEM STATE     ║
      ╚═══════════════════════════════╝*/

    /**
     * Updates the value of the long and short sides within the system.
     */
    function _updateSystemStateInternal(uint32 marketIndex)
        internal
        assertMarketExists(marketIndex)
    {
        // If a negative int is return this should fail.
        int256 newAssetPrice = oracleManagers[marketIndex].updatePrice();
        int256 oldAssetPrice = int256(assetPrice[marketIndex]);

        bool assetPriceChanged = oldAssetPrice != newAssetPrice;

        if (assetPriceChanged || msg.sender == address(staker)) {
            uint256 syntheticTokenPriceLong = syntheticTokenPriceSnapshot[
                marketIndex
            ][true][marketUpdateIndex[marketIndex]];
            uint256 syntheticTokenPriceShort = syntheticTokenPriceSnapshot[
                marketIndex
            ][false][marketUpdateIndex[marketIndex]];
            staker.addNewStateForFloatRewards(
                marketIndex,
                syntheticTokenPriceLong,
                syntheticTokenPriceShort,
                syntheticTokenPoolValue[marketIndex][true],
                syntheticTokenPoolValue[marketIndex][false]
            );

            if (!assetPriceChanged) {
                return;
            }

            _claimAndDistributeYield(marketIndex);
            _adjustMarketBasedOnNewAssetPrice(marketIndex, newAssetPrice);

            syntheticTokenPriceLong = _recalculateSyntheticTokenPrice(
                marketIndex,
                true
            );
            syntheticTokenPriceShort = _recalculateSyntheticTokenPrice(
                marketIndex,
                false
            );

            assetPrice[marketIndex] = uint256(newAssetPrice);
            marketUpdateIndex[marketIndex] += 1;

            _saveSyntheticTokenPriceSnapshots(
                marketIndex,
                marketUpdateIndex[marketIndex],
                syntheticTokenPriceLong,
                syntheticTokenPriceShort
            );
            _performOustandingSettlements(
                marketIndex,
                marketUpdateIndex[marketIndex],
                syntheticTokenPriceLong,
                syntheticTokenPriceShort
            );

            emit SystemStateUpdated(
                marketIndex,
                marketUpdateIndex[marketIndex],
                newAssetPrice,
                syntheticTokenPoolValue[marketIndex][true],
                syntheticTokenPoolValue[marketIndex][false],
                syntheticTokenPriceLong,
                syntheticTokenPriceShort
            );
        }
    }

    function updateSystemState(uint32 marketIndex) external override {
        _updateSystemStateInternal(marketIndex);
    }

    function updateSystemStateMulti(uint32[] calldata marketIndexes)
        external
        override
    {
        for (uint256 i = 0; i < marketIndexes.length; i++) {
            _updateSystemStateInternal(marketIndexes[i]);
        }
    }

    /*╔════════════════════════════════╗
      ║      DEPOSIT + WITHDRAWAL      ║
      ╚════════════════════════════════╝*/

    function _depositFunds(uint32 marketIndex, uint256 amount) internal {
        paymentTokens[marketIndex].transferFrom(
            msg.sender,
            address(this),
            amount
        );
    }

    // NOTE: Only used in seeding the market.
    function _lockFundsInMarket(uint32 marketIndex, uint256 amount) internal {
        _depositFunds(marketIndex, amount);
        _transferFundsToYieldManager(marketIndex, amount);
    }

    /*
     * Returns locked funds from the market to the sender.
     */
    // TODO STENT only called in 1 place: _handleBatchedRedeemSettlement
    function _withdrawFunds(
        uint32 marketIndex,
        uint256 amountLong,
        uint256 amountShort,
        address user
    ) internal {
        uint256 totalAmount = amountLong + amountShort;

        if (totalAmount == 0) {
            return;
        }

        assert(
            syntheticTokenPoolValue[marketIndex][true] >= amountLong &&
                syntheticTokenPoolValue[marketIndex][false] >= amountShort
        );

        _transferFromYieldManager(marketIndex, totalAmount);

        // Transfer funds to the sender.
        paymentTokens[marketIndex].transfer(user, totalAmount);

        syntheticTokenPoolValue[marketIndex][true] -= amountLong;
        syntheticTokenPoolValue[marketIndex][false] -= amountShort;
    }

    function _burnSynthTokensForRedemption(
        uint32 marketIndex,
        uint256 amountSynthToRedeemLong,
        uint256 amountSynthToRedeemShort
    ) internal {
        if (amountSynthToRedeemLong > 0) {
            syntheticTokens[marketIndex][true].synthRedeemBurn(
                address(this),
                amountSynthToRedeemLong
            );
        }

        if (amountSynthToRedeemShort > 0) {
            syntheticTokens[marketIndex][false].synthRedeemBurn(
                address(this),
                amountSynthToRedeemShort
            );
        }
    }

    /*╔══════════════════════════════════╗
      ║     TREASURY + YIELD MANAGER     ║
      ╚══════════════════════════════════╝*/

    /*
     * Transfers locked funds from LongShort into the yield manager.
     */
    function _transferFundsToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        yieldManagers[marketIndex].depositPaymentToken(amount);
    }

    /*
     * Transfers locked funds from the yield manager into LongShort.
     */
    function _transferFromYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        // NB there will be issues here if not enough liquidity exists to withdraw
        // Boolean should be returned from yield manager and think how to appropriately handle this
        yieldManagers[marketIndex].withdrawPaymentToken(amount);
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
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
        _depositFunds(marketIndex, amount);

        batchedAmountOfTokensToDeposit[marketIndex][isLong] += amount;
        userNextPriceDepositAmount[marketIndex][isLong][msg.sender] += amount;
        userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] =
            marketUpdateIndex[marketIndex] +
            1;

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
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
        syntheticTokens[marketIndex][isLong].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );

        userNextPriceRedemptionAmount[marketIndex][isLong][
            msg.sender
        ] += tokensToRedeem;
        userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] =
            marketUpdateIndex[marketIndex] +
            1;

        batchedAmountOfSynthTokensToRedeem[marketIndex][
            isLong
        ] += tokensToRedeem;

        emit NextPriceRedeem(
            marketIndex,
            isLong,
            tokensToRedeem,
            msg.sender,
            marketUpdateIndex[marketIndex] + 1
        );
    }

    function redeemLongNextPrice(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
        _redeemNextPrice(marketIndex, tokensToRedeem, true);
    }

    function redeemShortNextPrice(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
        _redeemNextPrice(marketIndex, tokensToRedeem, false);
    }

    /*╔════════════════════════════════╗
      ║     NEXT PRICE SETTLEMENTS     ║
      ╚════════════════════════════════╝*/

    function _executeNextPriceMintsIfTheyExist(
        uint32 marketIndex,
        address user,
        bool isLong
    ) internal {
        uint256 currentDepositAmount = userNextPriceDepositAmount[marketIndex][
            isLong
        ][user];
        if (currentDepositAmount > 0) {
            userNextPriceDepositAmount[marketIndex][isLong][user] = 0;
            uint256 tokensToTransferToUser = _getAmountSynthToken(
                currentDepositAmount,
                syntheticTokenPriceSnapshot[marketIndex][isLong][
                    userCurrentNextPriceUpdateIndex[marketIndex][user]
                ]
            );
            syntheticTokens[marketIndex][isLong].transfer(
                user,
                tokensToTransferToUser
            );

            emit ExecuteNextPriceMintSettlementUser(
                user,
                marketIndex,
                isLong,
                tokensToTransferToUser
            );
        }
    }

    function _executeOutstandingNextPriceRedeems(
        uint32 marketIndex,
        address user,
        bool isLong
    ) internal {
        uint256 currentRedemptions = userNextPriceRedemptionAmount[marketIndex][
            isLong
        ][user];
        if (currentRedemptions > 0) {
            userNextPriceRedemptionAmount[marketIndex][isLong][user] = 0;
            uint256 amountToRedeem = _getAmountPaymentToken(
                currentRedemptions,
                syntheticTokenPriceSnapshot[marketIndex][isLong][
                    userCurrentNextPriceUpdateIndex[marketIndex][user]
                ]
            );
            paymentTokens[marketIndex].transfer(user, amountToRedeem);
            emit ExecuteNextPriceRedeemSettlementUser(
                user,
                marketIndex,
                isLong,
                amountToRedeem
            );
        }
    }

    function _executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex
    ) internal {
        uint256 currentUpdateIndex = userCurrentNextPriceUpdateIndex[
            marketIndex
        ][user];
        if (
            currentUpdateIndex != 0 &&
            currentUpdateIndex <= marketUpdateIndex[marketIndex]
        ) {
            _executeNextPriceMintsIfTheyExist(marketIndex, user, true);
            _executeNextPriceMintsIfTheyExist(marketIndex, user, false);
            _executeOutstandingNextPriceRedeems(marketIndex, user, true);
            _executeOutstandingNextPriceRedeems(marketIndex, user, false);

            userCurrentNextPriceUpdateIndex[marketIndex][user] = 0;

            emit ExecuteNextPriceSettlementsUser(user, marketIndex);
        }
    }

    function executeOutstandingNextPriceSettlementsUser(
        address user,
        uint32 marketIndex
    ) external override {
        _executeOutstandingNextPriceSettlements(user, marketIndex);
    }

    /*╔═══════════════════════════════════════════╗
      ║   BATCHED NEXT PRICE SETTLEMENT ACTIONS   ║
      ╚═══════════════════════════════════════════╝*/

    function _performOustandingSettlements(
        uint32 marketIndex,
        uint256 newLatestPriceStateIndex,
        uint256 syntheticTokenPriceLong,
        uint256 syntheticTokenPriceShort
    ) internal {
        _handleBatchedDepositSettlement(
            marketIndex,
            true,
            syntheticTokenPriceLong
        );
        _handleBatchedDepositSettlement(
            marketIndex,
            false,
            syntheticTokenPriceShort
        );
        _handleBatchedRedeemSettlement(
            marketIndex,
            syntheticTokenPriceLong,
            syntheticTokenPriceShort
        );
    }

    function _handleBatchedDepositSettlement(
        uint32 marketIndex,
        bool isLong,
        uint256 syntheticTokenPrice
    ) internal {
        uint256 amountToBatchDeposit = batchedAmountOfTokensToDeposit[
            marketIndex
        ][isLong];

        if (amountToBatchDeposit > 0) {
            batchedAmountOfTokensToDeposit[marketIndex][isLong] = 0;
            _transferFundsToYieldManager(marketIndex, amountToBatchDeposit);

            uint256 numberOfTokens = _getAmountSynthToken(
                amountToBatchDeposit,
                syntheticTokenPrice
            );

            syntheticTokens[marketIndex][isLong].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenPoolValue[marketIndex][
                isLong
            ] += amountToBatchDeposit;
        }
    }

    function _handleBatchedRedeemSettlement(
        uint32 marketIndex,
        uint256 syntheticTokenPriceLong,
        uint256 syntheticTokenPriceShort
    ) internal {
        _burnSynthTokensForRedemption(
            marketIndex,
            batchedAmountOfSynthTokensToRedeem[marketIndex][true],
            batchedAmountOfSynthTokensToRedeem[marketIndex][false]
        );

        uint256 longAmountOfPaymentTokenToRedeem = _getAmountPaymentToken(
            batchedAmountOfSynthTokensToRedeem[marketIndex][true],
            syntheticTokenPriceLong
        );
        uint256 shortAmountOfPaymentTokenToRedeem = _getAmountPaymentToken(
            batchedAmountOfSynthTokensToRedeem[marketIndex][false],
            syntheticTokenPriceShort
        );

        batchedAmountOfSynthTokensToRedeem[marketIndex][true] = 0;
        batchedAmountOfSynthTokensToRedeem[marketIndex][false] = 0;

        _withdrawFunds(
            marketIndex,
            longAmountOfPaymentTokenToRedeem,
            shortAmountOfPaymentTokenToRedeem,
            address(this)
        );
    }
}
