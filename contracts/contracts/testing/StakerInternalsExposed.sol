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

    function mintAccumulatedFloatExternal(ISyntheticToken token, address user)
        external
    {
        mintAccumulatedFloat(token, user);
    }

    function _mintFloatExternal(address user, uint256 floatToMint) external {
        _mintFloat(user, floatToMint);
    }

    function _withdrawExternal(ISyntheticToken token, uint256 amount) external {
        _withdraw(token, amount);
    }
}
