open Globals

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let systemStateQuery = Queries.LatestSystemState.use()

  <AccessControl
    alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
      <Login />
    </h1>}>
    <Toggle onClick={() => Js.log("Switch to diff currency")} preLabel="BUSD" postLabel="BNB" />
    <div className="grid grid-cols-2 gap-4 items-center my-5">
      {<>
        {switch systemStateQuery {
        | {loading: true} => <MiniLoader />
        | {error: Some(_error)} => "Error loading data"->React.string
        | {
            data: Some({
              systemStates: [
                {
                  // timestamp,
                  // txHash,
                  // blockNumber,
                  // syntheticPrice,
                  // longTokenPrice,
                  // shortTokenPrice,
                  totalLockedLong,
                  totalLockedShort,
                  totalValueLocked,
                  // setBy,
                },
              ],
            }),
          } =>
          <div className="col-span-2">
            <div
              className="p-5 flex flex-col items-center justify-center bg-white bg-opacity-75 rounded">
              <h2 className="text-lg"> {"Total value locked"->React.string} </h2>
              <p className="text-primary text-4xl">
                {"BUSD "->React.string}
                <FormatMoney
                  number={totalValueLocked
                  ->Ethers.Utils.formatEther
                  ->Float.fromString
                  ->Option.getWithDefault(0.)}
                />
              </p>
            </div>
            <div className="grid grid-cols-2 gap-2">
              <Card>
                <h2 className="text-lg"> {"Total short value locked"->React.string} </h2>
                <p className="text-primary text-2xl">
                  {"BUSD "->React.string}
                  <FormatMoney
                    number={totalLockedShort
                    ->Ethers.Utils.formatEther
                    ->Float.fromString
                    ->Option.getWithDefault(0.)}
                  />
                </p>
              </Card>
              <Card>
                <h2 className="text-lg"> {"Total long value locked"->React.string} </h2>
                <p className="text-primary text-2xl">
                  {"BUSD "->React.string}
                  <FormatMoney
                    number={totalLockedLong
                    ->Ethers.Utils.formatEther
                    ->Float.fromString
                    ->Option.getWithDefault(0.)}
                  />
                </p>
              </Card>
            </div>
          </div>
        | {data: Some(_), error: None, loading: false} =>
          "Query returned wrong number of results"->React.string
        | {data: None, error: None, loading: false} =>
          "You might think this is impossible, but depending on the situation it might not be!"->React.string
        }}
      </>}
      <div> <MarketsList /> </div>
      <div> <StakeDetails /> </div>
    </div>
    {Config.isDevMode
      ? {
          switch systemStateQuery {
          | {loading: true} => <MiniLoader />
          | {error: Some(_error)} => "Error loading data"->React.string
          | {
              data: Some({
                systemStates: [
                  {
                    timestamp,
                    txHash,
                    // blockNumber,
                    syntheticPrice,
                    longTokenPrice,
                    shortTokenPrice,
                    totalLockedLong,
                    totalLockedShort,
                    totalValueLocked,
                    setBy,
                  },
                ],
              }),
            } =>
            let timeSinceUpdate = timestamp->timestampToDuration

            <>
              <br />
              <br />
              <br />
              <br />
              <h1> {"Dashboard"->React.string} </h1>
              <DaiBalance />
              <a href={`https://goerli.etherscan.io/tx/${txHash}`}>
                {`Latest update happened ${timeSinceUpdate} ago. (view on block-explorer) by ${setBy}`->React.string}
              </a>
              <p> {`SyntheticPrice ${syntheticPrice->Ethers.Utils.formatEther}$`->React.string} </p>
              <p>
                {`Long Token Price ${longTokenPrice->Ethers.Utils.formatEther}$`->React.string}
              </p>
              <p>
                {`Short Token Price ${shortTokenPrice->Ethers.Utils.formatEther}$`->React.string}
              </p>
              <p>
                {`Total locked long ${totalLockedLong->Ethers.Utils.formatEther}$`->React.string}
              </p>
              <p>
                {`Total Locked Short ${totalLockedShort->Ethers.Utils.formatEther}$`->React.string}
              </p>
              <p> {`Total Locked ${totalValueLocked->Ethers.Utils.formatEther}$`->React.string} </p>
              <p> {"TODO:"->React.string} </p>
              <p> {"show the ratio of long to short in the same chart"->React.string} </p>
              <p> {"show historic returns of long asset (history APY)"->React.string} </p>
              <p> {"show current APY on opposing side (probably short)"->React.string} </p>
            </>
          | {data: Some(_), error: None, loading: false} =>
            "Query returned wrong number of results"->React.string
          | {data: None, error: None, loading: false} =>
            "You might think this is impossible, but depending on the situation it might not be!"->React.string
          }
        }
      : React.null}
  </AccessControl>
}

let default = make
