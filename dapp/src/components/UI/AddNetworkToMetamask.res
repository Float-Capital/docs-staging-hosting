type nativeCurrency = {
  name: string,
  symbol: string,
  decimals: int,
}

type reqParams = {
  chainId: string,
  chainName: string,
  nativeCurrency: nativeCurrency,
  // rpcUrls: array<string>,
  blockExplorerUrls: array<string>,
}

type requestObj = {
  method: string,
  params: array<reqParams>,
}

@send external request: (Ethereum.t, requestObj) => unit = "request"

@react.component
let make = () => {
  let addToMetamask = ethObj =>
    Misc.onlyExecuteClientSide(() => {
      request(
        ethObj,
        {
          method: "wallet_addEthereumChain",
          params: [
            {
              chainId: "0x2A",
              chainName: "Kovan",
              nativeCurrency: {
                name: "Test Eth",
                symbol: "ETH",
                decimals: 18,
              },
              blockExplorerUrls: ["https://kovan.etherscan.io/"],
            },
          ],
        },
      )
    })

  switch Ethereum.ethObj {
  | Some(ethObj) =>
    <Button.Element onClick={_event => addToMetamask(ethObj)}>
      <div className="mx-auto">
        <div className="flex flex-row items-center">
          <div className="text-sm"> {`Add ${Config.networkName} to metamask `->React.string} </div>
          <img src="/icons/metamask.svg" className="h-6 ml-1" />
        </div>
      </div>
    </Button.Element>
  | None => React.null
  }
}
