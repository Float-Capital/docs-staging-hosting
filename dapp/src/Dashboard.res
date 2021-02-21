@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let systemStateQuery = Queries.LatestSystemState.use()

  <AccessControl
    alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
      <Login />
    </h1>}>
    // <Toggle onClick={() => Js.log("Switch to diff currency")} preLabel="BUSD" postLabel="BNB" />
    <div className="grid grid-cols-2 gap-4 items-center my-5">
      {<>
        {switch systemStateQuery {
        | {loading: true} => <MiniLoader />
        | {error: Some(_error)} => "Error loading data"->React.string
        | {data: Some({systemStates: [{totalValueLocked}]})} =>
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
          </div>
        | {data: Some(_), error: None, loading: false} =>
          "Query returned wrong number of results"->React.string
        | {data: None, error: None, loading: false} => "Error getting data"->React.string
        }}
      </>}
      <div> <MarketsList /> </div>
      <div> <StakeDetails /> </div>
    </div>
  </AccessControl>
}

let default = make
