@react.component
let make = () => {
  let tvlQuery = Queries.TVL.use()

  {
    switch tvlQuery {
    | {loading: true} => <Loader.Tiny />
    | {error: Some(_error)} =>
      <div
        className="fixed bottom-3 left-3 flex flex-col items-end invisible md:visible bg-white bg-opacity-75 rounded-lg shadow-lg px-2 py-1">
        <span className="text-xxs"> {"Error loading TVL"->React.string} </span>
      </div>
    | {data: Some({globalState: Some({totalValueLocked})})} =>
      if totalValueLocked->Ethers.BigNumber.gte(CONSTANTS.fiftyThousandInWei) {
        <div
          className="fixed bottom-3 left-3 flex flex-col items-end invisible md:visible bg-white bg-opacity-75 rounded-lg shadow-lg px-2 py-1">
          <div className="text-sm flex flex-row items-center">
            <span> {`TVL: $`->React.string} </span>
            <span className="font-bold">
              {totalValueLocked->Misc.NumberFormat.formatEther->React.string}
            </span>
            <img src="/icons/dollar-coin.png" className="h-6 mx-1" />
          </div>
        </div>
      } else {
        React.null
      }

    | _ => <> {""->React.string} </>
    }
  }
}
