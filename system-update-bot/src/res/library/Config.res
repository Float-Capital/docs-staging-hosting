type s = {
  providerUrls: array<string>,
  mnemonic: string,
}

type oraclesToWatch = {linkedMarketIds: array<int>}

type c = {
  longShortContractAddress: Ethers.ethAddress,
  chainId: option<int>,
  chainlinkOracleAddresses: Js.Dict.t<oraclesToWatch>,
  defaultMarkets: array<int>,
}

let secrets: s = %raw(`require("../../../secretsManager.js")`)

let config: c = %raw(`require("../config.json")`)
