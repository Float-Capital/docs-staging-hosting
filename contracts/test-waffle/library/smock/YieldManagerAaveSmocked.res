type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: YieldManagerAave.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

let mockTEN_TO_THE_18ToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.TEN_TO_THE_18.will.return.with([_param0])")
}

type tEN_TO_THE_18Call

let tEN_TO_THE_18Calls: t => array<tEN_TO_THE_18Call> = _r => {
  let array = %raw("_r.smocked.TEN_TO_THE_18.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockATokenToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.aToken.will.return.with([_param0])")
}

type aTokenCall

let aTokenCalls: t => array<aTokenCall> = _r => {
  let array = %raw("_r.smocked.aToken.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

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

let mockLendingPoolToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.lendingPool.will.return.with([_param0])")
}

type lendingPoolCall

let lendingPoolCalls: t => array<lendingPoolCall> = _r => {
  let array = %raw("_r.smocked.lendingPool.calls")
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

let mockPaymentTokenToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.paymentToken.will.return.with([_param0])")
}

type paymentTokenCall

let paymentTokenCalls: t => array<paymentTokenCall> = _r => {
  let array = %raw("_r.smocked.paymentToken.calls")
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

let mockChangeAdminToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.changeAdmin.will.return()")
}

type changeAdminCall = {admin: Ethers.ethAddress}

let changeAdminCalls: t => array<changeAdminCall> = _r => {
  let array = %raw("_r.smocked.changeAdmin.calls")
  array->Array.map(_m => {
    let admin = _m->Array.getUnsafe(0)

    {
      admin: admin,
    }
  })
}

let mockDepositPaymentTokenToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.depositPaymentToken.will.return()")
}

type depositPaymentTokenCall = {amount: Ethers.BigNumber.t}

let depositPaymentTokenCalls: t => array<depositPaymentTokenCall> = _r => {
  let array = %raw("_r.smocked.depositPaymentToken.calls")
  array->Array.map(_m => {
    let amount = _m->Array.getUnsafe(0)

    {
      amount: amount,
    }
  })
}

let mockWithdrawPaymentTokenToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.withdrawPaymentToken.will.return()")
}

type withdrawPaymentTokenCall = {amount: Ethers.BigNumber.t}

let withdrawPaymentTokenCalls: t => array<withdrawPaymentTokenCall> = _r => {
  let array = %raw("_r.smocked.withdrawPaymentToken.calls")
  array->Array.map(_m => {
    let amount = _m->Array.getUnsafe(0)

    {
      amount: amount,
    }
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

let mockClaimYieldAndGetMarketAmountToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.claimYieldAndGetMarketAmount.will.return.with([_param0])")
}

type claimYieldAndGetMarketAmountCall = {
  totalValueRealizedForMarket: Ethers.BigNumber.t,
  marketPercentE18: Ethers.BigNumber.t,
}

let claimYieldAndGetMarketAmountCalls: t => array<claimYieldAndGetMarketAmountCall> = _r => {
  let array = %raw("_r.smocked.claimYieldAndGetMarketAmount.calls")
  array->Array.map(((totalValueRealizedForMarket, marketPercentE18)) => {
    {
      totalValueRealizedForMarket: totalValueRealizedForMarket,
      marketPercentE18: marketPercentE18,
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
