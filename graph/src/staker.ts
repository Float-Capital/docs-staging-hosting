import {
  DeployV1,
  StateAdded,
  StakeAdded,
  StakeWithdrawn,
  FloatMinted,
  KFactorParametersChanges,
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
import { log, BigInt, DataSourceContext } from "@graphprotocol/graph-ts";
import { saveEventToStateChange } from "./utils/txEventHelpers";
import {
  getOrCreateUser,
  getOrCreateStakerState,
} from "./utils/globalStateManager";

import { ZERO, ONE, GLOBAL_STATE_ID } from "./CONSTANTS";

export function handleDeployV1(event: DeployV1): void {
  log.warning("first", [])
  let floatAddress = event.params.floatToken;
  log.warning("secord",[])
  
  let context = new DataSourceContext();
  log.warning("third",[])
  context.setString("contractAddress", floatAddress.toHex());
  log.warning("fourth",[])
  context.setBoolean("isFloatToken", true);
  log.warning("fifth",[])
  erc20.createWithContext(floatAddress, context);
  log.warning("sixth",[])
  
  saveEventToStateChange(
    event,
    "DeployV1",
    [floatAddress.toHex()],
    ["floatAddress"],
    ["address"],
    [],
    []
  );
  log.warning("end", [])
}

export function handleStateAdded(event: StateAdded): void {
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;

  let tokenAddress = event.params.tokenAddress;
  let tokenAddressString = tokenAddress.toHex();
  let stateIndex = event.params.stateIndex;
  let accumulativeFloatPerToken = event.params.accumulative;
  // don't necessarily need to emit this since we can get it from event.block
  let timestampOfState = event.params.timestamp;

  let syntheticToken = SyntheticToken.load(tokenAddressString);
  if (syntheticToken == null) {
    /////// THIS IS A BUG!!!!! TEMPORARILY IGNORING. THE SYNTHETIC TOKEN SHOULD NEVER BE UNDEFINED IN THIS FUNCTION.
    return
    // log.critical("Token should be defined", []);
  }

  let state = getOrCreateStakerState(tokenAddressString, stateIndex, event);
  state.blockNumber = blockNumber;
  state.creationTxHash = txHash;
  state.stateIndex = stateIndex;
  state.timestamp = timestamp;
  state.syntheticToken = syntheticToken.id;
  state.accumulativeFloatPerToken = accumulativeFloatPerToken;

  if (stateIndex.equals(ZERO)) {
    // The first state - set floatRatePerTokenOverInterval to zero
    state.floatRatePerTokenOverInterval = ZERO;
    state.timeSinceLastUpdate = ZERO;
  } else {
    let prevState = StakeState.load(
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
    let changeInAccumulativeFloatPerSecond = state.accumulativeFloatPerToken.minus(
      prevState.accumulativeFloatPerToken
    );

    state.timeSinceLastUpdate = timeElapsedSinceLastStateChange;

    if (
      // NOTE: This hapens if two staking state changes happen in the same block.
      timeElapsedSinceLastStateChange.equals(changeInAccumulativeFloatPerSecond)
    ) {
      state.floatRatePerTokenOverInterval = ZERO;
    } else {
      state.floatRatePerTokenOverInterval = changeInAccumulativeFloatPerSecond.div(
        timeElapsedSinceLastStateChange
      );
    }
  }

  syntheticToken.latestStakerState = state.id;
  syntheticToken.save();
  state.save();

  saveEventToStateChange(
    event,
    "StateAdded",
    [
      tokenAddress.toHex(),
      stateIndex.toString(),
      timestamp.toString(),
      accumulativeFloatPerToken.toString(),
    ],
    ["tokenAddress", "stateIndex", "timestamp", "accumulative"],
    ["address", "uint256", "uint256", "uint256"],
    [],
    []
  );
}

export function handleKFactorParametersChanges(
  event: KFactorParametersChanges
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
    "KFactorParametersChanges",
    [marketIndex.toString(), period.toString(), multiplier.toString()],
    ["marketIndex", "period", "multiplier"],
    ["uint256", "uint256", "uint256"],
    [],
    []
  );
}

export function handleStakeAdded(event: StakeAdded): void {
  log.warning("Staker 1",[])
  let txHash = event.transaction.hash;
  let blockNumber = event.block.number;
  let timestamp = event.block.timestamp;
  
  log.warning("Staker 2",[])
  let userAddress = event.params.user;
  let userAddressString = userAddress.toHex();
  let tokenAddress = event.params.tokenAddress;
  let tokenAddressString = tokenAddress.toHex();
  let amount = event.params.amount;
  
  log.warning("Staker 3",[])
  let lastMintIndex = event.params.lastMintIndex;
  
  log.warning("Staker 4",[])
  // NOTE: This will create a new (empyt) StakerState if the user is not staking immediately
  let state = getOrCreateStakerState(tokenAddressString, lastMintIndex, event);
  log.warning("Staker 5",[])
  
  let user = getOrCreateUser(userAddress, event);
  log.warning("Staker 6",[])
  
  let syntheticToken = SyntheticToken.load(tokenAddressString);
  if (syntheticToken == null) {
    /////// THIS IS A BUG!!!!! TEMPORARILY IGNORING. THE SYNTHETIC TOKEN SHOULD NEVER BE UNDEFINED IN THIS FUNCTION.
    return
    // log.critical("Token should be defined", []);
  }
  log.warning("Staker 7",[])
  
  let stake = new Stake(txHash.toHex());
  log.warning("Staker 8",[])
  stake.timestamp = timestamp;
  stake.blockNumber = blockNumber;
  stake.creationTxHash = txHash;
  stake.syntheticToken = syntheticToken.id;
  stake.user = user.id;
  stake.amount = amount;
  stake.withdrawn = false;
  log.warning("Staker 9",[])
  
  let currentStake = CurrentStake.load(
    tokenAddressString + "-" + userAddressString + "-currentStake"
    );
    log.warning("Staker 10",[])
    if (currentStake == null) {
    log.warning("Staker 11",[])
    // They won't have a current stake.
    currentStake = new CurrentStake(
      tokenAddressString + "-" + userAddressString + "-currentStake"
      );
    currentStake.user = user.id;
    currentStake.userAddress = user.address;
    currentStake.syntheticToken = syntheticToken.id;
    
    user.currentStakes = user.currentStakes.concat([currentStake.id]);
    log.warning("Staker 12",[])
  } else {
    log.warning("Staker 13",[])
    // Note: Only add if still relevant and not withdrawn
    let oldStake = Stake.load(currentStake.currentStake);
    log.warning("Staker 14",[])
    if (!oldStake.withdrawn) {
      stake.amount = stake.amount.plus(oldStake.amount);
      oldStake.withdrawn = true;
    }
    log.warning("Staker 15",[])
  }
  log.warning("Staker 16",[])
  currentStake.currentStake = stake.id;
  log.warning("Staker 17",[])
  currentStake.lastMintState = state.id;
  
  log.warning("Staker 18",[])
  syntheticToken.totalStaked = syntheticToken.totalStaked.plus(amount);
  
  log.warning("Staker 19",[])
  stake.save();
  log.warning("Staker 20",[])
  currentStake.save();
  log.warning("Staker 21",[])
  user.save();
  log.warning("Staker 22",[])
  syntheticToken.save();
  log.warning("Staker 23g",[])

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
  let tokenAddress = event.params.tokenAddress;
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
  log.warning("fm 0", [])
  let userAddress = event.params.user;
  let userAddressString = userAddress.toHex();
  let tokenAddress = event.params.tokenAddress;
  let tokenAddressString = tokenAddress.toHex();
  let amount = event.params.amount;
  let lastMintIndex = event.params.lastMintIndex;
  log.warning("fm 1", [])
  
  let state = StakeState.load(
    tokenAddressString + "-" + lastMintIndex.toString()
    );
    log.warning("fm 2", [])
    if (state == null) {
      log.critical("state not defined yet in `handleFloatMinted`, tx hash {}", [
        event.transaction.hash.toHex(),
      ]);
    }
    let syntheticToken = SyntheticToken.load(tokenAddressString);
    log.warning("fm 3", [])
    syntheticToken.floatMintedFromSpecificToken = syntheticToken.floatMintedFromSpecificToken.plus(
      amount
      );
  log.warning("fm 4", [])
  
  let user = getOrCreateUser(userAddress, event);
  log.warning("fm 5", [])
  user.totalMintedFloat = user.totalMintedFloat.plus(amount);
  log.warning("fm 6", [])
  
  let currentStake = CurrentStake.load(
    tokenAddressString + "-" + userAddressString + "-currentStake"
    );
    log.warning("fm 7", [])
    currentStake.lastMintState = state.id;
  log.warning("fm 8", [])
  
  let globalState = GlobalState.load(GLOBAL_STATE_ID);
  log.warning("fm 9", [])
  globalState.totalFloatMinted = globalState.totalFloatMinted.plus(amount);
  log.warning("fm 10", [])
  
  syntheticToken.save();
  log.warning("fm 11", [])
  user.save();
  log.warning("fm 12", [])
  currentStake.save();
  log.warning("fm 13", [])
  globalState.save();
  
  log.warning("fm 14", [])
  saveEventToStateChange(
    event,
    "FloatMinted",
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
