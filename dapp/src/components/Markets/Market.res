@react.component
let make = (~marketData) => {
  <div>
    <Next.Link href="/markets">
      <div className="uppercase text-sm text-gray-600 hover:text-gray-500 cursor-pointer mt-2">
        {`◀`->React.string} <span className="text-xs"> {" Back to markets"->React.string} </span>
      </div>
    </Next.Link>
    <MarketCard marketData />
    <div className="flex flex-col md:flex-row justify-center items-stretch">
      <div
        className="flex-1 w-full min-h-10 p-1 mb-8 mr-8 rounded-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
        <PriceGraph marketName={marketData.name} />
      </div>
      <div className="flex-1  p-1 mb-8 rounded-lg flex flex-col bg-white bg-opacity-70 shadow-lg">
        <Mint.Mint />
      </div>
    </div>
  </div>
}
