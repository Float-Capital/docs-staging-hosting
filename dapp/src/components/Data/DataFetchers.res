open Globals
let {mul, fromInt, toString} = module(Ethers.BigNumber)

let useUsersStakes = (~address) => {
  let userId = address->ethAdrToStr->Js.String.toLowerCase
  let (executeQuery, _) = Queries.UsersStakes.useLazy()

  React.useEffect1(() => {
    executeQuery({userId: userId})
    None
  }, [StateChangeMonitor.useDataFreshnessString()])

  Queries.UsersStakes.use({userId: userId})
}

let oneGweiInWei = fromInt(1000000000)
let defaultGasPriceInGwei = oneGweiInWei->mul(fromInt(95)) // 95 gwei should be fast enough in most cases

let getGasPrice = () => {
  Fetch.fetch("https://gasstation-mainnet.matic.network")
  ->JsPromise.then(Fetch.Response.json)
  ->JsPromise.map(response =>
    Obj.magic(response)["fast"]->Option.map(gasInGWeiAsFloat =>
      gasInGWeiAsFloat->Js.Math.ceil_int->fromInt->mul(oneGweiInWei)
    )
  )
  ->JsPromise.catch(err => {
    Js.log2("Error fetching gas price:", err)
    Some(defaultGasPriceInGwei)->JsPromise.resolve
  })
}

// TODO: put this code into the global context rather, on pages that have multiple transactions (eg pages with a payment token approval) the gas prices are fetched twice as often as they need to be
let useRecommendedGasPrice = () => {
  let (gasPrice, setGasPrice) = React.useState(() => defaultGasPriceInGwei)

  let getAndSetGasPrice = () => {
    let _ = getGasPrice()->JsPromise.map(optGasPrice => {
      switch optGasPrice {
      | Some(gasPrice) => setGasPrice(_ => gasPrice)->ignore
      | None => ()
      }
    })
  }

  React.useEffect0(() => {
    getAndSetGasPrice()

    // update the fast gas price recommendation every 3 seconds
    let interval = Js.Global.setInterval(getAndSetGasPrice, 3000)
    Some(() => Js.Global.clearInterval(interval))
  })

  gasPrice
}
