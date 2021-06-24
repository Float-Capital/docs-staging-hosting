type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: Staker.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

let mockInitializeToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.initialize.will.return()")
}

type initializeCall = {
  admin: Ethers.ethAddress,
  longShortCoreContract: Ethers.ethAddress,
  floatToken: Ethers.ethAddress,
  floatCapital: Ethers.ethAddress,
}

let initializeCalls: t => array<initializeCall> = _r => {
  let array = %raw("_r.smocked.initialize.calls")
  array->Array.map(((admin, longShortCoreContract, floatToken, floatCapital)) => {
    {
      admin: admin,
      longShortCoreContract: longShortCoreContract,
      floatToken: floatToken,
      floatCapital: floatCapital,
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

let mockChangeFloatPercentageToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.changeFloatPercentage.will.return()")
}

type changeFloatPercentageCall = {newPercentage: int}

let changeFloatPercentageCalls: t => array<changeFloatPercentageCall> = _r => {
  let array = %raw("_r.smocked.changeFloatPercentage.calls")
  array->Array.map(_m => {
    let newPercentage = _m->Array.getUnsafe(0)

    {
      newPercentage: newPercentage,
    }
  })
}

let mockChangeMarketLaunchIncentiveParametersToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.changeMarketLaunchIncentiveParameters.will.return()")
}

type changeMarketLaunchIncentiveParametersCall = {
  marketIndex: int,
  period: Ethers.BigNumber.t,
  initialMultiplier: Ethers.BigNumber.t,
}

let changeMarketLaunchIncentiveParametersCalls: t => array<
  changeMarketLaunchIncentiveParametersCall,
> = _r => {
  let array = %raw("_r.smocked.changeMarketLaunchIncentiveParameters.calls")
  array->Array.map(((marketIndex, period, initialMultiplier)) => {
    {
      marketIndex: marketIndex,
      period: period,
      initialMultiplier: initialMultiplier,
    }
  })
}

let mockAddNewStakingFundToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.addNewStakingFund.will.return()")
}

type addNewStakingFundCall = {
  marketIndex: int,
  longToken: Ethers.ethAddress,
  shortToken: Ethers.ethAddress,
  kInitialMultiplier: Ethers.BigNumber.t,
  kPeriod: Ethers.BigNumber.t,
}

let addNewStakingFundCalls: t => array<addNewStakingFundCall> = _r => {
  let array = %raw("_r.smocked.addNewStakingFund.calls")
  array->Array.map(((marketIndex, longToken, shortToken, kInitialMultiplier, kPeriod)) => {
    {
      marketIndex: marketIndex,
      longToken: longToken,
      shortToken: shortToken,
      kInitialMultiplier: kInitialMultiplier,
      kPeriod: kPeriod,
    }
  })
}

let mockAddNewStateForFloatRewardsToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.addNewStateForFloatRewards.will.return()")
}

type addNewStateForFloatRewardsCall = {
  marketIndex: int,
  longPrice: Ethers.BigNumber.t,
  shortPrice: Ethers.BigNumber.t,
  longValue: Ethers.BigNumber.t,
  shortValue: Ethers.BigNumber.t,
}

let addNewStateForFloatRewardsCalls: t => array<addNewStateForFloatRewardsCall> = _r => {
  let array = %raw("_r.smocked.addNewStateForFloatRewards.calls")
  array->Array.map(((marketIndex, longPrice, shortPrice, longValue, shortValue)) => {
    {
      marketIndex: marketIndex,
      longPrice: longPrice,
      shortPrice: shortPrice,
      longValue: longValue,
      shortValue: shortValue,
    }
  })
}

let mockClaimFloatCustomToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.claimFloatCustom.will.return()")
}

type claimFloatCustomCall = {marketIndexes: array<int>}

let claimFloatCustomCalls: t => array<claimFloatCustomCall> = _r => {
  let array = %raw("_r.smocked.claimFloatCustom.calls")
  array->Array.map(_m => {
    let marketIndexes = _m->Array.getUnsafe(0)

    {
      marketIndexes: marketIndexes,
    }
  })
}

let mockStakeFromUserToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.stakeFromUser.will.return()")
}

type stakeFromUserCall = {
  from: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
}

let stakeFromUserCalls: t => array<stakeFromUserCall> = _r => {
  let array = %raw("_r.smocked.stakeFromUser.calls")
  array->Array.map(((from, amount)) => {
    {
      from: from,
      amount: amount,
    }
  })
}

let mockWithdrawToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.withdraw.will.return()")
}

type withdrawCall = {
  token: Ethers.ethAddress,
  amount: Ethers.BigNumber.t,
}

let withdrawCalls: t => array<withdrawCall> = _r => {
  let array = %raw("_r.smocked.withdraw.calls")
  array->Array.map(((token, amount)) => {
    {
      token: token,
      amount: amount,
    }
  })
}

let mockWithdrawAllToReturn: t => unit = _r => {
  let _ = %raw("_r.smocked.withdrawAll.will.return()")
}

type withdrawAllCall = {token: Ethers.ethAddress}

let withdrawAllCalls: t => array<withdrawAllCall> = _r => {
  let array = %raw("_r.smocked.withdrawAll.calls")
  array->Array.map(_m => {
    let token = _m->Array.getUnsafe(0)

    {
      token: token,
    }
  })
}

module InternalMock = {
  let mockContractName = "StakerForInternalMocking"
  type t = {address: Ethers.ethAddress}

  let internalRef: ref<option<t>> = ref(None)

  let functionToNotMock: ref<string> = ref("")

  @module("@eth-optimism/smock") external smock: 'a => Js.Promise.t<t> = "smockit"

  let setup: Staker.t => JsPromise.t<ContractHelpers.transaction> = contract => {
    ContractHelpers.deployContract0(mockContractName)
    ->JsPromise.then(a => {
      smock(a)
    })
    ->JsPromise.then(b => {
      internalRef := Some(b)
      contract->Staker.Exposed.setMocker(~mocker=(b->Obj.magic).address)
    })
  }

  let setFunctionForUnitTesting = (contract, ~functionName) => {
    functionToNotMock := functionName
    contract->Staker.Exposed.setFunctionToNotMock(~functionToNotMock=functionName)
  }

  let setupFunctionForUnitTesting = (contract, ~functionName) => {
    ContractHelpers.deployContract0(mockContractName)
    ->JsPromise.then(a => {
      smock(a)
    })
    ->JsPromise.then(b => {
      internalRef := Some(b)
      [
        contract->Staker.Exposed.setMocker(~mocker=(b->Obj.magic).address),
        contract->Staker.Exposed.setFunctionToNotMock(~functionToNotMock=functionName),
      ]->JsPromise.all
    })
  }

  exception MockingAFunctionThatYouShouldntBe

  exception HaventSetupInternalMockingForStaker

  let checkForExceptions = (~functionName) => {
    if functionToNotMock.contents == functionName {
      raise(MockingAFunctionThatYouShouldntBe)
    }
    if internalRef.contents == None {
      raise(HaventSetupInternalMockingForStaker)
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
    longShortCoreContract: Ethers.ethAddress,
    floatToken: Ethers.ethAddress,
    floatCapital: Ethers.ethAddress,
  }

  let initializeCalls: unit => array<initializeCall> = () => {
    checkForExceptions(~functionName="initialize")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.initializeMock.calls")
      array->Array.map(((admin, longShortCoreContract, floatToken, floatCapital)) => {
        {
          admin: admin,
          longShortCoreContract: longShortCoreContract,
          floatToken: floatToken,
          floatCapital: floatCapital,
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

  let mockChangeFloatPercentageToReturn: unit => unit = () => {
    checkForExceptions(~functionName="changeFloatPercentage")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.changeFloatPercentageMock.will.return()")
    })
  }

  type changeFloatPercentageCall = {newPercentage: int}

  let changeFloatPercentageCalls: unit => array<changeFloatPercentageCall> = () => {
    checkForExceptions(~functionName="changeFloatPercentage")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.changeFloatPercentageMock.calls")
      array->Array.map(_m => {
        let newPercentage = _m->Array.getUnsafe(0)

        {
          newPercentage: newPercentage,
        }
      })
    })
    ->Option.getExn
  }

  let mockChangeMarketLaunchIncentiveParametersToReturn: unit => unit = () => {
    checkForExceptions(~functionName="changeMarketLaunchIncentiveParameters")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.changeMarketLaunchIncentiveParametersMock.will.return()")
    })
  }

  type changeMarketLaunchIncentiveParametersCall = {
    marketIndex: int,
    period: Ethers.BigNumber.t,
    initialMultiplier: Ethers.BigNumber.t,
  }

  let changeMarketLaunchIncentiveParametersCalls: unit => array<
    changeMarketLaunchIncentiveParametersCall,
  > = () => {
    checkForExceptions(~functionName="changeMarketLaunchIncentiveParameters")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.changeMarketLaunchIncentiveParametersMock.calls")
      array->Array.map(((marketIndex, period, initialMultiplier)) => {
        {
          marketIndex: marketIndex,
          period: period,
          initialMultiplier: initialMultiplier,
        }
      })
    })
    ->Option.getExn
  }

  let mock_changeMarketLaunchIncentiveParametersToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_changeMarketLaunchIncentiveParameters")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._changeMarketLaunchIncentiveParametersMock.will.return()")
    })
  }

  type _changeMarketLaunchIncentiveParametersCall = {
    marketIndex: int,
    period: Ethers.BigNumber.t,
    initialMultiplier: Ethers.BigNumber.t,
  }

  let _changeMarketLaunchIncentiveParametersCalls: unit => array<
    _changeMarketLaunchIncentiveParametersCall,
  > = () => {
    checkForExceptions(~functionName="_changeMarketLaunchIncentiveParameters")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._changeMarketLaunchIncentiveParametersMock.calls")
      array->Array.map(((marketIndex, period, initialMultiplier)) => {
        {
          marketIndex: marketIndex,
          period: period,
          initialMultiplier: initialMultiplier,
        }
      })
    })
    ->Option.getExn
  }

  let mockAddNewStakingFundToReturn: unit => unit = () => {
    checkForExceptions(~functionName="addNewStakingFund")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.addNewStakingFundMock.will.return()")
    })
  }

  type addNewStakingFundCall = {
    marketIndex: int,
    longToken: Ethers.ethAddress,
    shortToken: Ethers.ethAddress,
    kInitialMultiplier: Ethers.BigNumber.t,
    kPeriod: Ethers.BigNumber.t,
  }

  let addNewStakingFundCalls: unit => array<addNewStakingFundCall> = () => {
    checkForExceptions(~functionName="addNewStakingFund")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.addNewStakingFundMock.calls")
      array->Array.map(((marketIndex, longToken, shortToken, kInitialMultiplier, kPeriod)) => {
        {
          marketIndex: marketIndex,
          longToken: longToken,
          shortToken: shortToken,
          kInitialMultiplier: kInitialMultiplier,
          kPeriod: kPeriod,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetMarketLaunchIncentiveParametersToReturn: (
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = (_param0, _param1) => {
    checkForExceptions(~functionName="getMarketLaunchIncentiveParameters")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw(
        "_r.smocked.getMarketLaunchIncentiveParametersMock.will.return.with([_param0,_param1])"
      )
    })
  }

  type getMarketLaunchIncentiveParametersCall = {marketIndex: int}

  let getMarketLaunchIncentiveParametersCalls: unit => array<
    getMarketLaunchIncentiveParametersCall,
  > = () => {
    checkForExceptions(~functionName="getMarketLaunchIncentiveParameters")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getMarketLaunchIncentiveParametersMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockGetKValueToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="getKValue")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.getKValueMock.will.return.with([_param0])")
    })
  }

  type getKValueCall = {marketIndex: int}

  let getKValueCalls: unit => array<getKValueCall> = () => {
    checkForExceptions(~functionName="getKValue")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getKValueMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockCalculateFloatPerSecondToReturn: (Ethers.BigNumber.t, Ethers.BigNumber.t) => unit = (
    _param0,
    _param1,
  ) => {
    checkForExceptions(~functionName="calculateFloatPerSecond")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.calculateFloatPerSecondMock.will.return.with([_param0,_param1])")
    })
  }

  type calculateFloatPerSecondCall = {
    marketIndex: int,
    longPrice: Ethers.BigNumber.t,
    shortPrice: Ethers.BigNumber.t,
    longValue: Ethers.BigNumber.t,
    shortValue: Ethers.BigNumber.t,
  }

  let calculateFloatPerSecondCalls: unit => array<calculateFloatPerSecondCall> = () => {
    checkForExceptions(~functionName="calculateFloatPerSecond")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.calculateFloatPerSecondMock.calls")
      array->Array.map(((marketIndex, longPrice, shortPrice, longValue, shortValue)) => {
        {
          marketIndex: marketIndex,
          longPrice: longPrice,
          shortPrice: shortPrice,
          longValue: longValue,
          shortValue: shortValue,
        }
      })
    })
    ->Option.getExn
  }

  let mockCalculateTimeDeltaToReturn: Ethers.BigNumber.t => unit = _param0 => {
    checkForExceptions(~functionName="calculateTimeDelta")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.calculateTimeDeltaMock.will.return.with([_param0])")
    })
  }

  type calculateTimeDeltaCall = {marketIndex: int}

  let calculateTimeDeltaCalls: unit => array<calculateTimeDeltaCall> = () => {
    checkForExceptions(~functionName="calculateTimeDelta")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.calculateTimeDeltaMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockCalculateNewCumulativeRateToReturn: (Ethers.BigNumber.t, Ethers.BigNumber.t) => unit = (
    _param0,
    _param1,
  ) => {
    checkForExceptions(~functionName="calculateNewCumulativeRate")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.calculateNewCumulativeRateMock.will.return.with([_param0,_param1])")
    })
  }

  type calculateNewCumulativeRateCall = {
    marketIndex: int,
    longPrice: Ethers.BigNumber.t,
    shortPrice: Ethers.BigNumber.t,
    longValue: Ethers.BigNumber.t,
    shortValue: Ethers.BigNumber.t,
  }

  let calculateNewCumulativeRateCalls: unit => array<calculateNewCumulativeRateCall> = () => {
    checkForExceptions(~functionName="calculateNewCumulativeRate")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.calculateNewCumulativeRateMock.calls")
      array->Array.map(((marketIndex, longPrice, shortPrice, longValue, shortValue)) => {
        {
          marketIndex: marketIndex,
          longPrice: longPrice,
          shortPrice: shortPrice,
          longValue: longValue,
          shortValue: shortValue,
        }
      })
    })
    ->Option.getExn
  }

  let mockSetRewardObjectsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="setRewardObjects")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.setRewardObjectsMock.will.return()")
    })
  }

  type setRewardObjectsCall = {
    marketIndex: int,
    longPrice: Ethers.BigNumber.t,
    shortPrice: Ethers.BigNumber.t,
    longValue: Ethers.BigNumber.t,
    shortValue: Ethers.BigNumber.t,
  }

  let setRewardObjectsCalls: unit => array<setRewardObjectsCall> = () => {
    checkForExceptions(~functionName="setRewardObjects")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.setRewardObjectsMock.calls")
      array->Array.map(((marketIndex, longPrice, shortPrice, longValue, shortValue)) => {
        {
          marketIndex: marketIndex,
          longPrice: longPrice,
          shortPrice: shortPrice,
          longValue: longValue,
          shortValue: shortValue,
        }
      })
    })
    ->Option.getExn
  }

  let mockAddNewStateForFloatRewardsToReturn: unit => unit = () => {
    checkForExceptions(~functionName="addNewStateForFloatRewards")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.addNewStateForFloatRewardsMock.will.return()")
    })
  }

  type addNewStateForFloatRewardsCall = {
    marketIndex: int,
    longPrice: Ethers.BigNumber.t,
    shortPrice: Ethers.BigNumber.t,
    longValue: Ethers.BigNumber.t,
    shortValue: Ethers.BigNumber.t,
  }

  let addNewStateForFloatRewardsCalls: unit => array<addNewStateForFloatRewardsCall> = () => {
    checkForExceptions(~functionName="addNewStateForFloatRewards")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.addNewStateForFloatRewardsMock.calls")
      array->Array.map(((marketIndex, longPrice, shortPrice, longValue, shortValue)) => {
        {
          marketIndex: marketIndex,
          longPrice: longPrice,
          shortPrice: shortPrice,
          longValue: longValue,
          shortValue: shortValue,
        }
      })
    })
    ->Option.getExn
  }

  let mock_updateStateToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_updateState")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._updateStateMock.will.return()")
    })
  }

  type _updateStateCall = {token: Ethers.ethAddress}

  let _updateStateCalls: unit => array<_updateStateCall> = () => {
    checkForExceptions(~functionName="_updateState")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._updateStateMock.calls")
      array->Array.map(_m => {
        let token = _m->Array.getUnsafe(0)

        {
          token: token,
        }
      })
    })
    ->Option.getExn
  }

  let mockCalculateAccumulatedFloatHelperToReturn: (
    Ethers.BigNumber.t,
    Ethers.BigNumber.t,
  ) => unit = (_param0, _param1) => {
    checkForExceptions(~functionName="calculateAccumulatedFloatHelper")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw(
        "_r.smocked.calculateAccumulatedFloatHelperMock.will.return.with([_param0,_param1])"
      )
    })
  }

  type calculateAccumulatedFloatHelperCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
    amountStakedLong: Ethers.BigNumber.t,
    amountStakedShort: Ethers.BigNumber.t,
    usersLastRewardIndex: Ethers.BigNumber.t,
  }

  let calculateAccumulatedFloatHelperCalls: unit => array<
    calculateAccumulatedFloatHelperCall,
  > = () => {
    checkForExceptions(~functionName="calculateAccumulatedFloatHelper")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.calculateAccumulatedFloatHelperMock.calls")
      array->Array.map(((
        marketIndex,
        user,
        amountStakedLong,
        amountStakedShort,
        usersLastRewardIndex,
      )) => {
        {
          marketIndex: marketIndex,
          user: user,
          amountStakedLong: amountStakedLong,
          amountStakedShort: amountStakedShort,
          usersLastRewardIndex: usersLastRewardIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockCalculateAccumulatedFloatToReturn: (Ethers.BigNumber.t, Ethers.BigNumber.t) => unit = (
    _param0,
    _param1,
  ) => {
    checkForExceptions(~functionName="calculateAccumulatedFloat")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.calculateAccumulatedFloatMock.will.return.with([_param0,_param1])")
    })
  }

  type calculateAccumulatedFloatCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
  }

  let calculateAccumulatedFloatCalls: unit => array<calculateAccumulatedFloatCall> = () => {
    checkForExceptions(~functionName="calculateAccumulatedFloat")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.calculateAccumulatedFloatMock.calls")
      array->Array.map(((marketIndex, user)) => {
        {
          marketIndex: marketIndex,
          user: user,
        }
      })
    })
    ->Option.getExn
  }

  let mock_mintFloatToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_mintFloat")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._mintFloatMock.will.return()")
    })
  }

  type _mintFloatCall = {
    user: Ethers.ethAddress,
    floatToMint: Ethers.BigNumber.t,
  }

  let _mintFloatCalls: unit => array<_mintFloatCall> = () => {
    checkForExceptions(~functionName="_mintFloat")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._mintFloatMock.calls")
      array->Array.map(((user, floatToMint)) => {
        {
          user: user,
          floatToMint: floatToMint,
        }
      })
    })
    ->Option.getExn
  }

  let mockMintAccumulatedFloatToReturn: unit => unit = () => {
    checkForExceptions(~functionName="mintAccumulatedFloat")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.mintAccumulatedFloatMock.will.return()")
    })
  }

  type mintAccumulatedFloatCall = {
    marketIndex: int,
    user: Ethers.ethAddress,
  }

  let mintAccumulatedFloatCalls: unit => array<mintAccumulatedFloatCall> = () => {
    checkForExceptions(~functionName="mintAccumulatedFloat")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.mintAccumulatedFloatMock.calls")
      array->Array.map(((marketIndex, user)) => {
        {
          marketIndex: marketIndex,
          user: user,
        }
      })
    })
    ->Option.getExn
  }

  let mock_claimFloatToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_claimFloat")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._claimFloatMock.will.return()")
    })
  }

  type _claimFloatCall = {marketIndex: array<int>}

  let _claimFloatCalls: unit => array<_claimFloatCall> = () => {
    checkForExceptions(~functionName="_claimFloat")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._claimFloatMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockClaimFloatCustomToReturn: unit => unit = () => {
    checkForExceptions(~functionName="claimFloatCustom")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.claimFloatCustomMock.will.return()")
    })
  }

  type claimFloatCustomCall = {marketIndexes: array<int>}

  let claimFloatCustomCalls: unit => array<claimFloatCustomCall> = () => {
    checkForExceptions(~functionName="claimFloatCustom")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.claimFloatCustomMock.calls")
      array->Array.map(_m => {
        let marketIndexes = _m->Array.getUnsafe(0)

        {
          marketIndexes: marketIndexes,
        }
      })
    })
    ->Option.getExn
  }

  let mockStakeFromUserToReturn: unit => unit = () => {
    checkForExceptions(~functionName="stakeFromUser")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.stakeFromUserMock.will.return()")
    })
  }

  type stakeFromUserCall = {
    from: Ethers.ethAddress,
    amount: Ethers.BigNumber.t,
  }

  let stakeFromUserCalls: unit => array<stakeFromUserCall> = () => {
    checkForExceptions(~functionName="stakeFromUser")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.stakeFromUserMock.calls")
      array->Array.map(((from, amount)) => {
        {
          from: from,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mock_stakeToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_stake")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._stakeMock.will.return()")
    })
  }

  type _stakeCall = {
    token: Ethers.ethAddress,
    amount: Ethers.BigNumber.t,
    user: Ethers.ethAddress,
  }

  let _stakeCalls: unit => array<_stakeCall> = () => {
    checkForExceptions(~functionName="_stake")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._stakeMock.calls")
      array->Array.map(((token, amount, user)) => {
        {
          token: token,
          amount: amount,
          user: user,
        }
      })
    })
    ->Option.getExn
  }

  let mock_withdrawToReturn: unit => unit = () => {
    checkForExceptions(~functionName="_withdraw")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._withdrawMock.will.return()")
    })
  }

  type _withdrawCall = {
    token: Ethers.ethAddress,
    amount: Ethers.BigNumber.t,
  }

  let _withdrawCalls: unit => array<_withdrawCall> = () => {
    checkForExceptions(~functionName="_withdraw")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._withdrawMock.calls")
      array->Array.map(((token, amount)) => {
        {
          token: token,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mockWithdrawToReturn: unit => unit = () => {
    checkForExceptions(~functionName="withdraw")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.withdrawMock.will.return()")
    })
  }

  type withdrawCall = {
    token: Ethers.ethAddress,
    amount: Ethers.BigNumber.t,
  }

  let withdrawCalls: unit => array<withdrawCall> = () => {
    checkForExceptions(~functionName="withdraw")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.withdrawMock.calls")
      array->Array.map(((token, amount)) => {
        {
          token: token,
          amount: amount,
        }
      })
    })
    ->Option.getExn
  }

  let mockWithdrawAllToReturn: unit => unit = () => {
    checkForExceptions(~functionName="withdrawAll")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.withdrawAllMock.will.return()")
    })
  }

  type withdrawAllCall = {token: Ethers.ethAddress}

  let withdrawAllCalls: unit => array<withdrawAllCall> = () => {
    checkForExceptions(~functionName="withdrawAll")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.withdrawAllMock.calls")
      array->Array.map(_m => {
        let token = _m->Array.getUnsafe(0)

        {
          token: token,
        }
      })
    })
    ->Option.getExn
  }

  let mockOnlyAdminToReturn: unit => unit = () => {
    checkForExceptions(~functionName="onlyAdmin")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.onlyAdminMock.will.return()")
    })
  }

  type onlyAdminCall

  let onlyAdminCalls: unit => array<onlyAdminCall> = () => {
    checkForExceptions(~functionName="onlyAdmin")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.onlyAdminMock.calls")
      array->Array.map(() => {
        ()->Obj.magic
      })
    })
    ->Option.getExn
  }

  let mockOnlyValidSyntheticToReturn: unit => unit = () => {
    checkForExceptions(~functionName="onlyValidSynthetic")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.onlyValidSyntheticMock.will.return()")
    })
  }

  type onlyValidSyntheticCall = {synth: Ethers.ethAddress}

  let onlyValidSyntheticCalls: unit => array<onlyValidSyntheticCall> = () => {
    checkForExceptions(~functionName="onlyValidSynthetic")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.onlyValidSyntheticMock.calls")
      array->Array.map(_m => {
        let synth = _m->Array.getUnsafe(0)

        {
          synth: synth,
        }
      })
    })
    ->Option.getExn
  }

  let mockOnlyValidMarketToReturn: unit => unit = () => {
    checkForExceptions(~functionName="onlyValidMarket")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.onlyValidMarketMock.will.return()")
    })
  }

  type onlyValidMarketCall = {marketIndex: int}

  let onlyValidMarketCalls: unit => array<onlyValidMarketCall> = () => {
    checkForExceptions(~functionName="onlyValidMarket")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.onlyValidMarketMock.calls")
      array->Array.map(_m => {
        let marketIndex = _m->Array.getUnsafe(0)

        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }

  let mockOnlyFloatToReturn: unit => unit = () => {
    checkForExceptions(~functionName="onlyFloat")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.onlyFloatMock.will.return()")
    })
  }

  type onlyFloatCall

  let onlyFloatCalls: unit => array<onlyFloatCall> = () => {
    checkForExceptions(~functionName="onlyFloat")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.onlyFloatMock.calls")
      array->Array.map(() => {
        ()->Obj.magic
      })
    })
    ->Option.getExn
  }
}
