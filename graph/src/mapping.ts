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

export function handleinterestDistribution(event: interestDistribution): void {}

export function handlelongMinted(event: longMinted): void {}

export function handlelongRedeem(event: longRedeem): void {}

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
    "feesLevied",
    [newPriceStr, oldPriceStr],
    ["newPrice", "oldPrice"],
    ["uint256", "uint256"]
  );
}

export function handleshortMinted(event: shortMinted): void {}

export function handleshortRedeem(event: shortRedeem): void {}

export function handletokenPriceRefreshed(event: tokenPriceRefreshed): void {}
