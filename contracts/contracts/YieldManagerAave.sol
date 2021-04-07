// SPDX-License-Identifier: MIT

pragma solidity 0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

import "./interfaces/IYieldManager.sol";
import "./interfaces/aave/ILendingPool.sol";

/*
 * YieldManagerAave is an implementation of a yield manager that earns
 * APY through the Aave protocol. Each underlying asset (such as DAI)
 * has a corresponding aToken (such as aDAI) that continuously accrues
 * interest based on a lend/borrow liquidity ratio.
 *     see: https://docs.aave.com/portal/
 */
contract YieldManagerAave is IYieldManager, Initializable {
    // Admin contracts.
    address public admin;
    address public longShort;

    // Global state.
    ERC20 token; // underlying asset token
    IERC20Upgradeable aToken; // corresponding aToken
    ILendingPool lendingPool;

    uint16 referralCode;

    ////////////////////////////////////
    /////////// MODIFIERS //////////////
    ////////////////////////////////////

    modifier adminOnly() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier longShortOnly() {
        require(msg.sender == longShort, "Not longShort");
        _;
    }

    ////////////////////////////////////
    ///// CONTRACT SET-UP //////////////
    ////////////////////////////////////

    /*
     * Initialises the yield manager with the given underlying asset token
     * and corresponding venus aToken. We have to check whether it's BNB,
     * since BNB has a different interface to other ERC20 tokens in venus.io.
     */
    function setup(
        address _admin,
        address _longShort,
        address _token,
        address _aToken,
        address _lendingPool,
        uint16 _aaveReferalCode
    ) public initializer {
        admin = _admin;
        longShort = _longShort;

        referralCode = _aaveReferalCode;

        token = ERC20(_token);
        aToken = IERC20Upgradeable(_aToken);
        lendingPool = ILendingPool(_lendingPool);
    }

    ////////////////////////////////////
    /// MULTISIG ADMIN FUNCTIONS ///////
    ////////////////////////////////////

    function changeAdmin(address _admin) external adminOnly {
        admin = _admin;
    }

    ////////////////////////////////////
    ///// IMPLEMENTATION ///////////////
    ////////////////////////////////////

    function depositToken(uint256 amount) public override longShortOnly {
        // Transfer tokens to manager contract.
        token.transferFrom(longShort, address(this), amount);

        // Transfer tokens to aToken contract to mint aTokens.
        token.approve(address(lendingPool), amount);

        // Deposit the desired amount of tokens into the aave pool
        lendingPool.deposit(
            address(token),
            amount,
            address(this),
            referralCode
        );
    }

    function withdrawToken(uint256 amount) public override longShortOnly {
        // Redeem aToken for underlying asset tokens.
        uint256 amountWithdrawn =
            lendingPool.withdraw(address(token), amount, address(this));

        // TODO: if it only manages to do a partial withdraw this will revert. Make it partially work.
        //       Not 100% sure this is how aave v2 works, need to read their code more carefully.
        require(amountWithdrawn == amount);

        // Transfer tokens back to LongShort contract.
        token.transfer(longShort, amount);
    }

    function getTotalHeld() public override returns (uint256 amount) {
        return aToken.balanceOf(address(this));
    }

    function getHeldToken() public view override returns (address _token) {
        return address(token);
    }
}
