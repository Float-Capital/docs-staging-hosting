import {
  StateChange,
  EventParam,
  SystemState,
  GlobalState,
} from "../../generated/schema";
import { BigInt, Address, Bytes, log, ethereum } from "@graphprotocol/graph-ts";
import { ZERO } from "../CONSTANTS";

export function getOrCreateLatestSystemState(
  marketIndex: BigInt,
  latestStateChangeCounter: BigInt,
  event: ethereum.Event
): SystemState | null {
  let systemStateId = latestStateChangeCounter.toString();
  let marketIndexId = marketIndex.toString();
  let latestSystemState = SystemState.load(marketIndexId + "-" + systemStateId);
  if (latestSystemState == null) {
    latestSystemState = new SystemState(marketIndexId + "-" + systemStateId);
    latestSystemState.timestamp = event.block.timestamp;
    latestSystemState.txHash = event.transaction.hash;
    latestSystemState.blockNumber = event.block.number;
    latestSystemState.marketIndex = marketIndex;
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
