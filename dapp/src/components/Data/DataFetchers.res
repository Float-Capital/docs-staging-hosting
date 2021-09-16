open Globals

let useUsersStakes = (~address) => {
  let userId = address->ethAdrToStr->Js.String.toLowerCase
  let (executeQuery, _) = Queries.UsersStakes.useLazy()

  React.useEffect1(() => {
    executeQuery({userId: userId})
    None
  }, [StateChangeMonitor.useDataFreshnessString()])

  Queries.UsersStakes.use({userId: userId})
}

let oneGweiInWei = Ethers.BigNumber.fromInt(1000000000)
let defaultGasPriceInGwei = oneGweiInWei->Ethers.BigNumber.mul(Ethers.BigNumber.fromInt(95)) // 95 gwei should be fast enough in most cases

let getGasPrice = () => {
  Fetch.fetch("https://gasstation-mainnet.matic.network")
  ->JsPromise.then(Fetch.Response.json)
  ->JsPromise.map(response =>
    Obj.magic(response)["fast"]->Option.map(Ethers.BigNumber.mul(oneGweiInWei))
  )
  ->JsPromise.catch(err => {
    Js.log2("Error fetching gas price:", err)
    Some(defaultGasPriceInGwei)->JsPromise.resolve
  })
}

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
