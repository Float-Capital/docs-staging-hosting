// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";

import "../../interfaces/IFloatToken.sol";
import "../../interfaces/ILongShort.sol";
import "../../interfaces/IStaker.sol";


import "./StakerForInternalMocking.sol";
contract StakerMockable is IStaker, Initializable {
  StakerForInternalMocking mocker;
  bool shouldUseMock;
  string functionToNotMock;

  function setMocker(StakerForInternalMocking _mocker) external {
    mocker = _mocker;
    shouldUseMock = true;
  }

  function setFunctionToNotMock(string calldata _functionToNotMock) external {
    functionToNotMock = _functionToNotMock;
  }


    


        uint256 public constant FLOAT_ISSUANCE_FIXED_DECIMAL = 1e42;
    uint256 public constant TEN_TO_THE_18 = 1e18;

        address public admin;
    address public floatCapital;
    uint256 public floatPercentage;

    ILongShort public longShortCoreContract;
    IFloatToken public floatToken;

        mapping(uint32 => uint256) public marketLaunchIncentivePeriod;     mapping(uint32 => uint256) public marketLaunchIncentiveMultipliers;     mapping(uint32 => uint256) public marketUnstakeFeeBasisPoints;

    mapping(uint32 => mapping(bool => ISyntheticToken)) public syntheticTokens;

    mapping(ISyntheticToken => uint32) public marketIndexOfToken;

        mapping(uint32 => uint256) public latestRewardIndex;
    mapping(uint32 => mapping(uint256 => RewardState))
        public syntheticRewardParams;
    struct RewardState {
        uint256 timestamp;
        uint256 accumulativeFloatPerLongToken;
        uint256 accumulativeFloatPerShortToken;
    }

        mapping(uint32 => mapping(address => uint256))
        public userIndexOfLastClaimedReward;
    mapping(ISyntheticToken => mapping(address => uint256))
        public userAmountStaked;

    


    event StakerV1(address floatToken, uint256 floatPercentage);

    event MarketAddedToStaker(uint32 marketIndex, uint256 exitFeeBasisPoints);

    event StateAdded(
        uint32 marketIndex,
        uint256 stateIndex,
        uint256 accumulativeLong,
        uint256 accumulativeShort
    );

    event StakeAdded(
        address user,
        address token,
        uint256 amount,
        uint256 lastMintIndex
    );

    event StakeWithdrawn(address user, address token, uint256 amount);

    event FloatMinted(
        address user,
        uint32 marketIndex,
        uint256 amountLong,
        uint256 amountShort,
        uint256 lastMintIndex
    );

    event MarketLaunchIncentiveParametersChanges(
        uint32 marketIndex,
        uint256 period,
        uint256 multiplier
    );

    event StakeWithdrawalFeeUpdated(
        uint32 marketIndex,
        uint256 stakeWithdralFee
    );

    event FloatPercentageUpdated(uint256 floatPercentage);

    


    modifier onlyAdmin() {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("onlyAdmin"))){
        
      mocker.onlyAdminMock();
      _;
    } else {
      
        require(msg.sender == admin, "not admin");
        _;
    
    }
  }

    modifier onlyValidSynthetic(ISyntheticToken _synth) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("onlyValidSynthetic"))){
        
      mocker.onlyValidSyntheticMock(_synth);
      _;
    } else {
      
        require(marketIndexOfToken[_synth] != 0, "not valid synth");
        _;
    
    }
  }

    modifier onlyValidMarket(uint32 marketIndex) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("onlyValidMarket"))){
        
      mocker.onlyValidMarketMock(marketIndex);
      _;
    } else {
      
        require(
            address(syntheticTokens[marketIndex][true]) != address(0),
            "not valid market"
        );
                _;
    
    }
  }

    modifier onlyFloat() {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("onlyFloat"))){
        
      mocker.onlyFloatMock();
      _;
    } else {
      
        require(msg.sender == address(longShortCoreContract));
        _;
    
    }
  }

    


    function initialize(
        address _admin,
        address _longShortCoreContract,
        address _floatToken,
        address _floatCapital,
        uint256 _floatPercentage
    ) public initializer {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("initialize"))){
      
      return mocker.initializeMock(_admin,_longShortCoreContract,_floatToken,_floatCapital,_floatPercentage);
    }
  
        require(
            _admin != address(0) &&
                _floatCapital != address(0) &&
                _longShortCoreContract != address(0) &&
                _floatToken != address(0)
        );
        admin = _admin;
        floatCapital = _floatCapital;
        longShortCoreContract = ILongShort(_longShortCoreContract);
        floatToken = IFloatToken(_floatToken);

        _changeFloatPercentage(_floatPercentage);

        emit StakerV1(_floatToken, floatPercentage);
    }

    


    function changeAdmin(address _admin) external onlyAdmin {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("changeAdmin"))){
      
      return mocker.changeAdminMock(_admin);
    }
  
        admin = _admin;
    }

    function _changeFloatPercentage(uint256 newFloatPercentage) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_changeFloatPercentage"))){
      
      return mocker._changeFloatPercentageMock(newFloatPercentage);
    }
  
        require(newFloatPercentage <= TEN_TO_THE_18 && newFloatPercentage > 0);         floatPercentage = newFloatPercentage;
    }

    function changeFloatPercentage(uint256 newFloatPercentage)
        external
        onlyAdmin
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("changeFloatPercentage"))){
      
      return mocker.changeFloatPercentageMock(newFloatPercentage);
    }
  
        _changeFloatPercentage(newFloatPercentage);
        emit FloatPercentageUpdated(newFloatPercentage);
    }

    function _changeUnstakeFee(
        uint32 marketIndex,
        uint256 newMarketUnstakeFeeBasisPoints
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_changeUnstakeFee"))){
      
      return mocker._changeUnstakeFeeMock(marketIndex,newMarketUnstakeFeeBasisPoints);
    }
  
        require(newMarketUnstakeFeeBasisPoints <= 5e16);         marketUnstakeFeeBasisPoints[
            marketIndex
        ] = newMarketUnstakeFeeBasisPoints;
    }

    function changeUnstakeFee(
        uint32 marketIndex,
        uint256 newMarketUnstakeFeeBasisPoints
    ) external onlyAdmin {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("changeUnstakeFee"))){
      
      return mocker.changeUnstakeFeeMock(marketIndex,newMarketUnstakeFeeBasisPoints);
    }
  
        _changeUnstakeFee(marketIndex, newMarketUnstakeFeeBasisPoints);
        emit StakeWithdrawalFeeUpdated(
            marketIndex,
            newMarketUnstakeFeeBasisPoints
        );
    }

    function changeMarketLaunchIncentiveParameters(
        uint32 marketIndex,
        uint256 period,
        uint256 initialMultiplier
    ) external onlyAdmin {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("changeMarketLaunchIncentiveParameters"))){
      
      return mocker.changeMarketLaunchIncentiveParametersMock(marketIndex,period,initialMultiplier);
    }
  
        _changeMarketLaunchIncentiveParameters(
            marketIndex,
            period,
            initialMultiplier
        );
    }

    function _changeMarketLaunchIncentiveParameters(
        uint32 marketIndex,
        uint256 period,
        uint256 initialMultiplier
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_changeMarketLaunchIncentiveParameters"))){
      
      return mocker._changeMarketLaunchIncentiveParametersMock(marketIndex,period,initialMultiplier);
    }
  
        require(
            initialMultiplier >= TEN_TO_THE_18,
            "marketLaunchIncentiveMultiplier must be >= 1e18"
        );

        marketLaunchIncentivePeriod[marketIndex] = period;
        marketLaunchIncentiveMultipliers[marketIndex] = initialMultiplier;

        emit MarketLaunchIncentiveParametersChanges(
            marketIndex,
            period,
            initialMultiplier
        );
    }

    


    function addNewStakingFund(
        uint32 marketIndex,
        ISyntheticToken longToken,
        ISyntheticToken shortToken,
        uint256 kInitialMultiplier,
        uint256 kPeriod,
        uint256 unstakeFeeBasisPoints
    ) external override onlyFloat {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("addNewStakingFund"))){
      
      return mocker.addNewStakingFundMock(marketIndex,longToken,shortToken,kInitialMultiplier,kPeriod,unstakeFeeBasisPoints);
    }
  
        marketIndexOfToken[longToken] = marketIndex;
        marketIndexOfToken[shortToken] = marketIndex;

        syntheticRewardParams[marketIndex][0].timestamp = block.timestamp;
        syntheticRewardParams[marketIndex][0].accumulativeFloatPerLongToken = 0;
        syntheticRewardParams[marketIndex][0]
        .accumulativeFloatPerShortToken = 0;

        syntheticTokens[marketIndex][true] = longToken;
        syntheticTokens[marketIndex][false] = shortToken;

        _changeMarketLaunchIncentiveParameters(
            marketIndex,
            kPeriod,
            kInitialMultiplier
        );

        _changeUnstakeFee(marketIndex, unstakeFeeBasisPoints);
        emit MarketAddedToStaker(
            marketIndex,
            marketUnstakeFeeBasisPoints[marketIndex]
        );

        emit StateAdded(marketIndex, 0, 0, 0);
    }

            
    

    function getMarketLaunchIncentiveParameters(uint32 marketIndex)
        internal
        view
        returns (uint256, uint256)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getMarketLaunchIncentiveParameters"))){
      
      return mocker.getMarketLaunchIncentiveParametersMock(marketIndex);
    }
  
        uint256 period = marketLaunchIncentivePeriod[marketIndex];
        uint256 multiplier = marketLaunchIncentiveMultipliers[marketIndex];
        if (multiplier == 0) {
            multiplier = TEN_TO_THE_18;         }

        return (period, multiplier);
    }

    function getKValue(uint32 marketIndex) internal view returns (uint256) {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("getKValue"))){
      
      return mocker.getKValueMock(marketIndex);
    }
  
                (
            uint256 kPeriod,
            uint256 kInitialMultiplier
        ) = getMarketLaunchIncentiveParameters(marketIndex);

                        assert(kInitialMultiplier >= TEN_TO_THE_18);

        uint256 initialTimestamp = syntheticRewardParams[marketIndex][0]
        .timestamp;

        if (block.timestamp - initialTimestamp <= kPeriod) {
            return
                kInitialMultiplier -
                (((kInitialMultiplier - TEN_TO_THE_18) *
                    (block.timestamp - initialTimestamp)) / kPeriod);
        } else {
            return TEN_TO_THE_18;
        }
    }

    

    function calculateFloatPerSecond(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    )
        internal
        view
        returns (uint256 longFloatPerSecond, uint256 shortFloatPerSecond)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("calculateFloatPerSecond"))){
      
      return mocker.calculateFloatPerSecondMock(marketIndex,longPrice,shortPrice,longValue,shortValue);
    }
  
                if (longValue == 0 && shortValue == 0) {
            return (0, 0);
        }

                        uint256 k = getKValue(marketIndex);

        uint256 totalLocked = (longValue + shortValue);

                                return (
            ((k * shortValue) * longPrice) / totalLocked,
            ((k * longValue) * shortPrice) / totalLocked
        );
    }

    

    function calculateTimeDelta(uint32 marketIndex)
        internal
        view
        returns (uint256)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("calculateTimeDelta"))){
      
      return mocker.calculateTimeDeltaMock(marketIndex);
    }
  
        return
            block.timestamp -
            syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
            .timestamp;
    }

    

    function calculateNewCumulativeRate(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    )
        internal
        view
        returns (uint256 longCumulativeRates, uint256 shortCumulativeRates)
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("calculateNewCumulativeRate"))){
      
      return mocker.calculateNewCumulativeRateMock(marketIndex,longPrice,shortPrice,longValue,shortValue);
    }
  
                (
            uint256 longFloatPerSecond,
            uint256 shortFloatPerSecond
        ) = calculateFloatPerSecond(
            marketIndex,
            longPrice,
            shortPrice,
            longValue,
            shortValue
        );

                uint256 timeDelta = calculateTimeDelta(marketIndex);

                return (
            syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
            .accumulativeFloatPerLongToken + (timeDelta * longFloatPerSecond),
            syntheticRewardParams[marketIndex][latestRewardIndex[marketIndex]]
            .accumulativeFloatPerShortToken + (timeDelta * shortFloatPerSecond)
        );
    }

    

    function setRewardObjects(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("setRewardObjects"))){
      
      return mocker.setRewardObjectsMock(marketIndex,longPrice,shortPrice,longValue,shortValue);
    }
  
        (
            uint256 longAccumulativeRates,
            uint256 shortAccumulativeRates
        ) = calculateNewCumulativeRate(
            marketIndex,
            longPrice,
            shortPrice,
            longValue,
            shortValue
        );

        uint256 newIndex = latestRewardIndex[marketIndex] + 1;

                syntheticRewardParams[marketIndex][newIndex]
        .accumulativeFloatPerLongToken = longAccumulativeRates;
        syntheticRewardParams[marketIndex][newIndex]
        .accumulativeFloatPerShortToken = shortAccumulativeRates;

                syntheticRewardParams[marketIndex][newIndex].timestamp = block
        .timestamp;

                latestRewardIndex[marketIndex] = newIndex;

        emit StateAdded(
            marketIndex,
            newIndex,
            longAccumulativeRates,
            shortAccumulativeRates
        );
    }

    

    function addNewStateForFloatRewards(
        uint32 marketIndex,
        uint256 longPrice,
        uint256 shortPrice,
        uint256 longValue,
        uint256 shortValue
    ) external override onlyFloat {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("addNewStateForFloatRewards"))){
      
      return mocker.addNewStateForFloatRewardsMock(marketIndex,longPrice,shortPrice,longValue,shortValue);
    }
  
        
                if (calculateTimeDelta(marketIndex) > 0) {
            setRewardObjects(
                marketIndex,
                longPrice,
                shortPrice,
                longValue,
                shortValue
            );
        }
    }

            
    function calculateAccumulatedFloatHelper(
        uint32 marketIndex,
        address user,
        uint256 amountStakedLong,
        uint256 amountStakedShort,
        uint256 usersLastRewardIndex
    )
        internal
        view
        returns (
                        uint256 longFloatReward,
            uint256 shortFloatReward
        )
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("calculateAccumulatedFloatHelper"))){
      
      return mocker.calculateAccumulatedFloatHelperMock(marketIndex,user,amountStakedLong,amountStakedShort,usersLastRewardIndex);
    }
  
                if (usersLastRewardIndex == latestRewardIndex[marketIndex]) {
            return (0, 0);
        }

                assert(
            userIndexOfLastClaimedReward[marketIndex][user] <
                latestRewardIndex[marketIndex]
        );

        ISyntheticToken longToken = syntheticTokens[marketIndex][true];
        ISyntheticToken shortToken = syntheticTokens[marketIndex][false];

        if (amountStakedLong > 0) {
            uint256 accumDeltaLong = syntheticRewardParams[marketIndex][
                latestRewardIndex[marketIndex]
            ]
            .accumulativeFloatPerLongToken -
                syntheticRewardParams[marketIndex][
                    userIndexOfLastClaimedReward[marketIndex][user]
                ]
                .accumulativeFloatPerLongToken;
            longFloatReward =
                (accumDeltaLong * amountStakedLong) /
                FLOAT_ISSUANCE_FIXED_DECIMAL;
        }

        if (amountStakedShort > 0) {
            uint256 accumDeltaShort = syntheticRewardParams[marketIndex][
                latestRewardIndex[marketIndex]
            ]
            .accumulativeFloatPerShortToken -
                syntheticRewardParams[marketIndex][
                    userIndexOfLastClaimedReward[marketIndex][user]
                ]
                .accumulativeFloatPerShortToken;
            shortFloatReward =
                (accumDeltaShort * amountStakedShort) /
                FLOAT_ISSUANCE_FIXED_DECIMAL;
        }

                return (longFloatReward, shortFloatReward);
    }

    function calculateAccumulatedFloat(uint32 marketIndex, address user)
        internal
        view
        returns (
                        uint256 longFloatReward,
            uint256 shortFloatReward
        )
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("calculateAccumulatedFloat"))){
      
      return mocker.calculateAccumulatedFloatMock(marketIndex,user);
    }
  
        ISyntheticToken longToken = syntheticTokens[marketIndex][true];
        ISyntheticToken shortToken = syntheticTokens[marketIndex][false];

        uint256 amountStakedLong = userAmountStaked[longToken][user];
        uint256 amountStakedShort = userAmountStaked[shortToken][user];

                return
            calculateAccumulatedFloatHelper(
                marketIndex,
                user,
                amountStakedLong,
                amountStakedShort,
                userIndexOfLastClaimedReward[marketIndex][user]
            );
    }

    function _mintFloat(address user, uint256 floatToMint) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_mintFloat"))){
      
      return mocker._mintFloatMock(user,floatToMint);
    }
  
        floatToken.mint(user, floatToMint);
        floatToken.mint(
            floatCapital,
            (floatToMint * floatPercentage) / TEN_TO_THE_18
        );
    }

    function mintAccumulatedFloat(uint32 marketIndex, address user) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("mintAccumulatedFloat"))){
      
      return mocker.mintAccumulatedFloatMock(marketIndex,user);
    }
  
                (
            uint256 floatToMintLong,
            uint256 floatToMintShort
        ) = calculateAccumulatedFloat(marketIndex, user);

        uint256 floatToMint = floatToMintLong + floatToMintShort;
        if (floatToMint > 0) {
                        userIndexOfLastClaimedReward[marketIndex][user] = latestRewardIndex[
                marketIndex
            ];

            _mintFloat(user, floatToMint);

            emit FloatMinted(
                user,
                marketIndex,
                floatToMintLong,
                floatToMintShort,
                latestRewardIndex[marketIndex]
            );
        }
    }

    function _claimFloat(uint32[] calldata marketIndexes) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_claimFloat"))){
      
      return mocker._claimFloatMock(marketIndexes);
    }
  
        uint256 floatTotal = 0;
        for (uint256 i = 0; i < marketIndexes.length; i++) {
                        (
                uint256 floatToMintLong,
                uint256 floatToMintShort
            ) = calculateAccumulatedFloat(marketIndexes[i], msg.sender);

            uint256 floatToMint = floatToMintLong + floatToMintShort;

            if (floatToMint > 0) {
                                userIndexOfLastClaimedReward[marketIndexes[i]][
                    msg.sender
                ] = latestRewardIndex[marketIndexes[i]];
                floatTotal += floatToMint;

                emit FloatMinted(
                    msg.sender,
                    marketIndexes[i],
                    floatToMintLong,
                    floatToMintShort,
                    latestRewardIndex[marketIndexes[i]]
                );
            }
        }
        if (floatTotal > 0) {
            _mintFloat(msg.sender, floatTotal);
        }
    }

    function claimFloatCustom(uint32[] calldata marketIndexes) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("claimFloatCustom"))){
      
      return mocker.claimFloatCustomMock(marketIndexes);
    }
  
        require(marketIndexes.length <= 50);         longShortCoreContract.updateSystemStateMulti(marketIndexes);
        _claimFloat(marketIndexes);
    }

            
    

    function stakeFromUser(address from, uint256 amount)
        public
        override
        onlyValidSynthetic(ISyntheticToken(msg.sender))
    {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("stakeFromUser"))){
      
      return mocker.stakeFromUserMock(from,amount);
    }
  
        longShortCoreContract.updateSystemState(
            marketIndexOfToken[ISyntheticToken(msg.sender)]
        );
        _stake(ISyntheticToken(msg.sender), amount, from);
    }

    function _stake(
        ISyntheticToken token,
        uint256 amount,
        address user
    ) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_stake"))){
      
      return mocker._stakeMock(token,amount,user);
    }
  
        uint32 marketIndex = marketIndexOfToken[token];

                if (
            userIndexOfLastClaimedReward[marketIndex][user] != 0 &&
            userIndexOfLastClaimedReward[marketIndex][user] <
            latestRewardIndex[marketIndex]
        ) {
            mintAccumulatedFloat(marketIndex, user);
        }

        userAmountStaked[token][user] = userAmountStaked[token][user] + amount;

        userIndexOfLastClaimedReward[marketIndex][user] = latestRewardIndex[
            marketIndex
        ];

        emit StakeAdded(
            user,
            address(token),
            amount,
            userIndexOfLastClaimedReward[marketIndex][user]
        );
    }

            
    

    function _withdraw(ISyntheticToken token, uint256 amount) internal {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("_withdraw"))){
      
      return mocker._withdrawMock(token,amount);
    }
  
        uint32 marketIndex = marketIndexOfToken[token];
        require(userAmountStaked[token][msg.sender] > 0, "nothing to withdraw");
        mintAccumulatedFloat(marketIndex, msg.sender);

        userAmountStaked[token][msg.sender] =
            userAmountStaked[token][msg.sender] -
            amount;

        uint256 amountFees = (amount *
            marketUnstakeFeeBasisPoints[marketIndex]) / TEN_TO_THE_18;

        token.transfer(msg.sender, amount - amountFees);

        emit StakeWithdrawn(msg.sender, address(token), amount);
    }

    function withdraw(ISyntheticToken token, uint256 amount) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("withdraw"))){
      
      return mocker.withdrawMock(token,amount);
    }
  
        longShortCoreContract.updateSystemState(marketIndexOfToken[token]);

        _withdraw(token, amount);
    }

    function withdrawAll(ISyntheticToken token) external {
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("withdrawAll"))){
      
      return mocker.withdrawAllMock(token);
    }
  
        longShortCoreContract.updateSystemState(marketIndexOfToken[token]);

        _withdraw(token, userAmountStaked[token][msg.sender]);
    }
}
