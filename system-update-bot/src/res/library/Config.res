type s = {
  providerUrls: array<string>,
  mnemonic: string,
}

type c = {
  longShortContractAddress: Ethers.ethAddress,
  chainlinkOracleAddresses: array<Ethers.ethAddress>,
}

let secrets: s = %raw(`require("../../../secretsManager.js")`)

let config: c = %raw(`require("../config.json")`)
