import {
  StakerV1,
  StateAdded,
  StakeAdded,
  StakeWithdrawn,
  FloatMinted,
  MarketLaunchIncentiveParametersChanges,
  MarketAddedToStaker,
  StakeWithdrawalFeeUpdated,
  FloatPercentageUpdated,
  BalanceIncentiveEquilibriumOffsetUpdated,
  BalanceIncentiveExponentUpdated,
} from "../generated/Staker/Staker";
import { erc20 } from "../generated/templates";
import {
  GlobalState,
  SyntheticToken,
  SyntheticMarket,
  CurrentStake,
  Stake,
  StakeState,
} from "../generated/schema";
import { log, DataSourceContext } from "@graphprotocol/graph-ts";
import {
  bigIntArrayToStringArray,
  saveEventToStateChange,
} from "./utils/txEventHelpers";
import {
  getOrCreateUser,
  getOrCreateStakerState,
} from "./utils/globalStateManager";

import { ZERO, ONE, GLOBAL_STATE_ID } from "./CONSTANTS";

export function handleStakerV1(event: StakerV1): void {
  let floatAddress = event.params.floatToken;
  // TODO: add the floatPercentage to the graph.
  let floatPercentage = event.params.floatPercentage;

  let context = new DataSourceContext();
  context.setString("contractAddress", floatAddress.toHex());
  context.setBoolean("isFloatToken", true);
  erc20.createWithContext(floatAddress, context);

  saveEventToStateChange(
    event,
    "StakerV1",
    [floatAddress.toHex(), floatPercentage.toString()],
    ["floatAddress", "floatPercentage"],
    ["address", "uint256"],
    [],
    [],
    false
  );
}

export function handleStakeWithdrawalFeeUpdated(
  event: StakeWithdrawalFeeUpdated
): void {
  let marketIndex = event.params.marketIndex;
  let stakeWithdralFee = event.params.stakeWithdralFee;

  saveEventToStateChange(
    event,
    "StakeWithdrawalFeeUpdated",
    bigIntArrayToStringArray([marketIndex, stakeWithdralFee]),
    ["marketIndex", "stakeWithdralFee"],
    ["uint32", "uint256"],
    [],
    []
  );
}

export function handleMarketAddedToStaker(event: MarketAddedToStaker): void {
  let marketIndex = event.params.marketIndex;
  let exitFeeBasisPoints = event.params.exitFeeBasisPoints;

  saveEventToStateChange(
    event,
    "MarketAddedToStaker",
    bigIntArrayToStringArray([marketIndex, exitFeeBasisPoints]),
    ["marketIndex", "exitFee_e18"],
    ["uint32", "uint256"],
    [],
    []
  );
}

export function handleStateAdded(event: StateAdded): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let marketIndexId = marketIndex.toString();
  let stateIndex = event.params.stateIndex;
  let accumulativeLong = event.params.accumulativeLong;
  let accumulativeShort = event.params.accumulativeShort;

  let syntheticMarket = SyntheticMarket.load(marketIndexId);
  if (syntheticMarket == null) {
    log.critical(
      "`handleStateAdded` called without SyntheticMarket with id #{} being created.",
      [marketIndexId]
    );
  }

  let state = getOrCreateStakerState(
    syntheticMarket as SyntheticMarket,
    stateIndex,
    event
  );
  state.blockNumber = blockNumber;
  state.creationTxHash = txHash;
  state.stateIndex = stateIndex;
  state.timestamp = timestamp;
  state.accumulativeFloatPerTokenLong = accumulativeLong;
  state.accumulativeFloatPerTokenShort = accumulativeShort;

  if (!stateIndex.equals(ZERO)) {
    let prevState = StakeState.load(
      marketIndexId + "-" + stateIndex.minus(ONE).toString()
    );
    if (prevState == null) {
      log.critical(
        "There is no previous state for market #{} at with index {}",
        [marketIndexId, stateIndex.minus(ONE).toString()]
      );
    }
    let timeElapsedSinceLastStateChange = state.timestamp.minus(
      prevState.timestamp
    );

    let changeInAccumulativeFloatPerSecondLong = state.accumulativeFloatPerTokenLong.minus(
      prevState.accumulativeFloatPerTokenLong
    );

    let changeInAccumulativeFloatPerSecondShort = state.accumulativeFloatPerTokenShort.minus(
      prevState.accumulativeFloatPerTokenShort
    );

    state.timeSinceLastUpdate = timeElapsedSinceLastStateChange;

    if (
      // NOTE: This hapens if two staking state changes happen in the same block.
      timeElapsedSinceLastStateChange.equals(ZERO)
    ) {
      log.warning("state being set to zero! {}", [blockNumber.toString()]);
      state.floatRatePerTokenOverIntervalLong = ZERO;
      state.floatRatePerTokenOverIntervalShort = ZERO;
    } else {
      state.floatRatePerTokenOverIntervalLong = changeInAccumulativeFloatPerSecondLong.div(
        timeElapsedSinceLastStateChange
      );
      state.floatRatePerTokenOverIntervalShort = changeInAccumulativeFloatPerSecondShort.div(
        timeElapsedSinceLastStateChange
      );
    }
  }

  state.save();

  saveEventToStateChange(
    event,
    "StateAdded",
    [
      marketIndexId,
      stateIndex.toString(),
      accumulativeLong.toString(),
      accumulativeShort.toString(),
    ],
    ["marketIndex", "stateIndex", "accumulativeLong", "accumulativeShort"],
    ["uint32", "uint256", "uint256", "uint256"],
    [],
    []
  );
}

export function handleMarketLaunchIncentiveParametersChanges(
  event: MarketLaunchIncentiveParametersChanges
): void {
  let marketIndex = event.params.marketIndex;
  let period = event.params.period;
  let multiplier = event.params.multiplier;

  let syntheticMarket = SyntheticMarket.load(marketIndex.toString());
  if (syntheticMarket == null) {
    log.critical("syntheticMarket should be defined", []);
  }

  syntheticMarket.kPeriod = period;
  syntheticMarket.kMultiplier = multiplier;

  syntheticMarket.save();

  saveEventToStateChange(
    event,
    "MarketLaunchIncentiveParametersChanges",
    [marketIndex.toString(), period.toString(), multiplier.toString()],
    ["marketIndex", "period", "multiplier"],
    ["uint256", "uint256", "uint256"],
    [],
    [],
    false
  );
}

export function handleStakeAdded(event: StakeAdded): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let userAddress = event.params.user;
  let userAddressString = userAddress.toHex();
  let tokenAddress = event.params.token;
  let tokenAddressString = tokenAddress.toHex();
  let amount = event.params.amount;

  let lastMintIndex = event.params.lastMintIndex;

  let syntheticToken = SyntheticToken.load(tokenAddressString);
  if (syntheticToken == null) {
    log.critical("Token should be defined", []);
  }

  let marketIndexId = syntheticToken.syntheticMarket;
  let syntheticMarket = SyntheticMarket.load(marketIndexId);
  if (syntheticMarket == null) {
    log.critical(
      "`handleStakeAdded` called without SyntheticMarket with id #{} being created.",
      [marketIndexId]
    );
  }

  // NOTE: This will create a new (empyt) StakerState if the user is not staking immediately
  let state = getOrCreateStakerState(
    syntheticMarket as SyntheticMarket,
    lastMintIndex,
    event
  );

  let user = getOrCreateUser(userAddress, event);

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
    currentStake.syntheticMarket = syntheticToken.syntheticMarket;

    user.currentStakes = user.currentStakes.concat([currentStake.id]);
  } else {
    // Note: Only add if still relevant and not withdrawn
    let oldStake = Stake.load(currentStake.currentStake);
    if (oldStake != null) {
      if (!oldStake.withdrawn) {
        stake.amount = stake.amount.plus(oldStake.amount);
        oldStake.withdrawn = true;
      }
    }
  }
  currentStake.currentStake = stake.id;
  currentStake.lastMintState = state.id;

  syntheticToken.totalStaked = syntheticToken.totalStaked.plus(amount);

  stake.save();
  currentStake.save();
  user.save();
  syntheticToken.save();

  saveEventToStateChange(
    event,
    "StakeAdded",
    [
      userAddressString,
      tokenAddressString,
      amount.toString(),
      lastMintIndex.toString(),
    ],
    ["user", "tokenAddress", "amount", "lastMintIndex"],
    ["address", "address", "uint256", "uint256"],
    [userAddress],
    [currentStake.id]
  );
}

export function handleStakeWithdrawn(event: StakeWithdrawn): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let userAddress = event.params.user;
  let userAddressString = userAddress.toHex();
  let tokenAddress = event.params.token;
  let tokenAddressString = tokenAddress.toHex();
  let amount = event.params.amount;

  let user = getOrCreateUser(userAddress, event);
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

  syntheticToken.totalStaked = syntheticToken.totalStaked.minus(amount);

  syntheticToken.save();
  oldStake.save();
  currentStake.save();

  saveEventToStateChange(
    event,
    "StakeWithdrawn",
    [userAddressString, tokenAddressString, amount.toString()],
    ["user", "tokenAddress", "amount"],
    ["address", "address", "uint256"],
    [userAddress],
    [currentStake.id]
  );
}

export function handleFloatMinted(event: FloatMinted): void {
  let userAddress = event.params.user;
  let userAddressString = userAddress.toHex();
  let marketIndex = event.params.marketIndex;
  let marketIndexId = marketIndex.toString();
  let amountLong = event.params.amountLong;
  let amountShort = event.params.amountShort;
  let totalAmount = amountLong.plus(amountShort);
  let amountFloatMinted = event.params.amountFloatMinted;

  // TODO: This will brake here as the FloatMintedEvent has changed
  let state = StakeState.load(marketIndexId + "-" + lastMintIndex.toString());
  if (state == null) {
    log.critical("state not defined yet in `handleFloatMinted`, tx hash {}", [
      event.transaction.hash.toHex(),
    ]);
  }
  let syntheticMarket = SyntheticMarket.load(marketIndexId);
  if (syntheticMarket == null) {
    log.critical(
      "`handleFloatMinted` called without SyntheticMarket with id #{} being created.",
      [marketIndexId]
    );
  }

  let user = getOrCreateUser(userAddress, event);
  syntheticMarket.totalFloatMinted = syntheticMarket.totalFloatMinted.plus(
    totalAmount
  );
  user.totalMintedFloat = user.totalMintedFloat.plus(totalAmount);

  let changedStakesArray: Array<string> = [];
  if (amountLong.gt(ZERO)) {
    let syntheticLong = SyntheticToken.load(syntheticMarket.syntheticLong);
    syntheticLong.floatMintedFromSpecificToken = syntheticLong.floatMintedFromSpecificToken.plus(
      amountLong
    );
    // TODO - create a helper function the 'getOrCreate's the CurrentStake
    let currentStakeLong = CurrentStake.load(
      syntheticMarket.syntheticLong + "-" + userAddressString + "-currentStake"
    );
    if (currentStakeLong == null) {
      log.critical("Current stake (long) is still null. ID {}", [
        currentStakeLong.id,
      ]);
    }
    currentStakeLong.lastMintState = state.id;
    currentStakeLong.save();
    syntheticLong.save();
    changedStakesArray = changedStakesArray.concat([currentStakeLong.id]);
  }

  if (amountShort.gt(ZERO)) {
    let syntheticShort = SyntheticToken.load(syntheticMarket.syntheticShort);
    syntheticShort.floatMintedFromSpecificToken = syntheticShort.floatMintedFromSpecificToken.plus(
      amountShort
    );
    let currentStakeShort = CurrentStake.load(
      syntheticMarket.syntheticShort + "-" + userAddressString + "-currentStake"
    );
    if (currentStakeShort == null) {
      log.critical("Current stake (short) is still null. ID {}", [
        currentStakeShort.id,
      ]);
    }
    currentStakeShort.lastMintState = state.id;
    currentStakeShort.save();
    syntheticShort.save();
    changedStakesArray = changedStakesArray.concat([currentStakeShort.id]);
  }

  let globalState = GlobalState.load(GLOBAL_STATE_ID);
  globalState.totalFloatMinted = globalState.totalFloatMinted.plus(totalAmount);

  user.save();
  globalState.save();

  saveEventToStateChange(
    event,
    "FloatMinted",
    [userAddressString, marketIndexId, amountFloatMinted.toString()],
    ["user", "marketIndex", "amountFloatMinted"],
    ["address", "uint32", "uint256"],
    [userAddress],
    changedStakesArray
  );
}

export function handleFloatPercentageUpdated(
  event: FloatPercentageUpdated
): void {
  // TODO: update value in the graph!
  let floatPercentage = event.params.floatPercentage;

  saveEventToStateChange(
    event,
    "FloatPercentageUpdated",
    [floatPercentage.toString()],
    ["floatPercentage"],
    ["uint256"],
    [],
    []
  );
}

/*
  event StakeWithdrawalFeeUpdated(uint32 marketIndex, uint256 stakeWithdralFee);
  event BalanceIncentiveExponentUpdated(uint32 marketIndex, uint256 balanceIncentiveExponent);
*/
export function handleBalanceIncentiveEquilibriumOffsetUpdated(
  event: BalanceIncentiveEquilibriumOffsetUpdated
): void {
  // TODO: update value in the graph!
  let marketIndex = event.params.marketIndex;
  let balanceIncentiveEquilibriumOffset =
    event.params.balanceIncentiveEquilibriumOffset;

  saveEventToStateChange(
    event,
    "BalanceIncentiveEquilibriumOffsetUpdated",
    [marketIndex.toString(), balanceIncentiveEquilibriumOffset.toString()],
    ["marketIndex", "balanceIncentiveEquilibriumOffset"],
    ["uint32", "int256"],
    [],
    []
  );
}
export function handleBalanceIncentiveExponentUpdated(
  event: BalanceIncentiveExponentUpdated
): void {
  // TODO: update value in the graph!
  let marketIndex = event.params.marketIndex;
  let balanceIncentiveExponent = event.params.balanceIncentiveExponent;

  saveEventToStateChange(
    event,
    "BalanceIncentiveExponentUpdated",
    [marketIndex.toString(), balanceIncentiveExponent.toString()],
    ["marketIndex", "balanceIncentiveExponent"],
    ["uint32", "uint256"],
    [],
    []
  );
}
export function handleStakeWithdrawalFeeUpdate(
  event: StakeWithdrawalFeeUpdated
): void {
  // TODO: update value in the graph!
  let marketIndex = event.params.marketIndex;
  let stakeWithdralFee = event.params.stakeWithdralFee;

  saveEventToStateChange(
    event,
    "StakeWithdrawalFeeUpdate",
    [marketIndex.toString(), stakeWithdralFee.toString()],
    ["marketIndex", "stakeWithdralFee"],
    ["uint32", "uint256"],
    [],
    []
  );
}
