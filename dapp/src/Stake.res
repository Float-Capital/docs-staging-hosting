module Stake = {
  type synthenticTokensType = {
    // id: Ethers.ethAddress,
    id: string,
    symbol: string,
    apy: float,
    balance: float,
    position: string,
  }

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let (_hasSyntheticTokens, _setHasSyntheticTokens) = React.useState(_ => true)

    let isHotAPY = apy => apy > 0.15
    let isShort = position => position == "short" // improve with types structure

    let synthenticTokens = [
      {
        id: "0x00",
        symbol: "ethK",
        position: "long",
        apy: 0.11,
        balance: 0.,
      },
      {
        id: "0x01",
        symbol: "ethK",
        position: "short",
        balance: 10.,
        apy: 0.11,
      },
      {
        id: "0x02",
        symbol: "ebdom",
        position: "long",
        balance: 0.,
        apy: 0.2,
      },
      {
        id: "0x03",
        symbol: "ebdom",
        position: "short",
        balance: 0.,
        apy: 0.2,
      },
    ]

    let tokenId = router.query->Js.Dict.get("tokenId")

    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
        {"login to view this"->React.string}
      </h1>}>
      <ViewBox>
        <h1> {"Stake"->React.string} </h1>
        {synthenticTokens
        ->Array.map(token => {
          <Card key=token.symbol>
            <div className="flex justify-between items-center w-full">
              <div className="flex flex-col">
                <h3 className="font-bold"> {"Token"->React.string} </h3>
                <p>
                  {token.symbol->React.string}
                  {(token.position->isShort ? `↘️` : `↗️`)->React.string}
                </p>
              </div>
              <div className="flex flex-col">
                <h3 className="font-bold"> {"Balance"->React.string} </h3>
                <p> {token.balance->Belt.Float.toString->React.string} </p>
              </div>
              <div className="flex flex-col">
                <h3 className="font-bold">
                  {`R `->React.string} <span className="text-xs"> {`ℹ️`->React.string} </span>
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
        {switch tokenId {
        | Some(id) => id->React.string
        | _ => React.null
        }}
      </ViewBox>
    </AccessControl>
  }
}
let default = () => <Stake />
