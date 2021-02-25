//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/presets/ERC20PresetMinterPauserUpgradeable.sol";

import "./LongShort.sol";
import "./FloatToken.sol";
import "./interfaces/IStaker.sol";

/*
    ###### Purpose of contract ########
    This smart contract allows users to securely stake fTokens
    that represent their synthetic exposure.

    Staking sythentic tokens will ensure that the liquidity of the
    synthetic market is increased, and entitle users to FLOAT rewards.
*/

/** @title Staker Contract (name is WIP) */
contract Staker is IStaker, Initializable {
    using SafeMathUpgradeable for uint256;

    struct RewardState {
        uint256 timestamp;
        uint256 accumulativeFloatPerToken;
    }

    ////////////////////////////////////
    //////// CONSTANTS /////////////////
    ////////////////////////////////////

    // Controls the k-factor, a multiplier for incentivising early stakers.
    uint256 public constant K_FACTOR_PERIOD = 30 * 24 * 60 * 60; // secs
    uint256 public constant K_FACTOR_INITIAL = 5e18; // scale of e18

    ////////////////////////////////////
    //////// VARIABLES /////////////////
    ////////////////////////////////////

    // Global state.
    address public admin;
    uint256 public initialTimestamp;
    LongShort public floatContract;
    FloatToken public floatToken;

    // User state.
    // token -> user -> value
    mapping(address => mapping(address => uint256)) public userAmountStaked;
    mapping(address => mapping(address => uint256))
        public userIndexOfLastClaimedReward;

    // Token state.
    mapping(address => bool) syntheticValid; // token -> is valid?
    mapping(address => uint256) public marketIndexOfToken; // token -> market index
    mapping(address => mapping(uint256 => RewardState))
        public syntheticRewardParams; // token -> index -> state
    mapping(address => uint256) public latestRewardIndex; // token -> index

    ////////////////////////////////////
    /////////// EVENTS /////////////////
    ////////////////////////////////////

    event DeployV1(address floatToken);

    event StateAdded(
        address tokenAddress,
        uint256 stateIndex,
        uint256 timestamp,
        uint256 accumulative
    );

    event StakeAdded(
        address user,
        address tokenAddress,
        uint256 amount,
        uint256 lastMintIndex
    );

    event StakeWithdrawn(address user, address tokenAddress, uint256 amount);

    event FloatMinted(
        address user,
        address tokenAddress,
        uint256 amount,
        uint256 lastMintIndex
    );

    ////////////////////////////////////
    /////////// MODIFIERS //////////////
    ////////////////////////////////////

    modifier onlyAdmin() {
        require(msg.sender == admin, "not admin");
        _;
    }

    modifier onlyValidSynthetic(address _synthAddress) {
        require(syntheticValid[_synthAddress], "not valid synth");
        _;
    }

    modifier onlyFloat() {
        require(msg.sender == address(floatContract));
        _;
    }

    ////////////////////////////////////
    ///// CONTRACT SET-UP //////////////
    ////////////////////////////////////

    function initialize(
        address _admin,
        address _floatContract,
        address _floatToken
    ) public initializer {
        admin = _admin;
        initialTimestamp = block.timestamp;
        floatContract = LongShort(_floatContract);
        floatToken = FloatToken(_floatToken);

        emit DeployV1(_floatToken);
    }

    ////////////////////////////////////
    /// MULTISIG ADMIN FUNCTIONS ///////
    ////////////////////////////////////

    function changeAdmin(address _admin) external onlyAdmin {
        admin = _admin;
    }

    ////////////////////////////////////
    /////////// STAKING SETUP //////////
    ////////////////////////////////////

    function addNewStakingFund(
        uint256 marketIndex,
        address longTokenAddress,
        address shortTokenAddress
    ) external override onlyFloat {
        syntheticValid[longTokenAddress] = true;
        syntheticValid[shortTokenAddress] = true;
        marketIndexOfToken[longTokenAddress] = marketIndex;
        marketIndexOfToken[shortTokenAddress] = marketIndex;

        syntheticRewardParams[longTokenAddress][0].timestamp = block.timestamp;
        syntheticRewardParams[longTokenAddress][0]
            .accumulativeFloatPerToken = 0;

        syntheticRewardParams[shortTokenAddress][0].timestamp = block.timestamp;
        syntheticRewardParams[shortTokenAddress][0]
            .accumulativeFloatPerToken = 0;

        emit StateAdded(longTokenAddress, 0, block.timestamp, 0);
        emit StateAdded(shortTokenAddress, 0, block.timestamp, 0);
    }

    ////////////////////////////////////
    // GLOBAL REWARD STATE FUNCTIONS ///
    ////////////////////////////////////

    /*
     * Computes the current 'r' value, i.e. the number of float tokens a user
     * earns per second for every unit of value they've staked on a token.
     * The returned value has a fixed decimal scale of 1e18.
     */
    function calculateFloatPerSecond(
        uint256 longValue,
        uint256 shortValue,
        uint256 timestamp,
        bool isLong
    ) public view returns (uint256) {
        // Edge-case: no float is issued in an empty market.
        if (longValue == 0 && shortValue == 0) {
            return 0;
        }

        // A float issuance multiplier that starts high and decreases linearly
        // over time to a value of 1. This incentivises users to stake early.
        uint256 k = 1e18;
        if (timestamp - initialTimestamp <= K_FACTOR_PERIOD) {
            k =
                1e18 -
                ((K_FACTOR_INITIAL - 1e18) * (timestamp - initialTimestamp)) /
                K_FACTOR_PERIOD;
        }

        // Float is scaled by the percentage of the total market value held in
        // the opposite position. This incentivises users to stake on the
        // weaker position.
        if (isLong) {
            return (k * shortValue) / (longValue + shortValue);
        } else {
            return (k * longValue) / (longValue + shortValue);
        }
    }

    /*
     * Computes the time since last state point for the given token in seconds.
     */
    function calculateTimeDelta(address token) internal view returns (uint256) {
        return
            block.timestamp -
            syntheticRewardParams[token][latestRewardIndex[token]].timestamp;
    }

    /*
     * Computes new cumulative sum of 'r' value since last state point. We use
     * cumulative 'r' value to avoid looping during issuance.
     */
    function calculateNewCumulative(
        uint256 longValue,
        uint256 shortValue,
        address token,
        bool isLong
    ) internal view returns (uint256) {
        // Compute the current 'r' value for float issuance per second.
        uint256 floatPerSecond =
            calculateFloatPerSecond(
                longValue,
                shortValue,
                block.timestamp,
                isLong
            );

        // Compute time since last state point for the given token.
        uint256 timeDelta = calculateTimeDelta(token);

        // Compute new cumulative 'r' value total.
        return
            syntheticRewardParams[token][latestRewardIndex[token]]
                .accumulativeFloatPerToken
                .add(timeDelta.mul(floatPerSecond).div(1e18));
    }

    /*
     * Creates a new state point for the given token and updates indexes.
     */
    function setRewardObjects(
        uint256 longValue,
        uint256 shortValue,
        address token,
        bool isLong
    ) internal {
        uint256 newIndex = latestRewardIndex[token] + 1;

        // Set cumulative 'r' value on new state point.
        syntheticRewardParams[token][newIndex]
            .accumulativeFloatPerToken = calculateNewCumulative(
            longValue,
            shortValue,
            token,
            isLong
        );

        // Set timestamp on new state point.
        syntheticRewardParams[token][newIndex].timestamp = block.timestamp;

        // Update latest index to point to new state point.
        latestRewardIndex[token] = newIndex;

        emit StateAdded(
            token,
            newIndex,
            block.timestamp,
            syntheticRewardParams[token][newIndex].accumulativeFloatPerToken
        );
    }

    /*
     * Adds new state points for the given long/short tokens. Called by the
     * LongShort contract whenever there is a state change for a market.
     */
    function addNewStateForFloatRewards(
        address longToken,
        address shortToken,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    ) external override onlyFloat {
        // Only add a new state point if some time has passed.
        if (calculateTimeDelta(longToken) > 0) {
            setRewardObjects(longValue, shortValue, longToken, true);
            setRewardObjects(longValue, shortValue, shortToken, false);
        }
    }

    ////////////////////////////////////
    // USER REWARD STATE FUNCTIONS ///
    ////////////////////////////////////

    function calculateAccumulatedFloat(address tokenAddress, address user)
        internal
        returns (uint256)
    {
        // Don't let users accumulate float immediately after staking, before
        // the next reward state is indexed.
        if (
            userIndexOfLastClaimedReward[tokenAddress][user] >=
            latestRewardIndex[tokenAddress]
        ) {
            return 0;
        }

        uint256 accumDelta =
            syntheticRewardParams[tokenAddress][latestRewardIndex[tokenAddress]]
                .accumulativeFloatPerToken
                .sub(
                syntheticRewardParams[tokenAddress][
                    userIndexOfLastClaimedReward[tokenAddress][user]
                ]
                    .accumulativeFloatPerToken
            );

        return accumDelta * userAmountStaked[tokenAddress][user];
    }

    function mintAccumulatedFloat(address tokenAddress, address user) internal {
        uint256 floatToMint = calculateAccumulatedFloat(tokenAddress, user);

        if (floatToMint > 0) {
            // stops them setting this forward
            userIndexOfLastClaimedReward[tokenAddress][
                user
            ] = latestRewardIndex[tokenAddress];

            floatToken.mint(user, floatToMint);

            emit FloatMinted(
                user,
                tokenAddress,
                floatToMint,
                latestRewardIndex[tokenAddress]
            );
        }
    }

    function claimFloat(address[] memory tokenAddresses) external {
        require(tokenAddresses.length <= 15); // Set some limit on loop length
        uint256 floatTotal = 0;
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            uint256 floatToMint =
                calculateAccumulatedFloat(tokenAddresses[i], msg.sender);

            if (floatToMint > 0) {
                // Set the user has claimed up until now.
                userIndexOfLastClaimedReward[tokenAddresses[i]][
                    msg.sender
                ] = latestRewardIndex[tokenAddresses[i]];

                floatTotal += floatToMint;

                emit FloatMinted(
                    msg.sender,
                    tokenAddresses[i],
                    floatToMint,
                    latestRewardIndex[tokenAddresses[i]]
                );
            }
        }
        if (floatTotal > 0) {
            floatToken.mint(msg.sender, floatTotal);
        }
    }

    ////////////////////////////////////
    /////////// STAKING ////////////////
    ////////////////////////////////////

    /*
    Staking function.
    User can stake (flexibly) and start earning float rewards.
    Only approved float synthetic tokens can be staked.
    Users can call this same function to "top-up" their stake.
    */
    function stakeDirect(address from, uint256 amount)
        public
        override
        onlyValidSynthetic(msg.sender)
    {
        _stake(msg.sender, amount, from, true);
    }

    /*
    Staking function.
    User can stake (flexibly) and start earning float rewards.
    Only approved float synthetic tokens can be staked.
    Users can call this same function to "top-up" their stake.
    */
    function stake(address tokenAddress, uint256 amount)
        public
        onlyValidSynthetic(tokenAddress)
    {
        _stake(tokenAddress, amount, msg.sender, false);
        emit StakeAdded(
            msg.sender,
            tokenAddress,
            amount,
            userIndexOfLastClaimedReward[tokenAddress][msg.sender]
        );
    }

    /*
    Staking function.
    This is a more gas heavy staking function.
    It ensures the user starts earning FLOAT immediately 
    As opposed to from the next state point generated.
    */
    function stakeAndEarnImmediately(address tokenAddress, uint256 amount)
        external
        onlyValidSynthetic(tokenAddress)
    {
        //First update state.
        floatContract._updateSystemState(marketIndexOfToken[tokenAddress]);

        // Stake for user.
        stake(tokenAddress, amount);

        // Now we can set the users reward state to the just created state.
        userIndexOfLastClaimedReward[tokenAddress][
            msg.sender
        ] = latestRewardIndex[tokenAddress];
        emit StakeAdded(
            msg.sender,
            tokenAddress,
            amount,
            userIndexOfLastClaimedReward[tokenAddress][msg.sender]
        );
    }

    /**
     * Stake tokens that have already been minted for the staker
     */
    function stakeTransferredTokens(
        address tokenAddress,
        uint256 amount,
        address user
    ) external override onlyFloat() onlyValidSynthetic(tokenAddress) {
        _stake(tokenAddress, amount, user, true);

        // system state is already updated on the float side
        userIndexOfLastClaimedReward[tokenAddress][user] = latestRewardIndex[
            tokenAddress
        ];
        emit StakeAdded(
            user,
            tokenAddress,
            amount,
            userIndexOfLastClaimedReward[tokenAddress][user]
        );
    }

    function _stake(
        address tokenAddress,
        uint256 amount,
        address user,
        bool alreadyTransferred
    ) internal {
        if (!alreadyTransferred) {
            ERC20PresetMinterPauserUpgradeable(tokenAddress).transferFrom(
                user,
                address(this),
                amount
            );
        }

        // If they already have staked, calculate and award them their float.
        if (userAmountStaked[tokenAddress][user] > 0) {
            if (
                userIndexOfLastClaimedReward[tokenAddress][user] <
                latestRewardIndex[tokenAddress]
            ) {
                mintAccumulatedFloat(tokenAddress, user);
            }
        }

        userAmountStaked[tokenAddress][user] = userAmountStaked[tokenAddress][
            user
        ]
            .add(amount);

        // This currently disavatages people who top-up?
        // Since they have capital locked that will skip a state of earning.
        // This is very difficult for the top up case. Unless they create a state point,
        // There is going to need to be some system compromise.
        userIndexOfLastClaimedReward[tokenAddress][user] =
            latestRewardIndex[tokenAddress] +
            1;
    }

    ////////////////////////////////////
    /////// WITHDRAW n MINT ////////////
    ////////////////////////////////////

    /*
    Withdraw function.
    Mint user any outstanding float before
    */
    function withdraw(address tokenAddress, uint256 amount) external {
        require(
            userAmountStaked[tokenAddress][msg.sender] > 0,
            "nothing to withdraw"
        );
        // Note when withdrawing, they will only accumulate float tokens up until the last
        // state point that has been created. This is acceptable.
        mintAccumulatedFloat(tokenAddress, msg.sender);

        userAmountStaked[tokenAddress][msg.sender] = userAmountStaked[
            tokenAddress
        ][msg.sender]
            .sub(amount);

        ERC20PresetMinterPauserUpgradeable(tokenAddress).transfer(
            msg.sender,
            amount
        );

        emit StakeWithdrawn(msg.sender, tokenAddress, amount);
    }
}
