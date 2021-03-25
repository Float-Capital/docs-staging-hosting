open DashboardLi.Props

module Divider = {
  @react.component
  let make = (~children) =>
    <div className={"my-4 w-full md:w-1/3 px-3 md:px-0 md:m-4"}> {children} </div>
}

module Card = {
  @react.component
  let make = (~children) =>
    <div className={"bg-white w-full bg-opacity-75 rounded-lg shadow-lg mb-5"}> {children} </div>
}

module Header = {
  @react.component
  let make = (~children) =>
    <h1 className="font-bold text-center pt-5 text-lg font-alphbeta"> {children} </h1>
}

module TrendingStakes = {
  @react.component
  let make = () => {
    let stakeDetailsQuery = Queries.StakingDetails.use()

    {
      switch stakeDetailsQuery {
      | {loading: true} => <div className="m-auto"> <MiniLoader /> </div>
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({syntheticMarkets})} => {
          let trendingStakes = DashboardCalcs.trendingStakes(~syntheticMarkets)
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
      | {data: None, error: None, loading: false} =>
        "You might think this is impossible, but depending on the situation it might not be!"->React.string
      }
    }
  }
}

let totalValueCard = (~totalValueLocked) =>
  <div
    className={"mx-3 p-5 md:mt-7 self-center text-center bg-white bg-opacity-75 rounded-lg shadow-lg"}>
    <span className="font-alphbeta text-xl"> {"Total Value"->React.string} </span>
    <span className="text-sm"> {` 🏦 of Float Protocol: `->React.string} </span>
    <span className="text-green-700">
      {`$${totalValueLocked->FormatMoney.formatEther}`->React.string}
    </span>
  </div>

let floatProtocolCard = (~liveSince, ~totalTxs, ~totalUsers, ~totalGasUsed, ~txHash) =>
  <Card>
    <Header> {`Float Protocol 🏗️`->React.string} </Header>
    <DashboardUl
      list={[
        createDashboardLiProps(
          ~prefix=`📅 Live since:`,
          ~value={
            let dateObj = liveSince->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime
            `${dateObj->Js.Date.toDateString} (${dateObj->DateFns.formatDistanceToNow})`
          },
          ~link={`https://testnet.bscscan.com/tx/${txHash}`},
          (),
        ),
        createDashboardLiProps(
          ~prefix=`📈 No. Txs:`,
          ~value=totalTxs->Ethers.BigNumber.toString,
          (),
        ),
        createDashboardLiProps(
          ~prefix=`👯‍♀️ No. Users:`,
          ~value=totalUsers->Ethers.BigNumber.toString,
          (),
        ),
        createDashboardLiProps(
          ~prefix=`⛽ Gas used:`,
          ~value=totalGasUsed->Ethers.BigNumber.toString,
          (),
        ),
      ]}
    />
  </Card>

let syntheticAssetsCard = (~totalSynthValue, ~numberOfSynths) =>
  <Card>
    <Header>
      {`Synthetic Assets`->React.string} <img className="inline h-5 ml-2" src="/img/coin.png" />
    </Header>
    <DashboardUl
      list=[
        createDashboardLiProps(
          ~prefix=`💰 Total Synth Value: `,
          ~value=`$${totalSynthValue->FormatMoney.formatEther}`,
          ~suffix=<Tooltip tip={"Redeemable value of synths in the open market"} />,
          (),
        ),
        createDashboardLiProps(~prefix=`👷‍♀️ No. Synths:`, ~value=numberOfSynths, ()),
      ]
    />
    <Next.Link href="/markets">
      <div className="w-full p-4 pr-5 text-sm cursor-pointer">
        <div className="ml-10"> {`👀 See Markets`->React.string} </div>
        <div className="ml-20"> {`to learn more...`->React.string} </div>
      </div>
    </Next.Link>
  </Card>

let floatTokenCard = (~totalFloatMinted) =>
  <Card>
    <Header> {`🌊🌊 Float Token 🌊🌊`->React.string} </Header>
    <DashboardUl
      list={[
        createDashboardLiProps(~prefix=`😏 Float Price:`, ~value="...", ()),
        createDashboardLiProps(
          ~prefix=`🕶️ Float Supply:`,
          ~value=totalFloatMinted->Ethers.Utils.formatEtherToPrecision(2),
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
      <span className="text-sm mr-1"> {`💰 Total Staked Value: `->React.string} </span>
      {`$${totalValueStaked->FormatMoney.formatEther}`->React.string}
    </div>
    <div className="text-center mt-5 text-sm"> {`Trending`->React.string} </div>
    <div className="pt-2 pb-5"> <TrendingStakes /> </div>
  </Card>

@react.component
let make = () => {
  let globalStateQuery = Queries.GlobalState.use()
  let marketDetailsQuery = Queries.MarketDetails.use()

  <div className="w-screen absolute flex flex-col left-0 top-0 mt-20 overflow-x-hidden">
    {switch (globalStateQuery, marketDetailsQuery) {
    | ({loading: true}, _)
    | (_, {loading: true}) =>
      <MiniLoader />
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

      <div className="min-w-3/4 max-w-full flex flex-col self-center items-center justify-start">
        {totalValueCard(~totalValueLocked)}
        <div className={"w-full flex flex-col md:flex-row justify-between mt-1"}>
          <Divider>
            {floatProtocolCard(
              ~liveSince=timestampLaunched,
              ~totalTxs,
              ~totalUsers,
              ~totalGasUsed,
              ~txHash,
            )}
          </Divider>
          <Divider>
            {syntheticAssetsCard(~totalSynthValue, ~numberOfSynths)}
            {floatTokenCard(~totalFloatMinted)}
          </Divider>
          <Divider> {stakingCard(~totalValueStaked)} </Divider>
        </div>
      </div>

    | (_, {data: Some(_), error: None, loading: false})
    | ({data: Some(_), error: None, loading: false}, _) =>
      "Query returned wrong number of results"->React.string
    | (_, {data: None, error: None, loading: false}) => "Error getting data"->React.string
    }}
  </div>
}

let default = make
