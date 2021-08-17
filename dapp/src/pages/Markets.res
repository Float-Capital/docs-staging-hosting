module PriceCard = {
  open Recharts

  module Card = {
    @react.component
    let make = (~selected=false, ~children=React.null) =>
      <div
        className={`${selected
            ? "shadow-inner-card"
            : "shadow-outer-card opacity-60 transform hover:scale-102"}
    my-2
    md:my-3
    h-md
    md:w-price-width
    md:mr-4
    md:h-price-height
    custom-cursor
    bg-white
    flex md:flex-col
    relative
    rounded-lg`}>
        {children}
      </div>
  }

  module LoadedGraph = {
    @react.component
    let make = (~data) => {
      let isMobile = View.useIsTailwindMobile()
      <ResponsiveContainer
        width=Prc(99.) height={isMobile ? Px(40.) : Prc(100.)} className="m-0 p-0">
        <LineChart margin={"top": 5, "right": 0, "bottom": 5, "left": 0} data>
          <Line _type=#natural dataKey="price" stroke="#0d4184" strokeWidth={2} dot={false} />
          <YAxis _type=#number domain={["dataMin", "dataMax"]} axisLine={false} hide={true} />
        </LineChart>
      </ResponsiveContainer>
    }
  }

  type loadedInfo = {
    data: array<PriceGraph.priceData>,
    latestPrice: string,
  }

  type possibleState = DataHooks.graphResponse<loadedInfo>

  @react.component
  let make = (~selected, ~market: Queries.SyntheticMarketInfo.t, ~onClick) => {
    // price history for a week
    let priceHistory = Queries.PriceHistory.use(
      ~context=Client.createContext(Client.PriceHistory),
      {
        intervalId: `${market.oracleAddress->Ethers.Utils.ethAdrToLowerStr}-${CONSTANTS.oneHourInSeconds->Int.toString}`,
        numDataPoints: 168,
      },
    )

    let state: possibleState = switch priceHistory {
    | {data: Some({priceIntervalManager: Some({prices, latestPriceInterval: {endPrice}})})} =>
      Response({
        data: prices->Array.reduceReverse([], (prev, {startTimestamp, endPrice}) => {
          let info: PriceGraph.priceData = {
            date: startTimestamp,
            price: endPrice->Ethers.Utils.formatEther->Float.fromString->Option.getExn,
          }
          prev->Array.concat([info])
        }),
        latestPrice: endPrice->Ethers.Utils.formatEtherToPrecision(2),
      })
    | {data: Some({priceIntervalManager: None})} =>
      GraphError("Couldn't fetch prices for this market.")
    | {data: None, error: None, loading: false} =>
      GraphError("Couldn't fetch prices for this market.")
    | {loading: true} => Loading
    | {error: Some({message})} => GraphError(message)
    }

    <Card selected>
      <div className="z-10 absolute w-full h-full flex items-center justify-center" onClick />
      <div
        className="pt-2 text-xs font-medium flex-1 md:flex-initial md:w-full flex justify-between">
        <div className="mx-3"> {market.name->React.string} </div>
        <div className="mx-3">
          {switch state {
          | Response({latestPrice}) => `\$${latestPrice}`->React.string
          | _ => React.null
          }}
        </div>
      </div>
      <div className="flex items-center justify-center px-4 py-2 md:px-4 md:py-4 flex-1">
        {switch state {
        | Response({data}) => <LoadedGraph data />
        | Loading => <Loader.Ellipses />
        | GraphError(e) => e->React.string
        }}
      </div>
    </Card>
  }
}

module Mint = {
  module Header = {
    module TypedCharacters = {
      @react.component
      let make = (~str) => {
        let (count, setCount) = React.useState(_ => 1)
        Misc.Time.useIntervalFixed(
          _ => setCount(c => c + 1),
          ~numIterations=str->String.length - 1,
          ~delay=25,
        )
        str->String.sub(0, count)->React.string
      }
    }

    @react.component
    let make = (~market: Queries.SyntheticMarketInfo.t, ~actionOption, ~marketIndex) => {
      <div className="flex justify-between items-center mb-2">
        <div className="text-xl"> <TypedCharacters str={market.name} /> </div>
        <Next.Link
          href={`/app/markets?marketIndex=${marketIndex->Int.toString}&actionOption=${actionOption}`}>
          <div className="text-xxs hover:underline cursor-pointer">
            {`view details`->React.string}
          </div>
        </Next.Link>
      </div>
    }
  }

  @react.component
  let make = (~market) => {
    let router = Next.Router.useRouter()
    let actionOption = router.query->Js.Dict.get("actionOption")->Option.getWithDefault("short")
    <div className={`mt-5 md:mt-0 md:w-mint-width p-6 mb-5 rounded-lg shine md:order-2 order-1`}>
      <Header
        market={market} actionOption marketIndex={market.marketIndex->Ethers.BigNumber.toNumber}
      />
      <div className="px-1"> <MintForm market={market} isLong={actionOption != "short"} /> </div>
    </div>
  }
}

@val external parseFloatInt: string => float = "parseInt"

let floatToIntUnsafe: float => int = Obj.magic

@react.component
let make = () => {
  let marketsQuery = DataHooks.useGetMarkets()

  let router = Next.Router.useRouter()

  let selectedStr = router.query->Js.Dict.get("selected")->Option.getWithDefault("0")
  let selectedFloat = selectedStr->parseFloatInt
  let selectedInt = selectedFloat->Js.Float.isNaN ? 0 : selectedFloat->floatToIntUnsafe
  let marketIndexStr = router.query->Js.Dict.get("marketIndex")

  let isMarketPage = marketIndexStr->Option.isSome

  <div
    className={isMarketPage
      ? "w-full max-w-5xl mx-auto px-2 md:px-0"
      : "md:h-80-percent-screen flex flex-col items-center justify-center w-full"}>
    {switch marketsQuery {
    | Response(markets) if markets->Array.length > 0 =>
      if isMarketPage {
        let queryMarketIndex = marketIndexStr->Option.getUnsafe
        if (
          queryMarketIndex->Belt.Int.fromString->Option.mapWithDefault(1000, x => x) <=
            markets->Belt.Array.length
        ) {
          let selectedMarketData =
            markets[queryMarketIndex->Belt.Int.fromString->Option.mapWithDefault(1000, x => x) - 1]
          switch selectedMarketData {
          | Some(marketData) => <Market marketData />
          | None => React.null
          }
        } else {
          React.null
        }
      } else {
        let selected = selectedInt >= 0 && selectedInt < markets->Array.length ? selectedInt : 0
        <div className="w-9/10 md:w-auto flex flex-col">
          {if markets->Array.length > 1 {
            <div
              className="pb-6 flex md:order-1 order-2 flex-col md:flex-row w-full md:w-auto justify-center">
              {markets
              ->Array.mapWithIndex((index, market) =>
                <PriceCard
                  selected={selected == index}
                  market
                  onClick={_ => {
                    if selected !== index {
                      router.query->Js.Dict.set("selected", index->Int.toString)
                      router.query->Js.Dict.set("actionOption", "short")
                      router->Next.Router.pushObjShallow({
                        pathname: router.pathname,
                        query: router.query,
                      })
                    }
                  }}
                />
              )
              ->React.array}
            </div>
          } else {
            React.null
          }}
          <Mint market={markets->Array.getUnsafe(selected)} key={selectedStr} />
        </div>
      }
    | Response(_) => "Error fetching data for markets."->React.string
    | Loading => <Loader />
    | GraphError(e) => e->React.string
    }}
  </div>
}

let default = make
