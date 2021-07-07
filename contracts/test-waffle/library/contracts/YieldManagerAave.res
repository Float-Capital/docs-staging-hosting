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
  ~paymentToken: Ethers.ethAddress,
  ~aToken: Ethers.ethAddress,
  ~lendingPool: Ethers.ethAddress,
  ~aaveReferalCode: int,
) => JsPromise.t<t> = (
  ~admin,
  ~longShort,
  ~treasury,
  ~paymentToken,
  ~aToken,
  ~lendingPool,
  ~aaveReferalCode,
) =>
  deployContract7(
    contractName,
    admin,
    longShort,
    treasury,
    paymentToken,
    aToken,
    lendingPool,
    aaveReferalCode,
  )->Obj.magic

type tEN_TO_THE_18Return = Ethers.BigNumber.t
@send
external tEN_TO_THE_18: t => JsPromise.t<tEN_TO_THE_18Return> = "TEN_TO_THE_18"

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
  ~totalValueRealizedForMarket: Ethers.BigNumber.t,
  ~marketPercentE18: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "claimYieldAndGetMarketAmount"

type claimYieldAndGetMarketAmountReturn = Ethers.BigNumber.t
@send @scope("callStatic")
external claimYieldAndGetMarketAmountCall: (
  t,
  ~totalValueRealizedForMarket: Ethers.BigNumber.t,
  ~marketPercentE18: Ethers.BigNumber.t,
) => JsPromise.t<claimYieldAndGetMarketAmountReturn> = "claimYieldAndGetMarketAmount"

@send
external depositPaymentToken: (t, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> =
  "depositPaymentToken"

type lendingPoolReturn = Ethers.ethAddress
@send
external lendingPool: t => JsPromise.t<lendingPoolReturn> = "lendingPool"

type longShortReturn = Ethers.ethAddress
@send
external longShort: t => JsPromise.t<longShortReturn> = "longShort"

type paymentTokenReturn = Ethers.ethAddress
@send
external paymentToken: t => JsPromise.t<paymentTokenReturn> = "paymentToken"

type totalReservedForTreasuryReturn = Ethers.BigNumber.t
@send
external totalReservedForTreasury: t => JsPromise.t<totalReservedForTreasuryReturn> =
  "totalReservedForTreasury"

type treasuryReturn = Ethers.ethAddress
@send
external treasury: t => JsPromise.t<treasuryReturn> = "treasury"

@send
external withdrawErc20TokenToTreasury: (
  t,
  ~erc20Token: Ethers.ethAddress,
) => JsPromise.t<transaction> = "withdrawErc20TokenToTreasury"

@send
external withdrawPaymentToken: (t, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> =
  "withdrawPaymentToken"

@send
external withdrawTreasuryFunds: t => JsPromise.t<transaction> = "withdrawTreasuryFunds"
