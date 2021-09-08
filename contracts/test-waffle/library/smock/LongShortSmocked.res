open SmockGeneral

%%raw(`
const { expect, use } = require("chai");
use(require('@defi-wonderland/smock').smock.matchers);
`)

type t = {address: Ethers.ethAddress}

@module("@defi-wonderland/smock") @scope("smock")
external makeRaw: string => Js.Promise.t<t> = "fake"
let make = () => makeRaw("LongShort")

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

@send @scope("PERMANENT_INITIAL_LIQUIDITY_HOLDER")
external mockPERMANENT_INITIAL_LIQUIDITY_HOLDERToReturn: (t, Ethers.ethAddress) => unit = "returns"

type pERMANENT_INITIAL_LIQUIDITY_HOLDERCall

let pERMANENT_INITIAL_LIQUIDITY_HOLDEROld: t => array<
  pERMANENT_INITIAL_LIQUIDITY_HOLDERCall,
> = _r => {
  let array = %raw("_r.PERMANENT_INITIAL_LIQUIDITY_HOLDER.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external pERMANENT_INITIAL_LIQUIDITY_HOLDERCalledWith: expectation => unit = "calledWith"

@get
external pERMANENT_INITIAL_LIQUIDITY_HOLDERFunction: t => string =
  "pERMANENT_INITIAL_LIQUIDITY_HOLDER"

let pERMANENT_INITIAL_LIQUIDITY_HOLDERCallCheck = contract => {
  expect(
    contract->pERMANENT_INITIAL_LIQUIDITY_HOLDERFunction,
  )->pERMANENT_INITIAL_LIQUIDITY_HOLDERCalledWith
}

@send @scope("PERMANENT_INITIAL_LIQUIDITY_HOLDER")
external mockPERMANENT_INITIAL_LIQUIDITY_HOLDERToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("PERMANENT_INITIAL_LIQUIDITY_HOLDER")
external mockPERMANENT_INITIAL_LIQUIDITY_HOLDERToRevertNoReason: t => unit = "reverts"

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

@send @scope("assetPrice")
external mockAssetPriceToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type assetPriceCall = {param0: int}

let assetPriceOld: t => array<assetPriceCall> = _r => {
  let array = %raw("_r.assetPrice.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external assetPriceCalledWith: (expectation, int) => unit = "calledWith"

@get external assetPriceFunction: t => string = "assetPrice"

let assetPriceCallCheck = (contract, {param0}: assetPriceCall) => {
  expect(contract->assetPriceFunction)->assetPriceCalledWith(param0)
}

@send @scope("assetPrice")
external mockAssetPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("assetPrice")
external mockAssetPriceToRevertNoReason: t => unit = "reverts"

@send @scope("batched_amountPaymentToken_deposit")
external mockBatched_amountPaymentToken_depositToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type batched_amountPaymentToken_depositCall = {
  param0: int,
  param1: bool,
}

let batched_amountPaymentToken_depositOld: t => array<
  batched_amountPaymentToken_depositCall,
> = _r => {
  let array = %raw("_r.batched_amountPaymentToken_deposit.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external batched_amountPaymentToken_depositCalledWith: (expectation, int, bool) => unit =
  "calledWith"

@get
external batched_amountPaymentToken_depositFunction: t => string =
  "batched_amountPaymentToken_deposit"

let batched_amountPaymentToken_depositCallCheck = (
  contract,
  {param0, param1}: batched_amountPaymentToken_depositCall,
) => {
  expect(
    contract->batched_amountPaymentToken_depositFunction,
  )->batched_amountPaymentToken_depositCalledWith(param0, param1)
}

@send @scope("batched_amountPaymentToken_deposit")
external mockBatched_amountPaymentToken_depositToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("batched_amountPaymentToken_deposit")
external mockBatched_amountPaymentToken_depositToRevertNoReason: t => unit = "reverts"

@send @scope("batched_amountSyntheticToken_redeem")
external mockBatched_amountSyntheticToken_redeemToReturn: (t, Ethers.BigNumber.t) => unit =
  "returns"

type batched_amountSyntheticToken_redeemCall = {
  param0: int,
  param1: bool,
}

let batched_amountSyntheticToken_redeemOld: t => array<
  batched_amountSyntheticToken_redeemCall,
> = _r => {
  let array = %raw("_r.batched_amountSyntheticToken_redeem.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external batched_amountSyntheticToken_redeemCalledWith: (expectation, int, bool) => unit =
  "calledWith"

@get
external batched_amountSyntheticToken_redeemFunction: t => string =
  "batched_amountSyntheticToken_redeem"

let batched_amountSyntheticToken_redeemCallCheck = (
  contract,
  {param0, param1}: batched_amountSyntheticToken_redeemCall,
) => {
  expect(
    contract->batched_amountSyntheticToken_redeemFunction,
  )->batched_amountSyntheticToken_redeemCalledWith(param0, param1)
}

@send @scope("batched_amountSyntheticToken_redeem")
external mockBatched_amountSyntheticToken_redeemToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("batched_amountSyntheticToken_redeem")
external mockBatched_amountSyntheticToken_redeemToRevertNoReason: t => unit = "reverts"

@send @scope("batched_amountSyntheticToken_toShiftAwayFrom_marketSide")
external mockBatched_amountSyntheticToken_toShiftAwayFrom_marketSideToReturn: (
  t,
  Ethers.BigNumber.t,
) => unit = "returns"

type batched_amountSyntheticToken_toShiftAwayFrom_marketSideCall = {
  param0: int,
  param1: bool,
}

let batched_amountSyntheticToken_toShiftAwayFrom_marketSideOld: t => array<
  batched_amountSyntheticToken_toShiftAwayFrom_marketSideCall,
> = _r => {
  let array = %raw("_r.batched_amountSyntheticToken_toShiftAwayFrom_marketSide.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external batched_amountSyntheticToken_toShiftAwayFrom_marketSideCalledWith: (
  expectation,
  int,
  bool,
) => unit = "calledWith"

@get
external batched_amountSyntheticToken_toShiftAwayFrom_marketSideFunction: t => string =
  "batched_amountSyntheticToken_toShiftAwayFrom_marketSide"

let batched_amountSyntheticToken_toShiftAwayFrom_marketSideCallCheck = (
  contract,
  {param0, param1}: batched_amountSyntheticToken_toShiftAwayFrom_marketSideCall,
) => {
  expect(
    contract->batched_amountSyntheticToken_toShiftAwayFrom_marketSideFunction,
  )->batched_amountSyntheticToken_toShiftAwayFrom_marketSideCalledWith(param0, param1)
}

@send @scope("batched_amountSyntheticToken_toShiftAwayFrom_marketSide")
external mockBatched_amountSyntheticToken_toShiftAwayFrom_marketSideToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("batched_amountSyntheticToken_toShiftAwayFrom_marketSide")
external mockBatched_amountSyntheticToken_toShiftAwayFrom_marketSideToRevertNoReason: t => unit =
  "reverts"

type changeMarketTreasurySplitGradientCall = {
  marketIndex: int,
  marketTreasurySplitGradient_e18: Ethers.BigNumber.t,
}

let changeMarketTreasurySplitGradientOld: t => array<
  changeMarketTreasurySplitGradientCall,
> = _r => {
  let array = %raw("_r.changeMarketTreasurySplitGradient.calls")
  array->Array.map(((marketIndex, marketTreasurySplitGradient_e18)) => {
    {
      marketIndex: marketIndex,
      marketTreasurySplitGradient_e18: marketTreasurySplitGradient_e18,
    }
  })
}

@send @scope(("to", "have", "been"))
external changeMarketTreasurySplitGradientCalledWith: (
  expectation,
  int,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get
external changeMarketTreasurySplitGradientFunction: t => string =
  "changeMarketTreasurySplitGradient"

let changeMarketTreasurySplitGradientCallCheck = (
  contract,
  {marketIndex, marketTreasurySplitGradient_e18}: changeMarketTreasurySplitGradientCall,
) => {
  expect(
    contract->changeMarketTreasurySplitGradientFunction,
  )->changeMarketTreasurySplitGradientCalledWith(marketIndex, marketTreasurySplitGradient_e18)
}

@send @scope("changeMarketTreasurySplitGradient")
external mockChangeMarketTreasurySplitGradientToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("changeMarketTreasurySplitGradient")
external mockChangeMarketTreasurySplitGradientToRevertNoReason: t => unit = "reverts"

type createNewSyntheticMarketCall = {
  syntheticName: string,
  syntheticSymbol: string,
  paymentToken: Ethers.ethAddress,
  oracleManager: Ethers.ethAddress,
  yieldManager: Ethers.ethAddress,
}

let createNewSyntheticMarketOld: t => array<createNewSyntheticMarketCall> = _r => {
  let array = %raw("_r.createNewSyntheticMarket.calls")
  array->Array.map(((
    syntheticName,
    syntheticSymbol,
    paymentToken,
    oracleManager,
    yieldManager,
  )) => {
    {
      syntheticName: syntheticName,
      syntheticSymbol: syntheticSymbol,
      paymentToken: paymentToken,
      oracleManager: oracleManager,
      yieldManager: yieldManager,
    }
  })
}

@send @scope(("to", "have", "been"))
external createNewSyntheticMarketCalledWith: (
  expectation,
  string,
  string,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
) => unit = "calledWith"

@get external createNewSyntheticMarketFunction: t => string = "createNewSyntheticMarket"

let createNewSyntheticMarketCallCheck = (
  contract,
  {
    syntheticName,
    syntheticSymbol,
    paymentToken,
    oracleManager,
    yieldManager,
  }: createNewSyntheticMarketCall,
) => {
  expect(contract->createNewSyntheticMarketFunction)->createNewSyntheticMarketCalledWith(
    syntheticName,
    syntheticSymbol,
    paymentToken,
    oracleManager,
    yieldManager,
  )
}

@send @scope("createNewSyntheticMarket")
external mockCreateNewSyntheticMarketToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("createNewSyntheticMarket")
external mockCreateNewSyntheticMarketToRevertNoReason: t => unit = "reverts"

type createNewSyntheticMarketExternalSyntheticTokensCall = {
  syntheticName: string,
  syntheticSymbol: string,
  longToken: Ethers.ethAddress,
  shortToken: Ethers.ethAddress,
  paymentToken: Ethers.ethAddress,
  oracleManager: Ethers.ethAddress,
  yieldManager: Ethers.ethAddress,
}

let createNewSyntheticMarketExternalSyntheticTokensOld: t => array<
  createNewSyntheticMarketExternalSyntheticTokensCall,
> = _r => {
  let array = %raw("_r.createNewSyntheticMarketExternalSyntheticTokens.calls")
  array->Array.map(((
    syntheticName,
    syntheticSymbol,
    longToken,
    shortToken,
    paymentToken,
    oracleManager,
    yieldManager,
  )) => {
    {
      syntheticName: syntheticName,
      syntheticSymbol: syntheticSymbol,
      longToken: longToken,
      shortToken: shortToken,
      paymentToken: paymentToken,
      oracleManager: oracleManager,
      yieldManager: yieldManager,
    }
  })
}

@send @scope(("to", "have", "been"))
external createNewSyntheticMarketExternalSyntheticTokensCalledWith: (
  expectation,
  string,
  string,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
) => unit = "calledWith"

@get
external createNewSyntheticMarketExternalSyntheticTokensFunction: t => string =
  "createNewSyntheticMarketExternalSyntheticTokens"

let createNewSyntheticMarketExternalSyntheticTokensCallCheck = (
  contract,
  {
    syntheticName,
    syntheticSymbol,
    longToken,
    shortToken,
    paymentToken,
    oracleManager,
    yieldManager,
  }: createNewSyntheticMarketExternalSyntheticTokensCall,
) => {
  expect(
    contract->createNewSyntheticMarketExternalSyntheticTokensFunction,
  )->createNewSyntheticMarketExternalSyntheticTokensCalledWith(
    syntheticName,
    syntheticSymbol,
    longToken,
    shortToken,
    paymentToken,
    oracleManager,
    yieldManager,
  )
}

@send @scope("createNewSyntheticMarketExternalSyntheticTokens")
external mockCreateNewSyntheticMarketExternalSyntheticTokensToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("createNewSyntheticMarketExternalSyntheticTokens")
external mockCreateNewSyntheticMarketExternalSyntheticTokensToRevertNoReason: t => unit = "reverts"

type executeOutstandingNextPriceSettlementsUserCall = {
  user: Ethers.ethAddress,
  marketIndex: int,
}

let executeOutstandingNextPriceSettlementsUserOld: t => array<
  executeOutstandingNextPriceSettlementsUserCall,
> = _r => {
  let array = %raw("_r.executeOutstandingNextPriceSettlementsUser.calls")
  array->Array.map(((user, marketIndex)) => {
    {
      user: user,
      marketIndex: marketIndex,
    }
  })
}

@send @scope(("to", "have", "been"))
external executeOutstandingNextPriceSettlementsUserCalledWith: (
  expectation,
  Ethers.ethAddress,
  int,
) => unit = "calledWith"

@get
external executeOutstandingNextPriceSettlementsUserFunction: t => string =
  "executeOutstandingNextPriceSettlementsUser"

let executeOutstandingNextPriceSettlementsUserCallCheck = (
  contract,
  {user, marketIndex}: executeOutstandingNextPriceSettlementsUserCall,
) => {
  expect(
    contract->executeOutstandingNextPriceSettlementsUserFunction,
  )->executeOutstandingNextPriceSettlementsUserCalledWith(user, marketIndex)
}

@send @scope("executeOutstandingNextPriceSettlementsUser")
external mockExecuteOutstandingNextPriceSettlementsUserToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("executeOutstandingNextPriceSettlementsUser")
external mockExecuteOutstandingNextPriceSettlementsUserToRevertNoReason: t => unit = "reverts"

type executeOutstandingNextPriceSettlementsUserMultiCall = {
  user: Ethers.ethAddress,
  marketIndexes: array<int>,
}

let executeOutstandingNextPriceSettlementsUserMultiOld: t => array<
  executeOutstandingNextPriceSettlementsUserMultiCall,
> = _r => {
  let array = %raw("_r.executeOutstandingNextPriceSettlementsUserMulti.calls")
  array->Array.map(((user, marketIndexes)) => {
    {
      user: user,
      marketIndexes: marketIndexes,
    }
  })
}

@send @scope(("to", "have", "been"))
external executeOutstandingNextPriceSettlementsUserMultiCalledWith: (
  expectation,
  Ethers.ethAddress,
  array<int>,
) => unit = "calledWith"

@get
external executeOutstandingNextPriceSettlementsUserMultiFunction: t => string =
  "executeOutstandingNextPriceSettlementsUserMulti"

let executeOutstandingNextPriceSettlementsUserMultiCallCheck = (
  contract,
  {user, marketIndexes}: executeOutstandingNextPriceSettlementsUserMultiCall,
) => {
  expect(
    contract->executeOutstandingNextPriceSettlementsUserMultiFunction,
  )->executeOutstandingNextPriceSettlementsUserMultiCalledWith(user, marketIndexes)
}

@send @scope("executeOutstandingNextPriceSettlementsUserMulti")
external mockExecuteOutstandingNextPriceSettlementsUserMultiToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("executeOutstandingNextPriceSettlementsUserMulti")
external mockExecuteOutstandingNextPriceSettlementsUserMultiToRevertNoReason: t => unit = "reverts"

@send @scope("getAmountSyntheticTokenToMintOnTargetSide")
external mockGetAmountSyntheticTokenToMintOnTargetSideToReturn: (t, Ethers.BigNumber.t) => unit =
  "returns"

type getAmountSyntheticTokenToMintOnTargetSideCall = {
  marketIndex: int,
  amountSyntheticToken_redeemOnOriginSide: Ethers.BigNumber.t,
  isShiftFromLong: bool,
  priceSnapshotIndex: Ethers.BigNumber.t,
}

let getAmountSyntheticTokenToMintOnTargetSideOld: t => array<
  getAmountSyntheticTokenToMintOnTargetSideCall,
> = _r => {
  let array = %raw("_r.getAmountSyntheticTokenToMintOnTargetSide.calls")
  array->Array.map(((
    marketIndex,
    amountSyntheticToken_redeemOnOriginSide,
    isShiftFromLong,
    priceSnapshotIndex,
  )) => {
    {
      marketIndex: marketIndex,
      amountSyntheticToken_redeemOnOriginSide: amountSyntheticToken_redeemOnOriginSide,
      isShiftFromLong: isShiftFromLong,
      priceSnapshotIndex: priceSnapshotIndex,
    }
  })
}

@send @scope(("to", "have", "been"))
external getAmountSyntheticTokenToMintOnTargetSideCalledWith: (
  expectation,
  int,
  Ethers.BigNumber.t,
  bool,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get
external getAmountSyntheticTokenToMintOnTargetSideFunction: t => string =
  "getAmountSyntheticTokenToMintOnTargetSide"

let getAmountSyntheticTokenToMintOnTargetSideCallCheck = (
  contract,
  {
    marketIndex,
    amountSyntheticToken_redeemOnOriginSide,
    isShiftFromLong,
    priceSnapshotIndex,
  }: getAmountSyntheticTokenToMintOnTargetSideCall,
) => {
  expect(
    contract->getAmountSyntheticTokenToMintOnTargetSideFunction,
  )->getAmountSyntheticTokenToMintOnTargetSideCalledWith(
    marketIndex,
    amountSyntheticToken_redeemOnOriginSide,
    isShiftFromLong,
    priceSnapshotIndex,
  )
}

@send @scope("getAmountSyntheticTokenToMintOnTargetSide")
external mockGetAmountSyntheticTokenToMintOnTargetSideToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("getAmountSyntheticTokenToMintOnTargetSide")
external mockGetAmountSyntheticTokenToMintOnTargetSideToRevertNoReason: t => unit = "reverts"

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

@send @scope("getUsersConfirmedButNotSettledSynthBalance")
external mockGetUsersConfirmedButNotSettledSynthBalanceToReturn: (t, Ethers.BigNumber.t) => unit =
  "returns"

type getUsersConfirmedButNotSettledSynthBalanceCall = {
  user: Ethers.ethAddress,
  marketIndex: int,
  isLong: bool,
}

let getUsersConfirmedButNotSettledSynthBalanceOld: t => array<
  getUsersConfirmedButNotSettledSynthBalanceCall,
> = _r => {
  let array = %raw("_r.getUsersConfirmedButNotSettledSynthBalance.calls")
  array->Array.map(((user, marketIndex, isLong)) => {
    {
      user: user,
      marketIndex: marketIndex,
      isLong: isLong,
    }
  })
}

@send @scope(("to", "have", "been"))
external getUsersConfirmedButNotSettledSynthBalanceCalledWith: (
  expectation,
  Ethers.ethAddress,
  int,
  bool,
) => unit = "calledWith"

@get
external getUsersConfirmedButNotSettledSynthBalanceFunction: t => string =
  "getUsersConfirmedButNotSettledSynthBalance"

let getUsersConfirmedButNotSettledSynthBalanceCallCheck = (
  contract,
  {user, marketIndex, isLong}: getUsersConfirmedButNotSettledSynthBalanceCall,
) => {
  expect(
    contract->getUsersConfirmedButNotSettledSynthBalanceFunction,
  )->getUsersConfirmedButNotSettledSynthBalanceCalledWith(user, marketIndex, isLong)
}

@send @scope("getUsersConfirmedButNotSettledSynthBalance")
external mockGetUsersConfirmedButNotSettledSynthBalanceToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("getUsersConfirmedButNotSettledSynthBalance")
external mockGetUsersConfirmedButNotSettledSynthBalanceToRevertNoReason: t => unit = "reverts"

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
  admin: Ethers.ethAddress,
  tokenFactory: Ethers.ethAddress,
  staker: Ethers.ethAddress,
}

let initializeOld: t => array<initializeCall> = _r => {
  let array = %raw("_r.initialize.calls")
  array->Array.map(((admin, tokenFactory, staker)) => {
    {
      admin: admin,
      tokenFactory: tokenFactory,
      staker: staker,
    }
  })
}

@send @scope(("to", "have", "been"))
external initializeCalledWith: (
  expectation,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
) => unit = "calledWith"

@get external initializeFunction: t => string = "initialize"

let initializeCallCheck = (contract, {admin, tokenFactory, staker}: initializeCall) => {
  expect(contract->initializeFunction)->initializeCalledWith(admin, tokenFactory, staker)
}

@send @scope("initialize")
external mockInitializeToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("initialize")
external mockInitializeToRevertNoReason: t => unit = "reverts"

type initializeMarketCall = {
  marketIndex: int,
  kInitialMultiplier: Ethers.BigNumber.t,
  kPeriod: Ethers.BigNumber.t,
  unstakeFee_e18: Ethers.BigNumber.t,
  initialMarketSeedForEachMarketSide: Ethers.BigNumber.t,
  balanceIncentiveCurve_exponent: Ethers.BigNumber.t,
  balanceIncentiveCurve_equilibriumOffset: Ethers.BigNumber.t,
  marketTreasurySplitGradient_e18: Ethers.BigNumber.t,
}

let initializeMarketOld: t => array<initializeMarketCall> = _r => {
  let array = %raw("_r.initializeMarket.calls")
  array->Array.map(((
    marketIndex,
    kInitialMultiplier,
    kPeriod,
    unstakeFee_e18,
    initialMarketSeedForEachMarketSide,
    balanceIncentiveCurve_exponent,
    balanceIncentiveCurve_equilibriumOffset,
    marketTreasurySplitGradient_e18,
  )) => {
    {
      marketIndex: marketIndex,
      kInitialMultiplier: kInitialMultiplier,
      kPeriod: kPeriod,
      unstakeFee_e18: unstakeFee_e18,
      initialMarketSeedForEachMarketSide: initialMarketSeedForEachMarketSide,
      balanceIncentiveCurve_exponent: balanceIncentiveCurve_exponent,
      balanceIncentiveCurve_equilibriumOffset: balanceIncentiveCurve_equilibriumOffset,
      marketTreasurySplitGradient_e18: marketTreasurySplitGradient_e18,
    }
  })
}

@send @scope(("to", "have", "been"))
external initializeMarketCalledWith: (
  expectation,
  int,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get external initializeMarketFunction: t => string = "initializeMarket"

let initializeMarketCallCheck = (
  contract,
  {
    marketIndex,
    kInitialMultiplier,
    kPeriod,
    unstakeFee_e18,
    initialMarketSeedForEachMarketSide,
    balanceIncentiveCurve_exponent,
    balanceIncentiveCurve_equilibriumOffset,
    marketTreasurySplitGradient_e18,
  }: initializeMarketCall,
) => {
  expect(contract->initializeMarketFunction)->initializeMarketCalledWith(
    marketIndex,
    kInitialMultiplier,
    kPeriod,
    unstakeFee_e18,
    initialMarketSeedForEachMarketSide,
    balanceIncentiveCurve_exponent,
    balanceIncentiveCurve_equilibriumOffset,
    marketTreasurySplitGradient_e18,
  )
}

@send @scope("initializeMarket")
external mockInitializeMarketToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("initializeMarket")
external mockInitializeMarketToRevertNoReason: t => unit = "reverts"

@send @scope("latestMarket")
external mockLatestMarketToReturn: (t, int) => unit = "returns"

type latestMarketCall

let latestMarketOld: t => array<latestMarketCall> = _r => {
  let array = %raw("_r.latestMarket.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external latestMarketCalledWith: expectation => unit = "calledWith"

@get external latestMarketFunction: t => string = "latestMarket"

let latestMarketCallCheck = contract => {
  expect(contract->latestMarketFunction)->latestMarketCalledWith
}

@send @scope("latestMarket")
external mockLatestMarketToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("latestMarket")
external mockLatestMarketToRevertNoReason: t => unit = "reverts"

@send @scope("marketExists")
external mockMarketExistsToReturn: (t, bool) => unit = "returns"

type marketExistsCall = {param0: int}

let marketExistsOld: t => array<marketExistsCall> = _r => {
  let array = %raw("_r.marketExists.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external marketExistsCalledWith: (expectation, int) => unit = "calledWith"

@get external marketExistsFunction: t => string = "marketExists"

let marketExistsCallCheck = (contract, {param0}: marketExistsCall) => {
  expect(contract->marketExistsFunction)->marketExistsCalledWith(param0)
}

@send @scope("marketExists")
external mockMarketExistsToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("marketExists")
external mockMarketExistsToRevertNoReason: t => unit = "reverts"

@send @scope("marketSideValueInPaymentToken")
external mockMarketSideValueInPaymentTokenToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type marketSideValueInPaymentTokenCall = {
  param0: int,
  param1: bool,
}

let marketSideValueInPaymentTokenOld: t => array<marketSideValueInPaymentTokenCall> = _r => {
  let array = %raw("_r.marketSideValueInPaymentToken.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external marketSideValueInPaymentTokenCalledWith: (expectation, int, bool) => unit = "calledWith"

@get external marketSideValueInPaymentTokenFunction: t => string = "marketSideValueInPaymentToken"

let marketSideValueInPaymentTokenCallCheck = (
  contract,
  {param0, param1}: marketSideValueInPaymentTokenCall,
) => {
  expect(contract->marketSideValueInPaymentTokenFunction)->marketSideValueInPaymentTokenCalledWith(
    param0,
    param1,
  )
}

@send @scope("marketSideValueInPaymentToken")
external mockMarketSideValueInPaymentTokenToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("marketSideValueInPaymentToken")
external mockMarketSideValueInPaymentTokenToRevertNoReason: t => unit = "reverts"

@send @scope("marketTreasurySplitGradient_e18")
external mockMarketTreasurySplitGradient_e18ToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type marketTreasurySplitGradient_e18Call = {param0: int}

let marketTreasurySplitGradient_e18Old: t => array<marketTreasurySplitGradient_e18Call> = _r => {
  let array = %raw("_r.marketTreasurySplitGradient_e18.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external marketTreasurySplitGradient_e18CalledWith: (expectation, int) => unit = "calledWith"

@get
external marketTreasurySplitGradient_e18Function: t => string = "marketTreasurySplitGradient_e18"

let marketTreasurySplitGradient_e18CallCheck = (
  contract,
  {param0}: marketTreasurySplitGradient_e18Call,
) => {
  expect(
    contract->marketTreasurySplitGradient_e18Function,
  )->marketTreasurySplitGradient_e18CalledWith(param0)
}

@send @scope("marketTreasurySplitGradient_e18")
external mockMarketTreasurySplitGradient_e18ToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("marketTreasurySplitGradient_e18")
external mockMarketTreasurySplitGradient_e18ToRevertNoReason: t => unit = "reverts"

@send @scope("marketUpdateIndex")
external mockMarketUpdateIndexToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type marketUpdateIndexCall = {param0: int}

let marketUpdateIndexOld: t => array<marketUpdateIndexCall> = _r => {
  let array = %raw("_r.marketUpdateIndex.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external marketUpdateIndexCalledWith: (expectation, int) => unit = "calledWith"

@get external marketUpdateIndexFunction: t => string = "marketUpdateIndex"

let marketUpdateIndexCallCheck = (contract, {param0}: marketUpdateIndexCall) => {
  expect(contract->marketUpdateIndexFunction)->marketUpdateIndexCalledWith(param0)
}

@send @scope("marketUpdateIndex")
external mockMarketUpdateIndexToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("marketUpdateIndex")
external mockMarketUpdateIndexToRevertNoReason: t => unit = "reverts"

type mintLongNextPriceCall = {
  marketIndex: int,
  amount: Ethers.BigNumber.t,
}

let mintLongNextPriceOld: t => array<mintLongNextPriceCall> = _r => {
  let array = %raw("_r.mintLongNextPrice.calls")
  array->Array.map(((marketIndex, amount)) => {
    {
      marketIndex: marketIndex,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external mintLongNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t) => unit = "calledWith"

@get external mintLongNextPriceFunction: t => string = "mintLongNextPrice"

let mintLongNextPriceCallCheck = (contract, {marketIndex, amount}: mintLongNextPriceCall) => {
  expect(contract->mintLongNextPriceFunction)->mintLongNextPriceCalledWith(marketIndex, amount)
}

@send @scope("mintLongNextPrice")
external mockMintLongNextPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("mintLongNextPrice")
external mockMintLongNextPriceToRevertNoReason: t => unit = "reverts"

type mintShortNextPriceCall = {
  marketIndex: int,
  amount: Ethers.BigNumber.t,
}

let mintShortNextPriceOld: t => array<mintShortNextPriceCall> = _r => {
  let array = %raw("_r.mintShortNextPrice.calls")
  array->Array.map(((marketIndex, amount)) => {
    {
      marketIndex: marketIndex,
      amount: amount,
    }
  })
}

@send @scope(("to", "have", "been"))
external mintShortNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t) => unit = "calledWith"

@get external mintShortNextPriceFunction: t => string = "mintShortNextPrice"

let mintShortNextPriceCallCheck = (contract, {marketIndex, amount}: mintShortNextPriceCall) => {
  expect(contract->mintShortNextPriceFunction)->mintShortNextPriceCalledWith(marketIndex, amount)
}

@send @scope("mintShortNextPrice")
external mockMintShortNextPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("mintShortNextPrice")
external mockMintShortNextPriceToRevertNoReason: t => unit = "reverts"

@send @scope("oracleManagers")
external mockOracleManagersToReturn: (t, Ethers.ethAddress) => unit = "returns"

type oracleManagersCall = {param0: int}

let oracleManagersOld: t => array<oracleManagersCall> = _r => {
  let array = %raw("_r.oracleManagers.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external oracleManagersCalledWith: (expectation, int) => unit = "calledWith"

@get external oracleManagersFunction: t => string = "oracleManagers"

let oracleManagersCallCheck = (contract, {param0}: oracleManagersCall) => {
  expect(contract->oracleManagersFunction)->oracleManagersCalledWith(param0)
}

@send @scope("oracleManagers")
external mockOracleManagersToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("oracleManagers")
external mockOracleManagersToRevertNoReason: t => unit = "reverts"

@send @scope("paymentTokens")
external mockPaymentTokensToReturn: (t, Ethers.ethAddress) => unit = "returns"

type paymentTokensCall = {param0: int}

let paymentTokensOld: t => array<paymentTokensCall> = _r => {
  let array = %raw("_r.paymentTokens.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external paymentTokensCalledWith: (expectation, int) => unit = "calledWith"

@get external paymentTokensFunction: t => string = "paymentTokens"

let paymentTokensCallCheck = (contract, {param0}: paymentTokensCall) => {
  expect(contract->paymentTokensFunction)->paymentTokensCalledWith(param0)
}

@send @scope("paymentTokens")
external mockPaymentTokensToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("paymentTokens")
external mockPaymentTokensToRevertNoReason: t => unit = "reverts"

type redeemLongNextPriceCall = {
  marketIndex: int,
  tokens_redeem: Ethers.BigNumber.t,
}

let redeemLongNextPriceOld: t => array<redeemLongNextPriceCall> = _r => {
  let array = %raw("_r.redeemLongNextPrice.calls")
  array->Array.map(((marketIndex, tokens_redeem)) => {
    {
      marketIndex: marketIndex,
      tokens_redeem: tokens_redeem,
    }
  })
}

@send @scope(("to", "have", "been"))
external redeemLongNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external redeemLongNextPriceFunction: t => string = "redeemLongNextPrice"

let redeemLongNextPriceCallCheck = (
  contract,
  {marketIndex, tokens_redeem}: redeemLongNextPriceCall,
) => {
  expect(contract->redeemLongNextPriceFunction)->redeemLongNextPriceCalledWith(
    marketIndex,
    tokens_redeem,
  )
}

@send @scope("redeemLongNextPrice")
external mockRedeemLongNextPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("redeemLongNextPrice")
external mockRedeemLongNextPriceToRevertNoReason: t => unit = "reverts"

type redeemShortNextPriceCall = {
  marketIndex: int,
  tokens_redeem: Ethers.BigNumber.t,
}

let redeemShortNextPriceOld: t => array<redeemShortNextPriceCall> = _r => {
  let array = %raw("_r.redeemShortNextPrice.calls")
  array->Array.map(((marketIndex, tokens_redeem)) => {
    {
      marketIndex: marketIndex,
      tokens_redeem: tokens_redeem,
    }
  })
}

@send @scope(("to", "have", "been"))
external redeemShortNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external redeemShortNextPriceFunction: t => string = "redeemShortNextPrice"

let redeemShortNextPriceCallCheck = (
  contract,
  {marketIndex, tokens_redeem}: redeemShortNextPriceCall,
) => {
  expect(contract->redeemShortNextPriceFunction)->redeemShortNextPriceCalledWith(
    marketIndex,
    tokens_redeem,
  )
}

@send @scope("redeemShortNextPrice")
external mockRedeemShortNextPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("redeemShortNextPrice")
external mockRedeemShortNextPriceToRevertNoReason: t => unit = "reverts"

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

type shiftPositionFromLongNextPriceCall = {
  marketIndex: int,
  amountSyntheticTokensToShift: Ethers.BigNumber.t,
}

let shiftPositionFromLongNextPriceOld: t => array<shiftPositionFromLongNextPriceCall> = _r => {
  let array = %raw("_r.shiftPositionFromLongNextPrice.calls")
  array->Array.map(((marketIndex, amountSyntheticTokensToShift)) => {
    {
      marketIndex: marketIndex,
      amountSyntheticTokensToShift: amountSyntheticTokensToShift,
    }
  })
}

@send @scope(("to", "have", "been"))
external shiftPositionFromLongNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t) => unit =
  "calledWith"

@get external shiftPositionFromLongNextPriceFunction: t => string = "shiftPositionFromLongNextPrice"

let shiftPositionFromLongNextPriceCallCheck = (
  contract,
  {marketIndex, amountSyntheticTokensToShift}: shiftPositionFromLongNextPriceCall,
) => {
  expect(
    contract->shiftPositionFromLongNextPriceFunction,
  )->shiftPositionFromLongNextPriceCalledWith(marketIndex, amountSyntheticTokensToShift)
}

@send @scope("shiftPositionFromLongNextPrice")
external mockShiftPositionFromLongNextPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("shiftPositionFromLongNextPrice")
external mockShiftPositionFromLongNextPriceToRevertNoReason: t => unit = "reverts"

type shiftPositionFromShortNextPriceCall = {
  marketIndex: int,
  amountSyntheticTokensToShift: Ethers.BigNumber.t,
}

let shiftPositionFromShortNextPriceOld: t => array<shiftPositionFromShortNextPriceCall> = _r => {
  let array = %raw("_r.shiftPositionFromShortNextPrice.calls")
  array->Array.map(((marketIndex, amountSyntheticTokensToShift)) => {
    {
      marketIndex: marketIndex,
      amountSyntheticTokensToShift: amountSyntheticTokensToShift,
    }
  })
}

@send @scope(("to", "have", "been"))
external shiftPositionFromShortNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t) => unit =
  "calledWith"

@get
external shiftPositionFromShortNextPriceFunction: t => string = "shiftPositionFromShortNextPrice"

let shiftPositionFromShortNextPriceCallCheck = (
  contract,
  {marketIndex, amountSyntheticTokensToShift}: shiftPositionFromShortNextPriceCall,
) => {
  expect(
    contract->shiftPositionFromShortNextPriceFunction,
  )->shiftPositionFromShortNextPriceCalledWith(marketIndex, amountSyntheticTokensToShift)
}

@send @scope("shiftPositionFromShortNextPrice")
external mockShiftPositionFromShortNextPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("shiftPositionFromShortNextPrice")
external mockShiftPositionFromShortNextPriceToRevertNoReason: t => unit = "reverts"

type shiftPositionNextPriceCall = {
  marketIndex: int,
  amountSyntheticTokensToShift: Ethers.BigNumber.t,
  isShiftFromLong: bool,
}

let shiftPositionNextPriceOld: t => array<shiftPositionNextPriceCall> = _r => {
  let array = %raw("_r.shiftPositionNextPrice.calls")
  array->Array.map(((marketIndex, amountSyntheticTokensToShift, isShiftFromLong)) => {
    {
      marketIndex: marketIndex,
      amountSyntheticTokensToShift: amountSyntheticTokensToShift,
      isShiftFromLong: isShiftFromLong,
    }
  })
}

@send @scope(("to", "have", "been"))
external shiftPositionNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t, bool) => unit =
  "calledWith"

@get external shiftPositionNextPriceFunction: t => string = "shiftPositionNextPrice"

let shiftPositionNextPriceCallCheck = (
  contract,
  {marketIndex, amountSyntheticTokensToShift, isShiftFromLong}: shiftPositionNextPriceCall,
) => {
  expect(contract->shiftPositionNextPriceFunction)->shiftPositionNextPriceCalledWith(
    marketIndex,
    amountSyntheticTokensToShift,
    isShiftFromLong,
  )
}

@send @scope("shiftPositionNextPrice")
external mockShiftPositionNextPriceToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("shiftPositionNextPrice")
external mockShiftPositionNextPriceToRevertNoReason: t => unit = "reverts"

@send @scope("staker")
external mockStakerToReturn: (t, Ethers.ethAddress) => unit = "returns"

type stakerCall

let stakerOld: t => array<stakerCall> = _r => {
  let array = %raw("_r.staker.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external stakerCalledWith: expectation => unit = "calledWith"

@get external stakerFunction: t => string = "staker"

let stakerCallCheck = contract => {
  expect(contract->stakerFunction)->stakerCalledWith
}

@send @scope("staker")
external mockStakerToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("staker")
external mockStakerToRevertNoReason: t => unit = "reverts"

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

@send @scope("syntheticToken_priceSnapshot")
external mockSyntheticToken_priceSnapshotToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type syntheticToken_priceSnapshotCall = {
  param0: int,
  param1: bool,
  param2: Ethers.BigNumber.t,
}

let syntheticToken_priceSnapshotOld: t => array<syntheticToken_priceSnapshotCall> = _r => {
  let array = %raw("_r.syntheticToken_priceSnapshot.calls")
  array->Array.map(((param0, param1, param2)) => {
    {
      param0: param0,
      param1: param1,
      param2: param2,
    }
  })
}

@send @scope(("to", "have", "been"))
external syntheticToken_priceSnapshotCalledWith: (
  expectation,
  int,
  bool,
  Ethers.BigNumber.t,
) => unit = "calledWith"

@get external syntheticToken_priceSnapshotFunction: t => string = "syntheticToken_priceSnapshot"

let syntheticToken_priceSnapshotCallCheck = (
  contract,
  {param0, param1, param2}: syntheticToken_priceSnapshotCall,
) => {
  expect(contract->syntheticToken_priceSnapshotFunction)->syntheticToken_priceSnapshotCalledWith(
    param0,
    param1,
    param2,
  )
}

@send @scope("syntheticToken_priceSnapshot")
external mockSyntheticToken_priceSnapshotToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("syntheticToken_priceSnapshot")
external mockSyntheticToken_priceSnapshotToRevertNoReason: t => unit = "reverts"

@send @scope("syntheticTokens")
external mockSyntheticTokensToReturn: (t, Ethers.ethAddress) => unit = "returns"

type syntheticTokensCall = {
  param0: int,
  param1: bool,
}

let syntheticTokensOld: t => array<syntheticTokensCall> = _r => {
  let array = %raw("_r.syntheticTokens.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external syntheticTokensCalledWith: (expectation, int, bool) => unit = "calledWith"

@get external syntheticTokensFunction: t => string = "syntheticTokens"

let syntheticTokensCallCheck = (contract, {param0, param1}: syntheticTokensCall) => {
  expect(contract->syntheticTokensFunction)->syntheticTokensCalledWith(param0, param1)
}

@send @scope("syntheticTokens")
external mockSyntheticTokensToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("syntheticTokens")
external mockSyntheticTokensToRevertNoReason: t => unit = "reverts"

@send @scope("tokenFactory")
external mockTokenFactoryToReturn: (t, Ethers.ethAddress) => unit = "returns"

type tokenFactoryCall

let tokenFactoryOld: t => array<tokenFactoryCall> = _r => {
  let array = %raw("_r.tokenFactory.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

@send @scope(("to", "have", "been"))
external tokenFactoryCalledWith: expectation => unit = "calledWith"

@get external tokenFactoryFunction: t => string = "tokenFactory"

let tokenFactoryCallCheck = contract => {
  expect(contract->tokenFactoryFunction)->tokenFactoryCalledWith
}

@send @scope("tokenFactory")
external mockTokenFactoryToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("tokenFactory")
external mockTokenFactoryToRevertNoReason: t => unit = "reverts"

type updateMarketOracleCall = {
  marketIndex: int,
  newOracleManager: Ethers.ethAddress,
}

let updateMarketOracleOld: t => array<updateMarketOracleCall> = _r => {
  let array = %raw("_r.updateMarketOracle.calls")
  array->Array.map(((marketIndex, newOracleManager)) => {
    {
      marketIndex: marketIndex,
      newOracleManager: newOracleManager,
    }
  })
}

@send @scope(("to", "have", "been"))
external updateMarketOracleCalledWith: (expectation, int, Ethers.ethAddress) => unit = "calledWith"

@get external updateMarketOracleFunction: t => string = "updateMarketOracle"

let updateMarketOracleCallCheck = (
  contract,
  {marketIndex, newOracleManager}: updateMarketOracleCall,
) => {
  expect(contract->updateMarketOracleFunction)->updateMarketOracleCalledWith(
    marketIndex,
    newOracleManager,
  )
}

@send @scope("updateMarketOracle")
external mockUpdateMarketOracleToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("updateMarketOracle")
external mockUpdateMarketOracleToRevertNoReason: t => unit = "reverts"

type updateSystemStateCall = {marketIndex: int}

let updateSystemStateOld: t => array<updateSystemStateCall> = _r => {
  let array = %raw("_r.updateSystemState.calls")
  array->Array.map(_m => {
    let marketIndex = _m->Array.getUnsafe(0)

    {
      marketIndex: marketIndex,
    }
  })
}

@send @scope(("to", "have", "been"))
external updateSystemStateCalledWith: (expectation, int) => unit = "calledWith"

@get external updateSystemStateFunction: t => string = "updateSystemState"

let updateSystemStateCallCheck = (contract, {marketIndex}: updateSystemStateCall) => {
  expect(contract->updateSystemStateFunction)->updateSystemStateCalledWith(marketIndex)
}

@send @scope("updateSystemState")
external mockUpdateSystemStateToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("updateSystemState")
external mockUpdateSystemStateToRevertNoReason: t => unit = "reverts"

type updateSystemStateMultiCall = {marketIndexes: array<int>}

let updateSystemStateMultiOld: t => array<updateSystemStateMultiCall> = _r => {
  let array = %raw("_r.updateSystemStateMulti.calls")
  array->Array.map(_m => {
    let marketIndexes = _m->Array.getUnsafe(0)

    {
      marketIndexes: marketIndexes,
    }
  })
}

@send @scope(("to", "have", "been"))
external updateSystemStateMultiCalledWith: (expectation, array<int>) => unit = "calledWith"

@get external updateSystemStateMultiFunction: t => string = "updateSystemStateMulti"

let updateSystemStateMultiCallCheck = (contract, {marketIndexes}: updateSystemStateMultiCall) => {
  expect(contract->updateSystemStateMultiFunction)->updateSystemStateMultiCalledWith(marketIndexes)
}

@send @scope("updateSystemStateMulti")
external mockUpdateSystemStateMultiToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("updateSystemStateMulti")
external mockUpdateSystemStateMultiToRevertNoReason: t => unit = "reverts"

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

@send @scope("userNextPrice_currentUpdateIndex")
external mockUserNextPrice_currentUpdateIndexToReturn: (t, Ethers.BigNumber.t) => unit = "returns"

type userNextPrice_currentUpdateIndexCall = {
  param0: int,
  param1: Ethers.ethAddress,
}

let userNextPrice_currentUpdateIndexOld: t => array<userNextPrice_currentUpdateIndexCall> = _r => {
  let array = %raw("_r.userNextPrice_currentUpdateIndex.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

@send @scope(("to", "have", "been"))
external userNextPrice_currentUpdateIndexCalledWith: (expectation, int, Ethers.ethAddress) => unit =
  "calledWith"

@get
external userNextPrice_currentUpdateIndexFunction: t => string = "userNextPrice_currentUpdateIndex"

let userNextPrice_currentUpdateIndexCallCheck = (
  contract,
  {param0, param1}: userNextPrice_currentUpdateIndexCall,
) => {
  expect(
    contract->userNextPrice_currentUpdateIndexFunction,
  )->userNextPrice_currentUpdateIndexCalledWith(param0, param1)
}

@send @scope("userNextPrice_currentUpdateIndex")
external mockUserNextPrice_currentUpdateIndexToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("userNextPrice_currentUpdateIndex")
external mockUserNextPrice_currentUpdateIndexToRevertNoReason: t => unit = "reverts"

@send @scope("userNextPrice_paymentToken_depositAmount")
external mockUserNextPrice_paymentToken_depositAmountToReturn: (t, Ethers.BigNumber.t) => unit =
  "returns"

type userNextPrice_paymentToken_depositAmountCall = {
  param0: int,
  param1: bool,
  param2: Ethers.ethAddress,
}

let userNextPrice_paymentToken_depositAmountOld: t => array<
  userNextPrice_paymentToken_depositAmountCall,
> = _r => {
  let array = %raw("_r.userNextPrice_paymentToken_depositAmount.calls")
  array->Array.map(((param0, param1, param2)) => {
    {
      param0: param0,
      param1: param1,
      param2: param2,
    }
  })
}

@send @scope(("to", "have", "been"))
external userNextPrice_paymentToken_depositAmountCalledWith: (
  expectation,
  int,
  bool,
  Ethers.ethAddress,
) => unit = "calledWith"

@get
external userNextPrice_paymentToken_depositAmountFunction: t => string =
  "userNextPrice_paymentToken_depositAmount"

let userNextPrice_paymentToken_depositAmountCallCheck = (
  contract,
  {param0, param1, param2}: userNextPrice_paymentToken_depositAmountCall,
) => {
  expect(
    contract->userNextPrice_paymentToken_depositAmountFunction,
  )->userNextPrice_paymentToken_depositAmountCalledWith(param0, param1, param2)
}

@send @scope("userNextPrice_paymentToken_depositAmount")
external mockUserNextPrice_paymentToken_depositAmountToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("userNextPrice_paymentToken_depositAmount")
external mockUserNextPrice_paymentToken_depositAmountToRevertNoReason: t => unit = "reverts"

@send @scope("userNextPrice_syntheticToken_redeemAmount")
external mockUserNextPrice_syntheticToken_redeemAmountToReturn: (t, Ethers.BigNumber.t) => unit =
  "returns"

type userNextPrice_syntheticToken_redeemAmountCall = {
  param0: int,
  param1: bool,
  param2: Ethers.ethAddress,
}

let userNextPrice_syntheticToken_redeemAmountOld: t => array<
  userNextPrice_syntheticToken_redeemAmountCall,
> = _r => {
  let array = %raw("_r.userNextPrice_syntheticToken_redeemAmount.calls")
  array->Array.map(((param0, param1, param2)) => {
    {
      param0: param0,
      param1: param1,
      param2: param2,
    }
  })
}

@send @scope(("to", "have", "been"))
external userNextPrice_syntheticToken_redeemAmountCalledWith: (
  expectation,
  int,
  bool,
  Ethers.ethAddress,
) => unit = "calledWith"

@get
external userNextPrice_syntheticToken_redeemAmountFunction: t => string =
  "userNextPrice_syntheticToken_redeemAmount"

let userNextPrice_syntheticToken_redeemAmountCallCheck = (
  contract,
  {param0, param1, param2}: userNextPrice_syntheticToken_redeemAmountCall,
) => {
  expect(
    contract->userNextPrice_syntheticToken_redeemAmountFunction,
  )->userNextPrice_syntheticToken_redeemAmountCalledWith(param0, param1, param2)
}

@send @scope("userNextPrice_syntheticToken_redeemAmount")
external mockUserNextPrice_syntheticToken_redeemAmountToRevert: (t, ~errorString: string) => unit =
  "returns"

@send @scope("userNextPrice_syntheticToken_redeemAmount")
external mockUserNextPrice_syntheticToken_redeemAmountToRevertNoReason: t => unit = "reverts"

@send @scope("userNextPrice_syntheticToken_toShiftAwayFrom_marketSide")
external mockUserNextPrice_syntheticToken_toShiftAwayFrom_marketSideToReturn: (
  t,
  Ethers.BigNumber.t,
) => unit = "returns"

type userNextPrice_syntheticToken_toShiftAwayFrom_marketSideCall = {
  param0: int,
  param1: bool,
  param2: Ethers.ethAddress,
}

let userNextPrice_syntheticToken_toShiftAwayFrom_marketSideOld: t => array<
  userNextPrice_syntheticToken_toShiftAwayFrom_marketSideCall,
> = _r => {
  let array = %raw("_r.userNextPrice_syntheticToken_toShiftAwayFrom_marketSide.calls")
  array->Array.map(((param0, param1, param2)) => {
    {
      param0: param0,
      param1: param1,
      param2: param2,
    }
  })
}

@send @scope(("to", "have", "been"))
external userNextPrice_syntheticToken_toShiftAwayFrom_marketSideCalledWith: (
  expectation,
  int,
  bool,
  Ethers.ethAddress,
) => unit = "calledWith"

@get
external userNextPrice_syntheticToken_toShiftAwayFrom_marketSideFunction: t => string =
  "userNextPrice_syntheticToken_toShiftAwayFrom_marketSide"

let userNextPrice_syntheticToken_toShiftAwayFrom_marketSideCallCheck = (
  contract,
  {param0, param1, param2}: userNextPrice_syntheticToken_toShiftAwayFrom_marketSideCall,
) => {
  expect(
    contract->userNextPrice_syntheticToken_toShiftAwayFrom_marketSideFunction,
  )->userNextPrice_syntheticToken_toShiftAwayFrom_marketSideCalledWith(param0, param1, param2)
}

@send @scope("userNextPrice_syntheticToken_toShiftAwayFrom_marketSide")
external mockUserNextPrice_syntheticToken_toShiftAwayFrom_marketSideToRevert: (
  t,
  ~errorString: string,
) => unit = "returns"

@send @scope("userNextPrice_syntheticToken_toShiftAwayFrom_marketSide")
external mockUserNextPrice_syntheticToken_toShiftAwayFrom_marketSideToRevertNoReason: t => unit =
  "reverts"

@send @scope("yieldManagers")
external mockYieldManagersToReturn: (t, Ethers.ethAddress) => unit = "returns"

type yieldManagersCall = {param0: int}

let yieldManagersOld: t => array<yieldManagersCall> = _r => {
  let array = %raw("_r.yieldManagers.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

@send @scope(("to", "have", "been"))
external yieldManagersCalledWith: (expectation, int) => unit = "calledWith"

@get external yieldManagersFunction: t => string = "yieldManagers"

let yieldManagersCallCheck = (contract, {param0}: yieldManagersCall) => {
  expect(contract->yieldManagersFunction)->yieldManagersCalledWith(param0)
}

@send @scope("yieldManagers")
external mockYieldManagersToRevert: (t, ~errorString: string) => unit = "returns"

@send @scope("yieldManagers")
external mockYieldManagersToRevertNoReason: t => unit = "reverts"

module InternalMock = {
  let mockContractName = "LongShortForInternalMocking"
  type t = {address: Ethers.ethAddress}

  let internalRef: ref<option<t>> = ref(None)

  let functionToNotMock: ref<string> = ref("")

  @module("@defi-wonderland/smock") @scope("smock")
  external smock: string => Js.Promise.t<t> = "fake"

  let setup: LongShort.t => JsPromise.t<ContractHelpers.transaction> = contract => {
    smock(mockContractName)->JsPromise.then(b => {
      internalRef := Some(b)
      contract->LongShort.Exposed.setMocker(~mocker=(b->Obj.magic).address)
    })
  }

  let setFunctionForUnitTesting = (contract, ~functionName) => {
    functionToNotMock := functionName
    contract->LongShort.Exposed.setFunctionToNotMock(~functionToNotMock=functionName)
  }

  let setupFunctionForUnitTesting = (contract, ~functionName) => {
    smock(mockContractName)->JsPromise.then(b => {
      internalRef := Some(b)
      [
        contract->LongShort.Exposed.setMocker(~mocker=(b->Obj.magic).address),
        contract->LongShort.Exposed.setFunctionToNotMock(~functionToNotMock=functionName),
      ]->JsPromise.all
    })
  }

  exception MockingAFunctionThatYouShouldntBe

  exception HaventSetupInternalMockingForLongShort

  let checkForExceptions = (~functionName) => {
    if functionToNotMock.contents == functionName {
      raise(MockingAFunctionThatYouShouldntBe)
    }
    if internalRef.contents == None {
      raise(HaventSetupInternalMockingForLongShort)
    }
  }

  type adminOnlyModifierLogicCall

  @send @scope(("to", "have", "been"))
  external adminOnlyModifierLogicCalledWith: expectation => unit = "calledWith"

  @get
  external adminOnlyModifierLogicFunctionFromInstance: t => string = "adminOnlyModifierLogicMock"

  let adminOnlyModifierLogicFunction = () => {
    checkForExceptions(~functionName="adminOnlyModifierLogic")
    internalRef.contents->Option.map(contract => {
      contract->adminOnlyModifierLogicFunctionFromInstance
    })
  }

  let adminOnlyModifierLogicCallCheck = () =>
    expect(adminOnlyModifierLogicFunction())->adminOnlyModifierLogicCalledWith

  @send @scope("adminOnlyModifierLogicMock")
  external adminOnlyModifierLogicMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("adminOnlyModifierLogicMock")
  external adminOnlyModifierLogicMockRevertNoReasonRaw: t => unit = "reverts"

  let mockAdminOnlyModifierLogicToRevert = (~errorString) => {
    checkForExceptions(~functionName="adminOnlyModifierLogic")
    let _ = internalRef.contents->Option.map(adminOnlyModifierLogicMockRevertRaw(~errorString))
  }
  let mockAdminOnlyModifierLogicToRevertNoReason = () => {
    checkForExceptions(~functionName="adminOnlyModifierLogic")
    let _ = internalRef.contents->Option.map(adminOnlyModifierLogicMockRevertNoReasonRaw)
  }

  type requireMarketExistsModifierLogicCall = {marketIndex: int}

  @send @scope(("to", "have", "been"))
  external requireMarketExistsModifierLogicCalledWith: (expectation, int) => unit = "calledWith"

  @get
  external requireMarketExistsModifierLogicFunctionFromInstance: t => string =
    "requireMarketExistsModifierLogicMock"

  let requireMarketExistsModifierLogicFunction = () => {
    checkForExceptions(~functionName="requireMarketExistsModifierLogic")
    internalRef.contents->Option.map(contract => {
      contract->requireMarketExistsModifierLogicFunctionFromInstance
    })
  }

  let requireMarketExistsModifierLogicCallCheck = (
    {marketIndex}: requireMarketExistsModifierLogicCall,
  ) =>
    expect(requireMarketExistsModifierLogicFunction())->requireMarketExistsModifierLogicCalledWith(
      marketIndex,
    )

  @send @scope("requireMarketExistsModifierLogicMock")
  external requireMarketExistsModifierLogicMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("requireMarketExistsModifierLogicMock")
  external requireMarketExistsModifierLogicMockRevertNoReasonRaw: t => unit = "reverts"

  let mockRequireMarketExistsModifierLogicToRevert = (~errorString) => {
    checkForExceptions(~functionName="requireMarketExistsModifierLogic")
    let _ =
      internalRef.contents->Option.map(requireMarketExistsModifierLogicMockRevertRaw(~errorString))
  }
  let mockRequireMarketExistsModifierLogicToRevertNoReason = () => {
    checkForExceptions(~functionName="requireMarketExistsModifierLogic")
    let _ = internalRef.contents->Option.map(requireMarketExistsModifierLogicMockRevertNoReasonRaw)
  }

  type initializeCall = {
    admin: Ethers.ethAddress,
    tokenFactory: Ethers.ethAddress,
    staker: Ethers.ethAddress,
  }

  @send @scope(("to", "have", "been"))
  external initializeCalledWith: (
    expectation,
    Ethers.ethAddress,
    Ethers.ethAddress,
    Ethers.ethAddress,
  ) => unit = "calledWith"

  @get external initializeFunctionFromInstance: t => string = "initializeMock"

  let initializeFunction = () => {
    checkForExceptions(~functionName="initialize")
    internalRef.contents->Option.map(contract => {
      contract->initializeFunctionFromInstance
    })
  }

  let initializeCallCheck = ({admin, tokenFactory, staker}: initializeCall) =>
    expect(initializeFunction())->initializeCalledWith(admin, tokenFactory, staker)

  @send @scope("initializeMock")
  external initializeMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("initializeMock")
  external initializeMockRevertNoReasonRaw: t => unit = "reverts"

  let mockInitializeToRevert = (~errorString) => {
    checkForExceptions(~functionName="initialize")
    let _ = internalRef.contents->Option.map(initializeMockRevertRaw(~errorString))
  }
  let mockInitializeToRevertNoReason = () => {
    checkForExceptions(~functionName="initialize")
    let _ = internalRef.contents->Option.map(initializeMockRevertNoReasonRaw)
  }

  type _seedMarketInitiallyCall = {
    initialMarketSeedForEachMarketSide: Ethers.BigNumber.t,
    marketIndex: int,
  }

  @send @scope(("to", "have", "been"))
  external _seedMarketInitiallyCalledWith: (expectation, Ethers.BigNumber.t, int) => unit =
    "calledWith"

  @get external _seedMarketInitiallyFunctionFromInstance: t => string = "_seedMarketInitiallyMock"

  let _seedMarketInitiallyFunction = () => {
    checkForExceptions(~functionName="_seedMarketInitially")
    internalRef.contents->Option.map(contract => {
      contract->_seedMarketInitiallyFunctionFromInstance
    })
  }

  let _seedMarketInitiallyCallCheck = (
    {initialMarketSeedForEachMarketSide, marketIndex}: _seedMarketInitiallyCall,
  ) =>
    expect(_seedMarketInitiallyFunction())->_seedMarketInitiallyCalledWith(
      initialMarketSeedForEachMarketSide,
      marketIndex,
    )

  @send @scope("_seedMarketInitiallyMock")
  external _seedMarketInitiallyMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_seedMarketInitiallyMock")
  external _seedMarketInitiallyMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_seedMarketInitiallyToRevert = (~errorString) => {
    checkForExceptions(~functionName="_seedMarketInitially")
    let _ = internalRef.contents->Option.map(_seedMarketInitiallyMockRevertRaw(~errorString))
  }
  let mock_seedMarketInitiallyToRevertNoReason = () => {
    checkForExceptions(~functionName="_seedMarketInitially")
    let _ = internalRef.contents->Option.map(_seedMarketInitiallyMockRevertNoReasonRaw)
  }

  @send @scope("_getSyntheticTokenPriceMock")
  external _getSyntheticTokenPriceMockReturnRaw: (t, Ethers.BigNumber.t) => unit = "returns"

  let mock_getSyntheticTokenPriceToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getSyntheticTokenPrice")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_getSyntheticTokenPriceMockReturnRaw(_param0)
      )
  }

  type _getSyntheticTokenPriceCall = {
    amountPaymentTokenBackingSynth: Ethers.BigNumber.t,
    amountSyntheticToken: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _getSyntheticTokenPriceCalledWith: (
    expectation,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _getSyntheticTokenPriceFunctionFromInstance: t => string = "_getSyntheticTokenPriceMock"

  let _getSyntheticTokenPriceFunction = () => {
    checkForExceptions(~functionName="_getSyntheticTokenPrice")
    internalRef.contents->Option.map(contract => {
      contract->_getSyntheticTokenPriceFunctionFromInstance
    })
  }

  let _getSyntheticTokenPriceCallCheck = (
    {amountPaymentTokenBackingSynth, amountSyntheticToken}: _getSyntheticTokenPriceCall,
  ) =>
    expect(_getSyntheticTokenPriceFunction())->_getSyntheticTokenPriceCalledWith(
      amountPaymentTokenBackingSynth,
      amountSyntheticToken,
    )

  @send @scope("_getSyntheticTokenPriceMock")
  external _getSyntheticTokenPriceMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_getSyntheticTokenPriceMock")
  external _getSyntheticTokenPriceMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_getSyntheticTokenPriceToRevert = (~errorString) => {
    checkForExceptions(~functionName="_getSyntheticTokenPrice")
    let _ = internalRef.contents->Option.map(_getSyntheticTokenPriceMockRevertRaw(~errorString))
  }
  let mock_getSyntheticTokenPriceToRevertNoReason = () => {
    checkForExceptions(~functionName="_getSyntheticTokenPrice")
    let _ = internalRef.contents->Option.map(_getSyntheticTokenPriceMockRevertNoReasonRaw)
  }

  @send @scope("_getAmountPaymentTokenMock")
  external _getAmountPaymentTokenMockReturnRaw: (t, Ethers.BigNumber.t) => unit = "returns"

  let mock_getAmountPaymentTokenToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getAmountPaymentToken")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_getAmountPaymentTokenMockReturnRaw(_param0)
      )
  }

  type _getAmountPaymentTokenCall = {
    amountSyntheticToken: Ethers.BigNumber.t,
    syntheticTokenPriceInPaymentTokens: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _getAmountPaymentTokenCalledWith: (
    expectation,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _getAmountPaymentTokenFunctionFromInstance: t => string = "_getAmountPaymentTokenMock"

  let _getAmountPaymentTokenFunction = () => {
    checkForExceptions(~functionName="_getAmountPaymentToken")
    internalRef.contents->Option.map(contract => {
      contract->_getAmountPaymentTokenFunctionFromInstance
    })
  }

  let _getAmountPaymentTokenCallCheck = (
    {amountSyntheticToken, syntheticTokenPriceInPaymentTokens}: _getAmountPaymentTokenCall,
  ) =>
    expect(_getAmountPaymentTokenFunction())->_getAmountPaymentTokenCalledWith(
      amountSyntheticToken,
      syntheticTokenPriceInPaymentTokens,
    )

  @send @scope("_getAmountPaymentTokenMock")
  external _getAmountPaymentTokenMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_getAmountPaymentTokenMock")
  external _getAmountPaymentTokenMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_getAmountPaymentTokenToRevert = (~errorString) => {
    checkForExceptions(~functionName="_getAmountPaymentToken")
    let _ = internalRef.contents->Option.map(_getAmountPaymentTokenMockRevertRaw(~errorString))
  }
  let mock_getAmountPaymentTokenToRevertNoReason = () => {
    checkForExceptions(~functionName="_getAmountPaymentToken")
    let _ = internalRef.contents->Option.map(_getAmountPaymentTokenMockRevertNoReasonRaw)
  }

  @send @scope("_getAmountSyntheticTokenMock")
  external _getAmountSyntheticTokenMockReturnRaw: (t, Ethers.BigNumber.t) => unit = "returns"

  let mock_getAmountSyntheticTokenToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getAmountSyntheticToken")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_getAmountSyntheticTokenMockReturnRaw(_param0)
      )
  }

  type _getAmountSyntheticTokenCall = {
    amountPaymentTokenBackingSynth: Ethers.BigNumber.t,
    syntheticTokenPriceInPaymentTokens: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _getAmountSyntheticTokenCalledWith: (
    expectation,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _getAmountSyntheticTokenFunctionFromInstance: t => string =
    "_getAmountSyntheticTokenMock"

  let _getAmountSyntheticTokenFunction = () => {
    checkForExceptions(~functionName="_getAmountSyntheticToken")
    internalRef.contents->Option.map(contract => {
      contract->_getAmountSyntheticTokenFunctionFromInstance
    })
  }

  let _getAmountSyntheticTokenCallCheck = (
    {
      amountPaymentTokenBackingSynth,
      syntheticTokenPriceInPaymentTokens,
    }: _getAmountSyntheticTokenCall,
  ) =>
    expect(_getAmountSyntheticTokenFunction())->_getAmountSyntheticTokenCalledWith(
      amountPaymentTokenBackingSynth,
      syntheticTokenPriceInPaymentTokens,
    )

  @send @scope("_getAmountSyntheticTokenMock")
  external _getAmountSyntheticTokenMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_getAmountSyntheticTokenMock")
  external _getAmountSyntheticTokenMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_getAmountSyntheticTokenToRevert = (~errorString) => {
    checkForExceptions(~functionName="_getAmountSyntheticToken")
    let _ = internalRef.contents->Option.map(_getAmountSyntheticTokenMockRevertRaw(~errorString))
  }
  let mock_getAmountSyntheticTokenToRevertNoReason = () => {
    checkForExceptions(~functionName="_getAmountSyntheticToken")
    let _ = internalRef.contents->Option.map(_getAmountSyntheticTokenMockRevertNoReasonRaw)
  }

  @send @scope("_getEquivalentAmountSyntheticTokensOnTargetSideMock")
  external _getEquivalentAmountSyntheticTokensOnTargetSideMockReturnRaw: (
    t,
    Ethers.BigNumber.t,
  ) => unit = "returns"

  let mock_getEquivalentAmountSyntheticTokensOnTargetSideToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getEquivalentAmountSyntheticTokensOnTargetSide")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_getEquivalentAmountSyntheticTokensOnTargetSideMockReturnRaw(_param0)
      )
  }

  type _getEquivalentAmountSyntheticTokensOnTargetSideCall = {
    amountSyntheticTokens_originSide: Ethers.BigNumber.t,
    syntheticTokenPrice_originSide: Ethers.BigNumber.t,
    syntheticTokenPrice_targetSide: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _getEquivalentAmountSyntheticTokensOnTargetSideCalledWith: (
    expectation,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _getEquivalentAmountSyntheticTokensOnTargetSideFunctionFromInstance: t => string =
    "_getEquivalentAmountSyntheticTokensOnTargetSideMock"

  let _getEquivalentAmountSyntheticTokensOnTargetSideFunction = () => {
    checkForExceptions(~functionName="_getEquivalentAmountSyntheticTokensOnTargetSide")
    internalRef.contents->Option.map(contract => {
      contract->_getEquivalentAmountSyntheticTokensOnTargetSideFunctionFromInstance
    })
  }

  let _getEquivalentAmountSyntheticTokensOnTargetSideCallCheck = (
    {
      amountSyntheticTokens_originSide,
      syntheticTokenPrice_originSide,
      syntheticTokenPrice_targetSide,
    }: _getEquivalentAmountSyntheticTokensOnTargetSideCall,
  ) =>
    expect(
      _getEquivalentAmountSyntheticTokensOnTargetSideFunction(),
    )->_getEquivalentAmountSyntheticTokensOnTargetSideCalledWith(
      amountSyntheticTokens_originSide,
      syntheticTokenPrice_originSide,
      syntheticTokenPrice_targetSide,
    )

  @send @scope("_getEquivalentAmountSyntheticTokensOnTargetSideMock")
  external _getEquivalentAmountSyntheticTokensOnTargetSideMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_getEquivalentAmountSyntheticTokensOnTargetSideMock")
  external _getEquivalentAmountSyntheticTokensOnTargetSideMockRevertNoReasonRaw: t => unit =
    "reverts"

  let mock_getEquivalentAmountSyntheticTokensOnTargetSideToRevert = (~errorString) => {
    checkForExceptions(~functionName="_getEquivalentAmountSyntheticTokensOnTargetSide")
    let _ =
      internalRef.contents->Option.map(
        _getEquivalentAmountSyntheticTokensOnTargetSideMockRevertRaw(~errorString),
      )
  }
  let mock_getEquivalentAmountSyntheticTokensOnTargetSideToRevertNoReason = () => {
    checkForExceptions(~functionName="_getEquivalentAmountSyntheticTokensOnTargetSide")
    let _ =
      internalRef.contents->Option.map(
        _getEquivalentAmountSyntheticTokensOnTargetSideMockRevertNoReasonRaw,
      )
  }

  @send @scope("getAmountSyntheticTokenToMintOnTargetSideMock")
  external getAmountSyntheticTokenToMintOnTargetSideMockReturnRaw: (t, Ethers.BigNumber.t) => unit =
    "returns"

  let mockGetAmountSyntheticTokenToMintOnTargetSideToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="getAmountSyntheticTokenToMintOnTargetSide")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->getAmountSyntheticTokenToMintOnTargetSideMockReturnRaw(_param0)
      )
  }

  type getAmountSyntheticTokenToMintOnTargetSideCall = {
    marketIndex: int,
    amountSyntheticToken_redeemOnOriginSide: Ethers.BigNumber.t,
    isShiftFromLong: bool,
    priceSnapshotIndex: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external getAmountSyntheticTokenToMintOnTargetSideCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
    bool,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external getAmountSyntheticTokenToMintOnTargetSideFunctionFromInstance: t => string =
    "getAmountSyntheticTokenToMintOnTargetSideMock"

  let getAmountSyntheticTokenToMintOnTargetSideFunction = () => {
    checkForExceptions(~functionName="getAmountSyntheticTokenToMintOnTargetSide")
    internalRef.contents->Option.map(contract => {
      contract->getAmountSyntheticTokenToMintOnTargetSideFunctionFromInstance
    })
  }

  let getAmountSyntheticTokenToMintOnTargetSideCallCheck = (
    {
      marketIndex,
      amountSyntheticToken_redeemOnOriginSide,
      isShiftFromLong,
      priceSnapshotIndex,
    }: getAmountSyntheticTokenToMintOnTargetSideCall,
  ) =>
    expect(
      getAmountSyntheticTokenToMintOnTargetSideFunction(),
    )->getAmountSyntheticTokenToMintOnTargetSideCalledWith(
      marketIndex,
      amountSyntheticToken_redeemOnOriginSide,
      isShiftFromLong,
      priceSnapshotIndex,
    )

  @send @scope("getAmountSyntheticTokenToMintOnTargetSideMock")
  external getAmountSyntheticTokenToMintOnTargetSideMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("getAmountSyntheticTokenToMintOnTargetSideMock")
  external getAmountSyntheticTokenToMintOnTargetSideMockRevertNoReasonRaw: t => unit = "reverts"

  let mockGetAmountSyntheticTokenToMintOnTargetSideToRevert = (~errorString) => {
    checkForExceptions(~functionName="getAmountSyntheticTokenToMintOnTargetSide")
    let _ =
      internalRef.contents->Option.map(
        getAmountSyntheticTokenToMintOnTargetSideMockRevertRaw(~errorString),
      )
  }
  let mockGetAmountSyntheticTokenToMintOnTargetSideToRevertNoReason = () => {
    checkForExceptions(~functionName="getAmountSyntheticTokenToMintOnTargetSide")
    let _ =
      internalRef.contents->Option.map(
        getAmountSyntheticTokenToMintOnTargetSideMockRevertNoReasonRaw,
      )
  }

  @send @scope("getUsersConfirmedButNotSettledSynthBalanceMock")
  external getUsersConfirmedButNotSettledSynthBalanceMockReturnRaw: (
    t,
    Ethers.BigNumber.t,
  ) => unit = "returns"

  let mockGetUsersConfirmedButNotSettledSynthBalanceToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="getUsersConfirmedButNotSettledSynthBalance")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->getUsersConfirmedButNotSettledSynthBalanceMockReturnRaw(_param0)
      )
  }

  type getUsersConfirmedButNotSettledSynthBalanceCall = {
    user: Ethers.ethAddress,
    marketIndex: int,
    isLong: bool,
  }

  @send @scope(("to", "have", "been"))
  external getUsersConfirmedButNotSettledSynthBalanceCalledWith: (
    expectation,
    Ethers.ethAddress,
    int,
    bool,
  ) => unit = "calledWith"

  @get
  external getUsersConfirmedButNotSettledSynthBalanceFunctionFromInstance: t => string =
    "getUsersConfirmedButNotSettledSynthBalanceMock"

  let getUsersConfirmedButNotSettledSynthBalanceFunction = () => {
    checkForExceptions(~functionName="getUsersConfirmedButNotSettledSynthBalance")
    internalRef.contents->Option.map(contract => {
      contract->getUsersConfirmedButNotSettledSynthBalanceFunctionFromInstance
    })
  }

  let getUsersConfirmedButNotSettledSynthBalanceCallCheck = (
    {user, marketIndex, isLong}: getUsersConfirmedButNotSettledSynthBalanceCall,
  ) =>
    expect(
      getUsersConfirmedButNotSettledSynthBalanceFunction(),
    )->getUsersConfirmedButNotSettledSynthBalanceCalledWith(user, marketIndex, isLong)

  @send @scope("getUsersConfirmedButNotSettledSynthBalanceMock")
  external getUsersConfirmedButNotSettledSynthBalanceMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("getUsersConfirmedButNotSettledSynthBalanceMock")
  external getUsersConfirmedButNotSettledSynthBalanceMockRevertNoReasonRaw: t => unit = "reverts"

  let mockGetUsersConfirmedButNotSettledSynthBalanceToRevert = (~errorString) => {
    checkForExceptions(~functionName="getUsersConfirmedButNotSettledSynthBalance")
    let _ =
      internalRef.contents->Option.map(
        getUsersConfirmedButNotSettledSynthBalanceMockRevertRaw(~errorString),
      )
  }
  let mockGetUsersConfirmedButNotSettledSynthBalanceToRevertNoReason = () => {
    checkForExceptions(~functionName="getUsersConfirmedButNotSettledSynthBalance")
    let _ =
      internalRef.contents->Option.map(
        getUsersConfirmedButNotSettledSynthBalanceMockRevertNoReasonRaw,
      )
  }

  @send @scope("_getYieldSplitMock")
  external _getYieldSplitMockReturnRaw: (t, (bool, Ethers.BigNumber.t)) => unit = "returns"

  let mock_getYieldSplitToReturn: (bool, Ethers.BigNumber.t) => unit = (_param0, _param1) => {
    checkForExceptions(~functionName="_getYieldSplit")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_getYieldSplitMockReturnRaw((_param0, _param1))
      )
  }

  type _getYieldSplitCall = {
    marketIndex: int,
    longValue: Ethers.BigNumber.t,
    shortValue: Ethers.BigNumber.t,
    totalValueLockedInMarket: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _getYieldSplitCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get external _getYieldSplitFunctionFromInstance: t => string = "_getYieldSplitMock"

  let _getYieldSplitFunction = () => {
    checkForExceptions(~functionName="_getYieldSplit")
    internalRef.contents->Option.map(contract => {
      contract->_getYieldSplitFunctionFromInstance
    })
  }

  let _getYieldSplitCallCheck = (
    {marketIndex, longValue, shortValue, totalValueLockedInMarket}: _getYieldSplitCall,
  ) =>
    expect(_getYieldSplitFunction())->_getYieldSplitCalledWith(
      marketIndex,
      longValue,
      shortValue,
      totalValueLockedInMarket,
    )

  @send @scope("_getYieldSplitMock")
  external _getYieldSplitMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_getYieldSplitMock")
  external _getYieldSplitMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_getYieldSplitToRevert = (~errorString) => {
    checkForExceptions(~functionName="_getYieldSplit")
    let _ = internalRef.contents->Option.map(_getYieldSplitMockRevertRaw(~errorString))
  }
  let mock_getYieldSplitToRevertNoReason = () => {
    checkForExceptions(~functionName="_getYieldSplit")
    let _ = internalRef.contents->Option.map(_getYieldSplitMockRevertNoReasonRaw)
  }

  @send @scope("_claimAndDistributeYieldThenRebalanceMarketMock")
  external _claimAndDistributeYieldThenRebalanceMarketMockReturnRaw: (
    t,
    (Ethers.BigNumber.t, Ethers.BigNumber.t),
  ) => unit = "returns"

  let mock_claimAndDistributeYieldThenRebalanceMarketToReturn: (
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = (_param0, _param1) => {
    checkForExceptions(~functionName="_claimAndDistributeYieldThenRebalanceMarket")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_claimAndDistributeYieldThenRebalanceMarketMockReturnRaw((
          _param0,
          _param1,
        ))
      )
  }

  type _claimAndDistributeYieldThenRebalanceMarketCall = {
    marketIndex: int,
    newAssetPrice: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _claimAndDistributeYieldThenRebalanceMarketCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _claimAndDistributeYieldThenRebalanceMarketFunctionFromInstance: t => string =
    "_claimAndDistributeYieldThenRebalanceMarketMock"

  let _claimAndDistributeYieldThenRebalanceMarketFunction = () => {
    checkForExceptions(~functionName="_claimAndDistributeYieldThenRebalanceMarket")
    internalRef.contents->Option.map(contract => {
      contract->_claimAndDistributeYieldThenRebalanceMarketFunctionFromInstance
    })
  }

  let _claimAndDistributeYieldThenRebalanceMarketCallCheck = (
    {marketIndex, newAssetPrice}: _claimAndDistributeYieldThenRebalanceMarketCall,
  ) =>
    expect(
      _claimAndDistributeYieldThenRebalanceMarketFunction(),
    )->_claimAndDistributeYieldThenRebalanceMarketCalledWith(marketIndex, newAssetPrice)

  @send @scope("_claimAndDistributeYieldThenRebalanceMarketMock")
  external _claimAndDistributeYieldThenRebalanceMarketMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_claimAndDistributeYieldThenRebalanceMarketMock")
  external _claimAndDistributeYieldThenRebalanceMarketMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_claimAndDistributeYieldThenRebalanceMarketToRevert = (~errorString) => {
    checkForExceptions(~functionName="_claimAndDistributeYieldThenRebalanceMarket")
    let _ =
      internalRef.contents->Option.map(
        _claimAndDistributeYieldThenRebalanceMarketMockRevertRaw(~errorString),
      )
  }
  let mock_claimAndDistributeYieldThenRebalanceMarketToRevertNoReason = () => {
    checkForExceptions(~functionName="_claimAndDistributeYieldThenRebalanceMarket")
    let _ =
      internalRef.contents->Option.map(
        _claimAndDistributeYieldThenRebalanceMarketMockRevertNoReasonRaw,
      )
  }

  type _updateSystemStateInternalCall = {marketIndex: int}

  @send @scope(("to", "have", "been"))
  external _updateSystemStateInternalCalledWith: (expectation, int) => unit = "calledWith"

  @get
  external _updateSystemStateInternalFunctionFromInstance: t => string =
    "_updateSystemStateInternalMock"

  let _updateSystemStateInternalFunction = () => {
    checkForExceptions(~functionName="_updateSystemStateInternal")
    internalRef.contents->Option.map(contract => {
      contract->_updateSystemStateInternalFunctionFromInstance
    })
  }

  let _updateSystemStateInternalCallCheck = ({marketIndex}: _updateSystemStateInternalCall) =>
    expect(_updateSystemStateInternalFunction())->_updateSystemStateInternalCalledWith(marketIndex)

  @send @scope("_updateSystemStateInternalMock")
  external _updateSystemStateInternalMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_updateSystemStateInternalMock")
  external _updateSystemStateInternalMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_updateSystemStateInternalToRevert = (~errorString) => {
    checkForExceptions(~functionName="_updateSystemStateInternal")
    let _ = internalRef.contents->Option.map(_updateSystemStateInternalMockRevertRaw(~errorString))
  }
  let mock_updateSystemStateInternalToRevertNoReason = () => {
    checkForExceptions(~functionName="_updateSystemStateInternal")
    let _ = internalRef.contents->Option.map(_updateSystemStateInternalMockRevertNoReasonRaw)
  }

  type _transferPaymentTokensFromUserToYieldManagerCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _transferPaymentTokensFromUserToYieldManagerCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _transferPaymentTokensFromUserToYieldManagerFunctionFromInstance: t => string =
    "_transferPaymentTokensFromUserToYieldManagerMock"

  let _transferPaymentTokensFromUserToYieldManagerFunction = () => {
    checkForExceptions(~functionName="_transferPaymentTokensFromUserToYieldManager")
    internalRef.contents->Option.map(contract => {
      contract->_transferPaymentTokensFromUserToYieldManagerFunctionFromInstance
    })
  }

  let _transferPaymentTokensFromUserToYieldManagerCallCheck = (
    {marketIndex, amount}: _transferPaymentTokensFromUserToYieldManagerCall,
  ) =>
    expect(
      _transferPaymentTokensFromUserToYieldManagerFunction(),
    )->_transferPaymentTokensFromUserToYieldManagerCalledWith(marketIndex, amount)

  @send @scope("_transferPaymentTokensFromUserToYieldManagerMock")
  external _transferPaymentTokensFromUserToYieldManagerMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_transferPaymentTokensFromUserToYieldManagerMock")
  external _transferPaymentTokensFromUserToYieldManagerMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_transferPaymentTokensFromUserToYieldManagerToRevert = (~errorString) => {
    checkForExceptions(~functionName="_transferPaymentTokensFromUserToYieldManager")
    let _ =
      internalRef.contents->Option.map(
        _transferPaymentTokensFromUserToYieldManagerMockRevertRaw(~errorString),
      )
  }
  let mock_transferPaymentTokensFromUserToYieldManagerToRevertNoReason = () => {
    checkForExceptions(~functionName="_transferPaymentTokensFromUserToYieldManager")
    let _ =
      internalRef.contents->Option.map(
        _transferPaymentTokensFromUserToYieldManagerMockRevertNoReasonRaw,
      )
  }

  type _mintNextPriceCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
    isLong: bool,
  }

  @send @scope(("to", "have", "been"))
  external _mintNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t, bool) => unit =
    "calledWith"

  @get external _mintNextPriceFunctionFromInstance: t => string = "_mintNextPriceMock"

  let _mintNextPriceFunction = () => {
    checkForExceptions(~functionName="_mintNextPrice")
    internalRef.contents->Option.map(contract => {
      contract->_mintNextPriceFunctionFromInstance
    })
  }

  let _mintNextPriceCallCheck = ({marketIndex, amount, isLong}: _mintNextPriceCall) =>
    expect(_mintNextPriceFunction())->_mintNextPriceCalledWith(marketIndex, amount, isLong)

  @send @scope("_mintNextPriceMock")
  external _mintNextPriceMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_mintNextPriceMock")
  external _mintNextPriceMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_mintNextPriceToRevert = (~errorString) => {
    checkForExceptions(~functionName="_mintNextPrice")
    let _ = internalRef.contents->Option.map(_mintNextPriceMockRevertRaw(~errorString))
  }
  let mock_mintNextPriceToRevertNoReason = () => {
    checkForExceptions(~functionName="_mintNextPrice")
    let _ = internalRef.contents->Option.map(_mintNextPriceMockRevertNoReasonRaw)
  }

  type _redeemNextPriceCall = {
    marketIndex: int,
    tokens_redeem: Ethers.BigNumber.t,
    isLong: bool,
  }

  @send @scope(("to", "have", "been"))
  external _redeemNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t, bool) => unit =
    "calledWith"

  @get external _redeemNextPriceFunctionFromInstance: t => string = "_redeemNextPriceMock"

  let _redeemNextPriceFunction = () => {
    checkForExceptions(~functionName="_redeemNextPrice")
    internalRef.contents->Option.map(contract => {
      contract->_redeemNextPriceFunctionFromInstance
    })
  }

  let _redeemNextPriceCallCheck = ({marketIndex, tokens_redeem, isLong}: _redeemNextPriceCall) =>
    expect(_redeemNextPriceFunction())->_redeemNextPriceCalledWith(
      marketIndex,
      tokens_redeem,
      isLong,
    )

  @send @scope("_redeemNextPriceMock")
  external _redeemNextPriceMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("_redeemNextPriceMock")
  external _redeemNextPriceMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_redeemNextPriceToRevert = (~errorString) => {
    checkForExceptions(~functionName="_redeemNextPrice")
    let _ = internalRef.contents->Option.map(_redeemNextPriceMockRevertRaw(~errorString))
  }
  let mock_redeemNextPriceToRevertNoReason = () => {
    checkForExceptions(~functionName="_redeemNextPrice")
    let _ = internalRef.contents->Option.map(_redeemNextPriceMockRevertNoReasonRaw)
  }

  type shiftPositionNextPriceCall = {
    marketIndex: int,
    amountSyntheticTokensToShift: Ethers.BigNumber.t,
    isShiftFromLong: bool,
  }

  @send @scope(("to", "have", "been"))
  external shiftPositionNextPriceCalledWith: (expectation, int, Ethers.BigNumber.t, bool) => unit =
    "calledWith"

  @get
  external shiftPositionNextPriceFunctionFromInstance: t => string = "shiftPositionNextPriceMock"

  let shiftPositionNextPriceFunction = () => {
    checkForExceptions(~functionName="shiftPositionNextPrice")
    internalRef.contents->Option.map(contract => {
      contract->shiftPositionNextPriceFunctionFromInstance
    })
  }

  let shiftPositionNextPriceCallCheck = (
    {marketIndex, amountSyntheticTokensToShift, isShiftFromLong}: shiftPositionNextPriceCall,
  ) =>
    expect(shiftPositionNextPriceFunction())->shiftPositionNextPriceCalledWith(
      marketIndex,
      amountSyntheticTokensToShift,
      isShiftFromLong,
    )

  @send @scope("shiftPositionNextPriceMock")
  external shiftPositionNextPriceMockRevertRaw: (t, ~errorString: string) => unit = "reverts"

  @send @scope("shiftPositionNextPriceMock")
  external shiftPositionNextPriceMockRevertNoReasonRaw: t => unit = "reverts"

  let mockShiftPositionNextPriceToRevert = (~errorString) => {
    checkForExceptions(~functionName="shiftPositionNextPrice")
    let _ = internalRef.contents->Option.map(shiftPositionNextPriceMockRevertRaw(~errorString))
  }
  let mockShiftPositionNextPriceToRevertNoReason = () => {
    checkForExceptions(~functionName="shiftPositionNextPrice")
    let _ = internalRef.contents->Option.map(shiftPositionNextPriceMockRevertNoReasonRaw)
  }

  type _executeOutstandingNextPriceMintsCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
    isLong: bool,
  }

  @send @scope(("to", "have", "been"))
  external _executeOutstandingNextPriceMintsCalledWith: (
    expectation,
    int,
    Ethers.ethAddress,
    bool,
  ) => unit = "calledWith"

  @get
  external _executeOutstandingNextPriceMintsFunctionFromInstance: t => string =
    "_executeOutstandingNextPriceMintsMock"

  let _executeOutstandingNextPriceMintsFunction = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceMints")
    internalRef.contents->Option.map(contract => {
      contract->_executeOutstandingNextPriceMintsFunctionFromInstance
    })
  }

  let _executeOutstandingNextPriceMintsCallCheck = (
    {marketIndex, user, isLong}: _executeOutstandingNextPriceMintsCall,
  ) =>
    expect(
      _executeOutstandingNextPriceMintsFunction(),
    )->_executeOutstandingNextPriceMintsCalledWith(marketIndex, user, isLong)

  @send @scope("_executeOutstandingNextPriceMintsMock")
  external _executeOutstandingNextPriceMintsMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("_executeOutstandingNextPriceMintsMock")
  external _executeOutstandingNextPriceMintsMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_executeOutstandingNextPriceMintsToRevert = (~errorString) => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceMints")
    let _ =
      internalRef.contents->Option.map(_executeOutstandingNextPriceMintsMockRevertRaw(~errorString))
  }
  let mock_executeOutstandingNextPriceMintsToRevertNoReason = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceMints")
    let _ = internalRef.contents->Option.map(_executeOutstandingNextPriceMintsMockRevertNoReasonRaw)
  }

  type _executeOutstandingNextPriceRedeemsCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
    isLong: bool,
  }

  @send @scope(("to", "have", "been"))
  external _executeOutstandingNextPriceRedeemsCalledWith: (
    expectation,
    int,
    Ethers.ethAddress,
    bool,
  ) => unit = "calledWith"

  @get
  external _executeOutstandingNextPriceRedeemsFunctionFromInstance: t => string =
    "_executeOutstandingNextPriceRedeemsMock"

  let _executeOutstandingNextPriceRedeemsFunction = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceRedeems")
    internalRef.contents->Option.map(contract => {
      contract->_executeOutstandingNextPriceRedeemsFunctionFromInstance
    })
  }

  let _executeOutstandingNextPriceRedeemsCallCheck = (
    {marketIndex, user, isLong}: _executeOutstandingNextPriceRedeemsCall,
  ) =>
    expect(
      _executeOutstandingNextPriceRedeemsFunction(),
    )->_executeOutstandingNextPriceRedeemsCalledWith(marketIndex, user, isLong)

  @send @scope("_executeOutstandingNextPriceRedeemsMock")
  external _executeOutstandingNextPriceRedeemsMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("_executeOutstandingNextPriceRedeemsMock")
  external _executeOutstandingNextPriceRedeemsMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_executeOutstandingNextPriceRedeemsToRevert = (~errorString) => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceRedeems")
    let _ =
      internalRef.contents->Option.map(
        _executeOutstandingNextPriceRedeemsMockRevertRaw(~errorString),
      )
  }
  let mock_executeOutstandingNextPriceRedeemsToRevertNoReason = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceRedeems")
    let _ =
      internalRef.contents->Option.map(_executeOutstandingNextPriceRedeemsMockRevertNoReasonRaw)
  }

  type _executeOutstandingNextPriceTokenShiftsCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
    isShiftFromLong: bool,
  }

  @send @scope(("to", "have", "been"))
  external _executeOutstandingNextPriceTokenShiftsCalledWith: (
    expectation,
    int,
    Ethers.ethAddress,
    bool,
  ) => unit = "calledWith"

  @get
  external _executeOutstandingNextPriceTokenShiftsFunctionFromInstance: t => string =
    "_executeOutstandingNextPriceTokenShiftsMock"

  let _executeOutstandingNextPriceTokenShiftsFunction = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceTokenShifts")
    internalRef.contents->Option.map(contract => {
      contract->_executeOutstandingNextPriceTokenShiftsFunctionFromInstance
    })
  }

  let _executeOutstandingNextPriceTokenShiftsCallCheck = (
    {marketIndex, user, isShiftFromLong}: _executeOutstandingNextPriceTokenShiftsCall,
  ) =>
    expect(
      _executeOutstandingNextPriceTokenShiftsFunction(),
    )->_executeOutstandingNextPriceTokenShiftsCalledWith(marketIndex, user, isShiftFromLong)

  @send @scope("_executeOutstandingNextPriceTokenShiftsMock")
  external _executeOutstandingNextPriceTokenShiftsMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("_executeOutstandingNextPriceTokenShiftsMock")
  external _executeOutstandingNextPriceTokenShiftsMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_executeOutstandingNextPriceTokenShiftsToRevert = (~errorString) => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceTokenShifts")
    let _ =
      internalRef.contents->Option.map(
        _executeOutstandingNextPriceTokenShiftsMockRevertRaw(~errorString),
      )
  }
  let mock_executeOutstandingNextPriceTokenShiftsToRevertNoReason = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceTokenShifts")
    let _ =
      internalRef.contents->Option.map(_executeOutstandingNextPriceTokenShiftsMockRevertNoReasonRaw)
  }

  type _executeOutstandingNextPriceSettlementsCall = {
    user: Ethers.ethAddress,
    marketIndex: int,
  }

  @send @scope(("to", "have", "been"))
  external _executeOutstandingNextPriceSettlementsCalledWith: (
    expectation,
    Ethers.ethAddress,
    int,
  ) => unit = "calledWith"

  @get
  external _executeOutstandingNextPriceSettlementsFunctionFromInstance: t => string =
    "_executeOutstandingNextPriceSettlementsMock"

  let _executeOutstandingNextPriceSettlementsFunction = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceSettlements")
    internalRef.contents->Option.map(contract => {
      contract->_executeOutstandingNextPriceSettlementsFunctionFromInstance
    })
  }

  let _executeOutstandingNextPriceSettlementsCallCheck = (
    {user, marketIndex}: _executeOutstandingNextPriceSettlementsCall,
  ) =>
    expect(
      _executeOutstandingNextPriceSettlementsFunction(),
    )->_executeOutstandingNextPriceSettlementsCalledWith(user, marketIndex)

  @send @scope("_executeOutstandingNextPriceSettlementsMock")
  external _executeOutstandingNextPriceSettlementsMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("_executeOutstandingNextPriceSettlementsMock")
  external _executeOutstandingNextPriceSettlementsMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_executeOutstandingNextPriceSettlementsToRevert = (~errorString) => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceSettlements")
    let _ =
      internalRef.contents->Option.map(
        _executeOutstandingNextPriceSettlementsMockRevertRaw(~errorString),
      )
  }
  let mock_executeOutstandingNextPriceSettlementsToRevertNoReason = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceSettlements")
    let _ =
      internalRef.contents->Option.map(_executeOutstandingNextPriceSettlementsMockRevertNoReasonRaw)
  }

  type _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerCall = {
    marketIndex: int,
    totalPaymentTokenValueChangeForMarket: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerFunctionFromInstance: t => string =
    "_handleTotalPaymentTokenValueChangeForMarketWithYieldManagerMock"

  let _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerFunction = () => {
    checkForExceptions(~functionName="_handleTotalPaymentTokenValueChangeForMarketWithYieldManager")
    internalRef.contents->Option.map(contract => {
      contract->_handleTotalPaymentTokenValueChangeForMarketWithYieldManagerFunctionFromInstance
    })
  }

  let _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerCallCheck = (
    {
      marketIndex,
      totalPaymentTokenValueChangeForMarket,
    }: _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerCall,
  ) =>
    expect(
      _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerFunction(),
    )->_handleTotalPaymentTokenValueChangeForMarketWithYieldManagerCalledWith(
      marketIndex,
      totalPaymentTokenValueChangeForMarket,
    )

  @send @scope("_handleTotalPaymentTokenValueChangeForMarketWithYieldManagerMock")
  external _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_handleTotalPaymentTokenValueChangeForMarketWithYieldManagerMock")
  external _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerMockRevertNoReasonRaw: t => unit =
    "reverts"

  let mock_handleTotalPaymentTokenValueChangeForMarketWithYieldManagerToRevert = (~errorString) => {
    checkForExceptions(~functionName="_handleTotalPaymentTokenValueChangeForMarketWithYieldManager")
    let _ =
      internalRef.contents->Option.map(
        _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerMockRevertRaw(~errorString),
      )
  }
  let mock_handleTotalPaymentTokenValueChangeForMarketWithYieldManagerToRevertNoReason = () => {
    checkForExceptions(~functionName="_handleTotalPaymentTokenValueChangeForMarketWithYieldManager")
    let _ =
      internalRef.contents->Option.map(
        _handleTotalPaymentTokenValueChangeForMarketWithYieldManagerMockRevertNoReasonRaw,
      )
  }

  type _handleChangeInSyntheticTokensTotalSupplyCall = {
    marketIndex: int,
    isLong: bool,
    changeInSyntheticTokensTotalSupply: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _handleChangeInSyntheticTokensTotalSupplyCalledWith: (
    expectation,
    int,
    bool,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _handleChangeInSyntheticTokensTotalSupplyFunctionFromInstance: t => string =
    "_handleChangeInSyntheticTokensTotalSupplyMock"

  let _handleChangeInSyntheticTokensTotalSupplyFunction = () => {
    checkForExceptions(~functionName="_handleChangeInSyntheticTokensTotalSupply")
    internalRef.contents->Option.map(contract => {
      contract->_handleChangeInSyntheticTokensTotalSupplyFunctionFromInstance
    })
  }

  let _handleChangeInSyntheticTokensTotalSupplyCallCheck = (
    {
      marketIndex,
      isLong,
      changeInSyntheticTokensTotalSupply,
    }: _handleChangeInSyntheticTokensTotalSupplyCall,
  ) =>
    expect(
      _handleChangeInSyntheticTokensTotalSupplyFunction(),
    )->_handleChangeInSyntheticTokensTotalSupplyCalledWith(
      marketIndex,
      isLong,
      changeInSyntheticTokensTotalSupply,
    )

  @send @scope("_handleChangeInSyntheticTokensTotalSupplyMock")
  external _handleChangeInSyntheticTokensTotalSupplyMockRevertRaw: (
    t,
    ~errorString: string,
  ) => unit = "reverts"

  @send @scope("_handleChangeInSyntheticTokensTotalSupplyMock")
  external _handleChangeInSyntheticTokensTotalSupplyMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_handleChangeInSyntheticTokensTotalSupplyToRevert = (~errorString) => {
    checkForExceptions(~functionName="_handleChangeInSyntheticTokensTotalSupply")
    let _ =
      internalRef.contents->Option.map(
        _handleChangeInSyntheticTokensTotalSupplyMockRevertRaw(~errorString),
      )
  }
  let mock_handleChangeInSyntheticTokensTotalSupplyToRevertNoReason = () => {
    checkForExceptions(~functionName="_handleChangeInSyntheticTokensTotalSupply")
    let _ =
      internalRef.contents->Option.map(
        _handleChangeInSyntheticTokensTotalSupplyMockRevertNoReasonRaw,
      )
  }

  @send @scope("_batchConfirmOutstandingPendingActionsMock")
  external _batchConfirmOutstandingPendingActionsMockReturnRaw: (
    t,
    (Ethers.BigNumber.t, Ethers.BigNumber.t),
  ) => unit = "returns"

  let mock_batchConfirmOutstandingPendingActionsToReturn: (
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = (_param0, _param1) => {
    checkForExceptions(~functionName="_batchConfirmOutstandingPendingActions")
    let _ =
      internalRef.contents->Option.map(smockedContract =>
        smockedContract->_batchConfirmOutstandingPendingActionsMockReturnRaw((_param0, _param1))
      )
  }

  type _batchConfirmOutstandingPendingActionsCall = {
    marketIndex: int,
    syntheticTokenPrice_inPaymentTokens_long: Ethers.BigNumber.t,
    syntheticTokenPrice_inPaymentTokens_short: Ethers.BigNumber.t,
  }

  @send @scope(("to", "have", "been"))
  external _batchConfirmOutstandingPendingActionsCalledWith: (
    expectation,
    int,
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = "calledWith"

  @get
  external _batchConfirmOutstandingPendingActionsFunctionFromInstance: t => string =
    "_batchConfirmOutstandingPendingActionsMock"

  let _batchConfirmOutstandingPendingActionsFunction = () => {
    checkForExceptions(~functionName="_batchConfirmOutstandingPendingActions")
    internalRef.contents->Option.map(contract => {
      contract->_batchConfirmOutstandingPendingActionsFunctionFromInstance
    })
  }

  let _batchConfirmOutstandingPendingActionsCallCheck = (
    {
      marketIndex,
      syntheticTokenPrice_inPaymentTokens_long,
      syntheticTokenPrice_inPaymentTokens_short,
    }: _batchConfirmOutstandingPendingActionsCall,
  ) =>
    expect(
      _batchConfirmOutstandingPendingActionsFunction(),
    )->_batchConfirmOutstandingPendingActionsCalledWith(
      marketIndex,
      syntheticTokenPrice_inPaymentTokens_long,
      syntheticTokenPrice_inPaymentTokens_short,
    )

  @send @scope("_batchConfirmOutstandingPendingActionsMock")
  external _batchConfirmOutstandingPendingActionsMockRevertRaw: (t, ~errorString: string) => unit =
    "reverts"

  @send @scope("_batchConfirmOutstandingPendingActionsMock")
  external _batchConfirmOutstandingPendingActionsMockRevertNoReasonRaw: t => unit = "reverts"

  let mock_batchConfirmOutstandingPendingActionsToRevert = (~errorString) => {
    checkForExceptions(~functionName="_batchConfirmOutstandingPendingActions")
    let _ =
      internalRef.contents->Option.map(
        _batchConfirmOutstandingPendingActionsMockRevertRaw(~errorString),
      )
  }
  let mock_batchConfirmOutstandingPendingActionsToRevertNoReason = () => {
    checkForExceptions(~functionName="_batchConfirmOutstandingPendingActions")
    let _ =
      internalRef.contents->Option.map(_batchConfirmOutstandingPendingActionsMockRevertNoReasonRaw)
  }
}
