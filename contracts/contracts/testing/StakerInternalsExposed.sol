// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "./generated/StakerMockable.sol";
import "../interfaces/ISyntheticToken.sol";
import "../interfaces/ILongShort.sol";
import "hardhat/console.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract StakerInternalsExposed is StakerMockable {
    ///////////////////////////////////////////////
    //////////// Test Helper Functions ////////////
    ///////////////////////////////////////////////
    function setFloatRewardCalcParams(
        uint32 marketIndex,
        ISyntheticToken longToken,
        ISyntheticToken shortToken,
        uint256 newLatestRewardIndex,
        address user,
        uint256 usersLatestClaimedReward,
        uint256 accumulativeFloatPerTokenLatestLong,
        uint256 accumulativeFloatPerTokenLatestShort,
        uint256 accumulativeFloatPerTokenUserLong,
        uint256 accumulativeFloatPerTokenUserShort,
        uint256 newUserAmountStakedLong,
        uint256 newUserAmountStakedShort
    ) public {
        latestRewardIndex[marketIndex] = newLatestRewardIndex;
        userIndexOfLastClaimedReward[marketIndex][
            user
        ] = usersLatestClaimedReward;
        syntheticTokens[marketIndex].longToken = longToken;
        syntheticTokens[marketIndex].shortToken = shortToken;

        syntheticRewardParams[marketIndex][newLatestRewardIndex]
        .accumulativeFloatPerLongToken = accumulativeFloatPerTokenLatestLong;

        syntheticRewardParams[marketIndex][usersLatestClaimedReward]
        .accumulativeFloatPerLongToken = accumulativeFloatPerTokenUserLong;

        syntheticRewardParams[marketIndex][newLatestRewardIndex]
        .accumulativeFloatPerShortToken = accumulativeFloatPerTokenLatestShort;

        syntheticRewardParams[marketIndex][usersLatestClaimedReward]
        .accumulativeFloatPerShortToken = accumulativeFloatPerTokenUserShort;

        userAmountStaked[longToken][user] = newUserAmountStakedLong;
        userAmountStaked[shortToken][user] = newUserAmountStakedShort;
    }

    function setAddNewStakingFundParams(
        uint32 marketIndex,
        ISyntheticToken longToken,
        ISyntheticToken shortToken,
        ISyntheticToken mockAddress
    ) public {
        marketIndexOfToken[longToken] = marketIndex;
        marketIndexOfToken[shortToken] = marketIndex;

        syntheticRewardParams[marketIndex][0].timestamp = 0; // don't test with 0
        syntheticRewardParams[marketIndex][0].accumulativeFloatPerLongToken = 1;
        syntheticRewardParams[marketIndex][0]
        .accumulativeFloatPerShortToken = 1;

        syntheticTokens[marketIndex].longToken = mockAddress;
        syntheticTokens[marketIndex].shortToken = mockAddress;
    }

    function setGetMarketLaunchIncentiveParametersParams(
        uint32 marketIndex,
        uint256 period,
        uint256 multiplier
    ) external {
        marketLaunchIncentivePeriod[marketIndex] = period;
        marketLaunchIncentiveMultipliers[marketIndex] = multiplier;
    }

    function setGetKValueParams(uint32 marketIndex, uint256 timestamp)
        external
    {
        syntheticRewardParams[marketIndex][0].timestamp = timestamp;
    }

    function setStakeFromUserParams(
        address longshort,
        ISyntheticToken token,
        uint32 marketIndexForToken
    ) external {
        longShortCoreContract = ILongShort(longshort);
        marketIndexOfToken[token] = marketIndexForToken;
    }

    function setCalculateTimeDeltaParams(
        uint32 marketIndex,
        uint256 latestRewardIndexForMarket,
        uint256 timestamp
    ) external {
        latestRewardIndex[marketIndex] = latestRewardIndexForMarket;
        syntheticRewardParams[marketIndex][latestRewardIndexForMarket]
        .timestamp = timestamp;
    }

    function setCalculateNewCumulativeRateParams(
        uint32 marketIndex,
        uint256 latestRewardIndexForMarket,
        uint256 accumFloatLong,
        uint256 accumFloatShort
    ) external {
        latestRewardIndex[marketIndex] = latestRewardIndexForMarket;
        syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
        .accumulativeFloatPerLongToken = accumFloatLong;

        syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
        .accumulativeFloatPerShortToken = accumFloatShort;
    }

    function setSetRewardObjectsParams(
        uint32 marketIndex,
        uint256 latestRewardIndexForMarket
    ) external {
        latestRewardIndex[marketIndex] = latestRewardIndexForMarket;
    }

    function set_updateStateParams(
        ILongShort longShort,
        ISyntheticToken token,
        uint32 tokenMarketIndex
    ) public {
        longShortCoreContract = longShort;
        marketIndexOfToken[token] = tokenMarketIndex;
    }

    function set_mintFloatParams(
        IFloatToken _floatToken,
        uint16 _floatPercentage
    ) public {
        floatToken = _floatToken;
        floatPercentage = _floatPercentage;
    }

    function setMintAccumulatedFloatAndClaimFloatParams(
        uint32 marketIndex,
        uint256 latestRewardIndexForMarket
    ) public {
        latestRewardIndex[marketIndex] = latestRewardIndexForMarket;
    }

    function setClaimFloatCustomParams(address longshort) external {
        longShortCoreContract = ILongShort(longshort);
    }

    function set_stakeParams(
        address user,
        uint32 marketIndex,
        uint256 _latestRewardIndex,
        ISyntheticToken token,
        uint256 _userAmountStaked,
        uint256 userLastRewardIndex
    ) external {
        marketIndexOfToken[token] = marketIndex;
        latestRewardIndex[marketIndex] = _latestRewardIndex;
        userAmountStaked[token][user] = _userAmountStaked;
        userIndexOfLastClaimedReward[marketIndex][user] = userLastRewardIndex;
    }

    ///////////////////////////////////////////
    //////////// EXPOSED Functions ////////////
    ///////////////////////////////////////////
    function calculateAccumulatedFloatExposed(uint32 marketIndex, address user)
        external
        returns (uint256 longFloatReward, uint256 shortFloatReward)
    {
        return calculateAccumulatedFloat(marketIndex, user);
    }

    function calculateFloatPerSecondExposed(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    )
        external
        view
        returns (uint256 longFloatPerSecond, uint256 shortFloatPerSecond)
    {
        return
            calculateFloatPerSecond(
                marketIndex,
                longPrice,
                shortPrice,
                longValue,
                shortValue
            );
    }

    function mintAccumulatedFloatExternal(uint32 marketIndex, address user)
        external
    {
        mintAccumulatedFloat(marketIndex, user);
    }

    function _mintFloatExternal(address user, uint256 floatToMint) external {
        _mintFloat(user, floatToMint);
    }

    function _withdrawExternal(ISyntheticToken token, uint256 amount) external {
        _withdraw(token, amount);
    }

    function _changeMarketLaunchIncentiveParametersExternal(
        uint32 marketIndex,
        uint256 period,
        uint256 initialMultiplier
    ) external {
        _changeMarketLaunchIncentiveParameters(
            marketIndex,
            period,
            initialMultiplier
        );
    }

    function getMarketLaunchIncentiveParametersExternal(uint32 marketIndex)
        external
        view
        returns (uint256, uint256)
    {
        return getMarketLaunchIncentiveParameters(marketIndex);
    }

    function calculateTimeDeltaExposed(uint32 marketIndex)
        external
        view
        returns (uint256)
    {
        return calculateTimeDelta(marketIndex);
    }

    function calculateNewCumulativeRateExposed(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    )
        external
        view
        returns (uint256 longCumulativeRates, uint256 shortCumulativeRates)
    {
        return
            calculateNewCumulativeRate(
                marketIndex,
                longPrice,
                shortPrice,
                longValue,
                shortValue
            );
    }

    function getKValueExternal(uint32 marketIndex)
        external
        view
        returns (uint256)
    {
        return getKValue(marketIndex);
    }

    function setRewardObjectsExternal(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    ) external {
        setRewardObjects(
            marketIndex,
            longPrice,
            shortPrice,
            longValue,
            shortValue
        );
    }

    function _claimFloatExternal(uint32[] calldata marketIndex) external {
        _claimFloat(marketIndex);
    }

    function _stakeExternal(
        ISyntheticToken token,
        uint256 amount,
        address user
    ) external {
        _stake(token, amount, user);
    }
}
