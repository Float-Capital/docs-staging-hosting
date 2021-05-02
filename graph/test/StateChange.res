type address = string

type v1Data = {
  admin: address,
  staker: address,
  tokenFactory: address,
}
type valueLockedInSystemData = {
  marketIndex: BN.t,
  totalValueLockedInMarket: BN.t,
  longValue: BN.t,
  shortValue: BN.t,
}
type tokenPriceRefreshedData = {
  marketIndex: BN.t,
  longTokenPrice: BN.t,
  shortTokenPrice: BN.t,
}
type unclassifiedEvent = {
  name: string,
  data: Js.Dict.t<string>,
}
type feesLeviedData = {marketIndex: BN.t, totalFees: BN.t}
type syntheticTokenCreatedData = {
  marketIndex: BN.t,
  longTokenAddress: BN.t,
  shortTokenAddress: BN.t,
  fundToken: BN.t,
  assetPrice: BN.t,
  name: BN.t,
  symbol: BN.t,
  oracleAddress: BN.t,
}
type stateChanges =
  | V1(v1Data)
  | ValueLockedInSystem(valueLockedInSystemData)
  | TokenPriceRefreshed(tokenPriceRefreshedData)
  | FeesLevied(feesLeviedData)
  | SyntheticTokenCreat(syntheticTokenCreatedData)
  | Unclassified(unclassifiedEvent)

/*
    event SyntheticTokenCreated(
        uint32 marketIndex,
        address longTokenAddress,
        address shortTokenAddress,
        address fundToken,
        uint256 assetPrice,
        string name,
        string symbol,
        address oracleAddress
    );

    event PriceUpdate(
        uint32 marketIndex,
        uint256 oldPrice,
        uint256 newPrice,
        address user
    );

    event LongMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        uint256 finalDepositAmount,
        uint256 tokensMinted,
        address user
    );

    event ShortMinted(
        uint32 marketIndex,
        uint256 depositAdded,
        uint256 finalDepositAmount,
        uint256 tokensMinted,
        address user
    );

    event LongRedeem(
        uint32 marketIndex,
        uint256 tokensRedeemed,
        uint256 valueOfRedemption,
        uint256 finalRedeemValue,
        address user
    );

    event ShortRedeem(
        uint32 marketIndex,
        uint256 tokensRedeemed,
        uint256 valueOfRedemption,
        uint256 finalRedeemValue,
        address user
    );

    event FeesChanges(
        uint32 marketIndex,
        uint256 baseEntryFee,
        uint256 badLiquidityEntryFee,
        uint256 baseExitFee,
        uint256 badLiquidityExitFee
    );

*/
let getStateChange = (
  {eventName, params}: Queries.GetAllStateChanges.t_stateChanges_txEventParamList,
) => {
  let paramsObject = Js.Dict.empty()
  params->Array.forEach(({param, paramName}) => paramsObject->Js.Dict.set(paramName, param))

  // TODO: throw a (descriptive) error if the array of parameters is the wrong length (or make a separate test?)
  // TODO: turn `eventName` into a polymorphic variant (create a decoder for it) (for undefined make it #unclassified(string)
  switch eventName {
  | "V1" =>
    V1({
      admin: paramsObject->Js.Dict.get("admin")->Option.getExn,
      staker: paramsObject->Js.Dict.get("staker")->Option.getExn,
      tokenFactory: paramsObject->Js.Dict.get("tokenFactory")->Option.getExn,
    })
  | name => Unclassified({name: name, data: paramsObject})
  }
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
      | _ => currentEventGroups
      }
    )
    ->Js.Promise.resolve
  , _)
