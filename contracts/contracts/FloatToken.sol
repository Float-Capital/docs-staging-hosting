// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";

contract FloatToken is ERC20PresetMinterPauserUpgradeable {
    function setup(
        string calldata name,
        string calldata symbol,
        address stakerAddress
    ) public initializer {
        initialize(name, symbol);

        _setupRole(DEFAULT_ADMIN_ROLE, stakerAddress);
        _setupRole(MINTER_ROLE, stakerAddress);
        _setupRole(PAUSER_ROLE, stakerAddress);

        renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
        renounceRole(MINTER_ROLE, msg.sender);
        renounceRole(PAUSER_ROLE, msg.sender);
    }
}
