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

  let setupFunctionForUnitTesting = (staker, ~functionName) => {
    functionToNotMock := functionName
    staker->Staker.Exposed.setFunctionToNotMock(~functionToNotMock=functionName)
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

  let mock_changeMarketLaunchIncentiveParametersToReturn = () => {
    checkForExceptions(~functionName="_changeMarketLaunchIncentiveParameters")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._changeMarketLaunchIncentiveParametersMock.will.return()")
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
      array->Array.map((_) => ()->Obj.magic)
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
}
