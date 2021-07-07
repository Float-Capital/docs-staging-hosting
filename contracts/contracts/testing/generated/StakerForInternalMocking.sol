// SPDX-License-Identifier: BUSL-1.1 
 pragma solidity 0.8.3;
import "./StakerMockable.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";
import "../../interfaces/IFloatToken.sol";
import "../../interfaces/ILongShort.sol";
import "../../interfaces/IStaker.sol";
contract StakerForInternalMocking { 
    function initializeMock(address,address,address,address) public pure {
      return ();
    }
     
    function changeAdminMock(address) public pure {
      return ();
    }
     
    function changeFloatPercentageMock(uint16) public pure {
      return ();
    }
     
    function _changeUnstakeFeeMock(uint32,uint256) public pure {
      return ();
    }
     
    function changeUnstakeFeeMock(uint32,uint256) public pure {
      return ();
    }
     
    function changeMarketLaunchIncentiveParametersMock(uint32,uint256,uint256) public pure {
      return ();
    }
     
    function _changeMarketLaunchIncentiveParametersMock(uint32,uint256,uint256) public pure {
      return ();
    }
     
    function addNewStakingFundMock(uint32,ISyntheticToken,ISyntheticToken,uint256,uint256,uint256) public pure {
      return ();
    }
     
    function getMarketLaunchIncentiveParametersMock(uint32) public pure returns (uint256 ,uint256 ){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function getKValueMock(uint32) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function calculateFloatPerSecondMock(uint32,uint256,uint256,uint256,uint256) public pure returns (uint256 longFloatPerSecond,uint256 shortFloatPerSecond){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function calculateTimeDeltaMock(uint32) public pure returns (uint256 ){
      return (abi.decode("",(uint256)));
    }
     
    function calculateNewCumulativeRateMock(uint32,uint256,uint256,uint256,uint256) public pure returns (uint256 longCumulativeRates,uint256 shortCumulativeRates){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function setRewardObjectsMock(uint32,uint256,uint256,uint256,uint256) public pure {
      return ();
    }
     
    function addNewStateForFloatRewardsMock(uint32,uint256,uint256,uint256,uint256) public pure {
      return ();
    }
     
    function calculateAccumulatedFloatHelperMock(uint32,address,uint256,uint256,uint256) public pure returns (uint256 longFloatReward,uint256 shortFloatReward){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function calculateAccumulatedFloatMock(uint32,address) public pure returns (uint256 longFloatReward,uint256 shortFloatReward){
      return (abi.decode("",(uint256)),abi.decode("",(uint256)));
    }
     
    function _mintFloatMock(address,uint256) public pure {
      return ();
    }
     
    function mintAccumulatedFloatMock(uint32,address) public pure {
      return ();
    }
     
    function _claimFloatMock(uint32[] memory) public pure {
      return ();
    }
     
    function claimFloatCustomMock(uint32[] memory) public pure {
      return ();
    }
     
    function stakeFromUserMock(address,uint256) public pure {
      return ();
    }
     
    function _stakeMock(ISyntheticToken,uint256,address) public pure {
      return ();
    }
     
    function _withdrawMock(ISyntheticToken,uint256) public pure {
      return ();
    }
     
    function withdrawMock(ISyntheticToken,uint256) public pure {
      return ();
    }
     
    function withdrawAllMock(ISyntheticToken) public pure {
      return ();
    }
     
    function onlyAdminMock() public pure {
      return; 
    }
     
    function onlyValidSyntheticMock(ISyntheticToken) public pure {
      return; 
    }
     
    function onlyValidMarketMock(uint32) public pure {
      return; 
    }
     
    function onlyFloatMock() public pure {
      return; 
    }
    }