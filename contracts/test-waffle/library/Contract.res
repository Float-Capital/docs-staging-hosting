type contractFactory
type t

type bytes32
type transaction = unit // TODO: make this better

@val @scope("ethers")
external getContractFactory: string => JsPromise.t<contractFactory> = "getContractFactory"
@send
external attachAtAddress: (contractFactory, ~contractAddress: Ethers.ethAddress) => JsPromise.t<t> =
  "attach"
@send external deploy: contractFactory => JsPromise.t<t> = "deploy"
@send external deploy1: (contractFactory, 'a) => JsPromise.t<t> = "deploy"
@send external deploy2: (contractFactory, 'a, 'b) => JsPromise.t<t> = "deploy"
@send external deploy3: (contractFactory, 'a, 'b, 'c) => JsPromise.t<t> = "deploy"
@send external deploy4: (contractFactory, 'a, 'b, 'c, 'd) => JsPromise.t<t> = "deploy"

@send external deployed: t => JsPromise.t<unit> = "deployed"

let attachToContract = (contractName, ~contractAddress) => {
  getContractFactory(contractName)->JsPromise.then(attachAtAddress(~contractAddress))
}
let deployContract = contractName => {
  getContractFactory(contractName)->JsPromise.then(deploy)->JsPromise.then(deployed)
}
let deployContract1 = (contractName, firstParam) => {
  getContractFactory(contractName)->JsPromise.then(deploy1(_, firstParam))->JsPromise.then(deployed)
}
let deployContract2 = (contractName, firstParam, secondParam) => {
  getContractFactory(contractName)
  ->JsPromise.then(deploy2(_, firstParam, secondParam))
  ->JsPromise.then(deployed)
}
let deployContract3 = (contractName, firstParam, secondParam, thirdParam) => {
  getContractFactory(contractName)
  ->JsPromise.then(deploy3(_, firstParam, secondParam, thirdParam))
  ->JsPromise.then(deployed)
}

@send external connect: ('contract, ~address: Ethers.Wallet.t) => 'contract = "connect"

module SyntheticToken = {
  type t = {address: Ethers.ethAddress}
  let contractName = "SyntheticToken"

  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic

  @send
  external setup: (t, string, string, Ethers.ethAddress) => JsPromise.t<transaction> = "stake"

  @send
  external balanceOf: (t, ~account: Ethers.ethAddress) => JsPromise.t<Ethers.BigNumber.t> =
    "balanceOf"
}

type staker

module PaymentToken = {
  type t = {address: Ethers.ethAddress}
  let contractName = "ERC20PresetMinterPauser"

  let make: (~name: string, ~symbol: string) => JsPromise.t<t> = (~name, ~symbol) =>
    deployContract2(contractName, name, symbol)->Obj.magic
  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic

  @send @scope(`MINTER_ROLE`)
  external getMintRole: t => JsPromise.t<bytes32> = "call"
  @send
  external grantRole: (t, ~minterRole: bytes32, ~user: Ethers.ethAddress) => JsPromise.t<unit> =
    "grantRole"

  let grantMintRole = (t, ~user) =>
    t->getMintRole->JsPromise.then(minterRole => t->grantRole(~minterRole, ~user))

  @send
  external mint: (t, ~user: Ethers.ethAddress, ~amount: Ethers.BigNumber.t) => JsPromise.t<unit> =
    "mint"
  @send
  external approve: (
    t,
    ~spender: Ethers.ethAddress,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<unit> = "approve"
  let mintAndApprove = (
    t,
    ~user: Ethers.Wallet.t,
    ~amount: Ethers.BigNumber.t,
    ~spender: Ethers.ethAddress,
  ) =>
    t
    ->mint(~amount, ~user=user.address)
    ->JsPromise.then(_ => {
      t->connect(~address=user)->approve(~amount, ~spender)
    })
}

module YieldManagerMock = {
  type t = {address: Ethers.ethAddress}
  let contractName = "YieldManagerMock"

  let make: (Ethers.ethAddress, Ethers.ethAddress, Ethers.ethAddress) => JsPromise.t<t> = (
    admin,
    longShortAddress,
    fundTokenAddress,
  ) => deployContract3(contractName, admin, longShortAddress, fundTokenAddress)->Obj.magic
  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic
}

module OracleManagerMock = {
  type t = {address: Ethers.ethAddress}
  let contractName = "OracleManagerMock"

  let make: Ethers.ethAddress => JsPromise.t<t> = admin =>
    deployContract1(contractName, admin)->Obj.magic
  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic

  @send
  external setPrice: (t, ~newPrice: Ethers.BigNumber.t) => JsPromise.t<transaction> = "setPrice"
  @send
  external getLatestPrice: t => JsPromise.t<Ethers.BigNumber.t> = "getLatestPrice"
}

module LongShort = {
  type t = {address: Ethers.ethAddress}
  let contractName = "LongShort"
  let contractNameExposed = "LongShortInternalsExposed"
  let makeExposed: unit => JsPromise.t<t> = () => deployContract(contractNameExposed)->Obj.magic

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send
  external setup: (
    t,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "initialize"
  @send
  external newSyntheticMarket: (
    t,
    ~marketName: string,
    ~marketSymbol: string,
    ~paymentToken: Ethers.ethAddress,
    ~oracleManager: Ethers.ethAddress,
    ~yieldManager: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "newSyntheticMarket"
  @send
  external initializeMarket: (
    t,
    ~marketIndex: int,
    ~baseEntryFee: int,
    ~badLiquidityEntryFee: int,
    ~baseExitFee: int,
    ~badLiquidityExitFee: int,
    ~kInitialMultiplier: Ethers.BigNumber.t,
    ~kPeriod: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "initializeMarket"

  type batchedLazyDeposit = {
    mintLong: Ethers.BigNumber.t,
    mintShort: Ethers.BigNumber.t,
    mintAndStakeLong: Ethers.BigNumber.t,
    mintAntStakeShort: Ethers.BigNumber.t,
  }

  @send
  external batchedLazyDeposit: (t, ~marketIndex: int) => JsPromise.t<batchedLazyDeposit> =
    "batchedLazyDeposit"

  @send
  external fundTokens: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> = "fundTokens"

  @send
  external longSynth: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> = "longTokens"
  @send
  external shortSynth: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> = "shortTokens"
  @send
  external yieldManagers: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> = "yieldManagers"
  @send
  external oracleManagers: (t, ~marketIndex: int) => JsPromise.t<Ethers.ethAddress> =
    "oracleManagers"
  @send
  external staker: t => JsPromise.t<Ethers.ethAddress> = "staker"

  @send
  external latestMarket: t => JsPromise.t<int> = "latestMarket"

  @send
  external mintLongLazy: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintLongLazy"

  @send
  external mintShortLazy: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintShortLazy"

  @send
  external mintLongAndStakeLazy: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintLongAndStakeLazy"

  @send
  external mintShortAndStakeLazy: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintShortAndStakeLazy"

  @send
  external mintLongAndStake: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintLongAndStake"
  @send
  external mintShortAndStake: (
    t,
    ~marketIndex: int,
    ~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "mintShortAndStake"
  @send
  external updateMarketOracle: (
    t,
    ~marketIndex: int,
    ~newOracleAddress: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "updateMarketOracle"
  @send
  external _updateSystemState: (t, ~marketIndex: int) => JsPromise.t<transaction> =
    "_updateSystemState"

  @send
  external longTokenPrice: (t, ~marketIndex: int) => JsPromise.t<Ethers.BigNumber.t> =
    "longTokenPrice"
  @send
  external shortTokenPrice: (t, ~marketIndex: int) => JsPromise.t<Ethers.BigNumber.t> =
    "shortTokenPrice"

  @send
  external longValue: (t, ~marketIndex: int) => JsPromise.t<Ethers.BigNumber.t> = "longValue"
  @send
  external shortValue: (t, ~marketIndex: int) => JsPromise.t<Ethers.BigNumber.t> = "shortValue"

  type userLazyActionsStruct = {
    usersCurrentUpdateIndex: Ethers.BigNumber.t,
    mintLong: Ethers.BigNumber.t,
    mintShort: Ethers.BigNumber.t,
    mintAndStakeLong: Ethers.BigNumber.t,
    mintAndStakeShort: Ethers.BigNumber.t,
  }
  @send
  external userLazyActions: (
    t,
    ~marketIndex: int,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<userLazyActionsStruct> = "userLazyActions"

  module Exposed = {
    @send
    external refreshTokensPrice: (t, ~marketIndex: int) => JsPromise.t<transaction> =
      "refreshTokensPrice"

    @send
    external feesMechanism: (
      t,
      ~marketIndex: int,
      ~totalFees: Ethers.BigNumber.t,
    ) => JsPromise.t<transaction> = "feesMechanism"

    @send
    external yieldMechanism: (t, ~marketIndex: int) => JsPromise.t<transaction> = "yieldMechanism"

    @send
    external minimum: (
      t,
      ~liquidityOfPositionA: Ethers.BigNumber.t,
      ~liquidityOfPositionB: Ethers.BigNumber.t,
    ) => JsPromise.t<Ethers.BigNumber.t> = "minimum"

    @send
    external calculateValueChangeForPriceMechanism: (
      t,
      ~marketIndex: int,
      ~assetPriceGreater: Ethers.BigNumber.t,
      ~assetPriceLess: Ethers.BigNumber.t,
      ~baseValueExposure: Ethers.BigNumber.t,
    ) => JsPromise.t<Ethers.BigNumber.t> = "calculateValueChangeForPriceMechanism"

    @send
    external depositFunds: (
      t,
      ~marketIndex: int,
      ~amount: Ethers.BigNumber.t,
    ) => JsPromise.t<transaction> = "depositFunds"

    @send
    external withdrawFunds: (
      t,
      ~marketIndex: int,
      ~amount: Ethers.BigNumber.t,
    ) => JsPromise.t<transaction> = "withdrawFunds"

    @send
    external transferToYieldManager: (
      t,
      ~marketIndex: int,
      ~amount: Ethers.BigNumber.t,
    ) => JsPromise.t<transaction> = "transferToYieldManager"

    @send
    external transferFromYieldManager: (
      t,
      ~marketIndex: int,
      ~amount: Ethers.BigNumber.t,
    ) => JsPromise.t<transaction> = "transferFromYieldManager"

    @send
    external getFeesForAmounts: (
      t,
      ~marketIndex: int,
      ~baseAmount: Ethers.BigNumber.t,
      ~penaltyAmount: Ethers.BigNumber.t,
      ~isMint: bool,
    ) => JsPromise.t<Ethers.BigNumber.t> = "getFeesForAmounts"

    @send
    external getFeesForAction: (
      t,
      ~marketIndex: int,
      ~amount: Ethers.BigNumber.t,
      ~isMint: bool,
      ~isLong: bool,
    ) => JsPromise.t<Ethers.BigNumber.t> = "getFeesForAction"

    @send
    external priceChangeMechanism: (
      t,
      ~marketIndex: int,
      ~newPrice: Ethers.BigNumber.t,
    ) => JsPromise.t<Ethers.BigNumber.t> = "priceChangeMechanism"

    @send @scope("callStatic")
    external calculateAccumulatedFloatExposedCall: (
      t,
      ~marketIndex: int,
      ~user: Ethers.ethAddress,
    ) => JsPromise.t<{
      "longFloatReward": Ethers.BigNumber.t,
      "shortFloatReward": Ethers.BigNumber.t,
    }> = "calculateAccumulatedFloatExposed"

    @send
    external setUseexecuteOutstandingLazySettlementsMock: (
      t,
      ~shouldUseMock: bool,
    ) => JsPromise.t<transaction> = "setUseexecuteOutstandingLazySettlementsMock"

    @send
    external _executeOutstandingLazySettlementsExposed: (
      t,
      ~user: Ethers.ethAddress,
      ~marketIndex: int,
    ) => JsPromise.t<transaction> = "_executeOutstandingLazySettlements" // "_executeOutstandingLazySettlementsExposed"
  }
}

// module GenericErc20 = {
//   type t = {address: Ethers.ethAddress}
//   let contractName = "ERC20PresetMinterPauserUpgradeable"

//   let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

//   @send
//   external mint: (t, ~user: Ethers.Wallet.t, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> = "mint"
// }

module TokenFactory = {
  type t = {address: Ethers.ethAddress}
  let contractName = "TokenFactory"

  let make: (Ethers.ethAddress, Ethers.ethAddress) => JsPromise.t<t> = (admin, longShort) =>
    deployContract2(contractName, admin, longShort)->Obj.magic
}

module Staker = {
  type t = {address: Ethers.ethAddress}

  let contractName = "Staker"
  let contractNameExposed = "StakerInternalsExposed"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
  let makeExposed: unit => JsPromise.t<t> = () => deployContract(contractNameExposed)->Obj.magic
  let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
    attachToContract(contractName, ~contractAddress)->Obj.magic

  @send
  external setup: (
    t,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "initialize"

  @send
  external claimFloatCustom: (t, ~markets: array<int>) => JsPromise.t<transaction> =
    "claimFloatCustom"
  let claimFloatCustomUser = (staker, ~user: Ethers.Wallet.t, ~markets: array<int>) =>
    staker->connect(~address=user)->claimFloatCustom(~markets)

  @send
  external marketIndexOfToken: (t, ~syntheticToken: Ethers.ethAddress) => JsPromise.t<int> =
    "marketIndexOfToken"

  @send
  external userAmountStaked: (
    t,
    ~syntheticToken: Ethers.ethAddress,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<Ethers.BigNumber.t> = "userAmountStaked"

  @send
  external userIndexOfLastClaimedReward: (
    t,
    ~market: int,
    ~user: Ethers.ethAddress,
  ) => JsPromise.t<Ethers.BigNumber.t> = "userIndexOfLastClaimedReward"

  @send
  external latestRewardIndex: (t, ~market: int) => JsPromise.t<Ethers.BigNumber.t> =
    "latestRewardIndex"

  module Exposed = {
    @send
    external setFloatRewardCalcParams: (
      t,
      ~marketIndex: int,
      ~longToken: Ethers.ethAddress,
      ~shortToken: Ethers.ethAddress,
      ~newLatestRewardIndex: Ethers.BigNumber.t,
      ~user: Ethers.ethAddress,
      ~usersLatestClaimedReward: Ethers.BigNumber.t,
      ~accumulativeFloatPerTokenLatestLong: Ethers.BigNumber.t,
      ~accumulativeFloatPerTokenLatestShort: Ethers.BigNumber.t,
      ~accumulativeFloatPerTokenUserLong: Ethers.BigNumber.t,
      ~accumulativeFloatPerTokenUserShort: Ethers.BigNumber.t,
      ~newUserAmountStakedLong: Ethers.BigNumber.t,
      ~newUserAmountStakedShort: Ethers.BigNumber.t,
    ) => JsPromise.t<transaction> = "setFloatRewardCalcParams"

    @send @scope("callStatic")
    external calculateAccumulatedFloatExposedCall: (
      t,
      ~marketIndex: int,
      ~user: Ethers.ethAddress,
    ) => JsPromise.t<{
      "longFloatReward": Ethers.BigNumber.t,
      "shortFloatReward": Ethers.BigNumber.t,
    }> = "calculateAccumulatedFloatExposed"

    @send
    external calculateAccumulatedFloatExposed: (
      t,
      ~marketIndex: int,
      ~user: Ethers.ethAddress,
    ) => JsPromise.t<transaction> = "calculateAccumulatedFloatExposed"
  }
}

module FloatToken = {
  type t = {address: Ethers.ethAddress}
  let contractName = "FloatToken"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send
  external setup: (t, string, string, Ethers.ethAddress) => JsPromise.t<transaction> = "initialize3"
}

module FloatCapital_v0 = {
  type t = {address: Ethers.ethAddress}
  let contractName = "FloatCapital_v0"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic
}

module Treasury_v0 = {
  type t = {address: Ethers.ethAddress}
  let contractName = "Treasury_v0"

  let make: unit => JsPromise.t<t> = () => deployContract(contractName)->Obj.magic

  @send external setup: (t, Ethers.ethAddress) => JsPromise.t<transaction> = "initialize"
}

module DataFetchers = {
  let marketIndexOfSynth = (longShort: LongShort.t, ~syntheticToken: SyntheticToken.t): JsPromise.t<
    int,
  > =>
    longShort
    ->LongShort.staker
    ->JsPromise.then(Staker.at)
    ->JsPromise.then(Staker.marketIndexOfToken(~syntheticToken=syntheticToken.address))
}
