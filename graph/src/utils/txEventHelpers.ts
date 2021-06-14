import {
  StateChange,
  EventParam,
  EventParams,
  GlobalState,
} from "../../generated-price-history/generated/schema";
import { Bytes, ethereum, log } from "@graphprotocol/graph-ts";
import { ONE, ZERO_ADDRESS } from "../CONSTANTS";
import { getOrCreateGlobalState, getOrCreateUser } from "./globalStateManager";

function getEventIndex(txHash: Bytes): i32 {
  let stateChange = StateChange.load(txHash.toHex());
  if (stateChange == null) {
    return 0;
  }
  return stateChange.txEventParamList.length;
}

function createEventParams(
  txHash: Bytes,
  argValues: Array<string>,
  argNames: Array<string>,
  argTypes: Array<string>
): Array<string> {
  let eventIndex: i32 = getEventIndex(txHash);

  let eventParamsArr: Array<string> = [];

  for (let index = 0; index < argValues.length; index++) {
    let eventParamFund = new EventParam(
      txHash.toHex() + "-" + eventIndex.toString() + "-" + index.toString()
    );
    eventParamFund.index = index;
    eventParamFund.paramName = argNames[index];
    eventParamFund.param = argValues[index];
    eventParamFund.paramType = argTypes[index];
    eventParamFund.save();

    eventParamsArr.push(eventParamFund.id);
  }

  return eventParamsArr;
}

function txEventParamsHelper(
  eventName: string,
  eventIndex: i32,
  eventTxHash: Bytes,
  eventParamsArr: Array<string>
): EventParams {
  let eventParams = new EventParams(
    eventTxHash.toHex() + "-" + eventIndex.toString()
  );

  eventParams.index = eventIndex;
  eventParams.eventName = eventName;
  eventParams.params = eventParamsArr;

  eventParams.save();

  return eventParams;
}

function txStateChangeHelper(
  event: ethereum.Event,
  eventName: string,
  eventParamArray: Array<string>,
  affectedUsers: Array<Bytes>,
  affectedStakes: Array<string>,
  toFloatContracts: bool = true
): void {
  let txHash = event.transaction.hash;

  let stateChange = StateChange.load(txHash.toHex());
  if (stateChange == null) {
    stateChange = new StateChange(txHash.toHex());
    stateChange.txEventParamList = [];
    stateChange.affectedUsers = [];
    stateChange.affectedStakes = [];

    if (toFloatContracts) {
      // Order important here since getOrCreateUser loads and saves global state for a new user
      let user = getOrCreateUser(event.transaction.from, event);
      let globalState = getOrCreateGlobalState();

      user.totalGasUsed = user.totalGasUsed.plus(event.block.gasUsed);
      user.numberOfTransactions = user.numberOfTransactions.plus(ONE);

      globalState.totalTxs = globalState.totalTxs.plus(ONE);
      globalState.totalGasUsed = globalState.totalGasUsed.plus(
        event.block.gasUsed
      );

      globalState.save();
      user.save();
    }
  }

  let eventIndex: i32 = getEventIndex(txHash);

  // create EventParams
  let eventParams = txEventParamsHelper(
    eventName,
    eventIndex,
    txHash,
    eventParamArray
  );

  // Update affected users
  for (let index = 0; index < affectedUsers.length; index++) {
    if (affectedUsers[index].toHex() != ZERO_ADDRESS) {
      let user = getOrCreateUser(affectedUsers[index], event);
      stateChange.affectedUsers =
        stateChange.affectedUsers.indexOf(user.id) === -1
          ? stateChange.affectedUsers.concat([user.id])
          : stateChange.affectedUsers;

      user.stateChangesAffectingUser =
        user.stateChangesAffectingUser.indexOf(stateChange.id) === -1
          ? user.stateChangesAffectingUser.concat([stateChange.id])
          : user.stateChangesAffectingUser;

      user.save();
    }
  }

  // Update affected stakes
  for (let index = 0; index < affectedStakes.length; index++) {
    let affectedStake = affectedStakes[index];
    stateChange.affectedStakes =
      stateChange.affectedStakes.indexOf(affectedStake) === -1
        ? stateChange.affectedStakes.concat([affectedStake])
        : stateChange.affectedStakes;
  }
  stateChange.timestamp = event.block.timestamp;
  stateChange.blockNumber = event.block.number;
  stateChange.gasUsed = event.block.gasUsed;
  stateChange.txEventParamList = stateChange.txEventParamList.concat([
    eventParams.id,
  ]);

  stateChange.save();
}

export function saveEventToStateChange(
  event: ethereum.Event,
  eventName: string,
  parameterValues: Array<string>,
  parameterNames: Array<string>,
  parameterTypes: Array<string>,
  affectedUsers: Array<Bytes>,
  affectedStakes: Array<string>,
  toFloatContracts: bool = true
): void {
  if (
    parameterValues.length !== parameterNames.length ||
    parameterNames.length !== parameterTypes.length
  ) {
    log.critical("The event parameters aren't the same length", []);
  }
  let eventParamsArr: Array<string> = createEventParams(
    event.transaction.hash,
    parameterValues,
    parameterNames,
    parameterTypes
  );

  txStateChangeHelper(
    event,
    eventName,
    eventParamsArr,
    affectedUsers,
    affectedStakes,
    toFloatContracts
  );
}
