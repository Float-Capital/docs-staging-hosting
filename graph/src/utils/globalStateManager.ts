import {
  StateChange,
  EventParam,
  SystemState,
  GlobalState,
  User,
  SyntheticToken,
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

export function getOrCreateUser(address: Bytes): User | null {
  let user = User.load(address.toHex());
  if (user == null) {
    user = new User(address.toHex());
    user.address = address;
  }

  return user;
}

export function createSyntheticToken(
  tokenAddress: Bytes
): SyntheticToken | null {
  let tokenAddressString = tokenAddress.toHex();
  let syntheticToken = SyntheticToken.load(tokenAddressString);
  if (syntheticToken == null) {
    syntheticToken = new SyntheticToken(tokenAddressString);
    syntheticToken.tokenAddress = tokenAddress;
    syntheticToken.totalStaked = ZERO;
  }
  return syntheticToken;
}

export function createSyntheticTokenLong(
  tokenAddress: Bytes
): SyntheticToken | null {
  let syntheticToken = createSyntheticToken(tokenAddress);
  syntheticToken.tokenType = "Long";

  return syntheticToken;
}
export function createSyntheticTokenShort(
  tokenAddress: Bytes
): SyntheticToken | null {
  let syntheticToken = createSyntheticToken(tokenAddress);
  syntheticToken.tokenType = "Short";

  return syntheticToken;
}
