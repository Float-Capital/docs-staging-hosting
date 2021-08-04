import {
  LongShortV1,
  SyntheticMarketCreated,
  SystemStateUpdated,
  OracleUpdated,
  NextPriceDeposit,
  NewMarketLaunchedAndSeeded,
  NextPriceRedeem,
  ExecuteNextPriceSettlementsUser,
  ExecuteNextPriceRedeemSettlementUser,
  ExecuteNextPriceMintSettlementUser,
} from "../generated/LongShort/LongShort";
import {
  SyntheticMarket,
  GlobalState,
  Staker,
  TokenFactory,
  LongShortContract,
  SyntheticToken,
  PaymentToken,
  LatestPrice,
  Price,
  LatestUnderlyingPrice,
  UnderlyingPrice,
} from "../generated/schema";
import { BigInt, log, Bytes, Address } from "@graphprotocol/graph-ts";
import {
  bigIntArrayToStringArray,
  saveEventToStateChange,
} from "./utils/txEventHelpers";
import {
  getOrCreateLatestSystemState,
  getOrCreateAccumulativeFloatIssuanceSnapshot,
  createSyntheticTokenLong,
  createSyntheticTokenShort,
  createInitialSystemState,
  updateOrCreatePaymentToken,
  getOrCreateGlobalState,
  getAccumulativeFloatIssuanceSnapshotId,
  getUser,
  getSyntheticMarket,
  getSyntheticTokenById,
  getSyntheticTokenByMarketIdAndTokenType,
} from "./utils/globalStateManager";
import {
  createNewTokenDataSource,
  increaseUserMints,
  updateBalanceTransfer,
  updateUserBalance,
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

export function handleLongShortV1(event: LongShortV1): void {
  // event LongShortV1(address admin, address tokenFactory, address staker);

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
    "LongShortV1",
    [admin.toHex(), treasury.toHex(), tokenFactoryString, stakerString],
    ["admin", "treasury", "tokenFactory", "staker"],
    ["address", "address", "address", "address"],
    [],
    []
  );
}

export function handleSystemStateUpdated(event: SystemStateUpdated): void {
  let marketIndex = event.params.marketIndex;
  let marketIndexString = marketIndex.toString();
  let longValue = event.params.longValue;
  let updateIndex = event.params.updateIndex;
  let underlyingAssetPrice = event.params.underlyingAssetPrice;
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
  updateLatestUnderlyingPrice(
    marketIndexString,
    underlyingAssetPrice,
    timestamp
  );

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

      let hasMint = tokensMintedLong.gt(ZERO) || tokensMintedShort.gt(ZERO);

      if (hasMint) {
        increaseUserMints(user, syntheticTokenLong, tokensMintedLong);
        increaseUserMints(user, syntheticTokenShort, tokensMintedShort);
        updateUserBalance(longTokenId, user, tokensMintedLong, true, timestamp);
        updateUserBalance(
          shortTokenId,
          user,
          tokensMintedShort,
          true,
          timestamp
        );
      }

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
    "SystemStateUpdated",
    bigIntArrayToStringArray([
      marketIndex,
      updateIndex,
      underlyingAssetPrice,
      longValue,
      shortValue,
      longTokenPrice,
      shortTokenPrice,
    ]),
    [
      "marketIndex",
      "updateIndex",
      "underlyingAssetPrice",
      "longValue",
      "shortValue",
      "longPrice",
      "shortPrice",
    ],
    ["uint32", "uint256", "int256", "uint256", "uint256", "uint256", "uint256"],
    [],
    []
  );
}

export function handleSyntheticMarketCreated(
  event: SyntheticMarketCreated
): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let longTokenAddress = event.params.longTokenAddress;
  let shortTokenAddress = event.params.shortTokenAddress;
  let paymentToken = event.params.paymentToken;
  let initialAssetPrice = event.params.initialAssetPrice;
  let yieldManagerAddress = event.params.yieldManagerAddress;

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
    initialAssetPrice,
    longToken.id,
    shortToken.id
  );

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
  syntheticMarket.kPeriod = ZERO;
  syntheticMarket.kMultiplier = ZERO;
  syntheticMarket.totalFloatMinted = ZERO;
  syntheticMarket.nextPriceActions = [];
  syntheticMarket.settledNextPriceActions = [];

  // create new synthetic token object.
  let paymentTokenEntity = updateOrCreatePaymentToken(
    paymentToken,
    syntheticMarket
  );
  syntheticMarket.paymentToken = paymentTokenEntity.id;

  let globalState = GlobalState.load(GLOBAL_STATE_ID);
  if (globalState == null) {
    log.critical("Global state is null in `handleSyntheticMarketCreated`", []);
  }
  globalState.latestMarketIndex = globalState.latestMarketIndex.plus(
    BigInt.fromI32(1)
  );

  // Make sure the latest staker state has the correct ID even though the instance hasn't been created yet.
  syntheticMarket.latestAccumulativeFloatIssuanceSnapshot = getAccumulativeFloatIssuanceSnapshotId(
    marketIndexString,
    ZERO
  );

  longToken.syntheticMarket = syntheticMarket.id;
  longToken.latestPrice = initialState.latestTokenPriceLong.id;
  longToken.priceHistory = [initialState.tokenPriceLong.id];

  shortToken.syntheticMarket = syntheticMarket.id;
  shortToken.latestPrice = initialState.latestTokenPriceShort.id;
  shortToken.priceHistory = [initialState.tokenPriceShort.id];

  syntheticMarket.save();
  // This function uses the synthetic market internally, so can only be created once the synthetic market has been created.
  let initalLatestAccumulativeFloatIssuanceSnapshot = getOrCreateAccumulativeFloatIssuanceSnapshot(
    syntheticMarket,
    ZERO,
    event
  );
  paymentTokenEntity.save();
  initalLatestAccumulativeFloatIssuanceSnapshot.save();
  longToken.save();
  shortToken.save();
  initialState.systemState.save();
  globalState.save();

  saveEventToStateChange(
    event,
    "SyntheticMarketCreated",
    [
      marketIndex.toString(),
      longTokenAddress.toHex(),
      shortTokenAddress.toHex(),
      initialAssetPrice.toHex(),
      initialAssetPrice.toString(),
      syntheticName,
      syntheticSymbol,
      oracleAddress.toHex(),
      yieldManagerAddress.toHex(),
    ],
    [
      "marketIndex",
      "longTokenAddress",
      "shortTokenAddress",
      "paymentAddress",
      "initialAssetPrice",
      "name",
      "symbol",
      "oracleAddress",
      "yieldManagerAddress",
    ],
    [
      "uint32",
      "address",
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
  userNextPriceAction.confirmedTimestamp = event.block.timestamp;

  userNextPriceAction.save();
  batchedNextPriceExec.save();

  let paymentToken = PaymentToken.load(syntheticMarket.paymentToken);
  if (paymentToken == null) {
    log.critical(
      "paymentToken is undefined when it shouldn't be, entity id: {}",
      [syntheticMarket.paymentToken]
    );
  }

  decreaseOrCreateUserApprovals(
    userAddress,
    event.params.depositAdded,
    paymentToken,
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
  userNextPriceAction.confirmedTimestamp = event.block.timestamp;

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

export function handleExecuteNextPriceRedeemSettlementUser(
  event: ExecuteNextPriceRedeemSettlementUser
): void {
  let marketIndex = event.params.marketIndex;
  let userAddress = event.params.user;
  let isLong = event.params.isLong;
  let amount = event.params.amount;

  // TODO: do something something

  saveEventToStateChange(
    event,
    "ExecuteNextPriceRedeemSettlementUser",
    [
      marketIndex.toString(),
      userAddress.toHex(),
      isLong ? "true" : "false",
      amount.toString(),
    ],
    ["marketIndex", "userAddress", "isLong", "amount"],
    ["uint32", "address", "bool", "uint256"],
    [userAddress],
    []
  );
}

export function handleExecuteNextPriceMintSettlementUser(
  event: ExecuteNextPriceMintSettlementUser
): void {
  let marketIndex = event.params.marketIndex;
  let userAddress = event.params.user;
  let isLong = event.params.isLong;
  let amount = event.params.amount;

  let synthToken = getSyntheticTokenByMarketIdAndTokenType(marketIndex, isLong);

  let user = getUser(userAddress);

  // reverse double counting of tokenBalances from synth token TransferEvent
  updateUserBalance(synthToken.id, user, amount, false, event.block.timestamp);

  user.save();

  saveEventToStateChange(
    event,
    "ExecuteNextPriceMintSettlementUser",
    [
      marketIndex.toString(),
      userAddress.toHex(),
      isLong ? "true" : "false",
      amount.toString(),
    ],
    ["marketIndex", "userAddress", "isLong", "amount"],
    ["uint32", "address", "bool", "uint256"],
    [userAddress],
    []
  );
}

// TODO: refactor into helper function file
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

    // TODO: this is error prone (data write/save race condition), rather pass in the synthetic tokne!
    let syntheticToken = SyntheticToken.load(newPriceEntity.token);
    if (syntheticToken == null) {
      log.critical("Synthetic Token with id {} is undefined.", [
        newPriceEntity.token,
      ]);
    }
    syntheticToken.priceHistory.push(newPriceEntity.id);
  }
}

// TODO: refactor into helper function file
function updateLatestUnderlyingPrice(
  marketIndexId: string,
  newPrice: BigInt,
  timestamp: BigInt
): void {
  let latestPrice = LatestUnderlyingPrice.load(
    "latestPrice-" + marketIndexId + "-underlying"
  );

  if (latestPrice == null) {
    log.critical(
      "LATEST UNDERLYING PRICE IS UNDEFINED - make sure it is initialised on market creation",
      []
    );
  }

  let prevPrice = UnderlyingPrice.load(latestPrice.price);

  if (prevPrice == null) {
    log.critical(
      "UNDERLYING PRICE IS UNDEFINED - make sure it is initialised on market creation",
      []
    );
  }

  if (prevPrice.price.notEqual(newPrice)) {
    let newPriceEntity = new UnderlyingPrice(
      marketIndexId + "-underlying-" + timestamp.toString()
    );
    newPriceEntity.price = newPrice;
    newPriceEntity.timeUpdated = timestamp;
    newPriceEntity.market = prevPrice.market;

    newPriceEntity.save();

    latestPrice.price = newPriceEntity.id;
    latestPrice.save();
  }
}
