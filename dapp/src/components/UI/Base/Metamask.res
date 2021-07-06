module AddOrSwitchNetwork = {
  type nativeCurrency = {
    name: string,
    symbol: string,
    decimals: int,
  }

  type reqParams = {
    chainId: string,
    chainName: string,
    nativeCurrency: nativeCurrency,
    rpcUrls: array<string>,
    blockExplorerUrls: array<string>,
  }

  type requestObj = {
    method: string,
    params: array<reqParams>,
  }

  @send external request: (InjectedEthereum.t, requestObj) => JsPromise.t<unit> = "request"

  @react.component
  let make = (~onFailureCallback=_ => ()) => {
    let addToMetamask = ethObj =>
      Misc.onlyExecuteClientSide(() => {
        let _ = request(
          ethObj,
          {
            method: "wallet_addEthereumChain",
            params: [
              {
                chainId: Config.networkId->InjectedEthereum.chainIdIntToHex,
                chainName: Config.networkName,
                nativeCurrency: {
                  name: Config.networkCurrencyName,
                  symbol: Config.networkCurrencySymbol,
                  decimals: 18,
                },
                blockExplorerUrls: [Config.blockExplorer],
                rpcUrls: [Config.rpcEndopint],
              },
            ],
          },
        )->JsPromise.catch(error => {
          let _ = onFailureCallback(error)
          JsPromise.resolve()
        })
      })

    switch InjectedEthereum.ethObj {
    | Some(ethObj) =>
      <Button.Element
        onClick={_event => {
          addToMetamask(ethObj)
        }}>
        <div className="mx-auto">
          <div className="flex flex-row items-center">
            <div className="text-sm">
              {`Switch metamask to ${Config.networkName}`->React.string}
            </div>
            <img src="/icons/metamask.svg" className="h-6 ml-1" />
          </div>
        </div>
      </Button.Element>
    | None => React.null
    }
  }
}

module AddToken = {
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
        image: None,
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
        {children}
      </div>
    | None => React.null
    }
  }
}

module AddTokenButton = {
  @react.component
  let make = (~token, ~tokenSymbol) => {
    if InjectedEthereum.isMetamask() {
      <AddToken tokenAddress={token->Ethers.Utils.ethAdrToStr} tokenSymbol>
        <button
          className="w-44 h-12 text-sm shadow-md rounded-lg border-2 focus:outline-none border-gray-200 hover:bg-gray-200 flex justify-center items-center mx-auto">
          <div className="mx-2 flex flex-row">
            <div> {"Add token to"->React.string} </div>
            <img src="/icons/metamask.svg" className="h-5 ml-1" />
          </div>
        </button>
      </AddToken>
    } else {
      React.null
    }
  }
}
