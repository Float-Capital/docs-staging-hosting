import {
  V1,
  FeesLevied,
  SyntheticTokenCreated,
  LongMinted,
  LongRedeem,
  PriceUpdate,
  ShortMinted,
  ShortRedeem,
  TokenPriceRefreshed,
  ValueLockedInSystem,
  LongShort,
} from "../generated/LongShort/LongShort";

import {
  DeployV1,
  StateAdded,
  StakeAdded,
  StakeWithdrawn,
  FloatMinted,
} from "../generated/Staker/Staker";

import { erc20 } from "../generated/templates";
import { Transfer as TransferEvent } from "../generated/templates/erc20/erc20";

import {
  StateChange,
  EventParam,
  EventParams,
  SyntheticMarket,
  FeeStructure,
  GlobalState,
  YieldManager,
  Staker,
  TokenFactory,
  LongShortContract,
  SyntheticToken,
  CurrentStake,
  Stake,
  User,
  State,
  Transfer,
} from "../generated/schema";
import {
  BigInt,
  Address,
  Bytes,
  log,
  dataSource,
  DataSourceContext,
} from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";
import {
  getOrCreateLatestSystemState,
  getOrCreateUser,
  getOrCreateBalanceObject,
  createSyntheticTokenLong,
  createSyntheticTokenShort,
} from "./utils/globalStateManager";
import {
  createNewTokenDataSource,
  updateBalanceTransfer,
  updateBalanceFloatTransfer,
} from "./utils/helperFunctions";
import {
  ZERO,
  TEN_TO_THE_18,
  GLOBAL_STATE_ID,
  YIELD_MANAGER_ID,
  ORACLE_AGREGATOR_ID,
  STAKER_ID,
  TOKEN_FACTORY_ID,
  LONG_SHORT_ID,
  ZERO_ADDRESS,
} from "./CONSTANTS";

export function handleTransfer(event: TransferEvent): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let fromAddress = event.params.from;
  let fromAddressString = fromAddress.toHex();
  let toAddress = event.params.to;
  let toAddressString = toAddress.toHex();
  let amount = event.params.value;

  let context = dataSource.context();
  let tokenAddressString = context.getString("contractAddress");
  let isFloatToken = context.getBoolean("isFloatToken");

  if (isFloatToken) {
    updateBalanceFloatTransfer(fromAddress, amount, true);
    updateBalanceFloatTransfer(toAddress, amount, false);
  } else {
    let syntheticToken = SyntheticToken.load(tokenAddressString);
    if (syntheticToken == null) {
      log.critical("Token should be defined", []);
    }

    let transactionHash = event.transaction.hash.toHex();
    let transfer = new Transfer(transactionHash);
    transfer.from = fromAddressString;
    transfer.to = toAddressString;
    transfer.value = amount;
    transfer.token = syntheticToken.id;
    transfer.save();

    updateBalanceTransfer(tokenAddressString, fromAddress, amount, true);
    updateBalanceTransfer(tokenAddressString, toAddress, amount, false);
  }

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "Transfer",
    [tokenAddressString],
    ["name"],
    ["type"]
  );
}

export function handleV1(event: V1): void {
  // This function will only ever get called once
  if (GlobalState.load(GLOBAL_STATE_ID) != null) {
    log.critical("the event was emitted more than once!", []);
  }

  let longShort = new LongShortContract(LONG_SHORT_ID);
  longShort.address = event.address;
  longShort.save();

  let tokenFactory = new TokenFactory(TOKEN_FACTORY_ID);
  tokenFactory.address = event.params.tokenFactory;
  tokenFactory.save();

  let staker = new Staker(STAKER_ID);
  staker.address = event.params.staker;
  staker.save();

  let globalState = new GlobalState(GLOBAL_STATE_ID);
  globalState.contractVersion = BigInt.fromI32(1);
  globalState.latestMarketIndex = ZERO;
  globalState.staker = staker.id;
  globalState.tokenFactory = tokenFactory.id;
  globalState.adminAddress = event.params.admin;
  globalState.longShort = longShort.id;
  globalState.totalFloatMinted = ZERO;
  globalState.save();
}

export function handleFeesLevied(event: FeesLevied): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let totalFees = event.params.totalFees;
}

export function handleValueLockedInSystem(event: ValueLockedInSystem): void {
  //Void
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let contractCallCounter = event.params.contractCallCounter;
  let totalValueLockedInMarket = event.params.totalValueLockedInMarket;
  let longValue = event.params.longValue;
  let shortValue = event.params.shortValue;

  let state = getOrCreateLatestSystemState(
    marketIndex,
    contractCallCounter,
    event
  );
  state.totalValueLocked = totalValueLockedInMarket;
  state.totalLockedLong = longValue;
  state.totalLockedShort = shortValue;

  state.save();
}

export function handleSyntheticTokenCreated(
  event: SyntheticTokenCreated
): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let longTokenAddress = event.params.longTokenAddress;
  let shortTokenAddress = event.params.shortTokenAddress;
  let initialAssetPrice = event.params.assetPrice;

  let oracleAddress = event.params.oracleAddress;
  let syntheticName = event.params.name;
  let syntheticSymbol = event.params.symbol;

  let baseEntryFee = event.params.baseEntryFee;
  let badLiquidityEntryFee = event.params.badLiquidityEntryFee;
  let baseExitFee = event.params.baseExitFee;
  let badLiquidityExitFee = event.params.badLiquidityExitFee;

  let marketIndexString = marketIndex.toString();

  // TODO: Add string name to these.
  createNewTokenDataSource(longTokenAddress);
  createNewTokenDataSource(shortTokenAddress);

  // create new synthetic token object.
  let longToken = createSyntheticTokenLong(longTokenAddress);

  let shortToken = createSyntheticTokenShort(shortTokenAddress);

  let state = getOrCreateLatestSystemState(marketIndex, ZERO, event);

  let fees = new FeeStructure(
    marketIndexString + "-fees-" + longTokenAddress.toHexString()
  );
  fees.baseEntryFee = baseEntryFee;
  fees.badLiquidityEntryFee = badLiquidityEntryFee;
  fees.baseExitFee = baseExitFee;
  fees.badLiquidityExitFee = badLiquidityExitFee;

  let syntheticMarket = new SyntheticMarket(marketIndexString);
  syntheticMarket.timestampCreated = timestamp;
  syntheticMarket.txHash = txHash;
  syntheticMarket.blockNumberCreated = blockNumber;
  syntheticMarket.name = syntheticName;
  syntheticMarket.symbol = syntheticSymbol;
  syntheticMarket.latestSystemState = state.id;
  syntheticMarket.syntheticLong = longToken.id;
  syntheticMarket.syntheticShort = shortToken.id;
  syntheticMarket.marketIndex = marketIndex;
  syntheticMarket.oracleAddress = oracleAddress;
  syntheticMarket.feeStructure = fees.id;

  state.syntheticPrice = initialAssetPrice; // change me

  let globalState = GlobalState.load(GLOBAL_STATE_ID);
  globalState.latestMarketIndex = globalState.latestMarketIndex.plus(
    BigInt.fromI32(1)
  );

  longToken.syntheticMarket = syntheticMarket.id;
  shortToken.syntheticMarket = syntheticMarket.id;

  longToken.save();
  shortToken.save();
  state.save();
  syntheticMarket.save();
  fees.save();
  globalState.save();

  // Add below back later
  // saveEventToStateChange(
  //   txHash,
  //   timestamp,
  //   blockNumber,
  //   "InterestDistribution",
  //   bigIntArrayToStringArray([
  //     newTotalValueLocked,
  //     totalInterest,
  //     longPercentage,
  //     shortPercentage,
  //   ]),
  //   [
  //     "newValueTotalLocked",
  //     "totalInterest",
  //     "longPercentage",
  //     "shortPercentage",
  //   ],
  //   ["uint256", "uint256", "uint256", "uint256"]
  // );
}

export function handleLongMinted(event: LongMinted): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let depositAdded = event.params.depositAdded;
  let finalDepositAmount = event.params.finalDepositAmount;
  let tokensMinted = event.params.tokensMinted;
  let user = event.params.user;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "LongMinted",
    bigIntArrayToStringArray([
      depositAdded,
      finalDepositAmount,
      tokensMinted,
    ]).concat([user.toHex()]),
    ["depositAdded", "finalDepositAmount", "tokensMinted", "user"],
    ["uint256", "uint256", "uint256", "address"]
  );
}

export function handleLongRedeem(event: LongRedeem): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let tokensRedeemed = event.params.tokensRedeemed;
  let valueOfRedemption = event.params.valueOfRedemption;
  let finalRedeemValue = event.params.finalRedeemValue;
  let user = event.params.user;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "LongRedeem",
    bigIntArrayToStringArray([
      tokensRedeemed,
      valueOfRedemption,
      finalRedeemValue,
    ]).concat([user.toHex()]),
    ["tokensRedeemed", "valueOfRedemption", "finalRedeem", "user"],
    ["uint256", "uint256", "uint256", "address"]
  );
}

export function handlePriceUpdate(event: PriceUpdate): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let marketIndexString = marketIndex.toString();

  let contractCallCounter = event.params.contractCallCounter;
  let newPrice = event.params.newPrice;
  let oldPrice = event.params.oldPrice;
  let user = event.params.user;

  let syntheticMarket = SyntheticMarket.load(marketIndexString);

  let state = getOrCreateLatestSystemState(
    marketIndex,
    contractCallCounter,
    event
  );
  state.syntheticPrice = newPrice;
  syntheticMarket.latestSystemState = state.id;
  state.save();
  syntheticMarket.save();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "PriceUpdate",
    bigIntArrayToStringArray([newPrice, oldPrice]).concat([user.toHex()]),
    ["newPrice", "oldPrice", "user"],
    ["uint256", "uint256", "address"]
  );
}

export function handleShortMinted(event: ShortMinted): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let depositAdded = event.params.depositAdded;
  let finalDepositAmount = event.params.finalDepositAmount;
  let tokensMinted = event.params.tokensMinted;
  let user = event.params.user;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "ShortMinted",
    bigIntArrayToStringArray([
      depositAdded,
      finalDepositAmount,
      tokensMinted,
    ]).concat([user.toHex()]),
    ["depositAdded", "finalDepositAmount", "tokensMinted", "user"],
    ["uint256", "uint256", "uint256", "address"]
  );
}

export function handleShortRedeem(event: ShortRedeem): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let tokensRedeemed = event.params.tokensRedeemed;
  let valueOfRedemption = event.params.valueOfRedemption;
  let finalRedeemValue = event.params.finalRedeemValue;
  let user = event.params.user;

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "ShortRedeem",
    bigIntArrayToStringArray([
      tokensRedeemed,
      valueOfRedemption,
      finalRedeemValue,
    ]).concat([user.toHex()]),
    ["tokensRedeemed", "valueOfRedemption", "finalRedeemValue", "user"],
    ["uint256", "uint256", "uint256", "address"]
  );
}

export function handleTokenPriceRefreshed(event: TokenPriceRefreshed): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let marketIndexString = marketIndex.toString();
  let longTokenPrice = event.params.longTokenPrice;
  let shortTokenPrice = event.params.shortTokenPrice;

  let contractCallCounter = event.params.contractCallCounter;

  let syntheticMarket = SyntheticMarket.load(marketIndexString);

  let state = getOrCreateLatestSystemState(
    marketIndex,
    contractCallCounter,
    event
  );
  state.longTokenPrice = longTokenPrice;
  state.shortTokenPrice = shortTokenPrice;
  syntheticMarket.latestSystemState = state.id;
  state.save();
  syntheticMarket.save();

  saveEventToStateChange(
    txHash,
    timestamp,
    blockNumber,
    "TokenPriceRefreshed",
    bigIntArrayToStringArray([longTokenPrice, shortTokenPrice]),
    ["longTokenPrice", "shortTokenPrice"],
    ["uint256", "uint256"]
  );
}

export function handleDeployV1(event: DeployV1): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let floatAddress = event.params.floatToken;
  //create new float token!!!

  let context = new DataSourceContext();
  context.setString("contractAddress", floatAddress.toHex());
  context.setBoolean("isFloatToken", true);
  erc20.createWithContext(floatAddress, context);
}

export function handleStateAdded(event: StateAdded): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let tokenAddress = event.params.tokenAddress;
  let tokenAddressString = tokenAddress.toHex();
  let stateIndex = event.params.stateIndex;
  let accumulativeFloatPerSecond = event.params.accumulative;
  // don't necessarily need to emit this since we can get it from event.block
  let timestampOfState = event.params.timestamp;

  let syntheticToken = SyntheticToken.load(tokenAddressString);
  if (syntheticToken == null) {
    log.critical("Token should be defined", []);
  }

  let state = new State(tokenAddressString + "-" + stateIndex.toString());
  state.blockNumber = blockNumber;
  state.creationTxHash = txHash;
  state.stateIndex = stateIndex;
  state.timestamp = timestamp;
  state.syntheticToken = syntheticToken.id;
  state.accumulativeFloatPerSecond = accumulativeFloatPerSecond;

  syntheticToken.save();
  state.save();
}
export function handleStakeAdded(event: StakeAdded): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let userAddress = event.params.user;
  let userAddressString = userAddress.toHex();
  let tokenAddress = event.params.tokenAddress;
  let tokenAddressString = tokenAddress.toHex();
  let amount = event.params.amount;

  let lastMintIndex = event.params.lastMintIndex;

  let state = State.load(tokenAddressString + "-" + lastMintIndex.toString());
  if (state == null) {
    log.critical("state not defined yet crash", []);
  }

  let user = getOrCreateUser(userAddress);

  let syntheticToken = SyntheticToken.load(tokenAddressString);

  let stake = new Stake(txHash.toHex());
  stake.timestamp = timestamp;
  stake.blockNumber = blockNumber;
  stake.creationTxHash = txHash;
  stake.syntheticToken = syntheticToken.id;
  stake.user = user.id;
  stake.amount = amount;
  stake.withdrawn = false;

  let currentStake = CurrentStake.load(
    tokenAddressString + "-" + userAddressString + "-currentStake"
  );
  if (currentStake == null) {
    // They won't have a current stake.
    currentStake = new CurrentStake(
      tokenAddressString + "-" + userAddressString + "-currentStake"
    );
    currentStake.user = user.id;
    currentStake.userAddress = user.address;
    currentStake.syntheticToken = syntheticToken.id;
  } else {
    // Note: Only add if still relevant and not withdrawn
    let oldStake = Stake.load(currentStake.currentStake);
    if (!oldStake.withdrawn) {
      stake.amount = stake.amount.plus(oldStake.amount);
      oldStake.withdrawn = true;
    }
  }
  currentStake.currentStake = stake.id;
  currentStake.lastMintState = state.id;

  stake.save();
  currentStake.save();
  user.save();
  syntheticToken.save();
}

export function handleStakeWithdrawn(event: StakeWithdrawn): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let userAddress = event.params.user;
  let userAddressString = userAddress.toHex();
  let tokenAddress = event.params.tokenAddress;
  let tokenAddressString = tokenAddress.toHex();
  let amount = event.params.amount;

  let user = getOrCreateUser(userAddress);
  let syntheticToken = SyntheticToken.load(tokenAddressString);
  let currentStake = CurrentStake.load(
    tokenAddressString + "-" + userAddressString + "-currentStake"
  );
  if (currentStake == null) {
    log.critical("Stake should be defined", []);
  }
  let oldStake = Stake.load(currentStake.currentStake);

  // If they are not withdrawing the full amount
  if (!oldStake.amount.equals(amount)) {
    let stake = new Stake(txHash.toHex());
    stake.timestamp = timestamp;
    stake.blockNumber = blockNumber;
    stake.creationTxHash = txHash;
    stake.syntheticToken = syntheticToken.id;
    stake.user = user.id;
    stake.withdrawn = false;
    stake.amount = oldStake.amount.minus(amount);
    currentStake.currentStake = stake.id;
    stake.save();
  }
  oldStake.withdrawn = true;

  oldStake.save();
  currentStake.save();
}

export function handleFloatMinted(event: FloatMinted): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let userAddress = event.params.user;
  let userAddressString = userAddress.toHex();
  let tokenAddress = event.params.tokenAddress;
  let tokenAddressString = tokenAddress.toHex();
  let amount = event.params.amount;
  let lastMintIndex = event.params.lastMintIndex;

  let state = State.load(tokenAddressString + "-" + lastMintIndex.toString());
  if (state == null) {
    log.critical("state not defined yet crash", []);
  }
  let syntheticToken = SyntheticToken.load(tokenAddressString);
  syntheticToken.floatMintedFromSpecificToken = syntheticToken.floatMintedFromSpecificToken.plus(
    amount
  );

  let user = getOrCreateUser(userAddress);
  user.totalMintedFloat = user.totalMintedFloat.plus(amount);

  let currentStake = CurrentStake.load(
    tokenAddressString + "-" + userAddressString + "-currentStake"
  );
  currentStake.lastMintState = state.id;

  let globalState = GlobalState.load(GLOBAL_STATE_ID);
  globalState.totalFloatMinted = globalState.totalFloatMinted.plus(amount);

  syntheticToken.save();
  user.save();
  currentStake.save();
  globalState.save();
}

// currently all params are BigInts -> in future may have to modify to support e.g. Addresses
function bigIntArrayToStringArray(bigIntArr: BigInt[]): string[] {
  let returnArr = new Array<string>(bigIntArr.length);
  for (let i = 0; i < bigIntArr.length; i++) {
    returnArr[i] = bigIntArr[i].toString();
  }
  return returnArr;
}
