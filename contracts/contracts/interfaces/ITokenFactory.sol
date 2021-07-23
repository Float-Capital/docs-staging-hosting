pragma solidity 0.8.3;

abstract contract ITokenFactory {
  function createTokenLong(
    string calldata syntheticName,
    string calldata syntheticSymbol,
    address staker,
    uint32 marketIndex
  ) external virtual returns (address);

  function createTokenShort(
    string calldata syntheticName,
    string calldata syntheticSymbol,
    address staker,
    uint32 marketIndex
  ) external virtual returns (address);
}
