// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "./abstract/AccessControlledAndUpgradeable.sol";

/** Contract giving user XP*/

// Inspired by https://github.com/andrecronje/rarity/blob/main/rarity.sol

/** @title XP */
contract XP is AccessControlledAndUpgradeable {
  bytes32 public constant XP_ROLE = keccak256("XP_ROLE");

  uint256 constant xp_per_day = 250e18;
  uint256 constant DAY = 1 days;

  mapping(address => uint256) public xp;
  mapping(address => uint256) public level;
  mapping(address => uint256) public lastAction;

  event leveled(address indexed owner, uint256 level, uint256 summoner);

  function initialize(
    address _admin,
    address _longShort,
    address _staker
  ) external initializer {
    _AccessControlledAndUpgradeable_init(_admin);
    _setupRole(XP_ROLE, _longShort);
    _setupRole(XP_ROLE, _staker);
  }

  // Say gm and get XP by performing an action in LongShort
  function gm(address user) external {
    // Safer than using onlyRole modifier, as if role permission messed updates
    // We don't want longShot and Staker to revert. Rather they simply don't increase XP
    if (hasRole(XP_ROLE, msg.sender)) {
      if (block.timestamp - lastAction[user] >= DAY) {
        xp[user] += xp_per_day;
        lastAction[user] = block.timestamp;
      }
    }
  }

  function xp_required(uint256 curent_level) public pure returns (uint256 xp_to_next_level) {
    xp_to_next_level = curent_level * 1000e18;
    for (uint256 i = 1; i < curent_level; i++) {
      xp_to_next_level += curent_level * 1000e18;
    }
  }

  function level_up(address _user) external {
    require(msg.sender == user);
    uint256 _level = level[_user];
    uint256 _xp_required = xp_required(_level);
    xp[_user] -= _xp_required;
    level[_user] = _level + 1;
    emit leveled(msg.sender, _level, _user);
  }
}
