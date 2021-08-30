import {
  SystemState,
  GlobalState,
  User,
  Price,
  AccumulativeFloatIssuanceSnapshot,
  SyntheticToken,
  UserSyntheticTokenBalance,
  LatestPrice,
  SyntheticMarket,
  PaymentToken,
  UserPaymentTokenBalance,
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
import {
  getSyntheticMarket,
  getSyntheticToken,
} from "../generated/EntityHelpers";

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
    globalState.totalUsers = ZERO;
    globalState.timestampLaunched = ZERO;
    globalState.txHash = ZERO_ADDRESS_BYTES;
    globalState.totalValueLocked = ZERO;
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
  isLong: boolean
): SyntheticToken {
  let syntheticMarket = getSyntheticMarket(marketIndex.toString());
  if (isLong) {
    return getSyntheticToken(syntheticMarket.syntheticLong);
  } else {
    return getSyntheticToken(syntheticMarket.syntheticShort);
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
): UserPaymentTokenBalance {
  let balance = UserPaymentTokenBalance.load(
    tokenAddressString + "-" + userAddressString + "-balance"
  );

  if (balance == null) {
    let newBalance = new UserPaymentTokenBalance(
      tokenAddressString + "-" + userAddressString + "-balance"
    );

    let user = User.load(userAddressString);
    if (user == null) {
      log.critical("User is undefined with address {}", [userAddressString]);
    }
    newBalance.user = user.id;

    let token = PaymentToken.load(tokenAddressString);
    if (token == null) {
      log.critical("Synthetic Token is undefined with address {}", [
        tokenAddressString,
      ]);
    }
    newBalance.paymentToken = token.id;

    newBalance.balanceInaccurate = ZERO;
    newBalance.timeLastUpdated = ZERO;

    return newBalance;
  } else {
    return balance as UserPaymentTokenBalance;
  }
}

export function updateOrCreatePaymentToken(
  tokenAddress: Address,
  syntheticMarket: SyntheticMarket
): PaymentToken {
  let tokenAddressString = tokenAddress.toHex();
  let paymentToken = PaymentToken.load(tokenAddressString);
  if (paymentToken == null) {
    paymentToken = new PaymentToken(tokenAddressString);
    paymentToken.linkedMarkets = [];
    createNewTokenDataSource(tokenAddress);
  }

  paymentToken.linkedMarkets = paymentToken.linkedMarkets.concat([
    syntheticMarket.id,
  ]);

  return paymentToken as PaymentToken;
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
