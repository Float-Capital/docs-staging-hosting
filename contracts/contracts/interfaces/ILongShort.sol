// SPDX-License-Identifier: MIT

pragma solidity 0.8.2;

contract ILongShort {
    function redeemLong(uint32 marketIndex, uint256 tokensToRedeem)
        external
        virtual
    {}

    function redeemShort(uint32 marketIndex, uint256 tokensToRedeem)
        external
        virtual
    {}
}
