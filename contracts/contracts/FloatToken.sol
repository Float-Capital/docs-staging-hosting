// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;
/* The bellow code can make this token non-upgradable. This can be decided closer to launch6
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract FloatToken is ERC20PresetMinterPauser {
    constructor(
        string memory name,
        string memory symbol,
        address stakerAddress
    ) ERC20PresetMinterPauser(name, symbol) {
*/
import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";

import "./interfaces/IFloatToken.sol";

contract FloatToken is IFloatToken, ERC20PresetMinterPauserUpgradeable {
    function initialize(
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

    ///////////////////////////////////////////////////////////////////////////////
    ///////// FUNCTIONS INHERITED BY ERC20PresetMinterPauserUpgradeable ///////////
    ///////////////////////////////////////////////////////////////////////////////
    function mint(address to, uint256 amount)
        public
        override(IFloatToken, ERC20PresetMinterPauserUpgradeable)
    {
        ERC20PresetMinterPauserUpgradeable.mint(to, amount);
    }
}
