// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

abstract contract ILongShort {
    enum MarketSide {Long, Short}

    function _updateSystemState(uint32 marketIndex) external virtual;

    function _updateSystemStateMulti(uint32[] calldata marketIndex)
        external
        virtual;

    function getUsersPendingBalance(
        address user,
        uint32 marketIndex,
        MarketSide syntheticTokenType
    ) external view virtual returns (uint256 pendingBalance);

    function executeOutstandingLazySettlementsSynth(
        address user,
        uint32 marketIndex,
        MarketSide syntheticTokenType
    ) external virtual;
}
