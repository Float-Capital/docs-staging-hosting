// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

abstract contract ILongShort {
  function updateSystemState(uint32 marketIndex) external virtual;

  function updateSystemStateMulti(uint32[] calldata marketIndex) external virtual;

  function getUsersConfirmedButNotSettledBalance(
    address user,
    uint32 marketIndex,
    bool isLong
  ) external view virtual returns (uint256 pendingBalance);

  function executeOutstandingNextPriceSettlementsUser(address user, uint32 marketIndex)
    external
    virtual;
}
