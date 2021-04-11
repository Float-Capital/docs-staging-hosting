@val
external optConfigOverride: option<string> = "process.env.CONFIG_FILE"
let defaultConfig = "./config.json"

type contractDetails = {
  @as("LongShort") longShort: Ethers.ethAddress,
  @as("Staker") staker: Ethers.ethAddress,
  @as("Dai") dai: Ethers.ethAddress,
  @as("FloatToken") floatToken: Ethers.ethAddress,
}
type configShape = {
  graphEndpoint: string,
  networkId: int,
  networkName: string,
  paymentTokenName: string,
  blockExplorer: string,
  blockExplorerName: string,
  discordInviteLink: string,
  contracts: contractDetails,
}
let getConfig: string => option<configShape> = %raw(`(configLocation) => require(configLocation)`)

let configPath = optConfigOverride->Option.getWithDefault(defaultConfig)
let config =
  getConfig(configPath)->Option.getWithDefault(
    Js.Exn.raiseError(`Could not find config file at ${configPath}`),
  )

// NOTE: no validation happens on the config. IT IS NOT TYPE SAFE.

let {
  graphEndpoint,
  networkId,
  networkName,
  paymentTokenName,
  blockExplorer,
  blockExplorerName,
  discordInviteLink,
  contracts: {longShort, staker, dai, floatToken},
} = config
