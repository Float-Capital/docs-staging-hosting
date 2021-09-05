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
  StakeShifted,
} from "../../generated/Staker/Staker";
import { erc20 } from "../../generated/templates";
import {
  GlobalState,
  SyntheticToken,
  SyntheticMarket,
  CurrentStake,
  Stake,
  AccumulativeFloatIssuanceSnapshot,
  BatchedNextPriceStakeAction,
  UserNextPriceStakeAction,
  UserCurrentNextPriceStakeAction,
  UserNextPriceStakeActionComponent,
} from "../../generated/schema";
import {
  log,
  DataSourceContext,
  Address,
  BigInt,
  ethereum,
} from "@graphprotocol/graph-ts";
import {
  bigIntArrayToStringArray,
  saveEventToStateChange,
} from "../utils/txEventHelpers";
import { getOrCreateUser } from "../utils/globalStateManager";
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
  getOrInitializeBatchedNextPriceStakeAction,
  getOrInitializeUserCurrentNextPriceStakeAction,
  getOrInitializeUserNextPriceStakeAction,
  getBatchedNextPriceStakeAction,
  getUserNextPriceStakeAction,
  getBatchedNextPriceExec,
  getUserCurrentNextPriceStakeAction,
} from "../generated/EntityHelpers";
import { removeFromArrayAtIndex } from "./longShort";

import {
  ZERO,
  ONE,
  GLOBAL_STATE_ID,
  TEN_TO_THE_18,
  FLOAT_ISSUANCE_FIXED_DECIMAL,
  ACTION_SHIFT,
} from "../CONSTANTS";
import {
  generateBatchedNextPriceExecId,
  createUserNextPriceStakeActionComponent,
} from "../utils/nextPrice";

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

  let stake = new Stake(
    userAddressString + "-" + tokenAddressString + "-" + txHash.toHex()
  );
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
    let stake = new Stake(
      userAddressString + "-" + tokenAddressString + "-" + txHash.toHex()
    );
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

function calculateAccumulatedFloatInRange(
  amountStakedLong: BigInt,
  amountStakedShort: BigInt,
  accumulativeFloatSnapshot_indexStart: AccumulativeFloatIssuanceSnapshot,
  accumulativeFloatSnapshot_indexEnd: AccumulativeFloatIssuanceSnapshot
): FloatMintedBreakdown {
  let amountFromLongStake = ZERO;
  let amountFromShortStake = ZERO;

  if (
    accumulativeFloatSnapshot_indexStart.index.equals(
      accumulativeFloatSnapshot_indexEnd.index
    )
  ) {
    return {
      amountFromLongStake: ZERO,
      amountFromShortStake: ZERO,
    };
  }

  if (amountStakedLong.gt(ZERO)) {
    let accumDeltaLong = accumulativeFloatSnapshot_indexEnd.accumulativeFloatPerTokenLong.minus(
      accumulativeFloatSnapshot_indexStart.accumulativeFloatPerTokenLong
    );
    amountFromLongStake = accumDeltaLong
      .times(amountStakedLong)
      .div(FLOAT_ISSUANCE_FIXED_DECIMAL);
  }

  if (amountStakedShort.gt(ZERO)) {
    let accumDeltaShort = accumulativeFloatSnapshot_indexEnd.accumulativeFloatPerTokenShort.minus(
      accumulativeFloatSnapshot_indexStart.accumulativeFloatPerTokenShort
    );
    amountFromShortStake = accumDeltaShort
      .times(amountStakedShort)
      .div(FLOAT_ISSUANCE_FIXED_DECIMAL);
  }

  return {
    amountFromLongStake,
    amountFromShortStake,
  };
}

function calculateAccumulatedFloatAndExecuteOutstandingShifts(
  syntheticMarket: SyntheticMarket,
  syntheticLong: SyntheticToken,
  syntheticShort: SyntheticToken,
  user: Address
): FloatMintedBreakdown {
  let lastUserMintId_forNonzeroStake = "";
  let amountStakedLong = ZERO;
  let amountStakedShort = ZERO;

  let unaccountedForSettledShift: UserNextPriceStakeAction;

  let userCurrentShift = UserCurrentNextPriceStakeAction.load(
    user.toHex() + "-" + syntheticMarket.marketIndex.toString()
  );

  if (userCurrentShift != null) {
    let lastUserShift = getUserNextPriceStakeAction(
      userCurrentShift.currentAction
    );
    if (lastUserShift.settled && !lastUserShift.floatMintedPastSettled) {
      unaccountedForSettledShift = lastUserShift;
    }
  }

  let currentStakeShort = CurrentStake.load(
    syntheticShort.tokenAddress.toHex() + "-" + user.toHex() + "-currentStake"
  );

  let currentStakeLong = CurrentStake.load(
    syntheticLong.tokenAddress.toHex() + "-" + user.toHex() + "-currentStake"
  );

  if (currentStakeLong != null) {
    let longStake = getStake(currentStakeLong.currentStake);
    if (!longStake.withdrawn) {
      lastUserMintId_forNonzeroStake = currentStakeLong.lastMintState;
      amountStakedLong = longStake.amount;
    }
  }

  if (currentStakeShort != null) {
    let shortStake = getStake(currentStakeShort.currentStake);
    if (!shortStake.withdrawn) {
      if (lastUserMintId_forNonzeroStake == "") {
        lastUserMintId_forNonzeroStake = currentStakeShort.lastMintState;
      } else if (
        lastUserMintId_forNonzeroStake != currentStakeShort.lastMintState
      ) {
        log.warning(
          "{} {} Nonzero long and short stakes have different mint times!",
          [lastUserMintId_forNonzeroStake, currentStakeShort.lastMintState]
        );
      }
      amountStakedShort = shortStake.amount;
    }
  }

  if (
    lastUserMintId_forNonzeroStake != "" &&
    unaccountedForSettledShift == null
  ) {
    return calculateAccumulatedFloatInRange(
      amountStakedLong,
      amountStakedShort,
      getAccumulativeFloatIssuanceSnapshot(lastUserMintId_forNonzeroStake),
      getAccumulativeFloatIssuanceSnapshot(
        syntheticMarket.latestAccumulativeFloatIssuanceSnapshot
      )
    );
  } else if (lastUserMintId_forNonzeroStake != "") {
    let shiftSnapshot = getAccumulativeFloatIssuanceSnapshot(
      generateAccumulativeFloatIssuanceSnapshotId(
        syntheticMarket.marketIndex,
        unaccountedForSettledShift.updateIndex
      )
    );

    let batchedNextPriceExec = getBatchedNextPriceExec(
      generateBatchedNextPriceExecId(
        syntheticMarket.marketIndex,
        unaccountedForSettledShift.updateIndex
      )
    );

    let longTokenPriceAtShift = batchedNextPriceExec.priceSnapshotLong;
    let shortTokenPriceAtShift = batchedNextPriceExec.priceSnapshotShort;

    let deltaLong = unaccountedForSettledShift.amountStakeForShiftFromShort
      .times(shortTokenPriceAtShift)
      .div(longTokenPriceAtShift)
      .minus(unaccountedForSettledShift.amountStakeForShiftFromLong);

    let amountStakedBeforeShiftLong = amountStakedLong.minus(deltaLong);

    let deltaShort = unaccountedForSettledShift.amountStakeForShiftFromLong
      .times(longTokenPriceAtShift)
      .div(shortTokenPriceAtShift)
      .minus(unaccountedForSettledShift.amountStakeForShiftFromShort);

    let amountStakedBeforeShiftShort = amountStakedShort.minus(deltaShort);

    let floatMintedToShift = calculateAccumulatedFloatInRange(
      amountStakedBeforeShiftLong,
      amountStakedBeforeShiftShort,
      getAccumulativeFloatIssuanceSnapshot(lastUserMintId_forNonzeroStake),
      shiftSnapshot
    );

    // TODO: Optimize by not doing this if no time has elapsed.
    let floatMintedAfterShift = calculateAccumulatedFloatInRange(
      amountStakedLong,
      amountStakedShort,
      shiftSnapshot,
      getAccumulativeFloatIssuanceSnapshot(
        syntheticMarket.latestAccumulativeFloatIssuanceSnapshot
      )
    );

    unaccountedForSettledShift.floatMintedPastSettled = true;
    unaccountedForSettledShift.save();

    return {
      amountFromLongStake: floatMintedToShift.amountFromLongStake.plus(
        floatMintedAfterShift.amountFromLongStake
      ),
      amountFromShortStake: floatMintedToShift.amountFromShortStake.plus(
        floatMintedAfterShift.amountFromShortStake
      ),
    };
  } else {
    log.warning(
      "Shouldn't be calculating minted float for a user with no stakes!",
      []
    );
    return {
      amountFromLongStake: ZERO,
      amountFromShortStake: ZERO,
    };
  }
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

  syntheticMarket.save();

  user.totalMintedFloat = user.totalMintedFloat.plus(amountFloatMinted);

  user.save();

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
      log.warning(
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

function setupUserNextPriceStateAction(
  userNextPriceStakeAction: UserNextPriceStakeAction,
  userAddress: Address,
  marketIndex: BigInt,
  userShiftIndex: BigInt,
  userNextPriceStakeActionComponent: UserNextPriceStakeActionComponent,
  event: ethereum.Event
): void {
  let userAddressStr = userAddress.toHex();
  let marketIndexStr = marketIndex.toString();
  let userShiftIndexStr = userShiftIndex.toString();
  userNextPriceStakeAction.user = userAddressStr;
  userNextPriceStakeAction.marketIndex = marketIndex;
  userNextPriceStakeAction.updateIndex = userShiftIndex;

  let batchedStakeRetrieval = getOrInitializeBatchedNextPriceStakeAction(
    marketIndexStr + "-" + userShiftIndexStr
  );
  let batchedStake: BatchedNextPriceStakeAction = batchedStakeRetrieval.entity;
  if (batchedStakeRetrieval.wasCreated) {
    batchedStake.marketIndex = marketIndex;
    batchedStake.updateIndex = userShiftIndex;
  }
  batchedStake.linkedUserNextPriceStakeActions = batchedStake.linkedUserNextPriceStakeActions.concat(
    [userNextPriceStakeActionComponent.id]
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
  userCurrentStakeAction.currentAction = userNextPriceStakeActionComponent.id;
  userCurrentStakeAction.save();

  let userObj = getOrCreateUser(userAddress, event);
  userObj.pendingNextPriceStakeActions = userObj.pendingNextPriceStakeActions.concat(
    [userNextPriceStakeActionComponent.id]
  );
  userObj.save();
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
    userAddressStr + "-" + marketIndex.toString() + "-" + userShiftIndexStr;

  let batchId = userAddressStr + "-" + marketIndexStr;
  let userNextPriceStakeActionComponent = createUserNextPriceStakeActionComponent(
    user,
    marketIndex,
    userShiftIndex,
    amount,
    ACTION_SHIFT,
    isShiftFromLong,
    userNextPriceStakeActionId,
    batchId,
    event
  );

  let userNextPriceStakeActionRetrieval = getOrInitializeUserNextPriceStakeAction(
    userNextPriceStakeActionId
  );

  let userNextPriceStakeAction = userNextPriceStakeActionRetrieval.entity;

  if (userNextPriceStakeActionRetrieval.wasCreated) {
    setupUserNextPriceStateAction(
      userNextPriceStakeAction,
      user,
      marketIndex,
      userShiftIndex,
      userNextPriceStakeActionComponent,
      event
    );
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

  userNextPriceStakeAction.nextPriceActionComponents = userNextPriceStakeAction.nextPriceActionComponents.concat(
    [userNextPriceStakeActionComponent.id]
  );

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

export function handleStakeShifted(event: StakeShifted): void {
  let user = event.params.user;
  let userStr = user.toHex();
  let marketIndex = event.params.marketIndex;

  let newStakeLong = event.params.newAmountStakedLong;
  let newStakeShort = event.params.newAmountStakedShort;

  let syntheticMarket = getSyntheticMarket(marketIndex.toString());

  let longCorrect = false;
  let shortCorrect = false;

  let currentStakeLong = getCurrentStake(
    syntheticMarket.syntheticLong + "-" + userStr + "-currentStake"
  );
  let currentStakeShort = getCurrentStake(
    syntheticMarket.syntheticShort + "-" + userStr + "-currentStake"
  );

  let userStakeLong = getStake(currentStakeLong.currentStake);
  let userStakeShort = getStake(currentStakeShort.currentStake);

  if (newStakeLong.gt(ZERO)) {
    longCorrect =
      newStakeLong.equals(userStakeLong.amount) && !userStakeLong.withdrawn;
  } else {
    longCorrect = userStakeLong.withdrawn;
  }

  if (newStakeShort.gt(ZERO)) {
    shortCorrect =
      newStakeShort.equals(userStakeShort.amount) && !userStakeShort.withdrawn;
  } else {
    shortCorrect = userStakeShort.withdrawn;
  }

  if (!longCorrect) {
    log.warning(
      "Incorrect long user stake balance in graph. Stake in graph: {}, Stake Withdrawn in graph: {}, Stake Amount (with withdrawn stakes equal zero) in contracts: {}",
      [
        userStakeLong.amount.toString(),
        userStakeLong.withdrawn ? "true" : "false",
        newStakeLong.toString(),
      ]
    );
  }

  if (!shortCorrect) {
    log.warning(
      "Incorrect short user stake balance in graph. Stake in graph: {}, Stake Withdrawn in graph: {}, Stake Amount (with withdrawn stakes equal zero) in contracts: {}",
      [
        userStakeShort.amount.toString(),
        userStakeShort.withdrawn ? "true" : "false",
        newStakeShort.toString(),
      ]
    );
  }
}
