// SPDX-License-Identifier: BUSL-1.1 
 pragma solidity 0.8.3;
import "../../LongShort.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/ITokenFactory.sol";
import "../../interfaces/ISyntheticToken.sol";
import "../../interfaces/IStaker.sol";
import "../../interfaces/ILongShort.sol";
import "../../interfaces/IYieldManager.sol";
import "../../interfaces/IOracleManager.sol";
contract LongShortForInternalMocking is LongShort { 
    function initializeMock(
        address _admin,
        address _treasury,
        ITokenFactory _tokenFactory,
        IStaker _staker
    ) public pure {
      return ();
    }
     
    function changeAdminMock(address _admin) public pure {
      return ();
    }
     
    function changeTreasuryMock(address _treasury) public pure {
      return ();
    }
     
    function changeFeesMock(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee
    ) public pure {
      return ();
    }
     
    function _changeFeesMock(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityEntryFee,
        uint256 _badLiquidityExitFee
    ) public pure {
      return ();
    }
     
    function updateMarketOracleMock(uint32 marketIndex, address _newOracleManager) public pure {
      return ();
    }
     
    function newSyntheticMarketMock(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address _fundToken,
        address _oracleManager,
        address _yieldManager
    ) public pure {
      return ();
    }
     
    function initializeMarketMock(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee,
        uint256 kInitialMultiplier,
        uint256 kPeriod
    ) public pure {
      return ();
    }
     
    function getLatestPriceMock(uint32 marketIndex) public pure returns (int256 ){
      return (abi.decode("",(int256)));
    }
     
    function getLongBetaMock(uint32 marketIndex) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function getShortBetaMock(uint32 marketIndex) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function getTreasurySplitMock(uint32 marketIndex, uint256 amount) public pure returns (uint256 marketAmount,uint256 treasuryAmount){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function getMarketSplitMock(uint32 marketIndex, uint256 amount) public pure returns (uint256 longAmount,uint256 shortAmount){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function _refreshTokensPriceMock(uint32 marketIndex) public pure {
      return ();
    }
     
    function _feesMechanismMock(uint32 marketIndex, uint256 totalFees) public pure {
      return ();
    }
     
    function _yieldMechanismMock(uint32 marketIndex) public pure {
      return ();
    }
     
    function _minimumMock(
        uint256 liquidityOfPositionA,
        uint256 liquidityOfPositionB
    ) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _calculateValueChangeForPriceMechanismMock(
        uint32 marketIndex,
        uint256 assetPriceGreater,
        uint256 assetPriceLess,
        uint256 baseValueExposure
    ) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _priceChangeMechanismMock(uint32 marketIndex, uint256 newPrice) public pure returns (bool didUpdate){
      return (abi.decode("",(bool)));
    }
     
    function handleBatchedDepositSettlementMock(
        uint32 marketIndex,
        MarketSide syntheticTokenType
    ) public pure {
      return ();
    }
     
    function _updateSystemStateInternalMock(uint32 marketIndex) public pure {
      return ();
    }
     
    function _updateSystemStateMock(uint32 marketIndex) public pure {
      return ();
    }
     
    function _updateSystemStateMultiMock(uint32[] calldata marketIndexes) public pure {
      return ();
    }
     
    function _transferFundsToYieldManagerMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function _depositFundsMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function _lockFundsInMarketMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function _withdrawFundsMock(
        uint32 marketIndex,
        uint256 amount,
        address user
    ) public pure {
      return ();
    }
     
    function _transferToYieldManagerMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function _transferFromYieldManagerMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function _getFeesForAmountsMock(
        uint32 marketIndex,
        uint256 baseAmount,         uint256 penaltyAmount,         bool isMint     ) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _getFeesForActionMock(
        uint32 marketIndex,
        uint256 amount,         bool isMint,         MarketSide syntheticTokenType     ) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function mintLongMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function mintShortMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function mintLongAndStakeMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function mintShortAndStakeMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function _mintMock(
        uint32 marketIndex,
        uint256 amount,
        address user,
        address transferTo,
        MarketSide syntheticTokenType
    ) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _redeemMock(
        uint32 marketIndex,
        uint256 tokensToRedeem,
        MarketSide syntheticTokenType
    ) public pure {
      return ();
    }
     
    function redeemLongMock(uint32 marketIndex, uint256 tokensToRedeem) public pure {
      return ();
    }
     
    function redeemLongAllMock(uint32 marketIndex) public pure {
      return ();
    }
     
    function redeemShortMock(uint32 marketIndex, uint256 tokensToRedeem) public pure {
      return ();
    }
     
    function redeemShortAllMock(uint32 marketIndex) public pure {
      return ();
    }
     
    function transferTreasuryFundsMock(uint32 marketIndex) public pure {
      return ();
    }
     
    function getUsersPendingBalanceMock(
        address user,
        uint32 marketIndex,
        MarketSide syntheticTokenType
    ) public pure returns (uint256 pendingBalance){
      return (abi.decode("",(uint256)));
    }
     
    function _executeOutstandingLazySettlementsActionMock(
        address user,
        uint32 marketIndex
    ) public pure {
      return ();
    }
     
    function _executeOutstandingLazySettlementsMock(
        address user,
        uint32 marketIndex     ) public pure {
      return ();
    }
     
    function _getMaxAvailableLazilyMock(
        address user,
        uint32 marketIndex,         MarketSide syntheticTokenType
    ) public pure returns (uint256 amountPaymentTokenLazyAvailableImmediately,uint256 amountSynthTokenLazyAvailableImmediately){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function _executeOutstandingLazySettlementsPartialOrCurrentIfNeededMock(
        address user,
        uint32 marketIndex,         MarketSide syntheticTokenType,
        uint256 minimumAmountRequired
    ) public pure {
      return ();
    }
     
    function executeOutstandingLazySettlementsSynthMock(
        address user,
        uint32 marketIndex,
        MarketSide syntheticTokenType
    ) public pure {
      return ();
    }
     
    function executeOutstandingLazySettlementsPartialOrCurrentIfNeededMock(
        address user,
        uint32 marketIndex,         MarketSide syntheticTokenType,
        uint256 minimumAmountRequired
    ) public pure {
      return ();
    }
     
    function _mintLazyMock(
        uint32 marketIndex,
        uint256 amount,
        MarketSide syntheticTokenType
    ) public pure {
      return ();
    }
     
    function mintLongLazyMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function mintShortLazyMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function mintAndStakeLazyMock(
        uint32 marketIndex,
        uint256 amount,
        MarketSide syntheticTokenType
    ) public pure {
      return ();
    }
     
    function mintLongAndStakeLazyMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function mintShortAndStakeLazyMock(uint32 marketIndex, uint256 amount) public pure {
      return ();
    }
     
    function _executeOutstandingLazyRedeemsMock(address user, uint32 marketIndex) public pure {
      return ();
    }
     
    function redeemLongLazyMock(uint32 marketIndex, uint256 tokensToRedeem) public pure {
      return ();
    }
     
    function redeemShortLazyMock(uint32 marketIndex, uint256 tokensToRedeem) public pure {
      return ();
    }
     
    function handleBatchedLazyRedeemsMock(uint32 marketIndex) public pure {
      return ();
    }
     
    function adminOnlyMock() public pure {
      return; 
    }
     
    function treasuryOnlyMock() public pure {
      return; 
    }
     
    function doesMarketExistMock(uint32 marketIndex) public pure {
      return; 
    }
     
    function isCorrectSynthMock(
        uint32 marketIndex,
        MarketSide syntheticTokenType,
        ISyntheticToken syntheticToken
    ) public pure {
      return; 
    }
     
    function refreshSystemStateMock(uint32 marketIndex) public pure {
      return; 
    }
     
    function executeOutstandingLazySettlementsMock(address user, uint32 marketIndex) public pure {
      return; 
    }
     
    function executeOutstandingLazyRedeemsMock(address user, uint32 marketIndex) public pure {
      return; 
    }
    }