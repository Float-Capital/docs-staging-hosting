open BsRecharts
open GqlConverters
let {ethAdrToLowerStr} = module(Ethers.Utils)

type priceData = {
  date: Js.Date.t,
  price: float,
}

// This module isn't used anywhere else in the code. If it is in the future, hoist it up into the Queries module.
module PriceHistory = %graphql(`
query ($intervalId: String!, $numDataPoints: Int!) @ppxConfig(schema: "graphql_schema_price_history.json") {
  priceIntervalManager(id: $intervalId) {
    id
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

type marketSecondsExisted = int
type graphZoom = Day | Week | Month | ThreeMonth | Year | Max(marketSecondsExisted)

let minThreshodFromGraphSetting = graphSetting =>
  switch graphSetting {
  | Max(_timeMaketHasExisted) => 0
  | Day => CONSTANTS.oneDayInSeconds
  | Week => CONSTANTS.oneWeekInSeconds
  | Month => CONSTANTS.oneMonthInSeconds
  | ThreeMonth => CONSTANTS.threeMonthsInSeconds
  | Year => CONSTANTS.oneYearInSeconds
  }

let btnTextFromGraphSetting = graphSetting =>
  switch graphSetting {
  // TODO: these values should be constants
  | Max(_timeMaketHasExisted) => "MAX"
  | Day => "1D"
  | Week => "1W"
  | Month => "1M"
  | ThreeMonth => "3M"
  | Year => "1Y"
  }

let getMaxTimeDateFormatter = timeMarketExists => {
  switch timeMarketExists {
  | time if time < CONSTANTS.halfDayInSeconds => "hh aa"
  | time if time < CONSTANTS.oneWeekInSeconds => "iii"
  | time if time < CONSTANTS.twoWeeksInSeconds => "iii MMM"
  | time if time < CONSTANTS.threeMonthsInSeconds => "iii MMM"
  | time if time < CONSTANTS.oneYearInSeconds => "MMM"
  | _ => "MMM"
  }
}

let dateFormattersFromGraphSetting = graphSetting =>
  switch graphSetting {
  // https://date-fns.org/v2.19.0/docs/format
  | Max(timeMaketHasExisted) => timeMaketHasExisted->getMaxTimeDateFormatter
  | Day => "hh aa"
  | Week => "iii"
  | Month => "iii"
  | ThreeMonth => "iii MMM"
  | Year => "MMM"
  }

let getMaxTimeIntervalAndAmount = timeMarketExists => {
  switch timeMarketExists {
  | time if time < CONSTANTS.halfDayInSeconds => (
      CONSTANTS.fiveMinutesInSeconds,
      // timeMarketExists / CONSTANTS.fiveMinutesInSeconds + 1, // Max data points: 144
      1000,
    )
  | time if time < CONSTANTS.oneWeekInSeconds => (
      CONSTANTS.oneHourInSeconds,
      // timeMarketExists / CONSTANTS.oneHourInSeconds + 1, // Min data points: 13; Max data points: 84
      1000,
    )
  | time if time < CONSTANTS.twoWeeksInSeconds => (
      CONSTANTS.halfDayInSeconds,
      // timeMarketExists / CONSTANTS.halfDayInSeconds + 1, // Min data points: 13; Max data points: 84
      1000,
    )
  | time if time < CONSTANTS.threeMonthsInSeconds => (
      CONSTANTS.oneDayInSeconds,
      // timeMarketExists / CONSTANTS.oneDayInSeconds + 1, // Min data points: 15; Max data points: 90
      1000,
    )
  | time if time < CONSTANTS.oneYearInSeconds => (
      CONSTANTS.oneWeekInSeconds,
      // timeMarketExists / CONSTANTS.oneWeekInSeconds + 1, // Min data points: 13; Max data points: 56
      1000,
    )
  | _ => (CONSTANTS.twoWeeksInSeconds, 1000)
  }
}

let zoomAndNumDataPointsFromGraphSetting = graphSetting =>
  switch graphSetting {
  | Max(timeMaketHasExisted) => timeMaketHasExisted->getMaxTimeIntervalAndAmount
  | Day => (CONSTANTS.oneHourInSeconds, 24)
  | Week => (CONSTANTS.halfDayInSeconds, 14)
  | Month => (CONSTANTS.oneDayInSeconds, 30)
  | ThreeMonth => (CONSTANTS.threeMonthsInSeconds, 30)
  | Year => (CONSTANTS.twoWeeksInSeconds, 26)
  }

type dataInfo = {
  dataArray: array<priceData>,
  minYValue: float,
  maxYValue: float,
  dateFormat: string,
}

@ocaml.doc(`Takes the raw prices returned from the graph and transforms them into the correct format for recharts to display, as well as getting the max+min y-values.`)
let extractGraphPriceInfo = (
  rawPriceData: array<PriceHistory.PriceHistory_inner.t_priceIntervalManager_prices>,
  graphZoomSetting,
) =>
  rawPriceData->Array.reduceReverse(
    {
      dataArray: [],
      minYValue: Js.Int.max->Float.fromInt,
      maxYValue: 0.,
      dateFormat: graphZoomSetting->dateFormattersFromGraphSetting,
    },
    (data, {startTimestamp, endPrice}) => {
      let price = endPrice->Ethers.Utils.formatEther->Float.fromString->Option.getExn
      {
        ...data,
        dataArray: data.dataArray->Array.concat([
          {
            date: startTimestamp,
            price: price,
          },
        ]),
        minYValue: price < data.minYValue ? price : data.minYValue,
        maxYValue: price > data.maxYValue ? price : data.maxYValue,
      }
    },
  )

@ocaml.doc(`Generate random data to show on page load as a place holder`)
let generateDummyData = endTimestamp => {
  let oneDayInSecondsFloat = CONSTANTS.oneDayInSeconds->Float.fromInt

  // TODO: when I'm not on an airplane, look in docs how to generate this array easily.
  let (result, _, _) = Array.makeUninitialized(60)->Array.reduce(
    (
      {dataArray: [], minYValue: 200., maxYValue: 100., dateFormat: "iii"},
      endTimestamp->Float.fromInt,
      500. /* target price of the graph */,
    ),
    ((data, timestamp, prevPrice), _i) => {
      let newTimestamp = timestamp -. oneDayInSecondsFloat
      let randomDelta = Js.Math.random_int(-30, 25)->Float.fromInt // The graph goes up and down randomly between -30 and 25, but since the graph is reversed it goes goes up more than down (30 up, 25 down)
      let randomPrice = prevPrice +. randomDelta
      (
        {
          ...data,
          dataArray: [
            {
              date: timestamp->DateFns.fromUnixTime,
              price: randomPrice,
            },
          ]->Array.concat(data.dataArray),
          minYValue: randomPrice < data.minYValue ? randomPrice : data.minYValue,
          maxYValue: randomPrice > data.maxYValue ? randomPrice : data.maxYValue,
        },
        newTimestamp,
        randomPrice,
      )
    },
  )
  result
}

@react.component
let make = (~marketName, ~oracleAddress, ~timestampCreated) => {
  let currentTimestamp = Misc.Time.getCurrentTimestamp()

  let timestampCreatedInt = timestampCreated->Ethers.BigNumber.toNumber
  let timeMaketHasExisted = currentTimestamp - timestampCreatedInt

  let ({dataArray, minYValue, maxYValue}, setDisplayData) = React.useState(_ =>
    generateDummyData(currentTimestamp)
  )
  let (overlayMessageText, setOverlayMessageText) = React.useState(_ => None)

  let (graphSetting, setGraphSetting) = React.useState(_ => Max(timeMaketHasExisted))
  let (intervalLength, numDataPoints) = graphSetting->zoomAndNumDataPointsFromGraphSetting
  let priceHistory = PriceHistory.use(
    ~context=Client.createContext(Client.PriceHistory),
    {
      intervalId: `${oracleAddress->ethAdrToLowerStr}-${intervalLength->Int.toString}`,
      numDataPoints: numDataPoints,
    },
  )

  React.useEffect2(() => {
    {
      switch priceHistory {
      | {error: Some(_error)} => setOverlayMessageText(_ => Some("Error loading data"))
      | {data: Some({priceIntervalManager: Some({prices})})} =>
        setOverlayMessageText(_ => None)
        setDisplayData(_ => prices->extractGraphPriceInfo(graphSetting))
      | {data: Some({priceIntervalManager: None})} =>
        setOverlayMessageText(_ => Some("Unable to find prices for this market"))
      | {data: None, error: None, loading: false}
      | {loading: true} =>
        setOverlayMessageText(_ => Some(`Loading data for ${marketName}`))
      }
    }

    None
  }, (graphSetting, priceHistory.loading))

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
      {overlayMessageText->Option.mapWithDefault(React.null, overlayMessage)}
      <div className="flex flex-row justify-between ml-5">
        {[Day, Week, Month, ThreeMonth, Year, Max(timeMaketHasExisted)]
        ->Array.map(buttonSetting => {
          let text = btnTextFromGraphSetting(buttonSetting)
          <Button.Tiny
            key={text}
            disabled={minThreshodFromGraphSetting(buttonSetting) > timeMaketHasExisted}
            active={graphSetting == buttonSetting}
            onClick={_ => {
              setGraphSetting(_ => buttonSetting)
            }}>
            {text}
          </Button.Tiny>
        })
        ->React.array}
      </div>
    </div>
  </>
}
