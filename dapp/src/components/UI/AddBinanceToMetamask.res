type ethereum
@val @scope("window") external ethObj: option<ethereum> = "ethereum"

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

@send external request: (ethereum, requestObj) => unit = "request"

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
              chainId: "0x61",
              chainName: "BSC testnet",
              nativeCurrency: {
                name: "Test BNB",
                symbol: "BNB",
                decimals: 18,
              },
              rpcUrls: [
                "https://data-seed-prebsc-1-s2.binance.org:8545/",
                "https://data-seed-prebsc-2-s2.binance.org:8545/",
                "https://data-seed-prebsc-1-s3.binance.org:8545/",
                "https://data-seed-prebsc-2-s3.binance.org:8545/",
              ],
              blockExplorerUrls: ["https://testnet.bscscan.com/"],
            },
          ],
        },
      )
    })

  switch ethObj {
  | Some(ethObj) =>
    <Button.Element onClick={_event => addToMetamask(ethObj)}>
    <div className="mx-auto">
    <div className="flex flex-row items-center">
      <div className="text-sm"> {"Add BSC Testnet to metamask "->React.string} </div>
      <img src="/icons/metamask.svg" className="h-6 ml-1" />
    </div>
    </div>
    </Button.Element>    
  | None => React.null
  }
}
