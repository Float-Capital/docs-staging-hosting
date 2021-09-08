open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("YieldManagerAave")

let uninitializedValue: t = None->Obj.magic

@send @scope("ADMIN_ROLE")
external mockADMIN_ROLEToReturn: (t, string) => unit = "returns"

type aDMIN_ROLECall

let aDMIN_ROLEOld: t => array<aDMIN_ROLECall> = _r => {
  let array = %raw("_r.ADMIN_ROLE.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external aDMIN_ROLECalledWith: expectation => unit = "calledWith"

@get external aDMIN_ROLEFunction: t => string = "aDMIN_ROLE"

let aDMIN_ROLECallCheck = contract => {
  expect(contract->aDMIN_ROLEFunction)->aDMIN_ROLECalledWith
}

@send @scope("ADMIN_ROLE")
external mockADMIN_ROLEToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("ADMIN_ROLE")
external mockADMIN_ROLEToRevertNoReason: t => unit = "reverts"

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

@send @scope("aToken")
external mockATokenToReturn: (t, Ethers.ethAddress) => unit = "returns"

type aTokenCall

let aTokenOld: t => array<aTokenCall> = _r => {
  let array = %raw("_r.aToken.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external aTokenCalledWith: expectation => unit = "calledWith"

@get external aTokenFunction: t => string = "aToken"

let aTokenCallCheck = contract => {
  expect(contract->aTokenFunction)->aTokenCalledWith
}

@send @scope("aToken")
external mockATokenToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("aToken")
external mockATokenToRevertNoReason: t => unit = "reverts"

@send @scope("aaveIncentivesController")
external mockAaveIncentivesControllerToReturn: (t, Ethers.ethAddress) => unit = "returns"

type aaveIncentivesControllerCall

let aaveIncentivesControllerOld: t => array<aaveIncentivesControllerCall> = _r => {
  let array = %raw("_r.aaveIncentivesController.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external aaveIncentivesControllerCalledWith: expectation => unit = "calledWith"

@get external aaveIncentivesControllerFunction: t => string = "aaveIncentivesController"

let aaveIncentivesControllerCallCheck = contract => {
  expect(contract->aaveIncentivesControllerFunction)->aaveIncentivesControllerCalledWith
}

@send @scope("aaveIncentivesController")
external mockAaveIncentivesControllerToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("aaveIncentivesController")
external mockAaveIncentivesControllerToRevertNoReason: t => unit = "reverts"

@send @scope("amountReservedInCaseOfInsufficientAaveLiquidity")
external mockAmountReservedInCaseOfInsufficientAaveLiquidityToReturn: (
  t,
  Ethers.BigNumber.t,
) => unit = "returns"

type amountReservedInCaseOfInsufficientAaveLiquidityCall

let amountReservedInCaseOfInsufficientAaveLiquidityOld: t => array<
  amountReservedInCaseOfInsufficientAaveLiquidityCall,
> = _r => {
  let array = %raw("_r.amountReservedInCaseOfInsufficientAaveLiquidity.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external amountReservedInCaseOfInsufficientAaveLiquidityCalledWith: expectation => unit =
  "calledWith"

@get
external amountReservedInCaseOfInsufficientAaveLiquidityFunction: t => string =
  "amountReservedInCaseOfInsufficientAaveLiquidity"

let amountReservedInCaseOfInsufficientAaveLiquidityCallCheck = contract => {
  expect(
    contract->amountReservedInCaseOfInsufficientAaveLiquidityFunction,
  )->amountReservedInCaseOfInsufficientAaveLiquidityCalledWith
}

@send @scope("amountReservedInCaseOfInsufficientAaveLiquidity")
external mockAmountReservedInCaseOfInsufficientAaveLiquidityToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("amountReservedInCaseOfInsufficientAaveLiquidity")
external mockAmountReservedInCaseOfInsufficientAaveLiquidityToRevertNoReason: t => unit = "reverts"

type claimAaveRewardsToTreasuryCall

let claimAaveRewardsToTreasuryOld: t => array<claimAaveRewardsToTreasuryCall> = _r => {
  let array = %raw("_r.claimAaveRewardsToTreasury.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external claimAaveRewardsToTreasuryCalledWith: expectation => unit = "calledWith"

@get external claimAaveRewardsToTreasuryFunction: t => string = "claimAaveRewardsToTreasury"

let claimAaveRewardsToTreasuryCallCheck = contract => {
  expect(contract->claimAaveRewardsToTreasuryFunction)->claimAaveRewardsToTreasuryCalledWith
}

@send @scope("claimAaveRewardsToTreasury")
external mockClaimAaveRewardsToTreasuryToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("claimAaveRewardsToTreasury")
external mockClaimAaveRewardsToTreasuryToRevertNoReason: t => unit = "reverts"

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

type initializeCall = {
  longShort: Ethers.ethAddress,
  treasury: Ethers.ethAddress,
  paymentToken: Ethers.ethAddress,
  aToken: Ethers.ethAddress,
  lendingPoolAddressesProvider: Ethers.ethAddress,
  aaveIncentivesController: Ethers.ethAddress,
  aaveReferralCode: int,
  admin: Ethers.ethAddress,
}

let initializeOld: t => array<initializeCall> = _r => {
  let array = %raw("_r.initialize.calls")
  array->Array.map(((
    longShort,
    treasury,
    paymentToken,
    aToken,
    lendingPoolAddressesProvider,
    aaveIncentivesController,
    aaveReferralCode,
    admin,
  )) => {
    {
      longShort: longShort,
      treasury: treasury,
      paymentToken: paymentToken,
      aToken: aToken,
      lendingPoolAddressesProvider: lendingPoolAddressesProvider,
      aaveIncentivesController: aaveIncentivesController,
      aaveReferralCode: aaveReferralCode,
      admin: admin,
    }
  })
}

@send @scope(("to", "have", "been"))
external initializeCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  int,
  Ethers.ethAddress,
) => unit = "calledWith"

@get external initializeFunction: t => string = "initialize"

let initializeCallCheck = (
  contract,
  {
    longShort,
    treasury,
    paymentToken,
    aToken,
    lendingPoolAddressesProvider,
    aaveIncentivesController,
    aaveReferralCode,
    admin,
  }: initializeCall,
) => {
  expect(contract->initializeFunction)->initializeCalledWith(
    longShort,
    treasury,
    paymentToken,
    aToken,
    lendingPoolAddressesProvider,
    aaveIncentivesController,
    aaveReferralCode,
    admin,
  )
}

@send @scope("initialize")
external mockInitializeToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("initialize")
external mockInitializeToRevertNoReason: t => unit = "reverts"

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

@send @scope("lendingPoolAddressesProvider")
external mockLendingPoolAddressesProviderToReturn: (t, Ethers.ethAddress) => unit = "returns"

type lendingPoolAddressesProviderCall

let lendingPoolAddressesProviderOld: t => array<lendingPoolAddressesProviderCall> = _r => {
  let array = %raw("_r.lendingPoolAddressesProvider.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external lendingPoolAddressesProviderCalledWith: expectation => unit = "calledWith"

@get external lendingPoolAddressesProviderFunction: t => string = "lendingPoolAddressesProvider"

let lendingPoolAddressesProviderCallCheck = contract => {
  expect(contract->lendingPoolAddressesProviderFunction)->lendingPoolAddressesProviderCalledWith
}

@send @scope("lendingPoolAddressesProvider")
external mockLendingPoolAddressesProviderToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("lendingPoolAddressesProvider")
external mockLendingPoolAddressesProviderToRevertNoReason: t => unit = "reverts"

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

@send @scope("paymentToken")
external mockPaymentTokenToReturn: (t, Ethers.ethAddress) => unit = "returns"

type paymentTokenCall

let paymentTokenOld: t => array<paymentTokenCall> = _r => {
  let array = %raw("_r.paymentToken.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external paymentTokenCalledWith: expectation => unit = "calledWith"

@get external paymentTokenFunction: t => string = "paymentToken"

let paymentTokenCallCheck = contract => {
  expect(contract->paymentTokenFunction)->paymentTokenCalledWith
}

@send @scope("paymentToken")
external mockPaymentTokenToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("paymentToken")
external mockPaymentTokenToRevertNoReason: t => unit = "reverts"

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

type updateLatestLendingPoolAddressCall

let updateLatestLendingPoolAddressOld: t => array<updateLatestLendingPoolAddressCall> = _r => {
  let array = %raw("_r.updateLatestLendingPoolAddress.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external updateLatestLendingPoolAddressCalledWith: expectation => unit = "calledWith"

@get external updateLatestLendingPoolAddressFunction: t => string = "updateLatestLendingPoolAddress"

let updateLatestLendingPoolAddressCallCheck = contract => {
  expect(contract->updateLatestLendingPoolAddressFunction)->updateLatestLendingPoolAddressCalledWith
}

@send @scope("updateLatestLendingPoolAddress")
external mockUpdateLatestLendingPoolAddressToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("updateLatestLendingPoolAddress")
external mockUpdateLatestLendingPoolAddressToRevertNoReason: t => unit = "reverts"

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
