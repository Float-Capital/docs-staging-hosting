// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

abstract contract ILongShort {
    function redeemLong(uint32 marketIndex, uint256 tokensToRedeem)
        external
        virtual;

    function redeemShort(uint32 marketIndex, uint256 tokensToRedeem)
        external
        virtual;

    function _updateSystemState(uint32 marketIndex) external virtual;

    function _updateSystemStateMulti(uint32[] calldata marketIndex)
        external
        virtual;
}
