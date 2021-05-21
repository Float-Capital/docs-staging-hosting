// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "../Staker.sol";
import "../interfaces/ISyntheticToken.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract StakerInternalsExposed is Staker {
    ///////////////////////////////////////////////
    //////////// Test Helper Functions ////////////
    ///////////////////////////////////////////////
    function setFloatRewardCalcParams(
        ISyntheticToken token,
        uint256 newLatestRewardIndex,
        address user,
        uint256 usersLatestClaimedReward,
        uint256 accumulativeFloatPerTokenLatest,
        uint256 accumulativeFloatPerTokenUser,
        uint256 newUserAmountStaked
    ) public {
        latestRewardIndex[token] = newLatestRewardIndex;
        userIndexOfLastClaimedReward[token][user] = usersLatestClaimedReward;

        syntheticRewardParams[token][newLatestRewardIndex]
            .accumulativeFloatPerToken = accumulativeFloatPerTokenLatest;

        syntheticRewardParams[token][usersLatestClaimedReward]
            .accumulativeFloatPerToken = accumulativeFloatPerTokenUser;

        userAmountStaked[token][user] = newUserAmountStaked;
    }

    ///////////////////////////////////////////
    //////////// EXPOSED Functions ////////////
    ///////////////////////////////////////////
    function calculateAccumulatedFloatExposed(
        ISyntheticToken token,
        address user
    ) external returns (uint256) {
        return calculateAccumulatedFloat(token, user);
    }

    function calculateNewCumulativeExternal(
        uint256 longValue,
        uint256 shortValue,
        uint256 tokenPrice,
        ISyntheticToken token, // either long or short token address
        bool isLong // tells us which one
    ) external returns (uint256) {
        calculateNewCumulative(
            longValue,
            shortValue,
            tokenPrice,
            token,
            isLong
        );
    }

    function mintAccumulatedFloatExternal(ISyntheticToken token, address user)
        external
    {
        mintAccumulatedFloat(token, user);
    }

    // function calculateAccumulatedFloatExposed(uint32 marketIndex, address user)
    //     external
    //     returns (uint256, uint256)
    // {
    //     return calculateAccumulatedFloat(marketIndex, user);
    // }

    // function mintAccumulatedFloatExternal(uint32 marketIndex, address user)
    //     external
    // {
    //     mintAccumulatedFloat(marketIndex, user);
    // }

    function _mintFloatExternal(address user, uint256 floatToMint) external {
        _mintFloat(user, floatToMint);
    }

    function _withdrawExternal(ISyntheticToken token, uint256 amount) external {
        _withdraw(token, amount);
    }
}
