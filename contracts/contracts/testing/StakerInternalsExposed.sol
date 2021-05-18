// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "../Staker.sol";
import "../interfaces/ISyntheticToken.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract StakerInternalsExposed is Staker {
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

    function _withdrawExternal(ISyntheticToken tokenAddress, uint256 amount)
        external
    {
        _withdraw(tokenAddress, amount);
    }
}
