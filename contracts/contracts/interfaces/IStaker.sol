// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

abstract contract IStaker {
    function addNewStakingFund(
        uint32 marketIndex,
        address longTokenAddress,
        address shortTokenAddress,
        uint256 kInitialMultiplier,
        uint256 kPeriod
    ) external virtual;

    function addNewStateForFloatRewards(
        address longTokenAddress,
        address shortTokenAddress,
        uint256 longTokenPrice,
        uint256 shortTokenPrice,
        uint256 longValue,
        uint256 shortValue
    ) external virtual;

    function stakeTransferredTokens(
        address tokenAddress,
        uint256 amount,
        address user
    ) external virtual;

    function stakeDirect(address from, uint256 amount) public virtual;
}
