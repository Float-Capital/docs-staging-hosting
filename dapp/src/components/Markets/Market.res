@react.component
let make = (~marketData: Queries.SyntheticMarketInfo.t) => {
  <div>
    <Next.Link href="/app/markets">
      <div className="uppercase text-sm text-gray-600 hover:text-gray-500 cursor-pointer mb-4">
        {`◀`->React.string} <span className="text-xs"> {" Back to markets"->React.string} </span>
      </div>
    </Next.Link>
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
      <div
        className="flex flex-col md:flex-row justify-center items-stretch col-span-1 md:col-span-3">
        <MarketInteractionCard />
        <div
          className="flex-1 w-full min-h-10 p-1 mx:0 mt-4 md:mt-0 md:ml-4 rounded-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
          <PriceGraph
            timestampCreated={marketData.timestampCreated}
            marketName={marketData.name}
            oracleAddress={marketData.oracleAddress}
            oracleDecimals={(
              marketData.marketIndex->Ethers.BigNumber.toNumber->Backend.getMarketInfoUnsafe
            ).oracleDecimals}
          />
        </div>
      </div>
      <MarketInfoCard marketIndex={marketData.marketIndex->Ethers.BigNumber.toNumber} />
      <div className="w-full col-span-1 md:col-span-2">
        <MarketStakeCard key={marketData.name} syntheticMarket=marketData />
      </div>
    </div>
  </div>
}
