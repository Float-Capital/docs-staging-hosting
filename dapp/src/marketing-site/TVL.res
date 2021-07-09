@react.component
let make = () => {
  let marketDetailsQuery = Queries.MarketDetails.use()
  <div
    className="fixed bottom-3 left-3 flex flex-col items-end invisible md:visible bg-white bg-opacity-75 rounded-lg shadow-lg px-2 py-1">
    {switch marketDetailsQuery {
    | {loading: true} => <Loader.Tiny />
    | {error: Some(_error)} =>
      <span className="text-xs"> {"Error Loading TVL"->React.string} </span>
    | {data: Some({syntheticMarkets})} => {
        let {totalValueLocked, _} = StatsCalcs.getTotalValueLockedAndTotalStaked(syntheticMarkets)
        <div className="text-sm flex flex-row items-center">
          <span> {`TVL: `->React.string} </span>
          <img src="/icons/dollar-coin.png" className="h-6 mx-1" />
          <span> {totalValueLocked->Misc.NumberFormat.formatEther->React.string} </span>
        </div>
      }
    | _ => <> {""->React.string} </>
    }}
  </div>
}
