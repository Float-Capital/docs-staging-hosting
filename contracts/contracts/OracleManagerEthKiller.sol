//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;
pragma abicoder v2;

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
        (tronPrice, eosPrice, xrpPrice) = _getAssetPrices();

        // Initial base index price.
        indexPrice = 1e18;
    }

    ////////////////////////////////////
    ///// IMPLEMENTATION ///////////////
    ////////////////////////////////////

    function _getAssetPrices()
        internal
        view
        returns (
            int256,
            int256,
            int256
        )
    {
        string[] memory baseSymbols = new string[](3);
        baseSymbols[0] = "TRX"; // tron
        baseSymbols[1] = "EOS"; // eos
        baseSymbols[2] = "XRP"; // ripple

        string[] memory quoteSymbols = new string[](3);
        quoteSymbols[0] = "BUSD";
        quoteSymbols[1] = "BUSD";
        quoteSymbols[2] = "BUSD";

        IBandOracle.ReferenceData[] memory data =
            oracle.getReferenceDataBulk(baseSymbols, quoteSymbols);

        return (
            int256(data[0].rate),
            int256(data[1].rate),
            int256(data[2].rate)
        );
    }

    function _calculatePrice() internal {
        (int256 newTronPrice, int256 newEosPrice, int256 newXrpPrice) =
            _getAssetPrices();

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
        pure
        returns (int256)
    {
        return ((newPrice - basePrice) * (1e18)) / (basePrice);
    }

    function getLatestPrice() external returns (int256) {
        _calculatePrice();
        return indexPrice;
    }
}
