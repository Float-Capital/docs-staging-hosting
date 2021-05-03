open ConverterTypes

@decco.decode
type transferData = {
  from: address,
  to: address,
  amount: bn,
}
@decco.decode
type priceUpdateData = {
  marketIndex: bn,
  newPrice: bn,
  oldPrice: bn,
  user: address,
}
@decco.decode
type tokenPriceRefreshedData = {
  marketIndex: bn,
  longTokenPrice: bn,
  shortTokenPrice: bn,
}
@decco.decode
type valueLockedInSystemData = {
  marketIndex: bn,
  totalValueLockedInMarket: bn,
  longValue: bn,
  shortValue: bn,
}
@decco.decode
type approvalData = {
  owner: address,
  spender: address,
  value: bn,
}
@decco.decode
type shortMintedData = {
  marketIndex: bn,
  depositAdded: bn,
  finalDepositAmount: bn,
  tokensMinted: bn,
  user: address,
}
@decco.decode
type stakeAddedData = {
  user: address,
  tokenAddress: address,
  amount: bn,
  lastMintIndex: bn,
}
@decco.decode
type stateAddedData = {
  tokenAddress: address,
  stateIndex: bn,
  timestamp: bn,
  accumulative: bn,
}
@decco.decode
type shortRedeemData = {
  marketIndex: bn,
  tokensRedeemed: bn,
  valueOfRedemption: bn,
  finalRedeem: bn,
  user: address,
}
@decco.decode
type longMintedData = {
  marketIndex: bn,
  depositAdded: bn,
  finalDepositAmount: bn,
  tokensMinted: bn,
  user: address,
}
@decco.decode
type longRedeemData = {
  marketIndex: bn,
  tokensRedeemed: bn,
  valueOfRedemption: bn,
  finalRedeem: bn,
  user: address,
}
@decco.decode
type deployV1Data = {
  floatAddress: address,
}
@decco.decode
type feesChangesData = {
  marketIndex: bn,
  baseEntryFee: bn,
  badLiquidityEntryFee: bn,
  baseExitFee: bn,
  badLiquidityExitFee: bn,
}
@decco.decode
type syntheticTokenCreatedData = {
  marketIndex: bn,
  longTokenAddress: address,
  shortTokenAddress: address,
  assetPrice: bn,
  name: string,
  symbol: string,
  oracleAddress: address,
}
@decco.decode
type floatMintedData = {
  user: address,
  tokenAddress: address,
  amount: bn,
  lastMintIndex: bn,
}
@decco.decode
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

let covertToStateChange = (eventName, paramsObject) => {
  // TODO: throw a (descriptive) error if the array of parameters is the wrong length (or make a separate test?)
  // TODO: turn `eventName` into a polymorphic variant (create a decoder for it) (for undefined make it #unclassified(string)
  switch eventName {
  | "Transfer" => Transfer(paramsObject->Js.Json.object_->transferData_decode->Result.getExn)
  | "PriceUpdate" => PriceUpdate(paramsObject->Js.Json.object_->priceUpdateData_decode->Result.getExn)
  | "TokenPriceRefreshed" => TokenPriceRefreshed(paramsObject->Js.Json.object_->tokenPriceRefreshedData_decode->Result.getExn)
  | "ValueLockedInSystem" => ValueLockedInSystem(paramsObject->Js.Json.object_->valueLockedInSystemData_decode->Result.getExn)
  | "Approval" => Approval(paramsObject->Js.Json.object_->approvalData_decode->Result.getExn)
  | "ShortMinted" => ShortMinted(paramsObject->Js.Json.object_->shortMintedData_decode->Result.getExn)
  | "StakeAdded" => StakeAdded(paramsObject->Js.Json.object_->stakeAddedData_decode->Result.getExn)
  | "StateAdded" => StateAdded(paramsObject->Js.Json.object_->stateAddedData_decode->Result.getExn)
  | "ShortRedeem" => ShortRedeem(paramsObject->Js.Json.object_->shortRedeemData_decode->Result.getExn)
  | "LongMinted" => LongMinted(paramsObject->Js.Json.object_->longMintedData_decode->Result.getExn)
  | "LongRedeem" => LongRedeem(paramsObject->Js.Json.object_->longRedeemData_decode->Result.getExn)
  | "DeployV1" => DeployV1(paramsObject->Js.Json.object_->deployV1Data_decode->Result.getExn)
  | "FeesChanges" => FeesChanges(paramsObject->Js.Json.object_->feesChangesData_decode->Result.getExn)
  | "SyntheticTokenCreated" => SyntheticTokenCreated(paramsObject->Js.Json.object_->syntheticTokenCreatedData_decode->Result.getExn)
  | "FloatMinted" => FloatMinted(paramsObject->Js.Json.object_->floatMintedData_decode->Result.getExn)
  | "V1" => V1(paramsObject->Js.Json.object_->v1Data_decode->Result.getExn)
  | name => Unclassified({name: name, data: paramsObject})
  }
}

