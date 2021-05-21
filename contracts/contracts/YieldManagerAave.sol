// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
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
contract YieldManagerAave is IYieldManager {
    // Admin contracts.
    address public admin;
    address public longShort;
    address public treasury;

    // Global state.
    ERC20 public token; // underlying asset token
    IERC20Upgradeable public aToken; // corresponding aToken
    ILendingPool public lendingPool;

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
    
    modifier treasuryOnly() {
        require(msg.sender == treasury, "Not treasury");
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
    constructor(
        address _admin,
        address _longShort,
        address _treasury,
        address _token,
        address _aToken,
        address _lendingPool,
        uint16 _aaveReferalCode
    ) {
        admin = _admin;
        longShort = _longShort;
        treasury = _treasury;

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
        // This will fail if not enough liquidity is avaiable on aave.
        uint256 amountWithdrawn =
            lendingPool.withdraw(address(token), amount, address(this));

        // Transfer tokens back to LongShort contract.
        token.transfer(longShort, amount);
    }
    
    function withdrawErc20TokenToTreasury(address erc20Token) external treasuryOnly {
        // Redeem other erc20 for underlying asset tokens.        
        // Transfer tokens back to Treasury contract.
        uint256 amount = IERC20Upgradeable(erc20Token).balanceOf(address(this));
        IERC20Upgradeable(erc20Token).transfer(treasury, amount);
    }

    function getTotalHeld() public view override returns (uint256 amount) {
        return aToken.balanceOf(address(this));
    }

    function getHeldToken() public view override returns (address _token) {
        return address(token);
    }
}
