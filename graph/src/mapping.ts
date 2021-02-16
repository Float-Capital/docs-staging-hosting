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
  LongShort,
} from "../generated/LongShort/LongShort";

import {
  StateChange,
  EventParam,
  EventParams,
  SyntheticMarket,
  SyntheticToken,
  FeeStructure,
  GlobalState,
  OracleAgregator,
  YieldManager,
  Staker,
  TokenFactory,
  LongShort,
} from "../generated/schema";
import { BigInt, Address, Bytes, log } from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";
import { getOrCreateLatestSystemState } from "./utils/globalStateManager";
import {
  ZERO,
  TEN_TO_THE_18,
  GLOBAL_STATE_ID,
  YIELD_MANAGER_ID,
  ORACLE_AGREGATOR_ID,
  STAKER_ID,
  TOKEN_FACTORY_ID,
  LONG_SHORT_ID,
} from "./CONSTANTS";

// export function handleEvent(event: EVENT): void {
//   let txHash = event.transaction.hash;
//   let blockNumber = event.block.number;
//   let timestamp = event.block.timestamp;

//   saveEventToStateChange(
//     txHash,
//     timestamp,
//     blockNumber,
//     "EVENT",
//     ["a", "b"],
//     ["eventParam1", "eventParam2"],
//     ["eventParamType", "eventParamType"]
//   );
// }

export function handleV1(event: V1): void {
  // This function will only ever get called once
  if (GlobalState.load(GLOBAL_STATE_ID) != null) {
    log.critical("the event was emitted more than once!", []);
  }

  let longShort = new LongShort(LONG_SHORT_ID);
  longShort.address = event.address;
  longShort.save();

  let tokenFactory = new TokenFactory(TOKEN_FACTORY_ID);
  tokenFactory.address = event.params.tokenFactory;
  tokenFactory.save();

  let staker = new Staker(STAKER_ID);
  staker.address = event.params.staker;
  staker.save();

  let oracleAgregator = new OracleAgregator(ORACLE_AGREGATOR_ID);
  oracleAgregator.address = event.params.oracleAgregator;
  oracleAgregator.save();

  let yieldManager = new YieldManager(YIELD_MANAGER_ID);
  yieldManager.address = event.params.yieldManager;
  yieldManager.save();

  let globalState = new GlobalState(GLOBAL_STATE_ID);
  globalState.contractVersion = BigInt.fromI32(1);
  globalState.yieldManager = yieldManager.id;
  globalState.oracleAgreagator = oracleAgregator.id;
  globalState.staker = staker.id;
  globalState.tokenFactory = tokenFactory.id;
  globalState.adminAddress = event.params.admin;
  globalState.longShort = longShort.id;
  globalState.save();
}

export function handleFeesLevied(event: FeesLevied): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let totalFees = event.params.totalFees;
  let longPercentage = event.params.longPercentage;
  let shortPercentage = event.params.shortPercentage;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "FeesLevied",
    bigIntArrayToStringArray([totalFees, longPercentage, shortPercentage]),
    ["totalFees", "longPercentage", "shortPercentage"],
    ["uint256", "uint256", "uint256"]
  );
}

export function handleValueLockedInSystem(event: ValueLockedInSystem): void {
  //Void
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let contractCallCounter = event.params.contractCallCounter;
  let totalValueLocked = event.params.totalValueLockedInMarket;
  let longValue = event.params.longValue;
  let shortValue = event.params.shortValue;

  let state = getOrCreateLatestSystemState(
    marketIndex,
    contractCallCounter,
    event
  );
  state.totalValueLocked = totalValueLocked;
  state.totalLockedLong = longValue;
  state.totalLockedShort = shortValue;
  state.save();
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
  let initialAssetPrice = event.params.assetPrice;

  let oracleAddress = event.params.oracleAddress;
  let syntheticName = event.params.name;
  let syntheticSymbol = event.params.symbol;

  let baseEntryFee = event.params.baseEntryFee;
  let badLiquidityEntryFee = event.params.badLiquidityEntryFee;
  let baseExitFee = event.params.baseExitFee;
  let badLiquidityExitFee = event.params.badLiquidityExitFee;

  let marketIndexString = marketIndex.toString();

  let state = getOrCreateLatestSystemState(marketIndex, ZERO, event);

  let fees = new FeeStructure(
    marketIndexString + "-fees-" + longTokenAddress.toHexString()
  );
  fees.baseEntryFee = baseEntryFee;
  fees.badLiquidityEntryFee = badLiquidityEntryFee;
  fees.baseExitFee = baseExitFee;
  fees.badLiquidityExitFee = badLiquidityExitFee;

  // create new synthetic token object.
  let longToken = new SyntheticToken(
    marketIndexString + "-" + longTokenAddress.toHexString()
  );
  longToken.tokenAddress = longTokenAddress;
  longToken.tokenPrice = TEN_TO_THE_18;
  longToken.tokenSupply = ZERO;
  longToken.totalValueLocked = ZERO;

  let shortToken = new SyntheticToken(
    marketIndexString + "-" + shortTokenAddress.toHexString()
  );
  shortToken.tokenAddress = shortTokenAddress;
  shortToken.tokenPrice = TEN_TO_THE_18;
  shortToken.tokenSupply = ZERO;
  shortToken.totalValueLocked = ZERO;

  let syntheticMarket = new SyntheticMarket(marketIndexString);
  syntheticMarket.timestampCreated = timestamp;
  syntheticMarket.txHash = txHash;
  syntheticMarket.blockNumberCreated = blockNumber;
  syntheticMarket.name = syntheticName;
  syntheticMarket.symbol = syntheticSymbol;
  syntheticMarket.latestSystemState = state.id;
  syntheticMarket.syntheticLong = longToken.id;
  syntheticMarket.syntheticShort = shortToken.id;
  syntheticMarket.marketIndex = marketIndex;
  syntheticMarket.totalValueLockedInMarket = ZERO;
  syntheticMarket.oracleAddress = oracleAddress;
  syntheticMarket.feeStructure = fees.id;

  state.syntheticPrice = initialAssetPrice; // change me

  longToken.save();
  shortToken.save();
  state.save();
  syntheticMarket.save();
  fees.save();

  // Add below back later
  // saveEventToStateChange(
  //   txHash,
  //   timestamp,
  //   blockNumber,
  //   "InterestDistribution",
  //   bigIntArrayToStringArray([
  //     newTotalValueLocked,
  //     totalInterest,
  //     longPercentage,
  //     shortPercentage,
  //   ]),
  //   [
  //     "newValueTotalLocked",
  //     "totalInterest",
  //     "longPercentage",
  //     "shortPercentage",
  //   ],
  //   ["uint256", "uint256", "uint256", "uint256"]
  // );
}

export function handleLongMinted(event: LongMinted): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let depositAdded = event.params.depositAdded;
  let finalDepositAmount = event.params.finalDepositAmount;
  let tokensMinted = event.params.tokensMinted;
  let user = event.params.user;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "LongMinted",
    bigIntArrayToStringArray([
      depositAdded,
      finalDepositAmount,
      tokensMinted,
    ]).concat([user.toHex()]),
    ["depositAdded", "finalDepositAmount", "tokensMinted", "user"],
    ["uint256", "uint256", "uint256", "address"]
  );
}

export function handleLongRedeem(event: LongRedeem): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let tokensRedeemed = event.params.tokensRedeemed;
  let valueOfRedemption = event.params.valueOfRedemption;
  let finalRedeemValue = event.params.finalRedeemValue;
  let user = event.params.user;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "LongRedeem",
    bigIntArrayToStringArray([
      tokensRedeemed,
      valueOfRedemption,
      finalRedeemValue,
    ]).concat([user.toHex()]),
    ["tokensRedeemed", "valueOfRedemption", "finalRedeem", "user"],
    ["uint256", "uint256", "uint256", "address"]
  );
}

export function handlePriceUpdate(event: PriceUpdate): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let contractCallCounter = event.params.contractCallCounter;
  let newPrice = event.params.newPrice;
  let oldPrice = event.params.oldPrice;
  let user = event.params.user;

  let state = getOrCreateLatestSystemState(
    marketIndex,
    contractCallCounter,
    event
  );
  state.syntheticPrice = newPrice;
  state.save();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "PriceUpdate",
    bigIntArrayToStringArray([newPrice, oldPrice]).concat([user.toHex()]),
    ["newPrice", "oldPrice", "user"],
    ["uint256", "uint256", "address"]
  );
}

export function handleShortMinted(event: ShortMinted): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let depositAdded = event.params.depositAdded;
  let finalDepositAmount = event.params.finalDepositAmount;
  let tokensMinted = event.params.tokensMinted;
  let user = event.params.user;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "ShortMinted",
    bigIntArrayToStringArray([
      depositAdded,
      finalDepositAmount,
      tokensMinted,
    ]).concat([user.toHex()]),
    ["depositAdded", "finalDepositAmount", "tokensMinted", "user"],
    ["uint256", "uint256", "uint256", "address"]
  );
}

export function handleShortRedeem(event: ShortRedeem): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let tokensRedeemed = event.params.tokensRedeemed;
  let valueOfRedemption = event.params.valueOfRedemption;
  let finalRedeemValue = event.params.finalRedeemValue;
  let user = event.params.user;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "ShortRedeem",
    bigIntArrayToStringArray([
      tokensRedeemed,
      valueOfRedemption,
      finalRedeemValue,
    ]).concat([user.toHex()]),
    ["tokensRedeemed", "valueOfRedemption", "finalRedeemValue", "user"],
    ["uint256", "uint256", "uint256", "address"]
  );
}

export function handleTokenPriceRefreshed(event: TokenPriceRefreshed): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let longTokenPrice = event.params.longTokenPrice;
  let shortTokenPrice = event.params.shortTokenPrice;

  let contractCallCounter = event.params.contractCallCounter;

  let state = getOrCreateLatestSystemState(
    marketIndex,
    contractCallCounter,
    event
  );
  state.longTokenPrice = longTokenPrice;
  state.shortTokenPrice = shortTokenPrice;
  state.save();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "TokenPriceRefreshed",
    bigIntArrayToStringArray([longTokenPrice, shortTokenPrice]),
    ["longTokenPrice", "shortTokenPrice"],
    ["uint256", "uint256"]
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
