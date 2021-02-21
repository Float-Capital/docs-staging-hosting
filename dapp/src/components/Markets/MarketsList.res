@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let marketDetailsQuery = Queries.MarketDetails.use()

  <AccessControl
    alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
      <Login />
    </h1>}>
    <div className="p-5 flex flex-col bg-white bg-opacity-75  rounded">
      <h2 className="text-lg font-medium"> {"Markets"->React.string} </h2>
      <div className="flex justify-between items-center w-full mt-3">
        <p className="font-bold underline"> {"Market"->React.string} </p>
        <p className="font-bold underline"> {"Symbol"->React.string} </p>
        <p className="font-bold underline"> {"Long staked"->React.string} </p>
        <p className="font-bold underline"> {"Short staked"->React.string} </p>
        <p className="font-bold underline"> {"Action"->React.string} </p>
      </div>
      {switch marketDetailsQuery {
      | {loading: true} => <div className="m-auto"> <MiniLoader /> </div>
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({syntheticMarkets})} => <>
          {syntheticMarkets
          ->Array.map(({
            name,
            symbol,
            marketIndex,
            syntheticLong: {
              // id: idLong,
              // tokenAddress: tokenAddressLong,
              totalStaked: totalStakedLong,
            },
            syntheticShort: {
              // id: idShort,
              // tokenAddress: tokenAddressShort,
              totalStaked: totalStakedShort,
            },
          }) =>
            <div className="flex justify-between items-center w-full" key=symbol>
              <p> {name->React.string} </p>
              <p> {symbol->React.string} </p>
              <p> {totalStakedLong->Ethers.Utils.formatEther->React.string} </p>
              <p> {totalStakedShort->Ethers.Utils.formatEther->React.string} </p>
              <div className="grid grid-cols-2 gap-2">
                <Button
                  onClick={_ => {
                    router->Next.Router.push(
                      `/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}`,
                    )
                  }}
                  variant="small">
                  "Mint"
                </Button>
                <Button
                  onClick={_ => {
                    router->Next.Router.push(
                      `/redeem?marketIndex=${marketIndex->Ethers.BigNumber.toString}`,
                    )
                  }}
                  variant="small">
                  "Redeem"
                </Button>
              </div>
            </div>
          )
          ->React.array}
        </>
      | {data: None, error: None, loading: false} =>
        "You might think this is impossible, but depending on the situation it might not be!"->React.string
      }}
    </div>
  </AccessControl>
}
