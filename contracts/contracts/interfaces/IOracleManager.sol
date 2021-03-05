//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.2;

/*
 * Manages price feeds from different oracle implementations.
 */
abstract contract IOracleManager {
    /*
     *Returns the latest price from the oracle feed.
     */
    function getLatestPrice() public view virtual returns (int256);
}
