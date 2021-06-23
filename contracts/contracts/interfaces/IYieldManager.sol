// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

/*
 * Manages yield accumulation for the LongShort contract. Each market is
 * deployed with its own yield manager to simplify the bookkeeping, as
 * different markets may share an underlying fund token.
 */
abstract contract IYieldManager {
    /*
     * Deposits the given amount of tokens into this yield manager.
     */
    function depositToken(uint256 amount) public virtual;

    /*
     * Withdraws the given amount of tokens from this yield manager.
     *
     * TODO(guy): at some point we should support withdrawing the
     *   underlying yield tokens if the protocol we use doesn't have
     *   enough liquidity.
     */
    function withdrawToken(uint256 amount) public virtual;

    /*
     *  Withdraw erc20 token to the treasury contract (WMATIC)
     */
    function withdrawErc20TokenToTreasury(address erc20Token) external virtual;

    /*
     * Returns the total amount of collateral that was provided, plus
     * the amount of yield that has been generated AND realized
     * through the claimYieldAndGetMarketAmount function.
     */
    function getTotalValueRealized() public virtual view
        returns (uint256 totalValueRealized);

    /*
     * Returns the total amount of yield that is owed to the treasury.
     */
    function getTotalReservedForTreasury() public virtual view
        returns (uint256 totalValueReservedForTreasury);

    /*
     * Calculate the amount of yield that has yet to be claimed,
     * note how much is reserved for the treasury and return how
     * much is reserved for the market. The yield is split between
     * the market and the treasury so treasuryPcnt = 1 - marketPcnt.
     */
    function claimYieldAndGetMarketAmount(uint256 marketPcntE5) public virtual
        returns (uint256 marketAmount);

    /*
     * Transfer tokens owed to the treasury to the treasury.
     */
    function withdrawTreasuryFunds() external virtual;

    /*
     * Returns the total token value held by this yield manager.
     */
    function getTotalHeld() public virtual returns (uint256 amount);

    /*
     * Returns the token held by this yield manager.
     */
    function getHeldToken() public view virtual returns (address token);
}
