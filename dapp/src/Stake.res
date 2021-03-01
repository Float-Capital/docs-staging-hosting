module Stake = {
  type synthenticTokensType = {
    // id: Ethers.ethAddress,
    id: string,
    symbol: string,
    apy: float,
    tokenType: string,
    totalStaked: Ethers.BigNumber.t,
    totalLockedLong: Ethers.BigNumber.t,
    totalLockedShort: Ethers.BigNumber.t,
  }

  @react.component
  let make = () => {
    let router = Next.Router.useRouter()
    let (_hasSyntheticTokens, _setHasSyntheticTokens) = React.useState(_ => true)

    let isHotAPY = apy => apy > 0.15
    let isShort = tokenType => tokenType == "short" // improve with types structure

    let mapVal = apy =>
      `${(apy *. 100.)->Js.Float.toFixedWithPrecision(~digits=2)}%${apy->isHotAPY
          ? `🔥`
          : ""}`->React.string

    let basicApyCalc = (busdApy: float, longVal: float, shortVal: float, tokenType) => {
      switch tokenType {
      | "long" =>
        switch longVal {
        | 0.0 => busdApy
        | _ => busdApy *. shortVal /. longVal
        }
      | "short" =>
        switch shortVal {
        | 0.0 => busdApy
        | _ => busdApy *. longVal /. shortVal
        }
      | _ => busdApy
      }
    }

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
            ->Array.map(({
              id,
              syntheticMarket: {
                name: symbol,
                latestSystemState: {totalLockedLong, totalLockedShort},
              },
              tokenType,
              totalStaked,
            }) => {
              {
                id: id,
                symbol: symbol,
                apy: 0.2,
                totalLockedLong: totalLockedLong,
                totalLockedShort: totalLockedShort,
                tokenType: tokenType->Js.String2.make->Js.String.toLowerCase,
                totalStaked: totalStaked,
              }
            })
            ->SortArray.stableSortBy((a, b) =>
              switch Js.String.localeCompare(a.symbol, b.symbol) {
              | greater if greater > 0.0 => -1
              | lesser if lesser < 0.0 => 1
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
      alternateComponent={<h1 onClick={_ => router->Next.Router.push("/login?nextPath=/stake")}>
        <Login />
      </h1>}>
      <ViewBox>
        {switch tokenId {
        | Some(tokenId) => <div> <StakeForm tokenId={tokenId} /> </div>
        | _ => <>
            // center me
            <div className="font-bold">
              <h1> {"Stake to earn Float tokens"->React.string} </h1>
            </div>
            {synthenticTokens
            ->Array.map(token => {
              <Card key={token.symbol ++ token.tokenType}>
                <div className="flex justify-between items-center w-full">
                  <div className="flex flex-col">
                    <div className="flex">
                      <h3 className="font-bold"> {"Synth"->React.string} </h3>
                      // <AddToMetamask
                      //   tokenAddress={token.id}
                      //   tokenSymbol={(token.tokenType->isShort ? `↘️` : `↗️`) ++
                      //   token.symbol->Js.String2.replaceByRe(%re("/[aeiou]/ig"), "")}
                      // />
                    </div>
                    <p>
                      {token.symbol->React.string}
                      {
                        // {(token.tokenType->isShort ? " (short) " : " (long) ")->React.string}
                        (token.tokenType->isShort ? `↘️` : `↗️`)->React.string
                      }
                    </p>
                  </div>
                  <div className="flex flex-col">
                    <h3 className="font-bold"> {"Total staked"->React.string} </h3>
                    <p> {token.totalStaked->FormatMoney.formatEther->React.string} </p>
                  </div>
                  // <div className="flex flex-col">
                  //   <h3 className="font-bold"> {"Your current stake"->React.string} </h3>
                  //   <TokenBalance erc20Address={token.id->Ethers.Utils.getAddressUnsafe} />
                  // </div>
                  <div className="flex flex-col">
                    <h3 className="font-bold">
                      {`APY `->React.string}
                      <span className="text-xs"> {`ℹ️`->React.string} </span>
                    </h3>
                    <p>
                      {basicApyCalc(
                        0.12,
                        token.totalLockedLong->Ethers.Utils.formatEther->Js.Float.fromString,
                        token.totalLockedShort->Ethers.Utils.formatEther->Js.Float.fromString,
                        token.tokenType,
                      )->mapVal}
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
