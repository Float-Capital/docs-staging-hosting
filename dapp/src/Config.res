type contractDetails = {
  @as("LongShort") longShort: Ethers.ethAddress,
  @as("Staker") staker: Ethers.ethAddress,
  @as("Dai") dai: Ethers.ethAddress,
  @as("FloatToken") floatToken: Ethers.ethAddress,
}
type configShape = {
  graphEndpoint: string,
  priceHistoryGraphEndpoint: string,
  networkId: int,
  networkName: string,
  paymentTokenName: string,
  blockExplorer: string,
  blockExplorerName: string,
  discordInviteLink: string,
  contracts: contractDetails,
}
let config: configShape = %raw(`require('config_file')`)

// NOTE: no validation happens on the config. IT IS NOT TYPE SAFE.

let {
  graphEndpoint,
  priceHistoryGraphEndpoint,
  networkId,
  networkName,
  paymentTokenName,
  blockExplorer,
  blockExplorerName,
  discordInviteLink,
  contracts: {longShort, staker, dai, floatToken},
} = config
