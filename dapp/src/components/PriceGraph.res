open BsRecharts
open GqlConverters
let {ethAdrToLowerStr} = module(Ethers.Utils)

type priceData = {
  date: Js.Date.t,
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
  let make = (~data, ~xAxisFormat, ~minYValue, ~maxYValue) => {
    let totalRange = maxYValue -. minYValue
    let yAxisRange = [minYValue -. totalRange *. 0.05, maxYValue +. totalRange *. 0.05]

    let isMobile = View.useIsTailwindMobile()

    <ResponsiveContainer
      height={isMobile ? Px(200.) : Prc(100.)} width=Prc(100.) className="w-full text-xs m-0 p-0">
      <LineChart margin={"top": 0, "right": 0, "bottom": 0, "left": 0} data>
        <Line _type=#natural dataKey="price" stroke="#0d4184" strokeWidth={2} dot={false} />
        <Tooltip labelFormatter={value => value->DateFns.format("hha do MMM yyyy")} />
        <XAxis dataKey="date" tickFormatter={value => value->DateFns.format(xAxisFormat)} />
        <YAxis
          _type=#number
          tickFormatter={value => value->Js.Float.toFixedWithPrecision(~digits=3)}
          domain={yAxisRange}
          axisLine={false}
        />
      </LineChart>
    </ResponsiveContainer>
  }
}

type graphZoom = Day | Week | Month | ThreeMonth | Year | Max

let minThreshodFromGraphSetting = graphSetting =>
  switch graphSetting {
  | Max => 0
  | Day => CONSTANTS.oneDayInSeconds
  | Week => CONSTANTS.oneWeekInSeconds
  | Month => CONSTANTS.oneMonthInSeconds
  | ThreeMonth => CONSTANTS.threeMonthsInSeconds
  | Year => CONSTANTS.oneYearInSeconds
  }

let btnTextFromGraphSetting = graphSetting =>
  switch graphSetting {
  | Max => "MAX"
  | Day => "1D"
  | Week => "1W"
  | Month => "1M"
  | ThreeMonth => "3M"
  | Year => "1Y"
  }

let dateFormattersFromGraphSetting = graphSetting =>
  switch graphSetting {
  // https://date-fns.org/v2.19.0/docs/format
  | Max => "do MMM yyyy" /// TODO: implement! These numbers should be calculated dynamically based on the time the market has existed
  | Day => "hh aa"
  | Week => "iii"
  | Month => "iii"
  | ThreeMonth => "iii MMM"
  | Year => "MMM"
  }

let zoomAndNumDataPointsFromGraphSetting = graphSetting =>
  switch graphSetting {
  | Max => (CONSTANTS.oneHourInSeconds, 1000) /// TODO: implement! These numbers should be calculated dynamically based on the time the market has existed
  | Day => (CONSTANTS.oneHourInSeconds, 24)
  | Week => (CONSTANTS.halfDayInSeconds, 14)
  | Month => (CONSTANTS.oneDayInSeconds, 30)
  | ThreeMonth => (CONSTANTS.threeMonthsInSeconds, 30)
  | Year => (CONSTANTS.twoWeeksInSeconds, 26)
  }

type dataInfo = {dataArray: array<priceData>, minYValue: float, maxYValue: float}

@ocaml.doc(`Takes the raw prices returned from the graph and transforms them into the correct format for recharts to display, as well as getting the max+min y-values.`)
let extractGraphPriceInfo = (
  rawPriceData: array<PriceHistory.PriceHistory_inner.t_priceIntervalManager_prices>,
) =>
  rawPriceData->Array.reduceReverse(
    {dataArray: [], minYValue: Js.Int.max->Float.fromInt, maxYValue: 0.},
    ({dataArray, minYValue, maxYValue}, {startTimestamp, endPrice}) => {
      let price = endPrice->Ethers.Utils.formatEther->Float.fromString->Option.getExn
      {
        dataArray: dataArray->Array.concat([
          {
            date: startTimestamp,
            price: price,
          },
        ]),
        minYValue: price < minYValue ? price : minYValue,
        maxYValue: price > maxYValue ? price : maxYValue,
      }
    },
  )

let generateDummyData = endTimestamp => {
  let oneDayInSecondsFloat = CONSTANTS.oneDayInSeconds->Float.fromInt

  let (result, _) = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]->Array.reduce(
    ({dataArray: [], minYValue: 200., maxYValue: 100.}, endTimestamp->Float.fromInt),
    (({dataArray, minYValue, maxYValue}, timestamp), _i) => {
      let newTimestamp = timestamp -. oneDayInSecondsFloat
      let randomPrice = Js.Math.random_int(100, 200)->Float.fromInt
      (
        {
          dataArray: [
            {
              date: timestamp->DateFns.fromUnixTime,
              price: randomPrice,
            },
          ]->Array.concat(dataArray),
          minYValue: randomPrice < minYValue ? randomPrice : minYValue,
          maxYValue: randomPrice > maxYValue ? randomPrice : maxYValue,
        },
        newTimestamp,
      )
    },
  )
  result
}

@react.component
let make = (~marketName, ~oracleAddress, ~timestampCreated) => {
  let currentTimestamp = Misc.Time.getCurrentTimestamp()
  let ({dataArray, minYValue, maxYValue}, setDisplayData) = React.useState(_ =>
    generateDummyData(currentTimestamp)
  )
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
      <h3 className="ml-5"> {`${marketName} Price`->React.string} </h3>
      <LoadedGraph
        xAxisFormat={dateFormattersFromGraphSetting(graphSetting)}
        data=dataArray
        minYValue
        maxYValue
      />
      {switch priceHistory {
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({priceIntervalManager: Some({prices})})} =>
        setDisplayData(_ => prices->extractGraphPriceInfo)
        React.null
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
    </div>
  </>
}
