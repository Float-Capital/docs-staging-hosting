open Converters
open ConverterTypes

let getStateChange = (
  {eventName, params}: Queries.GetAllStateChanges.t_stateChanges_txEventParamList,
) => {
  let paramsObject = Js.Dict.empty()
  params->Array.forEach(({param, paramName}) =>
    paramsObject->Js.Dict.set(paramName, param->Js.Json.string)
  )
  covertToStateChange(eventName, paramsObject)
}

type blockNumber = int
type timestamp = int
type eventData<'a> = {
  blockNumber: blockNumber,
  timestamp: timestamp,
  txHash: string,
  data: 'a,
}

let getAllStateChangeEvents = allStateChangesRaw =>
  allStateChangesRaw->Js.Promise.then_(rawStateChanges => {
    rawStateChanges
    ->Array.reduce([], (
      currentArrayOfStateChanges,
      {Queries.GetAllStateChanges.id: id, txEventParamList, blockNumber, timestamp},
    ) =>
      currentArrayOfStateChanges->Array.concat(
        txEventParamList->Array.map(eventRaw => {
          blockNumber: blockNumber->BN.toNumber,
          timestamp: timestamp->BN.toNumber,
          txHash: id,
          data: eventRaw->getStateChange,
        }),
      )
    )
    ->Js.Promise.resolve
  }, _)

type eventGroup = {
  allV1Events: array<eventData<v1Data>>,
  allUnclassifiedEvents: array<unclassifiedEvent>,
}
let emptyEventGroups = {
  allV1Events: [],
  allUnclassifiedEvents: [],
}
let splitIntoEventGroups = allStateChanges => allStateChanges->Js.Promise.then_(stateChanges =>
    stateChanges
    ->Array.reduce(emptyEventGroups, (currentEventGroups, {blockNumber, timestamp, txHash, data}) =>
      switch data {
      | V1(stakeData) => {
          ...currentEventGroups,
          allV1Events: currentEventGroups.allV1Events->Array.concat([
            {blockNumber: blockNumber, timestamp: timestamp, data: stakeData, txHash: txHash},
          ]),
        }
      | Unclassified(event) => {
          ...currentEventGroups,
          allUnclassifiedEvents: currentEventGroups.allUnclassifiedEvents->Array.concat([event]),
        }
      | _TODO => currentEventGroups
      }
    )
    ->Js.Promise.resolve
  , _)
