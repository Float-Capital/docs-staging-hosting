open StatsLi.Props
open Masonry

module TrendingStakes = {
  open APYProvider
  @react.component
  let make = (~global) => {
    let marketDetailsQuery = Queries.MarketDetails.use()
    let apy = APYProvider.useAPY()
    let bnApy = APYProvider.useBnApy()

    {
      switch marketDetailsQuery {
      | {loading: true} => <div className="m-auto"> <Loader.Mini /> </div>
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({syntheticMarkets})} =>
        switch (apy, bnApy) {
        | (Loaded(apyVal), Loaded(bnApy)) => {
            let trendingStakes = StatsCalcs.trendingStakes(
              ~syntheticMarkets,
              ~apy=apyVal,
              ~global,
              ~bnApy,
            )
            trendingStakes
            ->Array.map(({marketName, isLong, apy, floatApy, stakeApy}) =>
              <StatsStakeCard
                marketName={marketName}
                isLong={isLong}
                yield={apy}
                rewards={floatApy}
                stakeYield={stakeApy}
                key={marketName ++ (isLong ? "-long" : "-short")}
              />
            )
            ->React.array
          }
        | _ => <Loader.Mini />
        }
      | {data: None, error: None, loading: false} =>
        "You might think this is impossible, but depending on the situation it might not be!"->React.string
      }
    }
  }
}

let totalValueCard = (~totalValueLocked) =>
  <div
    className={"mb-2 md:mb-5 mx-3 p-5 md:mt-7 self-center text-center bg-white bg-opacity-75 rounded-lg shadow-lg"}>
    <span className="font-alphbeta text-xl"> {"Total Value"->React.string} </span>
    <span className="text-sm"> {` 🏦 in Float Protocol: `->React.string} </span>
    <span className="text-green-700 font-bold text-xl">
      {`$${totalValueLocked->Misc.NumberFormat.formatEther}`->React.string}
    </span>
  </div>

let floatProtocolCard = (~liveSince, ~totalUsers, ~txHash, ~numberOfSynths) => {
  let dateObj = liveSince->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime

  <Card>
    <Header> {`Float Protocol 🏗️`->React.string} </Header>
    <StatsUl
      list={[
        createStatsLiProps(
          ~prefix=`🗓️ Live since:`,
          ~value={
            dateObj->DateFns.format(#"do MMM ''yy")
          },
          ~link={`${Config.blockExplorer}/tx/${txHash}`},
          (),
        ),
        createStatsLiProps(
          ~prefix=`📅 Days live:`,
          ~value={
            dateObj->DateFns.formatDistanceToNow
          },
          (),
        ),        
        createStatsLiProps(
          ~prefix=`👯‍♀️ No. users:`,
          ~value=totalUsers->Ethers.BigNumber.toString,
          (),
        ),
        createStatsLiProps(~prefix=`👷‍♀️ No. synths:`, ~value=numberOfSynths, ()),
      ]}
    />
  </Card>
}

let syntheticAssetsCard = (~totalSynthValue) =>
  <Card>
    <Header>
      {`Synthetic Assets`->React.string}
      <img className="inline h-5 ml-2" src="/icons/dollar-coin.png" />
    </Header>
    <div className="p-6 py-4 text-center">
      <div>
        <span className="text-sm mr-2"> {`💰 Total synth value`->React.string} </span>
        <div className="text-green-700 text-xl ">
          {`$${totalSynthValue->Misc.NumberFormat.formatEther}`->React.string}
          <span className="text-black">
            <Tooltip tip={"Redeemable value of synths in the open market"} />
          </span>
        </div>
      </div>
    </div>
    <Next.Link href="/app/markets">
      <div className="w-full pb-4 text-sm cursor-pointer hover:opacity-70 mx-auto">
        <div className="flex justify-center">
          <div className="inline-block mx-auto">
            <p> {`👀 See markets`->React.string} </p>
            <p className="ml-5"> {`to learn more...`->React.string} </p>
          </div>
        </div>
      </div>
    </Next.Link>
  </Card>

let floatTokenCard = (~totalFloatMinted) =>
  <Card>
    <Header> {`🌊🌊 Float Token 🌊🌊`->React.string} </Header>
    <StatsUl
      list={[
        createStatsLiProps(~prefix=`😏 Float price:`, ~value="...", ()),
        createStatsLiProps(
          ~prefix=`🗳 Float supply:`,
          ~value=totalFloatMinted->Misc.NumberFormat.formatEther,
          ~suffix=<Tooltip tip="The number of Float tokens in circulation" />,
          (),
        ),
        createStatsLiProps(~prefix=`🧢 Market cap: `, ~value="...", ()),
      ]}
    />
  </Card>

let stakingCard = (~totalValueStaked, ~global) =>
  <Card>
    <Header> {`Staking 🔥`->React.string} </Header>
    <div className="text-center mt-5">
      <div className="text-sm"> {`💰 Total staked value `->React.string} </div>
      <div className="text-green-700 text-xl ">
        {`$${totalValueStaked->Misc.NumberFormat.formatEther}`->React.string}
      </div>
    </div>
    <div className="text-left mt-4 pl-4 text-sm font-bold"> {`Trending`->React.string} </div>
    <div className="pt-2 pb-5"> <TrendingStakes global /> </div>
  </Card>

@react.component
let make = () => {
  let globalStateQuery = Queries.GlobalState.use()
  let marketDetailsQuery = Queries.MarketDetails.use()

  <div className="flex flex-col overflow-x-hidden">
    {switch (globalStateQuery, marketDetailsQuery) {
    | ({loading: true}, _)
    | (_, {loading: true}) =>
      <Loader.Mini />
    | ({error: Some(_error)}, _)
    | (_, {error: Some(_error)}) =>
      "Error loading data"->React.string
    | (
        {
          data: Some({
            globalStates: [
              {totalFloatMinted, totalUsers, timestampLaunched, txHash} as global,
            ],
          }),
        },
        {data: Some({syntheticMarkets})},
      ) =>
      let {totalValueLocked, totalValueStaked} = StatsCalcs.getTotalValueLockedAndTotalStaked(
        syntheticMarkets,
      )
      let totalSynthValue = StatsCalcs.getTotalSynthValue(~totalValueLocked, ~totalValueStaked)
      let numberOfSynths = (syntheticMarkets->Array.length * 2)->Int.toString

      <div className="w-full max-w-7xl flex flex-col self-center items-center justify-start">
        {totalValueCard(~totalValueLocked)}
        <Container>
          <Divider>
            {floatProtocolCard(
              ~liveSince=timestampLaunched,              
              ~totalUsers,
              ~txHash,
              ~numberOfSynths,
            )}
          </Divider>
          <Divider>
            {syntheticAssetsCard(~totalSynthValue)} {floatTokenCard(~totalFloatMinted)}
          </Divider>
          <Divider> {stakingCard(~totalValueStaked, ~global)} </Divider>
        </Container>
      </div>

    | (_, {data: Some(_), error: None, loading: false})
    | ({data: Some(_), error: None, loading: false}, _) =>
      "Query returned wrong number of results"->React.string
    | (_, {data: None, error: None, loading: false}) => "Error getting data"->React.string
    }}
  </div>
}

let default = make
