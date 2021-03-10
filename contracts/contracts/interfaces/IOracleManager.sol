// SPDX-License-Identifier: MIT

pragma solidity 0.8.2;

/*
 * Manages price feeds from different oracle implementations.
 */
interface IOracleManager {
    function updatePrice() external virtual;

    /*
     *Returns the latest price from the oracle feed.
     */
    function getLatestPrice() external view virtual returns (int256);
}
