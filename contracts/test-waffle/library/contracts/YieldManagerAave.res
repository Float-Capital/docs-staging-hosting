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

type tEN_TO_THE_5Return = Ethers.BigNumber.t
@send
external tEN_TO_THE_5: t => JsPromise.t<tEN_TO_THE_5Return> = "TEN_TO_THE_5"

type aTokenReturn = Ethers.ethAddress
@send
external aToken: t => JsPromise.t<aTokenReturn> = "aToken"

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

@send
external changeAdmin: (t, ~admin: Ethers.ethAddress) => JsPromise.t<transaction> = "changeAdmin"

@send
external claimYieldAndGetMarketAmount: (
  t,
  ~marketPcntE5: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "claimYieldAndGetMarketAmount"

type claimYieldAndGetMarketAmountReturn = Ethers.BigNumber.t
@send @scope("callStatic")
external claimYieldAndGetMarketAmountCall: (
  t,
  ~marketPcntE5: Ethers.BigNumber.t,
) => JsPromise.t<claimYieldAndGetMarketAmountReturn> = "claimYieldAndGetMarketAmount"

@send
external depositToken: (t, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> = "depositToken"

type lendingPoolReturn = Ethers.ethAddress
@send
external lendingPool: t => JsPromise.t<lendingPoolReturn> = "lendingPool"

type longShortReturn = Ethers.ethAddress
@send
external longShort: t => JsPromise.t<longShortReturn> = "longShort"

type tokenReturn = Ethers.ethAddress
@send
external token: t => JsPromise.t<tokenReturn> = "token"

type totalValueRealizedReturn = Ethers.BigNumber.t
@send
external totalValueRealized: t => JsPromise.t<totalValueRealizedReturn> = "totalValueRealized"

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
