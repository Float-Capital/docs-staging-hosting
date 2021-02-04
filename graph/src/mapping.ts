import {
  FeesLevied,
  InterestDistribution,
  LongMinted,
  LongRedeem,
  PriceUpdate,
  ShortMinted,
  ShortRedeem,
  TokenPriceRefreshed,
  ValueLockedInSystem,
} from "../generated/LongShort/LongShort";

import { StateChange, EventParam, EventParams } from "../generated/schema";
import { BigInt, Address, Bytes, log } from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";
import { getOrCreateLatestSystemState } from "./utils/globalStateManager";

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

export function handleFeesLevied(event: FeesLevied): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;
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
  
  let contractCallCounter = event.params.contractCallCounter;
  let totalValueLocked = event.params.totalValueLocked;
  let longValue = event.params.longValue;
  let shortValue = event.params.shortValue;

  let state = getOrCreateLatestSystemState(contractCallCounter, event);
  state.totalValueLocked = totalValueLocked;
  state.totalLockedLong = longValue;
  state.totalLockedShort = shortValue;
  state.save();
}


export function handleInterestDistribution(event: InterestDistribution): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let contractCallCounter = event.params.contractCallCounter;
  let newTotalValueLocked = event.params.newTotalValueLocked;
  let totalInterest = event.params.totalInterest;
  let longPercentage = event.params.longPercentage;
  let shortPercentage = event.params.shortPercentage;

  // let state = getOrCreateLatestSystemState(contractCallCounter, event);
  // state.save();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "InterestDistribution",
    bigIntArrayToStringArray([
      newTotalValueLocked,
      totalInterest,
      longPercentage,
      shortPercentage,
    ]),
    [
      "newValueTotalLocked",
      "totalInterest",
      "longPercentage",
      "shortPercentage",
    ],
    ["uint256", "uint256", "uint256", "uint256"]
  );
}

export function handleLongMinted(event: LongMinted): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

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

  let contractCallCounter = event.params.contractCallCounter;
  let newPrice = event.params.newPrice;
  let oldPrice = event.params.oldPrice;
  let user = event.params.user;

  let state = getOrCreateLatestSystemState(contractCallCounter, event);
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

  let longTokenPrice = event.params.longTokenPrice;
  let shortTokenPrice = event.params.shortTokenPrice;

  let contractCallCounter = event.params.contractCallCounter;

  let state = getOrCreateLatestSystemState(contractCallCounter, event);
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
