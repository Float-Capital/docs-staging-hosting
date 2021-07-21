// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "./interfaces/IStaker.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/ISyntheticToken.sol";

contract SyntheticToken is ISyntheticToken {
  address public longShort;
  address public staker;
  uint32 public marketIndex;
  bool public isLong;

  constructor(
    string memory name,
    string memory symbol,
    address _longShort,
    address _staker,
    uint32 _marketIndex,
    bool _isLong
  ) ERC20PresetMinterPauser(name, symbol) {
    longShort = _longShort;
    staker = _staker;
    marketIndex = _marketIndex;
    isLong = _isLong;
  }

  function _burn(address account, uint256 amount) internal override {
    require(msg.sender == address(longShort), "Only longSHORT contract");
    super._burn(account, amount);
  }

  function stake(uint256 amount) external override {
    // NOTE: this is safe, this function will throw "ERC20: transfer
    //       amount exceeds balance" if amount exceeds users balance.
    _transfer(msg.sender, address(staker), amount);

    IStaker(staker).stakeFromUser(msg.sender, amount);
  }

  /*╔══════════════════════════════════════════════════════╗
    ║    FUNCTIONS INHERITED BY ERC20PresetMinterPauser    ║
    ╚══════════════════════════════════════════════════════╝*/

  function mint(address to, uint256 amount) public override {
    ERC20PresetMinterPauser.mint(to, amount);
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public override returns (bool) {
    if (recipient == address(longShort) && msg.sender == address(longShort)) {
      // TODO STENT so this means that the longShort contract is sending to itself?
      //      There is no function call like this in the LongShort contract.
      _transfer(sender, recipient, amount);
      return true;
    } else {
      return super.transferFrom(sender, recipient, amount);
    }
  }

  function _beforeTokenTransfer(
    address sender,
    address,
    uint256
  ) internal override {
    if (sender != address(longShort)) {
      ILongShort(longShort).executeOutstandingNextPriceSettlementsUser(sender, marketIndex);
    }
  }

  /**
   * @dev See {IERC20-balanceOf}.
   */
  function balanceOf(address account) public view virtual override returns (uint256) {
    return
      uint256(
        int256(ERC20.balanceOf(account)) +
          ILongShort(longShort).getUsersConfirmedButNotSettledBalance(account, marketIndex, isLong)
      );
  }
}
