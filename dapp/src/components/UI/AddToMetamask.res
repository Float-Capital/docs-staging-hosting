type paramOptions = {
  address: string,
  symbol: string,
  decimals: string,
  image: option<string>,
}

type reqParams = {
  @as("type") type_: string,
  options: paramOptions,
}

type requestObj = {
  method: string,
  params: reqParams,
}

@send external request: (InjectedEthereum.t, requestObj) => unit = "request"

let requestStructure = (~tokenAddress, ~tokenSymbol) => {
  method: "wallet_watchAsset",
  params: {
    type_: "ERC20",
    options: {
      address: tokenAddress,
      symbol: tokenSymbol->Js.String.slice(~from=0, ~to_=5), // A ticker symbol, up to 5 chars.
      decimals: "18",
      image: None, // TODO: Add token image url symbol here
    },
  },
}

@react.component
let make = (
  ~tokenAddress,
  ~tokenSymbol,
  ~callback=_ => (),
  ~children=<img src="/icons/metamask.svg" className="h-5 ml-1" />,
) => {
  let addToMetamask = ethObj =>
    Misc.onlyExecuteClientSide(() => {
      request(ethObj, requestStructure(~tokenAddress, ~tokenSymbol))
      callback()
    })

  switch InjectedEthereum.ethObj {
  | Some(ethObj) =>
    <div onClick={_event => addToMetamask(ethObj)} className="flex justify-start align-center">
      {
        //   <div className="text-sm"> {"Add token to "->React.string} </div>
        children
      }
    </div>
  | None => React.null
  }
}
