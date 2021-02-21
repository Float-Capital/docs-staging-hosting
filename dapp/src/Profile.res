module Profile = {
  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let userAddress = router.query->Js.Dict.get("address")
    let isShort = tokenType => tokenType == "short" // improve with types structure
    let tokens = Queries.SyntheticTokens.use()
    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push(`/login?nextPath=/`)}>
        <Login />
      </h1>}>
      <section>
        {switch userAddress {
        | Some(address) =>
          <div>
            <p className="text-xs"> {"User: "->React.string} {address->React.string} </p>
            <div className="flex w-full justify-between">
              <div className="w-full mr-3">
                <Card> <DaiBalance /> </Card>
                {switch tokens {
                | {loading: true} => <MiniLoader />
                | {error: Some(_error)} => "There was an error loading the tokens"->React.string
                | {data: Some({syntheticTokens})} =>
                  syntheticTokens
                  ->Array.map(({id, syntheticMarket: {name: symbol}, tokenType}) => {
                    <Card>
                      <div className="flex justify-between w-full">
                        <div className="flex items-center ">
                          <div className="mr-2">
                            <AddToMetamask
                              tokenAddress={id}
                              tokenSymbol={(
                                tokenType->Js.String2.make->Js.String.toLowerCase->isShort
                                  ? `↘️`
                                  : `↗️`
                              ) ++
                              symbol->Js.String2.replaceByRe(%re("/[aeiou]/ig"), "")}
                            />
                          </div>
                          {`${symbol} `->React.string}
                          {`${tokenType
                            ->Js.String2.make
                            ->Js.String.toLowerCase} balance: `->React.string}
                        </div>
                        <div className="ml-2">
                          <TokenBalance erc20Address={id->Ethers.Utils.getAddressUnsafe} />
                        </div>
                      </div>
                    </Card>
                  })
                  ->React.array
                | {data: None, error: None, loading: false} =>
                  "You might think this is impossible, but depending on the situation it might not be!"->React.string
                }}
              </div>
              <div className="w-full ml-3"> <StakeDetails /> </div>
            </div>
          </div>
        | _ => React.null
        }}
      </section>
    </AccessControl>
  }
}
let default = () => <Profile />
