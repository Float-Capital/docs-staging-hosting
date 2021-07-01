type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: YieldManagerAave.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

let mockTEN_TO_THE_5ToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.TEN_TO_THE_5.will.return.with([_param0])")
}

type tEN_TO_THE_5Call

let tEN_TO_THE_5Calls: t => array<tEN_TO_THE_5Call> = _r => {
  let array = %raw("_r.smocked.TEN_TO_THE_5.calls")
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

let mockClaimYieldAndGetMarketAmountToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.claimYieldAndGetMarketAmount.will.return.with([_param0])")
}

type claimYieldAndGetMarketAmountCall = {marketPcntE5: Ethers.BigNumber.t}

let claimYieldAndGetMarketAmountCalls: t => array<claimYieldAndGetMarketAmountCall> = _r => {
  let array = %raw("_r.smocked.claimYieldAndGetMarketAmount.calls")
  array->Array.map(_m => {
    let marketPcntE5 = _m->Array.getUnsafe(0)

    {
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

let mockTotalValueRealizedToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.totalValueRealized.will.return.with([_param0])")
}

type totalValueRealizedCall

let totalValueRealizedCalls: t => array<totalValueRealizedCall> = _r => {
  let array = %raw("_r.smocked.totalValueRealized.calls")
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
