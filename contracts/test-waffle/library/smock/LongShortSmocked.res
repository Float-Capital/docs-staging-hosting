type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: LongShort.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

let mockDEAD_ADDRESSToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.DEAD_ADDRESS.will.return.with([_param0])")
}

type dEAD_ADDRESSCall

let dEAD_ADDRESSCalls: t => array<dEAD_ADDRESSCall> = _r => {
  let array = %raw("_r.smocked.DEAD_ADDRESS.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

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

let mockTEN_TO_THE_18_SIGNEDToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.TEN_TO_THE_18_SIGNED.will.return.with([_param0])")
}

type tEN_TO_THE_18_SIGNEDCall

let tEN_TO_THE_18_SIGNEDCalls: t => array<tEN_TO_THE_18_SIGNEDCall> = _r => {
  let array = %raw("_r.smocked.TEN_TO_THE_18_SIGNED.calls")
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

let mockAssetPriceToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.assetPrice.will.return.with([_param0])")
}

type assetPriceCall = {param0: int}

let assetPriceCalls: t => array<assetPriceCall> = _r => {
  let array = %raw("_r.smocked.assetPrice.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

let mockBatchedAmountOfSynthTokensToRedeemToReturn: (t, Ethers.BigNumber.t) => unit = (
  _r,
  _param0,
) => {
  let _ = %raw("_r.smocked.batchedAmountOfSynthTokensToRedeem.will.return.with([_param0])")
}

type batchedAmountOfSynthTokensToRedeemCall = {
  param0: int,
  param1: bool,
}

let batchedAmountOfSynthTokensToRedeemCalls: t => array<
  batchedAmountOfSynthTokensToRedeemCall,
> = _r => {
  let array = %raw("_r.smocked.batchedAmountOfSynthTokensToRedeem.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

let mockBatchedAmountOfTokensToDepositToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.batchedAmountOfTokensToDeposit.will.return.with([_param0])")
}

type batchedAmountOfTokensToDepositCall = {
  param0: int,
  param1: bool,
}

let batchedAmountOfTokensToDepositCalls: t => array<batchedAmountOfTokensToDepositCall> = _r => {
  let array = %raw("_r.smocked.batchedAmountOfTokensToDeposit.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

let mockLatestMarketToReturn: (t, int) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.latestMarket.will.return.with([_param0])")
}

type latestMarketCall

let latestMarketCalls: t => array<latestMarketCall> = _r => {
  let array = %raw("_r.smocked.latestMarket.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockMarketExistsToReturn: (t, bool) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.marketExists.will.return.with([_param0])")
}

type marketExistsCall = {param0: int}

let marketExistsCalls: t => array<marketExistsCall> = _r => {
  let array = %raw("_r.smocked.marketExists.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

let mockMarketUpdateIndexToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.marketUpdateIndex.will.return.with([_param0])")
}

type marketUpdateIndexCall = {param0: int}

let marketUpdateIndexCalls: t => array<marketUpdateIndexCall> = _r => {
  let array = %raw("_r.smocked.marketUpdateIndex.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

let mockOracleManagersToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.oracleManagers.will.return.with([_param0])")
}

type oracleManagersCall = {param0: int}

let oracleManagersCalls: t => array<oracleManagersCall> = _r => {
  let array = %raw("_r.smocked.oracleManagers.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

let mockPaymentTokensToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.paymentTokens.will.return.with([_param0])")
}

type paymentTokensCall = {param0: int}

let paymentTokensCalls: t => array<paymentTokensCall> = _r => {
  let array = %raw("_r.smocked.paymentTokens.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

let mockStakerToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.staker.will.return.with([_param0])")
}

type stakerCall

let stakerCalls: t => array<stakerCall> = _r => {
  let array = %raw("_r.smocked.staker.calls")
  array->Array.map(() => {
    ()->Obj.magic
  })
}

let mockSyntheticTokenPoolValueToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.syntheticTokenPoolValue.will.return.with([_param0])")
}

type syntheticTokenPoolValueCall = {
  param0: int,
  param1: bool,
}

let syntheticTokenPoolValueCalls: t => array<syntheticTokenPoolValueCall> = _r => {
  let array = %raw("_r.smocked.syntheticTokenPoolValue.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

let mockSyntheticTokenPriceSnapshotToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.syntheticTokenPriceSnapshot.will.return.with([_param0])")
}

type syntheticTokenPriceSnapshotCall = {
  param0: int,
  param1: bool,
  param2: Ethers.BigNumber.t,
}

let syntheticTokenPriceSnapshotCalls: t => array<syntheticTokenPriceSnapshotCall> = _r => {
  let array = %raw("_r.smocked.syntheticTokenPriceSnapshot.calls")
  array->Array.map(((param0, param1, param2)) => {
    {
      param0: param0,
      param1: param1,
      param2: param2,
    }
  })
}

let mockSyntheticTokensToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.syntheticTokens.will.return.with([_param0])")
}

type syntheticTokensCall = {
  param0: int,
  param1: bool,
}

let syntheticTokensCalls: t => array<syntheticTokensCall> = _r => {
  let array = %raw("_r.smocked.syntheticTokens.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

let mockTokenFactoryToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.tokenFactory.will.return.with([_param0])")
}

type tokenFactoryCall

let tokenFactoryCalls: t => array<tokenFactoryCall> = _r => {
  let array = %raw("_r.smocked.tokenFactory.calls")
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

let mockUserCurrentNextPriceUpdateIndexToReturn: (t, Ethers.BigNumber.t) => unit = (
  _r,
  _param0,
) => {
  let _ = %raw("_r.smocked.userCurrentNextPriceUpdateIndex.will.return.with([_param0])")
}

type userCurrentNextPriceUpdateIndexCall = {
  param0: int,
  param1: Ethers.ethAddress,
}

let userCurrentNextPriceUpdateIndexCalls: t => array<userCurrentNextPriceUpdateIndexCall> = _r => {
  let array = %raw("_r.smocked.userCurrentNextPriceUpdateIndex.calls")
  array->Array.map(((param0, param1)) => {
    {
      param0: param0,
      param1: param1,
    }
  })
}

let mockUserNextPriceDepositAmountToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.userNextPriceDepositAmount.will.return.with([_param0])")
}

type userNextPriceDepositAmountCall = {
  param0: int,
  param1: bool,
  param2: Ethers.ethAddress,
}

let userNextPriceDepositAmountCalls: t => array<userNextPriceDepositAmountCall> = _r => {
  let array = %raw("_r.smocked.userNextPriceDepositAmount.calls")
  array->Array.map(((param0, param1, param2)) => {
    {
      param0: param0,
      param1: param1,
      param2: param2,
    }
  })
}

let mockUserNextPriceRedemptionAmountToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.userNextPriceRedemptionAmount.will.return.with([_param0])")
}

type userNextPriceRedemptionAmountCall = {
  param0: int,
  param1: bool,
  param2: Ethers.ethAddress,
}

let userNextPriceRedemptionAmountCalls: t => array<userNextPriceRedemptionAmountCall> = _r => {
  let array = %raw("_r.smocked.userNextPriceRedemptionAmount.calls")
  array->Array.map(((param0, param1, param2)) => {
    {
      param0: param0,
      param1: param1,
      param2: param2,
    }
  })
}

let mockYieldManagersToReturn: (t, Ethers.ethAddress) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.yieldManagers.will.return.with([_param0])")
}

type yieldManagersCall = {param0: int}

let yieldManagersCalls: t => array<yieldManagersCall> = _r => {
  let array = %raw("_r.smocked.yieldManagers.calls")
  array->Array.map(_m => {
    let param0 = _m->Array.getUnsafe(0)

    {
      param0: param0,
    }
  })
}

let mockInitializeToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.initialize.will.return()")
}

type initializeCall = {
  admin: Ethers.ethAddress,
  treasury: Ethers.ethAddress,
  tokenFactory: Ethers.ethAddress,
  staker: Ethers.ethAddress,
}

let initializeCalls: t => array<initializeCall> = _r => {
  let array = %raw("_r.smocked.initialize.calls")
  array->Array.map(((admin, treasury, tokenFactory, staker)) => {
    {
      admin: admin,
      treasury: treasury,
      tokenFactory: tokenFactory,
      staker: staker,
    }
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

let mockChangeTreasuryToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.changeTreasury.will.return()")
}

type changeTreasuryCall = {treasury: Ethers.ethAddress}

let changeTreasuryCalls: t => array<changeTreasuryCall> = _r => {
  let array = %raw("_r.smocked.changeTreasury.calls")
  array->Array.map(_m => {
    let treasury = _m->Array.getUnsafe(0)

    {
      treasury: treasury,
    }
  })
}

let mockUpdateMarketOracleToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.updateMarketOracle.will.return()")
}

type updateMarketOracleCall = {
  marketIndex: int,
  newOracleManager: Ethers.ethAddress,
}

let updateMarketOracleCalls: t => array<updateMarketOracleCall> = _r => {
  let array = %raw("_r.smocked.updateMarketOracle.calls")
  array->Array.map(((marketIndex, newOracleManager)) => {
    {
      marketIndex: marketIndex,
      newOracleManager: newOracleManager,
    }
  })
}

let mockNewSyntheticMarketToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.newSyntheticMarket.will.return()")
}

type newSyntheticMarketCall = {
  syntheticName: string,
  syntheticSymbol: string,
  paymentToken: Ethers.ethAddress,
  oracleManager: Ethers.ethAddress,
  yieldManager: Ethers.ethAddress,
}

let newSyntheticMarketCalls: t => array<newSyntheticMarketCall> = _r => {
  let array = %raw("_r.smocked.newSyntheticMarket.calls")
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

let mockInitializeMarketToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.initializeMarket.will.return()")
}

type initializeMarketCall = {
  marketIndex: int,
  kInitialMultiplier: Ethers.BigNumber.t,
  kPeriod: Ethers.BigNumber.t,
  unstakeFeeBasisPoints: Ethers.BigNumber.t,
  initialMarketSeed: Ethers.BigNumber.t,
}

let initializeMarketCalls: t => array<initializeMarketCall> = _r => {
  let array = %raw("_r.smocked.initializeMarket.calls")
  array->Array.map(((
    marketIndex,
    kInitialMultiplier,
    kPeriod,
    unstakeFeeBasisPoints,
    initialMarketSeed,
  )) => {
    {
      marketIndex: marketIndex,
      kInitialMultiplier: kInitialMultiplier,
      kPeriod: kPeriod,
      unstakeFeeBasisPoints: unstakeFeeBasisPoints,
      initialMarketSeed: initialMarketSeed,
    }
  })
}

let mockGetUsersConfirmedButNotSettledBalanceToReturn: (t, Ethers.BigNumber.t) => unit = (
  _r,
  _param0,
) => {
  let _ = %raw("_r.smocked.getUsersConfirmedButNotSettledBalance.will.return.with([_param0])")
}

type getUsersConfirmedButNotSettledBalanceCall = {
  user: Ethers.ethAddress,
  marketIndex: int,
  isLong: bool,
}

let getUsersConfirmedButNotSettledBalanceCalls: t => array<
  getUsersConfirmedButNotSettledBalanceCall,
> = _r => {
  let array = %raw("_r.smocked.getUsersConfirmedButNotSettledBalance.calls")
  array->Array.map(((user, marketIndex, isLong)) => {
    {
      user: user,
      marketIndex: marketIndex,
      isLong: isLong,
    }
  })
}

let mockUpdateSystemStateToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.updateSystemState.will.return()")
}

type updateSystemStateCall = {marketIndex: int}

let updateSystemStateCalls: t => array<updateSystemStateCall> = _r => {
  let array = %raw("_r.smocked.updateSystemState.calls")
  array->Array.map(_m => {
    let marketIndex = _m->Array.getUnsafe(0)

    {
      marketIndex: marketIndex,
    }
  })
}

let mockUpdateSystemStateMultiToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.updateSystemStateMulti.will.return()")
}

type updateSystemStateMultiCall = {marketIndexes: array<int>}

let updateSystemStateMultiCalls: t => array<updateSystemStateMultiCall> = _r => {
  let array = %raw("_r.smocked.updateSystemStateMulti.calls")
  array->Array.map(_m => {
    let marketIndexes = _m->Array.getUnsafe(0)

    {
      marketIndexes: marketIndexes,
    }
  })
}

let mockMintLongNextPriceToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.mintLongNextPrice.will.return()")
}

type mintLongNextPriceCall = {
  marketIndex: int,
  amount: Ethers.BigNumber.t,
}

let mintLongNextPriceCalls: t => array<mintLongNextPriceCall> = _r => {
  let array = %raw("_r.smocked.mintLongNextPrice.calls")
  array->Array.map(((marketIndex, amount)) => {
    {
      marketIndex: marketIndex,
      amount: amount,
    }
  })
}

let mockMintShortNextPriceToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.mintShortNextPrice.will.return()")
}

type mintShortNextPriceCall = {
  marketIndex: int,
  amount: Ethers.BigNumber.t,
}

let mintShortNextPriceCalls: t => array<mintShortNextPriceCall> = _r => {
  let array = %raw("_r.smocked.mintShortNextPrice.calls")
  array->Array.map(((marketIndex, amount)) => {
    {
      marketIndex: marketIndex,
      amount: amount,
    }
  })
}

let mockRedeemLongNextPriceToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.redeemLongNextPrice.will.return()")
}

type redeemLongNextPriceCall = {
  marketIndex: int,
  tokensToRedeem: Ethers.BigNumber.t,
}

let redeemLongNextPriceCalls: t => array<redeemLongNextPriceCall> = _r => {
  let array = %raw("_r.smocked.redeemLongNextPrice.calls")
  array->Array.map(((marketIndex, tokensToRedeem)) => {
    {
      marketIndex: marketIndex,
      tokensToRedeem: tokensToRedeem,
    }
  })
}

let mockRedeemShortNextPriceToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.redeemShortNextPrice.will.return()")
}

type redeemShortNextPriceCall = {
  marketIndex: int,
  tokensToRedeem: Ethers.BigNumber.t,
}

let redeemShortNextPriceCalls: t => array<redeemShortNextPriceCall> = _r => {
  let array = %raw("_r.smocked.redeemShortNextPrice.calls")
  array->Array.map(((marketIndex, tokensToRedeem)) => {
    {
      marketIndex: marketIndex,
      tokensToRedeem: tokensToRedeem,
    }
  })
}

let mockExecuteOutstandingNextPriceSettlementsUserToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.executeOutstandingNextPriceSettlementsUser.will.return()")
}

type executeOutstandingNextPriceSettlementsUserCall = {
  user: Ethers.ethAddress,
  marketIndex: int,
}

let executeOutstandingNextPriceSettlementsUserCalls: t => array<
  executeOutstandingNextPriceSettlementsUserCall,
> = _r => {
  let array = %raw("_r.smocked.executeOutstandingNextPriceSettlementsUser.calls")
  array->Array.map(((user, marketIndex)) => {
    {
      user: user,
      marketIndex: marketIndex,
    }
  })
}

module InternalMock = {
  let mockContractName = "LongShortForInternalMocking"
  type t = {address: Ethers.ethAddress}

  let internalRef: ref<option<t>> = ref(None)

  let functionToNotMock: ref<string> = ref("")

  @module("@eth-optimism/smock") external smock: 'a => Js.Promise.t<t> = "smockit"

  let setup: LongShort.t => JsPromise.t<ContractHelpers.transaction> = contract => {
    ContractHelpers.deployContract0(mockContractName)
    ->JsPromise.then(a => {
      smock(a)
    })
    ->JsPromise.then(b => {
      internalRef := Some(b)
      contract->LongShort.Exposed.setMocker(~mocker=(b->Obj.magic).address)
    })
  }

  let setFunctionForUnitTesting = (contract, ~functionName) => {
    functionToNotMock := functionName
    contract->LongShort.Exposed.setFunctionToNotMock(~functionToNotMock=functionName)
  }

  let setupFunctionForUnitTesting = (contract, ~functionName) => {
    ContractHelpers.deployContract0(mockContractName)
    ->JsPromise.then(a => {
      smock(a)
    })
    ->JsPromise.then(b => {
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

  let mockInitializeToReturn: unit => unit = () => {
    checkForExceptions(~functionName="initialize")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.initializeMock.will.return()")
    })
  }

  type initializeCall = {
    admin: Ethers.ethAddress,
    treasury: Ethers.ethAddress,
    tokenFactory: Ethers.ethAddress,
    staker: Ethers.ethAddress,
  }

  let initializeCalls: unit => array<initializeCall> = () => {
    checkForExceptions(~functionName="initialize")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.initializeMock.calls")
      array->Array.map(((admin, treasury, tokenFactory, staker)) => {
        {
          admin: admin,
          treasury: treasury,
          tokenFactory: tokenFactory,
          staker: staker,
        }
      })
    })
    ->Option.getExn
  }

  let mockChangeAdminToReturn: unit => unit = () => {
    checkForExceptions(~functionName="changeAdmin")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.changeAdminMock.will.return()")
    })
  }

  type changeAdminCall = {admin: Ethers.ethAddress}

  let changeAdminCalls: unit => array<changeAdminCall> = () => {
    checkForExceptions(~functionName="changeAdmin")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.changeAdminMock.calls")
      array->Array.map(_m => {
        let admin = _m->Array.getUnsafe(0)

        {
          admin: admin,
        }
      })
    })
    ->Option.getExn
  }

  let mockChangeTreasuryToReturn: unit => unit = () => {
    checkForExceptions(~functionName="changeTreasury")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.changeTreasuryMock.will.return()")
    })
  }

  type changeTreasuryCall = {treasury: Ethers.ethAddress}

  let changeTreasuryCalls: unit => array<changeTreasuryCall> = () => {
    checkForExceptions(~functionName="changeTreasury")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.changeTreasuryMock.calls")
      array->Array.map(_m => {
        let treasury = _m->Array.getUnsafe(0)

        {
          treasury: treasury,
        }
      })
    })
    ->Option.getExn
  }

  let mockUpdateMarketOracleToReturn: unit => unit = () => {
    checkForExceptions(~functionName="updateMarketOracle")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.updateMarketOracleMock.will.return()")
    })
  }

  type updateMarketOracleCall = {
    marketIndex: int,
    newOracleManager: Ethers.ethAddress,
  }

  let updateMarketOracleCalls: unit => array<updateMarketOracleCall> = () => {
    checkForExceptions(~functionName="updateMarketOracle")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.updateMarketOracleMock.calls")
      array->Array.map(((marketIndex, newOracleManager)) => {
        {
          marketIndex: marketIndex,
          newOracleManager: newOracleManager,
        }
      })
    })
    ->Option.getExn
  }

  let mockNewSyntheticMarketToReturn: unit => unit = () => {
    checkForExceptions(~functionName="newSyntheticMarket")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.newSyntheticMarketMock.will.return()")
    })
  }

  type newSyntheticMarketCall = {
    syntheticName: string,
    syntheticSymbol: string,
    paymentToken: Ethers.ethAddress,
    oracleManager: Ethers.ethAddress,
    yieldManager: Ethers.ethAddress,
  }

  let newSyntheticMarketCalls: unit => array<newSyntheticMarketCall> = () => {
    checkForExceptions(~functionName="newSyntheticMarket")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.newSyntheticMarketMock.calls")
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
    })
    ->Option.getExn
  }

  let mock_seedMarketInitiallyToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_seedMarketInitially")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._seedMarketInitiallyMock.will.return()")
    })
  }

  type _seedMarketInitiallyCall = {
    initialMarketSeed: Ethers.BigNumber.t,
    marketIndex: int,
  }

  let _seedMarketInitiallyCalls: unit => array<_seedMarketInitiallyCall> = () => {
    checkForExceptions(~functionName="_seedMarketInitially")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._seedMarketInitiallyMock.calls")
      array->Array.map(((initialMarketSeed, marketIndex)) => {
        {
          initialMarketSeed: initialMarketSeed,
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockInitializeMarketToReturn: unit => unit = () => {
    checkForExceptions(~functionName="initializeMarket")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.initializeMarketMock.will.return()")
    })
  }

  type initializeMarketCall = {
    marketIndex: int,
    kInitialMultiplier: Ethers.BigNumber.t,
    kPeriod: Ethers.BigNumber.t,
    unstakeFeeBasisPoints: Ethers.BigNumber.t,
    initialMarketSeed: Ethers.BigNumber.t,
  }

  let initializeMarketCalls: unit => array<initializeMarketCall> = () => {
    checkForExceptions(~functionName="initializeMarket")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.initializeMarketMock.calls")
      array->Array.map(((
        marketIndex,
        kInitialMultiplier,
        kPeriod,
        unstakeFeeBasisPoints,
        initialMarketSeed,
      )) => {
        {
          marketIndex: marketIndex,
          kInitialMultiplier: kInitialMultiplier,
          kPeriod: kPeriod,
          unstakeFeeBasisPoints: unstakeFeeBasisPoints,
          initialMarketSeed: initialMarketSeed,
        }
      })
    })
    ->Option.getExn
  }

  let mock_recalculateSyntheticTokenPriceToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_recalculateSyntheticTokenPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._recalculateSyntheticTokenPriceMock.will.return.with([_param0])")
    })
  }

  type _recalculateSyntheticTokenPriceCall = {
    marketIndex: int,
    isLong: bool,
  }

  let _recalculateSyntheticTokenPriceCalls: unit => array<
    _recalculateSyntheticTokenPriceCall,
  > = () => {
    checkForExceptions(~functionName="_recalculateSyntheticTokenPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._recalculateSyntheticTokenPriceMock.calls")
      array->Array.map(((marketIndex, isLong)) => {
        {
          marketIndex: marketIndex,
          isLong: isLong,
        }
      })
    })
    ->Option.getExn
  }

  let mock_getAmountPaymentTokenToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getAmountPaymentToken")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._getAmountPaymentTokenMock.will.return.with([_param0])")
    })
  }

  type _getAmountPaymentTokenCall = {
    amountSynth: Ethers.BigNumber.t,
    price: Ethers.BigNumber.t,
  }

  let _getAmountPaymentTokenCalls: unit => array<_getAmountPaymentTokenCall> = () => {
    checkForExceptions(~functionName="_getAmountPaymentToken")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._getAmountPaymentTokenMock.calls")
      array->Array.map(((amountSynth, price)) => {
        {
          amountSynth: amountSynth,
          price: price,
        }
      })
    })
    ->Option.getExn
  }

  let mock_getAmountSynthTokenToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getAmountSynthToken")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._getAmountSynthTokenMock.will.return.with([_param0])")
    })
  }

  type _getAmountSynthTokenCall = {
    amountPaymentToken: Ethers.BigNumber.t,
    price: Ethers.BigNumber.t,
  }

  let _getAmountSynthTokenCalls: unit => array<_getAmountSynthTokenCall> = () => {
    checkForExceptions(~functionName="_getAmountSynthToken")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._getAmountSynthTokenMock.calls")
      array->Array.map(((amountPaymentToken, price)) => {
        {
          amountPaymentToken: amountPaymentToken,
          price: price,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetUsersConfirmedButNotSettledBalanceToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="getUsersConfirmedButNotSettledBalance")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw(
        "_r.smocked.getUsersConfirmedButNotSettledBalanceMock.will.return.with([_param0])"
      )
    })
  }

  type getUsersConfirmedButNotSettledBalanceCall = {
    user: Ethers.ethAddress,
    marketIndex: int,
    isLong: bool,
  }

  let getUsersConfirmedButNotSettledBalanceCalls: unit => array<
    getUsersConfirmedButNotSettledBalanceCall,
  > = () => {
    checkForExceptions(~functionName="getUsersConfirmedButNotSettledBalance")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getUsersConfirmedButNotSettledBalanceMock.calls")
      array->Array.map(((user, marketIndex, isLong)) => {
        {
          user: user,
          marketIndex: marketIndex,
          isLong: isLong,
        }
      })
    })
    ->Option.getExn
  }

  let mock_getMarketPercentForTreasuryVsMarketSplitToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getMarketPercentForTreasuryVsMarketSplit")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw(
        "_r.smocked._getMarketPercentForTreasuryVsMarketSplitMock.will.return.with([_param0])"
      )
    })
  }

  type _getMarketPercentForTreasuryVsMarketSplitCall = {marketIndex: int}

  let _getMarketPercentForTreasuryVsMarketSplitCalls: unit => array<
    _getMarketPercentForTreasuryVsMarketSplitCall,
  > = () => {
    checkForExceptions(~functionName="_getMarketPercentForTreasuryVsMarketSplit")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._getMarketPercentForTreasuryVsMarketSplitMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mock_getLongPercentForLongVsShortSplitToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getLongPercentForLongVsShortSplit")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._getLongPercentForLongVsShortSplitMock.will.return.with([_param0])")
    })
  }

  type _getLongPercentForLongVsShortSplitCall = {marketIndex: int}

  let _getLongPercentForLongVsShortSplitCalls: unit => array<
    _getLongPercentForLongVsShortSplitCall,
  > = () => {
    checkForExceptions(~functionName="_getLongPercentForLongVsShortSplit")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._getLongPercentForLongVsShortSplitMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mock_getMarketSplitToReturn: (Ethers.BigNumber.t, Ethers.BigNumber.t) => unit = (
    _param0,
    _param1,
  ) => {
    checkForExceptions(~functionName="_getMarketSplit")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._getMarketSplitMock.will.return.with([_param0,_param1])")
    })
  }

  type _getMarketSplitCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  let _getMarketSplitCalls: unit => array<_getMarketSplitCall> = () => {
    checkForExceptions(~functionName="_getMarketSplit")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._getMarketSplitMock.calls")
      array->Array.map(((marketIndex, amount)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mock_distributeMarketAmountToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_distributeMarketAmount")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._distributeMarketAmountMock.will.return()")
    })
  }

  type _distributeMarketAmountCall = {
    marketIndex: int,
    marketAmount: Ethers.BigNumber.t,
  }

  let _distributeMarketAmountCalls: unit => array<_distributeMarketAmountCall> = () => {
    checkForExceptions(~functionName="_distributeMarketAmount")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._distributeMarketAmountMock.calls")
      array->Array.map(((marketIndex, marketAmount)) => {
        {
          marketIndex: marketIndex,
          marketAmount: marketAmount,
        }
      })
    })
    ->Option.getExn
  }

  let mock_claimAndDistributeYieldToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_claimAndDistributeYield")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._claimAndDistributeYieldMock.will.return()")
    })
  }

  type _claimAndDistributeYieldCall = {marketIndex: int}

  let _claimAndDistributeYieldCalls: unit => array<_claimAndDistributeYieldCall> = () => {
    checkForExceptions(~functionName="_claimAndDistributeYield")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._claimAndDistributeYieldMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mock_adjustMarketBasedOnNewAssetPriceToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_adjustMarketBasedOnNewAssetPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._adjustMarketBasedOnNewAssetPriceMock.will.return()")
    })
  }

  type _adjustMarketBasedOnNewAssetPriceCall = {
    marketIndex: int,
    newAssetPrice: Ethers.BigNumber.t,
  }

  let _adjustMarketBasedOnNewAssetPriceCalls: unit => array<
    _adjustMarketBasedOnNewAssetPriceCall,
  > = () => {
    checkForExceptions(~functionName="_adjustMarketBasedOnNewAssetPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._adjustMarketBasedOnNewAssetPriceMock.calls")
      array->Array.map(((marketIndex, newAssetPrice)) => {
        {
          marketIndex: marketIndex,
          newAssetPrice: newAssetPrice,
        }
      })
    })
    ->Option.getExn
  }

  let mock_saveSyntheticTokenPriceSnapshotsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_saveSyntheticTokenPriceSnapshots")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._saveSyntheticTokenPriceSnapshotsMock.will.return()")
    })
  }

  type _saveSyntheticTokenPriceSnapshotsCall = {
    marketIndex: int,
    newLatestPriceStateIndex: Ethers.BigNumber.t,
    syntheticTokenPriceLong: Ethers.BigNumber.t,
    syntheticTokenPriceShort: Ethers.BigNumber.t,
  }

  let _saveSyntheticTokenPriceSnapshotsCalls: unit => array<
    _saveSyntheticTokenPriceSnapshotsCall,
  > = () => {
    checkForExceptions(~functionName="_saveSyntheticTokenPriceSnapshots")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._saveSyntheticTokenPriceSnapshotsMock.calls")
      array->Array.map(((
        marketIndex,
        newLatestPriceStateIndex,
        syntheticTokenPriceLong,
        syntheticTokenPriceShort,
      )) => {
        {
          marketIndex: marketIndex,
          newLatestPriceStateIndex: newLatestPriceStateIndex,
          syntheticTokenPriceLong: syntheticTokenPriceLong,
          syntheticTokenPriceShort: syntheticTokenPriceShort,
        }
      })
    })
    ->Option.getExn
  }

  let mock_updateSystemStateInternalToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_updateSystemStateInternal")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._updateSystemStateInternalMock.will.return()")
    })
  }

  type _updateSystemStateInternalCall = {marketIndex: int}

  let _updateSystemStateInternalCalls: unit => array<_updateSystemStateInternalCall> = () => {
    checkForExceptions(~functionName="_updateSystemStateInternal")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._updateSystemStateInternalMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockUpdateSystemStateToReturn: unit => unit = () => {
    checkForExceptions(~functionName="updateSystemState")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.updateSystemStateMock.will.return()")
    })
  }

  type updateSystemStateCall = {marketIndex: int}

  let updateSystemStateCalls: unit => array<updateSystemStateCall> = () => {
    checkForExceptions(~functionName="updateSystemState")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.updateSystemStateMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockUpdateSystemStateMultiToReturn: unit => unit = () => {
    checkForExceptions(~functionName="updateSystemStateMulti")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.updateSystemStateMultiMock.will.return()")
    })
  }

  type updateSystemStateMultiCall = {marketIndexes: array<int>}

  let updateSystemStateMultiCalls: unit => array<updateSystemStateMultiCall> = () => {
    checkForExceptions(~functionName="updateSystemStateMulti")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.updateSystemStateMultiMock.calls")
      array->Array.map(_m => {
        let marketIndexes = _m->Array.getUnsafe(0)

        {
          marketIndexes: marketIndexes,
        }
      })
    })
    ->Option.getExn
  }

  let mock_depositFundsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_depositFunds")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._depositFundsMock.will.return()")
    })
  }

  type _depositFundsCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  let _depositFundsCalls: unit => array<_depositFundsCall> = () => {
    checkForExceptions(~functionName="_depositFunds")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._depositFundsMock.calls")
      array->Array.map(((marketIndex, amount)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mock_lockFundsInMarketToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_lockFundsInMarket")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._lockFundsInMarketMock.will.return()")
    })
  }

  type _lockFundsInMarketCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  let _lockFundsInMarketCalls: unit => array<_lockFundsInMarketCall> = () => {
    checkForExceptions(~functionName="_lockFundsInMarket")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._lockFundsInMarketMock.calls")
      array->Array.map(((marketIndex, amount)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mock_withdrawFundsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_withdrawFunds")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._withdrawFundsMock.will.return()")
    })
  }

  type _withdrawFundsCall = {
    marketIndex: int,
    amountLong: Ethers.BigNumber.t,
    amountShort: Ethers.BigNumber.t,
    user: Ethers.ethAddress,
  }

  let _withdrawFundsCalls: unit => array<_withdrawFundsCall> = () => {
    checkForExceptions(~functionName="_withdrawFunds")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._withdrawFundsMock.calls")
      array->Array.map(((marketIndex, amountLong, amountShort, user)) => {
        {
          marketIndex: marketIndex,
          amountLong: amountLong,
          amountShort: amountShort,
          user: user,
        }
      })
    })
    ->Option.getExn
  }

  let mock_burnSynthTokensForRedemptionToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_burnSynthTokensForRedemption")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._burnSynthTokensForRedemptionMock.will.return()")
    })
  }

  type _burnSynthTokensForRedemptionCall = {
    marketIndex: int,
    amountSynthToRedeemLong: Ethers.BigNumber.t,
    amountSynthToRedeemShort: Ethers.BigNumber.t,
  }

  let _burnSynthTokensForRedemptionCalls: unit => array<_burnSynthTokensForRedemptionCall> = () => {
    checkForExceptions(~functionName="_burnSynthTokensForRedemption")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._burnSynthTokensForRedemptionMock.calls")
      array->Array.map(((marketIndex, amountSynthToRedeemLong, amountSynthToRedeemShort)) => {
        {
          marketIndex: marketIndex,
          amountSynthToRedeemLong: amountSynthToRedeemLong,
          amountSynthToRedeemShort: amountSynthToRedeemShort,
        }
      })
    })
    ->Option.getExn
  }

  let mock_transferFundsToYieldManagerToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_transferFundsToYieldManager")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._transferFundsToYieldManagerMock.will.return()")
    })
  }

  type _transferFundsToYieldManagerCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  let _transferFundsToYieldManagerCalls: unit => array<_transferFundsToYieldManagerCall> = () => {
    checkForExceptions(~functionName="_transferFundsToYieldManager")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._transferFundsToYieldManagerMock.calls")
      array->Array.map(((marketIndex, amount)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mock_transferFromYieldManagerToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_transferFromYieldManager")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._transferFromYieldManagerMock.will.return()")
    })
  }

  type _transferFromYieldManagerCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  let _transferFromYieldManagerCalls: unit => array<_transferFromYieldManagerCall> = () => {
    checkForExceptions(~functionName="_transferFromYieldManager")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._transferFromYieldManagerMock.calls")
      array->Array.map(((marketIndex, amount)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mock_mintNextPriceToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_mintNextPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._mintNextPriceMock.will.return()")
    })
  }

  type _mintNextPriceCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
    isLong: bool,
  }

  let _mintNextPriceCalls: unit => array<_mintNextPriceCall> = () => {
    checkForExceptions(~functionName="_mintNextPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._mintNextPriceMock.calls")
      array->Array.map(((marketIndex, amount, isLong)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
          isLong: isLong,
        }
      })
    })
    ->Option.getExn
  }

  let mockMintLongNextPriceToReturn: unit => unit = () => {
    checkForExceptions(~functionName="mintLongNextPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.mintLongNextPriceMock.will.return()")
    })
  }

  type mintLongNextPriceCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  let mintLongNextPriceCalls: unit => array<mintLongNextPriceCall> = () => {
    checkForExceptions(~functionName="mintLongNextPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.mintLongNextPriceMock.calls")
      array->Array.map(((marketIndex, amount)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mockMintShortNextPriceToReturn: unit => unit = () => {
    checkForExceptions(~functionName="mintShortNextPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.mintShortNextPriceMock.will.return()")
    })
  }

  type mintShortNextPriceCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  let mintShortNextPriceCalls: unit => array<mintShortNextPriceCall> = () => {
    checkForExceptions(~functionName="mintShortNextPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.mintShortNextPriceMock.calls")
      array->Array.map(((marketIndex, amount)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mock_redeemNextPriceToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_redeemNextPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._redeemNextPriceMock.will.return()")
    })
  }

  type _redeemNextPriceCall = {
    marketIndex: int,
    tokensToRedeem: Ethers.BigNumber.t,
    isLong: bool,
  }

  let _redeemNextPriceCalls: unit => array<_redeemNextPriceCall> = () => {
    checkForExceptions(~functionName="_redeemNextPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._redeemNextPriceMock.calls")
      array->Array.map(((marketIndex, tokensToRedeem, isLong)) => {
        {
          marketIndex: marketIndex,
          tokensToRedeem: tokensToRedeem,
          isLong: isLong,
        }
      })
    })
    ->Option.getExn
  }

  let mockRedeemLongNextPriceToReturn: unit => unit = () => {
    checkForExceptions(~functionName="redeemLongNextPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.redeemLongNextPriceMock.will.return()")
    })
  }

  type redeemLongNextPriceCall = {
    marketIndex: int,
    tokensToRedeem: Ethers.BigNumber.t,
  }

  let redeemLongNextPriceCalls: unit => array<redeemLongNextPriceCall> = () => {
    checkForExceptions(~functionName="redeemLongNextPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.redeemLongNextPriceMock.calls")
      array->Array.map(((marketIndex, tokensToRedeem)) => {
        {
          marketIndex: marketIndex,
          tokensToRedeem: tokensToRedeem,
        }
      })
    })
    ->Option.getExn
  }

  let mockRedeemShortNextPriceToReturn: unit => unit = () => {
    checkForExceptions(~functionName="redeemShortNextPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.redeemShortNextPriceMock.will.return()")
    })
  }

  type redeemShortNextPriceCall = {
    marketIndex: int,
    tokensToRedeem: Ethers.BigNumber.t,
  }

  let redeemShortNextPriceCalls: unit => array<redeemShortNextPriceCall> = () => {
    checkForExceptions(~functionName="redeemShortNextPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.redeemShortNextPriceMock.calls")
      array->Array.map(((marketIndex, tokensToRedeem)) => {
        {
          marketIndex: marketIndex,
          tokensToRedeem: tokensToRedeem,
        }
      })
    })
    ->Option.getExn
  }

  let mock_executeNextPriceMintsIfTheyExistToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_executeNextPriceMintsIfTheyExist")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._executeNextPriceMintsIfTheyExistMock.will.return()")
    })
  }

  type _executeNextPriceMintsIfTheyExistCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
    isLong: bool,
  }

  let _executeNextPriceMintsIfTheyExistCalls: unit => array<
    _executeNextPriceMintsIfTheyExistCall,
  > = () => {
    checkForExceptions(~functionName="_executeNextPriceMintsIfTheyExist")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._executeNextPriceMintsIfTheyExistMock.calls")
      array->Array.map(((marketIndex, user, isLong)) => {
        {
          marketIndex: marketIndex,
          user: user,
          isLong: isLong,
        }
      })
    })
    ->Option.getExn
  }

  let mock_executeOutstandingNextPriceRedeemsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceRedeems")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._executeOutstandingNextPriceRedeemsMock.will.return()")
    })
  }

  type _executeOutstandingNextPriceRedeemsCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
    isLong: bool,
  }

  let _executeOutstandingNextPriceRedeemsCalls: unit => array<
    _executeOutstandingNextPriceRedeemsCall,
  > = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceRedeems")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._executeOutstandingNextPriceRedeemsMock.calls")
      array->Array.map(((marketIndex, user, isLong)) => {
        {
          marketIndex: marketIndex,
          user: user,
          isLong: isLong,
        }
      })
    })
    ->Option.getExn
  }

  let mock_executeOutstandingNextPriceSettlementsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceSettlements")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._executeOutstandingNextPriceSettlementsMock.will.return()")
    })
  }

  type _executeOutstandingNextPriceSettlementsCall = {
    user: Ethers.ethAddress,
    marketIndex: int,
  }

  let _executeOutstandingNextPriceSettlementsCalls: unit => array<
    _executeOutstandingNextPriceSettlementsCall,
  > = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceSettlements")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._executeOutstandingNextPriceSettlementsMock.calls")
      array->Array.map(((user, marketIndex)) => {
        {
          user: user,
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockExecuteOutstandingNextPriceSettlementsUserToReturn: unit => unit = () => {
    checkForExceptions(~functionName="executeOutstandingNextPriceSettlementsUser")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.executeOutstandingNextPriceSettlementsUserMock.will.return()")
    })
  }

  type executeOutstandingNextPriceSettlementsUserCall = {
    user: Ethers.ethAddress,
    marketIndex: int,
  }

  let executeOutstandingNextPriceSettlementsUserCalls: unit => array<
    executeOutstandingNextPriceSettlementsUserCall,
  > = () => {
    checkForExceptions(~functionName="executeOutstandingNextPriceSettlementsUser")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.executeOutstandingNextPriceSettlementsUserMock.calls")
      array->Array.map(((user, marketIndex)) => {
        {
          user: user,
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mock_performOustandingSettlementsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_performOustandingSettlements")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._performOustandingSettlementsMock.will.return()")
    })
  }

  type _performOustandingSettlementsCall = {
    marketIndex: int,
    newLatestPriceStateIndex: Ethers.BigNumber.t,
    syntheticTokenPriceLong: Ethers.BigNumber.t,
    syntheticTokenPriceShort: Ethers.BigNumber.t,
  }

  let _performOustandingSettlementsCalls: unit => array<_performOustandingSettlementsCall> = () => {
    checkForExceptions(~functionName="_performOustandingSettlements")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._performOustandingSettlementsMock.calls")
      array->Array.map(((
        marketIndex,
        newLatestPriceStateIndex,
        syntheticTokenPriceLong,
        syntheticTokenPriceShort,
      )) => {
        {
          marketIndex: marketIndex,
          newLatestPriceStateIndex: newLatestPriceStateIndex,
          syntheticTokenPriceLong: syntheticTokenPriceLong,
          syntheticTokenPriceShort: syntheticTokenPriceShort,
        }
      })
    })
    ->Option.getExn
  }

  let mock_handleBatchedDepositSettlementToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_handleBatchedDepositSettlement")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._handleBatchedDepositSettlementMock.will.return()")
    })
  }

  type _handleBatchedDepositSettlementCall = {
    marketIndex: int,
    isLong: bool,
    syntheticTokenPrice: Ethers.BigNumber.t,
  }

  let _handleBatchedDepositSettlementCalls: unit => array<
    _handleBatchedDepositSettlementCall,
  > = () => {
    checkForExceptions(~functionName="_handleBatchedDepositSettlement")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._handleBatchedDepositSettlementMock.calls")
      array->Array.map(((marketIndex, isLong, syntheticTokenPrice)) => {
        {
          marketIndex: marketIndex,
          isLong: isLong,
          syntheticTokenPrice: syntheticTokenPrice,
        }
      })
    })
    ->Option.getExn
  }

  let mock_handleBatchedRedeemSettlementToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_handleBatchedRedeemSettlement")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._handleBatchedRedeemSettlementMock.will.return()")
    })
  }

  type _handleBatchedRedeemSettlementCall = {
    marketIndex: int,
    syntheticTokenPriceLong: Ethers.BigNumber.t,
    syntheticTokenPriceShort: Ethers.BigNumber.t,
  }

  let _handleBatchedRedeemSettlementCalls: unit => array<
    _handleBatchedRedeemSettlementCall,
  > = () => {
    checkForExceptions(~functionName="_handleBatchedRedeemSettlement")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._handleBatchedRedeemSettlementMock.calls")
      array->Array.map(((marketIndex, syntheticTokenPriceLong, syntheticTokenPriceShort)) => {
        {
          marketIndex: marketIndex,
          syntheticTokenPriceLong: syntheticTokenPriceLong,
          syntheticTokenPriceShort: syntheticTokenPriceShort,
        }
      })
    })
    ->Option.getExn
  }

  let mockAdminOnlyToReturn: unit => unit = () => {
    checkForExceptions(~functionName="adminOnly")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.adminOnlyMock.will.return()")
    })
  }

  type adminOnlyCall

  let adminOnlyCalls: unit => array<adminOnlyCall> = () => {
    checkForExceptions(~functionName="adminOnly")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.adminOnlyMock.calls")
      array->Array.map(() => {
        ()->Obj.magic
      })
    })
    ->Option.getExn
  }

  let mockAssertMarketExistsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="assertMarketExists")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.assertMarketExistsMock.will.return()")
    })
  }

  type assertMarketExistsCall = {marketIndex: int}

  let assertMarketExistsCalls: unit => array<assertMarketExistsCall> = () => {
    checkForExceptions(~functionName="assertMarketExists")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.assertMarketExistsMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockExecuteOutstandingNextPriceSettlementsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="executeOutstandingNextPriceSettlements")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.executeOutstandingNextPriceSettlementsMock.will.return()")
    })
  }

  type executeOutstandingNextPriceSettlementsCall = {
    user: Ethers.ethAddress,
    marketIndex: int,
  }

  let executeOutstandingNextPriceSettlementsCalls: unit => array<
    executeOutstandingNextPriceSettlementsCall,
  > = () => {
    checkForExceptions(~functionName="executeOutstandingNextPriceSettlements")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.executeOutstandingNextPriceSettlementsMock.calls")
      array->Array.map(((user, marketIndex)) => {
        {
          user: user,
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockUpdateSystemStateMarketToReturn: unit => unit = () => {
    checkForExceptions(~functionName="updateSystemStateMarket")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.updateSystemStateMarketMock.will.return()")
    })
  }

  type updateSystemStateMarketCall = {marketIndex: int}

  let updateSystemStateMarketCalls: unit => array<updateSystemStateMarketCall> = () => {
    checkForExceptions(~functionName="updateSystemStateMarket")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.updateSystemStateMarketMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }
}
