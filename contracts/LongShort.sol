//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@nomiclabs/buidler/console.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorInterface.sol";

contract LongShort {
    AggregatorInterface internal priceFeed;

    /**
     * Network: Kovan
     * Aggregator: ETH/USD
     * Address: 0xD21912D8762078598283B14cbA40Cb4bFCb87581
     */
    constructor() public {
        priceFeed = AggregatorInterface(
            0xD21912D8762078598283B14cbA40Cb4bFCb87581
        );
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int256) {
        return priceFeed.latestAnswer();
    }

    /**
     * Returns the timestamp of the latest price update
     */
    function getLatestPriceTimestamp() public view returns (uint256) {
        return priceFeed.latestTimestamp();
    }
}
