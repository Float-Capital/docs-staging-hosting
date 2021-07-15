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
    Globals.percentStr(~n=totalLockedShort, ~outOf=totalLockedLong)
  } else if !isLong && totalLockedLong->Ethers.BigNumber.lt(totalLockedShort) {
    Globals.percentStr(~n=totalLockedLong, ~outOf=totalLockedShort)
  } else {
    "100"
  }
}

let marketPositionHeadings = (~isLong) =>
  <div className="flex flex-col items-center justify-center">
    <div className="pt-2 mt-auto">
      <h3 className="text-xs mt-1">
        <span className="font-bold"> {isLong ? "LONG"->React.string : "SHORT"->React.string} </span>
        {" Liquidity"->React.string}
      </h3>
    </div>
  </div>

let marketPositionValues = (
  ~marketName,
  ~isLong,
  ~totalLockedLong,
  ~totalLockedShort,
  ~totalValueLocked,
) => {
  let longBeta = calculateBeta(~totalLockedLong, ~totalLockedShort, ~totalValueLocked, ~isLong=true)

  let shortBeta = calculateBeta(
    ~totalLockedLong,
    ~totalLockedShort,
    ~totalValueLocked,
    ~isLong=false,
  )
  let value = (isLong ? totalLockedLong : totalLockedShort)->Misc.NumberFormat.formatEther
  let beta = isLong ? longBeta : shortBeta
  <div className="text-sm text-center m-auto mb-4">
    <div className="text-2xl tracking-widest font-vt323 my-3"> {`\$${value}`->React.string} </div>
    <span className="font-bold"> {`Exposure `->React.string} </span>
    <Tooltip
      tip={`The impact ${marketName} price movements have on ${isLong ? "long" : "short"} value`}
    />
    <span className="font-bold"> {`: `->React.string} </span>
    {`${beta}%`->React.string}
  </div>
}

let mintButtons = (~marketIndex) => {
  let router = Next.Router.useRouter()
  <div className={`flex w-full justify-around`}>
    <Button.Small
      onClick={event => {
        ReactEvent.Mouse.preventDefault(event)
        router->Next.Router.pushShallow(
          `/app/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}&actionOption=long`,
        )
      }}>
      "Mint Long"
    </Button.Small>
    <Button.Small
      onClick={event => {
        ReactEvent.Mouse.preventDefault(event)
        router->Next.Router.pushShallow(
          `/app/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}&actionOption=short`,
        )
      }}>
      "Mint Short"
    </Button.Small>
  </div>
}

let liquidityRatio = (~totalValueLocked, ~totalLockedLong) =>
  <div className={`w-full`}>
    {switch !(totalValueLocked->Ethers.BigNumber.eq(CONSTANTS.zeroBN)) {
    | true => <MarketBar totalLockedLong totalValueLocked />
    | false => React.null
    }}
  </div>

@react.component
let make = (
  ~marketData as {
    name: marketName,
    marketIndex,
    latestSystemState: {totalLockedLong, totalLockedShort, totalValueLocked},
  }: Queries.SyntheticMarketInfo.t,
) => {
  <Next.Link href={`/app/markets?marketIndex=${marketIndex->Ethers.BigNumber.toString}`}>
    <div
      className="p-1 rounded-lg flex flex-col bg-white bg-opacity-75 hover:bg-opacity-60 cursor-pointer shadow-lg hover:shadow-xl h-full justify-center w-full">
      <div className="flex justify-center w-full my-1">
        <h1 className="font-bold text-xl font-vt323 cursor-pointer hover:underline">
          {marketName->React.string}
        </h1>
      </div>
      <div className="flex flex-wrap justify-center w-full">
        <div
          className="order-2 md:order-1 w-1/2 md:w-1/4 flex items-center flex grow flex-wrap flex-col">
          {marketPositionHeadings(~isLong={true})}
          <div className="md:block hidden">
            {marketPositionValues(
              ~marketName,
              ~totalLockedLong,
              ~totalLockedShort,
              ~totalValueLocked,
              ~isLong={true},
            )}
          </div>
        </div>
        <div className="order-1 md:order-2 w-full md:w-1/2 flex items-center flex-col">
          <h2 className="text-xs mt-1">
            <span className="font-bold"> {"TOTAL"->React.string} </span>
            {" Liquidity"->React.string}
          </h2>
          <div className="text-3xl font-vt323 tracking-wider py-1">
            {`$${totalValueLocked->Misc.NumberFormat.formatEther}`->React.string}
          </div>
          <div className="md:block hidden w-full">
            {liquidityRatio(~totalValueLocked, ~totalLockedLong)} {mintButtons(~marketIndex)}
          </div>
        </div>
        <div className="order-3 w-1/2 md:w-1/4 flex-grow flex-wrap flex-col">
          {marketPositionHeadings(~isLong={false})}
          <div className="md:block hidden">
            {marketPositionValues(
              ~marketName,
              ~totalLockedLong,
              ~totalLockedShort,
              ~totalValueLocked,
              ~isLong={false},
            )}
          </div>
        </div>
      </div>
      <div className="block md:hidden pt-5">
        <div className="px-8"> {liquidityRatio(~totalValueLocked, ~totalLockedLong)} </div>
        <div className="flex md:hidden">
          {marketPositionValues(
            ~marketName,
            ~totalLockedLong,
            ~totalLockedShort,
            ~totalValueLocked,
            ~isLong={true},
          )}
          {marketPositionValues(
            ~marketName,
            ~totalLockedLong,
            ~totalLockedShort,
            ~totalValueLocked,
            ~isLong={false},
          )}
        </div>
        {mintButtons(~marketIndex)}
      </div>
    </div>
  </Next.Link>
}

module Mini = {
  @react.component
  let make = (
    ~marketData as {
      name: marketName,
      marketIndex,
      latestSystemState: {totalLockedLong, totalValueLocked},
    }: Queries.SyntheticMarketInfo.t,
  ) => {
    let router = Next.Router.useRouter()

    <div className="w-2/3">
      <Next.Link href={`/app/markets?marketIndex=${marketIndex->Ethers.BigNumber.toString}`}>
        <div
          className="p-1 rounded-sm flex flex-col bg-white bg-opacity-75 hover:bg-opacity-60 custom-cursor shadow-lg hover:shadow-xl h-full justify-center w-full">
          <div className="flex justify-center w-full my-1">
            <h1 className="font-bold text-xl font-vt323 uppercase custom-cursor hover:underline">
              {marketName->React.string}
            </h1>
          </div>
          <div className="flex flex-wrap justify-center w-full">
            <div className="order-2  w-1/2  flex items-center flex grow flex-wrap flex-col">
              {marketPositionHeadings(~isLong={true})}
            </div>
            <div className="order-1  w-full  flex items-center flex-col">
              <h2 className="text-xs mt-1">
                <span className="font-bold"> {"TOTAL"->React.string} </span>
                {" Liquidity"->React.string}
              </h2>
              <div className="text-3xl font-vt323 tracking-wider py-1">
                {`$${totalValueLocked->Misc.NumberFormat.formatEther}`->React.string}
              </div>
            </div>
            <div className="order-3 w-1/2 flex-grow flex-wrap flex-col">
              {marketPositionHeadings(~isLong={false})}
            </div>
          </div>
          <div className="block pt-5">
            <div className="px-8"> {liquidityRatio(~totalValueLocked, ~totalLockedLong)} </div>
            <div className={`flex w-full justify-around`}>
              <Button.Tiny
                onClick={event => {
                  ReactEvent.Mouse.preventDefault(event)
                  router->Next.Router.pushShallow(
                    `/app/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}&actionOption=long`,
                  )
                }}>
                "Mint Long"
              </Button.Tiny>
              <Button.Tiny
                onClick={event => {
                  ReactEvent.Mouse.preventDefault(event)
                  router->Next.Router.pushShallow(
                    `/app/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}&actionOption=short`,
                  )
                }}>
                "Mint Short"
              </Button.Tiny>
            </div>
          </div>
        </div>
      </Next.Link>
    </div>
  }
}
