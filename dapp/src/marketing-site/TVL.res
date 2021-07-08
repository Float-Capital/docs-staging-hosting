@react.component
let make = () => {
  let marketDetailsQuery = Queries.MarketDetails.use()
  switch marketDetailsQuery {
  | {loading: true} => <Loader.Mini />
  | {error: Some(_error)} => <> {"Error Loading TVL"->React.string} </>
  | {data: Some({syntheticMarkets})} => {
      let {totalValueLocked, _} = StatsCalcs.getTotalValueLockedAndTotalStaked(syntheticMarkets)
      <div
        className="fixed bottom-3 left-3 flex flex-col items-end invisible md:visible bg-white bg-opacity-75 rounded-lg shadow-lg px-2 py-1">
        <div className="text-sm cursor-pointer">
          {`TVL: $${totalValueLocked->Misc.NumberFormat.formatEther}`->React.string}
        </div>
      </div>
    }
  | _ => <> {""->React.string} </>
  }
}
