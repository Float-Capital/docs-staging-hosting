// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "./interfaces/IStaker.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/ISyntheticToken.sol";

/// @title SyntheticToken
/// @notice TODO
/// @dev
contract SyntheticToken is ISyntheticToken {
  /// @notice TODO
  address public longShort;
  /// @notice TODO
  address public staker;
  /// @notice TODO
  uint32 public marketIndex;
  /// @notice TODO
  bool public isLong;

  /// @notice TODO
  /// @dev TODO
  /// @param name TODO
  /// @param symbol TODO
  /// @param _longShort TODO
  /// @param _staker TODO
  /// @param _marketIndex TODO
  /// @param _isLong TODO

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

  /// @notice TODO
  /// @dev TODO
  /// @param account TODO
  /// @param amount TODO
  function _burn(address account, uint256 amount) internal override {
    require(msg.sender == address(longShort), "Only longSHORT contract");
    super._burn(account, amount);
  }

  /// @notice TODO
  /// @dev TODO
  /// @param amount TODO
  function stake(uint256 amount) external override {
    // NOTE: this is safe, this function will throw "ERC20: transfer
    //       amount exceeds balance" if amount exceeds users balance.
    _transfer(msg.sender, address(staker), amount);

    IStaker(staker).stakeFromUser(msg.sender, amount);
  }

  /*╔══════════════════════════════════════════════════════╗
    ║    FUNCTIONS INHERITED BY ERC20PresetMinterPauser    ║
    ╚══════════════════════════════════════════════════════╝*/

  /// @notice TODO
  /// @dev TODO
  /// @param to TODO
  /// @param amount TODO
  function mint(address to, uint256 amount) public override {
    ERC20PresetMinterPauser.mint(to, amount);
  }

  /// @notice TODO
  /// @dev TODO
  /// @param sender TODO
  /// @param recipient TODO
  /// @param amount TODO
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

  /// @notice TODO
  /// @dev TODO
  /// @param sender TODO
  /// @param
  /// @param TODO
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
      ERC20.balanceOf(account) +
      ILongShort(longShort).getUsersConfirmedButNotSettledSynthBalance(
        account,
        marketIndex,
        isLong
      );
  }
}
