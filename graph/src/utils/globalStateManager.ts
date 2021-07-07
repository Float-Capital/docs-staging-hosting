import {
  SystemState,
  GlobalState,
  User,
  Price,
  StakeState,
  SyntheticToken,
  UserSyntheticTokenBalance,
  LatestPrice,
  SyntheticMarket,
  CollateralToken,
  UserCollateralTokenBalance,
  UnderlyingPrice,
  LatestUnderlyingPrice,
} from "../../generated/schema";
import { BigInt, Bytes, log, ethereum, Address } from "@graphprotocol/graph-ts";
import {
  ZERO,
  ONE,
  GLOBAL_STATE_ID,
  TEN_TO_THE_18,
  ZERO_ADDRESS,
  ZERO_ADDRESS_BYTES,
  MARKET_SIDE_LONG,
  MARKET_SIDE_SHORT,
} from "../CONSTANTS";
import { createNewTokenDataSource } from "./helperFunctions";

function createInitialTokenPrice(
  id: string,
  tokenId: string,
  timestamp: BigInt
): Price {
  let initialTokenPrice = new Price(id);
  initialTokenPrice.price = TEN_TO_THE_18;
  initialTokenPrice.token = tokenId;
  initialTokenPrice.timeUpdated = timestamp;

  return initialTokenPrice as Price;
}

function createInitialUnderlyingPrice(
  id: string,
  marketId: string,
  initialPrice: BigInt,
  timestamp: BigInt
): UnderlyingPrice {
  let initialUnderlyingPrice = new UnderlyingPrice(id);
  initialUnderlyingPrice.price = initialPrice;
  initialUnderlyingPrice.market = marketId;
  initialUnderlyingPrice.timeUpdated = timestamp;

  return initialUnderlyingPrice as UnderlyingPrice;
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
  initialAssetPrice: BigInt,
  longTokenId: string,
  shortTokenId: string
): InitialState {
  let systemStateId = latestStateChangeCounter.toString();
  let marketIndexId = marketIndex.toString();
  let timestamp = event.block.timestamp;
  let initialLongPriceId = marketIndexId + "-long-" + timestamp.toString();
  let initialShortPriceId = marketIndexId + "-short-" + timestamp.toString();
  let initialUnderlyingAssetPriceId =
    marketIndexId + "-underlying-" + timestamp.toString();

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
  let initialUnderlyingAssetPrice = createInitialUnderlyingPrice(
    initialUnderlyingAssetPriceId,
    marketIndexId,
    initialAssetPrice,
    timestamp
  );
  let longCurrentTokenPrice = new LatestPrice(
    "latestPrice-" + marketIndexId + "-long"
  );
  let shortCurrentTokenPrice = new LatestPrice(
    "latestPrice-" + marketIndexId + "-short"
  );
  let underlyingAssetPrice = new LatestUnderlyingPrice(
    "latestPrice-" + marketIndexId + "-underlying"
  );
  longCurrentTokenPrice.price = initialLongTokenPrice.id;
  shortCurrentTokenPrice.price = initialShortTokenPrice.id;
  underlyingAssetPrice.price = initialUnderlyingAssetPrice.id;

  initialLongTokenPrice.save();
  initialShortTokenPrice.save();
  initialUnderlyingAssetPrice.save();

  longCurrentTokenPrice.save();
  shortCurrentTokenPrice.save();
  underlyingAssetPrice.save();

  let latestSystemState = new SystemState(marketIndexId + "-" + systemStateId);
  latestSystemState.timestamp = event.block.timestamp;
  latestSystemState.txHash = event.transaction.hash;
  latestSystemState.blockNumber = event.block.number;
  latestSystemState.marketIndex = marketIndex;
  latestSystemState.underlyingPrice = underlyingAssetPrice.id;
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
  txHash: Bytes,
  event: ethereum.Event
): SystemState {
  let systemStateId = txHash.toHex();
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
    latestSystemState.underlyingPrice = prevSystemState.underlyingPrice;
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

export function getStakerStateId(
  marketIndexId: string,
  stateIndex: BigInt
): string {
  return marketIndexId + "-" + stateIndex.toString();
}

export function getOrCreateStakerState(
  syntheticMarket: SyntheticMarket,
  stateIndex: BigInt,
  event: ethereum.Event
): StakeState {
  let marketIndexId = syntheticMarket.id;
  let stateId = getStakerStateId(marketIndexId, stateIndex);
  let state = StakeState.load(stateId);
  if (state == null) {
    state = new StakeState(stateId);
    state.blockNumber = event.block.number;
    state.creationTxHash = event.transaction.hash;
    state.stateIndex = ZERO;
    state.longToken = syntheticMarket.syntheticLong;
    state.shortToken = syntheticMarket.syntheticLong;
    state.timestamp = event.block.timestamp;
    state.accumulativeFloatPerTokenShort = ZERO;
    state.accumulativeFloatPerTokenLong = ZERO;
    state.floatRatePerTokenOverIntervalShort = ZERO;
    state.floatRatePerTokenOverIntervalLong = ZERO;
    state.timeSinceLastUpdate = ZERO;
    // update latest staker state for market
    syntheticMarket.latestStakerState = state.id;
    syntheticMarket.save();
  }

  return state as StakeState;
}

export function getOrCreateGlobalState(): GlobalState {
  let globalState = GlobalState.load(GLOBAL_STATE_ID);
  if (globalState == null) {
    globalState = new GlobalState(GLOBAL_STATE_ID);
    globalState.contractVersion = BigInt.fromI32(1);
    globalState.latestMarketIndex = ZERO;
    globalState.staker = ZERO_ADDRESS;
    globalState.tokenFactory = ZERO_ADDRESS;
    globalState.adminAddress = ZERO_ADDRESS_BYTES;
    globalState.longShort = ZERO_ADDRESS;
    globalState.totalFloatMinted = ZERO;
    globalState.totalTxs = ZERO;
    globalState.totalGasUsed = ZERO;
    globalState.totalUsers = ZERO;
    globalState.timestampLaunched = ZERO;
    globalState.txHash = ZERO_ADDRESS_BYTES;
  }

  return globalState as GlobalState;
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
    user.collatoralTokenApprovals = [];
    user.collatoralBalances = [];
    user.tokenMints = [];
    user.stateChangesAffectingUser = [];
    user.pendingNextPriceActions = [];
    user.confirmedNextPriceActions = [];
    user.settledNextPriceActions = [];

    let globalState = GlobalState.load(GLOBAL_STATE_ID);
    globalState.totalUsers = globalState.totalUsers.plus(ONE);
    globalState.save();
  }

  return user as User;
}
export function getUser(address: Bytes): User {
  let user = User.load(address.toHex());
  if (user == null) {
    log.critical(
      "ERROR: user with address {} doesn't exist, rather use `getOrCreateUser` function",
      [address.toHex()]
    );
  }

  return user as User;
}
export function getSyntheticMarket(marketIndex: BigInt): SyntheticMarket {
  let syntheticMarket = SyntheticMarket.load(marketIndex.toString());
  if (syntheticMarket == null) {
    log.critical(
      "`getOrCreateLatestSystemState` called without SyntheticMarket with id #{} being created.",
      [marketIndex.toString()]
    );
  }

  return syntheticMarket as SyntheticMarket;
}
export function getSyntheticTokenById(
  syntheticTokenId: string
): SyntheticToken {
  let syntheticTokenLong = SyntheticToken.load(syntheticTokenId);
  if (syntheticTokenLong == null) {
    log.critical("Synthetic Token with id {} is undefined.", []);
  }

  return syntheticTokenLong as SyntheticToken;
}

export function getSyntheticTokenByMarketIdAndTokenType(
  marketIndex: BigInt,
  isLong: bool
): SyntheticToken {
  let syntheticMarket = SyntheticMarket.load(marketIndex.toString());
  if (syntheticMarket == null) {
    log.critical("Synthetic market with id {} is undefined.", []);
  }
  if (isLong) {
    return SyntheticToken.load(syntheticMarket.syntheticLong) as SyntheticToken;
  } else {
    return SyntheticToken.load(
      syntheticMarket.syntheticShort
    ) as SyntheticToken;
  }
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
    if (user == null) {
      log.critical("User is undefined with address {}", [userAddressString]);
    }
    newBalance.user = user.id;

    let token = SyntheticToken.load(tokenAddressString);
    if (token == null) {
      log.critical("Synthetic Token is undefined with address {}", [
        tokenAddressString,
      ]);
    }
    newBalance.syntheticToken = token.id;

    newBalance.tokenBalance = ZERO;
    newBalance.timeLastUpdated = ZERO;

    return newBalance;
  } else {
    return balance as UserSyntheticTokenBalance;
  }
}

export function getOrCreateCollatoralBalanceObject(
  tokenAddressString: string,
  userAddressString: string
): UserCollateralTokenBalance {
  let balance = UserCollateralTokenBalance.load(
    tokenAddressString + "-" + userAddressString + "-balance"
  );

  if (balance == null) {
    let newBalance = new UserCollateralTokenBalance(
      tokenAddressString + "-" + userAddressString + "-balance"
    );

    let user = User.load(userAddressString);
    if (user == null) {
      log.critical("User is undefined with address {}", [userAddressString]);
    }
    newBalance.user = user.id;

    let token = CollateralToken.load(tokenAddressString);
    if (token == null) {
      log.critical("Synthetic Token is undefined with address {}", [
        tokenAddressString,
      ]);
    }
    newBalance.collateralToken = token.id;

    newBalance.balanceInaccurate = ZERO;
    newBalance.timeLastUpdated = ZERO;

    return newBalance;
  } else {
    return balance as UserCollateralTokenBalance;
  }
}

export function updateOrCreateCollateralToken(
  tokenAddress: Address,
  syntheticMarket: SyntheticMarket
): CollateralToken {
  let tokenAddressString = tokenAddress.toHex();
  let collateralToken = CollateralToken.load(tokenAddressString);
  if (collateralToken == null) {
    collateralToken = new CollateralToken(tokenAddressString);
    collateralToken.linkedMarkets = [];
    createNewTokenDataSource(tokenAddress);
  }

  collateralToken.linkedMarkets = collateralToken.linkedMarkets.concat([
    syntheticMarket.id,
  ]);

  return collateralToken as CollateralToken;
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
  syntheticToken.tokenType = MARKET_SIDE_LONG;

  return syntheticToken as SyntheticToken;
}
export function createSyntheticTokenShort(tokenAddress: Bytes): SyntheticToken {
  let syntheticToken = createSyntheticToken(tokenAddress);
  syntheticToken.tokenType = MARKET_SIDE_SHORT;

  return syntheticToken as SyntheticToken;
}
