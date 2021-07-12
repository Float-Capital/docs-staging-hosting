pragma solidity 0.8.3;

import "../SyntheticToken.sol";
import "./IStaker.sol";

abstract contract ITokenFactory {
  function createTokenLong(
    string calldata syntheticName,
    string calldata syntheticSymbol,
    IStaker staker,
    uint32 marketIndex
  ) external virtual returns (SyntheticToken);

  function createTokenShort(
    string calldata syntheticName,
    string calldata syntheticSymbol,
    IStaker staker,
    uint32 marketIndex
  ) external virtual returns (SyntheticToken);
}
