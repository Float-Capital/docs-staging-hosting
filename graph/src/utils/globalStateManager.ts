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
  SyntheticMarket,
} from "../../generated/schema";
import { BigInt, Address, Bytes, log, ethereum } from "@graphprotocol/graph-ts";
import { ZERO, ONE, GLOBAL_STATE_ID, TEN_TO_THE_18 } from "../CONSTANTS";

function createInitialTokenPrice(
  id: string,
  tokenId: string,
  timestamp: BigInt
): Price {
  let initialTokenPrice = Price.load("defaultTokenPrice");
  if (initialTokenPrice == null) {
    initialTokenPrice = new Price("defaultTokenPrice");
    initialTokenPrice.price = TEN_TO_THE_18;
    initialTokenPrice.token = tokenId;
    initialTokenPrice.timeUpdated = timestamp;
  }

  return initialTokenPrice as Price;
}

class InitialState {
  systemState: SystemState;
  tokenPriceLong: Price;
  tokenPriceShort: Price;
  latestTokenPriceLong: LatestPrice;
  latestTokenPriceShort: LatestPrice;
}
export function createInitialSystemState(
  marketIndex: BigInt,
  latestStateChangeCounter: BigInt,
  event: ethereum.Event,
  longTokenId: string,
  shortTokenId: string
): InitialState {
  let systemStateId = latestStateChangeCounter.toString();
  let marketIndexId = marketIndex.toString();
  let timestamp = event.block.timestamp;
  let initialLongPriceId = marketIndexId + "-long-" + timestamp.toString();
  let initialShortPriceId = marketIndexId + "-short-" + timestamp.toString();

  let initialLongTokenPrice = createInitialTokenPrice(
    initialLongPriceId,
    longTokenId,
    timestamp
  );
  let initialShortTokenPrice = createInitialTokenPrice(
    initialShortPriceId,
    shortTokenId,
    timestamp
  );
  let longCurrentTokenPrice = new LatestPrice(
    "latestPrice-" + marketIndexId + "-long"
  );
  let shortCurrentTokenPrice = new LatestPrice(
    "latestPrice-" + marketIndexId + "-short"
  );
  longCurrentTokenPrice.price = initialLongTokenPrice.id;
  shortCurrentTokenPrice.price = initialShortTokenPrice.id;
  initialLongTokenPrice.save();
  initialShortTokenPrice.save();
  longCurrentTokenPrice.save();
  shortCurrentTokenPrice.save();
  let latestSystemState = new SystemState(marketIndexId + "-" + systemStateId);
  latestSystemState.timestamp = event.block.timestamp;
  latestSystemState.txHash = event.transaction.hash;
  latestSystemState.blockNumber = event.block.number;
  latestSystemState.marketIndex = marketIndex;
  latestSystemState.syntheticPrice = ZERO;
  latestSystemState.longTokenPrice = longCurrentTokenPrice.id;
  latestSystemState.shortTokenPrice = shortCurrentTokenPrice.id;
  latestSystemState.totalLockedLong = ZERO;
  latestSystemState.totalLockedShort = ZERO;
  latestSystemState.totalValueLocked = ZERO;
  latestSystemState.setBy = event.transaction.from;
  latestSystemState.longToken = longTokenId;
  latestSystemState.shortToken = shortTokenId;

  return {
    systemState: latestSystemState,
    tokenPriceLong: initialLongTokenPrice,
    tokenPriceShort: initialShortTokenPrice,
    latestTokenPriceLong: longCurrentTokenPrice,
    latestTokenPriceShort: shortCurrentTokenPrice,
  };
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
    let syntheticMarket = SyntheticMarket.load(marketIndexId);
    if (syntheticMarket == null) {
      log.critical(
        "`getOrCreateLatestSystemState` called without SyntheticMarket with id #{} being created.",
        [marketIndexId]
      );
    }
    let prevSystemState = SystemState.load(syntheticMarket.latestSystemState);
    if (prevSystemState == null) {
      log.critical(
        "SyntheticMarket with id #{} references a non-existant (null) `latestSystemState`.",
        [marketIndexId]
      );
    }

    latestSystemState = new SystemState(marketIndexId + "-" + systemStateId);
    latestSystemState.timestamp = event.block.timestamp;
    latestSystemState.txHash = event.transaction.hash;
    latestSystemState.blockNumber = event.block.number;
    latestSystemState.marketIndex = marketIndex;
    latestSystemState.syntheticPrice = prevSystemState.syntheticPrice;
    latestSystemState.longTokenPrice = prevSystemState.longTokenPrice;
    latestSystemState.shortTokenPrice = prevSystemState.shortTokenPrice;
    latestSystemState.totalLockedLong = prevSystemState.totalLockedLong;
    latestSystemState.totalLockedShort = prevSystemState.totalLockedShort;
    latestSystemState.totalValueLocked = prevSystemState.totalValueLocked;
    latestSystemState.setBy = event.transaction.from;
    latestSystemState.longToken = prevSystemState.longToken;
    latestSystemState.shortToken = prevSystemState.shortToken;
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
    syntheticToken.priceHistory = [];
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
