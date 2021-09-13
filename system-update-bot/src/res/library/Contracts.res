type txOptions = {gasPrice: Ethers.BigNumber.t}

module Oracle = {
  type t = Ethers.Contract.t

  let abi =
    [
      "function phaseId() external view returns (uint16)",
      "function phaseAggregators(uint16) external view returns (address)",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)

  @send
  external phaseId: t => JsPromise.t<int> = "phaseId"

  @send
  external phaseAggregators: (t, ~phase: int) => JsPromise.t<Ethers.ethAddress> = "phaseAggregators"
}

module LongShort = {
  type t = Ethers.Contract.t

  let abi =
    [
      "function updateSystemState(uint32 marketIndex) external @400000",
      "function updateSystemStateMulti(uint32[] calldata marketIndexes) external @2800000",
    ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)
  @send
  external updateSystemState: (t, ~marketIndex: int) => JsPromise.t<Ethers.txSubmitted> =
    "updateSystemState"

  @send @scope("functions")
  external updateSystemStateMulti: (
    t,
    ~marketIndexes: array<int>,
    ~gasOptions: txOptions,
  ) => JsPromise.t<Ethers.txSubmitted> = "updateSystemStateMulti"
}
