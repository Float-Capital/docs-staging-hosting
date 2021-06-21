type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: LongShort.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

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

let mockChangeFeesToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.changeFees.will.return()")
}

type changeFeesCall = {
  marketIndex: int,
  baseEntryFee: Ethers.BigNumber.t,
  badLiquidityEntryFee: Ethers.BigNumber.t,
  baseExitFee: Ethers.BigNumber.t,
  badLiquidityExitFee: Ethers.BigNumber.t,
}

let changeFeesCalls: t => array<changeFeesCall> = _r => {
  let array = %raw("_r.smocked.changeFees.calls")
  array->Array.map(((
    marketIndex,
    baseEntryFee,
    badLiquidityEntryFee,
    baseExitFee,
    badLiquidityExitFee,
  )) => {
    {
      marketIndex: marketIndex,
      baseEntryFee: baseEntryFee,
      badLiquidityEntryFee: badLiquidityEntryFee,
      baseExitFee: baseExitFee,
      badLiquidityExitFee: badLiquidityExitFee,
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
  fundToken: Ethers.ethAddress,
  oracleManager: Ethers.ethAddress,
  yieldManager: Ethers.ethAddress,
}

let newSyntheticMarketCalls: t => array<newSyntheticMarketCall> = _r => {
  let array = %raw("_r.smocked.newSyntheticMarket.calls")
  array->Array.map(((syntheticName, syntheticSymbol, fundToken, oracleManager, yieldManager)) => {
    {
      syntheticName: syntheticName,
      syntheticSymbol: syntheticSymbol,
      fundToken: fundToken,
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
  baseEntryFee: Ethers.BigNumber.t,
  badLiquidityEntryFee: Ethers.BigNumber.t,
  baseExitFee: Ethers.BigNumber.t,
  badLiquidityExitFee: Ethers.BigNumber.t,
  kInitialMultiplier: Ethers.BigNumber.t,
  kPeriod: Ethers.BigNumber.t,
  initialMarketSeed: Ethers.BigNumber.t,
}

let initializeMarketCalls: t => array<initializeMarketCall> = _r => {
  let array = %raw("_r.smocked.initializeMarket.calls")
  array->Array.map(((
    marketIndex,
    baseEntryFee,
    badLiquidityEntryFee,
    baseExitFee,
    badLiquidityExitFee,
    kInitialMultiplier,
    kPeriod,
    initialMarketSeed,
  )) => {
    {
      marketIndex: marketIndex,
      baseEntryFee: baseEntryFee,
      badLiquidityEntryFee: badLiquidityEntryFee,
      baseExitFee: baseExitFee,
      badLiquidityExitFee: badLiquidityExitFee,
      kInitialMultiplier: kInitialMultiplier,
      kPeriod: kPeriod,
      initialMarketSeed: initialMarketSeed,
    }
  })
}

let mockGetUsersPendingBalanceToReturn: (t, Ethers.BigNumber.t) => unit = (_r, _param0) => {
  let _ = %raw("_r.smocked.getUsersPendingBalance.will.return.with([_param0])")
}

type getUsersPendingBalanceCall = {
  user: Ethers.ethAddress,
  marketIndex: int,
  syntheticTokenType: int,
}

let getUsersPendingBalanceCalls: t => array<getUsersPendingBalanceCall> = _r => {
  let array = %raw("_r.smocked.getUsersPendingBalance.calls")
  array->Array.map(((user, marketIndex, syntheticTokenType)) => {
    {
      user: user,
      marketIndex: marketIndex,
      syntheticTokenType: syntheticTokenType,
    }
  })
}

let mockGetTreasurySplitToReturn: (t, Ethers.BigNumber.t, Ethers.BigNumber.t) => unit = (
  _r,
  _param0,
  _param1,
) => {
  let _ = %raw("_r.smocked.getTreasurySplit.will.return.with([_param0,_param1])")
}

type getTreasurySplitCall = {
  marketIndex: int,
  amount: Ethers.BigNumber.t,
}

let getTreasurySplitCalls: t => array<getTreasurySplitCall> = _r => {
  let array = %raw("_r.smocked.getTreasurySplit.calls")
  array->Array.map(((marketIndex, amount)) => {
    {
      marketIndex: marketIndex,
      amount: amount,
    }
  })
}

let mockGetMarketSplitToReturn: (t, Ethers.BigNumber.t, Ethers.BigNumber.t) => unit = (
  _r,
  _param0,
  _param1,
) => {
  let _ = %raw("_r.smocked.getMarketSplit.will.return.with([_param0,_param1])")
}

type getMarketSplitCall = {
  marketIndex: int,
  amount: Ethers.BigNumber.t,
}

let getMarketSplitCalls: t => array<getMarketSplitCall> = _r => {
  let array = %raw("_r.smocked.getMarketSplit.calls")
  array->Array.map(((marketIndex, amount)) => {
    {
      marketIndex: marketIndex,
      amount: amount,
    }
  })
}

let mock_updateSystemStateToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked._updateSystemState.will.return()")
}

type _updateSystemStateCall = {marketIndex: int}

let _updateSystemStateCalls: t => array<_updateSystemStateCall> = _r => {
  let array = %raw("_r.smocked._updateSystemState.calls")
  array->Array.map(_m => {
    let marketIndex = _m->Array.getUnsafe(0)

    {
      marketIndex: marketIndex,
    }
  })
}

let mock_updateSystemStateMultiToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked._updateSystemStateMulti.will.return()")
}

type _updateSystemStateMultiCall = {marketIndexes: array<int>}

let _updateSystemStateMultiCalls: t => array<_updateSystemStateMultiCall> = _r => {
  let array = %raw("_r.smocked._updateSystemStateMulti.calls")
  array->Array.map(_m => {
    let marketIndexes = _m->Array.getUnsafe(0)

    {
      marketIndexes: marketIndexes,
    }
  })
}

let mockTransferTreasuryFundsToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.transferTreasuryFunds.will.return()")
}

type transferTreasuryFundsCall = {marketIndex: int}

let transferTreasuryFundsCalls: t => array<transferTreasuryFundsCall> = _r => {
  let array = %raw("_r.smocked.transferTreasuryFunds.calls")
  array->Array.map(_m => {
    let marketIndex = _m->Array.getUnsafe(0)

    {
      marketIndex: marketIndex,
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

  let mockChangeFeesToReturn: unit => unit = () => {
    checkForExceptions(~functionName="changeFees")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.changeFeesMock.will.return()")
    })
  }

  type changeFeesCall = {
    marketIndex: int,
    baseEntryFee: Ethers.BigNumber.t,
    badLiquidityEntryFee: Ethers.BigNumber.t,
    baseExitFee: Ethers.BigNumber.t,
    badLiquidityExitFee: Ethers.BigNumber.t,
  }

  let changeFeesCalls: unit => array<changeFeesCall> = () => {
    checkForExceptions(~functionName="changeFees")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.changeFeesMock.calls")
      array->Array.map(((
        marketIndex,
        baseEntryFee,
        badLiquidityEntryFee,
        baseExitFee,
        badLiquidityExitFee,
      )) => {
        {
          marketIndex: marketIndex,
          baseEntryFee: baseEntryFee,
          badLiquidityEntryFee: badLiquidityEntryFee,
          baseExitFee: baseExitFee,
          badLiquidityExitFee: badLiquidityExitFee,
        }
      })
    })
    ->Option.getExn
  }

  let mock_changeFeesToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_changeFees")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._changeFeesMock.will.return()")
    })
  }

  type _changeFeesCall = {
    marketIndex: int,
    baseEntryFee: Ethers.BigNumber.t,
    baseExitFee: Ethers.BigNumber.t,
    badLiquidityEntryFee: Ethers.BigNumber.t,
    badLiquidityExitFee: Ethers.BigNumber.t,
  }

  let _changeFeesCalls: unit => array<_changeFeesCall> = () => {
    checkForExceptions(~functionName="_changeFees")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._changeFeesMock.calls")
      array->Array.map(((
        marketIndex,
        baseEntryFee,
        baseExitFee,
        badLiquidityEntryFee,
        badLiquidityExitFee,
      )) => {
        {
          marketIndex: marketIndex,
          baseEntryFee: baseEntryFee,
          baseExitFee: baseExitFee,
          badLiquidityEntryFee: badLiquidityEntryFee,
          badLiquidityExitFee: badLiquidityExitFee,
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
    fundToken: Ethers.ethAddress,
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
        fundToken,
        oracleManager,
        yieldManager,
      )) => {
        {
          syntheticName: syntheticName,
          syntheticSymbol: syntheticSymbol,
          fundToken: fundToken,
          oracleManager: oracleManager,
          yieldManager: yieldManager,
        }
      })
    })
    ->Option.getExn
  }

  let mockSeedMarketInitiallyToReturn: unit => unit = () => {
    checkForExceptions(~functionName="seedMarketInitially")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.seedMarketInitiallyMock.will.return()")
    })
  }

  type seedMarketInitiallyCall = {
    initialMarketSeed: Ethers.BigNumber.t,
    marketIndex: int,
  }

  let seedMarketInitiallyCalls: unit => array<seedMarketInitiallyCall> = () => {
    checkForExceptions(~functionName="seedMarketInitially")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.seedMarketInitiallyMock.calls")
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
    baseEntryFee: Ethers.BigNumber.t,
    badLiquidityEntryFee: Ethers.BigNumber.t,
    baseExitFee: Ethers.BigNumber.t,
    badLiquidityExitFee: Ethers.BigNumber.t,
    kInitialMultiplier: Ethers.BigNumber.t,
    kPeriod: Ethers.BigNumber.t,
    initialMarketSeed: Ethers.BigNumber.t,
  }

  let initializeMarketCalls: unit => array<initializeMarketCall> = () => {
    checkForExceptions(~functionName="initializeMarket")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.initializeMarketMock.calls")
      array->Array.map(((
        marketIndex,
        baseEntryFee,
        badLiquidityEntryFee,
        baseExitFee,
        badLiquidityExitFee,
        kInitialMultiplier,
        kPeriod,
        initialMarketSeed,
      )) => {
        {
          marketIndex: marketIndex,
          baseEntryFee: baseEntryFee,
          badLiquidityEntryFee: badLiquidityEntryFee,
          baseExitFee: baseExitFee,
          badLiquidityExitFee: badLiquidityExitFee,
          kInitialMultiplier: kInitialMultiplier,
          kPeriod: kPeriod,
          initialMarketSeed: initialMarketSeed,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetOtherSynthTypeToReturn: int => unit = _param0 => {
    checkForExceptions(~functionName="getOtherSynthType")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.getOtherSynthTypeMock.will.return.with([_param0])")
    })
  }

  type getOtherSynthTypeCall = {synthTokenType: int}

  let getOtherSynthTypeCalls: unit => array<getOtherSynthTypeCall> = () => {
    checkForExceptions(~functionName="getOtherSynthType")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getOtherSynthTypeMock.calls")
      array->Array.map(_m => {
        let synthTokenType = _m->Array.getUnsafe(0)

        {
          synthTokenType: synthTokenType,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetPriceToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="getPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.getPriceMock.will.return.with([_param0])")
    })
  }

  type getPriceCall = {
    amountSynth: Ethers.BigNumber.t,
    amountPaymentToken: Ethers.BigNumber.t,
  }

  let getPriceCalls: unit => array<getPriceCall> = () => {
    checkForExceptions(~functionName="getPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getPriceMock.calls")
      array->Array.map(((amountSynth, amountPaymentToken)) => {
        {
          amountSynth: amountSynth,
          amountPaymentToken: amountPaymentToken,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetAmountPaymentTokenToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="getAmountPaymentToken")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.getAmountPaymentTokenMock.will.return.with([_param0])")
    })
  }

  type getAmountPaymentTokenCall = {
    amountSynth: Ethers.BigNumber.t,
    price: Ethers.BigNumber.t,
  }

  let getAmountPaymentTokenCalls: unit => array<getAmountPaymentTokenCall> = () => {
    checkForExceptions(~functionName="getAmountPaymentToken")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getAmountPaymentTokenMock.calls")
      array->Array.map(((amountSynth, price)) => {
        {
          amountSynth: amountSynth,
          price: price,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetAmountSynthTokenToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="getAmountSynthToken")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.getAmountSynthTokenMock.will.return.with([_param0])")
    })
  }

  type getAmountSynthTokenCall = {
    amountPaymentToken: Ethers.BigNumber.t,
    price: Ethers.BigNumber.t,
  }

  let getAmountSynthTokenCalls: unit => array<getAmountSynthTokenCall> = () => {
    checkForExceptions(~functionName="getAmountSynthToken")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getAmountSynthTokenMock.calls")
      array->Array.map(((amountPaymentToken, price)) => {
        {
          amountPaymentToken: amountPaymentToken,
          price: price,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetUsersPendingBalanceToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="getUsersPendingBalance")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.getUsersPendingBalanceMock.will.return.with([_param0])")
    })
  }

  type getUsersPendingBalanceCall = {
    user: Ethers.ethAddress,
    marketIndex: int,
    syntheticTokenType: int,
  }

  let getUsersPendingBalanceCalls: unit => array<getUsersPendingBalanceCall> = () => {
    checkForExceptions(~functionName="getUsersPendingBalance")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getUsersPendingBalanceMock.calls")
      array->Array.map(((user, marketIndex, syntheticTokenType)) => {
        {
          user: user,
          marketIndex: marketIndex,
          syntheticTokenType: syntheticTokenType,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetTreasurySplitToReturn: (Ethers.BigNumber.t, Ethers.BigNumber.t) => unit = (
    _param0,
    _param1,
  ) => {
    checkForExceptions(~functionName="getTreasurySplit")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.getTreasurySplitMock.will.return.with([_param0,_param1])")
    })
  }

  type getTreasurySplitCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  let getTreasurySplitCalls: unit => array<getTreasurySplitCall> = () => {
    checkForExceptions(~functionName="getTreasurySplit")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getTreasurySplitMock.calls")
      array->Array.map(((marketIndex, amount)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetMarketSplitToReturn: (Ethers.BigNumber.t, Ethers.BigNumber.t) => unit = (
    _param0,
    _param1,
  ) => {
    checkForExceptions(~functionName="getMarketSplit")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.getMarketSplitMock.will.return.with([_param0,_param1])")
    })
  }

  type getMarketSplitCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
  }

  let getMarketSplitCalls: unit => array<getMarketSplitCall> = () => {
    checkForExceptions(~functionName="getMarketSplit")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getMarketSplitMock.calls")
      array->Array.map(((marketIndex, amount)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mock_minimumToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_minimum")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._minimumMock.will.return.with([_param0])")
    })
  }

  type _minimumCall = {
    a: Ethers.BigNumber.t,
    b: Ethers.BigNumber.t,
  }

  let _minimumCalls: unit => array<_minimumCall> = () => {
    checkForExceptions(~functionName="_minimum")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._minimumMock.calls")
      array->Array.map(((a, b)) => {
        {
          a: a,
          b: b,
        }
      })
    })
    ->Option.getExn
  }

  let mock_refreshTokenPricesToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_refreshTokenPrices")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._refreshTokenPricesMock.will.return()")
    })
  }

  type _refreshTokenPricesCall = {marketIndex: int}

  let _refreshTokenPricesCalls: unit => array<_refreshTokenPricesCall> = () => {
    checkForExceptions(~functionName="_refreshTokenPrices")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._refreshTokenPricesMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
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

  let mock_feesMechanismToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_feesMechanism")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._feesMechanismMock.will.return()")
    })
  }

  type _feesMechanismCall = {
    marketIndex: int,
    totalFees: Ethers.BigNumber.t,
  }

  let _feesMechanismCalls: unit => array<_feesMechanismCall> = () => {
    checkForExceptions(~functionName="_feesMechanism")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._feesMechanismMock.calls")
      array->Array.map(((marketIndex, totalFees)) => {
        {
          marketIndex: marketIndex,
          totalFees: totalFees,
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

  let mock_adjustMarketBasedOnNewAssetPriceToReturn: bool => unit = _param0 => {
    checkForExceptions(~functionName="_adjustMarketBasedOnNewAssetPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._adjustMarketBasedOnNewAssetPriceMock.will.return.with([_param0])")
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

  let mockHandleBatchedDepositSettlementToReturn: bool => unit = _param0 => {
    checkForExceptions(~functionName="handleBatchedDepositSettlement")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.handleBatchedDepositSettlementMock.will.return.with([_param0])")
    })
  }

  type handleBatchedDepositSettlementCall = {
    marketIndex: int,
    syntheticTokenType: int,
  }

  let handleBatchedDepositSettlementCalls: unit => array<
    handleBatchedDepositSettlementCall,
  > = () => {
    checkForExceptions(~functionName="handleBatchedDepositSettlement")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.handleBatchedDepositSettlementMock.calls")
      array->Array.map(((marketIndex, syntheticTokenType)) => {
        {
          marketIndex: marketIndex,
          syntheticTokenType: syntheticTokenType,
        }
      })
    })
    ->Option.getExn
  }

  let mockSnapshotPriceChangeForNextPriceExecutionToReturn: unit => unit = () => {
    checkForExceptions(~functionName="snapshotPriceChangeForNextPriceExecution")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.snapshotPriceChangeForNextPriceExecutionMock.will.return()")
    })
  }

  type snapshotPriceChangeForNextPriceExecutionCall = {
    marketIndex: int,
    newLatestPriceStateIndex: Ethers.BigNumber.t,
  }

  let snapshotPriceChangeForNextPriceExecutionCalls: unit => array<
    snapshotPriceChangeForNextPriceExecutionCall,
  > = () => {
    checkForExceptions(~functionName="snapshotPriceChangeForNextPriceExecution")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.snapshotPriceChangeForNextPriceExecutionMock.calls")
      array->Array.map(((marketIndex, newLatestPriceStateIndex)) => {
        {
          marketIndex: marketIndex,
          newLatestPriceStateIndex: newLatestPriceStateIndex,
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

  let mock_updateSystemStateToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_updateSystemState")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._updateSystemStateMock.will.return()")
    })
  }

  type _updateSystemStateCall = {marketIndex: int}

  let _updateSystemStateCalls: unit => array<_updateSystemStateCall> = () => {
    checkForExceptions(~functionName="_updateSystemState")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._updateSystemStateMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mock_updateSystemStateMultiToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_updateSystemStateMulti")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._updateSystemStateMultiMock.will.return()")
    })
  }

  type _updateSystemStateMultiCall = {marketIndexes: array<int>}

  let _updateSystemStateMultiCalls: unit => array<_updateSystemStateMultiCall> = () => {
    checkForExceptions(~functionName="_updateSystemStateMulti")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._updateSystemStateMultiMock.calls")
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

  let mockTransferTreasuryFundsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="transferTreasuryFunds")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.transferTreasuryFundsMock.will.return()")
    })
  }

  type transferTreasuryFundsCall = {marketIndex: int}

  let transferTreasuryFundsCalls: unit => array<transferTreasuryFundsCall> = () => {
    checkForExceptions(~functionName="transferTreasuryFunds")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.transferTreasuryFundsMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mock_getFeesGeneralToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="_getFeesGeneral")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._getFeesGeneralMock.will.return.with([_param0])")
    })
  }

  type _getFeesGeneralCall = {
    marketIndex: int,
    delta: Ethers.BigNumber.t,
    synthTokenGainingDominance: int,
    synthTokenLosingDominance: int,
    baseFeePercent: Ethers.BigNumber.t,
    penaltyFeePercent: Ethers.BigNumber.t,
  }

  let _getFeesGeneralCalls: unit => array<_getFeesGeneralCall> = () => {
    checkForExceptions(~functionName="_getFeesGeneral")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._getFeesGeneralMock.calls")
      array->Array.map(((
        marketIndex,
        delta,
        synthTokenGainingDominance,
        synthTokenLosingDominance,
        baseFeePercent,
        penaltyFeePercent,
      )) => {
        {
          marketIndex: marketIndex,
          delta: delta,
          synthTokenGainingDominance: synthTokenGainingDominance,
          synthTokenLosingDominance: synthTokenLosingDominance,
          baseFeePercent: baseFeePercent,
          penaltyFeePercent: penaltyFeePercent,
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
    syntheticTokenType: int,
  }

  let _executeNextPriceMintsIfTheyExistCalls: unit => array<
    _executeNextPriceMintsIfTheyExistCall,
  > = () => {
    checkForExceptions(~functionName="_executeNextPriceMintsIfTheyExist")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._executeNextPriceMintsIfTheyExistMock.calls")
      array->Array.map(((marketIndex, user, syntheticTokenType)) => {
        {
          marketIndex: marketIndex,
          user: user,
          syntheticTokenType: syntheticTokenType,
        }
      })
    })
    ->Option.getExn
  }

  let mock_executeOutstandingNextPriceSettlementsActionToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceSettlementsAction")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._executeOutstandingNextPriceSettlementsActionMock.will.return()")
    })
  }

  type _executeOutstandingNextPriceSettlementsActionCall = {
    user: Ethers.ethAddress,
    marketIndex: int,
  }

  let _executeOutstandingNextPriceSettlementsActionCalls: unit => array<
    _executeOutstandingNextPriceSettlementsActionCall,
  > = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceSettlementsAction")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._executeOutstandingNextPriceSettlementsActionMock.calls")
      array->Array.map(((user, marketIndex)) => {
        {
          user: user,
          marketIndex: marketIndex,
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

  let mock_mintNextPriceToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_mintNextPrice")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._mintNextPriceMock.will.return()")
    })
  }

  type _mintNextPriceCall = {
    marketIndex: int,
    amount: Ethers.BigNumber.t,
    syntheticTokenType: int,
  }

  let _mintNextPriceCalls: unit => array<_mintNextPriceCall> = () => {
    checkForExceptions(~functionName="_mintNextPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._mintNextPriceMock.calls")
      array->Array.map(((marketIndex, amount, syntheticTokenType)) => {
        {
          marketIndex: marketIndex,
          amount: amount,
          syntheticTokenType: syntheticTokenType,
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

  let mock_executeOutstandingNextPriceRedeemsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceRedeems")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._executeOutstandingNextPriceRedeemsMock.will.return()")
    })
  }

  type _executeOutstandingNextPriceRedeemsCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
    syntheticTokenType: int,
  }

  let _executeOutstandingNextPriceRedeemsCalls: unit => array<
    _executeOutstandingNextPriceRedeemsCall,
  > = () => {
    checkForExceptions(~functionName="_executeOutstandingNextPriceRedeems")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._executeOutstandingNextPriceRedeemsMock.calls")
      array->Array.map(((marketIndex, user, syntheticTokenType)) => {
        {
          marketIndex: marketIndex,
          user: user,
          syntheticTokenType: syntheticTokenType,
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
    syntheticTokenType: int,
  }

  let _redeemNextPriceCalls: unit => array<_redeemNextPriceCall> = () => {
    checkForExceptions(~functionName="_redeemNextPrice")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._redeemNextPriceMock.calls")
      array->Array.map(((marketIndex, tokensToRedeem, syntheticTokenType)) => {
        {
          marketIndex: marketIndex,
          tokensToRedeem: tokensToRedeem,
          syntheticTokenType: syntheticTokenType,
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

  let mock_handleBatchedNextPriceRedeemToReturn: bool => unit = _param0 => {
    checkForExceptions(~functionName="_handleBatchedNextPriceRedeem")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._handleBatchedNextPriceRedeemMock.will.return.with([_param0])")
    })
  }

  type _handleBatchedNextPriceRedeemCall = {
    marketIndex: int,
    syntheticTokenType: int,
    amountSynthToRedeem: Ethers.BigNumber.t,
  }

  let _handleBatchedNextPriceRedeemCalls: unit => array<_handleBatchedNextPriceRedeemCall> = () => {
    checkForExceptions(~functionName="_handleBatchedNextPriceRedeem")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._handleBatchedNextPriceRedeemMock.calls")
      array->Array.map(((marketIndex, syntheticTokenType, amountSynthToRedeem)) => {
        {
          marketIndex: marketIndex,
          syntheticTokenType: syntheticTokenType,
          amountSynthToRedeem: amountSynthToRedeem,
        }
      })
    })
    ->Option.getExn
  }

  let mock_calculateBatchedNextPriceFeesToReturn: (
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = (_param0, _param1) => {
    checkForExceptions(~functionName="_calculateBatchedNextPriceFees")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw(
        "_r.smocked._calculateBatchedNextPriceFeesMock.will.return.with([_param0,_param1])"
      )
    })
  }

  type _calculateBatchedNextPriceFeesCall = {
    marketIndex: int,
    amountOfPaymentTokenToRedeem: Ethers.BigNumber.t,
    shortAmountOfPaymentTokenToRedeem: Ethers.BigNumber.t,
  }

  let _calculateBatchedNextPriceFeesCalls: unit => array<
    _calculateBatchedNextPriceFeesCall,
  > = () => {
    checkForExceptions(~functionName="_calculateBatchedNextPriceFees")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._calculateBatchedNextPriceFeesMock.calls")
      array->Array.map(((
        marketIndex,
        amountOfPaymentTokenToRedeem,
        shortAmountOfPaymentTokenToRedeem,
      )) => {
        {
          marketIndex: marketIndex,
          amountOfPaymentTokenToRedeem: amountOfPaymentTokenToRedeem,
          shortAmountOfPaymentTokenToRedeem: shortAmountOfPaymentTokenToRedeem,
        }
      })
    })
    ->Option.getExn
  }

  let mockCalculateRedeemPriceSnapshotToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="calculateRedeemPriceSnapshot")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.calculateRedeemPriceSnapshotMock.will.return.with([_param0])")
    })
  }

  type calculateRedeemPriceSnapshotCall = {
    marketIndex: int,
    amountOfPaymentTokenToRedeem: Ethers.BigNumber.t,
    syntheticTokenType: int,
  }

  let calculateRedeemPriceSnapshotCalls: unit => array<calculateRedeemPriceSnapshotCall> = () => {
    checkForExceptions(~functionName="calculateRedeemPriceSnapshot")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.calculateRedeemPriceSnapshotMock.calls")
      array->Array.map(((marketIndex, amountOfPaymentTokenToRedeem, syntheticTokenType)) => {
        {
          marketIndex: marketIndex,
          amountOfPaymentTokenToRedeem: amountOfPaymentTokenToRedeem,
          syntheticTokenType: syntheticTokenType,
        }
      })
    })
    ->Option.getExn
  }

  let mockHandleBatchedNextPriceRedeemsToReturn: bool => unit = _param0 => {
    checkForExceptions(~functionName="handleBatchedNextPriceRedeems")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.handleBatchedNextPriceRedeemsMock.will.return.with([_param0])")
    })
  }

  type handleBatchedNextPriceRedeemsCall = {marketIndex: int}

  let handleBatchedNextPriceRedeemsCalls: unit => array<handleBatchedNextPriceRedeemsCall> = () => {
    checkForExceptions(~functionName="handleBatchedNextPriceRedeems")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.handleBatchedNextPriceRedeemsMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
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

  let mockTreasuryOnlyToReturn: unit => unit = () => {
    checkForExceptions(~functionName="treasuryOnly")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.treasuryOnlyMock.will.return()")
    })
  }

  type treasuryOnlyCall

  let treasuryOnlyCalls: unit => array<treasuryOnlyCall> = () => {
    checkForExceptions(~functionName="treasuryOnly")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.treasuryOnlyMock.calls")
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

  let mockIsCorrectSynthToReturn: unit => unit = () => {
    checkForExceptions(~functionName="isCorrectSynth")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.isCorrectSynthMock.will.return()")
    })
  }

  type isCorrectSynthCall = {
    marketIndex: int,
    syntheticTokenType: int,
    syntheticToken: Ethers.ethAddress,
  }

  let isCorrectSynthCalls: unit => array<isCorrectSynthCall> = () => {
    checkForExceptions(~functionName="isCorrectSynth")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.isCorrectSynthMock.calls")
      array->Array.map(((marketIndex, syntheticTokenType, syntheticToken)) => {
        {
          marketIndex: marketIndex,
          syntheticTokenType: syntheticTokenType,
          syntheticToken: syntheticToken,
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
