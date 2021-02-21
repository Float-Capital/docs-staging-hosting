//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

import "./interfaces/IBandOracle.sol";

contract OracleManagerEthKiller is Initializable {
    address public admin; // This will likely be the Gnosis safe

    // Oracle price, changes by average of the underlying asset changes.
    int256 public indexPrice;

    // Underlying asset prices.
    int256 public tronPrice;
    int256 public eosPrice;
    int256 public xrpPrice;

    // Band oracle address.
    IBandOracle public oracle;

    ////////////////////////////////////
    ///// CONTRACT SET-UP //////////////
    ////////////////////////////////////

    function setup(address _admin, address _bandOracle) public initializer {
        admin = _admin;
        oracle = IBandOracle(_bandOracle);

        // Initial asset prices.
        tronPrice = _getAssetPrice(0);
        eosPrice = _getAssetPrice(1);
        xrpPrice = _getAssetPrice(2);

        // Initial base index price.
        indexPrice = 1e18;
    }

    ////////////////////////////////////
    ///// IMPLEMENTATION ///////////////
    ////////////////////////////////////

    function _getAssetPrice(uint256 index) internal returns (int256) {
        string memory base;
        if (index == 0) {
            base = "TRX"; // tron
        } else if (index == 1) {
            base = "EOS"; // eos
        } else {
            base = "XRP"; // ripple
        }

        IBandOracle.ReferenceData memory data =
            oracle.getReferenceData(base, "ETH");

        return int256(data.rate);
    }

    function _calculatePrice() internal {
        int256 newTronPrice = _getAssetPrice(0);
        int256 newEosPrice = _getAssetPrice(1);
        int256 newXrpPrice = _getAssetPrice(2);

        int256 valueOfChangeInIndex =
            (indexPrice *
                (_calcAbsolutePercentageChange(newTronPrice, tronPrice) +
                    _calcAbsolutePercentageChange(newEosPrice, eosPrice) +
                    _calcAbsolutePercentageChange(newXrpPrice, xrpPrice))) /
                (3 * 1e18);

        // Set new prices
        tronPrice = newTronPrice;
        eosPrice = newEosPrice;
        xrpPrice = newXrpPrice;

        // Set new index price
        indexPrice = indexPrice + valueOfChangeInIndex;
    }

    function _calcAbsolutePercentageChange(int256 newPrice, int256 basePrice)
        internal
        returns (int256)
    {
        return ((newPrice - basePrice) * (1e18)) / (basePrice);
    }

    function getLatestPrice() external returns (int256) {
        _calculatePrice();
        return indexPrice;
    }
}
