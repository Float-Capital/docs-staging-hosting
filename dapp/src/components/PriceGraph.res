open BsRecharts
open GqlConverters
let {ethAdrToLowerStr} = module(Ethers.Utils)

type priceData = {
  date: string,
  price: float,
}

module PriceHistory = %graphql(`
query ($intervalId: String!) @ppxConfig(schema: "graphql_schema_price_history.json") {
  priceIntervalManager(id: $intervalId) {
    prices(first: 25, orderBy: intervalIndex, orderDirection:desc) {
      startTimestamp @ppxCustom(module: "Date")
      endPrice
    }
  }
}`)

module LoadedGraph = {
  @react.component
  let make = (~data) => {
    // let noDataAvailable = data->Array.length == 0

    // let displayData = noDataAvailable ? dummyData : data

    let minYRange = data->Js.Array2.reduce(
      (min, dataPoint) => dataPoint.price < min ? dataPoint.price : min,
      switch data[0] {
      | Some(d) => d.price
      | None => 0.
      },
    )

    let maxYRange = data->Js.Array2.reduce(
      (max, dataPoint) => dataPoint.price > max ? dataPoint.price : max,
      switch data[0] {
      | Some(d) => d.price
      | None => 0.
      },
    )

    let totalRange = maxYRange -. minYRange
    let yAxisRange = [minYRange -. totalRange *. 0.05, maxYRange +. totalRange *. 0.05]

    let isMobile = View.useIsTailwindMobile()

    <ResponsiveContainer
      height={isMobile ? Px(200.) : Prc(100.)} width=Prc(100.) className="w-full text-xs m-0 p-0">
      <LineChart margin={"top": 0, "right": 0, "bottom": 0, "left": 0} data>
        <Line _type=#natural dataKey="price" stroke="#0d4184" strokeWidth={2} dot={false} />
        <Tooltip />
        <XAxis dataKey="date" />
        <YAxis _type=#number domain={yAxisRange} axisLine={false} />
      </LineChart>
    </ResponsiveContainer>
  }
}

type graphZoom = Day | Week | Month | ThreeMonth | Year | Max

@react.component
let make = (~marketName, ~oracleAddress, ~timestampCreated) => {
  // TODO: use timestampCreated to determine which buttons to disable
  let priceHistory = PriceHistory.use(
    ~context=Client.createContext(Client.PriceHistory),
    {intervalId: `${oracleAddress->ethAdrToLowerStr}-300`},
  )

  let overlayMessage = message =>
    <div
      className="v-align-in-responsive-height text-center text-gray-500 bg-white bg-opacity-90 p-2 z-10 rounded-lg">
      {message->React.string}
    </div>

  <>
    <div className={`flex-1 p-1 my-4 mr-6 flex flex-col relative`}>
      {<>
        <h3 className="ml-5"> {`${marketName} Price`->React.string} </h3>
        {switch priceHistory {
        | {error: Some(_error)} => "Error loading data"->React.string
        | {data: Some({priceIntervalManager: Some({prices})})} =>
          let priceData = prices->Array.map(({startTimestamp, endPrice}) => {
            {
              date: startTimestamp->DateFns.format("do MMM yyyy"),
              price: endPrice->Ethers.Utils.formatEther->Float.fromString->Option.getExn,
            }
          })
          <LoadedGraph data=priceData />
        | {data: Some({priceIntervalManager: None})} =>
          overlayMessage("Unable to find prices for this market")
        | {data: None, error: None, loading: false}
        | {loading: true} =>
          overlayMessage(`Loading data for ${marketName}`)
        }}
        <div className="flex flex-row justify-between ml-5">
          <Button.Tiny
            onClick={_ => {
              Js.log("1D")
            }}>
            "1D"
          </Button.Tiny>
          <Button.Tiny
            onClick={_ => {
              Js.log("1W")
            }}>
            "1W"
          </Button.Tiny>
          <Button.Tiny
            onClick={_ => {
              Js.log("1M")
            }}>
            "1M"
          </Button.Tiny>
          <Button.Tiny
            onClick={_ => {
              Js.log("3M")
            }}
            disabled={true}>
            "3M"
          </Button.Tiny>
          <Button.Tiny
            onClick={_ => {
              Js.log("1Y")
            }}
            disabled={true}>
            "1Y"
          </Button.Tiny>
          <Button.Tiny
            onClick={_ => {
              Js.log("MAX")
            }}
            disabled={true}>
            "MAX"
          </Button.Tiny>
        </div>
      </>}
    </div>
  </>
}
