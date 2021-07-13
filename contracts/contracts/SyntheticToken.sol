// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "./interfaces/IStaker.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/ISyntheticToken.sol";

contract SyntheticToken is ISyntheticToken, ERC20PresetMinterPauser {
  ILongShort public longShort;
  IStaker public staker;
  uint32 public marketIndex;
  bool public isLong;

  constructor(
    string memory name,
    string memory symbol,
    ILongShort _longShort,
    IStaker _staker,
    uint32 _marketIndex,
    bool _isLong
  ) ERC20PresetMinterPauser(name, symbol) {
    longShort = _longShort;
    staker = _staker;
    marketIndex = _marketIndex;
    isLong = _isLong;
  }

  function synthRedeemBurn(address account, uint256 amount) external override {
    require(msg.sender == address(longShort), "Only longSHORT contract");

    _burn(account, amount);
  }

  function stake(uint256 amount) external override {
    // NOTE: this is safe, this function will throw "ERC20: transfer
    //       amount exceeds balance" if amount exceeds users balance.
    _transfer(msg.sender, address(staker), amount);

    staker.stakeFromUser(msg.sender, amount);
  }

  /*╔══════════════════════════════════════════════════════╗
    ║    FUNCTIONS INHERITED BY ERC20PresetMinterPauser    ║
    ╚══════════════════════════════════════════════════════╝*/

  function mint(address to, uint256 amount)
    public
    override(ISyntheticToken, ERC20PresetMinterPauser)
  {
    ERC20PresetMinterPauser.mint(to, amount);
  }

  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) public override(ERC20, IERC20) returns (bool) {
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
    address recipient,
    uint256 amount
  ) internal override {
    if (sender != address(longShort)) {
      longShort.executeOutstandingNextPriceSettlementsUser(sender, marketIndex);
    }
    uint256 balance = ERC20.balanceOf(sender);
    uint256 balanceAll = balanceOf(sender);
  }

  /**
   * @dev See {IERC20-balanceOf}.
   */
  function balanceOf(address account)
    public
    view
    virtual
    override(ERC20, IERC20)
    returns (uint256)
  {
    return
      longShort.getUsersConfirmedButNotSettledBalance(account, marketIndex, isLong) +
      ERC20.balanceOf(account);
  }
}
