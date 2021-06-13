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
    // TODO: these values aren't set by the contructor/initializer
    uint32 public marketIndex;
    ILongShort.MarketSide public syntheticTokenType;

    constructor(
        string memory name,
        string memory symbol,
        ILongShort _longShort,
        IStaker _staker,
        uint32 _marketIndex,
        ILongShort.MarketSide _syntheticTokenType
    ) ERC20PresetMinterPauser(name, symbol) {
        longShort = _longShort;
        staker = _staker;
        marketIndex = _marketIndex;
        syntheticTokenType = _syntheticTokenType;
    }

    modifier settleRemainingNextPriceExecutions(address user) {
        if (user != address(longShort)) {
            longShort.executeOutstandingLazySettlementsUser(user, marketIndex);
        }
        uint256 balance = ERC20.balanceOf(user);
        uint256 balanceAll = balanceOf(user);
        _;
    }

    function synthRedeemBurn(address account, uint256 amount)
        external
        override
    {
        require(msg.sender == address(longShort), "Only longSHORT contract");

        _burn(account, amount);
    }

    function stake(uint256 amount)
        external
        override
        settleRemainingNextPriceExecutions(msg.sender)
    {
        // NOTE: this is safe, this function will throw "ERC20: transfer amount exceeds balance" if amount exceeds users balance
        _transfer(msg.sender, address(staker), amount);

        staker.stakeFromUser(msg.sender, amount);
    }

    ////////////////////////////////////////////////////////////////////
    ///////// FUNCTIONS INHERITED BY ERC20PresetMinterPauser ///////////
    ////////////////////////////////////////////////////////////////////
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
    )
        public
        override(ERC20, IERC20)
        settleRemainingNextPriceExecutions(sender)
        returns (bool)
    {
        if (
            recipient == address(longShort) && msg.sender == address(longShort)
        ) {
            // TODO STENT so this means that the longShort contract is sending to itself? There is no function call like this in the LongShort contract
            _transfer(sender, recipient, amount);
            return true;
        } else {
            return super.transferFrom(sender, recipient, amount);
        }
    }

    // NOTE: we could use `_beforeTokenTransfer` here rather
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        ERC20._transfer(sender, recipient, amount);
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
            longShort.getUsersPendingBalance(
                account,
                marketIndex,
                syntheticTokenType
            ) + ERC20.balanceOf(account);
    }
}
