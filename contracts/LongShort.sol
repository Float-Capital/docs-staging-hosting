//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@nomiclabs/buidler/console.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorInterface.sol";

contract LongShort {
    using SafeMath for uint256;
    // Oracle
    AggregatorInterface internal priceFeed;

    uint256 public totalValueLocked;
    int256 public longValue;
    int256 public shortValue;

    uint256 public longTokenPrice;
    uint256 public shortTokenPrice;
    int256 public assetPrice;

    /**
     * Necessary to update system state before any contract actions (deposits / withdraws)
     */
    modifier refreshSystemState() {
        _updateSystemState();
        _;
    }

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
     * Updates the value of the long and short sides within the system
     */
    function _updateSystemState() internal {
        int256 newPrice = getLatestPrice();
        int256 percentageChange;

        if (assetPrice == newPrice) {
            return; // If no new price update from oracle, proceed as normal
        }

        int256 valueChange = 0;
        // Long gains
        if (newPrice > assetPrice) {
            percentageChange = (newPrice - assetPrice) / assetPrice;
            if (getShortPercentageFilled() == 1) {
                valueChange = shortValue * percentageChange;
            } else {
                valueChange = longValue * percentageChange;
            }
            longValue = longValue + valueChange;
            shortValue = shortValue - valueChange; // NB Check for going below zero and system instability
        } else {
            percentageChange = (assetPrice - newPrice) / assetPrice;
            if (getShortPercentageFilled() == 1) {
                valueChange = shortValue * percentageChange;
            } else {
                valueChange = longValue * percentageChange;
            }
            longValue = longValue - valueChange;
            shortValue = shortValue + valueChange;
        }

        assetPrice = newPrice;
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

    /**
     * Returns % of long position that is filled
     */
    function getLongPercentageFilled() public view returns (int256) {
        if (shortValue >= longValue) {
            return 1;
        } else {
            return shortValue / (longValue);
        }
    }

    /**
     * Returns % of short position that is filled
     * zero div  error if both are zero
     */
    function getShortPercentageFilled() public view returns (int256) {
        if (longValue >= shortValue) {
            return 1;
        } else {
            return longValue / (shortValue);
        }
    }
}
