// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "../Staker.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract StakerInternalsExposed is Staker {
    function calculateAccumulatedFloatExposed(
        ISyntheticToken tokenAddress,
        address user
    ) external view returns (uint256) {
        return calculateAccumulatedFloat(tokenAddress, user);
    }
}
