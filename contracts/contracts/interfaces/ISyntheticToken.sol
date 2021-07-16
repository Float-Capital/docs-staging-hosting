// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

abstract contract ISyntheticToken is ERC20PresetMinterPauser {
  function stake(uint256 amount) external virtual;
}
