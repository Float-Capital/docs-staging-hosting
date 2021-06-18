// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.3;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../../interfaces/ITokenFactory.sol";
import "../../interfaces/ISyntheticToken.sol";
import "../../interfaces/IStaker.sol";
import "../../interfaces/ILongShort.sol";
import "../../interfaces/IYieldManager.sol";
import "../../interfaces/IOracleManager.sol";

import "./LongShortForInternalMocking.sol";

contract LongShortMockable is ILongShort, Initializable {
    LongShortForInternalMocking mocker;
    bool shouldUseMock;
    string functionToNotMock;

    function setMocker(LongShortForInternalMocking _mocker) external {
        mocker = _mocker;
        shouldUseMock = true;
    }

    function setFunctionToNotMock(string calldata _functionToNotMock) external {
        functionToNotMock = _functionToNotMock;
    }

    address public constant DEAD_ADDRESS =
        0xf10A7_F10A7_f10A7_F10a7_F10A7_f10a7_F10A7_f10a7;
    uint256 public constant TEN_TO_THE_18 = 1e18;
    int256 public constant TEN_TO_THE_18_SIGNED = 1e18;
    uint256 public constant feeUnitsOfPrecision = 10000;
    uint256[45] private __constantsGap;

    address public admin;
    address public treasury;
    uint32 public latestMarket;

    IStaker public staker;
    ITokenFactory public tokenFactory;
    uint256[45] private __globalStateGap;

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

    mapping(uint32 => mapping(bool => ISyntheticToken)) public syntheticTokens;
    mapping(uint32 => mapping(bool => uint256)) public syntheticTokenPoolValue;
    mapping(uint32 => mapping(bool => uint256)) public syntheticTokenPrice;

    mapping(uint32 => mapping(bool => mapping(uint256 => uint256)))
        public mintPriceSnapshot;
    mapping(uint32 => mapping(bool => mapping(uint256 => uint256)))
        public redeemPriceSnapshot;

    mapping(uint32 => mapping(bool => uint256))
        public batchedNextPriceDepositAmount;
    mapping(uint32 => mapping(bool => uint256))
        public batchedNextPriceSynthRedeemAmount;

    mapping(uint32 => mapping(address => uint256))
        public userCurrentNextPriceUpdateIndex;

    mapping(uint32 => mapping(bool => mapping(address => uint256)))
        public userNextPriceDepositAmount;
    mapping(uint32 => mapping(bool => mapping(address => uint256)))
        public userNextPriceRedemptionAmount;

    event V1(
        address admin,
        address treasury,
        address tokenFactory,
        address staker
    );

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

    modifier adminOnly() {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("adminOnly"))
        ) {
            mocker.adminOnlyMock();
            _;
        } else {
            require(msg.sender == admin, "only admin");
            _;
        }
    }

    modifier treasuryOnly() {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("treasuryOnly"))
        ) {
            mocker.treasuryOnlyMock();
            _;
        } else {
            require(msg.sender == treasury, "only treasury");
            _;
        }
    }

    modifier assertMarketExists(uint32 marketIndex) {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("assertMarketExists"))
        ) {
            mocker.assertMarketExistsMock(marketIndex);
            _;
        } else {
            require(marketExists[marketIndex], "market doesn't exist");
            _;
        }
    }

    modifier isCorrectSynth(
        uint32 marketIndex,
        bool isLong,
        ISyntheticToken syntheticToken
    ) {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("isCorrectSynth"))
        ) {
            mocker.isCorrectSynthMock(marketIndex, isLong, syntheticToken);
            _;
        } else {
            if (
                isLong == true /*long*/
            ) {
                require(
                    syntheticTokens[marketIndex][
                        true /*short*/
                    ] == syntheticToken,
                    "Incorrect synthetic token"
                );
            } else {
                require(
                    syntheticTokens[marketIndex][
                        false /*short*/
                    ] == syntheticToken,
                    "Incorrect synthetic token"
                );
            }
            _;
        }
    }

    modifier executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex
    ) virtual {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(
                abi.encodePacked("executeOutstandingNextPriceSettlements")
            )
        ) {
            mocker.executeOutstandingNextPriceSettlementsMock(
                user,
                marketIndex
            );
            _;
        } else {
            _executeOutstandingNextPriceSettlements(user, marketIndex);

            _;
        }
    }

    modifier updateSystemStateMarket(uint32 marketIndex) {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("updateSystemStateMarket"))
        ) {
            mocker.updateSystemStateMarketMock(marketIndex);
            _;
        } else {
            _updateSystemStateInternal(marketIndex);

            _;
        }
    }

    function initialize(
        address _admin,
        address _treasury,
        ITokenFactory _tokenFactory,
        IStaker _staker
    ) public initializer {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("initialize"))
        ) {
            return
                mocker.initializeMock(
                    _admin,
                    _treasury,
                    _tokenFactory,
                    _staker
                );
        }

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

    function changeAdmin(address _admin) external adminOnly {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("changeAdmin"))
        ) {
            return mocker.changeAdminMock(_admin);
        }

        admin = _admin;
    }

    function changeTreasury(address _treasury) external adminOnly {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("changeTreasury"))
        ) {
            return mocker.changeTreasuryMock(_treasury);
        }

        treasury = _treasury;
    }

    function changeFees(
        uint32 marketIndex,
        uint256 _baseEntryFee,
        uint256 _badLiquidityEntryFee,
        uint256 _baseExitFee,
        uint256 _badLiquidityExitFee
    ) external adminOnly {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("changeFees"))
        ) {
            return
                mocker.changeFeesMock(
                    marketIndex,
                    _baseEntryFee,
                    _badLiquidityEntryFee,
                    _baseExitFee,
                    _badLiquidityExitFee
                );
        }

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
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_changeFees"))
        ) {
            return
                mocker._changeFeesMock(
                    marketIndex,
                    _baseEntryFee,
                    _baseExitFee,
                    _badLiquidityEntryFee,
                    _badLiquidityExitFee
                );
        }

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

    function updateMarketOracle(uint32 marketIndex, address _newOracleManager)
        external
        adminOnly
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("updateMarketOracle"))
        ) {
            return
                mocker.updateMarketOracleMock(marketIndex, _newOracleManager);
        }

        address previousOracleManager = address(oracleManagers[marketIndex]);
        oracleManagers[marketIndex] = IOracleManager(_newOracleManager);
        emit OracleUpdated(
            marketIndex,
            previousOracleManager,
            _newOracleManager
        );
    }

    function newSyntheticMarket(
        string calldata syntheticName,
        string calldata syntheticSymbol,
        address _fundToken,
        address _oracleManager,
        address _yieldManager
    ) external adminOnly {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("newSyntheticMarket"))
        ) {
            return
                mocker.newSyntheticMarketMock(
                    syntheticName,
                    syntheticSymbol,
                    _fundToken,
                    _oracleManager,
                    _yieldManager
                );
        }

        latestMarket++;

        syntheticTokens[latestMarket][
            true /*short*/
        ] = ISyntheticToken(
            tokenFactory.createTokenLong(
                syntheticName,
                syntheticSymbol,
                staker,
                latestMarket
            )
        );

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

        syntheticTokenPrice[latestMarket][
            true /*short*/
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
                    true /*short*/
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

    function seedMarketInitially(uint256 initialMarketSeed, uint32 marketIndex)
        internal
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("seedMarketInitially"))
        ) {
            return
                mocker.seedMarketInitiallyMock(initialMarketSeed, marketIndex);
        }

        require(
            initialMarketSeed > 0.1 ether,
            "Insufficient value to seed the market"
        );

        _lockFundsInMarket(marketIndex, initialMarketSeed * 2);

        syntheticTokens[latestMarket][
            true /*short*/
        ]
            .mint(DEAD_ADDRESS, initialMarketSeed);
        syntheticTokens[latestMarket][
            false /*short*/
        ]
            .mint(DEAD_ADDRESS, initialMarketSeed);

        syntheticTokenPoolValue[marketIndex][
            true /*short*/
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
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("initializeMarket"))
        ) {
            return
                mocker.initializeMarketMock(
                    marketIndex,
                    _baseEntryFee,
                    _badLiquidityEntryFee,
                    _baseExitFee,
                    _badLiquidityExitFee,
                    kInitialMultiplier,
                    kPeriod,
                    initialMarketSeed
                );
        }

        require(!marketExists[marketIndex] && marketIndex <= latestMarket);

        marketExists[marketIndex] = true;

        _changeFees(
            marketIndex,
            _baseEntryFee,
            _baseExitFee,
            _badLiquidityEntryFee,
            _badLiquidityExitFee
        );

        staker.addNewStakingFund(
            latestMarket,
            syntheticTokens[latestMarket][
                true /*short*/
            ],
            syntheticTokens[latestMarket][
                false /*short*/
            ],
            kInitialMultiplier,
            kPeriod
        );

        seedMarketInitially(initialMarketSeed, marketIndex);
    }

    function getOtherSynthType(bool synthTokenType)
        internal
        view
        returns (bool)
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("getOtherSynthType"))
        ) {
            return mocker.getOtherSynthTypeMock(synthTokenType);
        }

        if (
            synthTokenType == true /*short*/
        ) {
            return false; /*short*/
        } else {
            return true; /*short*/
        }
    }

    function getPrice(uint256 amountSynth, uint256 amountPaymentToken)
        internal
        view
        returns (uint256)
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("getPrice"))
        ) {
            return mocker.getPriceMock(amountSynth, amountPaymentToken);
        }

        return (amountPaymentToken * TEN_TO_THE_18) / amountSynth;
    }

    function getAmountPaymentToken(uint256 amountSynth, uint256 price)
        internal
        view
        returns (uint256)
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("getAmountPaymentToken"))
        ) {
            return mocker.getAmountPaymentTokenMock(amountSynth, price);
        }

        return (amountSynth * price) / TEN_TO_THE_18;
    }

    function getAmountSynthToken(uint256 amountPaymentToken, uint256 price)
        internal
        view
        returns (uint256)
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("getAmountSynthToken"))
        ) {
            return mocker.getAmountSynthTokenMock(amountPaymentToken, price);
        }

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
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("getUsersPendingBalance"))
        ) {
            return mocker.getUsersPendingBalanceMock(user, marketIndex, isLong);
        }

        if (
            userCurrentNextPriceUpdateIndex[marketIndex][user] <=
            marketUpdateIndex[marketIndex]
        ) {
            uint256 amountPaymentTokenDeposited =
                userNextPriceDepositAmount[marketIndex][isLong][user];

            uint256 tokens =
                getAmountSynthToken(
                    amountPaymentTokenDeposited,
                    syntheticTokenPrice[marketIndex][isLong]
                );

            return tokens;
        } else {
            return 0;
        }
    }

    function getTreasurySplit(uint32 marketIndex, uint256 amount)
        public
        view
        returns (uint256 marketAmount, uint256 treasuryAmount)
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("getTreasurySplit"))
        ) {
            return mocker.getTreasurySplitMock(marketIndex, amount);
        }

        uint256 marketPcnt;
        uint256 totalValueLockedInMarket =
            syntheticTokenPoolValue[marketIndex][
                true /*short*/
            ] +
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ];

        if (
            syntheticTokenPoolValue[marketIndex][
                true /*short*/
            ] >
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ]
        ) {
            marketPcnt =
                ((syntheticTokenPoolValue[marketIndex][
                    true /*short*/
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
                        true /*short*/
                    ]) * 10000) /
                totalValueLockedInMarket;
        }

        marketAmount = (marketPcnt * amount) / 10000;
        treasuryAmount = amount - marketAmount;
        require(amount == marketAmount + treasuryAmount);

        return (marketAmount, treasuryAmount);
    }

    function getMarketSplit(uint32 marketIndex, uint256 amount)
        public
        view
        returns (uint256 longAmount, uint256 shortAmount)
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("getMarketSplit"))
        ) {
            return mocker.getMarketSplitMock(marketIndex, amount);
        }

        uint256 longPcnt =
            (syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ] * 10000) /
                (syntheticTokenPoolValue[marketIndex][
                    true /*short*/
                ] +
                    syntheticTokenPoolValue[marketIndex][
                        false /*short*/
                    ]);

        longAmount = (amount * longPcnt) / 10000;
        shortAmount = amount - longAmount;
        return (longAmount, shortAmount);
    }

    function _minimum(uint256 A, uint256 B) internal view returns (int256) {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_minimum"))
        ) {
            return mocker._minimumMock(A, B);
        }

        if (A < B) {
            return int256(A);
        } else {
            return int256(B);
        }
    }

    function _refreshTokenPrices(uint32 marketIndex) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_refreshTokenPrices"))
        ) {
            return mocker._refreshTokenPricesMock(marketIndex);
        }

        uint256 longTokenSupply =
            syntheticTokens[marketIndex][
                true /*short*/
            ]
                .totalSupply();

        if (longTokenSupply > 0) {
            syntheticTokenPrice[marketIndex][
                true /*short*/
            ] = getPrice(
                longTokenSupply,
                syntheticTokenPoolValue[marketIndex][
                    true /*short*/
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
            ] = getPrice(
                shortTokenSupply,
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ]
            );
        }

        emit TokenPriceRefreshed(
            marketIndex,
            syntheticTokenPrice[marketIndex][
                true /*short*/
            ],
            syntheticTokenPrice[marketIndex][
                false /*short*/
            ]
        );
    }

    function _distributeMarketAmount(uint32 marketIndex, uint256 marketAmount)
        internal
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_distributeMarketAmount"))
        ) {
            return
                mocker._distributeMarketAmountMock(marketIndex, marketAmount);
        }

        (uint256 longAmount, uint256 shortAmount) =
            getMarketSplit(marketIndex, marketAmount);
        syntheticTokenPoolValue[marketIndex][
            true /*short*/
        ] += longAmount;
        syntheticTokenPoolValue[marketIndex][
            false /*short*/
        ] += shortAmount;
    }

    function _feesMechanism(uint32 marketIndex, uint256 totalFees) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_feesMechanism"))
        ) {
            return mocker._feesMechanismMock(marketIndex, totalFees);
        }

        (uint256 marketAmount, uint256 treasuryAmount) =
            getTreasurySplit(marketIndex, totalFees);

        totalValueReservedForTreasury[marketIndex] += treasuryAmount;

        _distributeMarketAmount(marketIndex, marketAmount);
        emit FeesLevied(marketIndex, totalFees);
    }

    function _claimAndDistributeYield(uint32 marketIndex) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_claimAndDistributeYield"))
        ) {
            return mocker._claimAndDistributeYieldMock(marketIndex);
        }

        uint256 amount =
            yieldManagers[marketIndex].getTotalHeld() -
                totalValueLockedInYieldManager[marketIndex];

        if (amount > 0) {
            (uint256 marketAmount, uint256 treasuryAmount) =
                getTreasurySplit(marketIndex, amount);

            totalValueLockedInYieldManager[marketIndex] += amount;
            totalValueReservedForTreasury[marketIndex] += treasuryAmount;

            _distributeMarketAmount(marketIndex, marketAmount);
        }
    }

    function _adjustMarketBasedOnNewAssetPrice(
        uint32 marketIndex,
        int256 newAssetPrice
    ) internal returns (bool didUpdate) {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_adjustMarketBasedOnNewAssetPrice"))
        ) {
            return
                mocker._adjustMarketBasedOnNewAssetPriceMock(
                    marketIndex,
                    newAssetPrice
                );
        }

        int256 oldAssetPrice = int256(assetPrice[marketIndex]);

        if (oldAssetPrice == newAssetPrice) {
            return false;
        }

        int256 min =
            _minimum(
                syntheticTokenPoolValue[marketIndex][
                    true /*short*/
                ],
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ]
            );

        int256 percentageChangeE18 =
            ((newAssetPrice - oldAssetPrice) * TEN_TO_THE_18_SIGNED) /
                oldAssetPrice;

        int256 valueChange = (percentageChangeE18 * min) / TEN_TO_THE_18_SIGNED;

        if (valueChange > 0) {
            syntheticTokenPoolValue[marketIndex][
                true /*short*/
            ] += uint256(valueChange);
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ] -= uint256(valueChange);
        } else {
            syntheticTokenPoolValue[marketIndex][
                true /*short*/
            ] -= uint256(valueChange * -1);
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ] += uint256(valueChange * -1);
        }

        return true;
    }

    function handleBatchedDepositSettlement(uint32 marketIndex, bool isLong)
        internal
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("handleBatchedDepositSettlement"))
        ) {
            return
                mocker.handleBatchedDepositSettlementMock(marketIndex, isLong);
        }

        uint256 amountToBatchDeposit =
            batchedNextPriceDepositAmount[marketIndex][isLong];

        if (amountToBatchDeposit > 0) {
            batchedNextPriceDepositAmount[marketIndex][isLong] = 0;
            _transferFundsToYieldManager(marketIndex, amountToBatchDeposit);

            uint256 numberOfTokens =
                getAmountSynthToken(
                    amountToBatchDeposit,
                    syntheticTokenPrice[marketIndex][isLong]
                );

            syntheticTokens[marketIndex][isLong].mint(
                address(this),
                numberOfTokens
            );

            syntheticTokenPoolValue[marketIndex][
                isLong
            ] += amountToBatchDeposit;

            uint256 oldTokenLongPrice =
                syntheticTokenPrice[marketIndex][
                    true /*short*/
                ];
            uint256 oldTokenShortPrice =
                syntheticTokenPrice[marketIndex][
                    false /*short*/
                ];

            _refreshTokenPrices(marketIndex);

            assert(
                syntheticTokenPrice[marketIndex][
                    true /*short*/
                ] == oldTokenLongPrice
            );
            assert(
                syntheticTokenPrice[marketIndex][
                    false /*short*/
                ] == oldTokenShortPrice
            );
        }
    }

    function snapshotPriceChangeForNextPriceExecution(
        uint32 marketIndex,
        uint256 newLatestPriceStateIndex
    ) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(
                abi.encodePacked("snapshotPriceChangeForNextPriceExecution")
            )
        ) {
            return
                mocker.snapshotPriceChangeForNextPriceExecutionMock(
                    marketIndex,
                    newLatestPriceStateIndex
                );
        }

        mintPriceSnapshot[marketIndex][
            true /*short*/
        ][newLatestPriceStateIndex] = syntheticTokenPrice[marketIndex][
            true /*short*/
        ];
        mintPriceSnapshot[marketIndex][
            false /*short*/
        ][newLatestPriceStateIndex] = syntheticTokenPrice[marketIndex][
            false /*short*/
        ];
    }

    function _updateSystemStateInternal(uint32 marketIndex)
        internal
        assertMarketExists(marketIndex)
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_updateSystemStateInternal"))
        ) {
            return mocker._updateSystemStateInternalMock(marketIndex);
        }

        staker.addNewStateForFloatRewards(
            marketIndex,
            syntheticTokenPrice[marketIndex][
                true /*short*/
            ],
            syntheticTokenPrice[marketIndex][
                false /*short*/
            ],
            syntheticTokenPoolValue[marketIndex][
                true /*short*/
            ],
            syntheticTokenPoolValue[marketIndex][
                false /*short*/
            ]
        );

        int256 newAssetPrice = oracleManagers[marketIndex].updatePrice();

        bool priceChanged =
            _adjustMarketBasedOnNewAssetPrice(marketIndex, newAssetPrice);

        if (priceChanged) {
            assert(
                syntheticTokenPoolValue[marketIndex][
                    true /*short*/
                ] !=
                    0 &&
                    syntheticTokenPoolValue[marketIndex][
                        false /*short*/
                    ] !=
                    0
            );

            _claimAndDistributeYield(marketIndex);

            emit PriceUpdate(
                marketIndex,
                assetPrice[marketIndex],
                uint256(newAssetPrice),
                msg.sender
            );

            _refreshTokenPrices(marketIndex);
            assetPrice[marketIndex] = uint256(newAssetPrice);

            uint256 newLatestPriceStateIndex =
                marketUpdateIndex[marketIndex] + 1;
            marketUpdateIndex[marketIndex] = newLatestPriceStateIndex;
            snapshotPriceChangeForNextPriceExecution(
                marketIndex,
                newLatestPriceStateIndex
            );

            handleBatchedDepositSettlement(
                marketIndex,
                true /*short*/
            );
            handleBatchedDepositSettlement(
                marketIndex,
                false /*short*/
            );
            handleBatchedNextPriceRedeems(marketIndex);

            emit BatchedActionsSettled(
                marketIndex,
                newLatestPriceStateIndex,
                mintPriceSnapshot[marketIndex][
                    true /*short*/
                ][newLatestPriceStateIndex],
                mintPriceSnapshot[marketIndex][
                    false /*short*/
                ][newLatestPriceStateIndex],
                redeemPriceSnapshot[marketIndex][
                    true /*short*/
                ][newLatestPriceStateIndex],
                redeemPriceSnapshot[marketIndex][
                    false /*short*/
                ][newLatestPriceStateIndex]
            );

            emit ValueLockedInSystem(
                marketIndex,
                syntheticTokenPoolValue[marketIndex][
                    true /*short*/
                ] +
                    syntheticTokenPoolValue[marketIndex][
                        false /*short*/
                    ],
                syntheticTokenPoolValue[marketIndex][
                    true /*short*/
                ],
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ]
            );
        }
    }

    function _updateSystemState(uint32 marketIndex) external override {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_updateSystemState"))
        ) {
            return mocker._updateSystemStateMock(marketIndex);
        }

        _updateSystemStateInternal(marketIndex);
    }

    function _updateSystemStateMulti(uint32[] calldata marketIndexes)
        external
        override
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_updateSystemStateMulti"))
        ) {
            return mocker._updateSystemStateMultiMock(marketIndexes);
        }

        for (uint256 i = 0; i < marketIndexes.length; i++) {
            _updateSystemStateInternal(marketIndexes[i]);
        }
    }

    function _depositFunds(uint32 marketIndex, uint256 amount) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_depositFunds"))
        ) {
            return mocker._depositFundsMock(marketIndex, amount);
        }

        fundTokens[marketIndex].transferFrom(msg.sender, address(this), amount);
    }

    function _lockFundsInMarket(uint32 marketIndex, uint256 amount) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_lockFundsInMarket"))
        ) {
            return mocker._lockFundsInMarketMock(marketIndex, amount);
        }

        _depositFunds(marketIndex, amount);
        _transferFundsToYieldManager(marketIndex, amount);
    }

    function _withdrawFunds(
        uint32 marketIndex,
        uint256 amountLong,
        uint256 amountShort,
        address user
    ) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_withdrawFunds"))
        ) {
            return
                mocker._withdrawFundsMock(
                    marketIndex,
                    amountLong,
                    amountShort,
                    user
                );
        }

        uint256 totalAmount = amountLong + amountShort;

        assert(
            syntheticTokenPoolValue[marketIndex][
                true /*short*/
            ] >=
                amountLong &&
                syntheticTokenPoolValue[marketIndex][
                    false /*short*/
                ] >=
                amountShort
        );

        _transferFromYieldManager(marketIndex, totalAmount);

        fundTokens[marketIndex].transfer(user, totalAmount);

        syntheticTokenPoolValue[marketIndex][
            true /*short*/
        ] -= amountLong;
        syntheticTokenPoolValue[marketIndex][
            false /*short*/
        ] -= amountShort;
    }

    function _transferFundsToYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_transferFundsToYieldManager"))
        ) {
            return mocker._transferFundsToYieldManagerMock(marketIndex, amount);
        }

        fundTokens[marketIndex].approve(
            address(yieldManagers[marketIndex]),
            amount
        );
        yieldManagers[marketIndex].depositToken(amount);

        totalValueLockedInYieldManager[marketIndex] += amount;
    }

    function _transferFromYieldManager(uint32 marketIndex, uint256 amount)
        internal
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_transferFromYieldManager"))
        ) {
            return mocker._transferFromYieldManagerMock(marketIndex, amount);
        }

        require(totalValueLockedInYieldManager[marketIndex] >= amount);

        yieldManagers[marketIndex].withdrawToken(amount);

        totalValueLockedInYieldManager[marketIndex] -= amount;

        require(
            totalValueLockedInYieldManager[marketIndex] <=
                syntheticTokenPoolValue[marketIndex][
                    true /*short*/
                ] +
                    syntheticTokenPoolValue[marketIndex][
                        false /*short*/
                    ] +
                    totalValueReservedForTreasury[marketIndex]
        );
    }

    function transferTreasuryFunds(uint32 marketIndex) external treasuryOnly {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("transferTreasuryFunds"))
        ) {
            return mocker.transferTreasuryFundsMock(marketIndex);
        }

        uint256 totalForTreasury = totalValueReservedForTreasury[marketIndex];

        totalValueReservedForTreasury[marketIndex] = 0;

        if (totalForTreasury == 0) {
            return;
        }

        _transferFromYieldManager(marketIndex, totalForTreasury);

        fundTokens[marketIndex].transfer(treasury, totalForTreasury);
    }

    function _getFeesGeneral(
        uint32 marketIndex,
        uint256 delta,
        bool synthTokenGainingDominance,
        bool synthTokenLosingDominance,
        uint256 baseFeePercent,
        uint256 penaltyFeePercent
    ) internal view returns (uint256) {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_getFeesGeneral"))
        ) {
            return
                mocker._getFeesGeneralMock(
                    marketIndex,
                    delta,
                    synthTokenGainingDominance,
                    synthTokenLosingDominance,
                    baseFeePercent,
                    penaltyFeePercent
                );
        }

        uint256 baseFee = (delta * baseFeePercent) / feeUnitsOfPrecision;

        if (
            syntheticTokenPoolValue[marketIndex][synthTokenGainingDominance] >=
            syntheticTokenPoolValue[marketIndex][synthTokenLosingDominance]
        ) {
            return
                baseFee + ((delta * penaltyFeePercent) / feeUnitsOfPrecision);
        } else if (
            syntheticTokenPoolValue[marketIndex][synthTokenGainingDominance] +
                delta >
            syntheticTokenPoolValue[marketIndex][synthTokenLosingDominance]
        ) {
            uint256 amountImbalancing =
                delta -
                    (syntheticTokenPoolValue[marketIndex][
                        synthTokenLosingDominance
                    ] -
                        syntheticTokenPoolValue[marketIndex][
                            synthTokenGainingDominance
                        ]);
            uint256 penaltyFee =
                (amountImbalancing * penaltyFeePercent) / feeUnitsOfPrecision;

            return baseFee + penaltyFee;
        } else {
            return baseFee;
        }
    }

    function _executeNextPriceMintsIfTheyExist(
        uint32 marketIndex,
        address user,
        bool isLong
    ) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_executeNextPriceMintsIfTheyExist"))
        ) {
            return
                mocker._executeNextPriceMintsIfTheyExistMock(
                    marketIndex,
                    user,
                    isLong
                );
        }

        uint256 currentDepositAmount =
            userNextPriceDepositAmount[marketIndex][isLong][user];
        if (currentDepositAmount > 0) {
            uint256 tokensToMint =
                getAmountSynthToken(
                    currentDepositAmount,
                    mintPriceSnapshot[marketIndex][isLong][
                        userCurrentNextPriceUpdateIndex[marketIndex][user]
                    ]
                );

            syntheticTokens[marketIndex][isLong].transfer(user, tokensToMint);

            userNextPriceDepositAmount[marketIndex][isLong][user] = 0;
        }
    }

    function _executeOutstandingNextPriceSettlementsAction(
        address user,
        uint32 marketIndex
    ) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(
                abi.encodePacked(
                    "_executeOutstandingNextPriceSettlementsAction"
                )
            )
        ) {
            return
                mocker._executeOutstandingNextPriceSettlementsActionMock(
                    user,
                    marketIndex
                );
        }

        _executeNextPriceMintsIfTheyExist(
            marketIndex,
            user,
            true /*short*/
        );
        _executeNextPriceMintsIfTheyExist(
            marketIndex,
            user,
            false /*short*/
        );
        _executeOutstandingNextPriceRedeems(
            marketIndex,
            user,
            true /*short*/
        );
        _executeOutstandingNextPriceRedeems(
            marketIndex,
            user,
            false /*short*/
        );

        userCurrentNextPriceUpdateIndex[marketIndex][user] = 0;
    }

    function _executeOutstandingNextPriceSettlements(
        address user,
        uint32 marketIndex
    ) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(
                abi.encodePacked("_executeOutstandingNextPriceSettlements")
            )
        ) {
            return
                mocker._executeOutstandingNextPriceSettlementsMock(
                    user,
                    marketIndex
                );
        }

        uint256 currentUpdateIndex =
            userCurrentNextPriceUpdateIndex[marketIndex][user];
        if (
            currentUpdateIndex <= marketUpdateIndex[marketIndex] &&
            currentUpdateIndex != 0
        ) {
            _executeOutstandingNextPriceSettlementsAction(user, marketIndex);

            emit ExecuteNextPriceSettlementsUser(user, marketIndex);
        }
    }

    function executeOutstandingNextPriceSettlementsUser(
        address user,
        uint32 marketIndex
    ) external override {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(
                abi.encodePacked("executeOutstandingNextPriceSettlementsUser")
            )
        ) {
            return
                mocker.executeOutstandingNextPriceSettlementsUserMock(
                    user,
                    marketIndex
                );
        }

        _executeOutstandingNextPriceSettlements(user, marketIndex);
    }

    function _mintNextPrice(
        uint32 marketIndex,
        uint256 amount,
        bool isLong
    )
        internal
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_mintNextPrice"))
        ) {
            return mocker._mintNextPriceMock(marketIndex, amount, isLong);
        }

        _depositFunds(marketIndex, amount);

        batchedNextPriceDepositAmount[marketIndex][isLong] += amount;
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
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("mintLongNextPrice"))
        ) {
            return mocker.mintLongNextPriceMock(marketIndex, amount);
        }

        _mintNextPrice(
            marketIndex,
            amount,
            true /*short*/
        );
    }

    function mintShortNextPrice(uint32 marketIndex, uint256 amount) external {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("mintShortNextPrice"))
        ) {
            return mocker.mintShortNextPriceMock(marketIndex, amount);
        }

        _mintNextPrice(
            marketIndex,
            amount,
            false /*short*/
        );
    }

    function _executeOutstandingNextPriceRedeems(
        uint32 marketIndex,
        address user,
        bool isLong
    ) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_executeOutstandingNextPriceRedeems"))
        ) {
            return
                mocker._executeOutstandingNextPriceRedeemsMock(
                    marketIndex,
                    user,
                    isLong
                );
        }

        uint256 currentRedemptions =
            userNextPriceRedemptionAmount[marketIndex][isLong][user];
        if (currentRedemptions > 0) {
            uint256 amountToRedeem =
                getAmountPaymentToken(
                    currentRedemptions,
                    redeemPriceSnapshot[marketIndex][isLong][
                        userCurrentNextPriceUpdateIndex[marketIndex][user]
                    ]
                );

            uint256 balance = fundTokens[marketIndex].balanceOf(address(this));

            fundTokens[marketIndex].transfer(user, amountToRedeem);
            userNextPriceRedemptionAmount[marketIndex][isLong][user] = 0;
        }
    }

    function _redeemNextPrice(
        uint32 marketIndex,
        uint256 tokensToRedeem,
        bool isLong
    )
        internal
        updateSystemStateMarket(marketIndex)
        executeOutstandingNextPriceSettlements(msg.sender, marketIndex)
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_redeemNextPrice"))
        ) {
            return
                mocker._redeemNextPriceMock(
                    marketIndex,
                    tokensToRedeem,
                    isLong
                );
        }

        syntheticTokens[marketIndex][isLong].transferFrom(
            msg.sender,
            address(this),
            tokensToRedeem
        );
        uint256 nextUpdateIndex = marketUpdateIndex[marketIndex] + 1;

        userNextPriceRedemptionAmount[marketIndex][isLong][
            msg.sender
        ] += tokensToRedeem;
        userCurrentNextPriceUpdateIndex[marketIndex][
            msg.sender
        ] = nextUpdateIndex;

        batchedNextPriceSynthRedeemAmount[marketIndex][
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
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("redeemLongNextPrice"))
        ) {
            return mocker.redeemLongNextPriceMock(marketIndex, tokensToRedeem);
        }

        _redeemNextPrice(
            marketIndex,
            tokensToRedeem,
            true /*short*/
        );
    }

    function redeemShortNextPrice(uint32 marketIndex, uint256 tokensToRedeem)
        external
    {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("redeemShortNextPrice"))
        ) {
            return mocker.redeemShortNextPriceMock(marketIndex, tokensToRedeem);
        }

        _redeemNextPrice(
            marketIndex,
            tokensToRedeem,
            false /*short*/
        );
    }

    function _handleBatchedNextPriceRedeem(
        uint32 marketIndex,
        bool isLong,
        uint256 amountSynthToRedeem
    ) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_handleBatchedNextPriceRedeem"))
        ) {
            return
                mocker._handleBatchedNextPriceRedeemMock(
                    marketIndex,
                    isLong,
                    amountSynthToRedeem
                );
        }

        if (amountSynthToRedeem > 0) {
            syntheticTokens[marketIndex][isLong].synthRedeemBurn(
                address(this),
                amountSynthToRedeem
            );
        }
    }

    function _calculateBatchedNextPriceFees(
        uint32 marketIndex,
        uint256 amountOfPaymentTokenToRedeem,
        uint256 shortAmountOfPaymentTokenToRedeem
    ) internal returns (uint256 totalFeesLong, uint256 totalFeesShort) {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("_calculateBatchedNextPriceFees"))
        ) {
            return
                mocker._calculateBatchedNextPriceFeesMock(
                    marketIndex,
                    amountOfPaymentTokenToRedeem,
                    shortAmountOfPaymentTokenToRedeem
                );
        }

        if (amountOfPaymentTokenToRedeem > shortAmountOfPaymentTokenToRedeem) {
            uint256 delta =
                amountOfPaymentTokenToRedeem -
                    shortAmountOfPaymentTokenToRedeem;
            totalFeesLong = _getFeesGeneral(
                marketIndex,
                delta,
                false, /*short*/
                true, /*short*/
                0,
                badLiquidityExitFee[marketIndex]
            );
        } else {
            uint256 delta =
                shortAmountOfPaymentTokenToRedeem -
                    amountOfPaymentTokenToRedeem;
            totalFeesShort = _getFeesGeneral(
                marketIndex,
                delta,
                true, /*short*/
                false, /*short*/
                0,
                badLiquidityExitFee[marketIndex]
            );
        }

        _feesMechanism(marketIndex, totalFeesLong + totalFeesShort);
    }

    function calculateRedeemPriceSnapshot(
        uint32 marketIndex,
        uint256 amountOfPaymentTokenToRedeem,
        bool isLong
    ) internal returns (uint256 batchLongTotalWithdrawnPaymentToken) {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("calculateRedeemPriceSnapshot"))
        ) {
            return
                mocker.calculateRedeemPriceSnapshotMock(
                    marketIndex,
                    amountOfPaymentTokenToRedeem,
                    isLong
                );
        }

        if (amountOfPaymentTokenToRedeem > 0) {
            redeemPriceSnapshot[marketIndex][isLong][
                marketUpdateIndex[marketIndex]
            ] = getPrice(
                batchedNextPriceSynthRedeemAmount[marketIndex][isLong],
                amountOfPaymentTokenToRedeem
            );

            return
                getAmountPaymentToken(
                    batchedNextPriceSynthRedeemAmount[marketIndex][isLong],
                    redeemPriceSnapshot[marketIndex][isLong][
                        marketUpdateIndex[marketIndex]
                    ]
                );
        }
    }

    function handleBatchedNextPriceRedeems(uint32 marketIndex) internal {
        if (
            shouldUseMock &&
            keccak256(abi.encodePacked(functionToNotMock)) !=
            keccak256(abi.encodePacked("handleBatchedNextPriceRedeems"))
        ) {
            return mocker.handleBatchedNextPriceRedeemsMock(marketIndex);
        }

        uint256 batchedNextPriceSynthToRedeemLong =
            batchedNextPriceSynthRedeemAmount[marketIndex][
                true /*short*/
            ];
        uint256 batchedNextPriceSynthToRedeemShort =
            batchedNextPriceSynthRedeemAmount[marketIndex][
                false /*short*/
            ];

        _handleBatchedNextPriceRedeem(
            marketIndex,
            true, /*short*/
            batchedNextPriceSynthToRedeemLong
        );
        _handleBatchedNextPriceRedeem(
            marketIndex,
            false, /*short*/
            batchedNextPriceSynthToRedeemShort
        );

        uint256 longAmountOfPaymentTokenToRedeem =
            getAmountPaymentToken(
                batchedNextPriceSynthToRedeemLong,
                syntheticTokenPrice[marketIndex][
                    true /*short*/
                ]
            );

        uint256 shortAmountOfPaymentTokenToRedeem =
            getAmountPaymentToken(
                batchedNextPriceSynthToRedeemShort,
                syntheticTokenPrice[marketIndex][
                    false /*short*/
                ]
            );

        (uint256 totalFeesLong, uint256 totalFeesShort) =
            _calculateBatchedNextPriceFees(
                marketIndex,
                longAmountOfPaymentTokenToRedeem,
                shortAmountOfPaymentTokenToRedeem
            );

        uint256 batchShortTotalWithdrawnPaymentToken =
            calculateRedeemPriceSnapshot(
                marketIndex,
                shortAmountOfPaymentTokenToRedeem - totalFeesShort,
                false /*short*/
            );

        uint256 batchLongTotalWithdrawnPaymentToken =
            calculateRedeemPriceSnapshot(
                marketIndex,
                longAmountOfPaymentTokenToRedeem - totalFeesLong,
                true /*short*/
            );

        _withdrawFunds(
            marketIndex,
            batchLongTotalWithdrawnPaymentToken,
            batchShortTotalWithdrawnPaymentToken,
            address(this)
        );

        _refreshTokenPrices(marketIndex);

        batchedNextPriceSynthRedeemAmount[marketIndex][
            true /*short*/
        ] = 0;
        batchedNextPriceSynthRedeemAmount[marketIndex][
            false /*short*/
        ] = 0;
    }
}
