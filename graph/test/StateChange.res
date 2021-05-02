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
type feesLeviedData = {marketIndex: BN.t, totalFees: BN.t}
type syntheticTokenCreatedData = {
  marketIndex: BN.t,
  longTokenAddress: address,
  shortTokenAddress: address,
  fundToken: address,
  assetPrice: BN.t,
  name: string,
  symbol: string,
  oracleAddress: address,
}
type priceUpdateData = {
  marketIndex: BN.t,
  oldPrice: BN.t,
  newPrice: BN.t,
  user: address,
}
type longMintedData = {
  marketIndex: BN.t,
  depositAdded: BN.t,
  finalDepositAmount: BN.t,
  tokensMinted: BN.t,
  user: address,
}
type shortMintedData = {
  marketIndex: BN.t,
  depositAdded: BN.t,
  finalDepositAmount: BN.t,
  tokensMinted: BN.t,
  user: address,
}
type longRedeemData = {
  marketIndex: BN.t,
  tokensRedeemed: BN.t,
  valueOfRedemption: BN.t,
  finalRedeemValue: BN.t,
  user: address,
}
type shortRedeemData = {
  marketIndex: BN.t,
  tokensRedeemed: BN.t,
  valueOfRedemption: BN.t,
  finalRedeemValue: BN.t,
  user: address,
}
type feesChangesData = {
  marketIndex: BN.t,
  baseEntryFee: BN.t,
  badLiquidityEntryFee: BN.t,
  baseExitFee: BN.t,
  badLiquidityExitFee: BN.t,
}
type unclassifiedEvent = {
  name: string,
  data: Js.Dict.t<string>,
}

type stateChanges =
  | V1(v1Data)
  | ValueLockedInSystem(valueLockedInSystemData)
  | TokenPriceRefreshed(tokenPriceRefreshedData)
  | FeesLevied(feesLeviedData)
  | SyntheticTokenCreat(syntheticTokenCreatedData)
  | SyntheticTokenCreated(syntheticTokenCreatedData)
  | PriceUpdate(priceUpdateData)
  | LongMinted(longMintedData)
  | ShortMinted(shortMintedData)
  | LongRedeem(longRedeemData)
  | ShortRedeem(shortRedeemData)
  | FeesChanges(feesChangesData)
  | Unclassified(unclassifiedEvent)
  | StakeAdded
  | StateAdded
  | FloatMinted
  | DeployV1
  | Transfer
  | Approval

let getBnParam = (paramsObject, paramName) =>
  paramsObject->Js.Dict.get(paramName)->Option.map(BN.new_)->Option.getExn
let getStr = (paramsObject, paramName) => paramsObject->Js.Dict.get(paramName)->Option.getExn

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
      admin: paramsObject->getStr("admin"),
      staker: paramsObject->getStr("staker"),
      tokenFactory: paramsObject->getStr("tokenFactory"),
    })
  | "ValueLockedInSystem" =>
    ValueLockedInSystem({
      marketIndex: paramsObject->getBnParam("marketIndex"),
      totalValueLockedInMarket: paramsObject->getBnParam("totalValueLockedInMarket"),
      longValue: paramsObject->getBnParam("longValue"),
      shortValue: paramsObject->getBnParam("shortValue"),
    })
  | "TokenPriceRefreshed" =>
    TokenPriceRefreshed(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "FeesLevied" =>
    FeesLevied(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "SyntheticTokenCreat" =>
    SyntheticTokenCreat(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "SyntheticTokenCreated" =>
    SyntheticTokenCreated(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "PriceUpdate" =>
    PriceUpdate(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "LongMinted" =>
    LongMinted(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "ShortMinted" =>
    ShortMinted(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "LongRedeem" =>
    LongRedeem(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "ShortRedeem" =>
    ShortRedeem(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "FeesChanges" =>
    FeesChanges(
      {
        "TODO": "This isn't implemented",
      }->Obj.magic,
    )
  | "StakeAdded" => StakeAdded
  | "Transfer" => Transfer
  | "Approval" => Approval
  | "StateAdded" => StateAdded
  | "FloatMinted" => FloatMinted
  | "DeployV1" => DeployV1
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
      | Unclassified(event) => {
          ...currentEventGroups,
          allUnclassifiedEvents: currentEventGroups.allUnclassifiedEvents->Array.concat([event]),
        }
      | _TODO => currentEventGroups
      }
    )
    ->Js.Promise.resolve
  , _)
