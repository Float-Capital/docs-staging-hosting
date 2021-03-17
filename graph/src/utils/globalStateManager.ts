import {
  StateChange,
  EventParam,
  SystemState,
  GlobalState,
  User,
  Price,
  SyntheticToken,
  UserSyntheticTokenBalance,
  LatestPrice,
} from "../../generated/schema";
import { BigInt, Address, Bytes, log, ethereum } from "@graphprotocol/graph-ts";
import { ZERO, ONE, GLOBAL_STATE_ID, ZERO_ADDRESS_BYTES } from "../CONSTANTS";

export function getOrCreateDefaultTokenPrice(): Price {
  let initialTokenPrice = Price.load("defaultTokenPrice");
  if (initialTokenPrice == null) {
    initialTokenPrice = new Price("defaultTokenPrice");
    initialTokenPrice.price = ZERO;
    // initialTokenPrice.tokenAddress = ZERO_ADDRESS_BYTES;
  }

  return initialTokenPrice as Price;
}

export function getOrCreateLatestSystemState(
  marketIndex: BigInt,
  latestStateChangeCounter: BigInt,
  event: ethereum.Event
): SystemState {
  let systemStateId = latestStateChangeCounter.toString();
  let marketIndexId = marketIndex.toString();
  let latestSystemState = SystemState.load(marketIndexId + "-" + systemStateId);
  if (latestSystemState == null) {
    let initialTokenPrice = getOrCreateDefaultTokenPrice();
    let longCurrentTokenPrice = new LatestPrice(
      "latestPrice-" + marketIndexId + "-long"
    );
    let shortCrrentTokenPrice = new LatestPrice(
      "latestPrice-" + marketIndexId + "-short"
    );
    latestSystemState = new SystemState(marketIndexId + "-" + systemStateId);
    latestSystemState.timestamp = event.block.timestamp;
    latestSystemState.txHash = event.transaction.hash;
    latestSystemState.blockNumber = event.block.number;
    latestSystemState.marketIndex = marketIndex;
    latestSystemState.syntheticPrice = ZERO;
    latestSystemState.longTokenPrice = longCurrentTokenPrice.id;
    latestSystemState.shortTokenPrice = shortCrrentTokenPrice.id;
    latestSystemState.totalLockedLong = ZERO;
    latestSystemState.totalLockedShort = ZERO;
    latestSystemState.totalValueLocked = ZERO;
    latestSystemState.setBy = event.transaction.from;
  }
  return latestSystemState as SystemState;
}

export function getOrCreateUser(address: Bytes, event: ethereum.Event): User {
  let user = User.load(address.toHex());
  if (user == null) {
    user = new User(address.toHex());
    user.address = address;
    user.totalMintedFloat = ZERO;
    user.floatTokenBalance = ZERO;
    user.timestampJoined = event.block.timestamp;
    user.totalGasUsed = ZERO;
    user.numberOfTransactions = ZERO;
    user.currentStakes = [];
    user.tokenBalances = [];
    user.tokenMints = [];
    user.stateChangesAffectingUser = [];

    let globalState = GlobalState.load(GLOBAL_STATE_ID);
    globalState.totalUsers = globalState.totalUsers.plus(ONE);
    globalState.save();
  }

  return user as User;
}

export function getOrCreateBalanceObject(
  tokenAddressString: string,
  userAddressString: string
): UserSyntheticTokenBalance {
  let balance = UserSyntheticTokenBalance.load(
    tokenAddressString + "-" + userAddressString + "-balance"
  );

  if (balance == null) {
    let newBalance = new UserSyntheticTokenBalance(
      tokenAddressString + "-" + userAddressString + "-balance"
    );

    let user = User.load(userAddressString);
    newBalance.user = user.id;

    let token = SyntheticToken.load(tokenAddressString);
    newBalance.syntheticToken = token.id;

    newBalance.tokenBalance = ZERO;
    newBalance.timeLastUpdated = ZERO;

    return newBalance;
  } else {
    return balance as UserSyntheticTokenBalance;
  }
}

export function createSyntheticToken(tokenAddress: Bytes): SyntheticToken {
  let tokenAddressString = tokenAddress.toHex();
  let syntheticToken = SyntheticToken.load(tokenAddressString);
  if (syntheticToken == null) {
    syntheticToken = new SyntheticToken(tokenAddressString);
    syntheticToken.tokenAddress = tokenAddress;
    syntheticToken.totalStaked = ZERO;
    syntheticToken.tokenSupply = ZERO;
    syntheticToken.floatMintedFromSpecificToken = ZERO;
  }
  return syntheticToken as SyntheticToken;
}

export function createSyntheticTokenLong(tokenAddress: Bytes): SyntheticToken {
  let syntheticToken = createSyntheticToken(tokenAddress);
  syntheticToken.tokenType = "Long";

  return syntheticToken as SyntheticToken;
}
export function createSyntheticTokenShort(tokenAddress: Bytes): SyntheticToken {
  let syntheticToken = createSyntheticToken(tokenAddress);
  syntheticToken.tokenType = "Short";

  return syntheticToken as SyntheticToken;
}
