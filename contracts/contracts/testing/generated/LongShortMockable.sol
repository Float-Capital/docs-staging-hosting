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


            
        address public admin;     uint32 public latestMarket;
    mapping(uint32 => bool) public marketExists;

        address public treasury;

        ITokenFactory public tokenFactory;

        IStaker public staker;
    uint256[45] private __globalStateGap;

        address public constant DEAD_ADDRESS =
        0xf10A7_F10A7_f10A7_F10a7_F10A7_f10a7_F10A7_f10a7;
    uint256 public constant TEN_TO_THE_18 = 1e18;
    int256 public constant TEN_TO_THE_18_SIGNED = 1e18;
    uint256 public constant feeUnitsOfPrecision = 10000;
    uint256[45] private __constantsGap;

        mapping(MarketSide => mapping(uint32 => uint256))
        public syntheticTokenBackedValue;
    mapping(uint32 => uint256) public totalValueLockedInYieldManager;
    mapping(uint32 => uint256) public totalValueReservedForTreasury;
    mapping(uint32 => uint256) public assetPrice;
    mapping(MarketSide => mapping(uint32 => uint256))
        public syntheticTokenPrice;     mapping(uint32 => IERC20) public fundTokens;
    mapping(uint32 => IYieldManager) public yieldManagers;
    mapping(uint32 => IOracleManager) public oracleManagers;
    uint256[45] private __marketStateGap;

        mapping(MarketSide => mapping(uint32 => ISyntheticToken))
        public syntheticTokens;
    uint256[45] private __marketSynthsGap;

            mapping(uint32 => uint256) public baseEntryFee;
    mapping(uint32 => uint256) public badLiquidityEntryFee;
    mapping(uint32 => uint256) public baseExitFee;
    mapping(uint32 => uint256) public badLiquidityExitFee;
    uint256[45] private __feeInfo;

        mapping(uint32 => uint256) public latestUpdateIndex;
        mapping(uint32 => mapping(uint256 => mapping(MarketSide => uint256)))
        public mintPriceSnapshot;
    mapping(uint32 => mapping(uint256 => mapping(MarketSide => uint256)))
        public redeemPriceSnapshot;

        mapping(uint32 => mapping(MarketSide => uint256))
        public batchedLazyPaymentTokenToDeposit;
    mapping(uint32 => mapping(MarketSide => uint256))
        public batchedLazySynthToRedeem;

    mapping(uint32 => mapping(address => mapping(MarketSide => uint256)))
        public userLazyRedemptions;
    mapping(uint32 => mapping(address => mapping(MarketSide => uint256)))
        public userLazyDepositAmounts;
    mapping(uint32 => mapping(address => uint256))
        public userCurrentLazyUpdateIndex;

            
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

        event ExecuteNextPriceSettlementnsUser();

            
    


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
                syntheticTokens[MarketSide.Long][marketIndex] == syntheticToken,
                "Incorrect synthetic token"
            );
        } else {
            require(
                syntheticTokens[MarketSide.Short][marketIndex] ==
                    syntheticToken,
                "Incorrect synthetic token"
            );
        }
        _;
    
    }
  }

    modifier executeOutstandingLazySettlements(address user, uint32 marketIndex)
        virtual {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("executeOutstandingLazySettlements"))){
        
      mocker.executeOutstandingLazySettlementsMock(user,marketIndex);
      _;
    } else {
      
        _executeOutstandingLazySettlements(user, marketIndex);

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

                syntheticTokens[MarketSide.Long][latestMarket] = ISyntheticToken(
            tokenFactory.createTokenLong(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

                syntheticTokens[MarketSide.Short][latestMarket] = ISyntheticToken(
            tokenFactory.createTokenShort(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

                syntheticTokenPrice[MarketSide.Long][latestMarket] = TEN_TO_THE_18;
        syntheticTokenPrice[MarketSide.Short][latestMarket] = TEN_TO_THE_18;
        fundTokens[latestMarket] = IERC20(_fundToken);
        yieldManagers[latestMarket] = IYieldManager(_yieldManager);
        oracleManagers[latestMarket] = IOracleManager(_oracleManager);
        assetPrice[latestMarket] = uint256(
            oracleManagers[latestMarket].updatePrice()
        );

        emit SyntheticTokenCreated(
            latestMarket,
            address(syntheticTokens[MarketSide.Long][latestMarket]),
            address(syntheticTokens[MarketSide.Short][latestMarket]),
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

        syntheticTokens[MarketSide.Long][marketIndex].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );
        syntheticTokens[MarketSide.Short][marketIndex].mint(
            DEAD_ADDRESS,
            initialMarketSeed
        );

        syntheticTokenBackedValue[MarketSide.Long][
            marketIndex
        ] = initialMarketSeed;
        syntheticTokenBackedValue[MarketSide.Short][
            marketIndex
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
            syntheticTokens[MarketSide.Long][marketIndex],
            syntheticTokens[MarketSide.Short][marketIndex],
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
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                syntheticTokenBackedValue[MarketSide.Short][marketIndex];

        if (
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] >
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        ) {
            marketPcnt =
                ((syntheticTokenBackedValue[MarketSide.Long][marketIndex] -
                    syntheticTokenBackedValue[MarketSide.Short][marketIndex]) *
                    10000) /
                totalValueLockedInMarket;
        } else {
            marketPcnt =
                ((syntheticTokenBackedValue[MarketSide.Short][marketIndex] -
                    syntheticTokenBackedValue[MarketSide.Long][marketIndex]) *
                    10000) /
                totalValueLockedInMarket;
        }

        marketAmount = (marketPcnt * amount) / 10000;
        treasuryAmount = amount - marketAmount;
        require(amount == marketAmount + treasuryAmount);

        return (marketAmount, treasuryAmount);
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

    

    function getMarketSplit(uint32 marketIndex, uint256 amount)
        public
        view
        returns (uint256 longAmount, uint256 shortAmount)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getMarketSplit"))){
      
      return mocker.getMarketSplitMock(marketIndex,amount);
    }
  
                        uint256 longPcnt =
            (syntheticTokenBackedValue[MarketSide.Short][marketIndex] * 10000) /
                (syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                    syntheticTokenBackedValue[MarketSide.Short][marketIndex]);

        longAmount = (amount * longPcnt) / 10000;
        shortAmount = amount - longAmount;
        return (longAmount, shortAmount);
    }

    

    function _refreshTokenPrices(uint32 marketIndex) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_refreshTokenPrices"))){
      
      return mocker._refreshTokenPricesMock(marketIndex);
    }
  
        uint256 longTokenSupply =
            syntheticTokens[MarketSide.Long][marketIndex].totalSupply();

                if (longTokenSupply > 0) {
            syntheticTokenPrice[MarketSide.Long][marketIndex] =
                (syntheticTokenBackedValue[MarketSide.Long][marketIndex] *
                    TEN_TO_THE_18) /
                longTokenSupply;
        }

        uint256 shortTokenSupply =
            syntheticTokens[MarketSide.Short][marketIndex].totalSupply();
        if (shortTokenSupply > 0) {
            syntheticTokenPrice[MarketSide.Short][marketIndex] =
                (syntheticTokenBackedValue[MarketSide.Short][marketIndex] *
                    TEN_TO_THE_18) /
                shortTokenSupply;
        }

        emit TokenPriceRefreshed(
            marketIndex,
            syntheticTokenPrice[MarketSide.Long][marketIndex],
            syntheticTokenPrice[MarketSide.Short][marketIndex]
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
        syntheticTokenBackedValue[MarketSide.Long][marketIndex] += longAmount;
        syntheticTokenBackedValue[MarketSide.Short][marketIndex] += shortAmount;
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
                syntheticTokenBackedValue[MarketSide.Long][marketIndex],
                syntheticTokenBackedValue[MarketSide.Short][marketIndex]
            );

        int256 percentageChangeE18 =
            ((newAssetPrice - oldAssetPrice) * TEN_TO_THE_18_SIGNED) /
                oldAssetPrice;

        int256 valueChange = (percentageChangeE18 * min) / TEN_TO_THE_18_SIGNED;

        if (valueChange > 0) {
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] += uint256(
                valueChange
            );
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] -= uint256(
                valueChange
            );
        } else {
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] -= uint256(
                valueChange * -1
            );
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] += uint256(
                valueChange * -1
            );
        }

        return true;
    }

    function handleBatchedDepositSettlement(
        uint32 marketIndex,
        MarketSide syntheticTokenType
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("handleBatchedDepositSettlement"))){
      
      return mocker.handleBatchedDepositSettlementMock(marketIndex,syntheticTokenType);
    }
  
        uint256 amountToBatchDeposit =
            batchedLazyPaymentTokenToDeposit[marketIndex][syntheticTokenType];

        if (amountToBatchDeposit > 0) {
            batchedLazyPaymentTokenToDeposit[marketIndex][
                syntheticTokenType
            ] = 0;
            _transferFundsToYieldManager(marketIndex, amountToBatchDeposit);

                        uint256 numberOfTokens =
                (amountToBatchDeposit * TEN_TO_THE_18) /
                    syntheticTokenPrice[syntheticTokenType][marketIndex];

                        syntheticTokens[syntheticTokenType][marketIndex].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenBackedValue[syntheticTokenType][
                marketIndex
            ] += amountToBatchDeposit;

                        uint256 oldTokenLongPrice =
                syntheticTokenPrice[MarketSide.Long][marketIndex];
            uint256 oldTokenShortPrice =
                syntheticTokenPrice[MarketSide.Short][marketIndex];

                                                _refreshTokenPrices(marketIndex);

            assert(
                syntheticTokenPrice[MarketSide.Long][marketIndex] ==
                    oldTokenLongPrice
            );
            assert(
                syntheticTokenPrice[MarketSide.Short][marketIndex] ==
                    oldTokenShortPrice
            );
        }
    }

    function snapshotPriceChangeForNextPriceExecution(
        uint32 marketIndex,
        uint256 newLatestPriceStateIndex
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("snapshotPriceChangeForNextPriceExecution"))){
      
      return mocker.snapshotPriceChangeForNextPriceExecutionMock(marketIndex,newLatestPriceStateIndex);
    }
  
                mintPriceSnapshot[marketIndex][newLatestPriceStateIndex][
            MarketSide.Long
        ] = syntheticTokenPrice[MarketSide.Long][marketIndex];
        mintPriceSnapshot[marketIndex][newLatestPriceStateIndex][
            MarketSide.Short
        ] = syntheticTokenPrice[MarketSide.Short][marketIndex];
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
            syntheticTokenPrice[MarketSide.Long][marketIndex],
            syntheticTokenPrice[MarketSide.Short][marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );

        assert(
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] != 0 &&
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] != 0
        );

                _claimAndDistributeYield(marketIndex);

                int256 newAssetPrice = oracleManagers[marketIndex].updatePrice();

                emit PriceUpdate(
            marketIndex,
            assetPrice[marketIndex],
            uint256(newAssetPrice),
            msg.sender
        );

                bool priceChanged =
            _adjustMarketBasedOnNewAssetPrice(marketIndex, newAssetPrice);

                _refreshTokenPrices(marketIndex);
        assetPrice[marketIndex] = uint256(newAssetPrice);

        if (priceChanged) {
            uint256 newLatestPriceStateIndex =
                latestUpdateIndex[marketIndex] + 1;
            latestUpdateIndex[marketIndex] = newLatestPriceStateIndex;
            snapshotPriceChangeForNextPriceExecution(
                marketIndex,
                newLatestPriceStateIndex
            );

            handleBatchedDepositSettlement(marketIndex, MarketSide.Long);
            handleBatchedDepositSettlement(marketIndex, MarketSide.Short);
            handleBatchedLazyRedeems(marketIndex);

            emit BatchedActionsSettled(
                marketIndex,
                newLatestPriceStateIndex,
                mintPriceSnapshot[marketIndex][newLatestPriceStateIndex][
                    MarketSide.Long
                ],
                mintPriceSnapshot[marketIndex][newLatestPriceStateIndex][
                    MarketSide.Short
                ],
                redeemPriceSnapshot[marketIndex][newLatestPriceStateIndex][
                    MarketSide.Long
                ],
                redeemPriceSnapshot[marketIndex][newLatestPriceStateIndex][
                    MarketSide.Short
                ]
            );
        }

        emit ValueLockedInSystem(
            marketIndex,
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                syntheticTokenBackedValue[MarketSide.Short][marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );
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

        assert(
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] >=
                amountLong &&
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] >=
                amountShort
        );

        _transferFromYieldManager(marketIndex, totalAmount);

                fundTokens[marketIndex].transfer(user, totalAmount);

        syntheticTokenBackedValue[MarketSide.Long][marketIndex] -= amountLong;
        syntheticTokenBackedValue[MarketSide.Short][marketIndex] -= amountShort;
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
                syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                    syntheticTokenBackedValue[MarketSide.Short][marketIndex] +
                    totalValueReservedForTreasury[marketIndex]
        );
    }

    

            function _getFeesGeneral(
        uint32 marketIndex,
        uint256 delta,         MarketSide synthTokenGainingDominance,
        MarketSide synthTokenLosingDominance,
        uint256 baseFeePercent,
        uint256 penultyFeePercent
    ) internal view returns (uint256) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getFeesGeneral"))){
      
      return mocker._getFeesGeneralMock(marketIndex,delta,synthTokenGainingDominance,synthTokenLosingDominance,baseFeePercent,penultyFeePercent);
    }
  
        uint256 baseFee = (delta * baseFeePercent) / feeUnitsOfPrecision;

        if (
            syntheticTokenBackedValue[synthTokenGainingDominance][
                marketIndex
            ] >=
            syntheticTokenBackedValue[synthTokenLosingDominance][marketIndex]
        ) {
                        return
                baseFee + ((delta * penultyFeePercent) / feeUnitsOfPrecision);
        } else if (
            syntheticTokenBackedValue[synthTokenGainingDominance][marketIndex] +
                delta >
            syntheticTokenBackedValue[synthTokenLosingDominance][marketIndex]
        ) {
            uint256 amountImbalancing =
                delta -
                    (syntheticTokenBackedValue[synthTokenLosingDominance][
                        marketIndex
                    ] -
                        syntheticTokenBackedValue[synthTokenGainingDominance][
                            marketIndex
                        ]);
            uint256 penaltyFee =
                (amountImbalancing * penultyFeePercent) / feeUnitsOfPrecision;

            return baseFee + penaltyFee;
        } else {
            return baseFee;
        }
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
            userCurrentLazyUpdateIndex[marketIndex][user] <=
            latestUpdateIndex[marketIndex]
        ) {
                                    uint256 amountPaymentTokenDeposited =
                userLazyDepositAmounts[marketIndex][user][syntheticTokenType];

            uint256 tokens =
                getAmountSynthToken(
                    amountPaymentTokenDeposited,
                    syntheticTokenPrice[syntheticTokenType][marketIndex]
                );

            return tokens;
        } else {
            return 0;
        }
    }

    function _executeLazyMintsIfTheyExist(
        uint32 marketIndex,
        address user,
        MarketSide syntheticTokenType
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeLazyMintsIfTheyExist"))){
      
      return mocker._executeLazyMintsIfTheyExistMock(marketIndex,user,syntheticTokenType);
    }
  
        uint256 currentDepositAmount =
            userLazyDepositAmounts[marketIndex][user][syntheticTokenType];
        if (currentDepositAmount > 0) {
            uint256 tokensToMint =
                (currentDepositAmount * TEN_TO_THE_18) /
                    mintPriceSnapshot[marketIndex][
                        userCurrentLazyUpdateIndex[marketIndex][user]
                    ][syntheticTokenType];

            syntheticTokens[syntheticTokenType][marketIndex].transfer(
                user,
                tokensToMint
            );

            userLazyDepositAmounts[marketIndex][user][syntheticTokenType] = 0;
        }
    }

    function _executeOutstandingLazySettlementsAction(
        address user,
        uint32 marketIndex
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingLazySettlementsAction"))){
      
      return mocker._executeOutstandingLazySettlementsActionMock(user,marketIndex);
    }
  
        _executeLazyMintsIfTheyExist(marketIndex, user, MarketSide.Long);
        _executeLazyMintsIfTheyExist(marketIndex, user, MarketSide.Short);
        _executeOutstandingLazyRedeems(marketIndex, user, MarketSide.Long);
        _executeOutstandingLazyRedeems(marketIndex, user, MarketSide.Short);

        userCurrentLazyUpdateIndex[marketIndex][user] = 0;
    }

            function _executeOutstandingLazySettlements(
        address user,
        uint32 marketIndex     ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingLazySettlements"))){
      
      return mocker._executeOutstandingLazySettlementsMock(user,marketIndex);
    }
  
        uint256 currentUpdateIndex =
            userCurrentLazyUpdateIndex[marketIndex][user];
        if (
            currentUpdateIndex <= latestUpdateIndex[marketIndex] &&
            currentUpdateIndex != 0         ) {
            _executeOutstandingLazySettlementsAction(user, marketIndex);

            emit ExecuteNextPriceSettlementnsUser();
        }
    }

    function executeOutstandingLazySettlementsUser(
        address user,
        uint32 marketIndex
    ) external override {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("executeOutstandingLazySettlementsUser"))){
      
      return mocker.executeOutstandingLazySettlementsUserMock(user,marketIndex);
    }
  
                _executeOutstandingLazySettlements(user, marketIndex);
    }

    function _mintLazy(
        uint32 marketIndex,
        uint256 amount,
        MarketSide syntheticTokenType
    ) internal executeOutstandingLazySettlements(msg.sender, marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_mintLazy"))){
      
      return mocker._mintLazyMock(marketIndex,amount,syntheticTokenType);
    }
  
                        _depositFunds(marketIndex, amount);

        batchedLazyPaymentTokenToDeposit[marketIndex][
            syntheticTokenType
        ] += amount;
        userLazyDepositAmounts[marketIndex][msg.sender][
            syntheticTokenType
        ] += amount;
        userCurrentLazyUpdateIndex[marketIndex][msg.sender] =
            latestUpdateIndex[marketIndex] +
            1;

        emit NextPriceDeposit(
            marketIndex,
            syntheticTokenType,
            amount,
            msg.sender,
            latestUpdateIndex[marketIndex] + 1
        );
    }

    function mintLongLazy(uint32 marketIndex, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintLongLazy"))){
      
      return mocker.mintLongLazyMock(marketIndex,amount);
    }
  
        _mintLazy(marketIndex, amount, MarketSide.Long);
    }

    function mintShortLazy(uint32 marketIndex, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintShortLazy"))){
      
      return mocker.mintShortLazyMock(marketIndex,amount);
    }
  
        _mintLazy(marketIndex, amount, MarketSide.Short);
    }

    function _executeOutstandingLazyRedeems(
        uint32 marketIndex,
        address user,
        MarketSide syntheticTokenType
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingLazyRedeems"))){
      
      return mocker._executeOutstandingLazyRedeemsMock(marketIndex,user,syntheticTokenType);
    }
  
        uint256 currentRedemptions =
            userLazyRedemptions[marketIndex][user][syntheticTokenType];
        if (currentRedemptions > 0) {
            uint256 amountToRedeem =
                getAmountPaymentToken(
                    currentRedemptions,
                    redeemPriceSnapshot[marketIndex][
                        userCurrentLazyUpdateIndex[marketIndex][user]
                    ][syntheticTokenType]
                );

            uint256 balance = fundTokens[marketIndex].balanceOf(address(this));

            fundTokens[marketIndex].transfer(user, amountToRedeem);
            userLazyRedemptions[marketIndex][user][syntheticTokenType] = 0;
        }
    }

    function _redeemLazy(
        uint32 marketIndex,
        uint256 tokensToRedeem,
        MarketSide syntheticTokenType
    ) internal executeOutstandingLazySettlements(msg.sender, marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_redeemLazy"))){
      
      return mocker._redeemLazyMock(marketIndex,tokensToRedeem,syntheticTokenType);
    }
  
        syntheticTokens[syntheticTokenType][marketIndex].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );
        uint256 nextUpdateIndex = latestUpdateIndex[marketIndex] + 1;

        userLazyRedemptions[marketIndex][msg.sender][
            syntheticTokenType
        ] += tokensToRedeem;
        userCurrentLazyUpdateIndex[marketIndex][msg.sender] = nextUpdateIndex;

        batchedLazySynthToRedeem[marketIndex][
            syntheticTokenType
        ] += tokensToRedeem;

        emit NextPriceRedeem(
            marketIndex,
            syntheticTokenType,
            tokensToRedeem,
            msg.sender,
            latestUpdateIndex[marketIndex] + 1
        );
    }

    function redeemLongLazy(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemLongLazy"))){
      
      return mocker.redeemLongLazyMock(marketIndex,tokensToRedeem);
    }
  
        _redeemLazy(marketIndex, tokensToRedeem, MarketSide.Long);
    }

    function redeemShortLazy(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemShortLazy"))){
      
      return mocker.redeemShortLazyMock(marketIndex,tokensToRedeem);
    }
  
        _redeemLazy(marketIndex, tokensToRedeem, MarketSide.Short);
    }

    function _handleBatchedLazyRedeem(
        uint32 marketIndex,
        MarketSide syntheticTokenType,
        uint256 amountSynthToRedeem
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_handleBatchedLazyRedeem"))){
      
      return mocker._handleBatchedLazyRedeemMock(marketIndex,syntheticTokenType,amountSynthToRedeem);
    }
  
        if (amountSynthToRedeem > 0) {
            syntheticTokens[syntheticTokenType][marketIndex].synthRedeemBurn(
                address(this),
                amountSynthToRedeem
            );
        }
    }

    function _calculateBatchedLazyFees(
        uint32 marketIndex,
        uint256 amountOfPaymentTokenToRedeem,
        uint256 shortAmountOfPaymentTokenToRedeem
    ) internal returns (uint256 totalFeesLong, uint256 totalFeesShort) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_calculateBatchedLazyFees"))){
      
      return mocker._calculateBatchedLazyFeesMock(marketIndex,amountOfPaymentTokenToRedeem,shortAmountOfPaymentTokenToRedeem);
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
            redeemPriceSnapshot[marketIndex][latestUpdateIndex[marketIndex]][
                syntheticTokenType
            ] = getPrice(
                batchedLazySynthToRedeem[marketIndex][syntheticTokenType],
                amountOfPaymentTokenToRedeem
            );

                        return
                getAmountPaymentToken(
                    batchedLazySynthToRedeem[marketIndex][syntheticTokenType],
                    redeemPriceSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][syntheticTokenType]
                );
        }
    }

    function handleBatchedLazyRedeems(uint32 marketIndex) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("handleBatchedLazyRedeems"))){
      
      return mocker.handleBatchedLazyRedeemsMock(marketIndex);
    }
  
        uint256 batchedLazySynthToRedeemLong =
            batchedLazySynthToRedeem[marketIndex][MarketSide.Long];
        uint256 batchedLazySynthToRedeemShort =
            batchedLazySynthToRedeem[marketIndex][MarketSide.Short];

        _handleBatchedLazyRedeem(
            marketIndex,
            MarketSide.Long,
            batchedLazySynthToRedeemLong
        );
        _handleBatchedLazyRedeem(
            marketIndex,
            MarketSide.Short,
            batchedLazySynthToRedeemShort
        );

        uint256 longAmountOfPaymentTokenToRedeem =
            getAmountPaymentToken(
                batchedLazySynthToRedeemLong,
                syntheticTokenPrice[MarketSide.Long][marketIndex]
            );

        uint256 shortAmountOfPaymentTokenToRedeem =
            getAmountPaymentToken(
                batchedLazySynthToRedeemShort,
                syntheticTokenPrice[MarketSide.Short][marketIndex]
            );

        (uint256 totalFeesLong, uint256 totalFeesShort) =
            _calculateBatchedLazyFees(
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

        batchedLazySynthToRedeem[marketIndex][MarketSide.Long] = 0;
        batchedLazySynthToRedeem[marketIndex][MarketSide.Short] = 0;
    }
}
