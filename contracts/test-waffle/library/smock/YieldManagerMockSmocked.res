open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("YieldManagerMock")

let uninitializedValue: t = None->Obj.magic

@send @scope("TEN_TO_THE_18")
external mockTEN_TO_THE_18ToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type tEN_TO_THE_18Call

let tEN_TO_THE_18Old: t => array<tEN_TO_THE_18Call> = _r => {
  let array = %raw("_r.TEN_TO_THE_18.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external tEN_TO_THE_18CalledWith: expectation => unit = "calledWith"

@get external tEN_TO_THE_18Function: t => string = "tEN_TO_THE_18"

let tEN_TO_THE_18CallCheck = contract => {
  expect(contract->tEN_TO_THE_18Function)->tEN_TO_THE_18CalledWith
}

@send @scope("TEN_TO_THE_18")
external mockTEN_TO_THE_18ToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("TEN_TO_THE_18")
external mockTEN_TO_THE_18ToRevertNoReason: t => unit = "reverts"

@send @scope("admin")
external mockAdminToReturn: (t, Ethers.ethAddress) => unit = "returns"

type adminCall

let adminOld: t => array<adminCall> = _r => {
  let array = %raw("_r.admin.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external adminCalledWith: expectation => unit = "calledWith"

@get external adminFunction: t => string = "admin"

let adminCallCheck = contract => {
  expect(contract->adminFunction)->adminCalledWith
}

@send @scope("admin")
external mockAdminToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("admin")
external mockAdminToRevertNoReason: t => unit = "reverts"

type depositPaymentTokenCall = {amount: Ethers.BigNumber.t}

let depositPaymentTokenOld: t => array<depositPaymentTokenCall> = _r => {
  let array = %raw("_r.depositPaymentToken.calls")
  array->Array.map(_m => {
    let amount = _m->Array.getUnsafe(0)

    {
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external depositPaymentTokenCalledWith: (expectation, Ethers.BigNumber.t) => unit = "calledWith"

@get external depositPaymentTokenFunction: t => string = "depositPaymentToken"

let depositPaymentTokenCallCheck = (contract, {amount}: depositPaymentTokenCall) => {
  expect(contract->depositPaymentTokenFunction)->depositPaymentTokenCalledWith(amount)
}

@send @scope("depositPaymentToken")
external mockDepositPaymentTokenToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("depositPaymentToken")
external mockDepositPaymentTokenToRevertNoReason: t => unit = "reverts"

@send @scope("distributeYieldForTreasuryAndReturnMarketAllocation")
external mockDistributeYieldForTreasuryAndReturnMarketAllocationToReturn: (
  t,
  Ethers.BigNumber.t,
) => unit = "returns"

type distributeYieldForTreasuryAndReturnMarketAllocationCall = {
  totalValueRealizedForMarket: Ethers.BigNumber.t,
  treasuryYieldPercent_e18: Ethers.BigNumber.t,
}

let distributeYieldForTreasuryAndReturnMarketAllocationOld: t => array<
  distributeYieldForTreasuryAndReturnMarketAllocationCall,
> = _r => {
  let array = %raw("_r.distributeYieldForTreasuryAndReturnMarketAllocation.calls")
  array->Array.map(((totalValueRealizedForMarket, treasuryYieldPercent_e18)) => {
    {
      totalValueRealizedForMarket: totalValueRealizedForMarket,
      treasuryYieldPercent_e18: treasuryYieldPercent_e18,
    }
  })
}

@send @scope(("to", "have", "been"))
external distributeYieldForTreasuryAndReturnMarketAllocationCalledWith: (
  expectation,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get
external distributeYieldForTreasuryAndReturnMarketAllocationFunction: t => string =
  "distributeYieldForTreasuryAndReturnMarketAllocation"

let distributeYieldForTreasuryAndReturnMarketAllocationCallCheck = (
  contract,
  {
    totalValueRealizedForMarket,
    treasuryYieldPercent_e18,
  }: distributeYieldForTreasuryAndReturnMarketAllocationCall,
) => {
  expect(
    contract->distributeYieldForTreasuryAndReturnMarketAllocationFunction,
  )->distributeYieldForTreasuryAndReturnMarketAllocationCalledWith(
    totalValueRealizedForMarket,
    treasuryYieldPercent_e18,
  )
}

@send @scope("distributeYieldForTreasuryAndReturnMarketAllocation")
external mockDistributeYieldForTreasuryAndReturnMarketAllocationToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("distributeYieldForTreasuryAndReturnMarketAllocation")
external mockDistributeYieldForTreasuryAndReturnMarketAllocationToRevertNoReason: t => unit =
  "reverts"

type initializeForMarketCall

let initializeForMarketOld: t => array<initializeForMarketCall> = _r => {
  let array = %raw("_r.initializeForMarket.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external initializeForMarketCalledWith: expectation => unit = "calledWith"

@get external initializeForMarketFunction: t => string = "initializeForMarket"

let initializeForMarketCallCheck = contract => {
  expect(contract->initializeForMarketFunction)->initializeForMarketCalledWith
}

@send @scope("initializeForMarket")
external mockInitializeForMarketToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("initializeForMarket")
external mockInitializeForMarketToRevertNoReason: t => unit = "reverts"

@send @scope("isInitialized")
external mockIsInitializedToReturn: (t, bool) => unit = "returns"

type isInitializedCall

let isInitializedOld: t => array<isInitializedCall> = _r => {
  let array = %raw("_r.isInitialized.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external isInitializedCalledWith: expectation => unit = "calledWith"

@get external isInitializedFunction: t => string = "isInitialized"

let isInitializedCallCheck = contract => {
  expect(contract->isInitializedFunction)->isInitializedCalledWith
}

@send @scope("isInitialized")
external mockIsInitializedToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("isInitialized")
external mockIsInitializedToRevertNoReason: t => unit = "reverts"

@send @scope("lastSettled")
external mockLastSettledToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type lastSettledCall

let lastSettledOld: t => array<lastSettledCall> = _r => {
  let array = %raw("_r.lastSettled.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external lastSettledCalledWith: expectation => unit = "calledWith"

@get external lastSettledFunction: t => string = "lastSettled"

let lastSettledCallCheck = contract => {
  expect(contract->lastSettledFunction)->lastSettledCalledWith
}

@send @scope("lastSettled")
external mockLastSettledToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("lastSettled")
external mockLastSettledToRevertNoReason: t => unit = "reverts"

@send @scope("longShort")
external mockLongShortToReturn: (t, Ethers.ethAddress) => unit = "returns"

type longShortCall

let longShortOld: t => array<longShortCall> = _r => {
  let array = %raw("_r.longShort.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external longShortCalledWith: expectation => unit = "calledWith"

@get external longShortFunction: t => string = "longShort"

let longShortCallCheck = contract => {
  expect(contract->longShortFunction)->longShortCalledWith
}

@send @scope("longShort")
external mockLongShortToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("longShort")
external mockLongShortToRevertNoReason: t => unit = "reverts"

type removePaymentTokenFromMarketCall = {amount: Ethers.BigNumber.t}

let removePaymentTokenFromMarketOld: t => array<removePaymentTokenFromMarketCall> = _r => {
  let array = %raw("_r.removePaymentTokenFromMarket.calls")
  array->Array.map(_m => {
    let amount = _m->Array.getUnsafe(0)

    {
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external removePaymentTokenFromMarketCalledWith: (expectation, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external removePaymentTokenFromMarketFunction: t => string = "removePaymentTokenFromMarket"

let removePaymentTokenFromMarketCallCheck = (
  contract,
  {amount}: removePaymentTokenFromMarketCall,
) => {
  expect(contract->removePaymentTokenFromMarketFunction)->removePaymentTokenFromMarketCalledWith(
    amount,
  )
}

@send @scope("removePaymentTokenFromMarket")
external mockRemovePaymentTokenFromMarketToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("removePaymentTokenFromMarket")
external mockRemovePaymentTokenFromMarketToRevertNoReason: t => unit = "reverts"

type setYieldRateCall = {yieldRate: Ethers.BigNumber.t}

let setYieldRateOld: t => array<setYieldRateCall> = _r => {
  let array = %raw("_r.setYieldRate.calls")
  array->Array.map(_m => {
    let yieldRate = _m->Array.getUnsafe(0)

    {
      yieldRate: yieldRate,
    }
  })
}

@send @scope(("to", "have", "been"))
external setYieldRateCalledWith: (expectation, Ethers.BigNumber.t) => unit = "calledWith"

@get external setYieldRateFunction: t => string = "setYieldRate"

let setYieldRateCallCheck = (contract, {yieldRate}: setYieldRateCall) => {
  expect(contract->setYieldRateFunction)->setYieldRateCalledWith(yieldRate)
}

@send @scope("setYieldRate")
external mockSetYieldRateToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("setYieldRate")
external mockSetYieldRateToRevertNoReason: t => unit = "reverts"

type settleCall

let settleOld: t => array<settleCall> = _r => {
  let array = %raw("_r.settle.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external settleCalledWith: expectation => unit = "calledWith"

@get external settleFunction: t => string = "settle"

let settleCallCheck = contract => {
  expect(contract->settleFunction)->settleCalledWith
}

@send @scope("settle")
external mockSettleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("settle")
external mockSettleToRevertNoReason: t => unit = "reverts"

type settleWithYieldAbsoluteCall = {totalYield: Ethers.BigNumber.t}

let settleWithYieldAbsoluteOld: t => array<settleWithYieldAbsoluteCall> = _r => {
  let array = %raw("_r.settleWithYieldAbsolute.calls")
  array->Array.map(_m => {
    let totalYield = _m->Array.getUnsafe(0)

    {
      totalYield: totalYield,
    }
  })
}

@send @scope(("to", "have", "been"))
external settleWithYieldAbsoluteCalledWith: (expectation, Ethers.BigNumber.t) => unit = "calledWith"

@get external settleWithYieldAbsoluteFunction: t => string = "settleWithYieldAbsolute"

let settleWithYieldAbsoluteCallCheck = (contract, {totalYield}: settleWithYieldAbsoluteCall) => {
  expect(contract->settleWithYieldAbsoluteFunction)->settleWithYieldAbsoluteCalledWith(totalYield)
}

@send @scope("settleWithYieldAbsolute")
external mockSettleWithYieldAbsoluteToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("settleWithYieldAbsolute")
external mockSettleWithYieldAbsoluteToRevertNoReason: t => unit = "reverts"

type settleWithYieldPercentCall = {yieldPercent: Ethers.BigNumber.t}

let settleWithYieldPercentOld: t => array<settleWithYieldPercentCall> = _r => {
  let array = %raw("_r.settleWithYieldPercent.calls")
  array->Array.map(_m => {
    let yieldPercent = _m->Array.getUnsafe(0)

    {
      yieldPercent: yieldPercent,
    }
  })
}

@send @scope(("to", "have", "been"))
external settleWithYieldPercentCalledWith: (expectation, Ethers.BigNumber.t) => unit = "calledWith"

@get external settleWithYieldPercentFunction: t => string = "settleWithYieldPercent"

let settleWithYieldPercentCallCheck = (contract, {yieldPercent}: settleWithYieldPercentCall) => {
  expect(contract->settleWithYieldPercentFunction)->settleWithYieldPercentCalledWith(yieldPercent)
}

@send @scope("settleWithYieldPercent")
external mockSettleWithYieldPercentToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("settleWithYieldPercent")
external mockSettleWithYieldPercentToRevertNoReason: t => unit = "reverts"

@send @scope("token")
external mockTokenToReturn: (t, Ethers.ethAddress) => unit = "returns"

type tokenCall

let tokenOld: t => array<tokenCall> = _r => {
  let array = %raw("_r.token.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external tokenCalledWith: expectation => unit = "calledWith"

@get external tokenFunction: t => string = "token"

let tokenCallCheck = contract => {
  expect(contract->tokenFunction)->tokenCalledWith
}

@send @scope("token")
external mockTokenToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("token")
external mockTokenToRevertNoReason: t => unit = "reverts"

@send @scope("tokenOtherRewardERC20")
external mockTokenOtherRewardERC20ToReturn: (t, Ethers.ethAddress) => unit = "returns"

type tokenOtherRewardERC20Call

let tokenOtherRewardERC20Old: t => array<tokenOtherRewardERC20Call> = _r => {
  let array = %raw("_r.tokenOtherRewardERC20.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external tokenOtherRewardERC20CalledWith: expectation => unit = "calledWith"

@get external tokenOtherRewardERC20Function: t => string = "tokenOtherRewardERC20"

let tokenOtherRewardERC20CallCheck = contract => {
  expect(contract->tokenOtherRewardERC20Function)->tokenOtherRewardERC20CalledWith
}

@send @scope("tokenOtherRewardERC20")
external mockTokenOtherRewardERC20ToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("tokenOtherRewardERC20")
external mockTokenOtherRewardERC20ToRevertNoReason: t => unit = "reverts"

@send @scope("totalHeld")
external mockTotalHeldToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type totalHeldCall

let totalHeldOld: t => array<totalHeldCall> = _r => {
  let array = %raw("_r.totalHeld.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external totalHeldCalledWith: expectation => unit = "calledWith"

@get external totalHeldFunction: t => string = "totalHeld"

let totalHeldCallCheck = contract => {
  expect(contract->totalHeldFunction)->totalHeldCalledWith
}

@send @scope("totalHeld")
external mockTotalHeldToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("totalHeld")
external mockTotalHeldToRevertNoReason: t => unit = "reverts"

@send @scope("totalReservedForTreasury")
external mockTotalReservedForTreasuryToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type totalReservedForTreasuryCall

let totalReservedForTreasuryOld: t => array<totalReservedForTreasuryCall> = _r => {
  let array = %raw("_r.totalReservedForTreasury.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external totalReservedForTreasuryCalledWith: expectation => unit = "calledWith"

@get external totalReservedForTreasuryFunction: t => string = "totalReservedForTreasury"

let totalReservedForTreasuryCallCheck = contract => {
  expect(contract->totalReservedForTreasuryFunction)->totalReservedForTreasuryCalledWith
}

@send @scope("totalReservedForTreasury")
external mockTotalReservedForTreasuryToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("totalReservedForTreasury")
external mockTotalReservedForTreasuryToRevertNoReason: t => unit = "reverts"

type transferPaymentTokensToUserCall = {
  user: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
}

let transferPaymentTokensToUserOld: t => array<transferPaymentTokensToUserCall> = _r => {
  let array = %raw("_r.transferPaymentTokensToUser.calls")
  array->Array.map(((user, amount)) => {
    {
      user: user,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external transferPaymentTokensToUserCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get external transferPaymentTokensToUserFunction: t => string = "transferPaymentTokensToUser"

let transferPaymentTokensToUserCallCheck = (
  contract,
  {user, amount}: transferPaymentTokensToUserCall,
) => {
  expect(contract->transferPaymentTokensToUserFunction)->transferPaymentTokensToUserCalledWith(
    user,
    amount,
  )
}

@send @scope("transferPaymentTokensToUser")
external mockTransferPaymentTokensToUserToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("transferPaymentTokensToUser")
external mockTransferPaymentTokensToUserToRevertNoReason: t => unit = "reverts"

@send @scope("treasury")
external mockTreasuryToReturn: (t, Ethers.ethAddress) => unit = "returns"

type treasuryCall

let treasuryOld: t => array<treasuryCall> = _r => {
  let array = %raw("_r.treasury.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external treasuryCalledWith: expectation => unit = "calledWith"

@get external treasuryFunction: t => string = "treasury"

let treasuryCallCheck = contract => {
  expect(contract->treasuryFunction)->treasuryCalledWith
}

@send @scope("treasury")
external mockTreasuryToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("treasury")
external mockTreasuryToRevertNoReason: t => unit = "reverts"

type withdrawTreasuryFundsCall

let withdrawTreasuryFundsOld: t => array<withdrawTreasuryFundsCall> = _r => {
  let array = %raw("_r.withdrawTreasuryFunds.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external withdrawTreasuryFundsCalledWith: expectation => unit = "calledWith"

@get external withdrawTreasuryFundsFunction: t => string = "withdrawTreasuryFunds"

let withdrawTreasuryFundsCallCheck = contract => {
  expect(contract->withdrawTreasuryFundsFunction)->withdrawTreasuryFundsCalledWith
}

@send @scope("withdrawTreasuryFunds")
external mockWithdrawTreasuryFundsToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("withdrawTreasuryFunds")
external mockWithdrawTreasuryFundsToRevertNoReason: t => unit = "reverts"

@send @scope("yieldRate")
external mockYieldRateToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type yieldRateCall

let yieldRateOld: t => array<yieldRateCall> = _r => {
  let array = %raw("_r.yieldRate.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external yieldRateCalledWith: expectation => unit = "calledWith"

@get external yieldRateFunction: t => string = "yieldRate"

let yieldRateCallCheck = contract => {
  expect(contract->yieldRateFunction)->yieldRateCalledWith
}

@send @scope("yieldRate")
external mockYieldRateToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("yieldRate")
external mockYieldRateToRevertNoReason: t => unit = "reverts"
