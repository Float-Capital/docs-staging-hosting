type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: TokenFactory.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

let mockDEFAULT_ADMIN_ROLEToReturn: (t, string) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.DEFAULT_ADMIN_ROLE.will.return.with([_param0])")
}

type dEFAULT_ADMIN_ROLECall

let dEFAULT_ADMIN_ROLECalls: t => array<dEFAULT_ADMIN_ROLECall> = _r => {
  let array = %raw("_r.smocked.DEFAULT_ADMIN_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockMINTER_ROLEToReturn: (t, string) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.MINTER_ROLE.will.return.with([_param0])")
}

type mINTER_ROLECall

let mINTER_ROLECalls: t => array<mINTER_ROLECall> = _r => {
  let array = %raw("_r.smocked.MINTER_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockPAUSER_ROLEToReturn: (t, string) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.PAUSER_ROLE.will.return.with([_param0])")
}

type pAUSER_ROLECall

let pAUSER_ROLECalls: t => array<pAUSER_ROLECall> = _r => {
  let array = %raw("_r.smocked.PAUSER_ROLE.calls")
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

let mockChangeFloatAddressToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.changeFloatAddress.will.return()")
}

type changeFloatAddressCall = {longShort: Ethers.ethAddress}

let changeFloatAddressCalls: t => array<changeFloatAddressCall> = _r => {
  let array = %raw("_r.smocked.changeFloatAddress.calls")
  array->Array.map(_m => {
    let longShort = _m->Array.getUnsafe(0)

    {
      longShort: longShort,
    }
  })
}

let mockCreateTokenLongToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.createTokenLong.will.return.with([_param0])")
}

type createTokenLongCall = {
  syntheticName: string,
  syntheticSymbol: string,
  staker: Ethers.ethAddress,
  marketIndex: int,
}

let createTokenLongCalls: t => array<createTokenLongCall> = _r => {
  let array = %raw("_r.smocked.createTokenLong.calls")
  array->Array.map(((syntheticName, syntheticSymbol, staker, marketIndex)) => {
    {
      syntheticName: syntheticName,
      syntheticSymbol: syntheticSymbol,
      staker: staker,
      marketIndex: marketIndex,
    }
  })
}

let mockCreateTokenShortToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.createTokenShort.will.return.with([_param0])")
}

type createTokenShortCall = {
  syntheticName: string,
  syntheticSymbol: string,
  staker: Ethers.ethAddress,
  marketIndex: int,
}

let createTokenShortCalls: t => array<createTokenShortCall> = _r => {
  let array = %raw("_r.smocked.createTokenShort.calls")
  array->Array.map(((syntheticName, syntheticSymbol, staker, marketIndex)) => {
    {
      syntheticName: syntheticName,
      syntheticSymbol: syntheticSymbol,
      staker: staker,
      marketIndex: marketIndex,
    }
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
