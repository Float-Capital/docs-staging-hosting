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
    uint256 public constant feeUnitsOfPrecision = 10000;
    uint256[45] private __constantsGap;

        mapping(MarketSide => mapping(uint32 => uint256))
        public syntheticTokenBackedValue;
    mapping(uint32 => uint256) public totalValueLockedInMarket;
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

    event LongMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        uint256 finalDepositAmount,
        uint256 tokensMinted,
        address user
    );

    event LazyLongMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        address user,
        uint256 totalBatchedDepositAmount,
        uint256 oracleUpdateIndex
    );

    event LazyLongStaked(
        uint32 marketIndex,
        uint256 depositAdded,
        address user,
        uint256 totalBatchedDepositAmount,
        uint256 oracleUpdateIndex
    );

    event ShortMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        uint256 finalDepositAmount,
        uint256 tokensMinted,
        address user
    );

    event LazyShortMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        address user,
        uint256 totalBatchedDepositAmount,
        uint256 oracleUpdateIndex
    );

    event LazyShortStaked(
        uint32 marketIndex,
        uint256 depositAdded,
        address user,
        uint256 totalBatchedDepositAmount,
        uint256 oracleUpdateIndex
    );

    event LongRedeem(
        uint32 marketIndex,
        uint256 tokensRedeemed,
        uint256 valueOfRedemption,
        uint256 finalRedeemValue,
        address user
    );

    event ShortRedeem(
        uint32 marketIndex,
        uint256 tokensRedeemed,
        uint256 valueOfRedemption,
        uint256 finalRedeemValue,
        address user
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

    modifier doesMarketExist(uint32 marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("doesMarketExist"))){
      mocker.doesMarketExistMock(marketIndex);
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

    modifier refreshSystemState(uint32 marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("refreshSystemState"))){
      mocker.refreshSystemStateMock(marketIndex);
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

        percentageAvailableForEarlyExitNumerator = 80000;
        percentageAvailableForEarlyExitDenominator = 100000;

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

        emit ShortMinted(
            marketIndex,
            initialMarketSeed,
            initialMarketSeed,
            initialMarketSeed,
            DEAD_ADDRESS
        );
        emit LongMinted(
            marketIndex,
            initialMarketSeed,
            initialMarketSeed,
            initialMarketSeed,
            DEAD_ADDRESS
        );
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
  
        assert(totalValueLockedInMarket[marketIndex] != 0);

        uint256 marketPcnt;         if (
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] >
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        ) {
            marketPcnt =
                ((syntheticTokenBackedValue[MarketSide.Long][marketIndex] -
                    syntheticTokenBackedValue[MarketSide.Short][marketIndex]) *
                    10000) /
                totalValueLockedInMarket[marketIndex];
        } else {
            marketPcnt =
                ((syntheticTokenBackedValue[MarketSide.Short][marketIndex] -
                    syntheticTokenBackedValue[MarketSide.Long][marketIndex]) *
                    10000) /
                totalValueLockedInMarket[marketIndex];
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
  
        assert(totalValueLockedInMarket[marketIndex] != 0);

                        uint256 longPcnt =
            (syntheticTokenBackedValue[MarketSide.Short][marketIndex] * 10000) /
                (syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                    syntheticTokenBackedValue[MarketSide.Short][marketIndex]);

        longAmount = (amount * longPcnt) / 10000;
        shortAmount = amount - longAmount;
        return (longAmount, shortAmount);
    }

    

    function _refreshTokensPrice(uint32 marketIndex) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_refreshTokensPrice"))){
      
      return mocker._refreshTokensPriceMock(marketIndex);
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
        syntheticTokenBackedValue[MarketSide.Long][marketIndex] =
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
            longAmount;
        syntheticTokenBackedValue[MarketSide.Short][marketIndex] =
            syntheticTokenBackedValue[MarketSide.Short][marketIndex] +
            shortAmount;
    }

    

    function _feesMechanism(uint32 marketIndex, uint256 totalFees) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_feesMechanism"))){
      
      return mocker._feesMechanismMock(marketIndex,totalFees);
    }
  
                (uint256 marketAmount, uint256 treasuryAmount) =
            getTreasurySplit(marketIndex, totalFees);

                totalValueLockedInMarket[marketIndex] -= treasuryAmount;
        totalValueReservedForTreasury[marketIndex] += treasuryAmount;

        _distributeMarketAmount(marketIndex, marketAmount);
        emit FeesLevied(marketIndex, totalFees);
    }

    

    function _yieldMechanism(uint32 marketIndex) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_yieldMechanism"))){
      
      return mocker._yieldMechanismMock(marketIndex);
    }
  
        uint256 amount =
            yieldManagers[marketIndex].getTotalHeld() -
                totalValueLockedInYieldManager[marketIndex];

        if (amount > 0) {
            (uint256 marketAmount, uint256 treasuryAmount) =
                getTreasurySplit(marketIndex, amount);

                                    totalValueLockedInYieldManager[marketIndex] += amount;
            totalValueLockedInMarket[marketIndex] += marketAmount;
            totalValueReservedForTreasury[marketIndex] += treasuryAmount;

            _distributeMarketAmount(marketIndex, marketAmount);
        }
    }

    function _minimum(uint256 value1, uint256 value2)
        internal
        view
        returns (uint256)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_minimum"))){
      
      return mocker._minimumMock(value1,value2);
    }
  
        if (value1 < value2) {
            return value1;
        } else {
            return value2;
        }
    }

    function _calculateValueChangeForPriceMechanism(
        uint32 marketIndex,
        uint256 assetPriceGreater,
        uint256 assetPriceLess,
        uint256 baseValueExposure,
        MarketSide winningSyntheticTokenType,
        MarketSide losingSyntheticTokenType
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_calculateValueChangeForPriceMechanism"))){
      
      return mocker._calculateValueChangeForPriceMechanismMock(marketIndex,assetPriceGreater,assetPriceLess,baseValueExposure,winningSyntheticTokenType,losingSyntheticTokenType);
    }
  
        uint256 valueChange = 0;

        uint256 percentageChange =
            ((assetPriceGreater - assetPriceLess) * TEN_TO_THE_18) /
                assetPrice[marketIndex];

        valueChange = (baseValueExposure * percentageChange) / TEN_TO_THE_18;

        if (valueChange > baseValueExposure) {
                        valueChange = baseValueExposure;
        }

        syntheticTokenBackedValue[winningSyntheticTokenType][marketIndex] =
            syntheticTokenBackedValue[winningSyntheticTokenType][marketIndex] +
            valueChange;
        syntheticTokenBackedValue[losingSyntheticTokenType][marketIndex] =
            syntheticTokenBackedValue[losingSyntheticTokenType][marketIndex] -
            valueChange;
    }

    function _priceChangeMechanism(uint32 marketIndex, uint256 newPrice)
        internal
        returns (bool didUpdate)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_priceChangeMechanism"))){
      
      return mocker._priceChangeMechanismMock(marketIndex,newPrice);
    }
  
                if (assetPrice[marketIndex] == newPrice) {
            return false;
        }

        uint256 baseValueExposure =
            _minimum(
                syntheticTokenBackedValue[MarketSide.Long][marketIndex],
                syntheticTokenBackedValue[MarketSide.Short][marketIndex]
            );

                if (newPrice > assetPrice[marketIndex]) {
            _calculateValueChangeForPriceMechanism(
                marketIndex,
                newPrice,
                assetPrice[marketIndex],
                baseValueExposure,
                MarketSide.Long,
                MarketSide.Short
            );
        } else {
            _calculateValueChangeForPriceMechanism(
                marketIndex,
                assetPrice[marketIndex],
                newPrice,
                baseValueExposure,
                MarketSide.Short,
                MarketSide.Long
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
  
                NextActionValues storage currentMarketBatchedLazyDeposit =
            batchedLazyDeposit[marketIndex][syntheticTokenType];
        uint256 totalAmount =
            currentMarketBatchedLazyDeposit.mintAmount +
                currentMarketBatchedLazyDeposit.mintAndStakeAmount;

        if (totalAmount > 0) {
            _transferFundsToYieldManager(marketIndex, totalAmount);

            
                        uint256 numberOfTokens =
                (totalAmount * TEN_TO_THE_18) /
                    syntheticTokenPrice[syntheticTokenType][marketIndex];

            syntheticTokens[syntheticTokenType][marketIndex].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenBackedValue[syntheticTokenType][marketIndex] =
                syntheticTokenBackedValue[syntheticTokenType][marketIndex] +
                totalAmount;

                        uint256 oldTokenLongPrice =
                syntheticTokenPrice[MarketSide.Long][marketIndex];
            uint256 oldTokenShortPrice =
                syntheticTokenPrice[MarketSide.Short][marketIndex];

            _refreshTokensPrice(marketIndex);

            assert(
                syntheticTokenPrice[MarketSide.Long][marketIndex] ==
                    oldTokenLongPrice
            );
            assert(
                syntheticTokenPrice[MarketSide.Short][marketIndex] ==
                    oldTokenShortPrice
            );

            if (currentMarketBatchedLazyDeposit.mintAndStakeAmount > 0) {
                
                uint256 amountToStake =
                    (currentMarketBatchedLazyDeposit.mintAndStakeAmount *
                        TEN_TO_THE_18) /
                        syntheticTokenPrice[syntheticTokenType][marketIndex];

                staker.stakeFromMintBatched(
                    marketIndex,
                    amountToStake,
                    latestUpdateIndex[marketIndex],
                    syntheticTokenType
                );
                currentMarketBatchedLazyDeposit.mintAndStakeAmount = 0;
            }
                        currentMarketBatchedLazyDeposit.mintAmount = 0;
                    }
    }

    function snapshotPriceChangeForNextPriceExecution(uint32 marketIndex)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("snapshotPriceChangeForNextPriceExecution"))){
      
      return mocker.snapshotPriceChangeForNextPriceExecutionMock(marketIndex);
    }
  
        uint256 newLatestPriceStateIndex = latestUpdateIndex[marketIndex] + 1;
        latestUpdateIndex[marketIndex] = newLatestPriceStateIndex;

                marketStateSnapshot[marketIndex][newLatestPriceStateIndex][
            MarketSide.Long
        ] = syntheticTokenPrice[MarketSide.Long][marketIndex];
        marketStateSnapshot[marketIndex][newLatestPriceStateIndex][
            MarketSide.Short
        ] = syntheticTokenPrice[MarketSide.Short][marketIndex];
    }

    

    function _updateSystemStateInternal(uint32 marketIndex)
        internal
        doesMarketExist(marketIndex)
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

                _yieldMechanism(marketIndex);

                uint256 newPrice = uint256(oracleManagers[marketIndex].updatePrice());
        emit PriceUpdate(
            marketIndex,
            assetPrice[marketIndex],
            newPrice,
            msg.sender
        );

        bool priceChanged = _priceChangeMechanism(marketIndex, newPrice);
        assetPrice[marketIndex] = newPrice;

        _refreshTokensPrice(marketIndex);

        if (priceChanged) {
            snapshotPriceChangeForNextPriceExecution(marketIndex);

            handleBatchedDepositSettlement(marketIndex, MarketSide.Long);
            handleBatchedDepositSettlement(marketIndex, MarketSide.Short);
            handleBatchedLazyRedeems(marketIndex);
        }

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );

                assert(
            syntheticTokenBackedValue[MarketSide.Long][marketIndex] +
                syntheticTokenBackedValue[MarketSide.Short][marketIndex] ==
                totalValueLockedInMarket[marketIndex]
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

    

    function _transferFundsToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_transferFundsToYieldManager"))){
      
      return mocker._transferFundsToYieldManagerMock(marketIndex,amount);
    }
  
                totalValueLockedInMarket[marketIndex] =
            totalValueLockedInMarket[marketIndex] +
            amount;
        _transferToYieldManager(marketIndex, amount);
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
        uint256 amount,
        address user
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_withdrawFunds"))){
      
      return mocker._withdrawFundsMock(marketIndex,amount,user);
    }
  
        assert(totalValueLockedInMarket[marketIndex] >= amount);

        _transferFromYieldManager(marketIndex, amount);

                fundTokens[marketIndex].transfer(user, amount);

                totalValueLockedInMarket[marketIndex] =
            totalValueLockedInMarket[marketIndex] -
            amount;
    }

    

    function _transferToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_transferToYieldManager"))){
      
      return mocker._transferToYieldManagerMock(marketIndex,amount);
    }
  
        fundTokens[marketIndex].approve(
            address(yieldManagers[marketIndex]),
            amount
        );
        yieldManagers[marketIndex].depositToken(amount);

        
        totalValueLockedInYieldManager[marketIndex] += amount;

                        require(
            totalValueLockedInYieldManager[marketIndex] <=
                totalValueLockedInMarket[marketIndex] +
                    totalValueReservedForTreasury[marketIndex]
        );
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
                totalValueLockedInMarket[marketIndex] +
                    totalValueReservedForTreasury[marketIndex]
        );
    }

    

    function _getFeesGeneral(
        uint32 marketIndex,
        uint256 delta,         MarketSide synthTokenGainingDominance,
        MarketSide synthTokenLosingDominance,
        uint256 baseFee,
        uint256 penaltyFees
    ) internal view returns (uint256) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getFeesGeneral"))){
      
      return mocker._getFeesGeneralMock(marketIndex,delta,synthTokenGainingDominance,synthTokenLosingDominance,baseFee,penaltyFees);
    }
  
        uint256 baseFee = (delta * baseFee) / feeUnitsOfPrecision;

        if (
            syntheticTokenBackedValue[synthTokenGainingDominance][
                marketIndex
            ] >=
            syntheticTokenBackedValue[synthTokenLosingDominance][marketIndex]
        ) {
                        return baseFee + ((delta * penaltyFees) / feeUnitsOfPrecision);
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
                (amountImbalancing * penaltyFees) / feeUnitsOfPrecision;

            return baseFee + penaltyFee;
        } else {
            return baseFee;
        }
    }

    function _getFeesForMint(
        uint32 marketIndex,
        uint256 amount,         MarketSide syntheticTokenType
    ) internal view returns (uint256) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getFeesForMint"))){
      
      return mocker._getFeesForMintMock(marketIndex,amount,syntheticTokenType);
    }
  
        MarketSide otherSideSynthType = getOtherSynthType(syntheticTokenType);

        return
            _getFeesGeneral(
                marketIndex,
                amount,
                syntheticTokenType,
                otherSideSynthType,
                baseEntryFee[marketIndex],
                badLiquidityEntryFee[marketIndex]
            );
    }

    function _getFeesForRedeem(
        uint32 marketIndex,
        uint256 amount,         MarketSide syntheticTokenType
    ) internal view returns (uint256) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_getFeesForRedeem"))){
      
      return mocker._getFeesForRedeemMock(marketIndex,amount,syntheticTokenType);
    }
  
        MarketSide otherSideSynthType = getOtherSynthType(syntheticTokenType);

        return
            _getFeesGeneral(
                marketIndex,
                amount,
                otherSideSynthType,
                syntheticTokenType,
                baseExitFee[marketIndex],
                badLiquidityExitFee[marketIndex]
            );
    }

            
    

    function mintLong(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintLong"))){
      
      return mocker.mintLongMock(marketIndex,amount);
    }
  
                _lockFundsInMarket(marketIndex, amount);

        _mint(marketIndex, amount, msg.sender, msg.sender, MarketSide.Long);
    }

    

    function mintShort(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintShort"))){
      
      return mocker.mintShortMock(marketIndex,amount);
    }
  
                _lockFundsInMarket(marketIndex, amount);

        _mint(marketIndex, amount, msg.sender, msg.sender, MarketSide.Short);
    }

    

    function mintLongAndStake(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintLongAndStake"))){
      
      return mocker.mintLongAndStakeMock(marketIndex,amount);
    }
  
                _lockFundsInMarket(marketIndex, amount);

        uint256 tokensMinted =
            _mint(
                marketIndex,
                amount,
                msg.sender,
                address(staker),
                MarketSide.Long
            );

        staker.stakeFromMint(
            syntheticTokens[MarketSide.Long][marketIndex],
            tokensMinted,
            msg.sender
        );
    }

    

    function mintShortAndStake(uint32 marketIndex, uint256 amount)
        external
        refreshSystemState(marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintShortAndStake"))){
      
      return mocker.mintShortAndStakeMock(marketIndex,amount);
    }
  
                _lockFundsInMarket(marketIndex, amount);

        uint256 tokensMinted =
            _mint(
                marketIndex,
                amount,
                msg.sender,
                address(staker),
                MarketSide.Short
            );

        staker.stakeFromMint(
            syntheticTokens[MarketSide.Short][marketIndex],
            tokensMinted,
            msg.sender
        );
    }

    function _mint(
        uint32 marketIndex,
        uint256 amount,
        address user,
        address transferTo,
        MarketSide syntheticTokenType
    ) internal returns (uint256) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_mint"))){
      
      return mocker._mintMock(marketIndex,amount,user,transferTo,syntheticTokenType);
    }
  
        uint256 fees = _getFeesForMint(marketIndex, amount, syntheticTokenType);
        uint256 remaining = amount - fees;

                _feesMechanism(marketIndex, fees);
        _refreshTokensPrice(marketIndex);

                uint256 tokens =
            (remaining * TEN_TO_THE_18) /
                syntheticTokenPrice[syntheticTokenType][marketIndex];
        syntheticTokens[syntheticTokenType][marketIndex].mint(
            transferTo,
            tokens
        );
        syntheticTokenBackedValue[syntheticTokenType][marketIndex] =
            syntheticTokenBackedValue[syntheticTokenType][marketIndex] +
            remaining;

                if (syntheticTokenType == MarketSide.Long) {
            emit ShortMinted(marketIndex, amount, remaining, tokens, user);
        } else {
            emit LongMinted(marketIndex, amount, remaining, tokens, user);
        }

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );
        return tokens;
    }

            
    function _redeem(
        uint32 marketIndex,
        uint256 tokensToRedeem,
        MarketSide syntheticTokenType
    ) internal refreshSystemState(marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_redeem"))){
      
      return mocker._redeemMock(marketIndex,tokensToRedeem,syntheticTokenType);
    }
  
                syntheticTokens[syntheticTokenType][marketIndex].synthRedeemBurn(
            msg.sender,
            tokensToRedeem
        );

                uint256 amount =
            (tokensToRedeem *
                syntheticTokenPrice[syntheticTokenType][marketIndex]) /
                TEN_TO_THE_18;
        uint256 fees =
            _getFeesForRedeem(marketIndex, amount, syntheticTokenType);
        uint256 remaining = amount - fees;

                _feesMechanism(marketIndex, fees);

                syntheticTokenBackedValue[syntheticTokenType][marketIndex] =
            syntheticTokenBackedValue[syntheticTokenType][marketIndex] -
            amount;
        _withdrawFunds(marketIndex, remaining, msg.sender);
        _refreshTokensPrice(marketIndex);

                if (syntheticTokenType == MarketSide.Long) {
            emit LongRedeem(
                marketIndex,
                tokensToRedeem,
                amount,
                remaining,
                msg.sender
            );
        } else {
            emit ShortRedeem(
                marketIndex,
                tokensToRedeem,
                amount,
                remaining,
                msg.sender
            );
        }

        emit ValueLockedInSystem(
            marketIndex,
            totalValueLockedInMarket[marketIndex],
            syntheticTokenBackedValue[MarketSide.Long][marketIndex],
            syntheticTokenBackedValue[MarketSide.Short][marketIndex]
        );
    }

    function redeemLong(uint32 marketIndex, uint256 tokensToRedeem)
        external
        override
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemLong"))){
      
      return mocker.redeemLongMock(marketIndex,tokensToRedeem);
    }
  
        _redeem(marketIndex, tokensToRedeem, MarketSide.Long);
    }

    function redeemLongAll(uint32 marketIndex) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemLongAll"))){
      
      return mocker.redeemLongAllMock(marketIndex);
    }
  
        uint256 tokensToRedeem =
            syntheticTokens[MarketSide.Long][marketIndex].balanceOf(msg.sender);
        _redeem(marketIndex, tokensToRedeem, MarketSide.Long);
    }

    function redeemShort(uint32 marketIndex, uint256 tokensToRedeem)
        external
        override
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemShort"))){
      
      return mocker.redeemShortMock(marketIndex,tokensToRedeem);
    }
  
        _redeem(marketIndex, tokensToRedeem, MarketSide.Short);
    }

    function redeemShortAll(uint32 marketIndex) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemShortAll"))){
      
      return mocker.redeemShortAllMock(marketIndex);
    }
  
        uint256 tokensToRedeem =
            syntheticTokens[MarketSide.Short][marketIndex].balanceOf(
                msg.sender
            );
        _redeem(marketIndex, tokensToRedeem, MarketSide.Short);
    }

            
    

    function transferTreasuryFunds(uint32 marketIndex) external treasuryOnly {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("transferTreasuryFunds"))){
      
      return mocker.transferTreasuryFundsMock(marketIndex);
    }
  
                if (totalValueReservedForTreasury[marketIndex] == 0) {
            return;
        }

        _transferFromYieldManager(
            marketIndex,
            totalValueReservedForTreasury[marketIndex]
        );

                fundTokens[marketIndex].transfer(
            treasury,
            totalValueReservedForTreasury[marketIndex]
        );

                totalValueReservedForTreasury[marketIndex] = 0;
    }

        
        struct NextActionValues {
        uint256 mintAmount;
        uint256 mintAndStakeAmount;
    }
    struct UserLazyDeposit {
        uint256 usersCurrentUpdateIndex;
        NextActionValues[2] nextActionValues;
    }

    mapping(uint32 => uint256) public latestUpdateIndex;
    mapping(uint32 => mapping(uint256 => mapping(MarketSide => uint256)))
        public marketStateSnapshot;
    mapping(uint32 => mapping(MarketSide => NextActionValues))
        public batchedLazyDeposit;
    mapping(uint32 => mapping(address => UserLazyDeposit))
        public userLazyActions;

        uint256 public percentageAvailableForEarlyExitNumerator;
    uint256 public percentageAvailableForEarlyExitDenominator;

    function getUsersPendingBalance(
        address user,
        uint32 marketIndex,
        MarketSide syntheticTokenType
    )
        external
        view
        override
        doesMarketExist(marketIndex)
        returns (uint256 pendingBalance)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getUsersPendingBalance"))){
      
      return mocker.getUsersPendingBalanceMock(user,marketIndex,syntheticTokenType);
    }
  
        UserLazyDeposit storage currentUserDeposits =
            userLazyActions[marketIndex][user];

        if (
            currentUserDeposits.usersCurrentUpdateIndex <=
            latestUpdateIndex[marketIndex]
        ) {
                                    uint256 remaining =
                currentUserDeposits.nextActionValues[uint8(syntheticTokenType)]
                    .mintAmount;

            uint256 tokens =
                (remaining * TEN_TO_THE_18) /
                    syntheticTokenPrice[syntheticTokenType][marketIndex];

            return tokens;
        } else {
            return 0;
        }
    }

    function _executeLazyMintsIfTheyExist(
        uint32 marketIndex,
        address user,
        MarketSide syntheticTokenType,
        UserLazyDeposit storage currentUserDeposits
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeLazyMintsIfTheyExist"))){
      
          UserLazyDeposit memory  currentUserDeposits_temp1 = currentUserDeposits;
        
      return mocker._executeLazyMintsIfTheyExistMock(marketIndex,user,syntheticTokenType,currentUserDeposits_temp1);
    }
  
        if (
            currentUserDeposits.nextActionValues[uint8(syntheticTokenType)]
                .mintAmount != 0
        ) {
            uint256 tokensToMint =
                (((
                    currentUserDeposits.nextActionValues[
                        uint8(syntheticTokenType)
                    ]
                        .mintAmount
                ) * TEN_TO_THE_18) /
                    marketStateSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][syntheticTokenType]);

            syntheticTokens[syntheticTokenType][marketIndex].transfer(
                user,
                tokensToMint
            );

            currentUserDeposits.nextActionValues[uint8(syntheticTokenType)]
                .mintAmount = 0;
        }
    }

    function _executeOutstandingLazySettlementsAction(
        address user,
        uint32 marketIndex,
        UserLazyDeposit storage currentUserDeposits
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingLazySettlementsAction"))){
      
          UserLazyDeposit memory  currentUserDeposits_temp1 = currentUserDeposits;
        
      return mocker._executeOutstandingLazySettlementsActionMock(user,marketIndex,currentUserDeposits_temp1);
    }
  
        _executeLazyMintsIfTheyExist(
            marketIndex,
            user,
            MarketSide.Long,
            currentUserDeposits
        );
        _executeLazyMintsIfTheyExist(
            marketIndex,
            user,
            MarketSide.Short,
            currentUserDeposits
        );

        if (
            currentUserDeposits.nextActionValues[uint8(MarketSide.Long)]
                .mintAndStakeAmount !=
            0 ||
            currentUserDeposits.nextActionValues[uint8(MarketSide.Short)]
                .mintAndStakeAmount !=
            0
        ) {
            uint256 tokensToStakeShort =
                ((currentUserDeposits.nextActionValues[uint8(MarketSide.Short)]
                    .mintAndStakeAmount * TEN_TO_THE_18) /
                    marketStateSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][MarketSide.Short]);
            uint256 tokensToStakeLong =
                ((currentUserDeposits.nextActionValues[uint8(MarketSide.Long)]
                    .mintAndStakeAmount * TEN_TO_THE_18) /
                    marketStateSnapshot[marketIndex][
                        latestUpdateIndex[marketIndex]
                    ][MarketSide.Long]);
            staker.transferBatchStakeToUser(
                tokensToStakeLong,
                tokensToStakeShort,
                marketIndex,
                currentUserDeposits.usersCurrentUpdateIndex,
                user
            );

                        currentUserDeposits.nextActionValues[uint8(MarketSide.Long)]
                .mintAndStakeAmount = 0;
            currentUserDeposits.nextActionValues[uint8(MarketSide.Short)]
                .mintAndStakeAmount = 0;
        }
        currentUserDeposits.usersCurrentUpdateIndex = 0;
    }

            function _executeOutstandingLazySettlements(
        address user,
        uint32 marketIndex     ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingLazySettlements"))){
      
      return mocker._executeOutstandingLazySettlementsMock(user,marketIndex);
    }
  
        UserLazyDeposit storage currentUserDeposits =
            userLazyActions[marketIndex][user];

        if (
            currentUserDeposits.usersCurrentUpdateIndex <=
            latestUpdateIndex[marketIndex] &&
            currentUserDeposits.usersCurrentUpdateIndex != 0         ) {
            _executeOutstandingLazySettlementsAction(
                user,
                marketIndex,
                currentUserDeposits
            );
        }
            }

    function executeOutstandingLazySettlementsSynth(
        address user,
        uint32 marketIndex,
        MarketSide syntheticTokenType
    )
        external
        override
        isCorrectSynth(
            marketIndex,
            syntheticTokenType,
            ISyntheticToken(msg.sender)
        )
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("executeOutstandingLazySettlementsSynth"))){
      
      return mocker.executeOutstandingLazySettlementsSynthMock(user,marketIndex,syntheticTokenType);
    }
  
                _executeOutstandingLazySettlements(user, marketIndex);
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

    function _mintLazy(
        uint32 marketIndex,
        uint256 amount,
        MarketSide syntheticTokenType
    ) internal executeOutstandingLazySettlements(msg.sender, marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_mintLazy"))){
      
      return mocker._mintLazyMock(marketIndex,amount,syntheticTokenType);
    }
  
                        _depositFunds(marketIndex, amount);

        batchedLazyDeposit[marketIndex][syntheticTokenType]
            .mintAmount += amount;
        userLazyActions[marketIndex][msg.sender].nextActionValues[
            uint8(syntheticTokenType)
        ]
            .mintAmount += amount;
        userLazyActions[marketIndex][msg.sender].usersCurrentUpdateIndex =
            latestUpdateIndex[marketIndex] +
            1;
    }

    function mintLongLazy(uint32 marketIndex, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintLongLazy"))){
      
      return mocker.mintLongLazyMock(marketIndex,amount);
    }
  
        _mintLazy(marketIndex, amount, MarketSide.Long);
        
        emit LazyLongMinted(
            marketIndex,
            amount,
            msg.sender,
            batchedLazyDeposit[marketIndex][MarketSide.Long].mintAmount,
            latestUpdateIndex[marketIndex] + 1
        );
    }

    function mintShortLazy(uint32 marketIndex, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintShortLazy"))){
      
      return mocker.mintShortLazyMock(marketIndex,amount);
    }
  
        _mintLazy(marketIndex, amount, MarketSide.Short);
            }

    function mintAndStakeLazy(
        uint32 marketIndex,
        uint256 amount,
        MarketSide syntheticTokenType
    ) internal executeOutstandingLazySettlements(msg.sender, marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintAndStakeLazy"))){
      
      return mocker.mintAndStakeLazyMock(marketIndex,amount,syntheticTokenType);
    }
  
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);

        batchedLazyDeposit[marketIndex][syntheticTokenType]
            .mintAndStakeAmount += amount;
        userLazyActions[marketIndex][msg.sender].nextActionValues[
            uint8(MarketSide.Short)
        ]
            .mintAndStakeAmount += amount;

        userLazyActions[marketIndex][msg.sender].usersCurrentUpdateIndex =
            latestUpdateIndex[marketIndex] +
            1;
            }

    function mintLongAndStakeLazy(uint32 marketIndex, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintLongAndStakeLazy"))){
      
      return mocker.mintLongAndStakeLazyMock(marketIndex,amount);
    }
  
        mintAndStakeLazy(marketIndex, amount, MarketSide.Long);
    }

    function mintShortAndStakeLazy(uint32 marketIndex, uint256 amount)
        external
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintShortAndStakeLazy"))){
      
      return mocker.mintShortAndStakeLazyMock(marketIndex,amount);
    }
  
        mintAndStakeLazy(marketIndex, amount, MarketSide.Short);
    }

    struct UserLazyRedeem {
        mapping(MarketSide => uint256) redemptions;
        uint256 usersCurrentUpdateIndex;
    }

    struct BatchedLazyRedeem {
        uint256 redemptions;
        uint256 totalWithdrawn;
    }

    mapping(uint32 => mapping(address => UserLazyRedeem))
        public userLazyRedeems;
    mapping(uint32 => mapping(uint256 => mapping(MarketSide => BatchedLazyRedeem)))
        public batchedLazyRedeems;

    function _executeOutstandingLazyRedeems(address user, uint32 marketIndex)
        internal
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_executeOutstandingLazyRedeems"))){
      
      return mocker._executeOutstandingLazyRedeemsMock(user,marketIndex);
    }
  
        UserLazyRedeem storage currentUserRedeems =
            userLazyRedeems[marketIndex][msg.sender];

        if (
            currentUserRedeems.usersCurrentUpdateIndex != 0 &&
            currentUserRedeems.usersCurrentUpdateIndex <=
            latestUpdateIndex[marketIndex]
        ) {
            BatchedLazyRedeem storage batchLong =
                batchedLazyRedeems[marketIndex][
                    currentUserRedeems.usersCurrentUpdateIndex
                ][MarketSide.Long];
            BatchedLazyRedeem storage batchShort =
                batchedLazyRedeems[marketIndex][
                    currentUserRedeems.usersCurrentUpdateIndex
                ][MarketSide.Short];
            if (currentUserRedeems.redemptions[MarketSide.Long] > 0) {
                fundTokens[marketIndex].transfer(
                    user,
                    (batchLong.totalWithdrawn *
                        currentUserRedeems.redemptions[MarketSide.Long]) /
                        batchLong.redemptions
                );
                currentUserRedeems.redemptions[MarketSide.Long] = 0;
            }
            if (currentUserRedeems.redemptions[MarketSide.Short] > 0) {
                fundTokens[marketIndex].transfer(
                    user,
                    (batchShort.totalWithdrawn *
                        currentUserRedeems.redemptions[MarketSide.Short]) /
                        batchShort.redemptions
                );
                currentUserRedeems.redemptions[MarketSide.Short] = 0;
            }
            currentUserRedeems.usersCurrentUpdateIndex = 0;
        }
    }

    modifier executeOutstandingLazyRedeems(address user, uint32 marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("executeOutstandingLazyRedeems"))){
      mocker.executeOutstandingLazyRedeemsMock(user,marketIndex);
      _;
    } else {
      
        _executeOutstandingLazyRedeems(user, marketIndex);
        _;
    
    }
  }

    function redeemLongLazy(uint32 marketIndex, uint256 tokensToRedeem)
        external
        executeOutstandingLazyRedeems(msg.sender, marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemLongLazy"))){
      
      return mocker.redeemLongLazyMock(marketIndex,tokensToRedeem);
    }
  
        syntheticTokens[MarketSide.Long][marketIndex].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );
        uint256 nextUpdateIndex = latestUpdateIndex[marketIndex] + 1;

        userLazyRedeems[marketIndex][msg.sender].redemptions[
            MarketSide.Long
        ] += tokensToRedeem;
        userLazyRedeems[marketIndex][msg.sender]
            .usersCurrentUpdateIndex = nextUpdateIndex;

        batchedLazyRedeems[marketIndex][nextUpdateIndex][MarketSide.Long]
            .redemptions += tokensToRedeem;
    }

    function redeemShortLazy(uint32 marketIndex, uint256 tokensToRedeem)
        external
        executeOutstandingLazyRedeems(msg.sender, marketIndex)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("redeemShortLazy"))){
      
      return mocker.redeemShortLazyMock(marketIndex,tokensToRedeem);
    }
  
        syntheticTokens[MarketSide.Short][marketIndex].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );
        uint256 nextUpdateIndex = latestUpdateIndex[marketIndex] + 1;

        userLazyRedeems[marketIndex][msg.sender].redemptions[
            MarketSide.Short
        ] += tokensToRedeem;
        userLazyRedeems[marketIndex][msg.sender]
            .usersCurrentUpdateIndex = nextUpdateIndex;

        batchedLazyRedeems[marketIndex][nextUpdateIndex][MarketSide.Short]
            .redemptions += tokensToRedeem;
    }

    function handleBatchedLazyRedeems(uint32 marketIndex) public {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("handleBatchedLazyRedeems"))){
      
      return mocker.handleBatchedLazyRedeemsMock(marketIndex);
    }
  
        BatchedLazyRedeem storage batchLong =
            batchedLazyRedeems[marketIndex][latestUpdateIndex[marketIndex]][
                MarketSide.Long
            ];
        BatchedLazyRedeem storage batchShort =
            batchedLazyRedeems[marketIndex][latestUpdateIndex[marketIndex]][
                MarketSide.Short
            ];

        if (batchLong.redemptions > 0) {
            syntheticTokens[MarketSide.Long][marketIndex].synthRedeemBurn(
                address(this),
                batchLong.redemptions
            );
        }

        if (batchShort.redemptions > 0) {
            syntheticTokens[MarketSide.Short][marketIndex].synthRedeemBurn(
                address(this),
                batchShort.redemptions
            );
        }
        uint256 longAmountToRedeem =
            (batchLong.redemptions *
                syntheticTokenPrice[MarketSide.Long][marketIndex]) /
                TEN_TO_THE_18;

        uint256 shortAmountToRedeem =
            (batchShort.redemptions *
                syntheticTokenPrice[MarketSide.Short][marketIndex]) /
                TEN_TO_THE_18;

        uint256 totalFeesLong = 0;

        uint256 totalFeesShort = 0;

                                if (longAmountToRedeem > shortAmountToRedeem) {
            uint256 delta = longAmountToRedeem - shortAmountToRedeem;
            totalFeesLong = _getFeesGeneral(
                marketIndex,
                delta,
                MarketSide.Long,
                MarketSide.Short,
                0,
                badLiquidityExitFee[marketIndex]
            );
        } else {
            uint256 delta = shortAmountToRedeem - longAmountToRedeem;
            totalFeesShort = _getFeesGeneral(
                marketIndex,
                delta,
                MarketSide.Short,
                MarketSide.Long,
                0,
                badLiquidityExitFee[marketIndex]
            );
        }

        batchLong.totalWithdrawn = longAmountToRedeem - totalFeesLong;
        batchShort.totalWithdrawn = shortAmountToRedeem - totalFeesShort;

        _feesMechanism(marketIndex, totalFeesLong + totalFeesShort);

        syntheticTokenBackedValue[MarketSide.Long][
            marketIndex
        ] -= longAmountToRedeem;
        syntheticTokenBackedValue[MarketSide.Short][
            marketIndex
        ] -= shortAmountToRedeem;

        _withdrawFunds(
            marketIndex,
            batchLong.totalWithdrawn + batchShort.totalWithdrawn,
            address(this)
        );

        _refreshTokensPrice(marketIndex);
    }
}
