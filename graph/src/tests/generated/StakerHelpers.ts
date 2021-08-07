import {
  Address,
  BigInt,
  Bytes,
  ethereum,
  store,
  Value,
} from "@graphprotocol/graph-ts";
  import {
AccumulativeIssuancePerStakedSynthSnapshotCreated,
BalanceIncentiveEquilibriumOffsetUpdated,
BalanceIncentiveExponentUpdated,
ChangeAdmin,
FloatMinted,
FloatPercentageUpdated,
MarketAddedToStaker,
MarketLaunchIncentiveParametersChanges,
StakeAdded,
StakeWithdrawalFeeUpdated,
StakeWithdrawn,
StakerV1,
SyntheticTokensShifted,} from "../../../generated/Staker/Staker";


export function createAccumulativeIssuancePerStakedSynthSnapshotCreatedEvent(marketIndex: BigInt, accumulativeFloatIssuanceSnapshotIndex: BigInt, accumulativeLong: BigInt, accumulativeShort: BigInt): AccumulativeIssuancePerStakedSynthSnapshotCreated {
  let newAccumulativeIssuancePerStakedSynthSnapshotCreatedEvent = new AccumulativeIssuancePerStakedSynthSnapshotCreated();
  newAccumulativeIssuancePerStakedSynthSnapshotCreatedEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newAccumulativeIssuancePerStakedSynthSnapshotCreatedEvent.parameters.push(marketIndexParam);

          let accumulativeFloatIssuanceSnapshotIndexParam = new ethereum.EventParam();

  accumulativeFloatIssuanceSnapshotIndexParam.name = "accumulativeFloatIssuanceSnapshotIndex";
  accumulativeFloatIssuanceSnapshotIndexParam.value = ethereum.Value.fromSignedBigInt(accumulativeFloatIssuanceSnapshotIndex);
  
  newAccumulativeIssuancePerStakedSynthSnapshotCreatedEvent.parameters.push(accumulativeFloatIssuanceSnapshotIndexParam);

          let accumulativeLongParam = new ethereum.EventParam();

  accumulativeLongParam.name = "accumulativeLong";
  accumulativeLongParam.value = ethereum.Value.fromSignedBigInt(accumulativeLong);
  
  newAccumulativeIssuancePerStakedSynthSnapshotCreatedEvent.parameters.push(accumulativeLongParam);

          let accumulativeShortParam = new ethereum.EventParam();

  accumulativeShortParam.name = "accumulativeShort";
  accumulativeShortParam.value = ethereum.Value.fromSignedBigInt(accumulativeShort);
  
  newAccumulativeIssuancePerStakedSynthSnapshotCreatedEvent.parameters.push(accumulativeShortParam);

  return newAccumulativeIssuancePerStakedSynthSnapshotCreatedEvent;
}

export function createBalanceIncentiveEquilibriumOffsetUpdatedEvent(marketIndex: BigInt, balanceIncentiveEquilibriumOffset: BigInt): BalanceIncentiveEquilibriumOffsetUpdated {
  let newBalanceIncentiveEquilibriumOffsetUpdatedEvent = new BalanceIncentiveEquilibriumOffsetUpdated();
  newBalanceIncentiveEquilibriumOffsetUpdatedEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newBalanceIncentiveEquilibriumOffsetUpdatedEvent.parameters.push(marketIndexParam);

          let balanceIncentiveEquilibriumOffsetParam = new ethereum.EventParam();

  balanceIncentiveEquilibriumOffsetParam.name = "balanceIncentiveEquilibriumOffset";
  balanceIncentiveEquilibriumOffsetParam.value = ethereum.Value.fromSignedBigInt(balanceIncentiveEquilibriumOffset);
  
  newBalanceIncentiveEquilibriumOffsetUpdatedEvent.parameters.push(balanceIncentiveEquilibriumOffsetParam);

  return newBalanceIncentiveEquilibriumOffsetUpdatedEvent;
}

export function createBalanceIncentiveExponentUpdatedEvent(marketIndex: BigInt, balanceIncentiveExponent: BigInt): BalanceIncentiveExponentUpdated {
  let newBalanceIncentiveExponentUpdatedEvent = new BalanceIncentiveExponentUpdated();
  newBalanceIncentiveExponentUpdatedEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newBalanceIncentiveExponentUpdatedEvent.parameters.push(marketIndexParam);

          let balanceIncentiveExponentParam = new ethereum.EventParam();

  balanceIncentiveExponentParam.name = "balanceIncentiveExponent";
  balanceIncentiveExponentParam.value = ethereum.Value.fromSignedBigInt(balanceIncentiveExponent);
  
  newBalanceIncentiveExponentUpdatedEvent.parameters.push(balanceIncentiveExponentParam);

  return newBalanceIncentiveExponentUpdatedEvent;
}

export function createChangeAdminEvent(newAdmin: Address): ChangeAdmin {
  let newChangeAdminEvent = new ChangeAdmin();
  newChangeAdminEvent.parameters = new Array<ethereum.EventParam>();

  
          let newAdminParam = new ethereum.EventParam();

  newAdminParam.name = "newAdmin";
  newAdminParam.value = ethereum.Value.fromAddress(newAdmin);
  
  newChangeAdminEvent.parameters.push(newAdminParam);

  return newChangeAdminEvent;
}

export function createFloatMintedEvent(user: Address, marketIndex: BigInt, amountFloatMinted: BigInt): FloatMinted {
  let newFloatMintedEvent = new FloatMinted();
  newFloatMintedEvent.parameters = new Array<ethereum.EventParam>();

  
          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newFloatMintedEvent.parameters.push(userParam);

          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newFloatMintedEvent.parameters.push(marketIndexParam);

          let amountFloatMintedParam = new ethereum.EventParam();

  amountFloatMintedParam.name = "amountFloatMinted";
  amountFloatMintedParam.value = ethereum.Value.fromSignedBigInt(amountFloatMinted);
  
  newFloatMintedEvent.parameters.push(amountFloatMintedParam);

  return newFloatMintedEvent;
}

export function createFloatPercentageUpdatedEvent(floatPercentage: BigInt): FloatPercentageUpdated {
  let newFloatPercentageUpdatedEvent = new FloatPercentageUpdated();
  newFloatPercentageUpdatedEvent.parameters = new Array<ethereum.EventParam>();

  
          let floatPercentageParam = new ethereum.EventParam();

  floatPercentageParam.name = "floatPercentage";
  floatPercentageParam.value = ethereum.Value.fromSignedBigInt(floatPercentage);
  
  newFloatPercentageUpdatedEvent.parameters.push(floatPercentageParam);

  return newFloatPercentageUpdatedEvent;
}

export function createMarketAddedToStakerEvent(marketIndex: BigInt, exitFee_e18: BigInt, period: BigInt, multiplier: BigInt, balanceIncentiveExponent: BigInt, balanceIncentiveEquilibriumOffset: BigInt): MarketAddedToStaker {
  let newMarketAddedToStakerEvent = new MarketAddedToStaker();
  newMarketAddedToStakerEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newMarketAddedToStakerEvent.parameters.push(marketIndexParam);

          let exitFee_e18Param = new ethereum.EventParam();

  exitFee_e18Param.name = "exitFee_e18";
  exitFee_e18Param.value = ethereum.Value.fromSignedBigInt(exitFee_e18);
  
  newMarketAddedToStakerEvent.parameters.push(exitFee_e18Param);

          let periodParam = new ethereum.EventParam();

  periodParam.name = "period";
  periodParam.value = ethereum.Value.fromSignedBigInt(period);
  
  newMarketAddedToStakerEvent.parameters.push(periodParam);

          let multiplierParam = new ethereum.EventParam();

  multiplierParam.name = "multiplier";
  multiplierParam.value = ethereum.Value.fromSignedBigInt(multiplier);
  
  newMarketAddedToStakerEvent.parameters.push(multiplierParam);

          let balanceIncentiveExponentParam = new ethereum.EventParam();

  balanceIncentiveExponentParam.name = "balanceIncentiveExponent";
  balanceIncentiveExponentParam.value = ethereum.Value.fromSignedBigInt(balanceIncentiveExponent);
  
  newMarketAddedToStakerEvent.parameters.push(balanceIncentiveExponentParam);

          let balanceIncentiveEquilibriumOffsetParam = new ethereum.EventParam();

  balanceIncentiveEquilibriumOffsetParam.name = "balanceIncentiveEquilibriumOffset";
  balanceIncentiveEquilibriumOffsetParam.value = ethereum.Value.fromSignedBigInt(balanceIncentiveEquilibriumOffset);
  
  newMarketAddedToStakerEvent.parameters.push(balanceIncentiveEquilibriumOffsetParam);

  return newMarketAddedToStakerEvent;
}

export function createMarketLaunchIncentiveParametersChangesEvent(marketIndex: BigInt, period: BigInt, multiplier: BigInt): MarketLaunchIncentiveParametersChanges {
  let newMarketLaunchIncentiveParametersChangesEvent = new MarketLaunchIncentiveParametersChanges();
  newMarketLaunchIncentiveParametersChangesEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newMarketLaunchIncentiveParametersChangesEvent.parameters.push(marketIndexParam);

          let periodParam = new ethereum.EventParam();

  periodParam.name = "period";
  periodParam.value = ethereum.Value.fromSignedBigInt(period);
  
  newMarketLaunchIncentiveParametersChangesEvent.parameters.push(periodParam);

          let multiplierParam = new ethereum.EventParam();

  multiplierParam.name = "multiplier";
  multiplierParam.value = ethereum.Value.fromSignedBigInt(multiplier);
  
  newMarketLaunchIncentiveParametersChangesEvent.parameters.push(multiplierParam);

  return newMarketLaunchIncentiveParametersChangesEvent;
}

export function createStakeAddedEvent(user: Address, token: Address, amount: BigInt, lastMintIndex: BigInt): StakeAdded {
  let newStakeAddedEvent = new StakeAdded();
  newStakeAddedEvent.parameters = new Array<ethereum.EventParam>();

  
          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newStakeAddedEvent.parameters.push(userParam);

          let tokenParam = new ethereum.EventParam();

  tokenParam.name = "token";
  tokenParam.value = ethereum.Value.fromAddress(token);
  
  newStakeAddedEvent.parameters.push(tokenParam);

          let amountParam = new ethereum.EventParam();

  amountParam.name = "amount";
  amountParam.value = ethereum.Value.fromSignedBigInt(amount);
  
  newStakeAddedEvent.parameters.push(amountParam);

          let lastMintIndexParam = new ethereum.EventParam();

  lastMintIndexParam.name = "lastMintIndex";
  lastMintIndexParam.value = ethereum.Value.fromSignedBigInt(lastMintIndex);
  
  newStakeAddedEvent.parameters.push(lastMintIndexParam);

  return newStakeAddedEvent;
}

export function createStakeWithdrawalFeeUpdatedEvent(marketIndex: BigInt, stakeWithdralFee: BigInt): StakeWithdrawalFeeUpdated {
  let newStakeWithdrawalFeeUpdatedEvent = new StakeWithdrawalFeeUpdated();
  newStakeWithdrawalFeeUpdatedEvent.parameters = new Array<ethereum.EventParam>();

  
          let marketIndexParam = new ethereum.EventParam();

  marketIndexParam.name = "marketIndex";
  marketIndexParam.value = ethereum.Value.fromSignedBigInt(marketIndex);
  
  newStakeWithdrawalFeeUpdatedEvent.parameters.push(marketIndexParam);

          let stakeWithdralFeeParam = new ethereum.EventParam();

  stakeWithdralFeeParam.name = "stakeWithdralFee";
  stakeWithdralFeeParam.value = ethereum.Value.fromSignedBigInt(stakeWithdralFee);
  
  newStakeWithdrawalFeeUpdatedEvent.parameters.push(stakeWithdralFeeParam);

  return newStakeWithdrawalFeeUpdatedEvent;
}

export function createStakeWithdrawnEvent(user: Address, token: Address, amount: BigInt): StakeWithdrawn {
  let newStakeWithdrawnEvent = new StakeWithdrawn();
  newStakeWithdrawnEvent.parameters = new Array<ethereum.EventParam>();

  
          let userParam = new ethereum.EventParam();

  userParam.name = "user";
  userParam.value = ethereum.Value.fromAddress(user);
  
  newStakeWithdrawnEvent.parameters.push(userParam);

          let tokenParam = new ethereum.EventParam();

  tokenParam.name = "token";
  tokenParam.value = ethereum.Value.fromAddress(token);
  
  newStakeWithdrawnEvent.parameters.push(tokenParam);

          let amountParam = new ethereum.EventParam();

  amountParam.name = "amount";
  amountParam.value = ethereum.Value.fromSignedBigInt(amount);
  
  newStakeWithdrawnEvent.parameters.push(amountParam);

  return newStakeWithdrawnEvent;
}

export function createStakerV1Event(admin: Address, floatTreasury: Address, floatCapital: Address, floatToken: Address, floatPercentage: BigInt): StakerV1 {
  let newStakerV1Event = new StakerV1();
  newStakerV1Event.parameters = new Array<ethereum.EventParam>();

  
          let adminParam = new ethereum.EventParam();

  adminParam.name = "admin";
  adminParam.value = ethereum.Value.fromAddress(admin);
  
  newStakerV1Event.parameters.push(adminParam);

          let floatTreasuryParam = new ethereum.EventParam();

  floatTreasuryParam.name = "floatTreasury";
  floatTreasuryParam.value = ethereum.Value.fromAddress(floatTreasury);
  
  newStakerV1Event.parameters.push(floatTreasuryParam);

          let floatCapitalParam = new ethereum.EventParam();

  floatCapitalParam.name = "floatCapital";
  floatCapitalParam.value = ethereum.Value.fromAddress(floatCapital);
  
  newStakerV1Event.parameters.push(floatCapitalParam);

          let floatTokenParam = new ethereum.EventParam();

  floatTokenParam.name = "floatToken";
  floatTokenParam.value = ethereum.Value.fromAddress(floatToken);
  
  newStakerV1Event.parameters.push(floatTokenParam);

          let floatPercentageParam = new ethereum.EventParam();

  floatPercentageParam.name = "floatPercentage";
  floatPercentageParam.value = ethereum.Value.fromSignedBigInt(floatPercentage);
  
  newStakerV1Event.parameters.push(floatPercentageParam);

  return newStakerV1Event;
}

export function createSyntheticTokensShiftedEvent(): SyntheticTokensShifted {
  let newSyntheticTokensShiftedEvent = new SyntheticTokensShifted();
  newSyntheticTokensShiftedEvent.parameters = new Array<ethereum.EventParam>();

  

  return newSyntheticTokensShiftedEvent;
}