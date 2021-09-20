type contractDetails = {
  @as("LongShort") longShort: Ethers.ethAddress,
  @as("Staker") staker: Ethers.ethAddress,
  @as("Dai") dai: Ethers.ethAddress,
  @as("FloatToken") floatToken: Ethers.ethAddress,
}
type floatTokenDetails = {
  floatTokenName: string,
  floatTokenImageUrl: string
}
type configShape = {
  graphEndpoint: string,
  priceHistoryGraphEndpoint: string,
  aaveGraphEndpoint: string,
  networkId: int,
  networkName: string,
  torusName: string,
  networkCurrencyName: string,
  networkCurrencySymbol: string,
  rpcEndopint: string,
  paymentTokenName: string,
  blockExplorer: string,
  blockExplorerName: string,
  discordInviteLink: string,
  polygonBridgeLink: string,
  web3PollingInterval: int,
  apolloConnectToDevTools: bool,
  floatToken: floatTokenDetails,
  contracts: contractDetails,
}
let config: configShape = %raw(`require('config_file')`)

// NOTE: no validation happens on the config. IT IS NOT TYPE SAFE.

let isPolygon = config.networkId == CONSTANTS.polygon.chainId

let {
  graphEndpoint,
  priceHistoryGraphEndpoint,
  aaveGraphEndpoint,
  networkId,
  networkName,
  torusName,
  networkCurrencyName,
  networkCurrencySymbol,
  rpcEndopint,
  paymentTokenName,
  blockExplorer,
  blockExplorerName,
  discordInviteLink,
  polygonBridgeLink,
  web3PollingInterval,
  apolloConnectToDevTools,
  floatToken: {
    floatTokenName,
    floatTokenImageUrl
  },
  contracts: {longShort, staker, dai, floatToken},
} = config
