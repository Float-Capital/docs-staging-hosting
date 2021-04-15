open BsRecharts
open GqlConverters

type priceData = {
  date: string,
  price: float,
}

module PriceHistory = %graphql(`
query @ppxConfig(schema: "graphql_schema_price_history.json") {
  fiveMinPrices(first: 25, orderBy: intervalIndex, orderDirection:desc, where: {
    oracle: "0x49b6eb4bb38178790b51a5630f08923580e10e8d"
  }) {
    startTimestamp @ppxCustom(module: "Date")
    endPrice
  }
}`)

module LoadedGraph = {
  @react.component
  let make = (~marketName, ~data) => {
    let dummyData = [
      {
        date: "1 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "2 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "3 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "4 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "5 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "6 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "7 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "8 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "9 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "10 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "11 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "12 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "13 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
      {
        date: "14 Feb",
        price: Js.Math.random_int(100, 200)->Float.fromInt,
      },
    ]

    let noDataAvailable = data->Array.length == 0

    let displayData = noDataAvailable ? dummyData : data

    let minYRange = displayData->Js.Array2.reduce(
      (min, dataPoint) => dataPoint.price < min ? dataPoint.price : min,
      switch displayData[0] {
      | Some(d) => d.price
      | None => 0.
      },
    )

    let maxYRange = displayData->Js.Array2.reduce(
      (max, dataPoint) => dataPoint.price > max ? dataPoint.price : max,
      switch displayData[0] {
      | Some(d) => d.price
      | None => 0.
      },
    )

	let totalRange = maxYRange -. minYRange
    let yAxisRange = [minYRange -. (totalRange *. 0.05), maxYRange +. (totalRange *. 0.05)]

    let isMobile = View.useIsTailwindMobile()

    <>
      <div className={`flex-1 p-1 my-4 mr-6 flex flex-col relative`}>
        {noDataAvailable
          ? <div
              className="v-align-in-responsive-height text-center text-gray-500 bg-white bg-opacity-90 p-2 z-10 rounded-lg">
              {"No price data available for this market yet"->React.string}
            </div>
          : React.null}
        {<>
          <h3 className="ml-5"> {`${marketName} Price`->React.string} </h3>
          <ResponsiveContainer
            height={isMobile ? Px(200.) : Prc(100.)}
            width=Prc(100.)
            className="w-full text-xs m-0 p-0">
            <LineChart margin={"top": 0, "right": 0, "bottom": 0, "left": 0} data={displayData}>
              <Line _type=#natural dataKey="price" stroke="#0d4184" strokeWidth={2} dot={false} />
              <Tooltip />
              <XAxis dataKey="date" />
              <YAxis _type=#number domain={yAxisRange} axisLine={false} />
            </LineChart>
          </ResponsiveContainer>
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
}

@react.component
let make = (~marketName) => {
  let priceHistory = PriceHistory.use(~context=Client.createContext(Client.PriceHistory), ())

  let loading =
    <div> <p> {`Loading data for ${marketName}`->React.string} </p> <MiniLoader /> </div>

  {
    switch priceHistory {
    | {error: Some(_error)} => "Error loading data"->React.string
    | {data: Some({fiveMinPrices})} =>
      let priceData = fiveMinPrices->Array.map(({startTimestamp, endPrice}) => {
        {
          date: startTimestamp->DateFns.format("do MMM yyyy"),
          price: endPrice->Ethers.Utils.formatEther->Float.fromString->Option.getExn,
        }
      })
      Js.log(priceData)
      <LoadedGraph marketName data=priceData />
    | {data: None, error: None, loading: false}
    | {loading: true} => loading
    }
  }
}
