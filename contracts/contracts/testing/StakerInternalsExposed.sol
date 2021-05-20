// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "../Staker.sol";
import "../interfaces/ISyntheticToken.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract StakerInternalsExposed is Staker {
    function calculateAccumulatedFloatExposed(uint32 marketIndex, address user)
        external
        returns (uint256, uint256)
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

    function _withdrawExternal(ISyntheticToken tokenAddress, uint256 amount)
        external
    {
        _withdraw(tokenAddress, amount);
    }
}
