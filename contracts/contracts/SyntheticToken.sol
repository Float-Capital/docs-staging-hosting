// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "./interfaces/IStaker.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/ISyntheticToken.sol";

/// @title SyntheticToken
/// @notice
/// @dev
contract SyntheticToken is ISyntheticToken {
  /// @notice
  address public longShort;
  /// @notice
  address public staker;
  /// @notice
  uint32 public marketIndex;
  /// @notice
  bool public isLong;

  /// @notice
  /// @dev
  /// @param name
  /// @param symbol
  /// @param _longShort
  /// @param _staker
  /// @param _marketIndex
  /// @param _isLong
  /// @return
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

  /// @notice
  /// @dev
  /// @param account
  /// @param amount
  /// @return
  function _burn(address account, uint256 amount) internal override {
    require(msg.sender == address(longShort), "Only longSHORT contract");
    super._burn(account, amount);
  }

  /// @notice
  /// @dev
  /// @param amount
  /// @return
  function stake(uint256 amount) external override {
    // NOTE: this is safe, this function will throw "ERC20: transfer
    //       amount exceeds balance" if amount exceeds users balance.
    _transfer(msg.sender, address(staker), amount);

    IStaker(staker).stakeFromUser(msg.sender, amount);
  }

  /*╔══════════════════════════════════════════════════════╗
    ║    FUNCTIONS INHERITED BY ERC20PresetMinterPauser    ║
    ╚══════════════════════════════════════════════════════╝*/

  /// @notice
  /// @dev
  /// @param to
  /// @param amount
  /// @return
  function mint(address to, uint256 amount) public override {
    ERC20PresetMinterPauser.mint(to, amount);
  }

  /// @notice
  /// @dev
  /// @param sender
  /// @param recipient
  /// @param amount
  /// @return
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

  /// @notice
  /// @dev
  /// @param sender
  /// @param
  /// @param
  /// @return
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
