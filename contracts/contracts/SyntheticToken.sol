// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "./interfaces/IStaker.sol";

contract SyntheticToken is ERC20PresetMinterPauser {
    address public longShortAddress;
    IStaker public staker;

    constructor(
        string memory name,
        string memory symbol,
        address _longShortAddress,
        address stakerAddress
    ) ERC20PresetMinterPauser(name, symbol) {
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

        staker.stakeFromUser(msg.sender, amount);
    }
}
