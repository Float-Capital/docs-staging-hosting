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

let secrets: s = %raw(`
  function() {
    let providerUrls = !process.env.PROVIDER_URL ? [] : [process.env.PROVIDER_URL];
    let mnemonic = process.env.MNEMONIC;
    
    try {
      const secrets = require("../../../secretsManager.js");
      providerUrls = [...providerUrls, secrets.providerUrls];
      mnemonic = secrets.mnemonic;
    } catch (_e) {
      console.warning("No secretsManager.js found, using environment variables");
    }
    return {
      providerUrls,
      mnemonic
    }
  }`)()

let config: c = %raw(`require("../config.json")`)
