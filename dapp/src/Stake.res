module Stake = {
  type synthenticTokensType = {
    // id: Ethers.ethAddress,
    id: string,
    symbol: string,
    apy: float,
    balance: float,
    tokenType: string,
  }

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let (_hasSyntheticTokens, _setHasSyntheticTokens) = React.useState(_ => true)

    let isHotAPY = apy => apy > 0.15
    let isShort = tokenType => tokenType == "short" // improve with types structure

    let (synthenticTokens, setSyntheticTokens) = React.useState(() => [])
    let tokens = Queries.SyntheticTokens.use()

    let tokenId = router.query->Js.Dict.get("tokenId")

    React.useEffect1(() => {
      switch tokens {
      | {loading: true} => None
      | {error: Some(_error)} => {
          Js.log("error")
          setSyntheticTokens(_ => [])
          None
        }
      | {data: Some({syntheticTokens})} => {
          setSyntheticTokens(_ =>
            syntheticTokens
            ->Array.map(({id, syntheticMarket: {name: symbol}, tokenType}) => {
              id: id,
              symbol: symbol,
              apy: 0.2,
              balance: 0., /// need to pull this in at some stage
              tokenType: tokenType->Js.String2.make->Js.String.toLowerCase,
            })
            ->SortArray.stableSortBy((a, b) =>
              switch Js.String.localeCompare(a.symbol, b.symbol) {
              | greater when greater > 0.0 => -1
              | lesser when lesser < 0.0 => 1
              | _ =>
                switch (a.tokenType, b.tokenType) {
                | ("long", "short") => -1
                | ("short", "long") => 1
                | (_, _) => 0
                }
              }
            )
          )
          None
        }
      | {data: None, error: None, loading: false} => {
          setSyntheticTokens(_ => [])
          Js.log(
            "You might think this is impossible, but depending on the situation it might not be!",
          )
          None
        }
      }
    }, [tokens])

    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
        {"login to view this"->React.string}
      </h1>}>
      <ViewBox>
        {switch tokenId {
        | Some(tokenId) => <div> <StakeForm tokenId={tokenId} /> </div>
        | _ => <>
            <h1> {"Stake"->React.string} </h1>
            {synthenticTokens
            ->Array.map(token => {
              <Card key={token.symbol ++ token.tokenType}>
                <div className="flex justify-between items-center w-full">
                  <div className="flex flex-col">
                    <h3 className="font-bold"> {"Token"->React.string} </h3>
                    <p>
                      {token.symbol->React.string}
                      {(token.tokenType->isShort ? `↘️` : `↗️`)->React.string}
                    </p>
                  </div>
                  <div className="flex flex-col">
                    <h3 className="font-bold"> {"Balance"->React.string} </h3>
                    <p> {token.balance->Belt.Float.toString->React.string} </p>
                  </div>
                  <div className="flex flex-col">
                    <h3 className="font-bold">
                      {`R `->React.string}
                      <span className="text-xs"> {`ℹ️`->React.string} </span>
                    </h3>
                    <p>
                      {`${(token.apy *. 100.)->Belt.Float.toString}%${token.apy->isHotAPY
                          ? `🔥`
                          : ""}`->React.string}
                    </p>
                  </div>
                  <Button
                    onClick={_ => {
                      router->Next.Router.push(`/stake?tokenId=${token.id}`)
                    }}
                    variant="small">
                    "STAKE"
                  </Button>
                </div>
              </Card>
            })
            ->React.array}
          </>
        }}
      </ViewBox>
    </AccessControl>
  }
}
let default = () => <Stake />
