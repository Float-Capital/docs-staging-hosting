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

  let totalFeesStr = totalFees.toString();
  let longPercentageStr = longPercentage.toString();
  let shortPercentageStr = shortPercentage.toString();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "feesLevied",
    [totalFeesStr, longPercentageStr, shortPercentageStr],
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

  let newTotalValueLockedStr = newTotalValueLocked.toString();
  let totalInterestStr = totalInterest.toString();
  let longPercentageStr = longPercentage.toString();
  let shortPercentageStr = shortPercentage.toString();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "interestDistribution",
    [newTotalValueLockedStr, totalInterestStr, longPercentageStr, shortPercentageStr],
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

  let depositAddedStr =  depositAdded.toString();
  let finalDepositAmountStr = finalDepositAmount.toString();
  let tokensMintedStr = tokensMinted.toString();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "longMinted",
    [depositAddedStr, finalDepositAmountStr, tokensMintedStr],
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

  let tokensRedeemedStr = tokensRedeemed.toString();
  let valueOfRedemptionStr = valueOfRedemption.toString();
  let finalRedeemValueStr = finalRedeemValue.toString();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "longRedeem",
    [tokensRedeemedStr, valueOfRedemptionStr, finalRedeemValueStr],
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

  let newPriceStr = newPrice.toString();
  let oldPriceStr = oldPrice.toString();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "priceUpdate",
    [newPriceStr, oldPriceStr],
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

  let depositAddedStr = depositAdded.toString();
  let finalDepositAmountStr = finalDepositAmount.toString();
  let tokensMintedStr = tokensMinted.toString();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "shortMinted",
    [depositAddedStr, finalDepositAmountStr, tokensMintedStr],
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

  let tokensRedeemedStr = tokensRedeemed.toString();
  let valueOfRedemptionStr = valueOfRedemption.toString();
  let finalRedeemValueStr = finalRedeemValue.toString();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "shortRedeem",
    [tokensRedeemedStr, valueOfRedemptionStr, finalRedeemValueStr],
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

  let longTokenPriceStr = longTokenPrice.toString();
  let shortTokenPriceStr = shortTokenPrice.toString();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "tokenPriceRefreshed",
    [longTokenPriceStr, shortTokenPriceStr],
    ["longTokenPrice", "shortTokenPrice"],
    ["uint256", "uint256"]
  );
}
