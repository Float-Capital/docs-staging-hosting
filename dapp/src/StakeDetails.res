open Globals

@react.component
let make = () => {
  let currentUser = RootProvider.useCurrentUserExn()
  let activeStakes = DataFetchers.useUsersStakes(~address=currentUser)

  <div className="p-5 flex flex-col items-center justify-center bg-white bg-opacity-75  rounded">
    <h2 className="text-4xl"> {"Stake"->React.string} </h2>
    {switch activeStakes {
    | {data: Some({currentStakes: []})} => <h2> {"You have no active stakes."->React.string} </h2>
    | {data: Some({currentStakes})} => <>
        {currentStakes
        ->Array.map(({
          currentStake: {
            timestamp,
            creationTxHash,
            tokenType: {tokenAddress, totalStaked, tokenType, syntheticMarket: {name, symbol}},
            amount,
            withdrawn,
          },
        }) => {
          let amountFormatted = FormatMoney.formatMoney(
            ~number=amount->Ethers.Utils.formatEther->Float.fromString->Option.getWithDefault(0.),
          )
          // let totalStakedFormatted = FormatMoney.formatMoney(
          //   ~number=totalStaked
          //   ->Ethers.Utils.formatEther
          //   ->Float.fromString
          //   ->Option.getWithDefault(0.),
          // )
          let timeSinceStaking = timestamp->timestampToDuration

          withdrawn
            ? {
                Js.log(
                  "This is a bug in the graph, no withdrawn stakes should show in the `currentStakes`",
                )
                React.null
              }
            : <>
                <h3 className="text-xl"> {`${name}(${symbol})`->React.string} </h3>
                <p>
                  {`Stake of ${amountFormatted} `->React.string}
                  <a
                    target="_"
                    href={`https://testnet.bscscan.com/token/${tokenAddress}?a=${currentUser->ethAdrToStr}`}>
                    {tokenType->Obj.magic->React.string}
                  </a>
                </p>
                <p>
                  <a href={`https://testnet.bscscan.com/tx/${creationTxHash}`}>
                    {`Last updated ${timeSinceStaking} ago`->React.string}
                  </a>
                </p>
              </>
        })
        ->React.array}
      </>
    | {error: Some(_)} => "Error"->React.string
    | _ => "Loading"->React.string
    }}
  </div>
}
