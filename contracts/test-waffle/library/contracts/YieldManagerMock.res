@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "YieldManagerMock"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: (
  ~admin: Ethers.ethAddress,
  ~longShort: Ethers.ethAddress,
  ~token: Ethers.ethAddress,
) => JsPromise.t<t> = (~admin, ~longShort, ~token) =>
  deployContract3(contractName, admin, longShort, token)->Obj.magic

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

@send
external depositToken: (t, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> = "depositToken"

type getHeldTokenReturn = Ethers.ethAddress
@send
external getHeldToken: t => JsPromise.t<getHeldTokenReturn> = "getHeldToken"

@send
external getTotalHeld: t => JsPromise.t<transaction> = "getTotalHeld"

type getTotalHeldReturn = Ethers.BigNumber.t
@send @scope("callStatic")
external getTotalHeldCall: t => JsPromise.t<getTotalHeldReturn> = "getTotalHeld"

type lastSettledReturn = Ethers.BigNumber.t
@send
external lastSettled: t => JsPromise.t<lastSettledReturn> = "lastSettled"

type longShortReturn = Ethers.ethAddress
@send
external longShort: t => JsPromise.t<longShortReturn> = "longShort"

@send
external setYieldRate: (t, ~yieldRate: Ethers.BigNumber.t) => JsPromise.t<transaction> =
  "setYieldRate"

@send
external settle: t => JsPromise.t<transaction> = "settle"

@send
external settleWithYield: (t, ~yield: Ethers.BigNumber.t) => JsPromise.t<transaction> =
  "settleWithYield"

type tokenReturn = Ethers.ethAddress
@send
external token: t => JsPromise.t<tokenReturn> = "token"

type totalHeldReturn = Ethers.BigNumber.t
@send
external totalHeld: t => JsPromise.t<totalHeldReturn> = "totalHeld"

@send
external withdrawToken: (t, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> =
  "withdrawToken"

type yieldRateReturn = Ethers.BigNumber.t
@send
external yieldRate: t => JsPromise.t<yieldRateReturn> = "yieldRate"

type yieldScaleReturn = Ethers.BigNumber.t
@send
external yieldScale: t => JsPromise.t<yieldScaleReturn> = "yieldScale"
