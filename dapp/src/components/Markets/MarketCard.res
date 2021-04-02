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

@react.component
let make = (
  ~marketData as {
    name: marketName,
    marketIndex,
    latestSystemState: {totalLockedLong, totalLockedShort, totalValueLocked},
  }: Queries.MarketDetails.t_syntheticMarkets,
) => {
  let router = Next.Router.useRouter()
  let marketIndexOption = router.query->Js.Dict.get("marketIndex")
  let percentStrLong = percentStr(~n=totalLockedLong, ~outOf=totalValueLocked)
  let percentStrShort =
    (100.0 -. percentStrLong->Float.fromString->Option.getExn)
      ->Js.Float.toFixedWithPrecision(~digits=2)

  let longBeta = calculateBeta(~totalLockedLong, ~totalLockedShort, ~totalValueLocked, ~isLong=true)

  let shortBeta = calculateBeta(
    ~totalLockedLong,
    ~totalLockedShort,
    ~totalValueLocked,
    ~isLong=false,
  )

  let marketPositionHeadings = (~isLong) =>
    <div className="flex flex-col items-center justify-center">
      <h2 className="font-bold text-sm">
        {marketName->React.string}
        <span className="text-xs">
          {isLong ? `↗️`->React.string : `↘️`->React.string}
        </span>
      </h2>
      <div className="pt-2 mt-auto">
        <h3 className="text-xs mt-1">
          <span className="font-bold">
            {isLong ? "LONG"->React.string : "SHORT"->React.string}
          </span>
          {" Liquidity"->React.string}
        </h3>
      </div>
    </div>

  let marketPositionValues = (~isLong) => {
    let value = (isLong ? totalLockedLong : totalLockedShort)->FormatMoney.formatEther
    let beta = isLong ? longBeta : shortBeta
    <div className="text-sm text-center m-auto mb-4">
      <div className="text-2xl tracking-widest font-alphbeta my-3">
        {`$${value}`->React.string}
      </div>
      <span className="font-bold"> {`Exposure `->React.string} </span>
      <Tooltip
        tip={`The impact ${marketName} price movements have on ${isLong ? "long" : "short"} value`}
      />
      <span className="font-bold"> {`: `->React.string} </span>
      {`${beta}%`->React.string}
    </div>
  }

  let liquidityRatio = () =>
    <div className={`w-full`}>
      {switch !(totalValueLocked->Ethers.BigNumber.eq(CONSTANTS.zeroBN)) {
      | true => <MarketBar percentStrLong={percentStrLong} percentStrShort={percentStrShort} />
      | false => React.null
      }}
    </div>

  let mintButtons = () =>
    <div className={`flex w-full justify-around`}>
      <Button.Small
        onClick={_ => {
          router->Next.Router.pushShallow(
            `/markets?marketIndex=${marketIndex->Ethers.BigNumber.toString}&mintOption=long`,
          )
        }}>
        "Mint Long"
      </Button.Small>
      <Button.Small
        onClick={_ => {
          router->Next.Router.pushShallow(
            `/markets?marketIndex=${marketIndex->Ethers.BigNumber.toString}&mintOption=short`,
          )
        }}>
        "Mint Short"
      </Button.Small>
    </div>

  <>
    <div className="p-1 mb-8 rounded-lg flex flex-col bg-white bg-opacity-75 my-5 shadow-lg">
      <div className="flex justify-center w-full my-1">
        <h1 className="font-bold text-xl font-alphbeta">
          {marketName->React.string} <Tooltip tip={`This market tracks ${marketName}`} />
        </h1>
      </div>
      <div className="flex flex-wrap justify-center w-full">
        <div
          className="order-2 md:order-1 w-1/2 md:w-1/4 flex items-center flex grow flex-wrap flex-col">
          {marketPositionHeadings(~isLong={true})}
          <div className="md:block hidden"> {marketPositionValues(~isLong={true})} </div>
        </div>
        <div className="order-1 md:order-2 w-full md:w-1/2 flex items-center flex-col">
          <h2 className="text-xs mt-1">
            <span className="font-bold"> {"TOTAL"->React.string} </span>
            {" Liquidity"->React.string}
          </h2>
          <div className="text-3xl font-alphbeta tracking-wider py-1">
            {`$${totalValueLocked->FormatMoney.formatEther}`->React.string}
          </div>
          <div className="md:block hidden w-full">
            {liquidityRatio()} {Option.isNone(marketIndexOption) ? mintButtons() : React.null}
          </div>
        </div>
        <div className="order-3 w-1/2 md:w-1/4 flex-grow flex-wrap flex-col">
          {marketPositionHeadings(~isLong={false})}
          <div className="md:block hidden"> {marketPositionValues(~isLong={false})} </div>
        </div>
      </div>
      <div className="block md:hidden pt-5">
        <div className="px-8"> {liquidityRatio()} </div>
        <div className="flex md:hidden">
          {marketPositionValues(~isLong={true})} {marketPositionValues(~isLong={false})}
        </div>
        {Option.isNone(marketIndexOption) ? mintButtons() : React.null}
      </div>
    </div>
  </>
}
