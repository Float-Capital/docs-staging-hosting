open Globals

module ClaimFloat = {
  @react.component
  let make = (~tokenAddresses) => {
    let signer = ContractActions.useSignerExn()

    let (contractExecutionHandler, txState, setTxState) = ContractActions.useContractFunction(
      ~signer,
    )

    let stakerAddress = Config.useStakerAddress()

    <Button
      onClick={_ => {
        Js.log("Claim float")
        let _ = contractExecutionHandler(
          ~makeContractInstance=Contracts.Staker.make(~address=stakerAddress),
          ~contractFunction=Contracts.Staker.claimFloat(~tokenAddresses),
        )
      }}>
      "Claim Float"
    </Button>
  }
}
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
              : <Card>
                  <div className="flex justify-between items-start w-full ">
                    <div className="flex justify-start items-center ">
                      <h3 className="text-xl"> {symbol->React.string} </h3>
                      // <AddToMetamask
                      //   tokenAddress={tokenAddress}
                      //   tokenSymbol={(tokenType->Obj.magic == "Short" ? `↘️` : `↗️`) ++
                      //   symbol->Js.String2.replaceByRe(%re("/[aeiou]/ig"), "")}
                      // />
                    </div>
                    <a
                      className="text-xs hover:text-gray-500 hover:underline  ml-5"
                      href={`https://testnet.bscscan.com/tx/${creationTxHash}`}>
                      {`Last updated ${timeSinceStaking} ago`->React.string}
                    </a>
                  </div>
                  <div className="flex justify-between items-end w-full">
                    <h4 className="text-lg"> {tokenType->Obj.magic->React.string} </h4>
                    <p className="text-primary ">
                      <a
                        target="_"
                        href={`https://testnet.bscscan.com/token/${tokenAddress->ethAdrToStr}?a=${currentUser->ethAdrToStr}`}>
                        <span className="text-bold text-4xl">
                          {amountFormatted->React.string}
                        </span>
                        {" Tokens"->React.string}
                      </a>
                    </p>
                  </div>
                </Card>
          })
          ->React.array}
        </>
      | {error: Some(_)} => "Error"->React.string
      | _ => <MiniLoader />
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
