import {
  StakerV1,
  AccumulativeIssuancePerStakedSynthSnapshotCreated,
  StakeAdded,
  StakeWithdrawn,
  FloatMinted,
  MarketLaunchIncentiveParametersChanges,
  MarketAddedToStaker,
  StakeWithdrawalFeeUpdated,
  NextPriceStakeShift,
  FloatPercentageUpdated,
  BalanceIncentiveParamsUpdated,
} from "../../generated/Staker/Staker";
import { erc20 } from "../../generated/templates";
import {
  GlobalState,
  SyntheticToken,
  SyntheticMarket,
  CurrentStake,
  Stake,
  AccumulativeFloatIssuanceSnapshot,
  BatchedStakerNextPriceAction,
} from "../../generated/schema";
import {
  log,
  DataSourceContext,
  Address,
  BigInt,
} from "@graphprotocol/graph-ts";
import {
  bigIntArrayToStringArray,
  saveEventToStateChange,
} from "../utils/txEventHelpers";
import { getOrCreateUser, getUser } from "../utils/globalStateManager";
import {
  generateAccumulativeFloatIssuanceSnapshotId,
  getOrInitializeAccumulativeFloatIssuanceSnapshot,
  getSyntheticMarket,
  getAccumulativeFloatIssuanceSnapshot,
  getSyntheticToken,
  getCurrentStake,
  getStake,
  getOrInitializeCurrentStake,
  getOrInitializeStake,
  getOrInitializeBatchedStakerNextPriceAction,
  getOrInitializeUserCurrentNextPriceStakeAction,
  getOrInitializeUserNextPriceStakeAction,
  getBatchedNextPriceStakeAction,
  getUserNextPriceStakeAction,
} from "../generated/EntityHelpers";
import { removeFromArrayAtIndex } from "./longShort";

import {
  ZERO,
  ONE,
  GLOBAL_STATE_ID,
  TEN_TO_THE_18,
  FLOAT_ISSUANCE_FIXED_DECIMAL,
} from "../CONSTANTS";

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
  let exitFee_e18 = event.params.exitFee_e18;
  let balanceIncentiveEquilibriumOffset =
    event.params.balanceIncentiveEquilibriumOffset;
  let balanceIncentiveExponent = event.params.balanceIncentiveExponent;
  let multiplier = event.params.multiplier;
  let period = event.params.period;

  saveEventToStateChange(
    event,
    "MarketAddedToStaker",
    bigIntArrayToStringArray([
      marketIndex,
      exitFee_e18,
      balanceIncentiveExponent,
      multiplier,
      period,
      balanceIncentiveEquilibriumOffset,
    ]),
    [
      "marketIndex",
      "exitFee_e18",
      "balanceIncentiveExponent",
      "multiplier",
      "period",
      "balanceIncentiveEquilibriumOffset",
    ],
    ["uint32", "uint256", "uint256", "uint256", "uint256", "int256"],
    [],
    []
  );
}

function initializeCurrentStake(
  currentStake,
  syntheticToken,
  userAddress,
  marketIndex,
  accumulativeFloatIssuanceSnapshotId,
  txHash,
  timestamp,
  blockNumber
) {
  currentStake.syntheticToken = syntheticToken;
  currentStake.user = userAddress.toHex();
  currentStake.userAddress = userAddress;
  currentStake.syntheticMarket = marketIndex.toString();
  currentStake.lastMintState = accumulativeFloatIssuanceSnapshotId;

  let stake = new Stake(txHash.toHex());
  stake.timestamp = timestamp;
  stake.blockNumber = blockNumber;
  stake.creationTxHash = txHash;
  stake.syntheticToken = syntheticToken;
  stake.amount = ZERO;
  stake.user = userAddress.toHex();
  stake.withdrawn = true;
  stake.save();

  currentStake.stake = txHash.toHex();
}

export function handleAccumulativeIssuancePerStakedSynthSnapshotCreated(
  event: AccumulativeIssuancePerStakedSynthSnapshotCreated
): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let marketIndex = event.params.marketIndex;
  let marketIndexId = marketIndex.toString();
  let accumulativeFloatIssuanceSnapshotIndex =
    event.params.accumulativeFloatIssuanceSnapshotIndex;
  let accumulativeLong = event.params.accumulativeLong;
  let accumulativeShort = event.params.accumulativeShort;

  let syntheticMarket = SyntheticMarket.load(marketIndexId);
  if (syntheticMarket == null) {
    log.critical(
      "`handleAccumulativeIssuancePerStakedSynthSnapshotCreated` called without SyntheticMarket with id #{} being created.",
      [marketIndexId]
    );
  }

  let accumulativeFloatIssuanceSnapshotId = generateAccumulativeFloatIssuanceSnapshotId(
    marketIndex,
    accumulativeFloatIssuanceSnapshotIndex
  );
  let accumulativeFloatIssuanceSnapshotRetrieval = getOrInitializeAccumulativeFloatIssuanceSnapshot(
    accumulativeFloatIssuanceSnapshotId
  );
  let state = accumulativeFloatIssuanceSnapshotRetrieval.entity;
  if (accumulativeFloatIssuanceSnapshotRetrieval.wasCreated) {
    state.longToken = syntheticMarket.syntheticLong;
    state.shortToken = syntheticMarket.syntheticShort;
  }
  state.blockNumber = blockNumber;
  state.creationTxHash = txHash;
  state.index = accumulativeFloatIssuanceSnapshotIndex;
  state.timestamp = timestamp;
  state.accumulativeFloatPerTokenLong = accumulativeLong;
  state.accumulativeFloatPerTokenShort = accumulativeShort;

  syntheticMarket.latestAccumulativeFloatIssuanceSnapshot = accumulativeFloatIssuanceSnapshotId;
  syntheticMarket.save();

  if (!accumulativeFloatIssuanceSnapshotIndex.equals(ZERO)) {
    let prevState = AccumulativeFloatIssuanceSnapshot.load(
      marketIndexId +
        "-" +
        accumulativeFloatIssuanceSnapshotIndex.minus(ONE).toString()
    );
    if (prevState == null) {
      log.critical(
        "There is no previous state for market #{} at with index {}",
        [
          marketIndexId,
          accumulativeFloatIssuanceSnapshotIndex.minus(ONE).toString(),
        ]
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

  // rather do this in _updateSystemState handler

  let batchedNextPriceStakerShifts = getBatchedNextPriceStakeAction(
    marketIndex.toString() +
      "-" +
      accumulativeFloatIssuanceSnapshotIndex.toString()
  );
  if (batchedNextPriceStakerShifts != null) {
    let linkedNextPriceStakerActions =
      batchedNextPriceStakerShifts.linkedUserNextPriceStakeActions;
    for (let i = 0; i < linkedNextPriceStakerActions.length; i++) {
      let userNextPriceActionId: string = linkedNextPriceStakerActions[i];

      let userNextPriceAction = getUserNextPriceStakeAction(
        userNextPriceActionId
      );
      userNextPriceAction.settledTimestamp = event.block.timestamp;
      userNextPriceAction.settled = true;
      userNextPriceAction.save();

      let userAddress = Address.fromString(userNextPriceAction.user);
      let user = getUser(userAddress);

      user.pendingNextPriceStakeActions = removeFromArrayAtIndex(
        user.pendingNextPriceStakeActions,
        user.pendingNextPriceStakeActions.indexOf(userNextPriceActionId)
      );

      user.settledNextPriceStakeActions = user.settledNextPriceStakeActions.concat(
        [userNextPriceActionId]
      );

      let currentStakeLongFetch = getOrInitializeCurrentStake(
        syntheticMarket.syntheticLong + "-" + user.id
      );
      let currentStakeLong = currentStakeLongFetch.entity;
      if (currentStakeLongFetch.wasCreated) {
        initializeCurrentStake(
          currentStakeLong,
          syntheticMarket.syntheticLong,
          user.address,
          marketIndex,
          accumulativeFloatIssuanceSnapshotId,
          txHash,
          timestamp,
          blockNumber
        );
      }
      let currentStakeShortFetch = getOrInitializeCurrentStake(
        syntheticMarket.syntheticShort + "-" + user.id
      );
      let currentStakeShort = currentStakeShortFetch.entity;
      if (currentStakeShortFetch.wasCreated) {
        initializeCurrentStake(
          currentStakeShort,
          syntheticMarket.syntheticShort,
          user.address,
          marketIndex,
          accumulativeFloatIssuanceSnapshotId,
          txHash,
          timestamp,
          blockNumber
        );
      }

      let deltaLong = ZERO.minus(
        userNextPriceAction.amountStakeForShiftFromLong
      );
      let deltaShort = ZERO.minus(
        userNextPriceAction.amountStakeForShiftFromShort
      );

      let shortStake = getStake(currentStakeShort.currentStake);
    }
  }

  state.save();

  saveEventToStateChange(
    event,
    "AccumulativeIssuancePerStakedSynthSnapshotCreated",
    bigIntArrayToStringArray([
      marketIndex,
      accumulativeFloatIssuanceSnapshotIndex,
      accumulativeLong,
      accumulativeShort,
    ]),
    [
      "marketIndex",
      "accumulativeFloatIssuanceSnapshotIndex",
      "accumulativeLong",
      "accumulativeShort",
    ],
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

  // TODO: this code may need to change a bit once we are using the same index for LongShort updateIndexes and accumulativeFloatIssuance Indexes
  let state = getAccumulativeFloatIssuanceSnapshot(
    generateAccumulativeFloatIssuanceSnapshotId(
      syntheticMarket.marketIndex,
      lastMintIndex
    )
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

  let currentStakeId =
    tokenAddressString + "-" + userAddressString + "-currentStake";
  let currentStakeResult = getOrInitializeCurrentStake(currentStakeId);
  let currentStake = currentStakeResult.entity;
  if (currentStakeResult.wasCreated) {
    // They won't have a current stake.
    currentStake.user = user.id;
    currentStake.userAddress = user.address;
    currentStake.syntheticToken = syntheticToken.id;
    currentStake.syntheticMarket = syntheticToken.syntheticMarket;

    user.currentStakes = user.currentStakes.concat([currentStake.id]);
  } else {
    // Note: Only add if still relevant and not withdrawn
    let oldStakeResult = getOrInitializeStake(currentStake.currentStake);
    if (!oldStakeResult.wasCreated) {
      let oldStake = oldStakeResult.entity;
      if (!oldStake.withdrawn) {
        stake.amount = stake.amount.plus(oldStake.amount);
        oldStake.withdrawn = true;
        oldStake.save();
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

class FloatMintedBreakdown {
  amountFromLongStake: BigInt;
  amountFromShortStake: BigInt;
}

function calculateAccumulatedFloatAndExecuteOutstandingShifts(
  syntheticMarket: SyntheticMarket,
  syntheticLong: SyntheticToken,
  syntheticShort: SyntheticToken,
  user: Address
): FloatMintedBreakdown {
  // TODO: handle case where user has pending token shifts! #

  let currentStakeLong = CurrentStake.load(
    syntheticLong.tokenAddress.toHex() + "-" + user.toHex() + "-currentStake"
  );
  let amountFromLongStake = ZERO;
  if (currentStakeLong != null) {
    let longStake = getStake(currentStakeLong.currentStake);
    let lastUserMintState = getAccumulativeFloatIssuanceSnapshot(
      currentStakeLong.lastMintState
    );
    let lastMarketMintState = getAccumulativeFloatIssuanceSnapshot(
      syntheticMarket.latestAccumulativeFloatIssuanceSnapshot
    );
    let amountStakedLong = longStake.amount;

    if (amountStakedLong.gt(ZERO)) {
      let accumDeltaLong = lastMarketMintState.accumulativeFloatPerTokenLong.minus(
        lastUserMintState.accumulativeFloatPerTokenLong
      );
      amountFromLongStake = accumDeltaLong
        .times(amountStakedLong)
        .div(FLOAT_ISSUANCE_FIXED_DECIMAL);
    }
  }
  let currentStakeShort = CurrentStake.load(
    syntheticShort.tokenAddress.toHex() + "-" + user.toHex() + "-currentStake"
  );

  let amountFromShortStake = ZERO;
  if (currentStakeShort != null) {
    let shortStake = getStake(currentStakeShort.currentStake);
    let lastUserMintState = getAccumulativeFloatIssuanceSnapshot(
      currentStakeShort.lastMintState
    );
    let lastMarketMintState = getAccumulativeFloatIssuanceSnapshot(
      syntheticMarket.latestAccumulativeFloatIssuanceSnapshot
    );
    let amountStakedShort = shortStake.amount;

    if (amountStakedShort.gt(ZERO) && !shortStake.withdrawn) {
      let accumDeltaShort = lastMarketMintState.accumulativeFloatPerTokenShort.minus(
        lastUserMintState.accumulativeFloatPerTokenShort
      );
      amountFromShortStake = accumDeltaShort
        .times(amountStakedShort)
        .div(FLOAT_ISSUANCE_FIXED_DECIMAL);
    }
  }
  return {
    amountFromLongStake,
    amountFromShortStake,
  };
}
export function handleFloatMinted(event: FloatMinted): void {
  let userAddress = event.params.user;
  let userAddressString = userAddress.toHex();
  let marketIndex = event.params.marketIndex;
  let marketIndexId = marketIndex.toString();
  // // TODO: Need to calculate these values correctly.
  // let amountLong = TEN_TO_THE_18;
  // let amountShort = TEN_TO_THE_18;
  let amountFloatMinted = event.params.amountFloatMinted;
  /// TODO: assert that `amountFloatMinted` == `expectedTotalAmount (will fail until amountLong and amountShort calculations are fixed of course!!!)

  let syntheticMarket = getSyntheticMarket(marketIndexId);
  let syntheticLong = getSyntheticToken(syntheticMarket.syntheticLong);
  let syntheticShort = getSyntheticToken(syntheticMarket.syntheticShort);

  let latestAccumulativeFloatIssuanceSnapshot = getAccumulativeFloatIssuanceSnapshot(
    (syntheticMarket as SyntheticMarket).latestAccumulativeFloatIssuanceSnapshot
  );

  let user = getOrCreateUser(userAddress, event);
  syntheticMarket.totalFloatMinted = syntheticMarket.totalFloatMinted.plus(
    amountFloatMinted
  );
  user.totalMintedFloat = user.totalMintedFloat.plus(amountFloatMinted);

  let fltBreakdown = calculateAccumulatedFloatAndExecuteOutstandingShifts(
    syntheticMarket,
    syntheticLong,
    syntheticShort,
    userAddress
  );
  let amountLong = fltBreakdown.amountFromLongStake;
  let amountShort = fltBreakdown.amountFromShortStake;
  let expectedTotalAmount = amountLong.plus(amountShort);

  if (expectedTotalAmount.notEqual(amountFloatMinted)) {
    if (expectedTotalAmount.notEqual(amountFloatMinted)) {
      log.critical(
        "Float issuance breakdown is incorrect. This is either a bug in the contracts or in the graph (more likely the graph).\nexpected amount: {}\nactual amount: {}\n    {} (amount long) + {} (amount short) \n\n\n The offending transaciton is {}",
        [
          expectedTotalAmount.toString(),
          amountFloatMinted.toString(),
          amountLong.toString(),
          amountShort.toString(),
          event.transaction.hash.toHex(),
        ]
      );
    }
  }

  let changedStakesArray: Array<string> = [];
  if (amountLong.gt(ZERO)) {
    syntheticLong.floatMintedFromSpecificToken = syntheticLong.floatMintedFromSpecificToken.plus(
      amountLong
    );
    let currentStakeLong = getCurrentStake(
      syntheticMarket.syntheticLong + "-" + userAddressString + "-currentStake"
    );
    currentStakeLong.lastMintState = latestAccumulativeFloatIssuanceSnapshot.id;
    currentStakeLong.save();
    syntheticLong.save();
    changedStakesArray = changedStakesArray.concat([currentStakeLong.id]);
  }

  if (amountShort.gt(ZERO)) {
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
    currentStakeShort.lastMintState =
      latestAccumulativeFloatIssuanceSnapshot.id;
    currentStakeShort.save();
    syntheticShort.save();
    changedStakesArray = changedStakesArray.concat([currentStakeShort.id]);
  }

  let globalState = GlobalState.load(GLOBAL_STATE_ID);
  globalState.totalFloatMinted = globalState.totalFloatMinted.plus(
    amountFloatMinted
  );

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
export function handleBalanceIncentiveParamsUpdated(
  event: BalanceIncentiveParamsUpdated
): void {
  // TODO: update value in the graph!
  let marketIndex = event.params.marketIndex;
  let balanceIncentiveExponent = event.params.balanceIncentiveExponent;
  let balanceIncentiveCurve_equilibriumOffset =
    event.params.balanceIncentiveCurve_equilibriumOffset;
  let safeExponentBitShifting = event.params.safeExponentBitShifting;

  saveEventToStateChange(
    event,
    "BalanceIncentiveExponentUpdated",
    [
      marketIndex.toString(),
      balanceIncentiveExponent.toString(),
      balanceIncentiveCurve_equilibriumOffset.toString(),
      safeExponentBitShifting.toString(),
    ],
    [
      "marketIndex",
      "balanceIncentiveExponent",
      "balanceIncentiveCurve_equilibriumOffset",
      "safeExponentBitShifting",
    ],
    ["uint32", "uint256", "int256", "uint256"],
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

export function handleNextPriceStakeShift(event: NextPriceStakeShift): void {
  let user = event.params.user;
  let userAddressStr = user.toHex();
  let marketIndex = event.params.marketIndex;
  let marketIndexStr = marketIndex.toString();
  let isShiftFromLong = event.params.isShiftFromLong;
  let amount = event.params.amount;
  let userShiftIndex = event.params.userShiftIndex;
  let userShiftIndexStr = userShiftIndex.toString();

  let userNextPriceStakeActionId =
    userAddressStr + "-" + marketIndex + "-" + userShiftIndexStr;
  let userNextPriceStakeActionRetrieval = getOrInitializeUserNextPriceStakeAction(
    userNextPriceStakeActionId
  );

  let userNextPriceStakeAction = userNextPriceStakeActionRetrieval.entity;

  if (userNextPriceStakeActionRetrieval.wasCreated) {
    userNextPriceStakeAction.user = userAddressStr;
    userNextPriceStakeAction.marketIndex = marketIndex;
    userNextPriceStakeAction.updateIndex = userShiftIndex;

    let batchedStakeRetrieval = getOrInitializeBatchedStakerNextPriceAction(
      marketIndexStr + "-" + userShiftIndexStr
    );
    let batchedStake = batchedStakeRetrieval.entity;
    if (batchedStakeRetrieval.wasCreated) {
      batchedStake.marketIndex = marketIndex;
      batchedStake.updateIndex = userShiftIndex;
    }
    batchedStake.linkedUserNextPriceStakeActions = batchedStake.linkedUserNextPriceStakeActions.concat(
      [userNextPriceStakeActionId]
    );
    batchedStake.save();

    let userCurrentStakeActionRetrieval = getOrInitializeUserCurrentNextPriceStakeAction(
      userAddressStr + "-" + marketIndexStr
    );
    let userCurrentStakeAction = userCurrentStakeActionRetrieval.entity;
    if (userCurrentStakeActionRetrieval.wasCreated) {
      userCurrentStakeAction.user = userAddressStr;
      userCurrentStakeAction.marketIndex = marketIndex;
    }
    userCurrentStakeAction.currentAction = userNextPriceStakeActionId;
    userCurrentStakeAction.save();

    let userObj = getOrCreateUser(user, event);
    userObj.pendingNextPriceStakeActions = userObj.pendingNextPriceStakeActions.concat(
      [userNextPriceStakeActionId]
    );
    userObj.save();
  }

  if (isShiftFromLong) {
    userNextPriceStakeAction.amountStakeForShiftFromLong = userNextPriceStakeAction.amountStakeForShiftFromLong.plus(
      amount
    );
  } else {
    userNextPriceStakeAction.amountStakeForShiftFromShort = userNextPriceStakeAction.amountStakeForShiftFromShort.plus(
      amount
    );
  }

  userNextPriceStakeAction.save();

  saveEventToStateChange(
    event,
    "NextPriceStakeShift",
    [
      userAddressStr,
      marketIndexStr,
      amount.toString(),
      isShiftFromLong ? "true" : "false",
      userShiftIndexStr,
    ],
    ["user", "marketIndex", "amount", "isShiftFromLong", "userShiftIndex"],
    ["address", "uint32", "uint256", "bool", "uint256"],
    [user],
    []
  );
}
