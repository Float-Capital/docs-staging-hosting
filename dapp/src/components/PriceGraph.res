open BsRecharts
open GqlConverters
let {ethAdrToLowerStr} = module(Ethers.Utils)

type priceData = {
  date: string,
  price: float,
}

module PriceHistory = %graphql(`
query ($intervalId: String!, $numDataPoints: Int!) @ppxConfig(schema: "graphql_schema_price_history.json") {
  priceIntervalManager(id: $intervalId) {
    prices(first: $numDataPoints, orderBy: intervalIndex, orderDirection:desc) {
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

let minThreshodFromGraphSetting = graphSetting =>
  switch graphSetting {
  // TODO: these values should be constants
  | Max => 0
  | Day => 86400
  | Week => 604800
  | Month => 2628029
  | ThreeMonth => 7884087
  | Year => 31536000
  }

let btnTextFromGraphSetting = graphSetting =>
  switch graphSetting {
  // TODO: these values should be constants
  | Max => "MAX"
  | Day => "1D"
  | Week => "1W"
  | Month => "1M"
  | ThreeMonth => "3M"
  | Year => "1Y"
  }

let axisLabelsFromGraphSetting = graphSetting =>
  switch graphSetting {
  // https://date-fns.org/v2.19.0/docs/format
  | Max => "do MMM yyyy" /// TODO: implement! These numbers should be calculated dynamically based on the time the market has existed
  | Day => "hh"
  | Week => "iii"
  | Month => "iii"
  | ThreeMonth => "MMM"
  | Year => "MMM"
  }

let zoomAndNumDataPointsFromGraphSetting = graphSetting =>
  switch graphSetting {
  | Max => (3600, 10000) /// TODO: implement! These numbers should be calculated dynamically based on the time the market has existed
  | Day => (3600, 24)
  | Week => (43200, 14)
  | Month => (86400, 30)
  | ThreeMonth => (259200, 30)
  | Year => (1209600, 26)
  }

@react.component
let make = (~marketName, ~oracleAddress, ~timestampCreated) => {
  let currentTimestamp = Misc.Time.getCurrentTimestamp()
  let timestampCreatedInt = timestampCreated->Ethers.BigNumber.toNumber

  let timeMaketHasExisted = currentTimestamp - timestampCreatedInt

  // TODO: use timestampCreated to determine which buttons to disable
  let (graphSetting, setGraphSetting) = React.useState(_ => Max)
  let (intervalLength, numDataPoints) = graphSetting->zoomAndNumDataPointsFromGraphSetting
  let priceHistory = PriceHistory.use(
    ~context=Client.createContext(Client.PriceHistory),
    {
      intervalId: `${oracleAddress->ethAdrToLowerStr}-${intervalLength->Int.toString}`,
      numDataPoints: numDataPoints,
    },
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
              date: startTimestamp->DateFns.format(axisLabelsFromGraphSetting(graphSetting)),
              price: endPrice->Ethers.Utils.formatEther->Float.fromString->Option.getExn,
            }
          })
          Js.log(priceData)
          <LoadedGraph data=priceData />
        | {data: Some({priceIntervalManager: None})} =>
          overlayMessage("Unable to find prices for this market")
        | {data: None, error: None, loading: false}
        | {loading: true} =>
          overlayMessage(`Loading data for ${marketName}`)
        }}
        <div className="flex flex-row justify-between ml-5">
          {[Day, Week, Month, ThreeMonth, Year, Max]
          ->Array.map(buttonSetting =>
            <Button.Tiny
              disabled={minThreshodFromGraphSetting(buttonSetting) > timeMaketHasExisted}
              active={graphSetting == buttonSetting}
              onClick={_ => {
                setGraphSetting(_ => buttonSetting)
              }}>
              {btnTextFromGraphSetting(buttonSetting)}
            </Button.Tiny>
          )
          ->React.array}
        </div>
      </>}
    </div>
  </>
}
