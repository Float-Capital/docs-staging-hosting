// SPDX-License-Identifier: BUSL-1.1 
 pragma solidity 0.8.3;
import "./LongShortMockable.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../interfaces/ITokenFactory.sol";
import "../../interfaces/ISyntheticToken.sol";
import "../../interfaces/IStaker.sol";
import "../../interfaces/ILongShort.sol";
import "../../interfaces/IYieldManager.sol";
import "../../interfaces/IOracleManager.sol";
contract LongShortForInternalMocking { 
    function initializeMock(address,address,ITokenFactory,IStaker) public pure {
      return ();
    }
     
    function changeAdminMock(address) public pure {
      return ();
    }
     
    function changeTreasuryMock(address) public pure {
      return ();
    }
     
    function changeFeesMock(uint32,uint256,uint256,uint256,uint256) public pure {
      return ();
    }
     
    function _changeFeesMock(uint32,uint256,uint256,uint256,uint256) public pure {
      return ();
    }
     
    function updateMarketOracleMock(uint32,address) public pure {
      return ();
    }
     
    function newSyntheticMarketMock(string calldata ,string calldata ,address,address,address) public pure {
      return ();
    }
     
    function seedMarketInitiallyMock(uint256,uint32) public pure {
      return ();
    }
     
    function initializeMarketMock(uint32,uint256,uint256,uint256,uint256,uint256,uint256,uint256) public pure {
      return ();
    }
     
    function getOtherSynthTypeMock(ILongShort.MarketSide) public pure returns (ILongShort.MarketSide ){
      return (abi.decode("",(ILongShort.MarketSide)));
    }
     
    function getTreasurySplitMock(uint32,uint256) public pure returns (uint256 marketAmount,uint256 treasuryAmount){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function getMarketSplitMock(uint32,uint256) public pure returns (uint256 longAmount,uint256 shortAmount){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function _refreshTokensPriceMock(uint32) public pure {
      return ();
    }
     
    function _distributeMarketAmountMock(uint32,uint256) public pure {
      return ();
    }
     
    function _feesMechanismMock(uint32,uint256) public pure {
      return ();
    }
     
    function _yieldMechanismMock(uint32) public pure {
      return ();
    }
     
    function _minimumMock(uint256,uint256) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _calculateValueChangeForPriceMechanismMock(uint32,uint256,uint256,uint256,ILongShort.MarketSide,ILongShort.MarketSide) public pure {
      return ();
    }
     
    function _priceChangeMechanismMock(uint32,uint256) public pure returns (bool didUpdate){
      return (abi.decode("",(bool)));
    }
     
    function handleBatchedDepositSettlementMock(uint32,ILongShort.MarketSide) public pure {
      return ();
    }
     
    function snapshotPriceChangeForNextPriceExecutionMock(uint32) public pure {
      return ();
    }
     
    function _updateSystemStateInternalMock(uint32) public pure {
      return ();
    }
     
    function _updateSystemStateMock(uint32) public pure {
      return ();
    }
     
    function _updateSystemStateMultiMock(uint32[] memory) public pure {
      return ();
    }
     
    function _transferFundsToYieldManagerMock(uint32,uint256) public pure {
      return ();
    }
     
    function _depositFundsMock(uint32,uint256) public pure {
      return ();
    }
     
    function _lockFundsInMarketMock(uint32,uint256) public pure {
      return ();
    }
     
    function _withdrawFundsMock(uint32,uint256,address) public pure {
      return ();
    }
     
    function _transferToYieldManagerMock(uint32,uint256) public pure {
      return ();
    }
     
    function _transferFromYieldManagerMock(uint32,uint256) public pure {
      return ();
    }
     
    function _getFeesGeneralMock(uint32,uint256,ILongShort.MarketSide,ILongShort.MarketSide,uint256,uint256) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _getFeesForMintMock(uint32,uint256,ILongShort.MarketSide) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _getFeesForRedeemMock(uint32,uint256,ILongShort.MarketSide) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function mintLongMock(uint32,uint256) public pure {
      return ();
    }
     
    function mintShortMock(uint32,uint256) public pure {
      return ();
    }
     
    function mintLongAndStakeMock(uint32,uint256) public pure {
      return ();
    }
     
    function mintShortAndStakeMock(uint32,uint256) public pure {
      return ();
    }
     
    function _mintMock(uint32,uint256,address,address,ILongShort.MarketSide) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _redeemMock(uint32,uint256,ILongShort.MarketSide) public pure {
      return ();
    }
     
    function redeemLongMock(uint32,uint256) public pure {
      return ();
    }
     
    function redeemLongAllMock(uint32) public pure {
      return ();
    }
     
    function redeemShortMock(uint32,uint256) public pure {
      return ();
    }
     
    function redeemShortAllMock(uint32) public pure {
      return ();
    }
     
    function transferTreasuryFundsMock(uint32) public pure {
      return ();
    }
     
    function getUsersPendingBalanceMock(address,uint32,ILongShort.MarketSide) public pure returns (uint256 pendingBalance){
      return (abi.decode("",(uint256)));
    }
     
    function _executeLazyMintsIfTheyExistMock(uint32,address,ILongShort.MarketSide,LongShortMockable.UserLazyDeposit memory ) public pure {
      return ();
    }
     
    function _executeOutstandingLazySettlementsActionMock(address,uint32,LongShortMockable.UserLazyDeposit memory ) public pure {
      return ();
    }
     
    function _executeOutstandingLazySettlementsMock(address,uint32) public pure {
      return ();
    }
     
    function executeOutstandingLazySettlementsSynthMock(address,uint32,ILongShort.MarketSide) public pure {
      return ();
    }
     
    function _mintLazyMock(uint32,uint256,ILongShort.MarketSide) public pure {
      return ();
    }
     
    function mintLongLazyMock(uint32,uint256) public pure {
      return ();
    }
     
    function mintShortLazyMock(uint32,uint256) public pure {
      return ();
    }
     
    function mintAndStakeLazyMock(uint32,uint256,ILongShort.MarketSide) public pure {
      return ();
    }
     
    function mintLongAndStakeLazyMock(uint32,uint256) public pure {
      return ();
    }
     
    function mintShortAndStakeLazyMock(uint32,uint256) public pure {
      return ();
    }
     
    function _executeOutstandingLazyRedeemsMock(address,uint32) public pure {
      return ();
    }
     
    function redeemLongLazyMock(uint32,uint256) public pure {
      return ();
    }
     
    function redeemShortLazyMock(uint32,uint256) public pure {
      return ();
    }
     
    function handleBatchedLazyRedeemsMock(uint32) public pure {
      return ();
    }
     
    function adminOnlyMock() public pure {
      return; 
    }
     
    function treasuryOnlyMock() public pure {
      return; 
    }
     
    function doesMarketExistMock(uint32) public pure {
      return; 
    }
     
    function isCorrectSynthMock(uint32,ILongShort.MarketSide,ISyntheticToken) public pure {
      return; 
    }
     
    function refreshSystemStateMock(uint32) public pure {
      return; 
    }
     
    function executeOutstandingLazySettlementsMock(address,uint32) public pure {
      return; 
    }
     
    function executeOutstandingLazyRedeemsMock(address,uint32) public pure {
      return; 
    }
    }