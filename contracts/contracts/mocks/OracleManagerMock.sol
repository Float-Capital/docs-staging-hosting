//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.2;

import "@openzeppelin/contracts-upgradeable/utils/Initializable.sol";

import "../interfaces/IOracleManager.sol";

/*
 * Mock implementation of an OracleManager with fixed, changeable prices.
 */
contract OracleManagerMock is IOracleManager, Initializable {
    // Admin contract.
    address public admin;

    // Global state.
    int256 currentPrice; // e18

    ////////////////////////////////////
    /////////// MODIFIERS //////////////
    ////////////////////////////////////

    modifier adminOnly() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    ////////////////////////////////////
    ///// CONTRACT SET-UP //////////////
    ////////////////////////////////////

    function setup(address _admin) public initializer {
        admin = _admin;

        // Default to a price of 1.
        currentPrice = 1e18;
    }

    ////////////////////////////////////
    ///// IMPLEMENTATION ///////////////
    ////////////////////////////////////

    function setPrice(int256 newPrice) public adminOnly {
        currentPrice = newPrice;
    }

    function updatePrice() external override {}

    function getLatestPrice() external view override returns (int256) {
        return currentPrice;
    }
}
