// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "./ISyntheticToken.sol";
import "./ILongShort.sol";

abstract contract IStaker {
    function addNewStakingFund(
        uint32 marketIndex,
        ISyntheticToken longTokenAddress,
        ISyntheticToken shortTokenAddress,
        uint256 kInitialMultiplier,
        uint256 kPeriod
    ) external virtual;

    function addNewStateForFloatRewards(
        uint32 marketIndex,
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

    function stakeFromMintBatched(
        uint32 marketIndex,
        uint256 amount,
        uint256 oracleUpdateIndex,
        ILongShort.MarketSide syntheticTokenType
    ) external virtual;

    function transferBatchStakeToUser(
        uint256 amountLong,
        uint256 amountShort,
        uint32 marketIndex,
        uint256 oracleUpdateIndex,
        address user
    ) external virtual;

    function stakeFromUser(address from, uint256 amount) public virtual;
}
