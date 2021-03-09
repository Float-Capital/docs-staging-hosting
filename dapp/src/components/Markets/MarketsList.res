let percentStr = (~n: Ethers.BigNumber.t, ~outOf: Ethers.BigNumber.t) =>
  if outOf->Ethers.BigNumber.eq(CONSTANTS.zeroBN) {
    "0.00"
  } else {
    n
    ->Ethers.BigNumber.mul(CONSTANTS.oneHundredEth)
    ->Ethers.BigNumber.div(outOf)
    ->Ethers.Utils.formatEtherToPrecision(2)
  }

let calculateBeta = (
  ~totalValueLocked: Ethers.BigNumber.t,
  ~totalLockedLong,
  ~totalLockedShort,
  ~isLong,
) => {
  if (
    totalValueLocked->Ethers.BigNumber.eq(CONSTANTS.zeroBN) ||
    totalLockedLong->Ethers.BigNumber.eq(CONSTANTS.zeroBN) ||
    totalLockedShort->Ethers.BigNumber.eq(CONSTANTS.zeroBN)
  ) {
    "0"
  } else if totalLockedLong->Ethers.BigNumber.eq(totalLockedShort) {
    "100"
  } else if isLong && totalLockedShort->Ethers.BigNumber.lt(totalLockedLong) {
    percentStr(~n=totalLockedShort, ~outOf=totalLockedLong)
  } else if !isLong && totalLockedLong->Ethers.BigNumber.lt(totalLockedShort) {
    percentStr(~n=totalLockedLong, ~outOf=totalLockedShort)
  } else {
    "100"
  }
}

module MarketCard = {
  @react.component
  let make = (
    ~marketData as {
      name: marketName,
      marketIndex,
      latestSystemState: {totalLockedLong, totalLockedShort, totalValueLocked},
    }: Queries.MarketDetails.t_syntheticMarkets,
  ) => {
    let router = Next.Router.useRouter()
    let percentStrLong = percentStr(~n=totalLockedLong, ~outOf=totalValueLocked)
    let percentStrShort =
      (100.0 -. percentStrLong->Float.fromString->Option.getExn)
        ->Js.Float.toFixedWithPrecision(~digits=2)

    let longBeta = calculateBeta(
      ~totalLockedLong,
      ~totalLockedShort,
      ~totalValueLocked,
      ~isLong=true,
    )

    let shortBeta = calculateBeta(
      ~totalLockedLong,
      ~totalLockedShort,
      ~totalValueLocked,
      ~isLong=false,
    )

    let mintButtons = () => <>
      <Button
        onClick={_ => {
          router->Next.Router.push(
            `/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}&mintOption=long`,
          )
        }}
        variant="small">
        "Mint Long"
      </Button>
      <Button
        onClick={_ => {
          router->Next.Router.push(
            `/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}&mintOption=short`,
          )
        }}
        variant="small">
        "Mint Short"
      </Button>
    </>

    <div className="p-1 mb-8 rounded-lg flex flex-col bg-white bg-opacity-75 my-5 shadow-lg">
      <div className="flex justify-center w-full my-1">
        <h1 className="font-bold text-xl font-alphbeta">
          {marketName->React.string} <Tooltip tip={`This market tracks ${marketName}`} />
        </h1>
      </div>
      <div className="flex flex-wrap justify-center w-full">
        <div
          className="order-2 md:order-1 w-1/2 md:w-1/4 flex items-center flex grow flex-wrap flex-col">
          <MarketCardSide
            marketName={marketName} isLong={true} value={totalLockedLong} beta={longBeta}
          />
        </div>
        <div className="order-1 md:order-2 w-full md:w-1/2 flex items-center flex-col">
          <h2 className="text-xs mt-1">
            <span className="font-bold"> {"TOTAL"->React.string} </span>
            {" Liquidity"->React.string}
          </h2>
          <div className="text-3xl font-alphbeta tracking-wider py-1">
            {`$${totalValueLocked->FormatMoney.formatEther}`->React.string}
          </div>
          {switch !(totalValueLocked->Ethers.BigNumber.eq(CONSTANTS.zeroBN)) {
          | true => <MarketBar percentStrLong={percentStrLong} percentStrShort={percentStrShort} />
          | false => React.null
          }}
          <div className="hidden md:flex w-full justify-around"> {mintButtons()} </div>
        </div>
        <div className="order-3 w-1/2 md:w-1/4 flex items-center flex-grow flex-wrap flex-col">
          <MarketCardSide
            marketName={marketName} isLong={false} value={totalLockedShort} beta={shortBeta}
          />
        </div>
      </div>
      <div className="flex md:hidden justify-around"> {mintButtons()} </div>
    </div>
  }
}

module MarketsList = {
  @react.component
  let make = () => {
    let marketDetailsQuery = Queries.MarketDetails.use()

    <div className="w-full max-w-4xl mx-auto">
      {switch marketDetailsQuery {
      | {loading: true} => <div className="m-auto"> <MiniLoader /> </div>
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({syntheticMarkets})} => <>
          {syntheticMarkets
          ->Array.map(marketData => <MarketCard key={marketData.name} marketData />)
          ->React.array}
        </>
      | {data: None, error: None, loading: false} => ""->React.string
      }}
    </div>
  }
}

let default = () => <MarketsList />
