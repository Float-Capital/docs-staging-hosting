module InternalMock = {
  let mockContractName = "LongShortForInternalMocking"
  type t = {address: Ethers.ethAddress}

  let internalRef: ref<option<t>> = ref(None)

  let functionToNotMock: ref<string> = ref("")

  @module("@eth-optimism/smock") external smock: 'a => Js.Promise.t<t> = "smockit"

  let setup: LongShort.t => JsPromise.t<ContractHelpers.transaction> = longShort => {
    ContractHelpers.deployContract0("LongShortForInternalMocking")
    ->JsPromise.then(a => {
      smock(a)
    })
    ->JsPromise.then(b => {
      internalRef := Some(b)
      longShort->LongShort.Exposed.setMocker(~mocker=(b->Obj.magic).address)
    })
  }

  let setupFunctionForUnitTesting = (longShort, ~functionName) => {
    functionToNotMock := functionName
    longShort->LongShort.Exposed.setFunctionToNotMock(~functionToNotMock=functionName)
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

  let mock_changeFeesToReturn = () => {
    checkForExceptions(~functionName="_changeFees")
    let _ = internalRef.contents->Option.map(_r => {
      let _ = %raw("_r.smocked._changeFeesMock.will.return()")
    })
  }

  let mockadminOnlyToReturn = () => {
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
      array
    })
    ->Option.getExn
  }

  type changeFeeCall = {
    marketIndex: int,
    _baseEntryFee: Ethers.BigNumber.t,
    _badLiquidityEntryFee: Ethers.BigNumber.t,
    _baseExitFee: Ethers.BigNumber.t,
    _badLiquidityExitFee: Ethers.BigNumber.t,
  }

  let _changeFeeCalls: unit => array<changeFeeCall> = () => {
    checkForExceptions(~functionName="_changeFees")
    internalRef.contents
    ->Option.map(_r => {
      let array = %raw("_r.smocked._changeFeesMock.calls")
      array->Array.map(((
        marketIndex,
        _baseEntryFee,
        _baseExitFee,
        _badLiquidityEntryFee,
        _badLiquidityExitFee,
      )) => {
        {
          marketIndex: marketIndex,
          _baseEntryFee: _baseEntryFee,
          _badLiquidityEntryFee: _badLiquidityEntryFee,
          _baseExitFee: _baseExitFee,
          _badLiquidityExitFee: _badLiquidityExitFee,
        }
      })
    })
    ->Option.getExn
  }
}
