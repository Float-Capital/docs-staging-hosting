// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract ISyntheticToken is IERC20 {
    function mint(address to, uint256 amount) public virtual;

    function synthRedeemBurn(address account, uint256 amount) external virtual;

    function stake(uint256 amount) external virtual;
}
