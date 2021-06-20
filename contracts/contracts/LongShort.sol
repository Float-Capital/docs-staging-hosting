// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./interfaces/ITokenFactory.sol";
import "./interfaces/ISyntheticToken.sol";
import "./interfaces/IStaker.sol";
import "./interfaces/ILongShort.sol";
import "./interfaces/IYieldManager.sol";
import "./interfaces/IOracleManager.sol";

/**
 * @dev {LongShort} contract:
 **** visit https://float.capital *****
 *  - Ability for users to create synthetic long and short positions on value movements
 *  - Value movements could be derived from tradional or alternative asset classes, derivates, binary outcomes, etc...
 *  - Incentive mechansim providing fees to liquidity makers (users on both sides of order book)
 */

contract LongShort is ILongShort, Initializable {
    /*╔═════════════════════════════════╗
      ║             VARIABLES           ║
      ╚═════════════════════════════════╝*/

    // Fixed-precision constants ////////////////////////////////
    address public constant DEAD_ADDRESS =
        0xf10A7_F10A7_f10A7_F10a7_F10A7_f10a7_F10A7_f10a7;
    uint256 public constant TEN_TO_THE_18 = 1e18;
    int256 public constant TEN_TO_THE_18_SIGNED = 1e18;
    uint256 public constant feeUnitsOfPrecision = 10000;
    uint256[45] private __constantsGap;

    // Global state ////////////////////////////////////////////
    address public admin;
    address public treasury;
    uint32 public latestMarket;

    IStaker public staker;
    ITokenFactory public tokenFactory;
    uint256[45] private __globalStateGap;

    // Market specific /////////////////////////////////////////
    mapping(uint32 => bool) public marketExists;
    mapping(uint32 => uint256) public assetPrice;
    mapping(uint32 => uint256) public marketUpdateIndex;

    mapping(uint32 => uint256) public totalValueLockedInYieldManager;
    mapping(uint32 => uint256) public totalValueReservedForTreasury;
    mapping(uint32 => IERC20) public fundTokens;
    mapping(uint32 => IYieldManager) public yieldManagers;
    mapping(uint32 => IOracleManager) public oracleManagers;

    mapping(uint32 => uint256) public baseEntryFee;
    mapping(uint32 => uint256) public badLiquidityEntryFee;
    mapping(uint32 => uint256) public baseExitFee;
    mapping(uint32 => uint256) public badLiquidityExitFee;

    // Market + position (long/short) specific /////////////////
    mapping(uint32 => mapping(bool => ISyntheticToken)) public syntheticTokens;
    mapping(uint32 => mapping(bool => uint256)) public syntheticTokenPoolValue;
    mapping(uint32 => mapping(bool => uint256)) public syntheticTokenPrice;

    mapping(uint32 => mapping(bool => mapping(uint256 => uint256)))
        public syntheticTokenPriceSnapshot;
    mapping(uint32 => mapping(bool => mapping(uint256 => uint256)))
        public redeemPriceSnapshot;

    mapping(uint32 => mapping(bool => uint256))
        public batchedAmountOfTokensToDeposit;
    mapping(uint32 => mapping(bool => uint256))
        public batchedAmountOfSynthTokensToRedeem;

    // User specific ///////////////////////////////////////////
    mapping(uint32 => mapping(address => uint256))
        public userCurrentNextPriceUpdateIndex;

    mapping(uint32 => mapping(bool => mapping(address => uint256)))
        public userNextPriceDepositAmount;
    mapping(uint32 => mapping(bool => mapping(address => uint256)))
        public userNextPriceRedemptionAmount;

    /*╔═════════════════════════════════╗
      ║             EVENTS              ║
      ╚═════════════════════════════════╝*/

    event V1(
        address admin,
        address treasury,
        address tokenFactory,
        address staker
    );

    // TODO: make sure this is emmited for batched actions too!
    event ValueLockedInSystem(
        uint32 marketIndex,
        uint256 totalValueLockedInMarket,
        uint256 longValue,
        uint256 shortValue
    );

    event TokenPriceRefreshed(
        uint32 marketIndex,
        uint256 longTokenPrice,
        uint256 shortTokenPrice
    );

    event FeesLevied(uint32 marketIndex, uint256 totalFees);

    event SyntheticTokenCreated(
        uint32 marketIndex,
        address longTokenAddress,
        address shortTokenAddress,
        address fundToken,
        uint256 assetPrice,
        string name,
        string symbol,
        address oracleAddress
    );

    event PriceUpdate(
        uint32 marketIndex,
        uint256 oldPrice,
        uint256 newPrice,
        address user
    );

    event NextPriceRedeem(
        uint32 marketIndex,
        bool isLong,
        uint256 synthRedeemed,
        address user,
        uint256 oracleUpdateIndex
    );

    event BatchedActionsSettled(
        uint32 marketIndex,
        uint256 updateIndex,
        uint256 mintPriceSnapshotLong,
        uint256 mintPriceSnapshotShort,
        uint256 redeemPriceSnapshotLong,
        uint256 redeemPriceSnapshotShort
    );

    event NextPriceDeposit(
        uint32 marketIndex,
        bool isLong,
        uint256 depositAdded,
        address user,
        uint256 oracleUpdateIndex
    );

    event FeesChanges(
        uint32 marketIndex,
        uint256 baseEntryFee,
        uint256 badLiquidityEntryFee,
        uint256 baseExitFee,
        uint256 badLiquidityExitFee
    );

    event OracleUpdated(
        uint32 marketIndex,
        address oldOracleAddress,
        address newOracleAddress
    );

    event NewMarketLaunchedAndSeeded(uint32 marketIndex, uint256 initialSeed);

    event ExecuteNextPriceSettlementsUser(address user, uint32 marketIndex);

    /*╔═════════════════════════════════╗
      ║             MODIFIERS           ║
      ╚═════════════════════════════════╝*/

    /**
     * Necessary to update system state before any contract actions (deposits / withdraws)
     */

    modifier adminOnly() {
        require(msg.sender == admin, "only admin");
        _;
    }

    modifier treasuryOnly() {
        require(msg.sender == treasury, "only treasury");
        _;
    }

    modifier assertMarketExists(uint32 marketIndex) {
        require(marketExists[marketIndex], "market doesn't exist");
        _;
    }

    modifier executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex
    ) virtual {
        _executeOutstandingNextPriceSettlements(user, marketIndex);
        _;
    }

    modifier updateSystemStateMarket(uint32 marketIndex) {
        _updateSystemStateInternal(marketIndex);

        _;
    }

    /*╔═════════════════════════════════╗
      ║       CONTRACT SET-UP           ║
      ╚═════════════════════════════════╝*/

    function initialize(
        address _admin,
        address _treasury,
        ITokenFactory _tokenFactory,
        IStaker _staker
    ) public initializer {
        admin = _admin;
        treasury = _treasury;
        tokenFactory = _tokenFactory;
        staker = _staker;

        emit V1(
            _admin,
            address(treasury),
            address(_tokenFactory),
            address(_staker)
        );
    }

    /*╔═════════════════════════════════╗
      ║       MULTI-SIG ADMIN           ║
      ╚═════════════════════════════════╝*/

    function changeAdmin(address _admin) external adminOnly {
        admin = _admin;
    }

    function changeTreasury(address _treasury) external adminOnly {
        treasury = _treasury;
    }

    function changeFees(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee
    ) external adminOnly {
        _changeFees(
            marketIndex,
            _baseEntryFee,
            _baseExitFee,
            _badLiquidityEntryFee,
            _badLiquidityExitFee
        );
    }

    function _changeFees(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityEntryFee,
        uint256 _badLiquidityExitFee
    ) internal {
        baseEntryFee[marketIndex] = _baseEntryFee;
        baseExitFee[marketIndex] = _baseExitFee;
        badLiquidityEntryFee[marketIndex] = _badLiquidityEntryFee;
        badLiquidityExitFee[marketIndex] = _badLiquidityExitFee;

        emit FeesChanges(
            latestMarket,
            _baseEntryFee,
            _badLiquidityEntryFee,
            _baseExitFee,
            _badLiquidityExitFee
        );
    }

    /**
     * Update oracle for a market
     */
    function updateMarketOracle(uint32 marketIndex, address _newOracleManager)
        external
        adminOnly
    {
        // If not a oracle contract this would break things.. Test's arn't validating this
        // Ie require isOracle interface - ERC165
        address previousOracleManager = address(oracleManagers[marketIndex]);
        oracleManagers[marketIndex] = IOracleManager(_newOracleManager);
        emit OracleUpdated(
            marketIndex,
            previousOracleManager,
            _newOracleManager
        );
    }

    /*╔═════════════════════════════════╗
      ║       MARKET CREATION           ║
      ╚═════════════════════════════════╝*/

    /**
     * Creates an entirely new long/short market tracking an underlying
     * oracle price. Make sure the synthetic names/symbols are unique.
     */
    function newSyntheticMarket(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address _fundToken,
        address _oracleManager,
        address _yieldManager
    ) external adminOnly {
        latestMarket++;

        // Create new synthetic long token.
        syntheticTokens[latestMarket][
            true /*long*/
        ] = ISyntheticToken(
            tokenFactory.createTokenLong(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

        // Create new synthetic short token.
        syntheticTokens[latestMarket][
            false /*short*/
        ] = ISyntheticToken(
            tokenFactory.createTokenShort(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

        // Initial market state.
        syntheticTokenPrice[latestMarket][
            true /*long*/
        ] = TEN_TO_THE_18;
        syntheticTokenPrice[latestMarket][
            false /*short*/
        ] = TEN_TO_THE_18;
        fundTokens[latestMarket] = IERC20(_fundToken);
        yieldManagers[latestMarket] = IYieldManager(_yieldManager);
        oracleManagers[latestMarket] = IOracleManager(_oracleManager);
        assetPrice[latestMarket] = uint256(
            oracleManagers[latestMarket].updatePrice()
        );

        emit SyntheticTokenCreated(
            latestMarket,
            address(
                syntheticTokens[latestMarket][
                    true /*long*/
                ]
            ),
            address(
                syntheticTokens[latestMarket][
                    false /*short*/
                ]
            ),
            _fundToken,
            assetPrice[latestMarket],
            syntheticName,
            syntheticSymbol,
            _oracleManager
        );
    }

    function _seedMarketInitially(uint256 initialMarketSeed, uint32 marketIndex)
        internal
    {
        require(
            // You require at least 10^17 of the underlying payment token to seed the market.
            initialMarketSeed > 0.1 ether,
            "Insufficient value to seed the market"
        );

        _lockFundsInMarket(marketIndex, initialMarketSeed * 2);

        syntheticTokens[latestMarket][
            true /*long*/
        ]
            .mint(DEAD_ADDRESS, initialMarketSeed);
        syntheticTokens[latestMarket][
            false /*short*/
        ]
            .mint(DEAD_ADDRESS, initialMarketSeed);

        syntheticTokenPoolValue[marketIndex][
            true /*long*/
        ] = initialMarketSeed;
        syntheticTokenPoolValue[marketIndex][
            false /*short*/
        ] = initialMarketSeed;

        emit NewMarketLaunchedAndSeeded(marketIndex, initialMarketSeed);
    }

    function initializeMarket(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee,
        uint256 kInitialMultiplier,
        uint256 kPeriod,
        uint256 initialMarketSeed
    ) external adminOnly {
        require(!marketExists[marketIndex] && marketIndex <= latestMarket);

        marketExists[marketIndex] = true;

        _changeFees(
            marketIndex,
            _baseEntryFee,
            _baseExitFee,
            _badLiquidityEntryFee,
            _badLiquidityExitFee
        );

        // Add new staker funds with fresh synthetic tokens.
        staker.addNewStakingFund(
            latestMarket,
            syntheticTokens[latestMarket][
                true /*long*/
            ],
            syntheticTokens[latestMarket][
                false /*short*/
            ],
            kInitialMultiplier,
            kPeriod
        );

        _seedMarketInitially(initialMarketSeed, marketIndex);
    }

    /*╔═════════════════════════════════╗
      ║       GETTER FUNCTIONS          ║
      ╚═════════════════════════════════╝*/

    function _getPrice(uint256 amountSynth, uint256 amountPaymentToken)
        internal
        pure
        returns (uint256)
    {
        return (amountPaymentToken * TEN_TO_THE_18) / amountSynth;
    }

    function _getAmountPaymentToken(uint256 amountSynth, uint256 price)
        internal
        pure
        returns (uint256)
    {
        return (amountSynth * price) / TEN_TO_THE_18;
    }

    function _getAmountSynthToken(uint256 amountPaymentToken, uint256 price)
        internal
        pure
        returns (uint256)
    {
        return (amountPaymentToken * TEN_TO_THE_18) / price;
    }

    function getUsersPendingBalance(
        address user,
        uint32 marketIndex,
        bool isLong
    )
        external
        view
        override
        assertMarketExists(marketIndex)
        returns (uint256 pendingBalance)
    {
        if (
            userCurrentNextPriceUpdateIndex[marketIndex][user] != 0 &&
            userCurrentNextPriceUpdateIndex[marketIndex][user] <=
            marketUpdateIndex[marketIndex]
        ) {
            // Update is still nextPrice but not past the next oracle update - display the amount the user would get if they executed immediately
            uint256 amountPaymentTokenDeposited =
                userNextPriceDepositAmount[marketIndex][isLong][user];

            uint256 tokens =
                _getAmountSynthToken(
                    amountPaymentTokenDeposited,
                    syntheticTokenPrice[marketIndex][isLong]
                );

            return tokens;
        } else {
            return 0;
        }
    }

    /**
     * Returns the amount of accrued value that should go to the market,
     * and the amount that should be locked into the treasury. To incentivise
     * market balance, more value goes to the market in proportion to how
     * imbalanced it is.
     */
    function getTreasurySplit(uint32 marketIndex, uint256 amount)
        public
        view
        returns (uint256 marketAmount, uint256 treasuryAmount)
    {
        uint256 marketPcnt; // fixed-precision scale of 10000

        uint256 totalValueLockedInMarket =
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ] +
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ];

        if (
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ] >
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ]
        ) {
            marketPcnt =
                ((syntheticTokenPoolValue[marketIndex][
                    true /*long*/
                ] -
                    syntheticTokenPoolValue[marketIndex][
                        false /*short*/
                    ]) * 10000) /
                totalValueLockedInMarket;
        } else {
            marketPcnt =
                ((syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ] -
                    syntheticTokenPoolValue[marketIndex][
                        true /*long*/
                    ]) * 10000) /
                totalValueLockedInMarket;
        }

        marketAmount = (marketPcnt * amount) / 10000;
        treasuryAmount = amount - marketAmount;
        require(amount == marketAmount + treasuryAmount);

        return (marketAmount, treasuryAmount);
    }

    /**
     * Returns the amount of accrued value that should go to each side of the
     * market. To incentivise balance, more value goes to the weaker side in
     * proportion to how imbalanced the market is.
     */
    function getMarketSplit(uint32 marketIndex, uint256 amount)
        public
        view
        returns (uint256 longAmount, uint256 shortAmount)
    {
        // The percentage value that a position receives depends on the amount
        // of total market value taken up by the _opposite_ position.
        uint256 longPcnt =
            (syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ] * 10000) /
                (syntheticTokenPoolValue[marketIndex][
                    true /*long*/
                ] +
                    syntheticTokenPoolValue[marketIndex][
                        false /*short*/
                    ]);

        longAmount = (amount * longPcnt) / 10000;
        shortAmount = amount - longAmount;
        return (longAmount, shortAmount);
    }

    /**
     * Calculates fees for the given mint/redeem amount. Users are penalised
     * with higher fees for imbalancing the market.
     */
    // TODO STENT look at this again
    // TODO: this function was written with immediate price in mind, rework this function to suit latest code
    function getFeesGeneral(
        uint32 marketIndex,
        uint256 delta, // 1e18
        bool synthTokenGainingDominanceIsLong,
        uint256 baseFeePercent,
        uint256 penaltyFeePercent
    ) public view returns (uint256) {
        uint256 baseFee = (delta * baseFeePercent) / feeUnitsOfPrecision;

        if (
            syntheticTokenPoolValue[marketIndex][
                synthTokenGainingDominanceIsLong
            ] >=
            syntheticTokenPoolValue[marketIndex][
                !synthTokenGainingDominanceIsLong
            ]
        ) {
            // All funds are causing imbalance
            return
                baseFee + ((delta * penaltyFeePercent) / feeUnitsOfPrecision);
        } else if (
            syntheticTokenPoolValue[marketIndex][
                synthTokenGainingDominanceIsLong
            ] +
                delta >
            syntheticTokenPoolValue[marketIndex][
                !synthTokenGainingDominanceIsLong
            ]
        ) {
            uint256 amountImbalancing =
                delta -
                    (syntheticTokenPoolValue[marketIndex][
                        !synthTokenGainingDominanceIsLong
                    ] -
                        syntheticTokenPoolValue[marketIndex][
                            synthTokenGainingDominanceIsLong
                        ]);
            uint256 penaltyFee =
                (amountImbalancing * penaltyFeePercent) / feeUnitsOfPrecision;

            return baseFee + penaltyFee;
        } else {
            return baseFee;
        }
    }

    /*╔═════════════════════════════════╗
      ║       HELPER FUNCTIONS          ║
      ╚═════════════════════════════════╝*/

    /**
     * Adjusts the long/short token prices according to supply and value.
     */
    function _refreshTokenPrices(uint32 marketIndex) internal {
        uint256 longTokenSupply =
            syntheticTokens[marketIndex][
                true /*long*/
            ]
                .totalSupply();

        // supply should never be zero and burn address will always own a small amount
        if (longTokenSupply > 0) {
            syntheticTokenPrice[marketIndex][
                true /*long*/
            ] = _getPrice(
                longTokenSupply,
                syntheticTokenPoolValue[marketIndex][
                    true /*long*/
                ]
            );
        }

        uint256 shortTokenSupply =
            syntheticTokens[marketIndex][
                false /*short*/
            ]
                .totalSupply();
        if (shortTokenSupply > 0) {
            syntheticTokenPrice[marketIndex][
                false /*short*/
            ] = _getPrice(
                shortTokenSupply,
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ]
            );
        }

        emit TokenPriceRefreshed(
            marketIndex,
            syntheticTokenPrice[marketIndex][
                true /*long*/
            ],
            syntheticTokenPrice[marketIndex][
                false /*short*/
            ]
        );
    }

    function _distributeMarketAmount(uint32 marketIndex, uint256 marketAmount)
        internal
    {
        // Splits mostly to the weaker position to incentivise balance.
        (uint256 longAmount, uint256 shortAmount) =
            getMarketSplit(marketIndex, marketAmount);
        syntheticTokenPoolValue[marketIndex][
            true /*long*/
        ] += longAmount;
        syntheticTokenPoolValue[marketIndex][
            false /*short*/
        ] += shortAmount;
    }

    /**
     * Controls what happens with accrued yield manager interest.
     */
    function _claimAndDistributeYield(uint32 marketIndex) internal {
        uint256 amount =
            yieldManagers[marketIndex].getTotalHeld() -
                totalValueLockedInYieldManager[marketIndex];

        if (amount > 0) {
            (uint256 marketAmount, uint256 treasuryAmount) =
                getTreasurySplit(marketIndex, amount);

            // We keep the interest locked in the yield manager, but update our
            // bookkeeping to logically simulate moving the funds around.
            totalValueLockedInYieldManager[marketIndex] += amount;
            totalValueReservedForTreasury[marketIndex] += treasuryAmount;

            _distributeMarketAmount(marketIndex, marketAmount);
        }
    }

    function _adjustMarketBasedOnNewAssetPrice(
        uint32 marketIndex,
        int256 newAssetPrice
    ) internal {
        int256 oldAssetPrice = int256(assetPrice[marketIndex]);

        uint256 min;
        if (
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ] <
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ]
        ) {
            min = syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ];
        } else {
            min = syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ];
        }

        int256 percentageChangeE18 =
            ((newAssetPrice - oldAssetPrice) * TEN_TO_THE_18_SIGNED) /
                oldAssetPrice;

        int256 valueChange =
            (percentageChangeE18 * int256(min)) / TEN_TO_THE_18_SIGNED;

        if (valueChange > 0) {
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ] += uint256(valueChange);
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ] -= uint256(valueChange);
        } else {
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ] -= uint256(valueChange * -1);
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ] += uint256(valueChange * -1);
        }

        emit PriceUpdate(
            marketIndex,
            assetPrice[marketIndex],
            uint256(newAssetPrice),
            msg.sender
        );
    }

    function _saveSyntheticTokenPriceSnapshots(
        uint32 marketIndex,
        uint256 newLatestPriceStateIndex
    ) internal {
        syntheticTokenPriceSnapshot[marketIndex][
            true /*long*/
        ][newLatestPriceStateIndex] = syntheticTokenPrice[marketIndex][
            true /*long*/
        ];
        syntheticTokenPriceSnapshot[marketIndex][
            false /*short*/
        ][newLatestPriceStateIndex] = syntheticTokenPrice[marketIndex][
            false /*short*/
        ];
    }

    /*╔═════════════════════════════════╗
      ║     UPDATING SYSTEM STATE       ║
      ╚═════════════════════════════════╝*/

    /**
     * Updates the value of the long and short sides within the system
     * Note this is public. Anyone can call this function.
     */
    function _updateSystemStateInternal(uint32 marketIndex)
        internal
        assertMarketExists(marketIndex)
    {
        // This is called right before any state change!
        // So reward rate can be calculated just in time by
        // staker without needing to be saved
        staker.addNewStateForFloatRewards(
            marketIndex,
            syntheticTokenPrice[marketIndex][
                true /*long*/
            ],
            syntheticTokenPrice[marketIndex][
                false /*short*/
            ],
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ],
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ]
        );

        // If a negative int is return this should fail.
        int256 newAssetPrice = oracleManagers[marketIndex].updatePrice();
        int256 oldAssetPrice = int256(assetPrice[marketIndex]);

        if (oldAssetPrice == newAssetPrice) {
            return;
        }

        _claimAndDistributeYield(marketIndex);

        _adjustMarketBasedOnNewAssetPrice(marketIndex, newAssetPrice);

        assert(
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ] !=
                0 &&
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ] !=
                0
        );

        _refreshTokenPrices(marketIndex);
        assetPrice[marketIndex] = uint256(newAssetPrice);

        uint256 newLatestPriceStateIndex = marketUpdateIndex[marketIndex] + 1;
        marketUpdateIndex[marketIndex] = newLatestPriceStateIndex;
        _saveSyntheticTokenPriceSnapshots(
            marketIndex,
            newLatestPriceStateIndex
        );

        if (
            _handleBatchedDepositSettlement(
                marketIndex,
                true /*long*/
            ) ||
            _handleBatchedDepositSettlement(
                marketIndex,
                false /*short*/
            ) ||
            _handleBatchedNextPriceRedeems(marketIndex)
        ) {
            emit BatchedActionsSettled(
                marketIndex,
                newLatestPriceStateIndex,
                syntheticTokenPriceSnapshot[marketIndex][
                    true /*long*/
                ][newLatestPriceStateIndex],
                syntheticTokenPriceSnapshot[marketIndex][
                    false /*short*/
                ][newLatestPriceStateIndex],
                redeemPriceSnapshot[marketIndex][
                    true /*long*/
                ][newLatestPriceStateIndex],
                redeemPriceSnapshot[marketIndex][
                    false /*short*/
                ][newLatestPriceStateIndex]
            );
        }

        emit ValueLockedInSystem(
            marketIndex,
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ] +
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ],
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ],
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ]
        );
    }

    function _updateSystemState(uint32 marketIndex) external override {
        _updateSystemStateInternal(marketIndex);
    }

    function _updateSystemStateMulti(uint32[] calldata marketIndexes)
        external
        override
    {
        for (uint256 i = 0; i < marketIndexes.length; i++) {
            _updateSystemStateInternal(marketIndexes[i]);
        }
    }

    /*╔═════════════════════════════════╗
      ║       DEPOSIT + WITHDRAWL       ║
      ╚═════════════════════════════════╝*/

    function _depositFunds(uint32 marketIndex, uint256 amount) internal {
        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);
    }

    // NOTE: Only used in seeding the market.
    function _lockFundsInMarket(uint32 marketIndex, uint256 amount) internal {
        _depositFunds(marketIndex, amount);
        _transferFundsToYieldManager(marketIndex, amount);
    }

    /*
     * Returns locked funds from the market to the sender.
     */
    function _withdrawFunds(
        uint32 marketIndex,
        uint256 amountLong,
        uint256 amountShort,
        address user
    ) internal {
        uint256 totalAmount = amountLong + amountShort;

        if (totalAmount == 0) {
            return;
        }

        assert(
            syntheticTokenPoolValue[marketIndex][
                true /*long*/
            ] >=
                amountLong &&
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ] >=
                amountShort
        );

        _transferFromYieldManager(marketIndex, totalAmount);

        // Transfer funds to the sender.
        fundTokens[marketIndex].transfer(user, totalAmount);

        syntheticTokenPoolValue[marketIndex][
            true /*long*/
        ] -= amountLong;
        syntheticTokenPoolValue[marketIndex][
            false /*short*/
        ] -= amountShort;
    }

    /*╔═════════════════════════════════╗
      ║      TRESURY + YIELD MANAGER    ║
      ╚═════════════════════════════════╝*/

    /*
     * Transfers locked funds from LongShort into the yield manager.
     */
    // TODO STENT this is only called in one place, might as well move this code there
    function _transferFundsToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        // TODO STENT note there are 2 approvals & 2 transfers here:
        //     1. approve transfer from this contract to yield manager contract
        //     2. transfer from this contract to yield manager contract
        //     3. approve transfer from yield manager contract to lendingPool contract
        //     4. transfer from yield mnager contract to lendingPool contract
        // Surely we can mak this more efficient?
        fundTokens[marketIndex].approve(
            address(yieldManagers[marketIndex]),
            amount
        );
        yieldManagers[marketIndex].depositToken(amount);

        // Update market state.
        totalValueLockedInYieldManager[marketIndex] += amount;
    }

    /*
     * Transfers locked funds from the yield manager into LongShort.
     */
    function _transferFromYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        require(totalValueLockedInYieldManager[marketIndex] >= amount);

        // NB there will be issues here if not enough liquidity exists to withdraw
        // Boolean should be returned from yield manager and think how to appropriately handle this
        yieldManagers[marketIndex].withdrawToken(amount);

        // Update market state.
        // TODO STENT why is this amount stored in this cotract? Seems like it should be stored inyield manager contract
        totalValueLockedInYieldManager[marketIndex] -= amount;

        // Invariant: yield managers should never have more locked funds
        // than the combined value of the market and held treasury funds.
        // TODO STENT this check seems wierd. What happens if this fails? What is the recovery? Should it be an assert?
        require(
            totalValueLockedInYieldManager[marketIndex] <=
                syntheticTokenPoolValue[marketIndex][
                    true /*long*/
                ] +
                    syntheticTokenPoolValue[marketIndex][
                        false /*short*/
                    ] +
                    totalValueReservedForTreasury[marketIndex]
        );
    }

    /*
     * Transfers the reserved treasury funds to the treasury contract. This is
     * done async to avoid putting transfer gas costs on users every time they o
     * pay fees or accrue yield.
     *
     * NOTE: doesn't affect markets, so no state refresh necessary
     */
    function transferTreasuryFunds(uint32 marketIndex) external treasuryOnly {
        uint256 totalForTreasury = totalValueReservedForTreasury[marketIndex];

        // Update global state.
        totalValueReservedForTreasury[marketIndex] = 0;

        // Edge-case: no funds to transfer.
        if (totalForTreasury == 0) {
            return;
        }

        // TODO STENT why is this called? totalForTreasury gets value from fees and interest from the yield manager. Why are we then removing that value from the yiled manager?
        _transferFromYieldManager(marketIndex, totalForTreasury);

        // Transfer funds to the treasury.
        fundTokens[marketIndex].transfer(treasury, totalForTreasury);
    }

    /*╔═════════════════════════════════╗
      ║       MINT POSITION             ║
      ╚═════════════════════════════════╝*/

    function _mintNextPrice(
        uint32 marketIndex,
        uint256 amount,
        bool isLong
    )
        internal
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
        _depositFunds(marketIndex, amount);

        batchedAmountOfTokensToDeposit[marketIndex][isLong] += amount;
        userNextPriceDepositAmount[marketIndex][isLong][msg.sender] += amount;
        userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] =
            marketUpdateIndex[marketIndex] +
            1;

        emit NextPriceDeposit(
            marketIndex,
            isLong,
            amount,
            msg.sender,
            marketUpdateIndex[marketIndex] + 1
        );
    }

    function mintLongNextPrice(uint32 marketIndex, uint256 amount) external {
        _mintNextPrice(
            marketIndex,
            amount,
            true /*long*/
        );
    }

    function mintShortNextPrice(uint32 marketIndex, uint256 amount) external {
        _mintNextPrice(
            marketIndex,
            amount,
            false /*short*/
        );
    }

    /*╔═════════════════════════════════╗
      ║       REDEEM POSITION           ║
      ╚═════════════════════════════════╝*/

    function _redeemNextPrice(
        uint32 marketIndex,
        uint256 tokensToRedeem,
        bool isLong
    )
        internal
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
        syntheticTokens[marketIndex][isLong].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );

        userNextPriceRedemptionAmount[marketIndex][isLong][
            msg.sender
        ] += tokensToRedeem;
        userCurrentNextPriceUpdateIndex[marketIndex][msg.sender] =
            marketUpdateIndex[marketIndex] +
            1;

        batchedAmountOfSynthTokensToRedeem[marketIndex][
            isLong
        ] += tokensToRedeem;

        emit NextPriceRedeem(
            marketIndex,
            isLong,
            tokensToRedeem,
            msg.sender,
            marketUpdateIndex[marketIndex] + 1
        );
    }

    function redeemLongNextPrice(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
        _redeemNextPrice(
            marketIndex,
            tokensToRedeem,
            true /*long*/
        );
    }

    function redeemShortNextPrice(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
        _redeemNextPrice(
            marketIndex,
            tokensToRedeem,
            false /*short*/
        );
    }

    /*╔═════════════════════════════════╗
      ║       NEXT PRICE SETTLEMENTS    ║
      ╚═════════════════════════════════╝*/

    function _executeNextPriceMintsIfTheyExist(
        uint32 marketIndex,
        address user,
        bool isLong
    ) internal {
        uint256 currentDepositAmount =
            userNextPriceDepositAmount[marketIndex][isLong][user];
        if (currentDepositAmount > 0) {
            uint256 tokensToTransferToUser =
                _getAmountSynthToken(
                    currentDepositAmount,
                    syntheticTokenPriceSnapshot[marketIndex][isLong][
                        userCurrentNextPriceUpdateIndex[marketIndex][user]
                    ]
                );

            syntheticTokens[marketIndex][isLong].transfer(
                user,
                tokensToTransferToUser
            );

            userNextPriceDepositAmount[marketIndex][isLong][user] = 0;
        }
    }

    function _executeOutstandingNextPriceRedeems(
        uint32 marketIndex,
        address user,
        bool isLong
    ) internal {
        uint256 currentRedemptions =
            userNextPriceRedemptionAmount[marketIndex][isLong][user];
        if (currentRedemptions > 0) {
            uint256 amountToRedeem =
                _getAmountPaymentToken(
                    currentRedemptions,
                    redeemPriceSnapshot[marketIndex][isLong][
                        userCurrentNextPriceUpdateIndex[marketIndex][user]
                    ]
                );

            fundTokens[marketIndex].transfer(user, amountToRedeem);
            userNextPriceRedemptionAmount[marketIndex][isLong][user] = 0;
        }
    }

    // TODO: WARNING!! This function is re-entrancy vulnerable if the synthetic token has any execution hooks
    function _executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex
    ) internal {
        uint256 currentUpdateIndex =
            userCurrentNextPriceUpdateIndex[marketIndex][user];
        if (
            currentUpdateIndex != 0 &&
            currentUpdateIndex <= marketUpdateIndex[marketIndex]
        ) {
            _executeNextPriceMintsIfTheyExist(
                marketIndex,
                user,
                true /*long*/
            );
            _executeNextPriceMintsIfTheyExist(
                marketIndex,
                user,
                false /*short*/
            );
            _executeOutstandingNextPriceRedeems(
                marketIndex,
                user,
                true /*long*/
            );
            _executeOutstandingNextPriceRedeems(
                marketIndex,
                user,
                false /*short*/
            );

            userCurrentNextPriceUpdateIndex[marketIndex][user] = 0;

            emit ExecuteNextPriceSettlementsUser(user, marketIndex);
        }
    }

    function executeOutstandingNextPriceSettlementsUser(
        address user,
        uint32 marketIndex
    ) external override {
        // NOTE: this does all the "nextPrice" actions. This could be simplified to only do the relevant nextPrice action.
        _executeOutstandingNextPriceSettlements(user, marketIndex);
    }

    /*╔═════════════════════════════════╗
      ║       NEXT PRICE ORDERS         ║
      ╚═════════════════════════════════╝*/

    function _handleBatchedDepositSettlement(uint32 marketIndex, bool isLong)
        internal
        returns (bool wasABatchedSettlement)
    {
        uint256 amountToBatchDeposit =
            batchedAmountOfTokensToDeposit[marketIndex][isLong];

        if (amountToBatchDeposit > 0) {
            batchedAmountOfTokensToDeposit[marketIndex][isLong] = 0;
            _transferFundsToYieldManager(marketIndex, amountToBatchDeposit);

            uint256 numberOfTokens =
                _getAmountSynthToken(
                    amountToBatchDeposit,
                    syntheticTokenPrice[marketIndex][isLong]
                );

            // TODO STENT there are no token mint events emitted here, but there are on market initialization
            syntheticTokens[marketIndex][isLong].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenPoolValue[marketIndex][
                isLong
            ] += amountToBatchDeposit;

            //TODO: Can remove these sanity checks at some point
            uint256 oldTokenLongPrice =
                syntheticTokenPrice[marketIndex][
                    true /*long*/
                ];
            uint256 oldTokenShortPrice =
                syntheticTokenPrice[marketIndex][
                    false /*short*/
                ];

            _refreshTokenPrices(marketIndex);

            assert(
                syntheticTokenPrice[marketIndex][
                    true /*long*/
                ] == oldTokenLongPrice
            );
            assert(
                syntheticTokenPrice[marketIndex][
                    false /*short*/
                ] == oldTokenShortPrice
            );
            wasABatchedSettlement = true;
        }
    }

    function _burnSynthTokensForRedemption(
        uint32 marketIndex,
        uint256 amountSynthToRedeemLong,
        uint256 amountSynthToRedeemShort
    ) internal returns (bool wasABatchedSettlement) {
        if (amountSynthToRedeemLong > 0) {
            syntheticTokens[marketIndex][
                true /*long*/
            ]
                .synthRedeemBurn(address(this), amountSynthToRedeemLong);
            wasABatchedSettlement = true;
        }

        if (amountSynthToRedeemShort > 0) {
            syntheticTokens[marketIndex][
                false /*short*/
            ]
                .synthRedeemBurn(address(this), amountSynthToRedeemShort);
            wasABatchedSettlement = true;
        }
    }

    function _applyBatchedNextPriceFees(
        uint32 marketIndex,
        uint256 amountOfPaymentTokenToRedeem,
        uint256 shortAmountOfPaymentTokenToRedeem
    ) internal returns (uint256 totalFeesLong, uint256 totalFeesShort) {
        // penalty fee is shared equally between
        // all users on the side that ends up causing an imbalance in the
        // batch.
        if (amountOfPaymentTokenToRedeem > shortAmountOfPaymentTokenToRedeem) {
            uint256 delta =
                amountOfPaymentTokenToRedeem -
                    shortAmountOfPaymentTokenToRedeem;
            totalFeesLong = getFeesGeneral(
                marketIndex,
                delta,
                false, /*short*/
                0,
                badLiquidityExitFee[marketIndex]
            );
        } else {
            uint256 delta =
                shortAmountOfPaymentTokenToRedeem -
                    amountOfPaymentTokenToRedeem;
            totalFeesShort = getFeesGeneral(
                marketIndex,
                delta,
                true, /*long*/
                0,
                badLiquidityExitFee[marketIndex]
            );
        }

        uint256 totalFees = totalFeesLong + totalFeesShort;
        (uint256 marketAmount, uint256 treasuryAmount) =
            getTreasurySplit(marketIndex, totalFees);

        totalValueReservedForTreasury[marketIndex] += treasuryAmount;

        _distributeMarketAmount(marketIndex, marketAmount);
        emit FeesLevied(marketIndex, totalFees);
    }

    function _calculateRedeemPriceSnapshot(
        uint32 marketIndex,
        uint256 amountOfPaymentTokenToRedeem,
        bool isLong
    ) internal returns (uint256 batchLongTotalWithdrawnPaymentToken) {
        if (amountOfPaymentTokenToRedeem > 0) {
            redeemPriceSnapshot[marketIndex][isLong][
                marketUpdateIndex[marketIndex]
            ] = _getPrice(
                batchedAmountOfSynthTokensToRedeem[marketIndex][isLong],
                amountOfPaymentTokenToRedeem
            );

            // NOTE: this is always slightly less than `amountOfPaymentTokenToRedeem` due to rounding errors
            return
                _getAmountPaymentToken(
                    batchedAmountOfSynthTokensToRedeem[marketIndex][isLong],
                    redeemPriceSnapshot[marketIndex][isLong][
                        marketUpdateIndex[marketIndex]
                    ]
                );
        }
    }

    function _handleBatchedNextPriceRedeems(uint32 marketIndex)
        internal
        returns (bool wasABatchedSettlement)
    {
        uint256 batchedAmountOfSynthTokensToRedeemLong =
            batchedAmountOfSynthTokensToRedeem[marketIndex][
                true /*long*/
            ];
        uint256 batchedAmountOfSynthTokensToRedeemShort =
            batchedAmountOfSynthTokensToRedeem[marketIndex][
                false /*short*/
            ];

        wasABatchedSettlement = _burnSynthTokensForRedemption(
            marketIndex,
            batchedAmountOfSynthTokensToRedeemLong,
            batchedAmountOfSynthTokensToRedeemShort
        );

        uint256 longAmountOfPaymentTokenToRedeem =
            _getAmountPaymentToken(
                batchedAmountOfSynthTokensToRedeemLong,
                syntheticTokenPrice[marketIndex][
                    true /*long*/
                ]
            );
        uint256 shortAmountOfPaymentTokenToRedeem =
            _getAmountPaymentToken(
                batchedAmountOfSynthTokensToRedeemShort,
                syntheticTokenPrice[marketIndex][
                    false /*short*/
                ]
            );

        (uint256 totalFeesLong, uint256 totalFeesShort) =
            _applyBatchedNextPriceFees(
                marketIndex,
                longAmountOfPaymentTokenToRedeem,
                shortAmountOfPaymentTokenToRedeem
            );

        uint256 batchShortTotalWithdrawnPaymentToken =
            _calculateRedeemPriceSnapshot(
                marketIndex,
                shortAmountOfPaymentTokenToRedeem - totalFeesShort,
                false /*short*/
            );
        uint256 batchLongTotalWithdrawnPaymentToken =
            _calculateRedeemPriceSnapshot(
                marketIndex,
                longAmountOfPaymentTokenToRedeem - totalFeesLong,
                true /*long*/
            );

        _withdrawFunds(
            marketIndex,
            batchLongTotalWithdrawnPaymentToken,
            batchShortTotalWithdrawnPaymentToken,
            address(this)
        );

        _refreshTokenPrices(marketIndex);

        batchedAmountOfSynthTokensToRedeem[marketIndex][
            true /*long*/
        ] = 0;
        batchedAmountOfSynthTokensToRedeem[marketIndex][
            false /*short*/
        ] = 0;
    }
}
