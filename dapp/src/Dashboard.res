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
      | {loading: true} => <div className="m-auto"> <MiniLoader /> </div>
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
        | _ => <MiniLoader />
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
    <span className="text-green-700">
      {`$${totalValueLocked->FormatMoney.formatEther}`->React.string}
    </span>
  </div>

// let joinedStr = userInfo.joinedAt->DateFns.format("do MMM yyyy")
let floatProtocolCard = (~liveSince, ~totalTxs, ~totalUsers, ~totalGasUsed, ~txHash) =>
  <Card>
    <Header> {`Float Protocol 🏗️`->React.string} </Header>
    <DashboardUl
      list={[
        createDashboardLiProps(
          ~prefix=`📅 Live since:`,
          ~value={
            let dateObj = liveSince->Ethers.BigNumber.toNumberFloat->DateFns.fromUnixTime
            `${dateObj->DateFns.format("do MMM ''yy")} (${dateObj->DateFns.formatDistanceToNow})`
          },
          ~link={`${Config.blockExplorer}/tx/${txHash}`},
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
        createDashboardLiProps(
          ~prefix=`⛽ Gas used:`,
          ~value=totalGasUsed->Ethers.BigNumber.toString->FormatMoney.formatInt,
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
          ~prefix=`💰 Total synth value: `,
          ~value=`$${totalSynthValue->FormatMoney.formatEther}`,
          ~suffix=<Tooltip tip={"Redeemable value of synths in the open market"} />,
          (),
        ),
        createDashboardLiProps(~prefix=`👷‍♀️ No. synths:`, ~value=numberOfSynths, ()),
      ]
    />
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
          ~prefix=`🕶️ Float supply:`,
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
      <span className="text-sm mr-1"> {`💰 Total staked value: `->React.string} </span>
      <span className="text-green-700">
        {`$${totalValueStaked->FormatMoney.formatEther}`->React.string}
      </span>
    </div>
    <div className="text-left mt-4 pl-4 text-sm"> {`Trending`->React.string} </div>
    <div className="pt-2 pb-5"> <TrendingStakes /> </div>
  </Card>

@react.component
let make = () => {
  let globalStateQuery = Queries.GlobalState.use()
  let marketDetailsQuery = Queries.MarketDetails.use()

  <div className="w-screen absolute flex flex-col left-0 top-0 mt-40 overflow-x-hidden">
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
        <Container>
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
