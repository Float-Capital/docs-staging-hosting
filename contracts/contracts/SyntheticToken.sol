//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.2;

import "@openzeppelin/contracts-upgradeable/token/ERC20/presets/ERC20PresetMinterPauserUpgradeable.sol";
import "./interfaces/IStaker.sol";

contract SyntheticToken is ERC20PresetMinterPauserUpgradeable {
    address public longShortAddress;
    IStaker public staker;

    function initialize(
        string memory name,
        string memory symbol,
        address _longShortAddress,
        address stakerAddress
    ) public initializer {
        ERC20PresetMinterPauserUpgradeable.initialize(name, symbol);
        longShortAddress = _longShortAddress;
        staker = IStaker(stakerAddress);
    }

    function synthRedeemBurn(address account, uint256 amount) external {
        require(msg.sender == longShortAddress, "Only longSHORT contract");

        _burn(account, amount);
    }

    function stake(uint256 amount) external {
        // NOTE: this is safe, this function will throw "ERC20: transfer amount exceeds balance" if amount exceeds users balance
        _transfer(msg.sender, address(staker), amount);

        staker.stakeDirect(msg.sender, amount);
    }
}
