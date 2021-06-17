pragma solidity 0.8.3;

import "./generated/LongShortMockable.sol";

/*
NOTE: This contract is for testing purposes only!
*/

contract LongShortInternalsExposed is LongShortMockable {
    bool overRideexecuteOutstandingNextPriceSettlements;

    event executeOutstandingNextPriceSettlementsMock(
        address _user,
        uint32 _marketIndex
    );

    function setInitializeMarketParams(
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
        syntheticTokens[marketIndex][MarketSide.Long] = ISyntheticToken(
            longAddress
        );
        syntheticTokens[marketIndex][MarketSide.Short] = ISyntheticToken(
            shortAddress
        );
    }

    function setUseexecuteOutstandingNextPriceSettlementsMock(
        bool shouldUseMock
    ) public {
        overRideexecuteOutstandingNextPriceSettlements = shouldUseMock;
    }

    function _executeOutstandingNextPriceSettlementsMock(
        address _user,
        uint32 _marketIndex
    ) internal {
        emit executeOutstandingNextPriceSettlementsMock(_user, _marketIndex);
    }

    modifier executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex
    ) override {
        if (overRideexecuteOutstandingNextPriceSettlements) {
            // TODO: put a mock here?
            _executeOutstandingNextPriceSettlementsMock(user, marketIndex);
        } else {
            _executeOutstandingNextPriceSettlements(user, marketIndex);
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

    function _executeOutstandingNextPriceSettlementsExposed(
        address user,
        uint32 marketIndex
    ) external {
        _executeOutstandingNextPriceSettlements(user, marketIndex);
    }
}
