pragma solidity 0.8.3;

import "./generated/LongShortMockable.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract LongShortInternalsExposed is LongShortMockable {
    bool overRideexecuteOutstandingLazySettlements;

    event executeOutstandingLazySettlementsMock(
        address _user,
        uint32 _marketIndex
    );

    function setAddNewStakingFundParams(
        uint32 marketIndex,
        bool marketIndexValue,
        uint32 _latestMarket,
        address _staker,
        address longAddress,
        address shortAddress
    ) public {
        latestMarket = _latestMarket;
        marketExists[marketIndex] = marketIndexValue;
        staker = IStaker(_staker);
        syntheticTokens[MarketSide.Long][marketIndex] = ISyntheticToken(
            longAddress
        );
        syntheticTokens[MarketSide.Short][marketIndex] = ISyntheticToken(
            shortAddress
        );
    }

    function setUseexecuteOutstandingLazySettlementsMock(bool shouldUseMock)
        public
    {
        overRideexecuteOutstandingLazySettlements = shouldUseMock;
    }

    function _executeOutstandingLazySettlementsMock(
        address _user,
        uint32 _marketIndex
    ) internal {
        emit executeOutstandingLazySettlementsMock(_user, _marketIndex);
    }

    modifier executeOutstandingLazySettlements(address user, uint32 marketIndex)
        override {
        if (overRideexecuteOutstandingLazySettlements) {
            // TODO: put a mock here?
            _executeOutstandingLazySettlementsMock(user, marketIndex);
        } else {
            _executeOutstandingLazySettlements(user, marketIndex);
        }

        _;
    }

    function refreshTokenPrices(uint32 marketIndex) external {
        _refreshTokenPrices(marketIndex);
    }

    function feesMechanism(uint32 marketIndex, uint256 totalFees) external {
        _feesMechanism(marketIndex, totalFees);
    }

    function claimAndDistributeYield(uint32 marketIndex) external {
        _claimAndDistributeYield(marketIndex);
    }

    function minimum(uint256 liquidityOfPositionA, uint256 liquidityOfPositionB)
        external
        view
        returns (uint256)
    {
        _minimum(liquidityOfPositionA, liquidityOfPositionB);
    }

    function depositFunds(uint32 marketIndex, uint256 amount) external {
        _depositFunds(marketIndex, amount);
    }

    function withdrawFunds(
        uint32 marketIndex,
        uint256 amountLong,
        uint256 amountShort,
        address user
    ) external {
        _withdrawFunds(marketIndex, amountLong, amountShort, msg.sender);
    }

    function transferFundsToYieldManager(uint32 marketIndex, uint256 amount)
        external
    {
        _transferFundsToYieldManager(marketIndex, amount);
    }

    function transferFromYieldManager(uint32 marketIndex, uint256 amount)
        external
    {
        _transferFromYieldManager(marketIndex, amount);
    }

    function adjustMarketBasedOnNewAssetPrice(
        uint32 marketIndex,
        int256 newAssetPrice
    ) external returns (bool didUpdate) {
        _adjustMarketBasedOnNewAssetPrice(marketIndex, newAssetPrice);
    }

    function _executeOutstandingLazySettlementsExposed(
        address user,
        uint32 marketIndex
    ) external {
        _executeOutstandingLazySettlements(user, marketIndex);
    }
}
