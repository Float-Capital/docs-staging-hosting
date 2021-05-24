// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "../interfaces/IOracleManager.sol";

/**
  Contract that estimates BTC / ETH dominance.
  Currently estimates BTC / ETH supply. In the future can
  look towards using oracles for it. 
*/
contract OracleManagerFlippening is IOracleManager {
    address public admin; // This will likely be the Gnosis safe

    // Oracle price, changes by average of the underlying asset changes.
    int256 public indexPrice;

    uint256 public ethSupply; // 18 decimals
    uint256 public btcSupply; // 8 decimals

    int256 public ethPrice; // 8 decimals probably
    int256 public btcPrice; // 8 decimals probably

    uint256 public btcBlocksPerDay;
    uint256 public ethBlocksPerDay;

    uint256 public btcBlockReward; // 8 decimals
    uint256 public ethBlockReward; // 8 decimals

    uint256 public ethUnclesPerDay;

    uint256 public averageUncleReward; // 18 decimals

    // averageEthUncleReward = ethBlockReward * 75%
    //                         Variable uncle reward:
    //                          https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1234.md,
    //                        Source here says it's roughly 75% on average:
    //                         https://docs.ethhub.io/ethereum-basics/monetary-policy/
    uint256 public averageNephewReward; // 18 decimals currently = blockReward / 32

    uint80 lastUpdated;

    // Oracle addresses
    AggregatorV3Interface public btcOracle;
    AggregatorV3Interface public ethOracle;

    ////////////////////////////////////
    /////////// MODIFIERS //////////////
    ////////////////////////////////////

    modifier adminOnly() {
        require(msg.sender == admin);
        _;
    }

    ////////////////////////////////////
    ///// CONTRACT SET-UP //////////////
    ////////////////////////////////////

    constructor(
        address _admin,
        address _ethSupply,
        address _btcSupply,
        address _btcOracle,
        address _ethOracle
    ) {
        admin = _admin;
        btcOracle = AggregatorV3Interface(_btcOracle);
        ethOracle = AggregatorV3Interface(_ethOracle);
        // Initial asset prices.

        lastUpdated = block.timestamp;

        // Initial base index price.
        indexPrice = 1e18;
    }

    ////////////////////////////////////
    /// MULTISIG ADMIN FUNCTIONS ///////
    ////////////////////////////////////

    function changeAdmin(address _admin) external adminOnly {
        admin = _admin;
    }

    function changeAdmin(address _admin) external adminOnly {
        admin = _admin;
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
        (, int256 _tronPrice, , , ) = tronOracle.latestRoundData();
        (, int256 _eosPrice, , , ) = eosOracle.latestRoundData();
        (, int256 _xrpPrice, , , ) = xrpOracle.latestRoundData();
        return (_tronPrice, _eosPrice, _xrpPrice);
    }

    function updatePrice() external override returns (int256) {
        (int256 newTronPrice, int256 newEosPrice, int256 newXrpPrice) =
            _getAssetPrices();

        int256 valueOfChangeInIndex =
            (int256(indexPrice) *
                (_calcAbsolutePercentageChange(newTronPrice, tronPrice) +
                    _calcAbsolutePercentageChange(newEosPrice, eosPrice) +
                    _calcAbsolutePercentageChange(newXrpPrice, xrpPrice))) /
                (3 * 1e18);

        tronPrice = newTronPrice;
        eosPrice = newEosPrice;
        xrpPrice = newXrpPrice;

        indexPrice = indexPrice + valueOfChangeInIndex;

        return indexPrice;
    }

    function _calcAbsolutePercentageChange(int256 newPrice, int256 basePrice)
        internal
        pure
        returns (int256)
    {
        return ((newPrice - basePrice) * (1e18)) / (basePrice);
    }

    function getLatestPrice() external view override returns (int256) {
        return indexPrice;
    }
}
