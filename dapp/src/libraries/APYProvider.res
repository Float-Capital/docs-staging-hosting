type t = Loading | Loaded(float) | Error(string)

let vUnderlyingAssetAddress = "0x95c78222b3d6e262426483d42cfa53685a67ab9d"

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
      // if apy == Loading && shouldFetchData {
      if true {
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


type venusResponse = {
  data: string
}

let determineVenusApy = _ => {
  let _ = Request.make(
    ~url="http://api.venus.io/api/vtoken?addresses=0x2ff3d0f6990a40261c66e1ff2017acbc282eb6d0",
    ~responseType=Json,
    ~headers=Js.Dict.fromArray([("Content-type", "application/json")]),
    (),
  )->Future.get(response =>
    switch response {
    | Ok({response: Some(response)}) => Js.log(response)
    | Error(e) => {
      Js.log(`Couldn't fetch Venus APY. Reason:`)
      Js.log(e)
      }
    |_  => Js.log(`Couldn't fetch Venus APY.`)
    }
  )
}

@react.component
let make = (~children) =>
  <GenericAPYProvider apyDeterminer={determineVenusApy}> {children} </GenericAPYProvider>

let useAPY = () => {
  let {shouldFetchData, setShouldFetchData, apy} = React.useContext(APYProviderContext.context)
  if !shouldFetchData {
    setShouldFetchData(_ => true)
  }
  apy
}
