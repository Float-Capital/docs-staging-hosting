import {
  V1,
  FeesLevied,
  SyntheticTokenCreated,
  LongMinted,
  LongRedeem,
  PriceUpdate,
  ShortMinted,
  ShortRedeem,
  TokenPriceRefreshed,
  ValueLockedInSystem,
  FeesChanges,
} from "../generated/LongShort/LongShort";
import {
  SyntheticMarket,
  FeeStructure,
  GlobalState,
  Staker,
  TokenFactory,
  LongShortContract,
  SyntheticToken,
  LatestPrice,
  Price,
} from "../generated/schema";
import { BigInt, log } from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";
import {
  getOrCreateLatestSystemState,
  getOrCreateStakerState,
  createSyntheticTokenLong,
  createSyntheticTokenShort,
  createInitialSystemState,
} from "./utils/globalStateManager";
import {
  createNewTokenDataSource,
  increaseUserMints,
} from "./utils/helperFunctions";
import {
  ZERO,
  GLOBAL_STATE_ID,
  STAKER_ID,
  TOKEN_FACTORY_ID,
  LONG_SHORT_ID,
} from "./CONSTANTS";

export function handleV1(event: V1): void {
  log.warning("I WAS ALREADY CALLEDDD!!!!", [])
  // event V1(address admin, address tokenFactory, address staker);

  let admin = event.params.admin;
  let tokenFactoryParam = event.params.tokenFactory;
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

  let globalState = new GlobalState(GLOBAL_STATE_ID);
  globalState.contractVersion = BigInt.fromI32(1);
  globalState.latestMarketIndex = ZERO;
  globalState.staker = staker.id;
  globalState.tokenFactory = tokenFactory.id;
  globalState.adminAddress = event.params.admin;
  globalState.longShort = longShort.id;
  globalState.totalFloatMinted = ZERO;
  globalState.totalTxs = ZERO;
  globalState.totalGasUsed = ZERO;
  globalState.totalUsers = ZERO;
  globalState.timestampLaunched = event.block.timestamp;
  globalState.txHash = event.transaction.hash;
  globalState.save();

  saveEventToStateChange(
    event,
    "V1",
    [admin.toHex(), tokenFactoryString, stakerString],
    ["admin", "tokenFactory", "staker"],
    ["address", "address", "address"],
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

export function handleValueLockedInSystem(event: ValueLockedInSystem): void {
  let marketIndex = event.params.marketIndex;
  let totalValueLockedInMarket = event.params.totalValueLockedInMarket;
  let longValue = event.params.longValue;
  let shortValue = event.params.shortValue;
  let txHash = event.transaction.hash;

  let systemState = getOrCreateLatestSystemState(
    marketIndex,
    txHash,
    event
  );
  systemState.totalValueLocked = totalValueLockedInMarket;
  systemState.totalLockedLong = longValue;
  systemState.totalLockedShort = shortValue;

  systemState.save();

  saveEventToStateChange(
    event,
    "ValueLockedInSystem",
    bigIntArrayToStringArray([
      marketIndex,
      totalValueLockedInMarket,
      longValue,
      shortValue,
    ]),
    [
      "marketIndex",
      "totalValueLockedInMarket",
      "longValue",
      "shortValue",
    ],
    ["uint256", "uint256", "uint256", "uint256"],
    [],
    []
  );
}

export function handleSyntheticTokenCreated(
  event: SyntheticTokenCreated
): void {
  log.warning("Create synthetic token",[])
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let longTokenAddress = event.params.longTokenAddress;
  let shortTokenAddress = event.params.shortTokenAddress;
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
  syntheticMarket.feeStructure = fees.id;
  syntheticMarket.kPeriod = ZERO;
  syntheticMarket.kMultiplier = ZERO;
  initialState.systemState.syntheticPrice = initialAssetPrice; // change me

  let globalState = GlobalState.load(GLOBAL_STATE_ID);
  globalState.latestMarketIndex = globalState.latestMarketIndex.plus(
    BigInt.fromI32(1)
  );

  let initialLongStakerState = getOrCreateStakerState(
    shortToken.id,
    ZERO,
    event
  );
  longToken.syntheticMarket = syntheticMarket.id;
  longToken.latestPrice = initialState.latestTokenPriceLong.id;
  longToken.priceHistory = [initialState.tokenPriceLong.id];
  longToken.latestStakerState = initialLongStakerState.id;

  let initialShortStakerState = getOrCreateStakerState(
    shortToken.id,
    ZERO,
    event
  );
  shortToken.syntheticMarket = syntheticMarket.id;
  shortToken.latestPrice = initialState.latestTokenPriceShort.id;
  shortToken.priceHistory = [initialState.tokenPriceShort.id];
  shortToken.latestStakerState = initialShortStakerState.id;

  initialLongStakerState.save();
  initialShortStakerState.save();
  longToken.save();
  shortToken.save();
  initialState.systemState.save();
  syntheticMarket.save();
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
    ],
    [
      "marketIndex",
      "longTokenAddress",
      "shortTokenAddress",
      "assetPrice",
      "name",
      "symbol",
      "oracleAddress",
    ],
    ["uint256", "address", "address", "uint256", "string", "string", "address"],
    [],
    []
  );
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
    ["uint256", "uint256", "uint256", "uint256", "uint256"],
    [],
    []
  );
}

export function handleLongMinted(event: LongMinted): void {
  let marketIndex = event.params.marketIndex;
  let depositAdded = event.params.depositAdded;
  let finalDepositAmount = event.params.finalDepositAmount;
  let tokensMinted = event.params.tokensMinted;
  let userAddress = event.params.user;

  let market = SyntheticMarket.load(marketIndex.toString());
  let syntheticToken = SyntheticToken.load(market.syntheticLong);

  increaseUserMints(userAddress, syntheticToken, tokensMinted, event);

  saveEventToStateChange(
    event,
    "LongMinted",
    bigIntArrayToStringArray([
      marketIndex,
      depositAdded,
      finalDepositAmount,
      tokensMinted,
    ]).concat([userAddress.toHex()]),
    [
      "marketIndex",
      "depositAdded",
      "finalDepositAmount",
      "tokensMinted",
      "user",
    ],
    ["uint256", "uint256", "uint256", "uint256", "address"],
    [userAddress],
    []
  );
}

export function handleLongRedeem(event: LongRedeem): void {
  let marketIndex = event.params.marketIndex;
  let tokensRedeemed = event.params.tokensRedeemed;
  let valueOfRedemption = event.params.valueOfRedemption;
  let finalRedeemValue = event.params.finalRedeemValue;
  let user = event.params.user;

  saveEventToStateChange(
    event,
    "LongRedeem",
    bigIntArrayToStringArray([
      marketIndex,
      tokensRedeemed,
      valueOfRedemption,
      finalRedeemValue,
    ]).concat([user.toHex()]),
    [
      "marketIndex",
      "tokensRedeemed",
      "valueOfRedemption",
      "finalRedeem",
      "user",
    ],
    ["uint256", "uint256", "uint256", "uint256", "address"],
    [user],
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

  let systemState = getOrCreateLatestSystemState(
    marketIndex,
    txHash,
    event
  );
  systemState.syntheticPrice = newPrice;
  syntheticMarket.latestSystemState = systemState.id;
  systemState.save();
  syntheticMarket.save();

  saveEventToStateChange(
    event,
    "PriceUpdate",
    bigIntArrayToStringArray([
      marketIndex,
      oldPrice,
      newPrice,
    ]).concat([user.toHex()]),
    ["marketIndex", "newPrice", "oldPrice", "user"],
    ["uint256", "uint256", "uint256", "address"],
    [user],
    []
  );
}

export function handleShortMinted(event: ShortMinted): void {
  let marketIndex = event.params.marketIndex;
  let depositAdded = event.params.depositAdded;
  let finalDepositAmount = event.params.finalDepositAmount;
  let tokensMinted = event.params.tokensMinted;
  let userAddress = event.params.user;

  let market = SyntheticMarket.load(marketIndex.toString());
  let syntheticToken = SyntheticToken.load(market.syntheticShort);

  increaseUserMints(userAddress, syntheticToken, tokensMinted, event);

  saveEventToStateChange(
    event,
    "ShortMinted",
    bigIntArrayToStringArray([
      marketIndex,
      depositAdded,
      finalDepositAmount,
      tokensMinted,
    ]).concat([userAddress.toHex()]),
    [
      "marketIndex",
      "depositAdded",
      "finalDepositAmount",
      "tokensMinted",
      "user",
    ],
    ["uint256",  "uint256", "uint256", "uint256", "address"],
    [userAddress],
    []
  );
}

export function handleShortRedeem(event: ShortRedeem): void {
  let marketIndex = event.params.marketIndex;
  let tokensRedeemed = event.params.tokensRedeemed;
  let valueOfRedemption = event.params.valueOfRedemption;
  let finalRedeemValue = event.params.finalRedeemValue;
  let user = event.params.user;

  saveEventToStateChange(
    event,
    "ShortRedeem",
    bigIntArrayToStringArray([
      marketIndex,
      tokensRedeemed,
      valueOfRedemption,
      finalRedeemValue,
    ]).concat([user.toHex()]),
    [
      "marketIndex",
      "tokensRedeemed",
      "valueOfRedemption",
      "finalRedeem",
      "user",
    ],
    ["uint256", "uint256", "uint256", "uint256", "address"],
    [user],
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
    newPriceEntity.timeUpdated = newPrice;
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
export function handleTokenPriceRefreshed(event: TokenPriceRefreshed): void {
  let marketIndex = event.params.marketIndex;
  let marketIndexString = marketIndex.toString();
  let longTokenPrice = event.params.longTokenPrice;
  let shortTokenPrice = event.params.shortTokenPrice;
  let timestamp = event.block.timestamp;
  let txHash = event.transaction.hash;


  let syntheticMarket = SyntheticMarket.load(marketIndexString);

  let systemState = getOrCreateLatestSystemState(
    marketIndex,
    txHash,
    event
  );

  syntheticMarket.latestSystemState = systemState.id;
  systemState.save();
  syntheticMarket.save();

  updateLatestTokenPrice(true, marketIndexString, longTokenPrice, timestamp);
  updateLatestTokenPrice(false, marketIndexString, shortTokenPrice, timestamp);

  saveEventToStateChange(
    event,
    "TokenPriceRefreshed",
    bigIntArrayToStringArray([
      marketIndex,
      longTokenPrice,
      shortTokenPrice,
    ]),
    ["marketIndex", "longTokenPrice", "shortTokenPrice"],
    ["uint256", "uint256", "uint256"],
    [],
    []
  );
}

// currently all params are BigInts -> in future may have to modify to support e.g. Addresses
function bigIntArrayToStringArray(bigIntArr: BigInt[]): string[] {
  let returnArr = new Array<string>(bigIntArr.length);
  for (let i = 0; i < bigIntArr.length; i++) {
    returnArr[i] = bigIntArr[i].toString();
  }
  return returnArr;
}
