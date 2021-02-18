module Stake = {
  type synthenticTokensType = {
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
        symbol: "ethK",
        position: "long",
        apy: 0.11,
        balance: 0.,
      },
      {
        symbol: "ethK",
        position: "short",
        balance: 10.,
        apy: 0.11,
      },
      {
        symbol: "ebdom",
        position: "long",
        balance: 0.,
        apy: 0.2,
      },
      {
        symbol: "ebdom",
        position: "short",
        balance: 0.,
        apy: 0.2,
      },
    ]

    <AccessControl
      alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/dashboard")}>
        {"login to view this"->React.string}
      </h1>}>
      <section>
        <div className="flex flex-col max-w-xl m-auto p-6 border-white border-solid border-4">
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
                    router->Next.Router.push(`/stake?token=${token.symbol}+${token.position}`)
                  }}
                  variant="small">
                  "STAKE"
                </Button>
              </div>
            </Card>
          })
          ->React.array}
        </div>
      </section>
    </AccessControl>
  }
}
let default = () => <Stake />
