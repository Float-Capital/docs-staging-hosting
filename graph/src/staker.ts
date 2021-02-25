import {
  DeployV1,
  StateAdded,
  StakeAdded,
  StakeWithdrawn,
  FloatMinted,
} from "../generated/Staker/Staker";
import { erc20 } from "../generated/templates";
import {
  StateChange,
  EventParam,
  EventParams,
  GlobalState,
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
  DataSourceContext,
} from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";
import { getOrCreateUser } from "./utils/globalStateManager";

import { ZERO, ONE, TEN_TO_THE_18, GLOBAL_STATE_ID } from "./CONSTANTS";

export function handleDeployV1(event: DeployV1): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let floatAddress = event.params.floatToken;

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

  if (stateIndex.equals(ZERO)) {
    // The first state - set floatRatePerSecondOverInterval to zero
    state.floatRatePerSecondOverInterval = ZERO;
  } else {
    let prevState = State.load(
      tokenAddressString + "-" + stateIndex.minus(ONE).toString()
    );
    if (prevState == null) {
      log.critical("There is no previous state for token {} at address {}", [
        stateIndex.minus(ONE).toString(),
        tokenAddressString,
      ]);
    }
    let timeElapsedSinceLastStateChange = state.timestamp.minus(
      prevState.timestamp
    );
    let changeInAccumulativeFloatPerSecond = state.accumulativeFloatPerSecond.minus(
      prevState.accumulativeFloatPerSecond
    );

    if (
      // NOTE: This hapens if two staking state changes happen in the same block.
      timeElapsedSinceLastStateChange.equals(changeInAccumulativeFloatPerSecond)
    ) {
      state.floatRatePerSecondOverInterval = ZERO;
    } else {
      state.floatRatePerSecondOverInterval = changeInAccumulativeFloatPerSecond.div(
        timeElapsedSinceLastStateChange
      );
    }
  }

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
