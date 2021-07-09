// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";

import "./interfaces/IYieldManager.sol";
import "./interfaces/aave/ILendingPool.sol";

/*
 * YieldManagerAave is an implementation of a yield manager that earns
 * APY through the Aave protocol. Each fund's payment token (such as DAI)
 * has a corresponding aToken (such as aDAI) that continuously accrues
 * interest based on a lend/borrow liquidity ratio.
 *     see: https://docs.aave.com/portal/
 */
contract YieldManagerAave is IYieldManager {
    /*╔═════════════════════════════╗
      ║          VARIABLES          ║
      ╚═════════════════════════════╝*/

    // Fixed-precision constants ///////////////////////////////
    uint256 public constant TEN_TO_THE_18 = 1e18;

    // Addresses ///////////////////////////////////////////////
    address public admin;
    address public longShort;
    address public treasury;

    // Global state ////////////////////////////////////////////
    ERC20 public paymentToken;
    IERC20Upgradeable public aToken;
    ILendingPool public lendingPool;

    uint16 referralCode;
    uint256 public override totalReservedForTreasury;

    /*╔═════════════════════════════╗
      ║          MODIFIERS          ║
      ╚═════════════════════════════╝*/

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

    /*╔═════════════════════════════╗
      ║       CONTRACT SET-UP       ║
      ╚═════════════════════════════╝*/

    /*
     * Initialises the yield manager with the given payment token
     * and corresponding venus aToken.
     */
    constructor(
        address _admin,
        address _longShort,
        address _treasury,
        address _paymentToken,
        address _aToken,
        address _lendingPool,
        uint16 _aaveReferalCode
    ) {
        admin = _admin;
        longShort = _longShort;
        treasury = _treasury;

        referralCode = _aaveReferalCode;

        paymentToken = ERC20(_paymentToken);
        aToken = IERC20Upgradeable(_aToken);
        lendingPool = ILendingPool(_lendingPool);

        // Approve tokens for aave lending pool maximally.
        paymentToken.approve(address(lendingPool), type(uint256).max);
    }

    /*╔═════════════════════════════╗
      ║       MULTI-SIG ADMIN       ║
      ╚═════════════════════════════╝*/

    function changeAdmin(address _admin) external adminOnly {
        admin = _admin;
    }

    /*╔════════════════════════╗
      ║     IMPLEMENTATION     ║
      ╚════════════════════════╝*/

    function depositPaymentToken(uint256 amount) public override longShortOnly {
        // Transfer tokens to manager contract.
        paymentToken.transferFrom(longShort, address(this), amount);

        // Deposit the desired amount of tokens into the aave pool
        lendingPool.deposit(
            address(paymentToken),
            amount,
            address(this),
            referralCode
        );
    }

    function withdrawPaymentToken(uint256 amount)
        public
        override
        longShortOnly
    {
        // Redeem aToken for payment tokens.
        // This will fail if not enough liquidity is avaiable on aave.
        lendingPool.withdraw(address(paymentToken), amount, address(this));

        // Transfer payment tokens back to LongShort contract.
        paymentToken.transfer(longShort, amount);
    }

    function withdrawErc20TokenToTreasury(address erc20Token)
        external
        override
        treasuryOnly
    {
        // Redeem other erc20 tokens.
        // Transfer tokens back to Treasury contract.
        require(
            erc20Token != address(aToken),
            "Cannot withdraw aToken to treasury"
        );

        uint256 amount = IERC20Upgradeable(erc20Token).balanceOf(address(this));

        // Transfer tokens to treasury
        IERC20Upgradeable(erc20Token).transfer(treasury, amount);

        emit WithdrawErc20TokenToTreasury(erc20Token, amount);
    }

    /*
     * Calculate the amount of yield that has yet to be claimed,
     * note how much is reserved for the treasury and return how
     * much is reserved for the market. The yield is split between
     * the market and the treasury so treasuryPercent = 1 - marketPercent.
     */
    // TODO STENT not unit tested
    function claimYieldAndGetMarketAmount(
        uint256 totalValueRealizedForMarket,
        uint256 treasuryPercentE18
    ) public override longShortOnly returns (uint256) {
        uint256 totalHeld = aToken.balanceOf(address(this));

        uint256 unrealizedYield = totalHeld -
            totalValueRealizedForMarket -
            totalReservedForTreasury;

        if (unrealizedYield == 0) {
            return 0;
        }

        uint256 amountForTreasury = (unrealizedYield * treasuryPercentE18) /
            TEN_TO_THE_18;
        uint256 amountForMarketIncetives = unrealizedYield - amountForTreasury;

        totalReservedForTreasury += amountForTreasury;

        emit YieldDistributed(unrealizedYield, treasuryPercentE18);

        return amountForMarketIncetives;
    }

    /*
     * Transfer payment tokens owed to the treasury to the treasury.
     */
    // TODO STENT not unit tested
    function withdrawTreasuryFunds() external override {
        uint256 amountToWithdrawForTreasury = totalReservedForTreasury;
        totalReservedForTreasury = 0;

        // Redeem aToken for payment tokens.
        // This will fail if not enough liquidity is avaiable on aave.
        lendingPool.withdraw(
            address(paymentToken),
            amountToWithdrawForTreasury,
            treasury
        );

        emit WithdrawTreasuryFunds();
    }
}
