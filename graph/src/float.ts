import {
  V1,
  FeesLevied,
  SyntheticTokenCreated,
  PriceUpdate,
  SystemStateUpdated,
  FeesChanges,
  OracleUpdated,
  NextPriceDeposit,
  NewMarketLaunchedAndSeeded,
  NextPriceRedeem,
  ExecuteNextPriceSettlementsUser,
} from "../generated/LongShort/LongShort";
import {
  SyntheticMarket,
  FeeStructure,
  GlobalState,
  Staker,
  TokenFactory,
  LongShortContract,
  SyntheticToken,
  CollateralToken,
  LatestPrice,
  Price,
} from "../generated/schema";
import { BigInt, log, Bytes, Address } from "@graphprotocol/graph-ts";
import {
  bigIntArrayToStringArray,
  saveEventToStateChange,
} from "./utils/txEventHelpers";
import {
  getOrCreateLatestSystemState,
  getOrCreateStakerState,
  createSyntheticTokenLong,
  createSyntheticTokenShort,
  createInitialSystemState,
  updateOrCreateCollateralToken,
  getOrCreateGlobalState,
  getStakerStateId,
  getUser,
  getSyntheticMarket,
  getSyntheticTokenById,
} from "./utils/globalStateManager";
import {
  createNewTokenDataSource,
  increaseUserMints,
} from "./utils/helperFunctions";
import { decreaseOrCreateUserApprovals } from "./tokenTransfers";
import {
  ZERO,
  GLOBAL_STATE_ID,
  STAKER_ID,
  TOKEN_FACTORY_ID,
  LONG_SHORT_ID,
  MARKET_SIDE_SHORT,
  MARKET_SIDE_LONG,
  ACTION_MINT,
  ACTION_REDEEM,
  TEN_TO_THE_18,
} from "./CONSTANTS";
import {
  createOrUpdateUserNextPriceAction,
  createUserNextPriceActionComponent,
  createOrUpdateBatchedNextPriceExec,
  getBatchedNextPriceExec,
  getUserNextPriceActionById,
  getUsersCurrentNextPriceAction,
  doesBatchExist,
} from "./utils/nextPrice";

export function handleV1(event: V1): void {
  // event V1(address admin, address tokenFactory, address staker);

  let admin = event.params.admin;
  let tokenFactoryParam = event.params.tokenFactory;
  // TODO: do something with the treasury - not recorded at the moment!
  let treasury = event.params.treasury;
  let tokenFactoryString = tokenFactoryParam.toHex();
  let stakerParam = event.params.staker;
  let stakerString = stakerParam.toHex();

  // This function will only ever get called once
  if (GlobalState.load(GLOBAL_STATE_ID) != null) {
    log.critical("the event was emitted more than once!", []);
  }

  let longShort = new LongShortContract(LONG_SHORT_ID);
  longShort.address = event.address;
  longShort.save();

  let tokenFactory = new TokenFactory(TOKEN_FACTORY_ID);
  tokenFactory.address = event.params.tokenFactory;
  tokenFactory.save();

  // Create these with event params as opposed to constants
  let staker = new Staker(STAKER_ID);
  staker.address = event.params.staker;
  staker.save();

  let globalState = getOrCreateGlobalState();
  globalState.contractVersion = BigInt.fromI32(1);
  globalState.staker = staker.id;
  globalState.tokenFactory = tokenFactory.id;
  globalState.adminAddress = event.params.admin;
  globalState.longShort = longShort.id;
  globalState.timestampLaunched = event.block.timestamp;
  globalState.txHash = event.transaction.hash;
  globalState.save();

  saveEventToStateChange(
    event,
    "V1",
    [admin.toHex(), treasury.toHex(), tokenFactoryString, stakerString],
    ["admin", "treasury", "tokenFactory", "staker"],
    ["address", "address", "address", "address"],
    [],
    []
  );
}

export function handleFeesLevied(event: FeesLevied): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let totalFees = event.params.totalFees;

  // State change - TODO
}

export function handleSystemStateUpdated(event: SystemStateUpdated): void {
  let marketIndex = event.params.marketIndex;
  let marketIndexString = marketIndex.toString();
  let longValue = event.params.longValue;
  let updateIndex = event.params.updateIndex;
  let shortValue = event.params.shortValue;
  let longTokenPrice = event.params.longPrice;
  let shortTokenPrice = event.params.shortPrice;
  let totalValueLockedInMarket = longValue.plus(shortValue);
  let txHash = event.transaction.hash;
  let timestamp = event.block.timestamp;

  let systemState = getOrCreateLatestSystemState(marketIndex, txHash, event);
  systemState.totalValueLocked = totalValueLockedInMarket;
  systemState.totalLockedLong = longValue;
  systemState.totalLockedShort = shortValue;

  systemState.save();

  let syntheticMarket = SyntheticMarket.load(marketIndexString);

  syntheticMarket.latestSystemState = systemState.id;
  syntheticMarket.save();

  updateLatestTokenPrice(true, marketIndexString, longTokenPrice, timestamp);
  updateLatestTokenPrice(false, marketIndexString, shortTokenPrice, timestamp);

  let batchExists = doesBatchExist(marketIndex, updateIndex);
  if (batchExists) {
    let executedTimestamp = event.block.timestamp;

    let syntheticMarket = getSyntheticMarket(marketIndex);
    let longTokenId = syntheticMarket.syntheticLong;
    let shortTokenId = syntheticMarket.syntheticShort;

    let syntheticTokenLong = getSyntheticTokenById(longTokenId);
    let syntheticTokenShort = getSyntheticTokenById(shortTokenId);

    let batchedNextPriceExec = getBatchedNextPriceExec(
      marketIndex,
      updateIndex
    );

    batchedNextPriceExec.mintPriceSnapshotLong = longTokenPrice;
    batchedNextPriceExec.mintPriceSnapshotShort = shortTokenPrice;
    // TODO: when fees are added for redeem this will need to be updated!
    batchedNextPriceExec.redeemPriceSnapshotLong = longTokenPrice;
    batchedNextPriceExec.redeemPriceSnapshotShort = shortTokenPrice;

    batchedNextPriceExec.executedTimestamp = executedTimestamp;

    let linkedUserNextPriceActions =
      batchedNextPriceExec.linkedUserNextPriceActions;
    let numberOfUsersInBatch = linkedUserNextPriceActions.length;

    for (let i = 0; i < numberOfUsersInBatch; ++i) {
      let userNextPriceActionId: string = linkedUserNextPriceActions[i];

      let userNextPriceAction = getUserNextPriceActionById(
        userNextPriceActionId
      );
      userNextPriceAction.confirmedTimestamp = event.block.timestamp;
      userNextPriceAction.save();

      let userAddress = Address.fromString(userNextPriceAction.user);
      let user = getUser(userAddress);

      user.pendingNextPriceActions = removeFromArrayAtIndex(
        user.pendingNextPriceActions,
        user.pendingNextPriceActions.indexOf(userNextPriceActionId)
      );

      user.confirmedNextPriceActions = user.confirmedNextPriceActions.concat([
        userNextPriceActionId,
      ]);

      let tokensMintedLong = userNextPriceAction.amountPaymentTokenForDepositLong
        .times(TEN_TO_THE_18)
        .div(longTokenPrice);
      let tokensMintedShort = userNextPriceAction.amountPaymentTokenForDepositShort
        .times(TEN_TO_THE_18)
        .div(shortTokenPrice);

      increaseUserMints(user, syntheticTokenLong, tokensMintedLong);
      increaseUserMints(user, syntheticTokenShort, tokensMintedShort);

      // TODO: add fees when they are implemented!
      let paymentTokensToRedeemLong = userNextPriceAction.amountSynthTokenForWithdrawalLong
        .times(longTokenPrice)
        .div(TEN_TO_THE_18);
      let paymentTokensToRedeemShort = userNextPriceAction.amountSynthTokenForWithdrawalShort
        .times(shortTokenPrice)
        .div(TEN_TO_THE_18);
      // TODO: read the below warning, take note...
      log.warning(
        "TODO: WARNING: we are not handling the redeems yet! Think through",
        []
      );

      user.save();
    }

    batchedNextPriceExec.save();
  }

  saveEventToStateChange(
    event,
    "ValueLockedInSystem",
    bigIntArrayToStringArray([
      marketIndex,
      updateIndex,
      longValue,
      shortValue,
      longTokenPrice,
      shortTokenPrice,
    ]),
    [
      "marketIndex",
      "updateIndex",
      "longValue",
      "shortValue",
      "longPrice",
      "shortPrice",
    ],
    ["uint32", "uint256", "uint256", "uint256", "uint256", "uint256"],
    [],
    []
  );
}

export function handleSyntheticTokenCreated(
  event: SyntheticTokenCreated
): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let longTokenAddress = event.params.longTokenAddress;
  let shortTokenAddress = event.params.shortTokenAddress;
  let collateralTokenAddress = event.params.fundToken;
  let initialAssetPrice = event.params.assetPrice;

  let oracleAddress = event.params.oracleAddress;
  let syntheticName = event.params.name;
  let syntheticSymbol = event.params.symbol;

  let marketIndexString = marketIndex.toString();

  // TODO: Add string name to these.
  createNewTokenDataSource(longTokenAddress);
  createNewTokenDataSource(shortTokenAddress);

  // create new synthetic token object.
  let longToken = createSyntheticTokenLong(longTokenAddress);
  let shortToken = createSyntheticTokenShort(shortTokenAddress);

  let initialState = createInitialSystemState(
    marketIndex,
    ZERO,
    event,
    longToken.id,
    shortToken.id
  );

  let fees = new FeeStructure(marketIndexString + "-fees");
  fees.baseEntryFee = ZERO;
  fees.badLiquidityEntryFee = ZERO;
  fees.baseExitFee = ZERO;
  fees.badLiquidityExitFee = ZERO;

  let syntheticMarket = new SyntheticMarket(marketIndexString);
  syntheticMarket.timestampCreated = timestamp;
  syntheticMarket.txHash = txHash;
  syntheticMarket.blockNumberCreated = blockNumber;
  syntheticMarket.name = syntheticName;
  syntheticMarket.symbol = syntheticSymbol;
  syntheticMarket.latestSystemState = initialState.systemState.id;
  syntheticMarket.syntheticLong = longToken.id;
  syntheticMarket.syntheticShort = shortToken.id;
  syntheticMarket.marketIndex = marketIndex;
  syntheticMarket.oracleAddress = oracleAddress;
  syntheticMarket.previousOracleAddresses = [];
  syntheticMarket.feeStructure = fees.id;
  syntheticMarket.kPeriod = ZERO;
  syntheticMarket.kMultiplier = ZERO;
  syntheticMarket.totalFloatMinted = ZERO;
  syntheticMarket.nextPriceActions = [];
  syntheticMarket.settledNextPriceActions = [];
  initialState.systemState.syntheticPrice = initialAssetPrice; // change me

  // create new synthetic token object.
  let collateralToken = updateOrCreateCollateralToken(
    collateralTokenAddress,
    syntheticMarket
  );
  syntheticMarket.collateralToken = collateralToken.id;

  let globalState = GlobalState.load(GLOBAL_STATE_ID);
  if (globalState == null) {
    log.critical("Global state is null in `handleSyntheticTokenCreated`", []);
  }
  globalState.latestMarketIndex = globalState.latestMarketIndex.plus(
    BigInt.fromI32(1)
  );

  // Make sure the latest staker state has the correct ID even though the instance hasn't been created yet.
  syntheticMarket.latestStakerState = getStakerStateId(marketIndexString, ZERO);

  longToken.syntheticMarket = syntheticMarket.id;
  longToken.latestPrice = initialState.latestTokenPriceLong.id;
  longToken.priceHistory = [initialState.tokenPriceLong.id];

  shortToken.syntheticMarket = syntheticMarket.id;
  shortToken.latestPrice = initialState.latestTokenPriceShort.id;
  shortToken.priceHistory = [initialState.tokenPriceShort.id];

  syntheticMarket.save();
  // This function uses the synthetic market internally, so can only be created once the synthetic market has been created.
  let initalLatestStakerState = getOrCreateStakerState(
    syntheticMarket,
    ZERO,
    event
  );
  collateralToken.save();
  initalLatestStakerState.save();
  longToken.save();
  shortToken.save();
  initialState.systemState.save();
  fees.save();
  globalState.save();

  saveEventToStateChange(
    event,
    "SyntheticTokenCreated",
    [
      marketIndex.toString(),
      longTokenAddress.toHex(),
      shortTokenAddress.toHex(),
      initialAssetPrice.toString(),
      syntheticName,
      syntheticSymbol,
      oracleAddress.toHex(),
      collateralTokenAddress.toHex(),
    ],
    [
      "marketIndex",
      "longTokenAddress",
      "shortTokenAddress",
      "assetPrice",
      "name",
      "symbol",
      "oracleAddress",
      "collateralAddress",
    ],
    [
      "uint256",
      "address",
      "address",
      "uint256",
      "string",
      "string",
      "address",
      "address",
    ],
    [],
    []
  );
}

export function handleMarketOracleUpdated(event: OracleUpdated): void {
  let marketIndex = event.params.marketIndex;
  let oldOracleAddress = event.params.oldOracleAddress;
  let newOracleAddress = event.params.newOracleAddress;

  let syntheticMarket = SyntheticMarket.load(marketIndex.toString());
  syntheticMarket.oracleAddress = newOracleAddress;

  let previousOracles = syntheticMarket.previousOracleAddresses as Array<Bytes>;

  previousOracles.push(oldOracleAddress!);

  syntheticMarket.previousOracleAddresses = previousOracles;

  syntheticMarket.save();
}

export function handleFeesChanges(event: FeesChanges): void {
  let marketIndex = event.params.marketIndex;
  let baseEntryFee = event.params.baseEntryFee;
  let badLiquidityEntryFee = event.params.badLiquidityEntryFee;
  let baseExitFee = event.params.baseExitFee;
  let badLiquidityExitFee = event.params.badLiquidityExitFee;

  let marketIndexString = marketIndex.toString();

  let fees = FeeStructure.load(marketIndexString + "-fees");
  fees.baseEntryFee = baseEntryFee;
  fees.badLiquidityEntryFee = badLiquidityEntryFee;
  fees.baseExitFee = baseExitFee;
  fees.badLiquidityExitFee = badLiquidityExitFee;

  fees.save();

  saveEventToStateChange(
    event,
    "FeesChanges",
    [
      marketIndex.toString(),
      baseEntryFee.toString(),
      badLiquidityEntryFee.toString(),
      baseExitFee.toString(),
      badLiquidityExitFee.toString(),
    ],
    [
      "marketIndex",
      "baseEntryFee",
      "badLiquidityEntryFee",
      "baseExitFee",
      "badLiquidityExitFee",
    ],
    ["uint32", "uint256", "uint256", "uint256", "uint256"],
    [],
    []
  );
}

export function handlePriceUpdate(event: PriceUpdate): void {
  let marketIndex = event.params.marketIndex;
  let marketIndexString = marketIndex.toString();

  let newPrice = event.params.newPrice;
  let oldPrice = event.params.oldPrice;
  let user = event.params.user;
  let txHash = event.transaction.hash;

  let syntheticMarket = SyntheticMarket.load(marketIndexString);

  let systemState = getOrCreateLatestSystemState(marketIndex, txHash, event);
  systemState.syntheticPrice = newPrice;
  syntheticMarket.latestSystemState = systemState.id;
  systemState.save();
  syntheticMarket.save();

  saveEventToStateChange(
    event,
    "PriceUpdate",
    bigIntArrayToStringArray([marketIndex, oldPrice, newPrice]).concat([
      user.toHex(),
    ]),
    ["marketIndex", "newPrice", "oldPrice", "user"],
    ["uint32", "uint256", "uint256", "address"],
    [user],
    []
  );
}

export function handleNextPriceDeposit(event: NextPriceDeposit): void {
  let depositAdded = event.params.depositAdded;
  let marketIndex = event.params.marketIndex;
  let oracleUpdateIndex = event.params.oracleUpdateIndex;
  let isLong = event.params.isLong;
  let userAddress = event.params.user;

  let user = getUser(userAddress);
  let syntheticMarket = getSyntheticMarket(marketIndex);

  let userNextPriceActionComponent = createUserNextPriceActionComponent(
    user,
    syntheticMarket,
    oracleUpdateIndex,
    depositAdded,
    ACTION_MINT,
    isLong,
    event
  );

  let batchedNextPriceExec = createOrUpdateBatchedNextPriceExec(
    userNextPriceActionComponent
  );
  let userNextPriceAction = createOrUpdateUserNextPriceAction(
    userNextPriceActionComponent,
    syntheticMarket,
    user
  );

  userNextPriceAction.save();
  batchedNextPriceExec.save();

  let collateralToken = CollateralToken.load(syntheticMarket.collateralToken);
  if (collateralToken == null) {
    log.critical(
      "collateralToken is undefined when it shouldn't be, entity id: {}",
      [syntheticMarket.collateralToken]
    );
  }

  decreaseOrCreateUserApprovals(
    userAddress,
    event.params.depositAdded,
    collateralToken,
    event
  );

  saveEventToStateChange(
    event,
    "NextPriceDeposit",
    bigIntArrayToStringArray([
      depositAdded,
      marketIndex,
      oracleUpdateIndex,
    ]).concat([isLong ? "true" : "false", user.id]),
    ["depositAdded", "marketIndex", "oracleUpdateIndex", "isLong", "user"],
    ["uint256", "uint32", "uint256", "bool", "address"],
    [userAddress],
    []
  );
}

export function handleNextPriceRedeem(event: NextPriceRedeem): void {
  let depositAdded = event.params.synthRedeemed;
  let marketIndex = event.params.marketIndex;
  let oracleUpdateIndex = event.params.oracleUpdateIndex;
  let isLong = event.params.isLong;
  let userAddress = event.params.user;

  let user = getUser(userAddress);
  let syntheticMarket = getSyntheticMarket(marketIndex);

  let userNextPriceActionComponent = createUserNextPriceActionComponent(
    user,
    syntheticMarket,
    oracleUpdateIndex,
    depositAdded,
    ACTION_REDEEM,
    isLong,
    event
  );

  let batchedNextPriceExec = createOrUpdateBatchedNextPriceExec(
    userNextPriceActionComponent
  );
  let userNextPriceAction = createOrUpdateUserNextPriceAction(
    userNextPriceActionComponent,
    syntheticMarket,
    user
  );

  userNextPriceAction.save();
  batchedNextPriceExec.save();

  saveEventToStateChange(
    event,
    "NextPriceRedeem",
    bigIntArrayToStringArray([
      depositAdded,
      marketIndex,
      oracleUpdateIndex,
    ]).concat([isLong ? "true" : "false", user.id]),
    ["synthRedeemed", "marketIndex", "oracleUpdateIndex", "isLong", "user"],
    ["uint256", "uint32", "uint256", "bool", "address"],
    [userAddress],
    []
  );
}

export function handleNewMarketLaunchedAndSeeded(
  event: NewMarketLaunchedAndSeeded
): void {
  // TODO - need to include the market seed initially
  let marketIndex = event.params.marketIndex;
  let initialSeed = event.params.initialSeed;

  saveEventToStateChange(
    event,
    "NewMarketLaunchedAndSeeded",
    [marketIndex.toString(), initialSeed.toHex()],
    ["marketIndex", "initialMarketSeed"],
    ["uint32", "uint256"],
    [],
    []
  );
}

export function removeFromArrayAtIndex(
  array: Array<string>,
  index: i32
): Array<string> {
  if (array.length > index && index > -1) {
    return array.slice(0, index).concat(array.slice(index + 1, array.length));
  } else {
    return array;
  }
}

export function handleExecuteNextPriceSettlementsUser(
  event: ExecuteNextPriceSettlementsUser
): void {
  let marketIndex = event.params.marketIndex;
  let userAddress = event.params.user;

  let userNextPriceAction = getUsersCurrentNextPriceAction(
    userAddress,
    marketIndex
  );

  userNextPriceAction.settledTimestamp = event.block.timestamp;
  userNextPriceAction.save();

  let user = getUser(userAddress);

  user.confirmedNextPriceActions = removeFromArrayAtIndex(
    user.confirmedNextPriceActions,
    user.confirmedNextPriceActions.indexOf(userNextPriceAction.id)
  );

  user.settledNextPriceActions = user.settledNextPriceActions.concat([
    userNextPriceAction.id,
  ]);

  user.save();

  saveEventToStateChange(
    event,
    "ExecuteNextPriceSettlementsUser",
    [marketIndex.toString(), userAddress.toHex()],
    ["marketIndex", "userAddress"],
    ["uint32", "address"],
    [userAddress],
    []
  );
}

function updateLatestTokenPrice(
  isLong: boolean,
  marketIndexId: string,
  newPrice: BigInt,
  timestamp: BigInt
): void {
  let suffixStr = isLong ? "long" : "short";
  let latestPrice = LatestPrice.load(
    "latestPrice-" + marketIndexId + "-" + suffixStr
  );

  if (latestPrice == null) {
    log.critical(
      "LATEST PRICE IS UNDEFINED - make sure it is initialised on market creation",
      []
    );
  }

  let prevPrice = Price.load(latestPrice.price);

  if (prevPrice == null) {
    log.critical(
      "PRICE IS UNDEFINED - make sure it is initialised on market creation",
      []
    );
  }

  if (prevPrice.price.notEqual(newPrice)) {
    let newPriceEntity = new Price(
      marketIndexId + "-" + suffixStr + "-" + timestamp.toString()
    );
    newPriceEntity.price = newPrice;
    newPriceEntity.timeUpdated = timestamp;
    newPriceEntity.token = prevPrice.token;

    newPriceEntity.save();

    latestPrice.price = newPriceEntity.id;
    latestPrice.save();

    let syntheticToken = SyntheticToken.load(newPriceEntity.token);
    if (syntheticToken == null) {
      log.critical("Synthetic Token with id {} is undefined.", [
        newPriceEntity.token,
      ]);
    }
    syntheticToken.priceHistory.push(newPriceEntity.id);
  }
}
