import {
  StateChange,
  EventParam,
  SystemState,
  GlobalState,
  User,
  SyntheticToken,
  UserSyntheticTokenBalance,
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
    user.totalMintedFloat = ZERO;
    user.floatTokenBalance = ZERO;
    user.tokenBalances = [];
    user.tokenMints = [];
  }

  return user;
}

export function getOrCreateBalanceObject(
  tokenAddressString: string,
  userAddressString: string
): UserSyntheticTokenBalance | null {
  let balance = UserSyntheticTokenBalance.load(
    tokenAddressString + "-" + userAddressString + "-balance"
  );

  if (balance == null) {
    balance = new UserSyntheticTokenBalance(
      tokenAddressString + "-" + userAddressString + "-balance"
    );

    let user = User.load(userAddressString);
    balance.user = user.id;

    let token = SyntheticToken.load(tokenAddressString);
    balance.syntheticToken = token.id;

    balance.tokenBalance = ZERO;
  }

  return balance;
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
    syntheticToken.tokenSupply = ZERO;
    syntheticToken.floatMintedFromSpecificToken = ZERO;
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
