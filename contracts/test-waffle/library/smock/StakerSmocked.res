type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: Staker.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

@get @scope(("smocked", "addNewStakingFund"))
external addNewStakingFundCallsExternal: t => array<(
  int,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.BigNumber.t,
  Ethers.BigNumber.t,
)> = "calls"

type addNewStakingFundCall = {
  marketIndex: int,
  longToken: Ethers.ethAddress,
  shortToken: Ethers.ethAddress,
  kInitialMultiplier: Ethers.BigNumber.t,
  kPeriod: Ethers.BigNumber.t,
}

let mockaddNewStakingFundToReturn: t => unit = %raw(
  "t => t.smocked.addNewStakingFund.will.return()"
)

let addNewStakingFundCalls = smocked => {
  smocked
  ->addNewStakingFundCallsExternal
  ->Array.map(((m, l, s, kI, kP)) => {
    marketIndex: m,
    longToken: l,
    shortToken: s,
    kInitialMultiplier: kI,
    kPeriod: kP,
  })
}

module InternalMock = {
  let mockContractName = "StakerForInternalMocking"
  type t = {address: Ethers.ethAddress}

  let internalRef: ref<option<t>> = ref(None)

  let functionToNotMock: ref<string> = ref("")

  @module("@eth-optimism/smock") external smock: 'a => Js.Promise.t<t> = "smockit"

  let setup: Staker.t => JsPromise.t<ContractHelpers.transaction> = staker => {
    ContractHelpers.deployContract0(mockContractName)
    ->JsPromise.then(a => {
      smock(a)
    })
    ->JsPromise.then(b => {
      internalRef := Some(b)
      staker->Staker.Exposed.setMocker(~mocker=(b->Obj.magic).address)
    })
  }

  let setFunctionForUnitTesting = (staker, ~functionName) => {
    functionToNotMock := functionName
    staker->Staker.Exposed.setFunctionToNotMock(~functionToNotMock=functionName)
  }

  let setupFunctionForUnitTesting = (staker, ~functionName) => {
    ContractHelpers.deployContract0(mockContractName)
    ->JsPromise.then(a => {
      smock(a)
    })
    ->JsPromise.then(b => {
      internalRef := Some(b)
      [
        staker->Staker.Exposed.setMocker(~mocker=(b->Obj.magic).address),
        staker->Staker.Exposed.setFunctionToNotMock(~functionToNotMock=functionName),
      ]->JsPromise.all
    })
  }

  exception MockingAFunctionThatYouShouldntBe

  exception HaventSetupInternalMockingForStaking

  let checkForExceptions = (~functionName) => {
    if functionToNotMock.contents == functionName {
      raise(MockingAFunctionThatYouShouldntBe)
    }
    if internalRef.contents == None {
      raise(HaventSetupInternalMockingForStaking)
    }
  }

  let mock_changeMarketLaunchIncentiveParametersToReturn = () => {
    checkForExceptions(~functionName="_changeMarketLaunchIncentiveParameters")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._changeMarketLaunchIncentiveParametersMock.will.return()")
    })
  }

  let mockgetMarketLaunchIncentiveParametersToReturn = (
    ~_period: Ethers.BigNumber.t,
    ~_multiplier: Ethers.BigNumber.t,
  ) => {
    checkForExceptions(~functionName="getMarketLaunchIncentiveParameters")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw(
        "_r.smocked.getMarketLaunchIncentiveParametersMock.will.return.with([_period, _multiplier])"
      )
    })
  }

  let mockonlyFloatToReturn = () => {
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
      array->Array.map(_ => ()->Obj.magic)
    })
    ->Option.getExn
  }

  let mockonlyAdminToReturn = () => {
    checkForExceptions(~functionName="onlyAdmin")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked.onlyAdminMock.will.return()")
    })
  }

  type onlyAdminCall

  let onlyAdminCalls: unit => array<onlyAdminCall> = () => {
    checkForExceptions(~functionName="admin")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.onlyAdminMock.calls")
      array->Array.map(_ => ()->Obj.magic)
    })
    ->Option.getExn
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

  type getMarketLaunchIncentiveParametersCall = {marketIndex: int}

  let getMarketLaunchIncentiveParametersCalls: unit => array<
    getMarketLaunchIncentiveParametersCall,
  > = () => {
    checkForExceptions(~functionName="getMarketLaunchIncentiveParameters")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked.getMarketLaunchIncentiveParametersMock.calls")
      array->Array.map(m => {
        let marketIndex = m->Array.getExn(0)
        {
          marketIndex: marketIndex,
        }
      })
    })
    ->Option.getExn
  }
}
