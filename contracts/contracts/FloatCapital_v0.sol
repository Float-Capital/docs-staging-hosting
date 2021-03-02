//SPDX-License-Identifier: Unlicense
pragma solidity 0.7.6;

import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";

/** @title Float Capital Contract */
contract FloatCapital_v0 is Initializable {
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

    /** Small percentage of float token to accrue here for project
     development */
}
