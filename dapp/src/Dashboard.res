open DashboardLi.Props
open Masonry

module TrendingStakes = {
  open APYProvider
  @react.component
  let make = () => {
    let marketDetailsQuery = Queries.MarketDetails.use()
    let apy = APYProvider.useAPY()

    {
      switch marketDetailsQuery {
      | {loading: true} => <div className="m-auto"> <Loader.Mini /> </div>
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({syntheticMarkets})} =>
        switch apy {
        | Loaded(apyVal) => {
            let trendingStakes = DashboardCalcs.trendingStakes(~syntheticMarkets, ~apy=apyVal)
            trendingStakes
            ->Array.map(({marketName, isLong, apy, floatApy}) =>
              <DashboardStakeCard
                marketName={marketName}
                isLong={isLong}
                yield={apy}
                rewards={floatApy}
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
      {`$${totalValueLocked->FormatMoney.formatEther}`->React.string}
    </span>
  </div>

let floatProtocolCard = (
  ~liveSince,
  ~totalTxs,
  ~totalUsers,
  ~totalGasUsed,
  ~txHash,
  ~numberOfSynths,
) => {
  let dateObj = liveSince->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime

  <Card>
    <Header> {`Float Protocol 🏗️`->React.string} </Header>
    <DashboardUl
      list={[
        createDashboardLiProps(
          ~prefix=`🗓️ Live since:`,
          ~value={
            dateObj->DateFns.format(#"do MMM ''yy")
          },
          ~link={`${Config.blockExplorer}/tx/${txHash}`},
          (),
        ),
        createDashboardLiProps(
          ~prefix=`📅 Days live:`,
          ~value={
            dateObj->DateFns.formatDistanceToNow
          },
          (),
        ),
        createDashboardLiProps(
          ~prefix=`📈 No. txs:`,
          ~value=totalTxs->Ethers.BigNumber.toString,
          (),
        ),
        createDashboardLiProps(
          ~prefix=`👯‍♀️ No. users:`,
          ~value=totalUsers->Ethers.BigNumber.toString,
          (),
        ),
        createDashboardLiProps(~prefix=`👷‍♀️ No. synths:`, ~value=numberOfSynths, ()),
        createDashboardLiProps(
          ~prefix=`⛽ Gas used:`,
          ~value=totalGasUsed->Ethers.BigNumber.toString->FormatMoney.formatInt,
          (),
        ),
      ]}
    />
  </Card>
}

let syntheticAssetsCard = (~totalSynthValue) =>
  <Card>
    <Header>
      {`Synthetic Assets`->React.string} <img className="inline h-5 ml-2" src="/img/coin.png" />
    </Header>
    <div className="p-6 py-4 text-center">
      <div>
        <span className="text-sm mr-2"> {`💰 Total synth value`->React.string} </span>
        <div className="text-green-700 text-xl ">
          {`$${totalSynthValue->FormatMoney.formatEther}`->React.string}
          <span className="text-black">
            <Tooltip tip={"Redeemable value of synths in the open market"} />
          </span>
        </div>
      </div>
    </div>
    <Next.Link href="/markets">
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
    <DashboardUl
      list={[
        createDashboardLiProps(~prefix=`😏 Float price:`, ~value="...", ()),
        createDashboardLiProps(
          ~prefix=`🗳 Float supply:`,
          ~value=totalFloatMinted->FormatMoney.formatEther, //Ethers.Utils.formatEtherToPrecision(2),
          ~suffix=<Tooltip tip="The number of Float tokens in circulation" />,
          (),
        ),
        createDashboardLiProps(~prefix=`🧢 Market cap: `, ~value="...", ()),
      ]}
    />
  </Card>

let stakingCard = (~totalValueStaked) =>
  <Card>
    <Header> {`Staking 🔥`->React.string} </Header>
    <div className="text-center mt-5">
      <div className="text-sm"> {`💰 Total staked value `->React.string} </div>
      <div className="text-green-700 text-xl ">
        {`$${totalValueStaked->FormatMoney.formatEther}`->React.string}
      </div>
    </div>
    <div className="text-left mt-4 pl-4 text-sm font-bold"> {`Trending`->React.string} </div>
    <div className="pt-2 pb-5"> <TrendingStakes /> </div>
  </Card>

@react.component
let make = () => {
  let globalStateQuery = Queries.GlobalState.use()
  let marketDetailsQuery = Queries.MarketDetails.use()

  <div className="w-screen flex flex-col overflow-x-hidden">
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
              {totalFloatMinted, totalTxs, totalUsers, totalGasUsed, timestampLaunched, txHash},
            ],
          }),
        },
        {data: Some({syntheticMarkets})},
      ) =>
      let {totalValueLocked, totalValueStaked} = DashboardCalcs.getTotalValueLockedAndTotalStaked(
        syntheticMarkets,
      )
      let totalSynthValue = DashboardCalcs.getTotalSynthValue(~totalValueLocked, ~totalValueStaked)
      let numberOfSynths = (syntheticMarkets->Array.length * 2)->Int.toString

      <div className="w-full max-w-7xl flex flex-col self-center items-center justify-start">
        {totalValueCard(~totalValueLocked)}
        <Container>
          <Divider>
            {floatProtocolCard(
              ~liveSince=timestampLaunched,
              ~totalTxs,
              ~totalUsers,
              ~totalGasUsed,
              ~txHash,
              ~numberOfSynths,
            )}
          </Divider>
          <Divider>
            {syntheticAssetsCard(~totalSynthValue)} {floatTokenCard(~totalFloatMinted)}
          </Divider>
          <Divider> {stakingCard(~totalValueStaked)} </Divider>
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
