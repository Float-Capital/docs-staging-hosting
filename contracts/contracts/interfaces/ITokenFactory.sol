pragma solidity 0.8.3;

import "../SyntheticToken.sol";

abstract contract ITokenFactory {
    function createTokenLong(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address staker
    ) external virtual returns (SyntheticToken);

    function createTokenShort(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address staker
    ) external virtual returns (SyntheticToken);
}
