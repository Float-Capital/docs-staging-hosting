// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "./generated/StakerMockable.sol";
import "../interfaces/ISyntheticToken.sol";

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

    ///////////////////////////////////////////
    //////////// EXPOSED Functions ////////////
    ///////////////////////////////////////////
    function calculateAccumulatedFloatExposed(uint32 marketIndex, address user)
        external
        returns (uint256 longFloatReward, uint256 shortFloatReward)
    {
        return calculateAccumulatedFloat(marketIndex, user);
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
}
