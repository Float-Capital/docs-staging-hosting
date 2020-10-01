import { StateChange, EventParam, EventParams } from "../../generated/schema";
import { BigInt, Address, Bytes, log } from "@graphprotocol/graph-ts";

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
    eventParamFund.param = argNames[index];
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
  txHash: Bytes,
  timeStamp: BigInt,
  blockNumber: BigInt,
  eventName: string,
  eventParamArray: Array<string>
): void {
  let stateChange = StateChange.load(txHash.toHex());
  if (stateChange == null) {
    stateChange = new StateChange(txHash.toHex());
    stateChange.txEventParamList = [];
  }

  let eventIndex: i32 = getEventIndex(txHash);

  // create EventParams
  let eventParams = txEventParamsHelper(
    eventName,
    eventIndex,
    txHash,
    eventParamArray
  );

  stateChange.timestamp = timeStamp;
  stateChange.blockNumber = blockNumber;
  stateChange.txEventParamList = stateChange.txEventParamList.concat([
    eventParams.id,
  ]);

  stateChange.save();
}

export function saveEventToStateChange(
  txHash: Bytes,
  timestamp: BigInt,
  blockNumber: BigInt,
  eventName: String,
  parameterValues: Array<string>,
  parameterNames: Array<string>,
  parameterTypes: Array<string>
): void {
  let eventParamsArr: Array<string> = createEventParams(
    txHash,
    parameterValues,
    parameterNames,
    parameterTypes
  );

  txStateChangeHelper(
    txHash,
    timestamp,
    blockNumber,
    eventName,
    eventParamsArr
  );
}
