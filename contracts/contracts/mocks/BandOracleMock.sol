//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;
pragma abicoder v2;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/presets/ERC20PresetMinterPauserUpgradeable.sol";

import "../interfaces/IBandOracle.sol";

/*
 * BandOracleMock is an implementation of a Band oracle that allows prices
 * to be set arbitrarily for testing.
 */
contract BandOracleMock is IBandOracle, Initializable {
    using SafeMathUpgradeable for uint256;

    // Admin contracts.
    address public admin;

    // Global state.
    //   base -> quote -> price
    mapping(string => mapping(string => uint256)) pairRates; // e18

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
    }

    ////////////////////////////////////
    ///// IMPLEMENTATION ///////////////
    ////////////////////////////////////

    /*
     * Sets the mock rate for the given base/quote pair.
     */
    function setRate(
        string memory _base,
        string memory _quote,
        uint256 rate
    ) public {
        pairRates[_base][_quote] = rate;
    }

    /*
     * Returns rate data for given base/quote pair. Reverts if not available.
     */
    function getReferenceData(string memory _base, string memory _quote)
        external
        view
        override
        returns (IBandOracle.ReferenceData memory ref)
    {
        ref.lastUpdatedBase = block.timestamp;
        ref.lastUpdatedQuote = block.timestamp;
        ref.rate = pairRates[_base][_quote];
        require(ref.rate > 0);

        return ref;
    }

    /*
     * Batch version of getReferenceData(...).
     */
    function getReferenceDataBulk(
        string[] memory _bases,
        string[] memory _quotes
    ) external view override returns (IBandOracle.ReferenceData[] memory) {
        require(_bases.length == _quotes.length);

        IBandOracle.ReferenceData[] memory refs =
            new IBandOracle.ReferenceData[](_quotes.length);
        for (uint256 i = 0; i < _bases.length; i++) {
            refs[i] = this.getReferenceData(_bases[i], _quotes[i]);
        }

        return refs;
    }
}
