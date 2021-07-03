@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "YieldManagerMock"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: (
  ~admin: Ethers.ethAddress,
  ~longShort: Ethers.ethAddress,
  ~treasury: Ethers.ethAddress,
  ~token: Ethers.ethAddress,
) => JsPromise.t<t> = (~admin, ~longShort, ~treasury, ~token) =>
  deployContract4(contractName, admin, longShort, treasury, token)->Obj.magic

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

@send
external claimYieldAndGetMarketAmount: (
  t,
  ~totalValueRealizedForMarket: Ethers.BigNumber.t,
  ~marketPcntE5: Ethers.BigNumber.t,
) => JsPromise.t<transaction> = "claimYieldAndGetMarketAmount"

type claimYieldAndGetMarketAmountReturn = Ethers.BigNumber.t
@send @scope("callStatic")
external claimYieldAndGetMarketAmountCall: (
  t,
  ~totalValueRealizedForMarket: Ethers.BigNumber.t,
  ~marketPcntE5: Ethers.BigNumber.t,
) => JsPromise.t<claimYieldAndGetMarketAmountReturn> = "claimYieldAndGetMarketAmount"

@send
external depositPaymentToken: (t, ~amount: Ethers.BigNumber.t) => JsPromise.t<transaction> =
  "depositPaymentToken"

type lastSettledReturn = Ethers.BigNumber.t
@send
external lastSettled: t => JsPromise.t<lastSettledReturn> = "lastSettled"

type longShortReturn = Ethers.ethAddress
@send
external longShort: t => JsPromise.t<longShortReturn> = "longShort"

@send
external mockHoldingAdditionalRewardYield: t => JsPromise.t<transaction> =
  "mockHoldingAdditionalRewardYield"

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

type tokenOtherRewardERC20Return = Ethers.ethAddress
@send
external tokenOtherRewardERC20: t => JsPromise.t<tokenOtherRewardERC20Return> =
  "tokenOtherRewardERC20"

type totalHeldReturn = Ethers.BigNumber.t
@send
external totalHeld: t => JsPromise.t<totalHeldReturn> = "totalHeld"

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

type yieldRateReturn = Ethers.BigNumber.t
@send
external yieldRate: t => JsPromise.t<yieldRateReturn> = "yieldRate"

type yieldScaleReturn = Ethers.BigNumber.t
@send
external yieldScale: t => JsPromise.t<yieldScaleReturn> = "yieldScale"
