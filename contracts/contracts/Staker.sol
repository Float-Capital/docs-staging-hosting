// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";

import "./interfaces/IFloatToken.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/IStaker.sol";

/*
    ###### Purpose of contract ########
    This smart contract allows users to securely stake synthetic asset
    tokens created through the float protocol.

    Staking sythentic tokens will ensure that the liquidity of the
    synthetic market is increased, and entitle users to FLOAT rewards.
*/

/** @title Staker Contract */
contract Staker is IStaker, Initializable {
    struct RewardState {
        uint256 timestamp;
        uint256 accumulativeFloatPerLongToken;
        uint256 accumulativeFloatPerShortToken;
    }
    struct SyntheticTokens {
        ISyntheticToken shortToken;
        ISyntheticToken longToken;
    }

    ////////////////////////////////////
    //////// CONSTANTS /////////////////
    ////////////////////////////////////

    // Controls the k-factor, a multiplier for incentivising early stakers.
    //   token market index -> value
    uint256 public constant FLOAT_ISSUANCE_FIXED_DECIMAL = 1e42;
    mapping(uint256 => uint256) public kFactorPeriods; // seconds
    mapping(uint256 => uint256) public kFactorInitialMultipliers; // e18 scale
    uint256[45] private __stakeParametersGap;

    ////////////////////////////////////
    //////// VARIABLES /////////////////
    ////////////////////////////////////

    // Global state.
    address public admin;
    address public floatCapital;
    uint16 public floatPercentage;
    uint256 public initialTimestamp;
    ILongShort public longShortCoreContract;
    IFloatToken public floatToken;
    uint256[45] private __globalParamsGap;

    // User state.
    //   token -> user -> value
    mapping(ISyntheticToken => mapping(address => uint256))
        public userAmountStaked;
    uint256[45] private __userInfoGap;

    // Token state.
    mapping(ISyntheticToken => uint32) public marketIndexOfToken; // token -> market index
    uint256[45] private __tokenInfoGap;

    // market state.
    mapping(uint32 => mapping(address => uint256))
        public userIndexOfLastClaimedReward;
    mapping(uint32 => SyntheticTokens) public syntheticTokens; // token -> index -> state
    mapping(uint32 => mapping(uint256 => RewardState))
        public syntheticRewardParams; // token -> index -> state
    mapping(uint32 => uint256) public latestRewardIndex; // token -> index

    ////////////////////////////////////
    /////////// EVENTS /////////////////
    ////////////////////////////////////

    event DeployV1(address floatToken);

    event StateAdded(
        uint32 marketIndex,
        uint256 stateIndex,
        uint256 timestamp,
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

    event KFactorParametersChanges(
        uint32 marketIndex,
        uint256 period,
        uint256 multiplier
    );

    ////////////////////////////////////
    /////////// MODIFIERS //////////////
    ////////////////////////////////////

    modifier onlyAdmin() {
        require(msg.sender == admin, "not admin");
        _;
    }

    modifier onlyValidSynthetic(ISyntheticToken _synth) {
        require(marketIndexOfToken[_synth] != 0, "not valid synth");
        _;
    }

    modifier onlyFloat() {
        require(msg.sender == address(longShortCoreContract));
        _;
    }

    ////////////////////////////////////
    ///// CONTRACT SET-UP //////////////
    ////////////////////////////////////

    function initialize(
        address _admin,
        address _longShortCoreContract,
        address _floatToken,
        address _floatCapital
    ) public initializer {
        admin = _admin;
        floatCapital = _floatCapital;
        initialTimestamp = block.timestamp;
        longShortCoreContract = ILongShort(_longShortCoreContract);
        floatToken = IFloatToken(_floatToken);
        floatPercentage = 1500;

        emit DeployV1(_floatToken);
    }

    ////////////////////////////////////
    /// MULTISIG ADMIN FUNCTIONS ///////
    ////////////////////////////////////

    function changeAdmin(address _admin) external onlyAdmin {
        admin = _admin;
    }

    function changeFloatPercentage(uint16 _newPercentage) external onlyAdmin {
        require(_newPercentage <= 10000);
        floatPercentage = _newPercentage;
    }

    function changeKFactorParameters(
        uint32 marketIndex,
        uint256 period,
        uint256 initialMultiplier
    ) external onlyAdmin {
        _changeKFactorParameters(marketIndex, period, initialMultiplier);
    }

    function _changeKFactorParameters(
        uint32 marketIndex,
        uint256 period,
        uint256 initialMultiplier
    ) internal {
        require(
            initialMultiplier >= 1e18,
            "Initial kFactorMultiplier must be >= 1e18"
        );

        kFactorPeriods[marketIndex] = period;
        kFactorInitialMultipliers[marketIndex] = initialMultiplier;

        emit KFactorParametersChanges(marketIndex, period, initialMultiplier);
    }

    ////////////////////////////////////
    /////////// STAKING SETUP //////////
    ////////////////////////////////////

    function addNewStakingFund(
        uint32 marketIndex,
        ISyntheticToken longToken,
        ISyntheticToken shortToken,
        uint256 kInitialMultiplier,
        uint256 kPeriod
    ) external override onlyFloat {
        marketIndexOfToken[longToken] = marketIndex;
        marketIndexOfToken[shortToken] = marketIndex;

        syntheticRewardParams[marketIndex][0].timestamp = block.timestamp;
        syntheticRewardParams[marketIndex][0].accumulativeFloatPerLongToken = 0;
        syntheticRewardParams[marketIndex][0]
            .accumulativeFloatPerShortToken = 0;

        syntheticTokens[marketIndex].longToken = longToken;
        syntheticTokens[marketIndex].shortToken = shortToken;

        _changeKFactorParameters(marketIndex, kPeriod, kInitialMultiplier);

        emit StateAdded(marketIndex, 0, block.timestamp, 0, 0);
    }

    ////////////////////////////////////
    // GLOBAL REWARD STATE FUNCTIONS ///
    ////////////////////////////////////

    /*
     * Returns the K factor parameters for the given market with sensible
     * defaults if they haven't been set yet.
     */
    function getKFactorParameters(uint32 marketIndex)
        internal
        view
        returns (uint256, uint256)
    {
        uint256 period = kFactorPeriods[marketIndex];
        uint256 multiplier = kFactorInitialMultipliers[marketIndex];
        if (multiplier == 0) {
            multiplier = 1e18; // multiplier of 1 by default
        }

        return (period, multiplier);
    }

    function getKValue(uint32 marketIndex) internal view returns (uint256) {
        // Parameters controlling the float issuance multiplier.
        (uint256 kPeriod, uint256 kInitialMultiplier) =
            getKFactorParameters(marketIndex);

        // Sanity check - under normal circumstances, the multipliers should
        // *never* be set to a value < 1e18, as there are guards against this.
        assert(kInitialMultiplier >= 1e18);

        if (block.timestamp - initialTimestamp <= kPeriod) {
            return
                kInitialMultiplier -
                (((kInitialMultiplier - 1e18) *
                    (block.timestamp - initialTimestamp)) / kPeriod);
        } else {
            return 1e18;
        }
    }

    /*
     * Computes the current 'r' value, i.e. the number of float tokens a user
     * earns per second for every longshort token they've staked. The returned
     * value has a fixed decimal scale of 1e42 (!!!) for numerical stability.
     */
    // TODO: should be an internal function (only a javascript test using this function, )
    function calculateFloatPerSecond(
        uint256 longValue,
        uint256 shortValue,
        uint256 longPrice,
        uint256 shortPrice,
        uint32 marketIndex
    )
        public
        view
        returns (uint256 longFloatPerSecond, uint256 shortFloatPerSecond)
    {
        // Edge-case: no float is issued in an empty market.
        if (longValue == 0 && shortValue == 0) {
            return (0, 0);
        }

        // A float issuance multiplier that starts high and decreases linearly
        // over time to a value of 1. This incentivises users to stake early.
        uint256 k = getKValue(marketIndex);

        uint256 totalLocked = (longValue + shortValue);

        // Float is scaled by the percentage of the total market value held in
        // the opposite position. This incentivises users to stake on the
        // weaker position.
        return (
            ((k * shortValue) * longPrice) / totalLocked,
            ((k * longValue) * shortPrice) / totalLocked
        );
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
        uint256 longValue,
        uint256 shortValue,
        uint256 longPrice,
        uint256 shortPrice,
        uint32 marketIndex
    )
        internal
        view
        returns (uint256 longCumulativeRates, uint256 shortCumulativeRates)
    {
        // Compute the current 'r' value for float issuance per second.
        (uint256 longFloatPerSecond, uint256 shortFloatPerSecond) =
            calculateFloatPerSecond(
                longValue,
                shortValue,
                longPrice,
                shortPrice,
                marketIndex
            );

        // Compute time since last state point for the given token.
        uint256 timeDelta = calculateTimeDelta(marketIndex);

        // // Compute new cumulative 'r' value total.
        return (
            syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
                .accumulativeFloatPerLongToken +
                (timeDelta * longFloatPerSecond),
            syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
                .accumulativeFloatPerShortToken +
                (timeDelta * shortFloatPerSecond)
        );
    }

    /*
     * Creates a new state point for the given token and updates indexes.
     */
    function setRewardObjects(
        uint256 longValue,
        uint256 shortValue,
        uint256 longPrice,
        uint256 shortPrice,
        uint32 marketIndex
    ) internal {
        (uint256 longAccumulativeRates, uint256 shortAccumulativeRates) =
            calculateNewCumulativeRate(
                longValue,
                shortValue,
                longPrice,
                shortPrice,
                marketIndex
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
        syntheticRewardParams[marketIndex][newIndex].timestamp = block
            .timestamp;

        // Update latest index to point to new state point.
        latestRewardIndex[marketIndex] = newIndex;

        emit StateAdded(
            marketIndex,
            newIndex,
            block.timestamp,
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
            // TODO: for consistancy, all functions should follow same order
            setRewardObjects(
                longValue,
                shortValue,
                longPrice,
                shortPrice,
                marketIndex
            );
        }
    }

    ////////////////////////////////////
    // USER REWARD STATE FUNCTIONS /////
    ////////////////////////////////////

    function _updateState(ISyntheticToken token) internal {
        longShortCoreContract._updateSystemState(marketIndexOfToken[token]);
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
        // Don't do the calculation and return zero immediately if there is no change
        if (
            userIndexOfLastClaimedReward[marketIndex][user] ==
            latestRewardIndex[marketIndex]
        ) {
            return (0, 0);
        }

        // Stake should always do a full system state update, so 'users last claimed index' should never be greater than the latest index
        assert(
            userIndexOfLastClaimedReward[marketIndex][user] <
                latestRewardIndex[marketIndex]
        );

        uint256 stakedLong =
            userAmountStaked[syntheticTokens[marketIndex].longToken][user];
        uint256 stakedShort =
            userAmountStaked[syntheticTokens[marketIndex].shortToken][user];

        if (stakedLong > 0) {
            uint256 accumDeltaLong =
                syntheticRewardParams[marketIndex][
                    latestRewardIndex[marketIndex]
                ]
                    .accumulativeFloatPerLongToken -
                    syntheticRewardParams[marketIndex][
                        userIndexOfLastClaimedReward[marketIndex][user]
                    ]
                        .accumulativeFloatPerLongToken;
            longFloatReward =
                (accumDeltaLong * stakedLong) /
                FLOAT_ISSUANCE_FIXED_DECIMAL;
        }

        if (stakedShort > 0) {
            uint256 accumDeltaShort =
                syntheticRewardParams[marketIndex][
                    latestRewardIndex[marketIndex]
                ]
                    .accumulativeFloatPerShortToken -
                    syntheticRewardParams[marketIndex][
                        userIndexOfLastClaimedReward[marketIndex][user]
                    ]
                        .accumulativeFloatPerShortToken;
            shortFloatReward =
                (accumDeltaShort * stakedShort) /
                FLOAT_ISSUANCE_FIXED_DECIMAL;
        }

        // explicit return
        return (longFloatReward, shortFloatReward);
    }

    function _mintFloat(address user, uint256 floatToMint) internal {
        floatToken.mint(user, floatToMint);
        floatToken.mint(floatCapital, (floatToMint * floatPercentage) / 10000);
    }

    function mintAccumulatedFloat(uint32 marketIndex, address user) internal {
        // NOTE: Could merge these two values already inside the `calculateAccumulatedFloat` function, but that would make it harder for the graph
        (uint256 floatToMintLong, uint256 floatToMintShort) =
            calculateAccumulatedFloat(marketIndex, msg.sender);

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

    function _claimFloat(uint32[] calldata marketIndex) internal {
        uint256 floatTotal = 0;
        for (uint256 i = 0; i < marketIndex.length; i++) {
            // NOTE: Could merge these two values already inside the `calculateAccumulatedFloat` function, but that would make it harder for the graph
            (uint256 floatToMintLong, uint256 floatToMintShort) =
                calculateAccumulatedFloat(marketIndex[i], msg.sender);

            uint256 floatToMint = floatToMintLong + floatToMintShort;

            if (floatToMint > 0) {
                // Set the user has claimed up until now.
                userIndexOfLastClaimedReward[marketIndex[i]][
                    msg.sender
                ] = latestRewardIndex[marketIndex[i]];
                floatTotal += floatToMint;

                emit FloatMinted(
                    msg.sender,
                    marketIndex[i],
                    floatToMintLong,
                    floatToMintShort,
                    latestRewardIndex[marketIndex[i]]
                );
            }
        }
        if (floatTotal > 0) {
            _mintFloat(msg.sender, floatTotal);
        }
    }

    function claimFloatCustom(uint32[] calldata marketIndexes) external {
        require(marketIndexes.length <= 50); // Set some (arbitrary) limit on loop length
        longShortCoreContract._updateSystemStateMulti(marketIndexes);
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
        _updateState(ISyntheticToken(msg.sender));
        _stake(ISyntheticToken(msg.sender), amount, from);
    }

    /*
     * Called by the float contract when a user mints and immediately stakes
     * Updating the state is not necessary since this would have just been done
     * during the minting process
     */
    function stakeFromMint(
        ISyntheticToken token,
        uint256 amount,
        address user
    ) external override onlyFloat() onlyValidSynthetic(token) {
        _stake(token, amount, user);
    }

    function _stake(
        ISyntheticToken token,
        uint256 amount,
        address user
    ) internal {
        uint32 marketIndex = marketIndexOfToken[token];

        // If they already have staked and have rewards due, mint these.
        if (
            // userAmountStaked[token][user] > 0 &&
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

        token.transfer(msg.sender, amount);

        emit StakeWithdrawn(msg.sender, address(token), amount);
    }

    function withdraw(ISyntheticToken token, uint256 amount) external {
        _updateState(token);
        _withdraw(token, amount);
    }

    function withdrawAll(ISyntheticToken token) external {
        _updateState(token);
        _withdraw(token, userAmountStaked[token][msg.sender]);
    }
}
