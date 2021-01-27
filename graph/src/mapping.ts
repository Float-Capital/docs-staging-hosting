import {
  feesLevied,
  interestDistribution,
  longMinted,
  longRedeem,
  priceUpdate,
  shortMinted,
  shortRedeem,
  tokenPriceRefreshed,
} from "../generated/LongShort/LongShort";
import { StateChange, EventParam, EventParams } from "../generated/schema";
import { BigInt, Address, Bytes, log } from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";

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

export function handlefeesLevied(event: feesLevied): void {
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
    "feesLevied",
    bigIntArrayToStringArray([totalFees, longPercentage, shortPercentage]),
    ["totalFees", "longPercentage", "shortPercentage"],
    ["uint256", "uint256", "uint256"]
  );
}

export function handleinterestDistribution(event: interestDistribution): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let newTotalValueLocked = event.params.newTotalValueLocked;
  let totalInterest = event.params.totalInterest;
  let longPercentage = event.params.longPercentage;
  let shortPercentage = event.params.shortPercentage;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "interestDistribution",
    bigIntArrayToStringArray([newTotalValueLocked, totalInterest, longPercentage, shortPercentage]),
    ["newValueTotalLocked", "totalInterest", "longPercentage", "shortPercentage"],
    ["uint256", "uint256", "uint256", "uint256"]
  );
}

export function handlelongMinted(event: longMinted): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let depositAdded = event.params.depositAdded;
  let finalDepositAmount = event.params.finalDepositAmount;
  let tokensMinted = event.params.tokensMinted;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "longMinted",
    bigIntArrayToStringArray([depositAdded, finalDepositAmount, tokensMinted]),
    ["depositAdded", "finalDepositAmount", "tokensMinted"],
    ["uint256", "uint256", "uint256"]
  );
}

export function handlelongRedeem(event: longRedeem): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let tokensRedeemed = event.params.tokensRedeemed;
  let valueOfRedemption = event.params.valueOfRedemption;
  let finalRedeemValue = event.params.finalRedeemValue;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "longRedeem",
    bigIntArrayToStringArray([tokensRedeemed, valueOfRedemption, finalRedeemValue]),
    ["tokensRedeemed", "valueOfRedemption", "finalRedeem"],
    ["uint256", "uint256", "uint256"]
  );
}

export function handlepriceUpdate(event: priceUpdate): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;
  let newPrice = event.params.newPrice;
  let oldPrice = event.params.oldPrice;


  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "priceUpdate",
    bigIntArrayToStringArray([newPrice, oldPrice]),
    ["newPrice", "oldPrice"],
    ["uint256", "uint256"]
  );
}

export function handleshortMinted(event: shortMinted): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let depositAdded = event.params.depositAdded;
  let finalDepositAmount = event.params.finalDepositAmount;
  let tokensMinted = event.params.tokensMinted;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "shortMinted",
    bigIntArrayToStringArray([depositAdded, finalDepositAmount, tokensMinted]),
    ["depositAdded", "finalDepositAmount", "tokensMinted"],
    ["uint256", "uint256", "uint256"]
  );
}

export function handleshortRedeem(event: shortRedeem): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let tokensRedeemed = event.params.tokensRedeemed;
  let valueOfRedemption = event.params.valueOfRedemption;
  let finalRedeemValue = event.params.finalRedeemValue;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "shortRedeem",
    bigIntArrayToStringArray([tokensRedeemed, valueOfRedemption, finalRedeemValue]),
    ["tokensRedeemed", "valueOfRedemption", "finalRedeemValue"],
    ["uint256", "uint256", "uint256"]
  );
}

export function handletokenPriceRefreshed(event: tokenPriceRefreshed): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let longTokenPrice = event.params.longTokenPrice;
  let shortTokenPrice = event.params.shortTokenPrice;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "tokenPriceRefreshed",
    bigIntArrayToStringArray([longTokenPrice, shortTokenPrice]),
    ["longTokenPrice", "shortTokenPrice"],
    ["uint256", "uint256"]
  );
}

// currently all params are BigInts -> in future may have to modify to support e.g. Addresses
function bigIntArrayToStringArray(bigIntArr: BigInt[]): string[]{
  let returnArr = new Array<string>(bigIntArr.length);
  for (let i = 0; i < bigIntArr.length; i++){
    returnArr[i] = bigIntArr[i].toString();
  }
  return returnArr;
}
