import { EVENT } from "../generated/LongShort/LongShort";
import {
  Entity,
  StateChange,
  EventParam,
  EventParams,
} from "../generated/schema";
import { BigInt, Address, Bytes, log } from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";

export function handleEvent(event: EVENT): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "EVENT",
    [eventParam1, eventParam2],
    ["eventParam1", "eventParam2"],
    ["eventParamType", "eventParamType"]
  );
}
