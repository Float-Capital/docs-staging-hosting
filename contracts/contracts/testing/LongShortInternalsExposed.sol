pragma solidity 0.8.3;

import "../LongShort.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract LongShortInternalsExposed is LongShort {
    bool overRideExecuteOutstandingLazyDeposits;

    event ExecuteOutstandingLazyDepositsMock(
        address _user,
        uint32 _marketIndex
    );

    function setUseExecuteOutstandingLAzyDepositsMock(bool shouldUseMock)
        public
    {
        overRideExecuteOutstandingLazyDeposits = shouldUseMock;
    }

    function _executeOutstandingLazyDepositsMock(
        address _user,
        uint32 _marketIndex
    ) internal {
        emit ExecuteOutstandingLazyDepositsMock(_user, _marketIndex);
    }

    modifier executeOutstandingLazyDeposits(address user, uint32 marketIndex)
        override {
        if (overRideExecuteOutstandingLazyDeposits) {
            // TODO: put a mock here?
            _executeOutstandingLazyDepositsMock(user, marketIndex);
        } else {
            _executeOutstandingLazyDeposits(user, marketIndex);
        }

        _;
    }

    function refreshTokensPrice(uint32 marketIndex) external {
        _refreshTokensPrice(marketIndex);
    }

    function feesMechanism(uint32 marketIndex, uint256 totalFees) external {
        _feesMechanism(marketIndex, totalFees);
    }

    function yieldMechanism(uint32 marketIndex) external {
        _yieldMechanism(marketIndex);
    }

    function minimum(uint256 liquidityOfPositionA, uint256 liquidityOfPositionB)
        external
        view
        returns (uint256)
    {
        _minimum(liquidityOfPositionA, liquidityOfPositionB);
    }

    function calculateValueChangeForPriceMechanism(
        uint32 marketIndex,
        uint256 assetPriceGreater,
        uint256 assetPriceLess,
        uint256 baseValueExposure
    ) external view returns (uint256) {
        _calculateValueChangeForPriceMechanism(
            marketIndex,
            assetPriceGreater,
            assetPriceLess,
            baseValueExposure
        );
    }

    function depositFunds(uint32 marketIndex, uint256 amount) external {
        _depositFunds(marketIndex, amount);
    }

    function withdrawFunds(uint32 marketIndex, uint256 amount) external {
        _withdrawFunds(marketIndex, amount);
    }

    function transferToYieldManager(uint32 marketIndex, uint256 amount)
        external
    {
        _transferToYieldManager(marketIndex, amount);
    }

    function transferFromYieldManager(uint32 marketIndex, uint256 amount)
        external
    {
        _transferFromYieldManager(marketIndex, amount);
    }

    function getFeesForAmounts(
        uint32 marketIndex,
        uint256 baseAmount, // e18
        uint256 penaltyAmount, // e18
        bool isMint // true for mint, false for redeem
    ) external view returns (uint256) {
        _getFeesForAmounts(marketIndex, baseAmount, penaltyAmount, isMint);
    }

    function getFeesForAction(
        uint32 marketIndex,
        uint256 amount, // 1e18
        bool isMint, // true for mint, false for redeem
        bool isLong // true for long side, false for short side
    ) external view returns (uint256) {
        _getFeesForAction(marketIndex, amount, isMint, isLong);
    }

    function priceChangeMechanism(uint32 marketIndex, uint256 newPrice)
        external
        returns (bool didUpdate)
    {
        _priceChangeMechanism(marketIndex, newPrice);
    }
}
