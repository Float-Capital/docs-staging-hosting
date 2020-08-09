//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@nomiclabs/buidler/console.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorInterface.sol";

import "./interfaces/IAaveLendingPool.sol";
import "./interfaces/IADai.sol";
import "./interfaces/ILendingPoolAddressesProvider.sol";

import "./LongCoins.sol";
import "./ShortCoins.sol";

contract LongShort {
    using SafeMath for uint256;
    // Oracle
    AggregatorInterface internal priceFeed;

    // Value of the underlying from which we caluclate
    // gains and losses by respective sides
    uint256 public assetPrice;

    uint256 public totalValueLocked;
    uint256 public longValue;
    uint256 public shortValue;

    // Tokens representing short and long position and cost at which
    // They can be minted or redeemed
    LongCoins public longTokens;
    ShortCoins public shortTokens;
    uint256 public longTokenPrice;
    uint256 public shortTokenPrice; // gas costs.

    // DEFI contracts
    IERC20 public daiContract;
    IAaveLendingPool public aaveLendingContract;
    IADai public adaiContract;
    ILendingPoolAddressesProvider public provider;
    address public aaveLendingContractCore;

    /**
     * Necessary to update system state before any contract actions (deposits / withdraws)
     */
    modifier refreshSystemState() {
        _updateSystemState();
        _;
    }

    /**
     * Network: Kovan
     * Aggregator: BTC/USD
     * Address: 0x2445F2466898565374167859Ae5e3a231e48BB41
     * TODO: weigh up pros/cons of making this upgradable
     */
    constructor(
        address _longCoins,
        address _shortCoins,
        address daiAddress,
        address aDaiAddress,
        // lendingPoolAddressProvider should be one of below depending on deployment
        // kovan 0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5
        // mainnet 0x24a42fD28C976A61Df5D00D0599C34c4f90748c8
        address lendingPoolAddressProvider
    ) public {
        priceFeed = AggregatorInterface(
            0x2445F2466898565374167859Ae5e3a231e48BB41
        );
        // Will need to make sure we are a minter! and pauser!
        longTokens = LongCoins(_longCoins);
        shortTokens = ShortCoins(_shortCoins);

        daiContract = IERC20(daiAddress);
        provider = ILendingPoolAddressesProvider(lendingPoolAddressProvider);
        adaiContract = IADai(aDaiAddress);

        // Intialize price at $1 per token (adjust decimals)
        longTokenPrice = 1;
        shortTokenPrice = 1;
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int256) {
        return priceFeed.latestAnswer();
    }

    /**
     * Returns the timestamp of the latest price update
     */
    function getLatestPriceTimestamp() public view returns (uint256) {
        return priceFeed.latestTimestamp();
    }

    /**
     * Returns % of long position that is filled
     */
    function getLongBeta() public view returns (uint256) {
        // TODO account for contract start when these are both zero
        // and an erronous beta of 1 reported.
        if (shortValue >= longValue) {
            return 1;
        } else {
            return shortValue.div(longValue);
        }
    }

    /**
     * Returns % of short position that is filled
     * zero div  error if both are zero
     */
    function getShortBeta() public view returns (uint256) {
        if (longValue >= shortValue) {
            return 1;
        } else {
            return longValue.div(shortValue);
        }
    }

    /**
     * Adds and credits the interest due before new minting or withdrawl.
     * Currently works on 50/50 split between long and short
     * This can be dynamic and configurable
     */
    function _accreditInterestMechanism() internal {
        uint256 totalValueWithInterest = adaiContract.balanceOf(address(this));

        uint256 interestAccrued = totalValueWithInterest.sub(totalValueLocked);
        if (interestAccrued > 0) {
            longValue = longValue.add(interestAccrued.div(2));
            shortValue = shortValue.add(interestAccrued.div(2));
            totalValueLocked = totalValueWithInterest;
        }
    }

    /**
     * Updates the value of the long and short sides within the system
     */
    function _updateSystemState() internal {
        // For system start, no value adjustment till positions on both sides exist
        // Consider attacks of possible zero balances later on in contract life?
        if (longValue == 0 || shortValue == 0) {
            return;
        }

        // Check why this is bad (casting to uint)
        uint256 newPrice = uint256(getLatestPrice());
        // If no new price update from oracle, proceed as normal
        if (assetPrice == newPrice) {
            return;
        }

        uint256 percentageChange;
        uint256 valueChange = 0;
        // Long gains
        if (newPrice > assetPrice) {
            percentageChange = (newPrice.sub(assetPrice)).div(assetPrice);
            if (getShortBeta() == 1) {
                valueChange = shortValue.mul(percentageChange);
            } else {
                valueChange = longValue.mul(percentageChange);
            }
            longValue = longValue.add(valueChange);
            shortValue = shortValue.sub(valueChange); // NB Check for going below zero and system instability
        } else {
            percentageChange = (assetPrice.sub(newPrice)).div(assetPrice);
            if (getShortBeta() == 1) {
                valueChange = shortValue.mul(percentageChange);
            } else {
                valueChange = longValue.mul(percentageChange);
            }
            longValue = longValue.sub(valueChange);
            shortValue = shortValue.add(valueChange);
        }

        // Now add interest to both sides
        _accreditInterestMechanism();

        // Update price of tokens
        // careful if total supply is zero intitally.
        longTokenPrice = longValue.div(longTokens.totalSupply());
        shortTokenPrice = shortValue.div(shortTokens.totalSupply());
        assetPrice = newPrice;
    }

    function _addDeposit(uint256 amount) internal {
        require(amount > 0);
        aaveLendingContract = IAaveLendingPool(provider.getLendingPool());
        aaveLendingContractCore = provider.getLendingPoolCore();

        daiContract.transferFrom(msg.sender, address(this), amount);
        daiContract.approve(aaveLendingContractCore, amount);
        aaveLendingContract.deposit(address(daiContract), amount, 30);

        totalValueLocked = totalValueLocked.add(amount);
    }

    /**
     * Create a long position
     */
    function mintLong(uint256 amount) external refreshSystemState {
        _addDeposit(amount);

        uint256 amountToMint = amount.div(longTokenPrice);
        longValue = longValue.add(amount);
        longTokens.mint(msg.sender, amountToMint);
    }

    /**
     * Create a short position
     */
    function mintShort(uint256 amount) external refreshSystemState {
        _addDeposit(amount);

        uint256 amountToMint = amount.div(shortTokenPrice);
        shortValue = shortValue.add(amount);
        shortTokens.mint(msg.sender, amountToMint);
    }

    function _redeem(uint256 amount) internal {
        totalValueLocked = totalValueLocked.sub(amount);

        try adaiContract.redeem(amount)  {
            daiContract.transfer(msg.sender, amount);
        } catch {
            adaiContract.transfer(msg.sender, amount);
        }
    }

    function redeemLong(uint256 tokensToRedeem) external refreshSystemState {
        // Burn the tokens to redeem
        longTokens.burnFrom(msg.sender, tokensToRedeem);

        uint256 amountToRedeem = tokensToRedeem.mul(longTokenPrice);
        longValue = longValue.sub(amountToRedeem);
        _redeem(amountToRedeem);
    }

    function redeemShort(uint256 tokensToRedeem) external refreshSystemState {
        // Burn the tokens to redeem
        shortTokens.burnFrom(msg.sender, tokensToRedeem);

        uint256 amountToRedeem = tokensToRedeem.mul(shortTokenPrice);
        shortValue = shortValue.sub(amountToRedeem);
        _redeem(amountToRedeem);
    }
}
