module SystemUpdateTxState = {
  @react.component
  let make = (~txState, ~updateSystemStateCall, ~refetchCallback) => {
    <div className="flex flex-row items-center">
      {switch txState {
      | ContractActions.Created => <Loader.Ellipses />
      | SignedAndSubmitted(_) => <Loader.Mini />
      | Complete(_) => {
          refetchCallback(_ => 1.)
          <p className="text-xxxxs text-right text-green-500 "> {`✅ Success`->React.string} </p>
        }
      | Failed(_) =>
        <p className="text-xxxxs text-right text-red-500 "> {`Update tx failed`->React.string} </p>
      | _ =>
        <div>
          <p className="text-xxxxs text-right text-yellow-500 ">
            {`⚠️ Keeper down ⚠️`->React.string}
          </p>
          <Button.Tiny onClick={_ => updateSystemStateCall()}> {"Update Price"} </Button.Tiny>
        </div>
      }}
    </div>
  }
}

module PendingBarInner = {
  @react.component
  let make = (
    ~lastOracleUpdateTimestamp,
    ~oracleHeartbeat,
    ~now,
    ~txState,
    ~updateSystemStateCall,
    ~refetchCallback,
  ) => {
    React.useEffect1(() => {
      let earlyEdgeCaseTimeOffset = 20
      if (
        lastOracleUpdateTimestamp->Ethers.BigNumber.toNumber +
        oracleHeartbeat -
        earlyEdgeCaseTimeOffset > now->Belt.Int.fromFloat
      ) {
        refetchCallback(_ => now)
      }
      None
    }, [now])

    <div className="flex flex-row justify-between text-xxxs">
      <div className="flex flex-row justify-start items-center">
        <p className="text-gray"> {"Previous"->React.string} <br /> {"update"->React.string} </p>
        <p className="text-xs ml-2">
          {Js.Date.fromFloat(lastOracleUpdateTimestamp->Ethers.BigNumber.toNumberFloat *. 1000.)
          ->DateFns.format(#"HH:mm:ss")
          ->React.string}
        </p>
      </div>
      {
        let estimatedNextUpdateTimestamp =
          lastOracleUpdateTimestamp->Ethers.BigNumber.toNumber + oracleHeartbeat
        if estimatedNextUpdateTimestamp >= now->Belt.Int.fromFloat {
          <div className="flex flex-row justify-end items-center">
            <p className="text-xs mr-2">
              <CountDown endDateTimestamp={estimatedNextUpdateTimestamp} displayUnits=true />
            </p>
            <p className="text-gray text-right">
              {"Est next"->React.string} <br /> {"update"->React.string}
            </p>
          </div>
        } else {
          let twoMinutes = 10 // TODO: make two min or maybe 1 min - base on box and wiskr plot
          let anUnreasonablyLongWait =
            estimatedNextUpdateTimestamp + twoMinutes > now->Belt.Int.fromFloat
          if anUnreasonablyLongWait {
            <div className="flex flex-col justify-center">
              <div className="mx-auto text-xs"> <Loader.Tiny /> </div>
              <p className="text-xxxxs">
                {"checking for"->React.string} <br /> {"price update"->React.string}
              </p>
            </div>
          } else {
            <SystemUpdateTxState txState updateSystemStateCall refetchCallback />
          }
        }
      }
    </div>
  }
}

module PendingBarWrapper = {
  @react.component
  let make = (~marketIndex, ~signer, ~refetchCallback) => {
    let lastOracleTimestamp = DataHooks.useOracleLastUpdate(
      ~marketIndex=marketIndex->Ethers.BigNumber.toString,
    )

    let oracleHeartbeat = Backend.getMarketInfoUnsafe(
      marketIndex->Ethers.BigNumber.toNumber,
    ).oracleHeartbeat

    let (contractExecutionHandler, txState, _setTxState) = ContractActions.useContractFunction(
      ~signer,
    )

    let updateSystemStateCall = _ => {
      let longShortContract = Contracts.LongShort.make(~address=Config.longShort)
      contractExecutionHandler(
        ~makeContractInstance=longShortContract,
        ~contractFunction=Contracts.LongShort.updateSystemStateMulti(~marketIndexes=[marketIndex]),
      )
    }

    let (now, setNow) = React.useState(_ => Js.Date.now() /. 1000.)

    let _ = Refetchers.useRefetchLastOracleTimestamp(~marketIndex, ~stateForRefetchExecution=now)

    // used to ensure state updates every second for time based conditional checks
    let _ = Misc.Time.useInterval(_ => setNow(_ => Js.Date.now() /. 1000.), ~delay=1000)

    {
      <div className="relative pt-1">
        <div className="text-xxs text-center mx-4 text-gray-600">
          {`Your transaction will be processed with the next price update `->React.string}
          <Tooltip
            tip="To ensure fairness and security your position will be opened on the next oracle price update"
          />
        </div>
        {switch lastOracleTimestamp {
        | Response(lastOracleUpdateTimestamp) =>
          <PendingBarInner
            lastOracleUpdateTimestamp
            oracleHeartbeat
            now
            txState
            updateSystemStateCall
            refetchCallback
          />

        | GraphError(error) => <p className="text-xxxxs"> {error->React.string} </p>
        | Loading => <Loader.Tiny />
        }}
        <div className={`w-full mx-auto my-1`}>
          <div className="pending-bar-container"> <span className="pending-bar" /> </div>
        </div>
      </div>
    }
  }
}

@react.component
let make = (~marketIndex, ~refetchCallback) => {
  // TODO pass market index (es)
  let signer = ContractActions.useSignerExn()

  <PendingBarWrapper signer marketIndex refetchCallback />
}
