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

    function mintAccumulatedFloatExternal(address tokenAddress, address user)
        external
    {
        mintAccumulatedFloat(tokenAddress, user);
    }

    function _mintFloatExternal(address user, uint256 floatToMint) external {
        _mintFloat(user, floatToMint);
    }

    function _withdrawExternal(address tokenAddress, uint256 amount) external {
        _withdraw(tokenAddress, amount);
    }
}
