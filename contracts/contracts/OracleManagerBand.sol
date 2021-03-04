//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";

import "./interfaces/IOracleManager.sol";
import "./interfaces/IBandOracle.sol";

/*
 * Implementation of an OracleManager that fetches prices from a band oracle.
 */
contract OracleManagerBand is IOracleManager, Initializable {
    // Admin addresses.
    address public admin;

    // Global state.
    IBandOracle public bandOracle;
    string public base; // base pair for prices
    string public quote; // quote pair for prices

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

    function setup(
        address _admin,
        address _bandOracle,
        string memory _base,
        string memory _quote
    ) public initializer {
        admin = _admin;
        base = _base;
        quote = _quote;

        bandOracle = IBandOracle(_bandOracle);
    }

    ////////////////////////////////////
    /// MULTISIG ADMIN FUNCTIONS ///////
    ////////////////////////////////////

    function changeAdmin(address _admin) external adminOnly {
        admin = _admin;
    }

    ////////////////////////////////////
    ///// IMPLEMENTATION ///////////////
    ////////////////////////////////////

    function getLatestPrice() public view override returns (int256) {
        IBandOracle.ReferenceData memory data =
            bandOracle.getReferenceData(base, quote);

        return int256(data.rate);
    }
}
