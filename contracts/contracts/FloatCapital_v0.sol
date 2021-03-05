//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.2;

import "@openzeppelin/contracts-upgradeable/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

/** @title Float Capital Contract */
contract FloatCapital_v0 is Initializable {
    using SafeMathUpgradeable for uint256;
    address public admin;

    ////////////////////////////////////
    /////////// MODIFIERS //////////////
    ////////////////////////////////////

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    ////////////////////////////////////
    ///// CONTRACT SET-UP //////////////
    ////////////////////////////////////

    function initialize(address _admin) public initializer {
        admin = _admin;
    }

    ////////////////////////////////////
    /// MULTISIG ADMIN FUNCTIONS ///////
    ////////////////////////////////////

    function changeAdmin(address _admin) external onlyAdmin {
        admin = _admin;
    }

    /** Small percentage of float token to accrue here for project
     development */
}
