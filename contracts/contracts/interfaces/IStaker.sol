//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;

abstract contract IStaker {
    function addNewStakingFund(
        uint256 marketIndex,
        address longTokenAddress,
        address shortTokenAddress
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
