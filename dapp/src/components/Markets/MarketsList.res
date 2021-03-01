@react.component
let make = () => {
  let router = Next.Router.useRouter()
  let marketDetailsQuery = Queries.MarketDetails.use()

  <AccessControl
    alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
      <Login />
    </h1>}>
    <div className="w-full max-w-4xl mx-auto">
      // <h2 className="text-xl font-medium"> {"Markets"->React.string} </h2>
      // // <div className="flex justify-between items-center w-full mt-3">
      // <div className="grid grid-cols-4 gap-1 items-center">
      //   <p className="font-bold underline text-xs"> {"Market"->React.string} </p>
      //   // <p className="font-bold underline"> {"Symbol"->React.string} </p>
      //   <p className="font-bold underline  text-xs"> {"Long Liquidity"->React.string} </p>
      //   <p className="font-bold underline text-xs"> {"Short Liquidity"->React.string} </p>
      //   <p className="font-bold underline text-xs"> {""->React.string} </p>
      // </div>
      {switch marketDetailsQuery {
      | {loading: true} => <div className="m-auto"> <MiniLoader /> </div>
      | {error: Some(_error)} => "Error loading data"->React.string
      | {data: Some({syntheticMarkets})} => <>
          {syntheticMarkets
          ->Array.map(({
            name,
            marketIndex,
            latestSystemState: {totalLockedLong, totalLockedShort, totalValueLocked},
          }) =>
            // // <div className="flex justify-between items-center w-full" key=symbol>
            // <div className="grid grid-cols-4 gap-1 items-center">
            //   <p> {name->React.string} </p>
            //   // <p> {symbol->React.string} </p>
            //   <p> {`$${totalLockedLong->FormatMoney.formatEther}`->React.string} </p>
            //   <p> {`$${totalLockedShort->FormatMoney.formatEther}`->React.string} </p>
            //   // <div className="grid grid-cols-2 gap-2">
            //   <Button
            //     onClick={_ => {
            //       router->Next.Router.push(
            //         `/mint?marketIndex=${marketIndex->Ethers.BigNumber.toString}`,
            //       )
            //     }}
            //     variant="small">
            //     "Mint"
            //   </Button>
            //   // </div>
            // </div>
            <MarketCard 
              key={name}
              marketName={name}
              totalLockedLong={totalLockedLong}
              totalLockedShort={totalLockedShort}
              totalValueLocked={totalValueLocked}
              router={router}
              marketIndex={marketIndex}
            />
          )
          ->React.array}
        </>
      | {data: None, error: None, loading: false} =>
        "You might think this is impossible, but depending on the situation it might not be!"->React.string
      }}
    </div>
  </AccessControl>
}
