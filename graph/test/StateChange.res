type address = string

type unclassifiedEvent = {
  name: string,
  data: Js.Dict.t<string>,
}

type transferData = {
  from: address,
  to: address,
  amount: BN.t,
}
type priceUpdateData = {
  marketIndex: BN.t,
  newPrice: BN.t,
  oldPrice: BN.t,
  user: address,
}
type tokenPriceRefreshedData = {
  marketIndex: BN.t,
  longTokenPrice: BN.t,
  shortTokenPrice: BN.t,
}
type valueLockedInSystemData = {
  marketIndex: BN.t,
  totalValueLockedInMarket: BN.t,
  longValue: BN.t,
  shortValue: BN.t,
}
type approvalData = {
  owner: address,
  spender: address,
  value: BN.t,
}
type shortMintedData = {
  marketIndex: BN.t,
  depositAdded: BN.t,
  finalDepositAmount: BN.t,
  tokensMinted: BN.t,
  user: address,
}
type stakeAddedData = {
  user: address,
  tokenAddress: address,
  amount: BN.t,
  lastMintIndex: BN.t,
}
type stateAddedData = {
  tokenAddress: address,
  stateIndex: BN.t,
  timestamp: BN.t,
  accumulative: BN.t,
}
type shortRedeemData = {
  marketIndex: BN.t,
  tokensRedeemed: BN.t,
  valueOfRedemption: BN.t,
  finalRedeem: BN.t,
  user: address,
}
type longMintedData = {
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
  finalRedeem: BN.t,
  user: address,
}
type deployV1Data = {floatAddress: address}
type feesChangesData = {
  marketIndex: BN.t,
  baseEntryFee: BN.t,
  badLiquidityEntryFee: BN.t,
  baseExitFee: BN.t,
  badLiquidityExitFee: BN.t,
}
type syntheticTokenCreatedData = {
  marketIndex: BN.t,
  longTokenAddress: address,
  shortTokenAddress: address,
  assetPrice: BN.t,
  name: string,
  symbol: string,
  oracleAddress: address,
}
type floatMintedData = {
  user: address,
  tokenAddress: address,
  amount: BN.t,
  lastMintIndex: BN.t,
}
type v1Data = {
  admin: address,
  tokenFactory: address,
  staker: address,
}

type stateChanges =
  | Unclassified(unclassifiedEvent)
  | Transfer(transferData)
  | PriceUpdate(priceUpdateData)
  | TokenPriceRefreshed(tokenPriceRefreshedData)
  | ValueLockedInSystem(valueLockedInSystemData)
  | Approval(approvalData)
  | ShortMinted(shortMintedData)
  | StakeAdded(stakeAddedData)
  | StateAdded(stateAddedData)
  | ShortRedeem(shortRedeemData)
  | LongMinted(longMintedData)
  | LongRedeem(longRedeemData)
  | DeployV1(deployV1Data)
  | FeesChanges(feesChangesData)
  | SyntheticTokenCreated(syntheticTokenCreatedData)
  | FloatMinted(floatMintedData)
  | V1(v1Data)

let getBnParam = (paramsObject, paramName) =>
  paramsObject->Js.Dict.get(paramName)->Option.map(BN.new_)->Option.getExn
let getStr = (paramsObject, paramName) => paramsObject->Js.Dict.get(paramName)->Option.getExn

let getStateChange = (
  {eventName, params}: Queries.GetAllStateChanges.t_stateChanges_txEventParamList,
) => {
  let paramsObject = Js.Dict.empty()
  params->Array.forEach(({param, paramName}) => paramsObject->Js.Dict.set(paramName, param))

  let unimplementedPlaceholder = {
    "TODO": "This isn't implemented",
  }

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
  | "TokenPriceRefreshed" => TokenPriceRefreshed(unimplementedPlaceholder->Obj.magic)
  // | "FeesLevied" => FeesLevied(unimplementedPlaceholder->Obj.magic)
  | "SyntheticTokenCreated" => SyntheticTokenCreated(unimplementedPlaceholder->Obj.magic)
  | "PriceUpdate" => PriceUpdate(unimplementedPlaceholder->Obj.magic)
  | "LongMinted" => LongMinted(unimplementedPlaceholder->Obj.magic)
  | "ShortMinted" => ShortMinted(unimplementedPlaceholder->Obj.magic)
  | "LongRedeem" => LongRedeem(unimplementedPlaceholder->Obj.magic)
  | "ShortRedeem" => ShortRedeem(unimplementedPlaceholder->Obj.magic)
  | "FeesChanges" => FeesChanges(unimplementedPlaceholder->Obj.magic)
  | "StakeAdded" => StakeAdded(unimplementedPlaceholder->Obj.magic)
  | "Transfer" => Transfer(unimplementedPlaceholder->Obj.magic)
  | "Approval" => Approval(unimplementedPlaceholder->Obj.magic)
  | "StateAdded" => StateAdded(unimplementedPlaceholder->Obj.magic)
  | "FloatMinted" => FloatMinted(unimplementedPlaceholder->Obj.magic)
  | "DeployV1" => DeployV1(unimplementedPlaceholder->Obj.magic)
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
