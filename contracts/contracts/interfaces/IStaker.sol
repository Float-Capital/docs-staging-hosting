// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "./ISyntheticToken.sol";

abstract contract IStaker {
    function addNewStakingFund(
        uint32 marketIndex,
        ISyntheticToken longTokenAddress,
        ISyntheticToken shortTokenAddress,
        uint256 kInitialMultiplier,
        uint256 kPeriod
    ) external virtual;

    function addNewStateForFloatRewards(
        ISyntheticToken longTokenAddress,
        ISyntheticToken shortTokenAddress,
        uint256 longTokenPrice,
        uint256 shortTokenPrice,
        uint256 longValue,
        uint256 shortValue
    ) external virtual;

    function stakeFromMint(
        ISyntheticToken tokenAddress,
        uint256 amount,
        address user
    ) external virtual;

    function stakeFromUser(address from, uint256 amount) public virtual;
}
