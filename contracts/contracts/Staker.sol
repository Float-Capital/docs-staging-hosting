// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";

import "./interfaces/IFloatToken.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/IStaker.sol";

contract Staker is IStaker, Initializable {
    /*╔═════════════════════════════╗
      ║          VARIABLES          ║
      ╚═════════════════════════════╝*/

    // Fixed-precision constants
    uint256 public constant FLOAT_ISSUANCE_FIXED_DECIMAL = 1e42;

    // Global state
    address public admin;
    address public floatCapital;
    uint256 public floatPercentage;

    ILongShort public longShortCoreContract;
    IFloatToken public floatToken;

    // Market specific
    mapping(uint32 => uint256) public marketLaunchIncentivePeriod; // seconds
    mapping(uint32 => uint256) public marketLaunchIncentiveMultipliers; // e18 scale
    mapping(uint32 => uint256) public marketUnstakeFeeBasisPoints;
    mapping(uint32 => uint256) public balanceIncentiveCurveExponent;
    mapping(uint32 => int256) public balanceIncentiveCurveEquilibriumOffset;

    mapping(uint32 => mapping(bool => ISyntheticToken)) public syntheticTokens;

    mapping(ISyntheticToken => uint32) public marketIndexOfToken;

    // Reward specific
    mapping(uint32 => uint256) public latestRewardIndex;
    mapping(uint32 => mapping(uint256 => RewardState))
        public syntheticRewardParams;
    struct RewardState {
        uint256 timestamp;
        uint256 accumulativeFloatPerLongToken;
        uint256 accumulativeFloatPerShortToken;
    }

    // User specific
    mapping(uint32 => mapping(address => uint256))
        public userIndexOfLastClaimedReward;
    mapping(ISyntheticToken => mapping(address => uint256))
        public userAmountStaked;

    /*╔════════════════════════════╗
      ║           EVENTS           ║
      ╚════════════════════════════╝*/

    event StakerV1(address floatToken, uint256 floatPercentage);

    event MarketAddedToStaker(
        uint32 marketIndex,
        uint256 exitFeeBasisPoints,
        uint256 period,
        uint256 multiplier,
        uint256 balanceIncentiveExponent,
        int256 balanceIncentiveEquilibriumOffset
    );

    event StateAdded(
        uint32 marketIndex,
        uint256 stateIndex,
        uint256 accumulativeLong,
        uint256 accumulativeShort
    );

    event StakeAdded(
        address user,
        address token,
        uint256 amount,
        uint256 lastMintIndex
    );

    event StakeWithdrawn(address user, address token, uint256 amount);

    event FloatMinted(
        address user,
        uint32 marketIndex,
        uint256 amountLong,
        uint256 amountShort,
        uint256 lastMintIndex
    );

    event MarketLaunchIncentiveParametersChanges(
        uint32 marketIndex,
        uint256 period,
        uint256 multiplier
    );

    event StakeWithdrawalFeeUpdated(
        uint32 marketIndex,
        uint256 stakeWithdralFee
    );

    event BalanceIncentiveExponentUpdated(
        uint32 marketIndex,
        uint256 balanceIncentiveExponent
    );

    event BalanceIncentiveEquilibriumOffsetUpdated(
        uint32 marketIndex,
        int256 balanceIncentiveEquilibriumOffset
    );

    event FloatPercentageUpdated(uint256 floatPercentage);

    /*╔═════════════════════════════╗
      ║          MODIFIERS          ║
      ╚═════════════════════════════╝*/

    modifier onlyAdmin() {
        require(msg.sender == admin, "not admin");
        _;
    }

    modifier onlyValidSynthetic(ISyntheticToken _synth) {
        require(marketIndexOfToken[_synth] != 0, "not valid synth");
        _;
    }

    modifier onlyValidMarket(uint32 marketIndex) {
        require(
            address(syntheticTokens[marketIndex][true]) != address(0),
            "not valid market"
        );
        // require(latestRewardIndex[marketIndex] != 0, "not valid market");
        _;
    }

    modifier onlyFloat() {
        require(msg.sender == address(longShortCoreContract));
        _;
    }

    /*╔═════════════════════════════╗
      ║       CONTRACT SET-UP       ║
      ╚═════════════════════════════╝*/

    function initialize(
        address _admin,
        address _longShortCoreContract,
        address _floatToken,
        address _floatCapital,
        uint256 _floatPercentage
    ) public initializer {
        require(
            _admin != address(0) &&
                _floatCapital != address(0) &&
                _longShortCoreContract != address(0) &&
                _floatToken != address(0)
        );
        admin = _admin;
        floatCapital = _floatCapital;
        longShortCoreContract = ILongShort(_longShortCoreContract);
        floatToken = IFloatToken(_floatToken);

        _changeFloatPercentage(_floatPercentage);

        emit StakerV1(_floatToken, floatPercentage);
    }

    /*╔═════════════════════════════╗
      ║       MULTI-SIG ADMIN       ║
      ╚═════════════════════════════╝*/

    function changeAdmin(address _admin) external onlyAdmin {
        admin = _admin;
    }

    function _changeFloatPercentage(uint256 newFloatPercentage) internal {
        require(newFloatPercentage <= 1e18 && newFloatPercentage > 0); // less than 100% and greater than 0%
        floatPercentage = newFloatPercentage;
    }

    function changeFloatPercentage(uint256 newFloatPercentage)
        external
        onlyAdmin
    {
        _changeFloatPercentage(newFloatPercentage);
        emit FloatPercentageUpdated(newFloatPercentage);
    }

    function _changeUnstakeFee(
        uint32 marketIndex,
        uint256 newMarketUnstakeFeeBasisPoints
    ) internal {
        require(newMarketUnstakeFeeBasisPoints <= 5e16); // 5% fee is the max fee possible.
        marketUnstakeFeeBasisPoints[
            marketIndex
        ] = newMarketUnstakeFeeBasisPoints;
    }

    function changeUnstakeFee(
        uint32 marketIndex,
        uint256 newMarketUnstakeFeeBasisPoints
    ) external onlyAdmin {
        _changeUnstakeFee(marketIndex, newMarketUnstakeFeeBasisPoints);
        emit StakeWithdrawalFeeUpdated(
            marketIndex,
            newMarketUnstakeFeeBasisPoints
        );
    }

    function changeMarketLaunchIncentiveParameters(
        uint32 marketIndex,
        uint256 period,
        uint256 initialMultiplier
    ) external onlyAdmin {
        _changeMarketLaunchIncentiveParameters(
            marketIndex,
            period,
            initialMultiplier
        );

        emit MarketLaunchIncentiveParametersChanges(
            marketIndex,
            period,
            initialMultiplier
        );
    }

    function _changeMarketLaunchIncentiveParameters(
        uint32 marketIndex,
        uint256 period,
        uint256 initialMultiplier
    ) internal {
        require(
            initialMultiplier >= 1e18,
            "marketLaunchIncentiveMultiplier must be >= 1e18"
        );

        marketLaunchIncentivePeriod[marketIndex] = period;
        marketLaunchIncentiveMultipliers[marketIndex] = initialMultiplier;
    }

    function _changBalanceIncentiveExponent(
        uint32 marketIndex,
        uint256 _balanceIncentiveCurveExponent
    ) internal {
        require(
            _balanceIncentiveCurveExponent > 0 &&
                _balanceIncentiveCurveExponent < 10000,
            "balanceIncentiveCurveExponent out of bounds"
        );

        balanceIncentiveCurveExponent[
            marketIndex
        ] = _balanceIncentiveCurveExponent;
    }

    function changBalanceIncentiveExponent(
        uint32 marketIndex,
        uint256 _balanceIncentiveCurveExponent
    ) external onlyAdmin {
        _changBalanceIncentiveExponent(
            marketIndex,
            _balanceIncentiveCurveExponent
        );

        emit BalanceIncentiveExponentUpdated(
            marketIndex,
            _balanceIncentiveCurveExponent
        );
    }

    function _changBalanceIncentiveEquilibriumOffset(
        uint32 marketIndex,
        int256 _balanceIncentiveCurveEquilibriumOffset
    ) internal {
        // Seems unreasonable that we would ever shift this more than 50% either way
        require(
            _balanceIncentiveCurveEquilibriumOffset > -5e17 &&
                _balanceIncentiveCurveEquilibriumOffset < 5e17,
            "balanceIncentiveCurveEquilibriumOffset out of bounds"
        );

        balanceIncentiveCurveEquilibriumOffset[
            marketIndex
        ] = _balanceIncentiveCurveEquilibriumOffset;
    }

    function changBalanceIncentiveEquilibriumOffset(
        uint32 marketIndex,
        int256 _balanceIncentiveCurveEquilibriumOffset
    ) external onlyAdmin {
        _changBalanceIncentiveEquilibriumOffset(
            marketIndex,
            _balanceIncentiveCurveEquilibriumOffset
        );

        emit BalanceIncentiveEquilibriumOffsetUpdated(
            marketIndex,
            _balanceIncentiveCurveEquilibriumOffset
        );
    }

    /*╔═════════════════════════════╗
      ║        STAKING SETUP        ║
      ╚═════════════════════════════╝*/

    function addNewStakingFund(
        uint32 marketIndex,
        ISyntheticToken longToken,
        ISyntheticToken shortToken,
        uint256 kInitialMultiplier,
        uint256 kPeriod,
        uint256 unstakeFeeBasisPoints,
        uint256 _balanceIncentiveCurveExponent,
        int256 _balanceIncentiveCurveEquilibriumOffset
    ) external override onlyFloat {
        marketIndexOfToken[longToken] = marketIndex;
        marketIndexOfToken[shortToken] = marketIndex;

        syntheticRewardParams[marketIndex][0].timestamp = block.timestamp;
        syntheticRewardParams[marketIndex][0].accumulativeFloatPerLongToken = 0;
        syntheticRewardParams[marketIndex][0]
        .accumulativeFloatPerShortToken = 0;

        syntheticTokens[marketIndex][true] = longToken;
        syntheticTokens[marketIndex][false] = shortToken;

        _changBalanceIncentiveExponent(
            marketIndex,
            _balanceIncentiveCurveExponent
        );
        _changBalanceIncentiveEquilibriumOffset(
            marketIndex,
            _balanceIncentiveCurveEquilibriumOffset
        );
        _changeMarketLaunchIncentiveParameters(
            marketIndex,
            kPeriod,
            kInitialMultiplier
        );

        _changeUnstakeFee(marketIndex, unstakeFeeBasisPoints);

        emit MarketAddedToStaker(
            marketIndex,
            unstakeFeeBasisPoints,
            kPeriod,
            kInitialMultiplier,
            _balanceIncentiveCurveExponent,
            _balanceIncentiveCurveEquilibriumOffset
        );

        emit StateAdded(marketIndex, 0, 0, 0);
    }

    ////////////////////////////////////
    // GLOBAL REWARD STATE FUNCTIONS ///
    ////////////////////////////////////

    /*
     * Returns the K factor parameters for the given market with sensible
     * defaults if they haven't been set yet.
     */
    function getMarketLaunchIncentiveParameters(uint32 marketIndex)
        internal
        view
        returns (uint256, uint256)
    {
        uint256 period = marketLaunchIncentivePeriod[marketIndex];
        uint256 multiplier = marketLaunchIncentiveMultipliers[marketIndex];
        if (multiplier == 0) {
            multiplier = 1e18; // multiplier of 1 by default
        }

        return (period, multiplier);
    }

    function getKValue(uint32 marketIndex) internal view returns (uint256) {
        // Parameters controlling the float issuance multiplier.
        (
            uint256 kPeriod,
            uint256 kInitialMultiplier
        ) = getMarketLaunchIncentiveParameters(marketIndex);

        // Sanity check - under normal circumstances, the multipliers should
        // *never* be set to a value < 1e18, as there are guards against this.
        assert(kInitialMultiplier >= 1e18);

        uint256 initialTimestamp = syntheticRewardParams[marketIndex][0]
        .timestamp;

        if (block.timestamp - initialTimestamp <= kPeriod) {
            return
                kInitialMultiplier -
                (((kInitialMultiplier - 1e18) *
                    (block.timestamp - initialTimestamp)) / kPeriod);
        } else {
            return 1e18;
        }
    }

    // TODO: turn this into a library.
    //       make this a simple lookup table with appropriate aproximation
    function getRequiredAmountOfBitShiftForSafeExponentiation(
        uint256 number,
        uint256 exponent
    ) internal pure returns (uint256 amountOfBitShiftRequired) {
        uint256 targetMaxNumberSizeBinaryDigits = 257 / exponent;

        // Note this can be optimised, this gets a quick easy to compute safe upper bound, not the actuall upper bound.
        uint256 targetMaxNumber = 2**targetMaxNumberSizeBinaryDigits;

        while (number >> amountOfBitShiftRequired > targetMaxNumber) {
            ++amountOfBitShiftRequired;
        }
    }

    /*
     * Computes the current 'r' value, i.e. the number of float tokens a user
     * earns per second for every longshort token they've staked. The returned
     * value has a fixed decimal scale of 1e42 (!!!) for numerical stability.
     * The return values are float per second per synthetic token (hence the
     * requirement to multiply by price)
     */
    function _calculateFloatPerSecond(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    )
        internal
        view
        returns (uint256 longFloatPerSecond, uint256 shortFloatPerSecond)
    {
        // Markets cannot be or become empty (since they are seeded with non-withdrawable capital)
        assert(longValue != 0 && shortValue != 0);

        // A float issuance multiplier that starts high and decreases linearly
        // over time to a value of 1. This incentivises users to stake early.
        uint256 k = getKValue(marketIndex);

        uint256 totalLocked = (longValue + shortValue);

        // we need to scale this number by the totalLocked so that the offset remains consistent accross market size


            int256 equilibriumOffsetMarketScaled
         = (balanceIncentiveCurveEquilibriumOffset[marketIndex] *
            int256(totalLocked)) / 1e18;


            uint256 requiredBitShifting
         = getRequiredAmountOfBitShiftForSafeExponentiation(
            totalLocked,
            balanceIncentiveCurveExponent[marketIndex]
        );

        // Float is scaled by the percentage of the total market value held in
        // the opposite position. This incentivises users to stake on the
        // weaker position.
        if (
            int256(shortValue) - equilibriumOffsetMarketScaled <
            int256(longValue)
        ) {
            if (equilibriumOffsetMarketScaled >= int256(shortValue)) {
                // edge case: imbalanced far past the equilibrium offset - full rewards go to short token
                //            extremeley unlikely to happen in practice
                return (0, 1e18 * k * shortPrice);
            }

            uint256 numerator = (uint256(
                int256(shortValue) - equilibriumOffsetMarketScaled
            ) >> (requiredBitShifting - 1)) **
                balanceIncentiveCurveExponent[marketIndex];

            uint256 denominator = ((totalLocked >> requiredBitShifting) **
                balanceIncentiveCurveExponent[marketIndex]) / 1e18;

            uint256 longRewardUnscaled = (numerator / denominator) / 2;
            uint256 shortRewardUnscaled = 1e18 - longRewardUnscaled;

            return (
                (longRewardUnscaled * k * longPrice) / 1e18,
                (shortRewardUnscaled * k * shortPrice) / 1e18
            );
        } else {
            if (-equilibriumOffsetMarketScaled >= int256(longValue)) {
                // edge case: imbalanced far past the equilibrium offset - full rewards go to long token
                //            extremeley unlikely to happen in practice
                return (1e18 * k * longPrice, 0);
            }

            uint256 numerator = (uint256(
                int256(longValue) + equilibriumOffsetMarketScaled
            ) >> (requiredBitShifting - 1)) **
                balanceIncentiveCurveExponent[marketIndex];

            uint256 denominator = ((totalLocked >> requiredBitShifting) **
                balanceIncentiveCurveExponent[marketIndex]) / 1e18;

            uint256 shortRewardUnscaled = (numerator / denominator) / 2;
            uint256 longRewardUnscaled = 1e18 - shortRewardUnscaled;

            return (
                (longRewardUnscaled * k * longPrice) / 1e18,
                (shortRewardUnscaled * k * shortPrice) / 1e18
            );
        }
    }

    /*
     * Computes the time since last state point for the given token in seconds.
     */
    function calculateTimeDelta(uint32 marketIndex)
        internal
        view
        returns (uint256)
    {
        return
            block.timestamp -
            syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
            .timestamp;
    }

    /*
     * Computes new cumulative sum of 'r' value since last state point. We use
     * cumulative 'r' value to avoid looping during issuance. Note that the
     * cumulative sum is kept in 1e42 scale (!!!) to avoid numerical issues.
     */
    function calculateNewCumulativeRate(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    )
        internal
        view
        returns (uint256 longCumulativeRates, uint256 shortCumulativeRates)
    {
        // Compute the current 'r' value for float issuance per second.
        (
            uint256 longFloatPerSecond,
            uint256 shortFloatPerSecond
        ) = _calculateFloatPerSecond(
            marketIndex,
            longPrice,
            shortPrice,
            longValue,
            shortValue
        );

        // Compute time since last state point for the given token.
        uint256 timeDelta = calculateTimeDelta(marketIndex);

        // Compute new cumulative 'r' value total.
        return (
            syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
            .accumulativeFloatPerLongToken + (timeDelta * longFloatPerSecond),
            syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
            .accumulativeFloatPerShortToken + (timeDelta * shortFloatPerSecond)
        );
    }

    /*
     * Creates a new state point for the given token and updates indexes.
     */
    function setRewardObjects(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    ) internal {
        (
            uint256 longAccumulativeRates,
            uint256 shortAccumulativeRates
        ) = calculateNewCumulativeRate(
            marketIndex,
            longPrice,
            shortPrice,
            longValue,
            shortValue
        );

        uint256 newIndex = latestRewardIndex[marketIndex] + 1;

        // Set cumulative 'r' value on new state point.
        syntheticRewardParams[marketIndex][newIndex]
        .accumulativeFloatPerLongToken = longAccumulativeRates;
        syntheticRewardParams[marketIndex][newIndex]
        .accumulativeFloatPerShortToken = shortAccumulativeRates;

        // Set timestamp on new state point.
        syntheticRewardParams[marketIndex][newIndex].timestamp = block
        .timestamp;

        // Update latest index to point to new state point.
        latestRewardIndex[marketIndex] = newIndex;

        emit StateAdded(
            marketIndex,
            newIndex,
            longAccumulativeRates,
            shortAccumulativeRates
        );
    }

    /*
     * Adds new state points for the given long/short tokens. Called by the
     * ILongShort contract whenever there is a state change for a market.
     */
    function addNewStateForFloatRewards(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    ) external override onlyFloat {
        // Only add a new state point if some time has passed.

        // Time delta is fetched twice in below code, can pass through? Which is less gas?
        if (calculateTimeDelta(marketIndex) > 0) {
            setRewardObjects(
                marketIndex,
                longPrice,
                shortPrice,
                longValue,
                shortValue
            );
        }
    }

    ////////////////////////////////////
    // USER REWARD STATE FUNCTIONS /////
    ////////////////////////////////////

    function calculateAccumulatedFloatHelper(
        uint32 marketIndex,
        address user,
        uint256 amountStakedLong,
        uint256 amountStakedShort,
        uint256 usersLastRewardIndex
    )
        internal
        view
        returns (
            // NOTE: this returns the long and short reward separately for the sake of simplicity of the event and the graph. Would be more efficient to return as single value
            uint256 longFloatReward,
            uint256 shortFloatReward
        )
    {
        // Don't do the calculation and return zero immediately if there is no change
        if (usersLastRewardIndex == latestRewardIndex[marketIndex]) {
            return (0, 0);
        }

        // Stake should always do a full system state update, so 'users last claimed index' should never be greater than the latest index
        assert(
            userIndexOfLastClaimedReward[marketIndex][user] <
                latestRewardIndex[marketIndex]
        );

        ISyntheticToken longToken = syntheticTokens[marketIndex][true];
        ISyntheticToken shortToken = syntheticTokens[marketIndex][false];

        if (amountStakedLong > 0) {
            uint256 accumDeltaLong = syntheticRewardParams[marketIndex][
                latestRewardIndex[marketIndex]
            ]
            .accumulativeFloatPerLongToken -
                syntheticRewardParams[marketIndex][
                    userIndexOfLastClaimedReward[marketIndex][user]
                ]
                .accumulativeFloatPerLongToken;
            longFloatReward =
                (accumDeltaLong * amountStakedLong) /
                FLOAT_ISSUANCE_FIXED_DECIMAL;
        }

        if (amountStakedShort > 0) {
            uint256 accumDeltaShort = syntheticRewardParams[marketIndex][
                latestRewardIndex[marketIndex]
            ]
            .accumulativeFloatPerShortToken -
                syntheticRewardParams[marketIndex][
                    userIndexOfLastClaimedReward[marketIndex][user]
                ]
                .accumulativeFloatPerShortToken;
            shortFloatReward =
                (accumDeltaShort * amountStakedShort) /
                FLOAT_ISSUANCE_FIXED_DECIMAL;
        }

        // explicit return
        return (longFloatReward, shortFloatReward);
    }

    function calculateAccumulatedFloat(uint32 marketIndex, address user)
        internal
        view
        returns (
            // NOTE: this returns the long and short reward separately for the sake of simplicity of the event and the graph. Would be more efficient to return as single value
            uint256 longFloatReward,
            uint256 shortFloatReward
        )
    {
        ISyntheticToken longToken = syntheticTokens[marketIndex][true];
        ISyntheticToken shortToken = syntheticTokens[marketIndex][false];

        uint256 amountStakedLong = userAmountStaked[longToken][user];
        uint256 amountStakedShort = userAmountStaked[shortToken][user];

        // explicit return
        return
            calculateAccumulatedFloatHelper(
                marketIndex,
                user,
                amountStakedLong,
                amountStakedShort,
                userIndexOfLastClaimedReward[marketIndex][user]
            );
    }

    function _mintFloat(address user, uint256 floatToMint) internal {
        floatToken.mint(user, floatToMint);
        floatToken.mint(floatCapital, (floatToMint * floatPercentage) / 1e18);
    }

    function mintAccumulatedFloat(uint32 marketIndex, address user) internal {
        // NOTE: Could merge these two values already inside the `calculateAccumulatedFloat` function, but that would make it harder for the graph
        (
            uint256 floatToMintLong,
            uint256 floatToMintShort
        ) = calculateAccumulatedFloat(marketIndex, user);

        uint256 floatToMint = floatToMintLong + floatToMintShort;
        if (floatToMint > 0) {
            // stops them setting this forward
            userIndexOfLastClaimedReward[marketIndex][user] = latestRewardIndex[
                marketIndex
            ];

            _mintFloat(user, floatToMint);

            emit FloatMinted(
                user,
                marketIndex,
                floatToMintLong,
                floatToMintShort,
                latestRewardIndex[marketIndex]
            );
        }
    }

    function _claimFloat(uint32[] calldata marketIndexes) internal {
        uint256 floatTotal = 0;
        for (uint256 i = 0; i < marketIndexes.length; i++) {
            // NOTE: Could merge these two values already inside the `calculateAccumulatedFloat` function, but that would make it harder for the graph
            (
                uint256 floatToMintLong,
                uint256 floatToMintShort
            ) = calculateAccumulatedFloat(marketIndexes[i], msg.sender);

            uint256 floatToMint = floatToMintLong + floatToMintShort;

            if (floatToMint > 0) {
                // Set the user has claimed up until now.
                // TODO: think very carefully if it is ok for this to be in this if statement. Safer would be to always set this value?
                //       99.9% sure it is ok though, since `_stake` sets this value when someone joins.
                //       Maybe just change for the sake of caution?
                userIndexOfLastClaimedReward[marketIndexes[i]][
                    msg.sender
                ] = latestRewardIndex[marketIndexes[i]];

                floatTotal += floatToMint;

                emit FloatMinted(
                    msg.sender,
                    marketIndexes[i],
                    floatToMintLong,
                    floatToMintShort,
                    latestRewardIndex[marketIndexes[i]]
                );
            }
        }
        if (floatTotal > 0) {
            _mintFloat(msg.sender, floatTotal);
        }
    }

    function claimFloatCustom(uint32[] calldata marketIndexes) external {
        require(marketIndexes.length <= 50); // Set some (arbitrary) limit on loop length
        longShortCoreContract.updateSystemStateMulti(marketIndexes);
        _claimFloat(marketIndexes);
    }

    ////////////////////////////////////
    /////////// STAKING ////////////////
    ////////////////////////////////////

    /*
     * A user with synthetic tokens stakes by calling stake on the token
     * contract which calls this function. We need to first update the
     * State of the system before staking to correctly calculate user rewards.
     */
    function stakeFromUser(address from, uint256 amount)
        public
        override
        onlyValidSynthetic(ISyntheticToken(msg.sender))
    {
        longShortCoreContract.updateSystemState(
            marketIndexOfToken[ISyntheticToken(msg.sender)]
        );
        _stake(ISyntheticToken(msg.sender), amount, from);
    }

    function _stake(
        ISyntheticToken token,
        uint256 amount,
        address user
    ) internal {
        uint32 marketIndex = marketIndexOfToken[token];

        // If they already have staked and have rewards due, mint these.
        if (
            userIndexOfLastClaimedReward[marketIndex][user] != 0 &&
            userIndexOfLastClaimedReward[marketIndex][user] <
            latestRewardIndex[marketIndex]
        ) {
            mintAccumulatedFloat(marketIndex, user);
        }

        userAmountStaked[token][user] = userAmountStaked[token][user] + amount;

        userIndexOfLastClaimedReward[marketIndex][user] = latestRewardIndex[
            marketIndex
        ];

        emit StakeAdded(
            user,
            address(token),
            amount,
            userIndexOfLastClaimedReward[marketIndex][user]
        );
    }

    ////////////////////////////////////
    /////// WITHDRAW n MINT ////////////
    ////////////////////////////////////

    /*
    Withdraw function.
    Mint user any outstanding float before
    */
    function _withdraw(ISyntheticToken token, uint256 amount) internal {
        uint32 marketIndex = marketIndexOfToken[token];
        require(userAmountStaked[token][msg.sender] > 0, "nothing to withdraw");
        mintAccumulatedFloat(marketIndex, msg.sender);

        userAmountStaked[token][msg.sender] =
            userAmountStaked[token][msg.sender] -
            amount;

        uint256 amountFees = (amount *
            marketUnstakeFeeBasisPoints[marketIndex]) / 1e18;

        token.transfer(msg.sender, amount - amountFees);

        emit StakeWithdrawn(msg.sender, address(token), amount);
    }

    function withdraw(ISyntheticToken token, uint256 amount) external {
        longShortCoreContract.updateSystemState(marketIndexOfToken[token]);

        _withdraw(token, amount);
    }

    function withdrawAll(ISyntheticToken token) external {
        longShortCoreContract.updateSystemState(marketIndexOfToken[token]);

        _withdraw(token, userAmountStaked[token][msg.sender]);
    }
}
