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
    <div onClick={_event => addToMetamask(ethObj)} className="flex justify-start align-center">
      <div className="text-sm"> {"Go to the BSC network "->React.string} </div>
      <img src="/icons/metamask.svg" className="h-5 ml-1" />
    </div>
  | None => React.null
  }
}
