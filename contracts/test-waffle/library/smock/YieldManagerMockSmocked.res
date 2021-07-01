type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: YieldManagerMock.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

let mockAdminToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.admin.will.return.with([_param0])")
}

type adminCall

let adminCalls: t => array<adminCall> = _r => {
  let array = %raw("_r.smocked.admin.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockClaimYieldAndGetMarketAmountToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.claimYieldAndGetMarketAmount.will.return.with([_param0])")
}

type claimYieldAndGetMarketAmountCall = {
  totalValueRealizedForMarket: Ethers.BigNumber.t,
  marketPcntE5: Ethers.BigNumber.t,
}

let claimYieldAndGetMarketAmountCalls: t => array<claimYieldAndGetMarketAmountCall> = _r => {
  let array = %raw("_r.smocked.claimYieldAndGetMarketAmount.calls")
  array->Array.map(((totalValueRealizedForMarket, marketPcntE5)) => {
    {
      totalValueRealizedForMarket: totalValueRealizedForMarket,
      marketPcntE5: marketPcntE5,
    }
  })
}

let mockDepositTokenToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.depositToken.will.return()")
}

type depositTokenCall = {amount: Ethers.BigNumber.t}

let depositTokenCalls: t => array<depositTokenCall> = _r => {
  let array = %raw("_r.smocked.depositToken.calls")
  array->Array.map(_m => {
    let amount = _m->Array.getUnsafe(0)

    {
      amount: amount,
    }
  })
}

let mockLastSettledToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.lastSettled.will.return.with([_param0])")
}

type lastSettledCall

let lastSettledCalls: t => array<lastSettledCall> = _r => {
  let array = %raw("_r.smocked.lastSettled.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockLongShortToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.longShort.will.return.with([_param0])")
}

type longShortCall

let longShortCalls: t => array<longShortCall> = _r => {
  let array = %raw("_r.smocked.longShort.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockMockHoldingAdditionalRewardYieldToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.mockHoldingAdditionalRewardYield.will.return()")
}

type mockHoldingAdditionalRewardYieldCall

let mockHoldingAdditionalRewardYieldCalls: t => array<
  mockHoldingAdditionalRewardYieldCall,
> = _r => {
  let array = %raw("_r.smocked.mockHoldingAdditionalRewardYield.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockSetYieldRateToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.setYieldRate.will.return()")
}

type setYieldRateCall = {yieldRate: Ethers.BigNumber.t}

let setYieldRateCalls: t => array<setYieldRateCall> = _r => {
  let array = %raw("_r.smocked.setYieldRate.calls")
  array->Array.map(_m => {
    let yieldRate = _m->Array.getUnsafe(0)

    {
      yieldRate: yieldRate,
    }
  })
}

let mockSettleToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.settle.will.return()")
}

type settleCall

let settleCalls: t => array<settleCall> = _r => {
  let array = %raw("_r.smocked.settle.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockSettleWithYieldToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.settleWithYield.will.return()")
}

type settleWithYieldCall = {yield: Ethers.BigNumber.t}

let settleWithYieldCalls: t => array<settleWithYieldCall> = _r => {
  let array = %raw("_r.smocked.settleWithYield.calls")
  array->Array.map(_m => {
    let yield = _m->Array.getUnsafe(0)

    {
      yield: yield,
    }
  })
}

let mockTokenToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.token.will.return.with([_param0])")
}

type tokenCall

let tokenCalls: t => array<tokenCall> = _r => {
  let array = %raw("_r.smocked.token.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockTokenOtherRewardERC20ToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.tokenOtherRewardERC20.will.return.with([_param0])")
}

type tokenOtherRewardERC20Call

let tokenOtherRewardERC20Calls: t => array<tokenOtherRewardERC20Call> = _r => {
  let array = %raw("_r.smocked.tokenOtherRewardERC20.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockTotalHeldToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.totalHeld.will.return.with([_param0])")
}

type totalHeldCall

let totalHeldCalls: t => array<totalHeldCall> = _r => {
  let array = %raw("_r.smocked.totalHeld.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockTotalReservedForTreasuryToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.totalReservedForTreasury.will.return.with([_param0])")
}

type totalReservedForTreasuryCall

let totalReservedForTreasuryCalls: t => array<totalReservedForTreasuryCall> = _r => {
  let array = %raw("_r.smocked.totalReservedForTreasury.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockTreasuryToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.treasury.will.return.with([_param0])")
}

type treasuryCall

let treasuryCalls: t => array<treasuryCall> = _r => {
  let array = %raw("_r.smocked.treasury.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockWithdrawErc20TokenToTreasuryToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.withdrawErc20TokenToTreasury.will.return()")
}

type withdrawErc20TokenToTreasuryCall = {erc20Token: Ethers.ethAddress}

let withdrawErc20TokenToTreasuryCalls: t => array<withdrawErc20TokenToTreasuryCall> = _r => {
  let array = %raw("_r.smocked.withdrawErc20TokenToTreasury.calls")
  array->Array.map(_m => {
    let erc20Token = _m->Array.getUnsafe(0)

    {
      erc20Token: erc20Token,
    }
  })
}

let mockWithdrawTokenToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.withdrawToken.will.return()")
}

type withdrawTokenCall = {amount: Ethers.BigNumber.t}

let withdrawTokenCalls: t => array<withdrawTokenCall> = _r => {
  let array = %raw("_r.smocked.withdrawToken.calls")
  array->Array.map(_m => {
    let amount = _m->Array.getUnsafe(0)

    {
      amount: amount,
    }
  })
}

let mockWithdrawTreasuryFundsToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.withdrawTreasuryFunds.will.return()")
}

type withdrawTreasuryFundsCall

let withdrawTreasuryFundsCalls: t => array<withdrawTreasuryFundsCall> = _r => {
  let array = %raw("_r.smocked.withdrawTreasuryFunds.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockYieldRateToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.yieldRate.will.return.with([_param0])")
}

type yieldRateCall

let yieldRateCalls: t => array<yieldRateCall> = _r => {
  let array = %raw("_r.smocked.yieldRate.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockYieldScaleToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.yieldScale.will.return.with([_param0])")
}

type yieldScaleCall

let yieldScaleCalls: t => array<yieldScaleCall> = _r => {
  let array = %raw("_r.smocked.yieldScale.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}
