type t
@val @scope("window") external ethObj: option<t> = "ethereum"

@get external getIsMetamask: t => option<bool> = "isMetaMask"

let isMetamask = () => {
  ethObj->Option.flatMap(e => e->getIsMetamask)->Option.getWithDefault(false)
}

@ocaml.doc(
  "SSR will complain if you use isMetamask() at the top level of a page, use this to get around it"
)
let useIsMetamask = () => {
  let (state, setState) = React.useState(_ => false)
  React.useEffect0(() => {
    setState(_ => isMetamask())
    None
  })
  state
}

let chainIdIntToHex = id => `0x${id->Js.Int.toStringWithRadix(~radix=16)}`

let chainIdHexToInt = id => Ethers.BigNumber.fromUnsafe(id)->Ethers.BigNumber.toNumber

@send external metamaskOn: (t, string, string => unit) => unit = "on"

@ocaml.doc("Reloads the router when Metamask changes pages.")
let useReloadOnMetamaskChainChanged = () => {
  let router = Next.Router.useRouter()
  let routerRef = React.useRef(router)

  React.useEffect1(() => {
    routerRef.current = router
    None
  }, [router])

  React.useEffect0(() => {
    if isMetamask() {
      ethObj
      ->Option.getUnsafe
      ->metamaskOn("chainChanged", _ => {
        routerRef.current->Next.Router.replaceObj({
          pathname: routerRef.current.pathname,
          query: routerRef.current.query,
        })
      })
    }
    None
  })
}

type requestObj = {method: string}
@send external requestNoParams: (t, requestObj) => JsPromise.t<string> = "request"

let requestChainIdPromise = () => {
  let chainIdMatchesConfigPromise = JsPromise.make((resolve, _) =>
    resolve(. Config.networkId->chainIdIntToHex)
  )

  ethObj->Option.mapWithDefault(chainIdMatchesConfigPromise, e => {
    requestNoParams(e, {method: "eth_chainId"})
  })
}

@ocaml.doc(
  "Make sure to only use for children of a component that uses useReloadOnMetamaskChainChanged"
)
let useMetamaskChainId = () => {
  let router = Next.Router.useRouter()
  let (chainId: option<int>, setChainId) = React.useState(_ => None)

  let requeryChainId = () => {
    let _ =
      requestChainIdPromise()
      ->JsPromise.then(chainIdStr => {
        setChainId(_ => Some(chainIdStr->chainIdHexToInt))
        JsPromise.resolve("")
      })
      ->JsPromise.catch(_ => {
        setChainId(_ => Some(Config.networkId))
        JsPromise.resolve("")
      })
  }

  React.useEffect1(() => {
    requeryChainId()
    None
  }, [router])

  chainId
}
