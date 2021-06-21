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
    uint256 public constant feeUnitsOfPrecision = 10000;
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

    mapping(uint32 => uint256) public totalValueLockedInYieldManager;
    mapping(uint32 => uint256) public totalValueReservedForTreasury;
    mapping(uint32 => IERC20) public fundTokens;
    mapping(uint32 => IYieldManager) public yieldManagers;
    mapping(uint32 => IOracleManager) public oracleManagers;

    mapping(uint32 => uint256) public baseEntryFee;
    mapping(uint32 => uint256) public badLiquidityEntryFee;
    mapping(uint32 => uint256) public baseExitFee;
    mapping(uint32 => uint256) public badLiquidityExitFee;

        mapping(uint32 => mapping(MarketSide => ISyntheticToken))
        public syntheticTokens;
    mapping(uint32 => mapping(MarketSide => uint256))
        public syntheticTokenPoolValue;
    mapping(uint32 => mapping(MarketSide => uint256))
        public syntheticTokenPrice;

    mapping(uint32 => mapping(MarketSide => mapping(uint256 => uint256)))
        public mintPriceSnapshot;
    mapping(uint32 => mapping(MarketSide => mapping(uint256 => uint256)))
        public redeemPriceSnapshot;

    mapping(uint32 => mapping(MarketSide => uint256))
        public batchedNextPriceDepositAmount;
    mapping(uint32 => mapping(MarketSide => uint256))
        public batchedNextPriceSynthRedeemAmount;

        mapping(uint32 => mapping(address => uint256))
        public userCurrentNextPriceUpdateIndex;

    mapping(uint32 => mapping(MarketSide => mapping(address => uint256)))
        public userNextPriceDepositAmount;
    mapping(uint32 => mapping(MarketSide => mapping(address => uint256)))
        public userNextPriceRedemptionAmount;

    


    event V1(
        address admin,
        address treasury,
        address tokenFactory,
        address staker
    );

        event ValueLockedInSystem(
        uint32 marketIndex,
        uint256 totalValueLockedInMarket,
        uint256 longValue,
        uint256 shortValue
    );

    event TokenPriceRefreshed(
        uint32 marketIndex,
        uint256 longTokenPrice,
        uint256 shortTokenPrice
    );

    event FeesLevied(uint32 marketIndex, uint256 totalFees);

    event SyntheticTokenCreated(
        uint32 marketIndex,
        address longTokenAddress,
        address shortTokenAddress,
        address fundToken,
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
        MarketSide syntheticTokenType,
        uint256 synthRedeemed,
        address user,
        uint256 oracleUpdateIndex
    );

    event BatchedActionsSettled(
        uint32 marketIndex,
        uint256 updateIndex,
        uint256 mintPriceSnapshotLong,
        uint256 mintPriceSnapshotShort,
        uint256 redeemPriceSnapshotLong,
        uint256 redeemPriceSnapshotShort
    );

    event NextPriceDeposit(
        uint32 marketIndex,
        MarketSide syntheticTokenType,
        uint256 depositAdded,
        address user,
        uint256 oracleUpdateIndex
    );

    event FeesChanges(
        uint32 marketIndex,
        uint256 baseEntryFee,
        uint256 badLiquidityEntryFee,
        uint256 baseExitFee,
        uint256 badLiquidityExitFee
    );

    event OracleUpdated(
        uint32 marketIndex,
        address oldOracleAddress,
        address newOracleAddress
    );

    event NewMarketLaunchedAndSeeded(uint32 marketIndex, uint256 initialSeed);

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

    modifier treasuryOnly() {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("treasuryOnly"))){
        
      mocker.treasuryOnlyMock();
      _;
    } else {
      
        require(msg.sender == treasury, "only treasury");
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

    modifier isCorrectSynth(
        uint32 marketIndex,
        MarketSide syntheticTokenType,
        ISyntheticToken syntheticToken
    ) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("isCorrectSynth"))){
        
      mocker.isCorrectSynthMock(marketIndex,syntheticTokenType,syntheticToken);
      _;
    } else {
      
        if (syntheticTokenType == ILongShort.MarketSide.Long) {
            require(
                syntheticTokens[marketIndex][MarketSide.Long] == syntheticToken,
                "Incorrect synthetic token"
            );
        } else {
            require(
                syntheticTokens[marketIndex][MarketSide.Short] ==
                    syntheticToken,
                "Incorrect synthetic token"
            );
        }
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

    function changeFees(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee
    ) external adminOnly {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("changeFees"))){
      
      return mocker.changeFeesMock(marketIndex,_baseEntryFee,_badLiquidityEntryFee,_baseExitFee,_badLiquidityExitFee);
    }
  
        _changeFees(
            marketIndex,
            _baseEntryFee,
            _baseExitFee,
            _badLiquidityEntryFee,
            _badLiquidityExitFee
        );
    }

    function _changeFees(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityEntryFee,
        uint256 _badLiquidityExitFee
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_changeFees"))){
      
      return mocker._changeFeesMock(marketIndex,_baseEntryFee,_baseExitFee,_badLiquidityEntryFee,_badLiquidityExitFee);
    }
  
        baseEntryFee[marketIndex] = _baseEntryFee;
        baseExitFee[marketIndex] = _baseExitFee;
        badLiquidityEntryFee[marketIndex] = _badLiquidityEntryFee;
        badLiquidityExitFee[marketIndex] = _badLiquidityExitFee;

        emit FeesChanges(
            latestMarket,
            _baseEntryFee,
            _badLiquidityEntryFee,
            _baseExitFee,
            _badLiquidityExitFee
        );
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
        address _fundToken,
        address _oracleManager,
        address _yieldManager
    ) external adminOnly {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("newSyntheticMarket"))){
      
      return mocker.newSyntheticMarketMock(syntheticName,syntheticSymbol,_fundToken,_oracleManager,_yieldManager);
    }
  
        latestMarket++;

                syntheticTokens[latestMarket][MarketSide.Long] = ISyntheticToken(
            tokenFactory.createTokenLong(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

                syntheticTokens[latestMarket][MarketSide.Short] = ISyntheticToken(
            tokenFactory.createTokenShort(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

                syntheticTokenPrice[latestMarket][MarketSide.Long] = TEN_TO_THE_18;
        syntheticTokenPrice[latestMarket][MarketSide.Short] = TEN_TO_THE_18;
        fundTokens[latestMarket] = IERC20(_fundToken);
        yieldManagers[latestMarket] = IYieldManager(_yieldManager);
        oracleManagers[latestMarket] = IOracleManager(_oracleManager);
        assetPrice[latestMarket] = uint256(
            oracleManagers[latestMarket].updatePrice()
        );

        emit SyntheticTokenCreated(
            latestMarket,
            address(syntheticTokens[latestMarket][MarketSide.Long]),
            address(syntheticTokens[latestMarket][MarketSide.Short]),
            _fundToken,
            assetPrice[latestMarket],
            syntheticName,
            syntheticSymbol,
            _oracleManager
        );
    }

    function seedMarketInitially(uint256 initialMarketSeed, uint32 marketIndex)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("seedMarketInitially"))){
      
      return mocker.seedMarketInitiallyMock(initialMarketSeed,marketIndex);
    }
  
        require(
                        initialMarketSeed > 0.1 ether,
            "Insufficient value to seed the market"
        );

        _lockFundsInMarket(marketIndex, initialMarketSeed * 2);

        syntheticTokens[latestMarket][MarketSide.Long].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );
        syntheticTokens[latestMarket][MarketSide.Short].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );

        syntheticTokenPoolValue[marketIndex][
            MarketSide.Long
        ] = initialMarketSeed;
        syntheticTokenPoolValue[marketIndex][
            MarketSide.Short
        ] = initialMarketSeed;

        emit NewMarketLaunchedAndSeeded(marketIndex, initialMarketSeed);
    }

    function initializeMarket(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee,
        uint256 kInitialMultiplier,
        uint256 kPeriod,
        uint256 initialMarketSeed
    ) external adminOnly {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("initializeMarket"))){
      
      return mocker.initializeMarketMock(marketIndex,_baseEntryFee,_badLiquidityEntryFee,_baseExitFee,_badLiquidityExitFee,kInitialMultiplier,kPeriod,initialMarketSeed);
    }
  
        require(!marketExists[marketIndex] && marketIndex <= latestMarket);

        marketExists[marketIndex] = true;

        _changeFees(
            marketIndex,
            _baseEntryFee,
            _baseExitFee,
            _badLiquidityEntryFee,
            _badLiquidityExitFee
        );

                staker.addNewStakingFund(
            latestMarket,
            syntheticTokens[latestMarket][MarketSide.Long],
            syntheticTokens[latestMarket][MarketSide.Short],
            kInitialMultiplier,
            kPeriod
        );

        seedMarketInitially(initialMarketSeed, marketIndex);
    }

    


    function getOtherSynthType(MarketSide synthTokenType)
        internal
        view
        returns (MarketSide)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getOtherSynthType"))){
      
      return mocker.getOtherSynthTypeMock(synthTokenType);
    }
  
        if (synthTokenType == MarketSide.Long) {
            return MarketSide.Short;
        } else {
            return MarketSide.Long;
        }
    }

    function getPrice(uint256 amountSynth, uint256 amountPaymentToken)
        internal view returns (uint256)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getPrice"))){
      
      return mocker.getPriceMock(amountSynth,amountPaymentToken);
    }
  
        return (amountPaymentToken * TEN_TO_THE_18) / amountSynth;
    }

    function getAmountPaymentToken(uint256 amountSynth, uint256 price)
        internal view returns (uint256)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getAmountPaymentToken"))){
      
      return mocker.getAmountPaymentTokenMock(amountSynth,price);
    }
  
        return (amountSynth * price) / TEN_TO_THE_18;
    }

    function getAmountSynthToken(uint256 amountPaymentToken, uint256 price)
        internal view returns (uint256)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getAmountSynthToken"))){
      
      return mocker.getAmountSynthTokenMock(amountPaymentToken,price);
    }
  
        return (amountPaymentToken * TEN_TO_THE_18) / price;
    }

    function getUsersPendingBalance(
        address user,
        uint32 marketIndex,
        MarketSide syntheticTokenType
    )
        external
        view
        override
        assertMarketExists(marketIndex)
        returns (uint256 pendingBalance)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getUsersPendingBalance"))){
      
      return mocker.getUsersPendingBalanceMock(user,marketIndex,syntheticTokenType);
    }
  
        if (
            userCurrentNextPriceUpdateIndex[marketIndex][user] <=
            marketUpdateIndex[marketIndex]
        ) {
                                    uint256 amountPaymentTokenDeposited =
                userNextPriceDepositAmount[marketIndex][syntheticTokenType][
                    user
                ];

            uint256 tokens =
                getAmountSynthToken(
                    amountPaymentTokenDeposited,
                    syntheticTokenPrice[marketIndex][syntheticTokenType]
                );

            return tokens;
        } else {
            return 0;
        }
    }

    

    function getTreasurySplit(uint32 marketIndex, uint256 amount)
        public
        view
        returns (uint256 marketAmount, uint256 treasuryAmount)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getTreasurySplit"))){
      
      return mocker.getTreasurySplitMock(marketIndex,amount);
    }
  
        uint256 marketPcnt; 
        uint256 totalValueLockedInMarket =
            syntheticTokenPoolValue[marketIndex][MarketSide.Long] +
                syntheticTokenPoolValue[marketIndex][MarketSide.Short];

        if (
            syntheticTokenPoolValue[marketIndex][MarketSide.Long] >
            syntheticTokenPoolValue[marketIndex][MarketSide.Short]
        ) {
            marketPcnt =
                ((syntheticTokenPoolValue[marketIndex][MarketSide.Long] -
                    syntheticTokenPoolValue[marketIndex][MarketSide.Short]) *
                    10000) /
                totalValueLockedInMarket;
        } else {
            marketPcnt =
                ((syntheticTokenPoolValue[marketIndex][MarketSide.Short] -
                    syntheticTokenPoolValue[marketIndex][MarketSide.Long]) *
                    10000) /
                totalValueLockedInMarket;
        }

        marketAmount = (marketPcnt * amount) / 10000;
        treasuryAmount = amount - marketAmount;
        require(amount == marketAmount + treasuryAmount);

        return (marketAmount, treasuryAmount);
    }

    

    function getMarketSplit(uint32 marketIndex, uint256 amount)
        public
        view
        returns (uint256 longAmount, uint256 shortAmount)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getMarketSplit"))){
      
      return mocker.getMarketSplitMock(marketIndex,amount);
    }
  
                        uint256 longPcnt =
            (syntheticTokenPoolValue[marketIndex][MarketSide.Short] * 10000) /
                (syntheticTokenPoolValue[marketIndex][MarketSide.Long] +
                    syntheticTokenPoolValue[marketIndex][MarketSide.Short]);

        longAmount = (amount * longPcnt) / 10000;
        shortAmount = amount - longAmount;
        return (longAmount, shortAmount);
    }

    


    function _minimum(uint256 A, uint256 B) internal view returns (int256) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_minimum"))){
      
      return mocker._minimumMock(A,B);
    }
  
        if (A < B) {
            return int256(A);
        } else {
            return int256(B);
        }
    }

    

    function _refreshTokenPrices(uint32 marketIndex) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_refreshTokenPrices"))){
      
      return mocker._refreshTokenPricesMock(marketIndex);
    }
  
        uint256 longTokenSupply =
            syntheticTokens[marketIndex][MarketSide.Long].totalSupply();

                if (longTokenSupply > 0) {
            syntheticTokenPrice[marketIndex][MarketSide.Long] = getPrice(
                longTokenSupply,
                syntheticTokenPoolValue[marketIndex][MarketSide.Long]
            );
        }

        uint256 shortTokenSupply =
            syntheticTokens[marketIndex][MarketSide.Short].totalSupply();
        if (shortTokenSupply > 0) {
            syntheticTokenPrice[marketIndex][MarketSide.Short] = getPrice(
                shortTokenSupply,
                syntheticTokenPoolValue[marketIndex][MarketSide.Short]
            );
        }

        emit TokenPriceRefreshed(
            marketIndex,
            syntheticTokenPrice[marketIndex][MarketSide.Long],
            syntheticTokenPrice[marketIndex][MarketSide.Short]
        );
    }

    function _distributeMarketAmount(uint32 marketIndex, uint256 marketAmount)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_distributeMarketAmount"))){
      
      return mocker._distributeMarketAmountMock(marketIndex,marketAmount);
    }
  
                (uint256 longAmount, uint256 shortAmount) =
            getMarketSplit(marketIndex, marketAmount);
        syntheticTokenPoolValue[marketIndex][MarketSide.Long] += longAmount;
        syntheticTokenPoolValue[marketIndex][MarketSide.Short] += shortAmount;
    }

    

        function _feesMechanism(uint32 marketIndex, uint256 totalFees) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_feesMechanism"))){
      
      return mocker._feesMechanismMock(marketIndex,totalFees);
    }
  
                (uint256 marketAmount, uint256 treasuryAmount) =
            getTreasurySplit(marketIndex, totalFees);

        totalValueReservedForTreasury[marketIndex] += treasuryAmount;

        _distributeMarketAmount(marketIndex, marketAmount);
        emit FeesLevied(marketIndex, totalFees);
    }

    

    function _claimAndDistributeYield(uint32 marketIndex) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_claimAndDistributeYield"))){
      
      return mocker._claimAndDistributeYieldMock(marketIndex);
    }
  
        uint256 amount =
            yieldManagers[marketIndex].getTotalHeld() -
                totalValueLockedInYieldManager[marketIndex];

        if (amount > 0) {
            (uint256 marketAmount, uint256 treasuryAmount) =
                getTreasurySplit(marketIndex, amount);

                                    totalValueLockedInYieldManager[marketIndex] += amount;
            totalValueReservedForTreasury[marketIndex] += treasuryAmount;

            _distributeMarketAmount(marketIndex, marketAmount);
        }
    }

    function _adjustMarketBasedOnNewAssetPrice(
        uint32 marketIndex,
        int256 newAssetPrice
    ) internal returns (bool didUpdate) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_adjustMarketBasedOnNewAssetPrice"))){
      
      return mocker._adjustMarketBasedOnNewAssetPriceMock(marketIndex,newAssetPrice);
    }
  
        int256 oldAssetPrice = int256(assetPrice[marketIndex]);

        if (oldAssetPrice == newAssetPrice) {
            return false;
        }

        int256 min =
            _minimum(
                syntheticTokenPoolValue[marketIndex][MarketSide.Long],
                syntheticTokenPoolValue[marketIndex][MarketSide.Short]
            );

        int256 percentageChangeE18 =
            ((newAssetPrice - oldAssetPrice) * TEN_TO_THE_18_SIGNED) /
                oldAssetPrice;

        int256 valueChange = (percentageChangeE18 * min) / TEN_TO_THE_18_SIGNED;

        if (valueChange > 0) {
            syntheticTokenPoolValue[marketIndex][MarketSide.Long] += uint256(
                valueChange
            );
            syntheticTokenPoolValue[marketIndex][MarketSide.Short] -= uint256(
                valueChange
            );
        } else {
            syntheticTokenPoolValue[marketIndex][MarketSide.Long] -= uint256(
                valueChange * -1
            );
            syntheticTokenPoolValue[marketIndex][MarketSide.Short] += uint256(
                valueChange * -1
            );
        }

        return true;
    }

    function handleBatchedDepositSettlement(
        uint32 marketIndex,
        MarketSide syntheticTokenType
    ) internal returns (bool wasABatchedSettlement) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("handleBatchedDepositSettlement"))){
      
      return mocker.handleBatchedDepositSettlementMock(marketIndex,syntheticTokenType);
    }
  
        uint256 amountToBatchDeposit =
            batchedNextPriceDepositAmount[marketIndex][syntheticTokenType];

        if (amountToBatchDeposit > 0) {
            batchedNextPriceDepositAmount[marketIndex][syntheticTokenType] = 0;
            _transferFundsToYieldManager(marketIndex, amountToBatchDeposit);

                        uint256 numberOfTokens =
                getAmountSynthToken(
                    amountToBatchDeposit,
                    syntheticTokenPrice[marketIndex][syntheticTokenType]
                );

                        syntheticTokens[marketIndex][syntheticTokenType].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenPoolValue[marketIndex][
                syntheticTokenType
            ] += amountToBatchDeposit;

                        uint256 oldTokenLongPrice =
                syntheticTokenPrice[marketIndex][MarketSide.Long];
            uint256 oldTokenShortPrice =
                syntheticTokenPrice[marketIndex][MarketSide.Short];

                                                _refreshTokenPrices(marketIndex);

            assert(
                syntheticTokenPrice[marketIndex][MarketSide.Long] ==
                    oldTokenLongPrice
            );
            assert(
                syntheticTokenPrice[marketIndex][MarketSide.Short] ==
                    oldTokenShortPrice
            );
            wasABatchedSettlement = true;
        }
    }

    function snapshotPriceChangeForNextPriceExecution(
        uint32 marketIndex,
        uint256 newLatestPriceStateIndex
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("snapshotPriceChangeForNextPriceExecution"))){
      
      return mocker.snapshotPriceChangeForNextPriceExecutionMock(marketIndex,newLatestPriceStateIndex);
    }
  
                mintPriceSnapshot[marketIndex][MarketSide.Long][
            newLatestPriceStateIndex
        ] = syntheticTokenPrice[marketIndex][MarketSide.Long];
        mintPriceSnapshot[marketIndex][MarketSide.Short][
            newLatestPriceStateIndex
        ] = syntheticTokenPrice[marketIndex][MarketSide.Short];
    }

    


    

    function _updateSystemStateInternal(uint32 marketIndex)
        internal
        assertMarketExists(marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_updateSystemStateInternal"))){
      
      return mocker._updateSystemStateInternalMock(marketIndex);
    }
  
                                staker.addNewStateForFloatRewards(
            marketIndex,
            syntheticTokenPrice[marketIndex][MarketSide.Long],
            syntheticTokenPrice[marketIndex][MarketSide.Short],
            syntheticTokenPoolValue[marketIndex][MarketSide.Long],
            syntheticTokenPoolValue[marketIndex][MarketSide.Short]
        );

                int256 newAssetPrice = oracleManagers[marketIndex].updatePrice();

                bool priceChanged =
            _adjustMarketBasedOnNewAssetPrice(marketIndex, newAssetPrice);

        if (priceChanged) {
            assert(
                syntheticTokenPoolValue[marketIndex][MarketSide.Long] != 0 &&
                    syntheticTokenPoolValue[marketIndex][MarketSide.Short] != 0
            );

                        _claimAndDistributeYield(marketIndex);

                        emit PriceUpdate(
                marketIndex,
                assetPrice[marketIndex],
                uint256(newAssetPrice),
                msg.sender
            );

                        _refreshTokenPrices(marketIndex);
            assetPrice[marketIndex] = uint256(newAssetPrice);

            uint256 newLatestPriceStateIndex =
                marketUpdateIndex[marketIndex] + 1;
            marketUpdateIndex[marketIndex] = newLatestPriceStateIndex;
            snapshotPriceChangeForNextPriceExecution(
                marketIndex,
                newLatestPriceStateIndex
            );

            if (
                handleBatchedDepositSettlement(marketIndex, MarketSide.Long) ||
                handleBatchedDepositSettlement(marketIndex, MarketSide.Short) ||
                handleBatchedNextPriceRedeems(marketIndex)
            ) {
                emit BatchedActionsSettled(
                    marketIndex,
                    newLatestPriceStateIndex,
                    mintPriceSnapshot[marketIndex][MarketSide.Long][
                        newLatestPriceStateIndex
                    ],
                    mintPriceSnapshot[marketIndex][MarketSide.Short][
                        newLatestPriceStateIndex
                    ],
                    redeemPriceSnapshot[marketIndex][MarketSide.Long][
                        newLatestPriceStateIndex
                    ],
                    redeemPriceSnapshot[marketIndex][MarketSide.Short][
                        newLatestPriceStateIndex
                    ]
                );

                emit ValueLockedInSystem(
                    marketIndex,
                    syntheticTokenPoolValue[marketIndex][MarketSide.Long] +
                        syntheticTokenPoolValue[marketIndex][MarketSide.Short],
                    syntheticTokenPoolValue[marketIndex][MarketSide.Long],
                    syntheticTokenPoolValue[marketIndex][MarketSide.Short]
                );
            }
        }
    }

    function _updateSystemState(uint32 marketIndex) external override {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_updateSystemState"))){
      
      return mocker._updateSystemStateMock(marketIndex);
    }
  
        _updateSystemStateInternal(marketIndex);
    }

    function _updateSystemStateMulti(uint32[] calldata marketIndexes)
        external
        override
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_updateSystemStateMulti"))){
      
      return mocker._updateSystemStateMultiMock(marketIndexes);
    }
  
        for (uint256 i = 0; i < marketIndexes.length; i++) {
            _updateSystemStateInternal(marketIndexes[i]);
        }
    }

    


    function _depositFunds(uint32 marketIndex, uint256 amount) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_depositFunds"))){
      
      return mocker._depositFundsMock(marketIndex,amount);
    }
  
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);
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
            syntheticTokenPoolValue[marketIndex][MarketSide.Long] >=
                amountLong &&
                syntheticTokenPoolValue[marketIndex][MarketSide.Short] >=
                amountShort
        );

        _transferFromYieldManager(marketIndex, totalAmount);

                fundTokens[marketIndex].transfer(user, totalAmount);

        syntheticTokenPoolValue[marketIndex][MarketSide.Long] -= amountLong;
        syntheticTokenPoolValue[marketIndex][MarketSide.Short] -= amountShort;
    }

    


    

        function _transferFundsToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_transferFundsToYieldManager"))){
      
      return mocker._transferFundsToYieldManagerMock(marketIndex,amount);
    }
  
                                                        fundTokens[marketIndex].approve(
            address(yieldManagers[marketIndex]),
            amount
        );
        yieldManagers[marketIndex].depositToken(amount);

                totalValueLockedInYieldManager[marketIndex] += amount;
    }

    

    function _transferFromYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_transferFromYieldManager"))){
      
      return mocker._transferFromYieldManagerMock(marketIndex,amount);
    }
  
        require(totalValueLockedInYieldManager[marketIndex] >= amount);

                        yieldManagers[marketIndex].withdrawToken(amount);

                        totalValueLockedInYieldManager[marketIndex] -= amount;

                                require(
            totalValueLockedInYieldManager[marketIndex] <=
                syntheticTokenPoolValue[marketIndex][MarketSide.Long] +
                    syntheticTokenPoolValue[marketIndex][MarketSide.Short] +
                    totalValueReservedForTreasury[marketIndex]
        );
    }

    

    function transferTreasuryFunds(uint32 marketIndex) external treasuryOnly {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("transferTreasuryFunds"))){
      
      return mocker.transferTreasuryFundsMock(marketIndex);
    }
  
        uint256 totalForTreasury = totalValueReservedForTreasury[marketIndex];

                totalValueReservedForTreasury[marketIndex] = 0;

                if (totalForTreasury == 0) {
            return;
        }

                _transferFromYieldManager(marketIndex, totalForTreasury);

                fundTokens[marketIndex].transfer(treasury, totalForTreasury);
    }

    

            function _getFeesGeneral(
        uint32 marketIndex,
        uint256 delta,         MarketSide synthTokenGainingDominance,
        MarketSide synthTokenLosingDominance,
        uint256 baseFeePercent,
        uint256 penaltyFeePercent
    ) internal view returns (uint256) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getFeesGeneral"))){
      
      return mocker._getFeesGeneralMock(marketIndex,delta,synthTokenGainingDominance,synthTokenLosingDominance,baseFeePercent,penaltyFeePercent);
    }
  
        uint256 baseFee = (delta * baseFeePercent) / feeUnitsOfPrecision;

        if (
            syntheticTokenPoolValue[marketIndex][synthTokenGainingDominance] >=
            syntheticTokenPoolValue[marketIndex][synthTokenLosingDominance]
        ) {
                        return
                baseFee + ((delta * penaltyFeePercent) / feeUnitsOfPrecision);
        } else if (
            syntheticTokenPoolValue[marketIndex][synthTokenGainingDominance] +
                delta >
            syntheticTokenPoolValue[marketIndex][synthTokenLosingDominance]
        ) {
            uint256 amountImbalancing =
                delta -
                    (syntheticTokenPoolValue[marketIndex][
                        synthTokenLosingDominance
                    ] -
                        syntheticTokenPoolValue[marketIndex][
                            synthTokenGainingDominance
                        ]);
            uint256 penaltyFee =
                (amountImbalancing * penaltyFeePercent) / feeUnitsOfPrecision;

            return baseFee + penaltyFee;
        } else {
            return baseFee;
        }
    }

    


    function _executeNextPriceMintsIfTheyExist(
        uint32 marketIndex,
        address user,
        MarketSide syntheticTokenType
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeNextPriceMintsIfTheyExist"))){
      
      return mocker._executeNextPriceMintsIfTheyExistMock(marketIndex,user,syntheticTokenType);
    }
  
        uint256 currentDepositAmount =
            userNextPriceDepositAmount[marketIndex][syntheticTokenType][user];
        if (currentDepositAmount > 0) {
            uint256 tokensToMint =
                getAmountSynthToken(
                    currentDepositAmount,
                    mintPriceSnapshot[marketIndex][syntheticTokenType][
                        userCurrentNextPriceUpdateIndex[marketIndex][user]
                    ]
                );

            syntheticTokens[marketIndex][syntheticTokenType].transfer(
                user,
                tokensToMint
            );

            userNextPriceDepositAmount[marketIndex][syntheticTokenType][
                user
            ] = 0;
        }
    }

    function _executeOutstandingNextPriceSettlementsAction(
        address user,
        uint32 marketIndex
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingNextPriceSettlementsAction"))){
      
      return mocker._executeOutstandingNextPriceSettlementsActionMock(user,marketIndex);
    }
  
        _executeNextPriceMintsIfTheyExist(marketIndex, user, MarketSide.Long);
        _executeNextPriceMintsIfTheyExist(marketIndex, user, MarketSide.Short);
        _executeOutstandingNextPriceRedeems(marketIndex, user, MarketSide.Long);
        _executeOutstandingNextPriceRedeems(
            marketIndex,
            user,
            MarketSide.Short
        );

        userCurrentNextPriceUpdateIndex[marketIndex][user] = 0;
    }

            function _executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex     ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingNextPriceSettlements"))){
      
      return mocker._executeOutstandingNextPriceSettlementsMock(user,marketIndex);
    }
  
        uint256 currentUpdateIndex =
            userCurrentNextPriceUpdateIndex[marketIndex][user];
        if (
            currentUpdateIndex <= marketUpdateIndex[marketIndex] &&
            currentUpdateIndex != 0         ) {
            _executeOutstandingNextPriceSettlementsAction(user, marketIndex);

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

    


    function _mintNextPrice(
        uint32 marketIndex,
        uint256 amount,
        MarketSide syntheticTokenType
    )
        internal
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_mintNextPrice"))){
      
      return mocker._mintNextPriceMock(marketIndex,amount,syntheticTokenType);
    }
  
                        _depositFunds(marketIndex, amount);

        batchedNextPriceDepositAmount[marketIndex][
            syntheticTokenType
        ] += amount;
        userNextPriceDepositAmount[marketIndex][syntheticTokenType][
            msg.sender
        ] += amount;
        userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] =
            marketUpdateIndex[marketIndex] +
            1;

        emit NextPriceDeposit(
            marketIndex,
            syntheticTokenType,
            amount,
            msg.sender,
            marketUpdateIndex[marketIndex] + 1
        );
    }

    function mintLongNextPrice(uint32 marketIndex, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintLongNextPrice"))){
      
      return mocker.mintLongNextPriceMock(marketIndex,amount);
    }
  
        _mintNextPrice(marketIndex, amount, MarketSide.Long);
    }

    function mintShortNextPrice(uint32 marketIndex, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintShortNextPrice"))){
      
      return mocker.mintShortNextPriceMock(marketIndex,amount);
    }
  
        _mintNextPrice(marketIndex, amount, MarketSide.Short);
    }

    


    function _executeOutstandingNextPriceRedeems(
        uint32 marketIndex,
        address user,
        MarketSide syntheticTokenType
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingNextPriceRedeems"))){
      
      return mocker._executeOutstandingNextPriceRedeemsMock(marketIndex,user,syntheticTokenType);
    }
  
        uint256 currentRedemptions =
            userNextPriceRedemptionAmount[marketIndex][syntheticTokenType][
                user
            ];
        if (currentRedemptions > 0) {
            uint256 amountToRedeem =
                getAmountPaymentToken(
                    currentRedemptions,
                    redeemPriceSnapshot[marketIndex][syntheticTokenType][
                        userCurrentNextPriceUpdateIndex[marketIndex][user]
                    ]
                );

            uint256 balance = fundTokens[marketIndex].balanceOf(address(this));

            fundTokens[marketIndex].transfer(user, amountToRedeem);
            userNextPriceRedemptionAmount[marketIndex][syntheticTokenType][
                user
            ] = 0;
        }
    }

    function _redeemNextPrice(
        uint32 marketIndex,
        uint256 tokensToRedeem,
        MarketSide syntheticTokenType
    )
        internal
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_redeemNextPrice"))){
      
      return mocker._redeemNextPriceMock(marketIndex,tokensToRedeem,syntheticTokenType);
    }
  
        syntheticTokens[marketIndex][syntheticTokenType].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );
        uint256 nextUpdateIndex = marketUpdateIndex[marketIndex] + 1;

        userNextPriceRedemptionAmount[marketIndex][syntheticTokenType][
            msg.sender
        ] += tokensToRedeem;
        userCurrentNextPriceUpdateIndex[marketIndex][
            msg.sender
        ] = nextUpdateIndex;

        batchedNextPriceSynthRedeemAmount[marketIndex][
            syntheticTokenType
        ] += tokensToRedeem;

        emit NextPriceRedeem(
            marketIndex,
            syntheticTokenType,
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
  
        _redeemNextPrice(marketIndex, tokensToRedeem, MarketSide.Long);
    }

    function redeemShortNextPrice(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemShortNextPrice"))){
      
      return mocker.redeemShortNextPriceMock(marketIndex,tokensToRedeem);
    }
  
        _redeemNextPrice(marketIndex, tokensToRedeem, MarketSide.Short);
    }

    function _handleBatchedNextPriceRedeem(
        uint32 marketIndex,
        MarketSide syntheticTokenType,
        uint256 amountSynthToRedeem
    ) internal returns (bool wasABatchedSettlement) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_handleBatchedNextPriceRedeem"))){
      
      return mocker._handleBatchedNextPriceRedeemMock(marketIndex,syntheticTokenType,amountSynthToRedeem);
    }
  
        if (amountSynthToRedeem > 0) {
            syntheticTokens[marketIndex][syntheticTokenType].synthRedeemBurn(
                address(this),
                amountSynthToRedeem
            );
            wasABatchedSettlement = true;
        }
    }

    function _calculateBatchedNextPriceFees(
        uint32 marketIndex,
        uint256 amountOfPaymentTokenToRedeem,
        uint256 shortAmountOfPaymentTokenToRedeem
    ) internal returns (uint256 totalFeesLong, uint256 totalFeesShort) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_calculateBatchedNextPriceFees"))){
      
      return mocker._calculateBatchedNextPriceFeesMock(marketIndex,amountOfPaymentTokenToRedeem,shortAmountOfPaymentTokenToRedeem);
    }
  
                                if (amountOfPaymentTokenToRedeem > shortAmountOfPaymentTokenToRedeem) {
            uint256 delta =
                amountOfPaymentTokenToRedeem -
                    shortAmountOfPaymentTokenToRedeem;
            totalFeesLong = _getFeesGeneral(
                marketIndex,
                delta,
                MarketSide.Short,
                MarketSide.Long,
                0,
                badLiquidityExitFee[marketIndex]
            );
        } else {
            uint256 delta =
                shortAmountOfPaymentTokenToRedeem -
                    amountOfPaymentTokenToRedeem;
            totalFeesShort = _getFeesGeneral(
                marketIndex,
                delta,
                MarketSide.Long,
                MarketSide.Short,
                0,
                badLiquidityExitFee[marketIndex]
            );
        }

        _feesMechanism(marketIndex, totalFeesLong + totalFeesShort);
    }

    function calculateRedeemPriceSnapshot(
        uint32 marketIndex,
        uint256 amountOfPaymentTokenToRedeem,
        MarketSide syntheticTokenType
    ) internal returns (uint256 batchLongTotalWithdrawnPaymentToken) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("calculateRedeemPriceSnapshot"))){
      
      return mocker.calculateRedeemPriceSnapshotMock(marketIndex,amountOfPaymentTokenToRedeem,syntheticTokenType);
    }
  
        if (amountOfPaymentTokenToRedeem > 0) {
            redeemPriceSnapshot[marketIndex][syntheticTokenType][
                marketUpdateIndex[marketIndex]
            ] = getPrice(
                batchedNextPriceSynthRedeemAmount[marketIndex][
                    syntheticTokenType
                ],
                amountOfPaymentTokenToRedeem
            );

                        return
                getAmountPaymentToken(
                    batchedNextPriceSynthRedeemAmount[marketIndex][
                        syntheticTokenType
                    ],
                    redeemPriceSnapshot[marketIndex][syntheticTokenType][
                        marketUpdateIndex[marketIndex]
                    ]
                );
        }
    }

    function handleBatchedNextPriceRedeems(uint32 marketIndex)
        internal
        returns (bool wasABatchedSettlement)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("handleBatchedNextPriceRedeems"))){
      
      return mocker.handleBatchedNextPriceRedeemsMock(marketIndex);
    }
  
        uint256 batchedNextPriceSynthToRedeemLong =
            batchedNextPriceSynthRedeemAmount[marketIndex][MarketSide.Long];
        uint256 batchedNextPriceSynthToRedeemShort =
            batchedNextPriceSynthRedeemAmount[marketIndex][MarketSide.Short];

        bool longBatchExisted =
            _handleBatchedNextPriceRedeem(
                marketIndex,
                MarketSide.Long,
                batchedNextPriceSynthToRedeemLong
            );
        bool shortBatchExisted =
            _handleBatchedNextPriceRedeem(
                marketIndex,
                MarketSide.Short,
                batchedNextPriceSynthToRedeemShort
            );

        uint256 longAmountOfPaymentTokenToRedeem =
            getAmountPaymentToken(
                batchedNextPriceSynthToRedeemLong,
                syntheticTokenPrice[marketIndex][MarketSide.Long]
            );

        uint256 shortAmountOfPaymentTokenToRedeem =
            getAmountPaymentToken(
                batchedNextPriceSynthToRedeemShort,
                syntheticTokenPrice[marketIndex][MarketSide.Short]
            );

        (uint256 totalFeesLong, uint256 totalFeesShort) =
            _calculateBatchedNextPriceFees(
                marketIndex,
                longAmountOfPaymentTokenToRedeem,
                shortAmountOfPaymentTokenToRedeem
            );

        uint256 batchShortTotalWithdrawnPaymentToken =
            calculateRedeemPriceSnapshot(
                marketIndex,
                shortAmountOfPaymentTokenToRedeem - totalFeesShort,
                MarketSide.Short
            );

        uint256 batchLongTotalWithdrawnPaymentToken =
            calculateRedeemPriceSnapshot(
                marketIndex,
                longAmountOfPaymentTokenToRedeem - totalFeesLong,
                MarketSide.Long
            );

        _withdrawFunds(
            marketIndex,
            batchLongTotalWithdrawnPaymentToken,
            batchShortTotalWithdrawnPaymentToken,
            address(this)
        );

                _refreshTokenPrices(marketIndex);

        batchedNextPriceSynthRedeemAmount[marketIndex][MarketSide.Long] = 0;
        batchedNextPriceSynthRedeemAmount[marketIndex][MarketSide.Short] = 0;
        wasABatchedSettlement = longBatchExisted || longBatchExisted;
    }
}
