open Globals

module UsersActiveStakes = {
  @react.component
  let make = (~currentUser) => {
    let activeStakes = DataFetchers.useUsersStakes(~address=currentUser)
    <div className="flex flex-col">
      <h2 className="text-xl"> {"Your stakes"->React.string} </h2>
      {switch activeStakes {
      | {data: Some({currentStakes: []})} => <h2> {"You have no active stakes."->React.string} </h2>
      | {data: Some({currentStakes})} => <>
          {currentStakes
          ->Array.map(({
            currentStake: {
              timestamp,
              creationTxHash,
              syntheticToken: {
                tokenAddress,
                /* totalStaked, */ tokenType,
                syntheticMarket: {/* name, */ symbol},
              },
              amount,
              withdrawn,
            },
          }) => {
            let amountFormatted = FormatMoney.formatEther(amount)
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
              : <Card>
                  <div className="flex justify-between items-start w-full ">
                    <div className="flex justify-start items-center ">
                      <h3 className="text-xl"> {symbol->React.string} </h3>
                    </div>
                    <a
                      className="text-xs hover:text-gray-500 hover:underline  ml-5"
                      href={`${Config.blockExplorer}/tx/${creationTxHash}`}>
                      {`Last updated ${timeSinceStaking} ago`->React.string}
                    </a>
                  </div>
                  <div className="flex justify-between items-end w-full">
                    <h4 className="text-lg"> {tokenType->Obj.magic->React.string} </h4>
                    <p className="text-primary ">
                      <a
                        target="_"
                        rel="noopener noreferrer"
                        href={`${Config.blockExplorer}/token/${tokenAddress->ethAdrToStr}?a=${currentUser->ethAdrToStr}`}>
                        <span className="text-bold text-4xl">
                          {amountFormatted->React.string}
                        </span>
                        {" Tokens"->React.string}
                      </a>
                    </p>
                    <div className="flex items-center">
                      <ClaimFloatImmediatlyPerToken tokenAddress />
                    </div>
                  </div>
                </Card>
          })
          ->React.array}
        </>
      | {error: Some(_)} => "Error"->React.string
      | _ => <Loader.Mini />
      }}
    </div>
  }
}

@react.component
let make = () => {
  let optCurrentUser = RootProvider.useCurrentUser()

  switch optCurrentUser {
  | None => "Login to view your stakes"->React.string
  | Some(currentUser) => <UsersActiveStakes currentUser />
  }
}
