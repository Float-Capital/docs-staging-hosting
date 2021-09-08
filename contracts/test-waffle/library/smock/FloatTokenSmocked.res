open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("FloatToken")

let uninitializedValue: t = None->Obj.magic

@send @scope("DEFAULT_ADMIN_ROLE")
external mockDEFAULT_ADMIN_ROLEToReturn: (t, string) => unit = "returns"

type dEFAULT_ADMIN_ROLECall

let dEFAULT_ADMIN_ROLEOld: t => array<dEFAULT_ADMIN_ROLECall> = _r => {
  let array = %raw("_r.DEFAULT_ADMIN_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external dEFAULT_ADMIN_ROLECalledWith: expectation => unit = "calledWith"

@get external dEFAULT_ADMIN_ROLEFunction: t => string = "dEFAULT_ADMIN_ROLE"

let dEFAULT_ADMIN_ROLECallCheck = contract => {
  expect(contract->dEFAULT_ADMIN_ROLEFunction)->dEFAULT_ADMIN_ROLECalledWith
}

@send @scope("DEFAULT_ADMIN_ROLE")
external mockDEFAULT_ADMIN_ROLEToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("DEFAULT_ADMIN_ROLE")
external mockDEFAULT_ADMIN_ROLEToRevertNoReason: t => unit = "reverts"

@send @scope("DOMAIN_SEPARATOR")
external mockDOMAIN_SEPARATORToReturn: (t, string) => unit = "returns"

type dOMAIN_SEPARATORCall

let dOMAIN_SEPARATOROld: t => array<dOMAIN_SEPARATORCall> = _r => {
  let array = %raw("_r.DOMAIN_SEPARATOR.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external dOMAIN_SEPARATORCalledWith: expectation => unit = "calledWith"

@get external dOMAIN_SEPARATORFunction: t => string = "dOMAIN_SEPARATOR"

let dOMAIN_SEPARATORCallCheck = contract => {
  expect(contract->dOMAIN_SEPARATORFunction)->dOMAIN_SEPARATORCalledWith
}

@send @scope("DOMAIN_SEPARATOR")
external mockDOMAIN_SEPARATORToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("DOMAIN_SEPARATOR")
external mockDOMAIN_SEPARATORToRevertNoReason: t => unit = "reverts"

@send @scope("MINTER_ROLE")
external mockMINTER_ROLEToReturn: (t, string) => unit = "returns"

type mINTER_ROLECall

let mINTER_ROLEOld: t => array<mINTER_ROLECall> = _r => {
  let array = %raw("_r.MINTER_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external mINTER_ROLECalledWith: expectation => unit = "calledWith"

@get external mINTER_ROLEFunction: t => string = "mINTER_ROLE"

let mINTER_ROLECallCheck = contract => {
  expect(contract->mINTER_ROLEFunction)->mINTER_ROLECalledWith
}

@send @scope("MINTER_ROLE")
external mockMINTER_ROLEToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("MINTER_ROLE")
external mockMINTER_ROLEToRevertNoReason: t => unit = "reverts"

@send @scope("PAUSER_ROLE")
external mockPAUSER_ROLEToReturn: (t, string) => unit = "returns"

type pAUSER_ROLECall

let pAUSER_ROLEOld: t => array<pAUSER_ROLECall> = _r => {
  let array = %raw("_r.PAUSER_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external pAUSER_ROLECalledWith: expectation => unit = "calledWith"

@get external pAUSER_ROLEFunction: t => string = "pAUSER_ROLE"

let pAUSER_ROLECallCheck = contract => {
  expect(contract->pAUSER_ROLEFunction)->pAUSER_ROLECalledWith
}

@send @scope("PAUSER_ROLE")
external mockPAUSER_ROLEToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("PAUSER_ROLE")
external mockPAUSER_ROLEToRevertNoReason: t => unit = "reverts"

@send @scope("UPGRADER_ROLE")
external mockUPGRADER_ROLEToReturn: (t, string) => unit = "returns"

type uPGRADER_ROLECall

let uPGRADER_ROLEOld: t => array<uPGRADER_ROLECall> = _r => {
  let array = %raw("_r.UPGRADER_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external uPGRADER_ROLECalledWith: expectation => unit = "calledWith"

@get external uPGRADER_ROLEFunction: t => string = "uPGRADER_ROLE"

let uPGRADER_ROLECallCheck = contract => {
  expect(contract->uPGRADER_ROLEFunction)->uPGRADER_ROLECalledWith
}

@send @scope("UPGRADER_ROLE")
external mockUPGRADER_ROLEToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("UPGRADER_ROLE")
external mockUPGRADER_ROLEToRevertNoReason: t => unit = "reverts"

@send @scope("allowance")
external mockAllowanceToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type allowanceCall = {
  owner: Ethers.ethAddress,
  spender: Ethers.ethAddress,
}

let allowanceOld: t => array<allowanceCall> = _r => {
  let array = %raw("_r.allowance.calls")
  array->Array.map(((owner, spender)) => {
    {
      owner: owner,
      spender: spender,
    }
  })
}

@send @scope(("to", "have", "been"))
external allowanceCalledWith: (expectation, Ethers.ethAddress, Ethers.ethAddress) => unit =
  "calledWith"

@get external allowanceFunction: t => string = "allowance"

let allowanceCallCheck = (contract, {owner, spender}: allowanceCall) => {
  expect(contract->allowanceFunction)->allowanceCalledWith(owner, spender)
}

@send @scope("allowance")
external mockAllowanceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("allowance")
external mockAllowanceToRevertNoReason: t => unit = "reverts"

@send @scope("approve")
external mockApproveToReturn: (t, bool) => unit = "returns"

type approveCall = {
  spender: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
}

let approveOld: t => array<approveCall> = _r => {
  let array = %raw("_r.approve.calls")
  array->Array.map(((spender, amount)) => {
    {
      spender: spender,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external approveCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external approveFunction: t => string = "approve"

let approveCallCheck = (contract, {spender, amount}: approveCall) => {
  expect(contract->approveFunction)->approveCalledWith(spender, amount)
}

@send @scope("approve")
external mockApproveToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("approve")
external mockApproveToRevertNoReason: t => unit = "reverts"

@send @scope("balanceOf")
external mockBalanceOfToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type balanceOfCall = {account: Ethers.ethAddress}

let balanceOfOld: t => array<balanceOfCall> = _r => {
  let array = %raw("_r.balanceOf.calls")
  array->Array.map(_m => {
    let account = _m->Array.getUnsafe(0)

    {
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external balanceOfCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external balanceOfFunction: t => string = "balanceOf"

let balanceOfCallCheck = (contract, {account}: balanceOfCall) => {
  expect(contract->balanceOfFunction)->balanceOfCalledWith(account)
}

@send @scope("balanceOf")
external mockBalanceOfToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("balanceOf")
external mockBalanceOfToRevertNoReason: t => unit = "reverts"

type burnCall = {amount: Ethers.BigNumber.t}

let burnOld: t => array<burnCall> = _r => {
  let array = %raw("_r.burn.calls")
  array->Array.map(_m => {
    let amount = _m->Array.getUnsafe(0)

    {
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external burnCalledWith: (expectation, Ethers.BigNumber.t) => unit = "calledWith"

@get external burnFunction: t => string = "burn"

let burnCallCheck = (contract, {amount}: burnCall) => {
  expect(contract->burnFunction)->burnCalledWith(amount)
}

@send @scope("burn")
external mockBurnToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("burn")
external mockBurnToRevertNoReason: t => unit = "reverts"

type burnFromCall = {
  account: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
}

let burnFromOld: t => array<burnFromCall> = _r => {
  let array = %raw("_r.burnFrom.calls")
  array->Array.map(((account, amount)) => {
    {
      account: account,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external burnFromCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external burnFromFunction: t => string = "burnFrom"

let burnFromCallCheck = (contract, {account, amount}: burnFromCall) => {
  expect(contract->burnFromFunction)->burnFromCalledWith(account, amount)
}

@send @scope("burnFrom")
external mockBurnFromToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("burnFrom")
external mockBurnFromToRevertNoReason: t => unit = "reverts"

@send @scope("checkpoints")
external mockCheckpointsToReturn: (t, 'struct) => unit = "returns"

type checkpointsCall = {
  account: Ethers.ethAddress,
  pos: int,
}

let checkpointsOld: t => array<checkpointsCall> = _r => {
  let array = %raw("_r.checkpoints.calls")
  array->Array.map(((account, pos)) => {
    {
      account: account,
      pos: pos,
    }
  })
}

@send @scope(("to", "have", "been"))
external checkpointsCalledWith: (expectation, Ethers.ethAddress, int) => unit = "calledWith"

@get external checkpointsFunction: t => string = "checkpoints"

let checkpointsCallCheck = (contract, {account, pos}: checkpointsCall) => {
  expect(contract->checkpointsFunction)->checkpointsCalledWith(account, pos)
}

@send @scope("checkpoints")
external mockCheckpointsToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("checkpoints")
external mockCheckpointsToRevertNoReason: t => unit = "reverts"

@send @scope("decimals")
external mockDecimalsToReturn: (t, int) => unit = "returns"

type decimalsCall

let decimalsOld: t => array<decimalsCall> = _r => {
  let array = %raw("_r.decimals.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external decimalsCalledWith: expectation => unit = "calledWith"

@get external decimalsFunction: t => string = "decimals"

let decimalsCallCheck = contract => {
  expect(contract->decimalsFunction)->decimalsCalledWith
}

@send @scope("decimals")
external mockDecimalsToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("decimals")
external mockDecimalsToRevertNoReason: t => unit = "reverts"

@send @scope("decreaseAllowance")
external mockDecreaseAllowanceToReturn: (t, bool) => unit = "returns"

type decreaseAllowanceCall = {
  spender: Ethers.ethAddress,
  subtractedValue: Ethers.BigNumber.t,
}

let decreaseAllowanceOld: t => array<decreaseAllowanceCall> = _r => {
  let array = %raw("_r.decreaseAllowance.calls")
  array->Array.map(((spender, subtractedValue)) => {
    {
      spender: spender,
      subtractedValue: subtractedValue,
    }
  })
}

@send @scope(("to", "have", "been"))
external decreaseAllowanceCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external decreaseAllowanceFunction: t => string = "decreaseAllowance"

let decreaseAllowanceCallCheck = (contract, {spender, subtractedValue}: decreaseAllowanceCall) => {
  expect(contract->decreaseAllowanceFunction)->decreaseAllowanceCalledWith(spender, subtractedValue)
}

@send @scope("decreaseAllowance")
external mockDecreaseAllowanceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("decreaseAllowance")
external mockDecreaseAllowanceToRevertNoReason: t => unit = "reverts"

type delegateCall = {delegatee: Ethers.ethAddress}

let delegateOld: t => array<delegateCall> = _r => {
  let array = %raw("_r.delegate.calls")
  array->Array.map(_m => {
    let delegatee = _m->Array.getUnsafe(0)

    {
      delegatee: delegatee,
    }
  })
}

@send @scope(("to", "have", "been"))
external delegateCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external delegateFunction: t => string = "delegate"

let delegateCallCheck = (contract, {delegatee}: delegateCall) => {
  expect(contract->delegateFunction)->delegateCalledWith(delegatee)
}

@send @scope("delegate")
external mockDelegateToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("delegate")
external mockDelegateToRevertNoReason: t => unit = "reverts"

type delegateBySigCall = {
  delegatee: Ethers.ethAddress,
  nonce: Ethers.BigNumber.t,
  expiry: Ethers.BigNumber.t,
  v: int,
  r: string,
  s: string,
}

let delegateBySigOld: t => array<delegateBySigCall> = _r => {
  let array = %raw("_r.delegateBySig.calls")
  array->Array.map(((delegatee, nonce, expiry, v, r, s)) => {
    {
      delegatee: delegatee,
      nonce: nonce,
      expiry: expiry,
      v: v,
      r: r,
      s: s,
    }
  })
}

@send @scope(("to", "have", "been"))
external delegateBySigCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  int,
  string,
  string,
) => unit = "calledWith"

@get external delegateBySigFunction: t => string = "delegateBySig"

let delegateBySigCallCheck = (contract, {delegatee, nonce, expiry, v, r, s}: delegateBySigCall) => {
  expect(contract->delegateBySigFunction)->delegateBySigCalledWith(
    delegatee,
    nonce,
    expiry,
    v,
    r,
    s,
  )
}

@send @scope("delegateBySig")
external mockDelegateBySigToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("delegateBySig")
external mockDelegateBySigToRevertNoReason: t => unit = "reverts"

@send @scope("delegates")
external mockDelegatesToReturn: (t, Ethers.ethAddress) => unit = "returns"

type delegatesCall = {account: Ethers.ethAddress}

let delegatesOld: t => array<delegatesCall> = _r => {
  let array = %raw("_r.delegates.calls")
  array->Array.map(_m => {
    let account = _m->Array.getUnsafe(0)

    {
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external delegatesCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external delegatesFunction: t => string = "delegates"

let delegatesCallCheck = (contract, {account}: delegatesCall) => {
  expect(contract->delegatesFunction)->delegatesCalledWith(account)
}

@send @scope("delegates")
external mockDelegatesToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("delegates")
external mockDelegatesToRevertNoReason: t => unit = "reverts"

@send @scope("getPastTotalSupply")
external mockGetPastTotalSupplyToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type getPastTotalSupplyCall = {blockNumber: Ethers.BigNumber.t}

let getPastTotalSupplyOld: t => array<getPastTotalSupplyCall> = _r => {
  let array = %raw("_r.getPastTotalSupply.calls")
  array->Array.map(_m => {
    let blockNumber = _m->Array.getUnsafe(0)

    {
      blockNumber: blockNumber,
    }
  })
}

@send @scope(("to", "have", "been"))
external getPastTotalSupplyCalledWith: (expectation, Ethers.BigNumber.t) => unit = "calledWith"

@get external getPastTotalSupplyFunction: t => string = "getPastTotalSupply"

let getPastTotalSupplyCallCheck = (contract, {blockNumber}: getPastTotalSupplyCall) => {
  expect(contract->getPastTotalSupplyFunction)->getPastTotalSupplyCalledWith(blockNumber)
}

@send @scope("getPastTotalSupply")
external mockGetPastTotalSupplyToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("getPastTotalSupply")
external mockGetPastTotalSupplyToRevertNoReason: t => unit = "reverts"

@send @scope("getPastVotes")
external mockGetPastVotesToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type getPastVotesCall = {
  account: Ethers.ethAddress,
  blockNumber: Ethers.BigNumber.t,
}

let getPastVotesOld: t => array<getPastVotesCall> = _r => {
  let array = %raw("_r.getPastVotes.calls")
  array->Array.map(((account, blockNumber)) => {
    {
      account: account,
      blockNumber: blockNumber,
    }
  })
}

@send @scope(("to", "have", "been"))
external getPastVotesCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external getPastVotesFunction: t => string = "getPastVotes"

let getPastVotesCallCheck = (contract, {account, blockNumber}: getPastVotesCall) => {
  expect(contract->getPastVotesFunction)->getPastVotesCalledWith(account, blockNumber)
}

@send @scope("getPastVotes")
external mockGetPastVotesToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("getPastVotes")
external mockGetPastVotesToRevertNoReason: t => unit = "reverts"

@send @scope("getRoleAdmin")
external mockGetRoleAdminToReturn: (t, string) => unit = "returns"

type getRoleAdminCall = {role: string}

let getRoleAdminOld: t => array<getRoleAdminCall> = _r => {
  let array = %raw("_r.getRoleAdmin.calls")
  array->Array.map(_m => {
    let role = _m->Array.getUnsafe(0)

    {
      role: role,
    }
  })
}

@send @scope(("to", "have", "been"))
external getRoleAdminCalledWith: (expectation, string) => unit = "calledWith"

@get external getRoleAdminFunction: t => string = "getRoleAdmin"

let getRoleAdminCallCheck = (contract, {role}: getRoleAdminCall) => {
  expect(contract->getRoleAdminFunction)->getRoleAdminCalledWith(role)
}

@send @scope("getRoleAdmin")
external mockGetRoleAdminToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("getRoleAdmin")
external mockGetRoleAdminToRevertNoReason: t => unit = "reverts"

@send @scope("getVotes")
external mockGetVotesToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type getVotesCall = {account: Ethers.ethAddress}

let getVotesOld: t => array<getVotesCall> = _r => {
  let array = %raw("_r.getVotes.calls")
  array->Array.map(_m => {
    let account = _m->Array.getUnsafe(0)

    {
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external getVotesCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external getVotesFunction: t => string = "getVotes"

let getVotesCallCheck = (contract, {account}: getVotesCall) => {
  expect(contract->getVotesFunction)->getVotesCalledWith(account)
}

@send @scope("getVotes")
external mockGetVotesToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("getVotes")
external mockGetVotesToRevertNoReason: t => unit = "reverts"

type grantRoleCall = {
  role: string,
  account: Ethers.ethAddress,
}

let grantRoleOld: t => array<grantRoleCall> = _r => {
  let array = %raw("_r.grantRole.calls")
  array->Array.map(((role, account)) => {
    {
      role: role,
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external grantRoleCalledWith: (expectation, string, Ethers.ethAddress) => unit = "calledWith"

@get external grantRoleFunction: t => string = "grantRole"

let grantRoleCallCheck = (contract, {role, account}: grantRoleCall) => {
  expect(contract->grantRoleFunction)->grantRoleCalledWith(role, account)
}

@send @scope("grantRole")
external mockGrantRoleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("grantRole")
external mockGrantRoleToRevertNoReason: t => unit = "reverts"

@send @scope("hasRole")
external mockHasRoleToReturn: (t, bool) => unit = "returns"

type hasRoleCall = {
  role: string,
  account: Ethers.ethAddress,
}

let hasRoleOld: t => array<hasRoleCall> = _r => {
  let array = %raw("_r.hasRole.calls")
  array->Array.map(((role, account)) => {
    {
      role: role,
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external hasRoleCalledWith: (expectation, string, Ethers.ethAddress) => unit = "calledWith"

@get external hasRoleFunction: t => string = "hasRole"

let hasRoleCallCheck = (contract, {role, account}: hasRoleCall) => {
  expect(contract->hasRoleFunction)->hasRoleCalledWith(role, account)
}

@send @scope("hasRole")
external mockHasRoleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("hasRole")
external mockHasRoleToRevertNoReason: t => unit = "reverts"

@send @scope("increaseAllowance")
external mockIncreaseAllowanceToReturn: (t, bool) => unit = "returns"

type increaseAllowanceCall = {
  spender: Ethers.ethAddress,
  addedValue: Ethers.BigNumber.t,
}

let increaseAllowanceOld: t => array<increaseAllowanceCall> = _r => {
  let array = %raw("_r.increaseAllowance.calls")
  array->Array.map(((spender, addedValue)) => {
    {
      spender: spender,
      addedValue: addedValue,
    }
  })
}

@send @scope(("to", "have", "been"))
external increaseAllowanceCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external increaseAllowanceFunction: t => string = "increaseAllowance"

let increaseAllowanceCallCheck = (contract, {spender, addedValue}: increaseAllowanceCall) => {
  expect(contract->increaseAllowanceFunction)->increaseAllowanceCalledWith(spender, addedValue)
}

@send @scope("increaseAllowance")
external mockIncreaseAllowanceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("increaseAllowance")
external mockIncreaseAllowanceToRevertNoReason: t => unit = "reverts"

type initializeCall = {
  name: string,
  symbol: string,
  stakerAddress: Ethers.ethAddress,
}

let initializeOld: t => array<initializeCall> = _r => {
  let array = %raw("_r.initialize.calls")
  array->Array.map(((name, symbol, stakerAddress)) => {
    {
      name: name,
      symbol: symbol,
      stakerAddress: stakerAddress,
    }
  })
}

@send @scope(("to", "have", "been"))
external initializeCalledWith: (expectation, string, string, Ethers.ethAddress) => unit =
  "calledWith"

@get external initializeFunction: t => string = "initialize"

let initializeCallCheck = (contract, {name, symbol, stakerAddress}: initializeCall) => {
  expect(contract->initializeFunction)->initializeCalledWith(name, symbol, stakerAddress)
}

@send @scope("initialize")
external mockInitializeToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("initialize")
external mockInitializeToRevertNoReason: t => unit = "reverts"

type mintCall = {
  _to: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
}

let mintOld: t => array<mintCall> = _r => {
  let array = %raw("_r.mint.calls")
  array->Array.map(((_to, amount)) => {
    {
      _to: _to,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external mintCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit = "calledWith"

@get external mintFunction: t => string = "mint"

let mintCallCheck = (contract, {_to, amount}: mintCall) => {
  expect(contract->mintFunction)->mintCalledWith(_to, amount)
}

@send @scope("mint")
external mockMintToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("mint")
external mockMintToRevertNoReason: t => unit = "reverts"

@send @scope("name")
external mockNameToReturn: (t, string) => unit = "returns"

type nameCall

let nameOld: t => array<nameCall> = _r => {
  let array = %raw("_r.name.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external nameCalledWith: expectation => unit = "calledWith"

@get external nameFunction: t => string = "name"

let nameCallCheck = contract => {
  expect(contract->nameFunction)->nameCalledWith
}

@send @scope("name")
external mockNameToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("name")
external mockNameToRevertNoReason: t => unit = "reverts"

@send @scope("nonces")
external mockNoncesToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type noncesCall = {owner: Ethers.ethAddress}

let noncesOld: t => array<noncesCall> = _r => {
  let array = %raw("_r.nonces.calls")
  array->Array.map(_m => {
    let owner = _m->Array.getUnsafe(0)

    {
      owner: owner,
    }
  })
}

@send @scope(("to", "have", "been"))
external noncesCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external noncesFunction: t => string = "nonces"

let noncesCallCheck = (contract, {owner}: noncesCall) => {
  expect(contract->noncesFunction)->noncesCalledWith(owner)
}

@send @scope("nonces")
external mockNoncesToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("nonces")
external mockNoncesToRevertNoReason: t => unit = "reverts"

@send @scope("numCheckpoints")
external mockNumCheckpointsToReturn: (t, int) => unit = "returns"

type numCheckpointsCall = {account: Ethers.ethAddress}

let numCheckpointsOld: t => array<numCheckpointsCall> = _r => {
  let array = %raw("_r.numCheckpoints.calls")
  array->Array.map(_m => {
    let account = _m->Array.getUnsafe(0)

    {
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external numCheckpointsCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external numCheckpointsFunction: t => string = "numCheckpoints"

let numCheckpointsCallCheck = (contract, {account}: numCheckpointsCall) => {
  expect(contract->numCheckpointsFunction)->numCheckpointsCalledWith(account)
}

@send @scope("numCheckpoints")
external mockNumCheckpointsToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("numCheckpoints")
external mockNumCheckpointsToRevertNoReason: t => unit = "reverts"

type pauseCall

let pauseOld: t => array<pauseCall> = _r => {
  let array = %raw("_r.pause.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external pauseCalledWith: expectation => unit = "calledWith"

@get external pauseFunction: t => string = "pause"

let pauseCallCheck = contract => {
  expect(contract->pauseFunction)->pauseCalledWith
}

@send @scope("pause")
external mockPauseToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("pause")
external mockPauseToRevertNoReason: t => unit = "reverts"

@send @scope("paused")
external mockPausedToReturn: (t, bool) => unit = "returns"

type pausedCall

let pausedOld: t => array<pausedCall> = _r => {
  let array = %raw("_r.paused.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external pausedCalledWith: expectation => unit = "calledWith"

@get external pausedFunction: t => string = "paused"

let pausedCallCheck = contract => {
  expect(contract->pausedFunction)->pausedCalledWith
}

@send @scope("paused")
external mockPausedToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("paused")
external mockPausedToRevertNoReason: t => unit = "reverts"

type permitCall = {
  owner: Ethers.ethAddress,
  spender: Ethers.ethAddress,
  value: Ethers.BigNumber.t,
  deadline: Ethers.BigNumber.t,
  v: int,
  r: string,
  s: string,
}

let permitOld: t => array<permitCall> = _r => {
  let array = %raw("_r.permit.calls")
  array->Array.map(((owner, spender, value, deadline, v, r, s)) => {
    {
      owner: owner,
      spender: spender,
      value: value,
      deadline: deadline,
      v: v,
      r: r,
      s: s,
    }
  })
}

@send @scope(("to", "have", "been"))
external permitCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  int,
  string,
  string,
) => unit = "calledWith"

@get external permitFunction: t => string = "permit"

let permitCallCheck = (contract, {owner, spender, value, deadline, v, r, s}: permitCall) => {
  expect(contract->permitFunction)->permitCalledWith(owner, spender, value, deadline, v, r, s)
}

@send @scope("permit")
external mockPermitToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("permit")
external mockPermitToRevertNoReason: t => unit = "reverts"

type renounceRoleCall = {
  role: string,
  account: Ethers.ethAddress,
}

let renounceRoleOld: t => array<renounceRoleCall> = _r => {
  let array = %raw("_r.renounceRole.calls")
  array->Array.map(((role, account)) => {
    {
      role: role,
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external renounceRoleCalledWith: (expectation, string, Ethers.ethAddress) => unit = "calledWith"

@get external renounceRoleFunction: t => string = "renounceRole"

let renounceRoleCallCheck = (contract, {role, account}: renounceRoleCall) => {
  expect(contract->renounceRoleFunction)->renounceRoleCalledWith(role, account)
}

@send @scope("renounceRole")
external mockRenounceRoleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("renounceRole")
external mockRenounceRoleToRevertNoReason: t => unit = "reverts"

type revokeRoleCall = {
  role: string,
  account: Ethers.ethAddress,
}

let revokeRoleOld: t => array<revokeRoleCall> = _r => {
  let array = %raw("_r.revokeRole.calls")
  array->Array.map(((role, account)) => {
    {
      role: role,
      account: account,
    }
  })
}

@send @scope(("to", "have", "been"))
external revokeRoleCalledWith: (expectation, string, Ethers.ethAddress) => unit = "calledWith"

@get external revokeRoleFunction: t => string = "revokeRole"

let revokeRoleCallCheck = (contract, {role, account}: revokeRoleCall) => {
  expect(contract->revokeRoleFunction)->revokeRoleCalledWith(role, account)
}

@send @scope("revokeRole")
external mockRevokeRoleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("revokeRole")
external mockRevokeRoleToRevertNoReason: t => unit = "reverts"

@send @scope("supportsInterface")
external mockSupportsInterfaceToReturn: (t, bool) => unit = "returns"

type supportsInterfaceCall = {interfaceId: string}

let supportsInterfaceOld: t => array<supportsInterfaceCall> = _r => {
  let array = %raw("_r.supportsInterface.calls")
  array->Array.map(_m => {
    let interfaceId = _m->Array.getUnsafe(0)

    {
      interfaceId: interfaceId,
    }
  })
}

@send @scope(("to", "have", "been"))
external supportsInterfaceCalledWith: (expectation, string) => unit = "calledWith"

@get external supportsInterfaceFunction: t => string = "supportsInterface"

let supportsInterfaceCallCheck = (contract, {interfaceId}: supportsInterfaceCall) => {
  expect(contract->supportsInterfaceFunction)->supportsInterfaceCalledWith(interfaceId)
}

@send @scope("supportsInterface")
external mockSupportsInterfaceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("supportsInterface")
external mockSupportsInterfaceToRevertNoReason: t => unit = "reverts"

@send @scope("symbol")
external mockSymbolToReturn: (t, string) => unit = "returns"

type symbolCall

let symbolOld: t => array<symbolCall> = _r => {
  let array = %raw("_r.symbol.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external symbolCalledWith: expectation => unit = "calledWith"

@get external symbolFunction: t => string = "symbol"

let symbolCallCheck = contract => {
  expect(contract->symbolFunction)->symbolCalledWith
}

@send @scope("symbol")
external mockSymbolToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("symbol")
external mockSymbolToRevertNoReason: t => unit = "reverts"

@send @scope("totalSupply")
external mockTotalSupplyToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type totalSupplyCall

let totalSupplyOld: t => array<totalSupplyCall> = _r => {
  let array = %raw("_r.totalSupply.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external totalSupplyCalledWith: expectation => unit = "calledWith"

@get external totalSupplyFunction: t => string = "totalSupply"

let totalSupplyCallCheck = contract => {
  expect(contract->totalSupplyFunction)->totalSupplyCalledWith
}

@send @scope("totalSupply")
external mockTotalSupplyToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("totalSupply")
external mockTotalSupplyToRevertNoReason: t => unit = "reverts"

@send @scope("transfer")
external mockTransferToReturn: (t, bool) => unit = "returns"

type transferCall = {
  recipient: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
}

let transferOld: t => array<transferCall> = _r => {
  let array = %raw("_r.transfer.calls")
  array->Array.map(((recipient, amount)) => {
    {
      recipient: recipient,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external transferCalledWith: (expectation, Ethers.ethAddress, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external transferFunction: t => string = "transfer"

let transferCallCheck = (contract, {recipient, amount}: transferCall) => {
  expect(contract->transferFunction)->transferCalledWith(recipient, amount)
}

@send @scope("transfer")
external mockTransferToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("transfer")
external mockTransferToRevertNoReason: t => unit = "reverts"

@send @scope("transferFrom")
external mockTransferFromToReturn: (t, bool) => unit = "returns"

type transferFromCall = {
  sender: Ethers.ethAddress,
  recipient: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
}

let transferFromOld: t => array<transferFromCall> = _r => {
  let array = %raw("_r.transferFrom.calls")
  array->Array.map(((sender, recipient, amount)) => {
    {
      sender: sender,
      recipient: recipient,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external transferFromCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get external transferFromFunction: t => string = "transferFrom"

let transferFromCallCheck = (contract, {sender, recipient, amount}: transferFromCall) => {
  expect(contract->transferFromFunction)->transferFromCalledWith(sender, recipient, amount)
}

@send @scope("transferFrom")
external mockTransferFromToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("transferFrom")
external mockTransferFromToRevertNoReason: t => unit = "reverts"

type unpauseCall

let unpauseOld: t => array<unpauseCall> = _r => {
  let array = %raw("_r.unpause.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external unpauseCalledWith: expectation => unit = "calledWith"

@get external unpauseFunction: t => string = "unpause"

let unpauseCallCheck = contract => {
  expect(contract->unpauseFunction)->unpauseCalledWith
}

@send @scope("unpause")
external mockUnpauseToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("unpause")
external mockUnpauseToRevertNoReason: t => unit = "reverts"

type upgradeToCall = {newImplementation: Ethers.ethAddress}

let upgradeToOld: t => array<upgradeToCall> = _r => {
  let array = %raw("_r.upgradeTo.calls")
  array->Array.map(_m => {
    let newImplementation = _m->Array.getUnsafe(0)

    {
      newImplementation: newImplementation,
    }
  })
}

@send @scope(("to", "have", "been"))
external upgradeToCalledWith: (expectation, Ethers.ethAddress) => unit = "calledWith"

@get external upgradeToFunction: t => string = "upgradeTo"

let upgradeToCallCheck = (contract, {newImplementation}: upgradeToCall) => {
  expect(contract->upgradeToFunction)->upgradeToCalledWith(newImplementation)
}

@send @scope("upgradeTo")
external mockUpgradeToToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("upgradeTo")
external mockUpgradeToToRevertNoReason: t => unit = "reverts"

type upgradeToAndCallCall = {
  newImplementation: Ethers.ethAddress,
  data: string,
}

let upgradeToAndCallOld: t => array<upgradeToAndCallCall> = _r => {
  let array = %raw("_r.upgradeToAndCall.calls")
  array->Array.map(((newImplementation, data)) => {
    {
      newImplementation: newImplementation,
      data: data,
    }
  })
}

@send @scope(("to", "have", "been"))
external upgradeToAndCallCalledWith: (expectation, Ethers.ethAddress, string) => unit = "calledWith"

@get external upgradeToAndCallFunction: t => string = "upgradeToAndCall"

let upgradeToAndCallCallCheck = (contract, {newImplementation, data}: upgradeToAndCallCall) => {
  expect(contract->upgradeToAndCallFunction)->upgradeToAndCallCalledWith(newImplementation, data)
}

@send @scope("upgradeToAndCall")
external mockUpgradeToAndCallToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("upgradeToAndCall")
external mockUpgradeToAndCallToRevertNoReason: t => unit = "reverts"
