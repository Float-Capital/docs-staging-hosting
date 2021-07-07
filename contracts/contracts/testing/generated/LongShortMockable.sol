// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../../interfaces/ITokenFactory.sol";
import "../../interfaces/ISyntheticToken.sol";
import "../../interfaces/IStaker.sol";
import "../../interfaces/ILongShort.sol";
import "../../interfaces/IYieldManager.sol";
import "../../interfaces/IOracleManager.sol";





import "./LongShortForInternalMocking.sol";
contract LongShortMockable is ILongShort, Initializable {
  LongShortForInternalMocking mocker;
  bool shouldUseMock;
  string functionToNotMock;

  function setMocker(LongShortForInternalMocking _mocker) external {
    mocker = _mocker;
    shouldUseMock = true;
  }

  function setFunctionToNotMock(string calldata _functionToNotMock) external {
    functionToNotMock = _functionToNotMock;
  }


    


        address public constant DEAD_ADDRESS =
        0xf10A7_F10A7_f10A7_F10a7_F10A7_f10a7_F10A7_f10a7;
    uint256 public constant TEN_TO_THE_18 = 1e18;
    int256 public constant TEN_TO_THE_18_SIGNED = 1e18;
    uint256 public constant TEN_TO_THE_5 = 10000;
    uint256[45] private __constantsGap;

        address public admin;
    address public treasury;
    uint32 public latestMarket;

    IStaker public staker;
    ITokenFactory public tokenFactory;
    uint256[45] private __globalStateGap;

        mapping(uint32 => bool) public marketExists;
    mapping(uint32 => uint256) public assetPrice;
    mapping(uint32 => uint256) public marketUpdateIndex;
    mapping(uint32 => IERC20) public paymentTokens;
    mapping(uint32 => IYieldManager) public yieldManagers;
    mapping(uint32 => IOracleManager) public oracleManagers;

        mapping(uint32 => mapping(bool => ISyntheticToken)) public syntheticTokens;
    mapping(uint32 => mapping(bool => uint256)) public syntheticTokenPoolValue;

    mapping(uint32 => mapping(bool => mapping(uint256 => uint256)))
        public syntheticTokenPriceSnapshot;

    mapping(uint32 => mapping(bool => uint256))
        public batchedAmountOfTokensToDeposit;
    mapping(uint32 => mapping(bool => uint256))
        public batchedAmountOfSynthTokensToRedeem;

        mapping(uint32 => mapping(address => uint256))
        public userCurrentNextPriceUpdateIndex;

    mapping(uint32 => mapping(bool => mapping(address => uint256)))
        public userNextPriceDepositAmount;
    mapping(uint32 => mapping(bool => mapping(address => uint256)))
        public userNextPriceRedemptionAmount;

    


    event V1(
        address admin,
        address treasury,
        address tokenFactory,
        address staker
    );

        event SystemStateUpdated(
        uint32 marketIndex,
        uint256 updateIndex,
        int256 underlyingAssetPrice,
        uint256 longValue,
        uint256 shortValue,
        uint256 longPrice,
        uint256 shortPrice
    );

    event SyntheticTokenCreated(
        uint32 marketIndex,
        address longTokenAddress,
        address shortTokenAddress,
        address paymentToken,
        uint256 assetPrice,
        string name,
        string symbol,
        address oracleAddress
    );

    event PriceUpdate(
        uint32 marketIndex,
        uint256 oldPrice,
        uint256 newPrice,
        address user
    );

    event NextPriceRedeem(
        uint32 marketIndex,
        bool isLong,
        uint256 synthRedeemed,
        address user,
        uint256 oracleUpdateIndex
    );

    event NextPriceDeposit(
        uint32 marketIndex,
        bool isLong,
        uint256 depositAdded,
        address user,
        uint256 oracleUpdateIndex
    );

    event OracleUpdated(
        uint32 marketIndex,
        address oldOracleAddress,
        address newOracleAddress
    );

    event NewMarketLaunchedAndSeeded(uint32 marketIndex, uint256 initialSeed);

    event ExecuteNextPriceMintSettlementUser(
        address user,
        uint32 marketIndex,
        bool isLong,
        uint256 amount
    );

    event ExecuteNextPriceRedeemSettlementUser(
        address user,
        uint32 marketIndex,
        bool isLong,
        uint256 amount
    );

    event ExecuteNextPriceSettlementsUser(address user, uint32 marketIndex);

    


    


    modifier adminOnly() {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("adminOnly"))){
        
      mocker.adminOnlyMock();
      _;
    } else {
      
        require(msg.sender == admin, "only admin");
        _;
    
    }
  }

    modifier assertMarketExists(uint32 marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("assertMarketExists"))){
        
      mocker.assertMarketExistsMock(marketIndex);
      _;
    } else {
      
        require(marketExists[marketIndex], "market doesn't exist");
        _;
    
    }
  }

    modifier executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex
    ) virtual {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("executeOutstandingNextPriceSettlements"))){
        
      mocker.executeOutstandingNextPriceSettlementsMock(user,marketIndex);
      _;
    } else {
      
        _executeOutstandingNextPriceSettlements(user, marketIndex);
        _;
    
    }
  }

    modifier updateSystemStateMarket(uint32 marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("updateSystemStateMarket"))){
        
      mocker.updateSystemStateMarketMock(marketIndex);
      _;
    } else {
      
        _updateSystemStateInternal(marketIndex);

        _;
    
    }
  }

    


    function initialize(
        address _admin,
        address _treasury,
        ITokenFactory _tokenFactory,
        IStaker _staker
    ) public initializer {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("initialize"))){
      
      return mocker.initializeMock(_admin,_treasury,_tokenFactory,_staker);
    }
  
        admin = _admin;
        treasury = _treasury;
        tokenFactory = _tokenFactory;
        staker = _staker;

        emit V1(
            _admin,
            address(treasury),
            address(_tokenFactory),
            address(_staker)
        );
    }

    


    function changeAdmin(address _admin) external adminOnly {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("changeAdmin"))){
      
      return mocker.changeAdminMock(_admin);
    }
  
        admin = _admin;
    }

    function changeTreasury(address _treasury) external adminOnly {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("changeTreasury"))){
      
      return mocker.changeTreasuryMock(_treasury);
    }
  
        treasury = _treasury;
    }

    

    function updateMarketOracle(uint32 marketIndex, address _newOracleManager)
        external
        adminOnly
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("updateMarketOracle"))){
      
      return mocker.updateMarketOracleMock(marketIndex,_newOracleManager);
    }
  
                        address previousOracleManager = address(oracleManagers[marketIndex]);
        oracleManagers[marketIndex] = IOracleManager(_newOracleManager);
        emit OracleUpdated(
            marketIndex,
            previousOracleManager,
            _newOracleManager
        );
    }

    


    

    function newSyntheticMarket(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address _paymentToken,
        address _oracleManager,
        address _yieldManager
    ) external adminOnly {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("newSyntheticMarket"))){
      
      return mocker.newSyntheticMarketMock(syntheticName,syntheticSymbol,_paymentToken,_oracleManager,_yieldManager);
    }
  
        latestMarket++;

                syntheticTokens[latestMarket][true] = ISyntheticToken(
            tokenFactory.createTokenLong(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

                syntheticTokens[latestMarket][false] = ISyntheticToken(
            tokenFactory.createTokenShort(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

                paymentTokens[latestMarket] = IERC20(_paymentToken);
        yieldManagers[latestMarket] = IYieldManager(_yieldManager);
        oracleManagers[latestMarket] = IOracleManager(_oracleManager);
        assetPrice[latestMarket] = uint256(
            oracleManagers[latestMarket].updatePrice()
        );

                paymentTokens[latestMarket].approve(_yieldManager, type(uint256).max);

        emit SyntheticTokenCreated(
            latestMarket,
            address(syntheticTokens[latestMarket][true]),
            address(syntheticTokens[latestMarket][false]),
            _paymentToken,
            assetPrice[latestMarket],
            syntheticName,
            syntheticSymbol,
            _oracleManager
        );
    }

    function _seedMarketInitially(uint256 initialMarketSeed, uint32 marketIndex)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_seedMarketInitially"))){
      
      return mocker._seedMarketInitiallyMock(initialMarketSeed,marketIndex);
    }
  
        require(
                        initialMarketSeed > 0.1 ether,
            "Insufficient market seed"
        );

        _lockFundsInMarket(marketIndex, initialMarketSeed * 2);

        syntheticTokens[latestMarket][true].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );
        syntheticTokens[latestMarket][false].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );

        syntheticTokenPoolValue[marketIndex][true] = initialMarketSeed;
        syntheticTokenPoolValue[marketIndex][false] = initialMarketSeed;

        emit NewMarketLaunchedAndSeeded(marketIndex, initialMarketSeed);
    }

    function initializeMarket(
        uint32 marketIndex,
        uint256 kInitialMultiplier,
        uint256 kPeriod,
        uint256 unstakeFeeBasisPoints,
        uint256 initialMarketSeed
    ) external adminOnly {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("initializeMarket"))){
      
      return mocker.initializeMarketMock(marketIndex,kInitialMultiplier,kPeriod,unstakeFeeBasisPoints,initialMarketSeed);
    }
  
        require(!marketExists[marketIndex], "already initialized");
        require(marketIndex <= latestMarket, "index too high");

        marketExists[marketIndex] = true;

                staker.addNewStakingFund(
            latestMarket,
            syntheticTokens[latestMarket][true],
            syntheticTokens[latestMarket][false],
            kInitialMultiplier,
            kPeriod,
            unstakeFeeBasisPoints
        );

        _seedMarketInitially(initialMarketSeed, marketIndex);
    }

    


    function _recalculateSyntheticTokenPrice(uint32 marketIndex, bool isLong)
        internal
        view
        returns (uint256 syntheticTokenPrice)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_recalculateSyntheticTokenPrice"))){
      
      return mocker._recalculateSyntheticTokenPriceMock(marketIndex,isLong);
    }
  
        syntheticTokenPrice =
            (syntheticTokenPoolValue[marketIndex][isLong] * TEN_TO_THE_18) /
            syntheticTokens[marketIndex][isLong].totalSupply();
    }

    function _getAmountPaymentToken(uint256 amountSynth, uint256 price)
        internal view returns (uint256)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getAmountPaymentToken"))){
      
      return mocker._getAmountPaymentTokenMock(amountSynth,price);
    }
  
        return (amountSynth * price) / TEN_TO_THE_18;
    }

    function _getAmountSynthToken(uint256 amountPaymentToken, uint256 price)
        internal view returns (uint256)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getAmountSynthToken"))){
      
      return mocker._getAmountSynthTokenMock(amountPaymentToken,price);
    }
  
        return (amountPaymentToken * TEN_TO_THE_18) / price;
    }

    

    function getUsersConfirmedButNotSettledBalance(
        address user,
        uint32 marketIndex,
        bool isLong
    )
        external
        view
        override
        assertMarketExists(marketIndex)
        returns (uint256 pendingBalance)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getUsersConfirmedButNotSettledBalance"))){
      
      return mocker.getUsersConfirmedButNotSettledBalanceMock(user,marketIndex,isLong);
    }
  
        if (
            userCurrentNextPriceUpdateIndex[marketIndex][user] != 0 &&
            userCurrentNextPriceUpdateIndex[marketIndex][user] <=
            marketUpdateIndex[marketIndex]
        ) {
                        uint256 amountPaymentTokenDeposited = userNextPriceDepositAmount[
                marketIndex
            ][isLong][user];

            uint256 syntheticTokenPrice = syntheticTokenPriceSnapshot[
                marketIndex
            ][isLong][marketUpdateIndex[marketIndex]];

            uint256 tokens = _getAmountSynthToken(
                amountPaymentTokenDeposited,
                syntheticTokenPrice
            );

            return tokens;
        } else {
            return 0;
        }
    }

    function _getMarketPercentForTreasuryVsMarketSplit(uint32 marketIndex)
        internal
        view
        returns (uint256 marketPercentE5)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getMarketPercentForTreasuryVsMarketSplit"))){
      
      return mocker._getMarketPercentForTreasuryVsMarketSplitMock(marketIndex);
    }
  
        uint256 totalValueLockedInMarket = syntheticTokenPoolValue[marketIndex][
            true
        ] + syntheticTokenPoolValue[marketIndex][false];

        if (
            syntheticTokenPoolValue[marketIndex][true] >
            syntheticTokenPoolValue[marketIndex][false]
        ) {
            marketPercentE5 =
                ((syntheticTokenPoolValue[marketIndex][true] -
                    syntheticTokenPoolValue[marketIndex][false]) *
                    TEN_TO_THE_5) /
                totalValueLockedInMarket;
        } else {
            marketPercentE5 =
                ((syntheticTokenPoolValue[marketIndex][false] -
                    syntheticTokenPoolValue[marketIndex][true]) *
                    TEN_TO_THE_5) /
                totalValueLockedInMarket;
        }

        return marketPercentE5;
    }

    function _getLongPercentForLongVsShortSplit(uint32 marketIndex)
        internal
        view
        returns (uint256 longPercentE5)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getLongPercentForLongVsShortSplit"))){
      
      return mocker._getLongPercentForLongVsShortSplitMock(marketIndex);
    }
  
        return
            (syntheticTokenPoolValue[marketIndex][false] * TEN_TO_THE_5) /
            (syntheticTokenPoolValue[marketIndex][true] +
                syntheticTokenPoolValue[marketIndex][false]);
    }

    

    function _getMarketSplit(uint32 marketIndex, uint256 amount)
        internal
        view
        returns (uint256 longAmount, uint256 shortAmount)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getMarketSplit"))){
      
      return mocker._getMarketSplitMock(marketIndex,amount);
    }
  
        uint256 longPercentE5 = _getLongPercentForLongVsShortSplit(marketIndex);

        longAmount = (amount * longPercentE5) / TEN_TO_THE_5;
        shortAmount = amount - longAmount;

        return (longAmount, shortAmount);
    }

    


    function _distributeMarketAmount(uint32 marketIndex, uint256 marketAmount)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_distributeMarketAmount"))){
      
      return mocker._distributeMarketAmountMock(marketIndex,marketAmount);
    }
  
                (uint256 longAmount, uint256 shortAmount) = _getMarketSplit(
            marketIndex,
            marketAmount
        );
        syntheticTokenPoolValue[marketIndex][true] += longAmount;
        syntheticTokenPoolValue[marketIndex][false] += shortAmount;
    }

    

    function _claimAndDistributeYield(uint32 marketIndex) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_claimAndDistributeYield"))){
      
      return mocker._claimAndDistributeYieldMock(marketIndex);
    }
  
        uint256 marketPercentE5 = _getMarketPercentForTreasuryVsMarketSplit(
            marketIndex
        );

        uint256 totalValueRealizedForMarket = syntheticTokenPoolValue[
            marketIndex
        ][true] + syntheticTokenPoolValue[marketIndex][false];

        uint256 marketAmount = yieldManagers[marketIndex]
        .claimYieldAndGetMarketAmount(
            totalValueRealizedForMarket,
            marketPercentE5
        );

        if (marketAmount > 0) {
            _distributeMarketAmount(marketIndex, marketAmount);
        }
    }

    function _adjustMarketBasedOnNewAssetPrice(
        uint32 marketIndex,
        int256 newAssetPrice
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_adjustMarketBasedOnNewAssetPrice"))){
      
      return mocker._adjustMarketBasedOnNewAssetPriceMock(marketIndex,newAssetPrice);
    }
  
        int256 oldAssetPrice = int256(assetPrice[marketIndex]);

        uint256 min;
        if (
            syntheticTokenPoolValue[marketIndex][true] <
            syntheticTokenPoolValue[marketIndex][false]
        ) {
            min = syntheticTokenPoolValue[marketIndex][true];
        } else {
            min = syntheticTokenPoolValue[marketIndex][false];
        }

        int256 percentageChangeE18 = ((newAssetPrice - oldAssetPrice) *
            TEN_TO_THE_18_SIGNED) / oldAssetPrice;

        int256 valueChange = (percentageChangeE18 * int256(min)) /
            TEN_TO_THE_18_SIGNED;

        if (valueChange > 0) {
            syntheticTokenPoolValue[marketIndex][true] += uint256(valueChange);
            syntheticTokenPoolValue[marketIndex][false] -= uint256(valueChange);
        } else {
            syntheticTokenPoolValue[marketIndex][true] -= uint256(
                valueChange * -1
            );
            syntheticTokenPoolValue[marketIndex][false] += uint256(
                valueChange * -1
            );
        }

        emit PriceUpdate(
            marketIndex,
            assetPrice[marketIndex],
            uint256(newAssetPrice),
            msg.sender
        );
    }

    function _saveSyntheticTokenPriceSnapshots(
        uint32 marketIndex,
        uint256 newLatestPriceStateIndex,
        uint256 syntheticTokenPriceLong,
        uint256 syntheticTokenPriceShort
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_saveSyntheticTokenPriceSnapshots"))){
      
      return mocker._saveSyntheticTokenPriceSnapshotsMock(marketIndex,newLatestPriceStateIndex,syntheticTokenPriceLong,syntheticTokenPriceShort);
    }
  
        syntheticTokenPriceSnapshot[marketIndex][true][
            newLatestPriceStateIndex
        ] = syntheticTokenPriceLong;

        syntheticTokenPriceSnapshot[marketIndex][false][
            newLatestPriceStateIndex
        ] = syntheticTokenPriceShort;
    }

    


    

    function _updateSystemStateInternal(uint32 marketIndex)
        internal
        assertMarketExists(marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_updateSystemStateInternal"))){
      
      return mocker._updateSystemStateInternalMock(marketIndex);
    }
  
                int256 newAssetPrice = oracleManagers[marketIndex].updatePrice();
        int256 oldAssetPrice = int256(assetPrice[marketIndex]);

        bool assetPriceChanged = oldAssetPrice != newAssetPrice;

        if (assetPriceChanged || msg.sender == address(staker)) {
            uint256 syntheticTokenPriceLong = syntheticTokenPriceSnapshot[
                marketIndex
            ][true][marketUpdateIndex[marketIndex]];
            uint256 syntheticTokenPriceShort = syntheticTokenPriceSnapshot[
                marketIndex
            ][false][marketUpdateIndex[marketIndex]];
            staker.addNewStateForFloatRewards(
                marketIndex,
                syntheticTokenPriceLong,
                syntheticTokenPriceShort,
                syntheticTokenPoolValue[marketIndex][true],
                syntheticTokenPoolValue[marketIndex][false]
            );

            if (!assetPriceChanged) {
                return;
            }

            _claimAndDistributeYield(marketIndex);
            _adjustMarketBasedOnNewAssetPrice(marketIndex, newAssetPrice);

            syntheticTokenPriceLong = _recalculateSyntheticTokenPrice(
                marketIndex,
                true
            );
            syntheticTokenPriceShort = _recalculateSyntheticTokenPrice(
                marketIndex,
                false
            );

            assetPrice[marketIndex] = uint256(newAssetPrice);
            marketUpdateIndex[marketIndex] += 1;

            _saveSyntheticTokenPriceSnapshots(
                marketIndex,
                marketUpdateIndex[marketIndex],
                syntheticTokenPriceLong,
                syntheticTokenPriceShort
            );
            _performOustandingSettlements(
                marketIndex,
                marketUpdateIndex[marketIndex],
                syntheticTokenPriceLong,
                syntheticTokenPriceShort
            );

            emit SystemStateUpdated(
                marketIndex,
                marketUpdateIndex[marketIndex],
                newAssetPrice,
                syntheticTokenPoolValue[marketIndex][true],
                syntheticTokenPoolValue[marketIndex][false],
                syntheticTokenPriceLong,
                syntheticTokenPriceShort
            );
        }
    }

    function updateSystemState(uint32 marketIndex) external override {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("updateSystemState"))){
      
      return mocker.updateSystemStateMock(marketIndex);
    }
  
        _updateSystemStateInternal(marketIndex);
    }

    function updateSystemStateMulti(uint32[] calldata marketIndexes)
        external
        override
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("updateSystemStateMulti"))){
      
      return mocker.updateSystemStateMultiMock(marketIndexes);
    }
  
        for (uint256 i = 0; i < marketIndexes.length; i++) {
            _updateSystemStateInternal(marketIndexes[i]);
        }
    }

    


    function _depositFunds(uint32 marketIndex, uint256 amount) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_depositFunds"))){
      
      return mocker._depositFundsMock(marketIndex,amount);
    }
  
        paymentTokens[marketIndex].transferFrom(
            msg.sender,
            address(this),
            amount
        );
    }

        function _lockFundsInMarket(uint32 marketIndex, uint256 amount) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_lockFundsInMarket"))){
      
      return mocker._lockFundsInMarketMock(marketIndex,amount);
    }
  
        _depositFunds(marketIndex, amount);
        _transferFundsToYieldManager(marketIndex, amount);
    }

    

        function _withdrawFunds(
        uint32 marketIndex,
        uint256 amountLong,
        uint256 amountShort,
        address user
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_withdrawFunds"))){
      
      return mocker._withdrawFundsMock(marketIndex,amountLong,amountShort,user);
    }
  
        uint256 totalAmount = amountLong + amountShort;

        if (totalAmount == 0) {
            return;
        }

        assert(
            syntheticTokenPoolValue[marketIndex][true] >= amountLong &&
                syntheticTokenPoolValue[marketIndex][false] >= amountShort
        );

        _transferFromYieldManager(marketIndex, totalAmount);

                paymentTokens[marketIndex].transfer(user, totalAmount);

        syntheticTokenPoolValue[marketIndex][true] -= amountLong;
        syntheticTokenPoolValue[marketIndex][false] -= amountShort;
    }

    function _burnSynthTokensForRedemption(
        uint32 marketIndex,
        uint256 amountSynthToRedeemLong,
        uint256 amountSynthToRedeemShort
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_burnSynthTokensForRedemption"))){
      
      return mocker._burnSynthTokensForRedemptionMock(marketIndex,amountSynthToRedeemLong,amountSynthToRedeemShort);
    }
  
        if (amountSynthToRedeemLong > 0) {
            syntheticTokens[marketIndex][true].synthRedeemBurn(
                address(this),
                amountSynthToRedeemLong
            );
        }

        if (amountSynthToRedeemShort > 0) {
            syntheticTokens[marketIndex][false].synthRedeemBurn(
                address(this),
                amountSynthToRedeemShort
            );
        }
    }

    


    

    function _transferFundsToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_transferFundsToYieldManager"))){
      
      return mocker._transferFundsToYieldManagerMock(marketIndex,amount);
    }
  
        yieldManagers[marketIndex].depositPaymentToken(amount);
    }

    

    function _transferFromYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_transferFromYieldManager"))){
      
      return mocker._transferFromYieldManagerMock(marketIndex,amount);
    }
  
                        yieldManagers[marketIndex].withdrawPaymentToken(amount);
    }

    


    function _mintNextPrice(
        uint32 marketIndex,
        uint256 amount,
        bool isLong
    )
        internal
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_mintNextPrice"))){
      
      return mocker._mintNextPriceMock(marketIndex,amount,isLong);
    }
  
        _depositFunds(marketIndex, amount);

        batchedAmountOfTokensToDeposit[marketIndex][isLong] += amount;
        userNextPriceDepositAmount[marketIndex][isLong][msg.sender] += amount;
        userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] =
            marketUpdateIndex[marketIndex] +
            1;

        emit NextPriceDeposit(
            marketIndex,
            isLong,
            amount,
            msg.sender,
            marketUpdateIndex[marketIndex] + 1
        );
    }

    function mintLongNextPrice(uint32 marketIndex, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintLongNextPrice"))){
      
      return mocker.mintLongNextPriceMock(marketIndex,amount);
    }
  
        _mintNextPrice(marketIndex, amount, true);
    }

    function mintShortNextPrice(uint32 marketIndex, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintShortNextPrice"))){
      
      return mocker.mintShortNextPriceMock(marketIndex,amount);
    }
  
        _mintNextPrice(marketIndex, amount, false);
    }

    


    function _redeemNextPrice(
        uint32 marketIndex,
        uint256 tokensToRedeem,
        bool isLong
    )
        internal
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_redeemNextPrice"))){
      
      return mocker._redeemNextPriceMock(marketIndex,tokensToRedeem,isLong);
    }
  
        syntheticTokens[marketIndex][isLong].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );

        userNextPriceRedemptionAmount[marketIndex][isLong][
            msg.sender
        ] += tokensToRedeem;
        userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] =
            marketUpdateIndex[marketIndex] +
            1;

        batchedAmountOfSynthTokensToRedeem[marketIndex][
            isLong
        ] += tokensToRedeem;

        emit NextPriceRedeem(
            marketIndex,
            isLong,
            tokensToRedeem,
            msg.sender,
            marketUpdateIndex[marketIndex] + 1
        );
    }

    function redeemLongNextPrice(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemLongNextPrice"))){
      
      return mocker.redeemLongNextPriceMock(marketIndex,tokensToRedeem);
    }
  
        _redeemNextPrice(marketIndex, tokensToRedeem, true);
    }

    function redeemShortNextPrice(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemShortNextPrice"))){
      
      return mocker.redeemShortNextPriceMock(marketIndex,tokensToRedeem);
    }
  
        _redeemNextPrice(marketIndex, tokensToRedeem, false);
    }

    


    function _executeNextPriceMintsIfTheyExist(
        uint32 marketIndex,
        address user,
        bool isLong
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeNextPriceMintsIfTheyExist"))){
      
      return mocker._executeNextPriceMintsIfTheyExistMock(marketIndex,user,isLong);
    }
  
        uint256 currentDepositAmount = userNextPriceDepositAmount[marketIndex][
            isLong
        ][user];
        if (currentDepositAmount > 0) {
            userNextPriceDepositAmount[marketIndex][isLong][user] = 0;
            uint256 tokensToTransferToUser = _getAmountSynthToken(
                currentDepositAmount,
                syntheticTokenPriceSnapshot[marketIndex][isLong][
                    userCurrentNextPriceUpdateIndex[marketIndex][user]
                ]
            );
            syntheticTokens[marketIndex][isLong].transfer(
                user,
                tokensToTransferToUser
            );

            emit ExecuteNextPriceMintSettlementUser(
                user,
                marketIndex,
                isLong,
                tokensToTransferToUser
            );
        }
    }

    function _executeOutstandingNextPriceRedeems(
        uint32 marketIndex,
        address user,
        bool isLong
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingNextPriceRedeems"))){
      
      return mocker._executeOutstandingNextPriceRedeemsMock(marketIndex,user,isLong);
    }
  
        uint256 currentRedemptions = userNextPriceRedemptionAmount[marketIndex][
            isLong
        ][user];
        if (currentRedemptions > 0) {
            userNextPriceRedemptionAmount[marketIndex][isLong][user] = 0;
            uint256 amountToRedeem = _getAmountPaymentToken(
                currentRedemptions,
                syntheticTokenPriceSnapshot[marketIndex][isLong][
                    userCurrentNextPriceUpdateIndex[marketIndex][user]
                ]
            );
            paymentTokens[marketIndex].transfer(user, amountToRedeem);
            emit ExecuteNextPriceRedeemSettlementUser(
                user,
                marketIndex,
                isLong,
                amountToRedeem
            );
        }
    }

    function _executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingNextPriceSettlements"))){
      
      return mocker._executeOutstandingNextPriceSettlementsMock(user,marketIndex);
    }
  
        uint256 currentUpdateIndex = userCurrentNextPriceUpdateIndex[
            marketIndex
        ][user];
        if (
            currentUpdateIndex != 0 &&
            currentUpdateIndex <= marketUpdateIndex[marketIndex]
        ) {
            _executeNextPriceMintsIfTheyExist(marketIndex, user, true);
            _executeNextPriceMintsIfTheyExist(marketIndex, user, false);
            _executeOutstandingNextPriceRedeems(marketIndex, user, true);
            _executeOutstandingNextPriceRedeems(marketIndex, user, false);

            userCurrentNextPriceUpdateIndex[marketIndex][user] = 0;

            emit ExecuteNextPriceSettlementsUser(user, marketIndex);
        }
    }

    function executeOutstandingNextPriceSettlementsUser(
        address user,
        uint32 marketIndex
    ) external override {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("executeOutstandingNextPriceSettlementsUser"))){
      
      return mocker.executeOutstandingNextPriceSettlementsUserMock(user,marketIndex);
    }
  
        _executeOutstandingNextPriceSettlements(user, marketIndex);
    }

    


    function _performOustandingSettlements(
        uint32 marketIndex,
        uint256 newLatestPriceStateIndex,
        uint256 syntheticTokenPriceLong,
        uint256 syntheticTokenPriceShort
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_performOustandingSettlements"))){
      
      return mocker._performOustandingSettlementsMock(marketIndex,newLatestPriceStateIndex,syntheticTokenPriceLong,syntheticTokenPriceShort);
    }
  
        _handleBatchedDepositSettlement(
            marketIndex,
            true,
            syntheticTokenPriceLong
        );
        _handleBatchedDepositSettlement(
            marketIndex,
            false,
            syntheticTokenPriceShort
        );
        _handleBatchedRedeemSettlement(
            marketIndex,
            syntheticTokenPriceLong,
            syntheticTokenPriceShort
        );
    }

    function _handleBatchedDepositSettlement(
        uint32 marketIndex,
        bool isLong,
        uint256 syntheticTokenPrice
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_handleBatchedDepositSettlement"))){
      
      return mocker._handleBatchedDepositSettlementMock(marketIndex,isLong,syntheticTokenPrice);
    }
  
        uint256 amountToBatchDeposit = batchedAmountOfTokensToDeposit[
            marketIndex
        ][isLong];

        if (amountToBatchDeposit > 0) {
            batchedAmountOfTokensToDeposit[marketIndex][isLong] = 0;
            _transferFundsToYieldManager(marketIndex, amountToBatchDeposit);

            uint256 numberOfTokens = _getAmountSynthToken(
                amountToBatchDeposit,
                syntheticTokenPrice
            );

            syntheticTokens[marketIndex][isLong].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenPoolValue[marketIndex][
                isLong
            ] += amountToBatchDeposit;
        }
    }

    function _handleBatchedRedeemSettlement(
        uint32 marketIndex,
        uint256 syntheticTokenPriceLong,
        uint256 syntheticTokenPriceShort
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_handleBatchedRedeemSettlement"))){
      
      return mocker._handleBatchedRedeemSettlementMock(marketIndex,syntheticTokenPriceLong,syntheticTokenPriceShort);
    }
  
        _burnSynthTokensForRedemption(
            marketIndex,
            batchedAmountOfSynthTokensToRedeem[marketIndex][true],
            batchedAmountOfSynthTokensToRedeem[marketIndex][false]
        );

        uint256 longAmountOfPaymentTokenToRedeem = _getAmountPaymentToken(
            batchedAmountOfSynthTokensToRedeem[marketIndex][true],
            syntheticTokenPriceLong
        );
        uint256 shortAmountOfPaymentTokenToRedeem = _getAmountPaymentToken(
            batchedAmountOfSynthTokensToRedeem[marketIndex][false],
            syntheticTokenPriceShort
        );

        batchedAmountOfSynthTokensToRedeem[marketIndex][true] = 0;
        batchedAmountOfSynthTokensToRedeem[marketIndex][false] = 0;

        _withdrawFunds(
            marketIndex,
            longAmountOfPaymentTokenToRedeem,
            shortAmountOfPaymentTokenToRedeem,
            address(this)
        );
    }
}
