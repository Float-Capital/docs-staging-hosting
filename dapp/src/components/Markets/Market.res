@react.component
let make = (~marketData: Queries.SyntheticMarketInfo.t) => {
  <div>
    <Next.Link href="/markets">
      <div className="uppercase text-sm text-gray-600 hover:text-gray-500 cursor-pointer my-2">
        {`◀`->React.string} <span className="text-xs"> {" Back to markets"->React.string} </span>
      </div>
    </Next.Link>
    <div className="flex flex-col md:flex-row justify-center items-stretch">
      <MarketInteractionCard />
      <div
        className="flex-1 w-full min-h-10 p-1 mb-2 ml-8 rounded-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
        <PriceGraph
          timestampCreated={marketData.timestampCreated}
          marketName={marketData.name}
          oracleAddress={marketData.oracleAddress}
        />
      </div>
    </div>
    <MarketCard marketData />
  </div>
}
