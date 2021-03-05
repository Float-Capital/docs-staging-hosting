open DashboardLi.Props

module DashboardColumn = {
  @react.component
  let make = (~children) => <div className={"m-4 w-1/3"}>{children}</div>
} 

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let globalStateQuery = Queries.GlobalState.use()
  let marketDetailsQuery = Queries.MarketDetails.use()

  <AccessControl
    alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
      <Login />
    </h1>}>
    // <Toggle onClick={() => Js.log("Switch to diff currency")} preLabel="BUSD" postLabel="BNB" />
    <div className="w-screen absolute flex flex-col left-0 top-0 mt-20">
      {<>
        {switch (globalStateQuery, marketDetailsQuery){
        | ({loading: true}, _) 
        | (_, {loading: true}) => <MiniLoader />
        | ({error: Some(_error)}, _)
        | (_, {error: Some(_error)}) => "Error loading data"->React.string
        | (
            {
              data: 
                Some(
                  {
                    globalStates: 
                    [{
                        totalFloatMinted,
                        totalTxs,
                        totalUsers,
                        totalGasUsed
                    }]
                  })
            },
            {
              data: 
                Some({syntheticMarkets})
            }
          ) => {

        let { totalValueLocked, totalValueStaked } = DashboardCalcs.getTotalValueLockedAndTotalStaked(syntheticMarkets)
        let totalSynthValue = DashboardCalcs.getTotalSynthValue(~totalValueLocked, ~totalValueStaked)
        let numberOfSynths = ((syntheticMarkets->Array.length) * 2)->Js.String2.make

        <div className="min-w-3/4 flex flex-col self-center items-center justify-start">
          <div className={"p-5 mt-7 self-center text-center  bg-white bg-opacity-75 rounded-lg shadow-lg"}>
            <span className="font-alphbeta text-xl">{"Total Value"->React.string}</span>
            <span className="text-sm">{` 🏦 of Float Protocol: `->React.string}</span>
            <span className="text-green-700">{`$${totalValueLocked->FormatMoney.formatEther}`->React.string}</span>
          </div>

          <div className={"w-full flex justify-between mt-1"}>
            <DashboardColumn>
              <DashboardColumnCard>
                <DashboardHeader>
                    {`Float Protocol 🏗️`->React.string}
                </DashboardHeader>

                <DashboardUl list={
                  [
                    createDashboardLiProps(
                      ~prefix = `📅 Live since:`,
                      ~value = "28/02/2020", ()
                    ),
                    createDashboardLiProps(
                      ~prefix = `📈 No. Txs:`,
                      ~value = `${totalTxs->Ethers.BigNumber.toString}`, ()
                    ),
                    createDashboardLiProps(
                      ~prefix = `👯‍♀️ No. Users:`,
                      ~value = `${totalUsers->Ethers.BigNumber.toString}`, ()
                    ),
                    createDashboardLiProps(
                      ~prefix = `⛽ Gas used:`,
                      ~value = `${totalGasUsed->Ethers.BigNumber.toString}`, ()
                    )
                  ]
                }
               />
              </DashboardColumnCard>
            </DashboardColumn>

            <DashboardColumn>
        
              <DashboardColumnCard>
                
                <DashboardHeader>
                    {`Synthetic Assets`->React.string}
                     <img className="inline h-5 ml-2" src="/img/coin.png"/>
                </DashboardHeader>

                <DashboardUl list=[
                  createDashboardLiProps(
                    ~prefix = `💰 Total Synth Value`,
                    ~value = `$${totalSynthValue->FormatMoney.formatEther}`,
                    ~suffix=<Tooltip tip={"Redeemable value of synths in the open market"}/>,
                    ()
                  ),
                  createDashboardLiProps(
                    ~prefix = `👷‍♀️ No. Synths:`,
                    ~value = `${numberOfSynths}`, ()
                  ) 
                ]/>

                <Next.Link href="/markets">
                  <div className="w-full p-4 pr-5 text-sm cursor-pointer">
                    <div className="ml-10">{`👀 See Markets`->React.string}</div>
                    <div className="ml-20">{`to learn more...`->React.string}</div>
                  </div>
                </Next.Link>
              </DashboardColumnCard>


              <DashboardColumnCard>
                <DashboardHeader>
                    {`🌊🌊 Float Token 🌊🌊`->React.string}
                </DashboardHeader>

                <DashboardUl list={
                  [
                    createDashboardLiProps(
                      ~prefix = `😏 Float Price:`,
                      ~value = "...", ()
                    ),
                    createDashboardLiProps(
                      ~prefix = `🕶️ Float Supply:`,
                      ~value = `${totalFloatMinted->Ethers.Utils.formatEtherToPrecision(2)}`,
                      ~suffix=<Tooltip tip="The number of Float tokens in circulation"/>,
                      ()
                    ),
                    createDashboardLiProps(
                      ~prefix = `🧢 Market cap: `,
                      ~value = "...", ()
                    )
                  ]
                }/>
              </DashboardColumnCard>
            </DashboardColumn>

            <DashboardColumn>
              <DashboardColumnCard>
                <DashboardHeader>
                    {`Staking 🔥`->React.string}
                </DashboardHeader>

                <div className="text-center mt-5">
                  <span className="text-sm mr-1">
                  {`💰 Total Staked Value`->React.string}
                  </span>
                  {`$${totalValueStaked->FormatMoney.formatEther}`->React.string}
                </div>

                <div className="text-center mt-5 text-sm">
                  {`Trending`->React.string}
                </div>

                <div className="pt-2 pb-5">

                <DashboardStakeCard 
                  marketName={"FTSE100"}
                  isLong={true}
                  yieldStr={"87.5%"} 
                  rewardsStr={"637%"}/>

                <DashboardStakeCard 
                  marketName={"FTSE100"}
                  isLong={true}
                  yieldStr={"87.5%"} 
                  rewardsStr={"637%"}/>


                </div>
              </DashboardColumnCard>
            </DashboardColumn>
          </div>
         </div>
          // <div className="col-span-2">
          //   <div
          //     className="p-5 flex flex-col items-center justify-center bg-white bg-opacity-75 rounded">
          //     <h2 className="text-lg"> {"Total value locked"->React.string} </h2>
          //     <p className="text-primary text-4xl">
          //       {`BUSD ${totalValueLocked->FormatMoney.formatEther}`->React.string}
          //     </p>
          //   </div>
          // </div>
        }
        | (_, {data: Some(_), error: None, loading: false}) 
        | ({data: Some(_), error: None, loading: false}, _) =>
          "Query returned wrong number of results"->React.string
        | (_, {data: None, error: None, loading: false}) => "Error getting data"->React.string
            // ^ the other side of this was giving me a "this pattern is unused" for some reason
        }}
      </>}
      // <div> <MarketsList /> </div>
      // <div> <StakeDetails /> </div>
    </div>
  </AccessControl>
}

let default = make
