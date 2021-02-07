import {
  StateChange,
  EventParam,
  SystemState,
  GlobalState,
} from "../../generated/schema";
import { BigInt, Address, Bytes, log, ethereum } from "@graphprotocol/graph-ts";
import { ZERO } from "../CONSTANTS";

export function getOrCreateLatestSystemState(
  latestStateChangeCounter: BigInt,
  event: ethereum.Event
): SystemState | null {
  let systemStateId = latestStateChangeCounter.toString();
  let latestSystemState = SystemState.load(systemStateId);
  if (latestSystemState == null) {
    latestSystemState = new SystemState(systemStateId);
    latestSystemState.timestamp = event.block.timestamp;
    latestSystemState.txHash = event.transaction.hash;
    latestSystemState.blockNumber = event.block.number;
    latestSystemState.marketIndex = ZERO;
    latestSystemState.syntheticPrice = ZERO;
    latestSystemState.longTokenPrice = ZERO;
    latestSystemState.shortTokenPrice = ZERO;
    latestSystemState.totalLockedLong = ZERO;
    latestSystemState.totalLockedShort = ZERO;
    latestSystemState.totalValueLocked = ZERO;
    latestSystemState.setBy = event.transaction.from;
  }
  return latestSystemState;
}
