// SPDX-License-Identifier: MIT

pragma solidity 0.8.2;

contract ILongShort {
    function redeemLong(uint256 marketIndex, uint256 tokensToRedeem)
        external
        virtual
    {}

    function redeemShort(uint256 marketIndex, uint256 tokensToRedeem)
        external
        virtual
    {}
}
