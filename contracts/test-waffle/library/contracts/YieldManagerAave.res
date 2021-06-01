@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "YieldManagerAave"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: (
  ~admin: Ethers.ethAddress,
  ~longShort: Ethers.ethAddress,
  ~treasury: Ethers.ethAddress,
  ~token: Ethers.ethAddress,
  ~aToken: Ethers.ethAddress,
  ~lendingPool: Ethers.ethAddress,
  ~aaveReferalCode: int,
) => JsPromise.t<t> = (
  ~admin,
  ~longShort,
  ~treasury,
  ~token,
  ~aToken,
  ~lendingPool,
  ~aaveReferalCode,
) =>
  deployContract7(
    contractName,
    admin,
    longShort,
    treasury,
    token,
    aToken,
    lendingPool,
    aaveReferalCode,
  )->Obj.magic

type aTokenReturn = Ethers.ethAddress
@send
external aToken: t => JsPromise.t<aTokenReturn> = "aToken"

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

@send
external changeAdmin: (t, ~admin: Ethers.ethAddress) => JsPromise.t<transaction> = "changeAdmin"

@send
external depositToken: (t, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> = "depositToken"

type getHeldTokenReturn = Ethers.ethAddress
@send
external getHeldToken: t => JsPromise.t<getHeldTokenReturn> = "getHeldToken"

type getTotalHeldReturn = Ethers.BigNumber.t
@send
external getTotalHeld: t => JsPromise.t<getTotalHeldReturn> = "getTotalHeld"

type lendingPoolReturn = Ethers.ethAddress
@send
external lendingPool: t => JsPromise.t<lendingPoolReturn> = "lendingPool"

type longShortReturn = Ethers.ethAddress
@send
external longShort: t => JsPromise.t<longShortReturn> = "longShort"

type tokenReturn = Ethers.ethAddress
@send
external token: t => JsPromise.t<tokenReturn> = "token"

type treasuryReturn = Ethers.ethAddress
@send
external treasury: t => JsPromise.t<treasuryReturn> = "treasury"

@send
external withdrawErc20TokenToTreasury: (
  t,
  ~erc20Token: Ethers.ethAddress,
) => JsPromise.t<transaction> = "withdrawErc20TokenToTreasury"

@send
external withdrawToken: (t, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> =
  "withdrawToken"
