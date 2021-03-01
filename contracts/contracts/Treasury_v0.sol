//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";

/** @title Treasury Contract */
contract Treasury_v0 is Initializable {
    using SafeMathUpgradeable for uint256;
    address public admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    function initialize(address _admin) public initializer {
        admin = _admin;
    }

    function changeAdmin(address _admin) external onlyAdmin {
        admin = _admin;
    }

    /** To be upgraded in future allowing goverenance of treasury 
    and function to buy and burn FLOAT off open market using DEX */
}
