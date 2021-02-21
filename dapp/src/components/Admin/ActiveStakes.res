open Globals

@react.component
let make = () => {
  let currentUser = RootProvider.useCurrentUserExn()
  let activeStakes = DataFetchers.useUsersStakes(~address=currentUser)

  switch activeStakes {
  | {data: Some({currentStakes: []})} => "NO ACTIVE STAKES"->React.string
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
        let totalStakedFormatted = FormatMoney.formatMoney(
          ~number=totalStaked
          ->Ethers.Utils.formatEther
          ->Float.fromString
          ->Option.getWithDefault(0.),
        )
        <div>
          <h1> {`${name}(${symbol})`->React.string} </h1>
          <p>
            {`Stake of ${amountFormatted} for ${tokenType->Obj.magic} at address ${tokenAddress->ethAdrToStr}, which is ${withdrawn
                ? "withdrawn"
                : "still active"}. This stake was created at ${timestamp->Ethers.BigNumber.toString}, in transaction ${creationTxHash}. Total staked: ${totalStakedFormatted}`->React.string}
          </p>
        </div>
      })
      ->React.array}
    </>
  | {error: Some(_)} => "Error"->React.string
  | _ => "Loading"->React.string
  }
}
