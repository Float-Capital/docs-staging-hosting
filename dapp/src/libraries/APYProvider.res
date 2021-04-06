type t = Loading | Loaded(float) | Error(string)

type providerT = {
  apy: t,
  shouldFetchData: bool,
  setShouldFetchData: (bool => bool) => unit,
}

module APYProviderContext = {
  let context = React.createContext({
    apy: Loading,
    shouldFetchData: false,
    setShouldFetchData: _ => (),
  })

  module Provider = {
    let provider = React.Context.provider(context)

    @react.component
    let make = (~value, ~children) => {
      React.createElement(provider, {"value": value, "children": children})
    }
  }
}

module GenericAPYProvider = {
  @react.component
  let make = (~apyDeterminer, ~children) => {
    let (apy, setApy) = React.useState(_ => Loading)
    let (shouldFetchData, setShouldFetchData) = React.useState(_ => false)
    React.useEffect3(_ => {
      if apy == Loading && shouldFetchData {
        apyDeterminer(setApy)
      }
      None
    }, (shouldFetchData, apy, apyDeterminer))

    <APYProviderContext.Provider
      value={{setShouldFetchData: setShouldFetchData, shouldFetchData: false, apy: apy}}>
      {children}
    </APYProviderContext.Provider>
  }
}

module AaveAPYResponse = {
  @decco.decode type i_list = {liquidityRate: string}

  @decco.decode type inner = {reserves: array<i_list>}

  @decco.decode type t = {data: inner}
}

let determineAaveApy = setApy => {
  let logError = (~reason=None, ()) => {
    switch reason {
    | Some(r) => {
        Js.log(`Couldn't fetch AAVE Dai APY. Reason:`)
        Js.log(r)
      }
    | None => Js.log(`Couldn't fetch AAVE Dai APY for unknown reason.`)
    }
  }

  let _ = Request.make(
    ~url="https://api.thegraph.com/subgraphs/name/aave/aave-v2-matic",
    ~responseType=Json,
    ~headers=Js.Dict.fromArray([("Content-type", "application/json")]),
    ~body="{\"query\":\"{\\n  reserves(where:{symbol: \\\"DAI\\\"}){\\n    liquidityRate\\n  }\\n}\\n\",\"variables\":null}",
    ~method=#POST,
    (),
  )->Future.get(response =>
    switch response {
    | Ok({response: Some(response)}) =>
      let decoded = response->AaveAPYResponse.t_decode

      switch decoded {
      | Ok(result) => {
          let inner = result.data.reserves[0]
          switch inner {
          | Some(inner) =>
            let apy =
              Ethers.BigNumber.fromUnsafe(inner.liquidityRate)
              ->Ethers.BigNumber.div(CONSTANTS.tenToThe9) // input is 1e27
              ->Ethers.Utils.formatEther
              ->Float.fromString
              ->Option.getUnsafe
            setApy(_ => Loaded(apy))

          | _ => logError()
          }
        }
      | Error(e) => logError(~reason=Some(e), ())
      }

    | Error(e) => logError(~reason=Some(e), ())
    | _ => logError()
    }
  )
}

@react.component
let make = (~children) =>
  <GenericAPYProvider apyDeterminer={determineAaveApy}> {children} </GenericAPYProvider>

let useAPY = () => {
  let {shouldFetchData, setShouldFetchData, apy} = React.useContext(APYProviderContext.context)
  React.useEffect2(_ => {
    if !shouldFetchData {
      setShouldFetchData(_ => true)
    }
    None
  }, (shouldFetchData, setShouldFetchData))
  apy
}
