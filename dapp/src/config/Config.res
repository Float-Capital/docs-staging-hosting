type contractDetails = {
  @as("LongShort") longShort: Ethers.ethAddress,
  @as("Staker") staker: Ethers.ethAddress,
  @as("Dai") dai: Ethers.ethAddress,
  @as("FloatToken") floatToken: Ethers.ethAddress,
}
type configShape = {
  graphEndpoint: string,
  priceHistoryGraphEndpoint: string,
  aaveGraphEndpoint: string,
  networkId: int,
  networkName: string,
  networkCurrencyName: string,
  networkCurrencySymbol: string,
  rpcEndopint: string,
  paymentTokenName: string,
  blockExplorer: string,
  blockExplorerName: string,
  discordInviteLink: string,
  web3PollingInterval: int,
  apolloConnectToDevTools: bool,
  contracts: contractDetails,
}
let config: configShape = %raw(`require('config_file')`)

// NOTE: no validation happens on the config. IT IS NOT TYPE SAFE.

let {
  graphEndpoint,
  priceHistoryGraphEndpoint,
  aaveGraphEndpoint,
  networkId,
  networkName,
  networkCurrencyName,
  networkCurrencySymbol,
  rpcEndopint,
  paymentTokenName,
  blockExplorer,
  blockExplorerName,
  discordInviteLink,
  web3PollingInterval,
  apolloConnectToDevTools,
  contracts: {longShort, staker, dai, floatToken},
} = config
