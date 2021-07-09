// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

/*
 * Manages yield accumulation for the LongShort contract. Each market is
 * deployed with its own yield manager to simplify the bookkeeping, as
 * different markets may share an underlying fund token.
 */
abstract contract IYieldManager {
    event WithdrawErc20TokenToTreasury(address erc20Token, uint256 amount);

    event YieldDistributed(uint256 unrealizedYield, uint256 treasuryPercentE18);

    // NOTE: This is purely saving some gas, but the subgraph will know how much is due for the treasury at all times - no need to include in event.
    event WithdrawTreasuryFunds();

    function totalReservedForTreasury() external virtual returns (uint256);

    /*
     * Deposits the given amount of tokens into this yield manager.
     */
    function depositPaymentToken(uint256 amount) public virtual;

    /*
     * Withdraws the given amount of tokens from this yield manager.
     *
     * TODO(guy): at some point we should support withdrawing the
     *   underlying yield tokens if the protocol we use doesn't have
     *   enough liquidity.
     */
    function withdrawPaymentToken(uint256 amount) public virtual;

    /*
     *  Withdraw erc20 token to the treasury contract (WMATIC)
     */
    function withdrawErc20TokenToTreasury(address erc20Token) external virtual;

    /*
     * Calculate the amount of yield that has yet to be claimed,
     * note how much is reserved for the treasury and return how
     * much is reserved for the market. The yield is split between
     * the market and the treasury so treasuryPercent = 1 - marketPercent.
     */
    function claimYieldAndGetMarketAmount(
        uint256 totalValueRealizedForMarket,
        uint256 treasuryPercentE18
    ) public virtual returns (uint256 marketAmount);

    /*
     * Transfer tokens owed to the treasury to the treasury.
     */
    function withdrawTreasuryFunds() external virtual;
}
