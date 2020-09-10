//SPDX-License-Identifier: Unlicense
pragma solidity 0.6.12;

import "@nomiclabs/buidler/console.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

import "./interfaces/IAaveLendingPool.sol";
import "./interfaces/IADai.sol";
import "./interfaces/ILendingPoolAddressesProvider.sol";

import "./LongCoins.sol";
import "./ShortCoins.sol";

/**
 * @dev {LongShort} contract, including:
 *
 *  - Ability for users to create synthetic long and short positions on value movements
 *  - Value movements could be derived from tradional or alternative asset classes, derivates, binary outcomes, etc...
 *  - Incentive mechansim providng fees to liquidity makers
 *
 * ******* SYSTEM FUNCTIONING V0.0 ***********
 * System accepts stable coin (DAI) and has a total locked value = short position value + long position value
 * If percentage movement as calucated from oracle is +10%, and short position value == long position value,
 * Then value change = long position value * 10%
 * long position value = long position value + value change
 * short position value = short position value - value change
 * Total contract value remains unchanged.
 * long value has increased and each longtoken is now worth more as underlying pool avlue has increased.
 *
 * Tokens representing a shares in the short or long token pool can be minted
 * at price (short position value) / (total short token value)
 * or conversley burned to redeem the underlying share of the pool caluclated
 * as (short position value) / (total short token value) per token
 *
 * Depending on demand of minting and burning for undelying on both sides (long/short of contract),
 * most often short position value != long position value (there will be an imbalance)
 * Imbalances also naturally occur as the contract adjusts these values after observing oracle value changes
 * Incentives exist to best incentivize contract balance.
 *
 * Mechanim 1 - interest accural imbalance.
 * The entire total locked value accures interest and distributes it 50/50 even if imbalance exists.
 * I.e. Short side supplys $50 capital. Long side supply $150. Short side effectively earns interest on $100.
 * Enhanced yeild exists for sides taking on the position with less demand.
 *
 * Mechanism 2 - liquidity fees earned.
 * The side which is shorter on liquidity will recieve fees strengthening their value
 * Whenever liquidity is added to the opposing side or withdrawn from their side (i.e. when the imbalance increases)
 *
 * ******* KNOWN ATTACK VECTORS ***********
 * (1) Feeless withdrawl:
 * Long position $150, Short position $100. User should pay fee to remove short liquidity.
 * Step1: User mints $51 of short position (No fee to add liquidity).
 * Step2: User redeems $100 of short position (no fee as currently removing liquidity from bigger side)
 * Possible solution, check after deposit/withdrawl if order book has flipped, then apply fees.
 *
 * (2) FlashLoan mint:
 * Consider rapid large entries and exit of the system.
 *
 * (3) Oracle manipulation:
 * If the oracle determining price change can be easy manipulated (and by a decent magnitude),
 * Funds could be at risk. See: https://blog.trailofbits.com/2020/08/05/accidentally-stepping-on-a-defi-lego/
 */
contract LongShort {
    using SafeMath for uint256;
    // Oracle
    AggregatorV3Interface internal priceFeed;

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
    uint256 public shortTokenPrice;

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
        address lendingPoolAddressProvider,
        address _priceOracle
    ) public {
        priceFeed = AggregatorV3Interface(_priceOracle);

        // Will need to make sure we are a minter! and pauser!
        longTokens = LongCoins(_longCoins);
        shortTokens = ShortCoins(_shortCoins);

        daiContract = IERC20(daiAddress);
        provider = ILendingPoolAddressesProvider(lendingPoolAddressProvider);
        adaiContract = IADai(aDaiAddress);

        // Intialize price at $1 per token (adjust decimals)
        longTokenPrice = 10**18;
        shortTokenPrice = 10**18;
    }

    /**
     * Returns the latest price
     */
    function getLatestPrice() public view returns (int256) {
        (
            uint80 roundID,
            int256 price,
            uint256 startedAt,
            uint256 timeStamp,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
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

    function _refreshTokensPrice() internal {
        longTokenPrice = longValue.div(longTokens.totalSupply());
        shortTokenPrice = shortValue.div(shortTokens.totalSupply());
    }

    /**
     * Fees for depositing or leaving the pool if you are not a
     * liquidity taker and not a liquidity maker...
     * This is v1 mechanism
     */
    function _feesMechanism(
        uint256 totalFees,
        uint256 longPercentage,
        uint256 shortPercentage
    ) internal {
        _increaseLongShortSides(totalFees, longPercentage, shortPercentage);
        _refreshTokensPrice();
    }

    /**
     * Adds and credits the interest due before new minting or withdrawl.
     * Currently works on 50/50 split between long and short
     * This can be dynamic and configurable
     */
    function _accreditInterestMechanism(
        uint256 longPercentage,
        uint256 shortPercentage
    ) internal {
        uint256 totalValueWithInterest = adaiContract.balanceOf(address(this));
        uint256 interestAccrued = totalValueWithInterest.sub(totalValueLocked);
        _increaseLongShortSides(
            interestAccrued,
            longPercentage,
            shortPercentage
        );

        totalValueLocked = totalValueWithInterest;
    }

    /**
     * Generic function to add value to the system
     * Interest or fees
     */
    function _increaseLongShortSides(
        uint256 amount,
        uint256 longPercentage,
        uint256 shortPercentage
    ) internal {
        require(100 == shortPercentage.add(longPercentage));
        require(amount > 0);

        longValue = longValue.add(amount.mul(longPercentage).div(100));
        shortValue = shortValue.add(amount.mul(shortPercentage).div(100));
    }

    function _priceChangeMechanism(uint256 newPrice) internal {
        // If no new price update from oracle, proceed as normal
        if (assetPrice == newPrice) {
            return;
        }

        uint256 percentageChange;
        uint256 valueChange = 0;
        // Long gains
        if (newPrice > assetPrice) {
            percentageChange = (newPrice.sub(assetPrice)).div(assetPrice);
            if (percentageChange >= 1) {
                // More than 100% price movement, system liquidation.
                longValue = longValue.add(shortValue);
                shortValue = 0;
            } else {
                if (getShortBeta() == 1) {
                    valueChange = shortValue.mul(percentageChange);
                } else {
                    valueChange = longValue.mul(percentageChange);
                }
                longValue = longValue.add(valueChange);
                shortValue = shortValue.sub(valueChange);
            }
        } else {
            percentageChange = (assetPrice.sub(newPrice)).div(assetPrice);
            if (percentageChange >= 1) {
                shortValue = shortValue.add(longValue);
                longValue = 0;
            } else {
                if (getShortBeta() == 1) {
                    valueChange = shortValue.mul(percentageChange);
                } else {
                    valueChange = longValue.mul(percentageChange);
                }
                longValue = longValue.sub(valueChange);
                shortValue = shortValue.add(valueChange);
            }
        }
    }

    /**
     * Updates the value of the long and short sides within the system
     */
    function _updateSystemState() public {
        // For system start, no value adjustment till positions on both sides exist
        // Consider attacks of possible zero balances later on in contract life?
        if (longValue == 0 && shortValue == 0) {
            return;
        } else if (longValue == 0) {
            assetPrice = uint256(getLatestPrice());
            _accreditInterestMechanism(0, 100); // Give all interest to short side while we wait
            shortTokenPrice = shortValue.div(shortTokens.totalSupply());
            return;
        } else if (shortValue == 0) {
            assetPrice = uint256(getLatestPrice());
            _accreditInterestMechanism(100, 0); // Give all interest to long side while we wait
            longTokenPrice = longValue.div(longTokens.totalSupply());
            return;
        }

        // Check why this is bad (casting to uint)
        uint256 newPrice = uint256(getLatestPrice());

        // Adjusts long and short values based on price movements.
        _priceChangeMechanism(newPrice);

        // Now add interest to both sides in 50/50
        // If the price moved by more than 100% and the one side is completly liquidated
        if (longValue == 0) {
            _accreditInterestMechanism(0, 100);
        } else if (shortValue == 0) {
            _accreditInterestMechanism(100, 0);
        } else {
            _accreditInterestMechanism(50, 50);
        }

        // Update price of tokens
        // careful if total supply is zero intitally.
        _refreshTokensPrice();
        assetPrice = newPrice;

        require(longValue.add(shortValue) == totalValueLocked); //for testing
    }

    function _addDeposit(uint256 amount) internal {
        require(amount > 0, "USer needs to add positive amount");
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
        uint256 amountToMint = 0;

        // Pay fees if you are diluting the position
        // Make this more finegrained... and less coarse.
        if (getLongBeta() < 1) {
            uint256 fees = amount.mul(5).div(1000);
            uint256 depositLessFees = amount.sub(fees);
            _feesMechanism(fees, 0, 100);

            amountToMint = depositLessFees.div(longTokenPrice);
            longValue = longValue.add(depositLessFees);
        } else {
            amountToMint = amount.div(longTokenPrice);
            longValue = longValue.add(amount);
        }

        longTokens.mint(msg.sender, amountToMint);
        // longTokenPrice should remain unchanged after mint...
        // Likely slight rounding errors. Figure this out.
        require(longTokenPrice == longValue.div(longTokens.totalSupply()));
        require(longValue.add(shortValue) == totalValueLocked);
    }

    /**
     * Create a short position
     */
    function mintShort(uint256 amount) external refreshSystemState {
        _addDeposit(amount);
        uint256 amountToMint = 0;

        // Pay fees if you are diluting the position
        if (getShortBeta() < 1) {
            uint256 fees = amount.mul(5).div(1000);
            uint256 depositLessFees = amount.sub(fees);
            _feesMechanism(fees, 100, 0);

            amountToMint = depositLessFees.div(shortTokenPrice);
            shortValue = shortValue.add(depositLessFees);
        } else {
            amountToMint = amount.div(shortTokenPrice);
            shortValue = shortValue.add(amount);
        }

        // Check division errors here!
        shortTokens.mint(msg.sender, amountToMint);

        // shortTokenPrice should remain unchanged after mint...
        // Likely slight rounding errors. Figure this out.
        require(shortTokenPrice == shortValue.div(shortTokens.totalSupply()));
        require(longValue.add(shortValue) == totalValueLocked);
    }

    function _redeem(uint256 amount) internal {
        totalValueLocked = totalValueLocked.sub(amount);

        try adaiContract.redeem(amount)  {
            daiContract.transfer(msg.sender, amount);
        } catch {
            adaiContract.transfer(msg.sender, amount);
        }
    }

    /**
     * Redeem long tokens for underlying
     */
    function redeemLong(uint256 tokensToRedeem) external refreshSystemState {
        // Burn the tokens to redeem
        longTokens.burnFrom(msg.sender, tokensToRedeem);
        uint256 amountToRedeem = tokensToRedeem.mul(longTokenPrice);
        longValue = longValue.sub(amountToRedeem);

        uint256 fees = 0;
        // Pay fees if you are diluting the position
        if (getShortBeta() < 1) {
            fees = amountToRedeem.mul(8).div(1000);
            _feesMechanism(fees, 100, 0);
        } else {
            fees = amountToRedeem.mul(3).div(1000);
            _feesMechanism(fees, 50, 50);
        }

        amountToRedeem = amountToRedeem.sub(fees);
        _redeem(amountToRedeem);

        // longTokenPrice should remain unchanged
        require(longTokenPrice == longValue.div(longTokens.totalSupply()));
        require(longValue.add(shortValue) == totalValueLocked);
    }

    /**
     * Redeem short tokens for underlying
     */
    function redeemShort(uint256 tokensToRedeem) external refreshSystemState {
        // Burn the tokens to redeem
        shortTokens.burnFrom(msg.sender, tokensToRedeem);
        uint256 amountToRedeem = tokensToRedeem.mul(shortTokenPrice);
        shortValue = shortValue.sub(amountToRedeem);

        uint256 fees = 0;
        // Pay fees if you are diluting the position
        if (getLongBeta() < 1) {
            fees = amountToRedeem.mul(8).div(1000);
            _feesMechanism(fees, 0, 100);
        } else {
            fees = amountToRedeem.mul(3).div(1000);
            _feesMechanism(fees, 50, 50);
        }

        amountToRedeem = amountToRedeem.sub(fees);
        _redeem(amountToRedeem);

        // shortTokenPrice should remain unchanged after redeem (except with fees)
        require(shortTokenPrice == shortValue.div(shortTokens.totalSupply()));
        require(longValue.add(shortValue) == totalValueLocked);
    }
}
