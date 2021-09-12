@react.component
let make = (~marketIndex=CONSTANTS.oneBN) => {
  let lastOracleTimestamp = DataHooks.useOracleLastUpdate(
    ~marketIndex=marketIndex->Ethers.BigNumber.toString,
  )

  {
    <div className="relative pt-1">
      <div className="text-xxs text-center mx-4">
        {`Your transaction will be processed with the next price update `->React.string}
        <Tooltip
          tip="To ensure fairness and security your position will be opened on the next oracle price update"
        />
      </div>
      <div className="flex flex-row justify-between text-xxxs">
        <div className="flex flex-row justify-start items-center">
          <p className="text-gray"> {"Previous"->React.string} <br /> {"update"->React.string} </p>
          <p className="text-sm ml-2"> {"11:14:32"->React.string} </p>
          {switch lastOracleTimestamp {
          | Response(lastOracleUpdateTimestamp) =>
            <p className="text-sm ml-2">
              {DateFns.formatRelative(
                Js.Date.fromFloat(lastOracleUpdateTimestamp->Ethers.BigNumber.toNumberFloat),
                Js.Date.fromFloat(Js.Date.now()),
              )->React.string}
            </p>
          | GraphError(error) => <p className="text-xxxxs"> {error->React.string} </p>
          | Loading => <Loader.Tiny />
          }}
        </div>
        <div className="flex flex-row justify-end items-center">
          <p className="text-sm mr-2"> {"3min 12seconds"->React.string} </p>
          <p className="text-gray">
            {"Estimated"->React.string} <br /> {"next update"->React.string}
          </p>
        </div>
      </div>
      <div className={`w-full mx-auto my-1`}>
        <div className="pending-bar-container"> <span className="pending-bar" /> </div>
      </div>
    </div>
  }
}
