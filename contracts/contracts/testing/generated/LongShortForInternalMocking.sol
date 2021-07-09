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
     
    function updateMarketOracleMock(uint32,address) public pure {
      return ();
    }
     
    function newSyntheticMarketMock(string calldata ,string calldata ,address,address,address) public pure {
      return ();
    }
     
    function _seedMarketInitiallyMock(uint256,uint32) public pure {
      return ();
    }
     
    function initializeMarketMock(uint32,uint256,uint256,uint256,uint256,uint256,int256) public pure {
      return ();
    }
     
    function _recalculateSyntheticTokenPriceMock(uint32,bool) public pure returns (uint256 syntheticTokenPrice){
      return (abi.decode("",(uint256)));
    }
     
    function _getAmountPaymentTokenMock(uint256,uint256) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _getAmountSynthTokenMock(uint256,uint256) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function getUsersConfirmedButNotSettledBalanceMock(address,uint32,bool) public pure returns (uint256 pendingBalance){
      return (abi.decode("",(uint256)));
    }
     
    function floorMock(uint256,uint256) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function _getYieldSplitMock(uint256,uint256,uint256) public pure returns (bool isLongSideUnderbalanced,uint256 treasuryPercentE18){
      return (abi.decode("",(bool)),abi.decode("",(uint256)));
    }
     
    function _claimAndDistributeYieldMock(uint32) public pure {
      return ();
    }
     
    function _adjustMarketBasedOnNewAssetPriceMock(uint32,int256) public pure {
      return ();
    }
     
    function _saveSyntheticTokenPriceSnapshotsMock(uint32,uint256,uint256,uint256) public pure {
      return ();
    }
     
    function _updateSystemStateInternalMock(uint32) public pure {
      return ();
    }
     
    function updateSystemStateMock(uint32) public pure {
      return ();
    }
     
    function updateSystemStateMultiMock(uint32[] memory) public pure {
      return ();
    }
     
    function _depositFundsMock(uint32,uint256) public pure {
      return ();
    }
     
    function _lockFundsInMarketMock(uint32,uint256) public pure {
      return ();
    }
     
    function _withdrawFundsMock(uint32,uint256,uint256,address) public pure {
      return ();
    }
     
    function _burnSynthTokensForRedemptionMock(uint32,uint256,uint256) public pure {
      return ();
    }
     
    function _transferFundsToYieldManagerMock(uint32,uint256) public pure {
      return ();
    }
     
    function _transferFromYieldManagerMock(uint32,uint256) public pure {
      return ();
    }
     
    function _mintNextPriceMock(uint32,uint256,bool) public pure {
      return ();
    }
     
    function mintLongNextPriceMock(uint32,uint256) public pure {
      return ();
    }
     
    function mintShortNextPriceMock(uint32,uint256) public pure {
      return ();
    }
     
    function _redeemNextPriceMock(uint32,uint256,bool) public pure {
      return ();
    }
     
    function redeemLongNextPriceMock(uint32,uint256) public pure {
      return ();
    }
     
    function redeemShortNextPriceMock(uint32,uint256) public pure {
      return ();
    }
     
    function _executeNextPriceMintsIfTheyExistMock(uint32,address,bool) public pure {
      return ();
    }
     
    function _executeOutstandingNextPriceRedeemsMock(uint32,address,bool) public pure {
      return ();
    }
     
    function _executeOutstandingNextPriceSettlementsMock(address,uint32) public pure {
      return ();
    }
     
    function executeOutstandingNextPriceSettlementsUserMock(address,uint32) public pure {
      return ();
    }
     
    function _performOustandingSettlementsMock(uint32,uint256,uint256,uint256) public pure {
      return ();
    }
     
    function _handleBatchedDepositSettlementMock(uint32,bool,uint256) public pure {
      return ();
    }
     
    function _handleBatchedRedeemSettlementMock(uint32,uint256,uint256) public pure {
      return ();
    }
     
    function adminOnlyMock() public pure {
      return; 
    }
     
    function assertMarketExistsMock(uint32) public pure {
      return; 
    }
     
    function executeOutstandingNextPriceSettlementsMock(address,uint32) public pure {
      return; 
    }
     
    function updateSystemStateMarketMock(uint32) public pure {
      return; 
    }
    }