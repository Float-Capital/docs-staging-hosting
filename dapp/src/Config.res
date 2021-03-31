open Globals

@val
external devMode: option<string> = "process.env.NEXT_PUBLIC_DEVMODE"
let isDevMode = devMode == Some("true")

let longshortContractAbi = [""]->Ethers.makeAbi

let binancTestnetGraphEndpoint = "https://test.graph.float.capital/subgraphs/name/float-capital/float-capital"
let localhostGraphEndpoint = "https://localhost:8000/subgraphs/name/float-capital/float-capital/graphql"
let defaultNetworkId = 97
let defaultNetworkName = "Binance Smart Chain"
let paymentTokenName = "BUSD"
let defaultBlockExplorer = "https://testnet.bscscan.com/"
let getDefaultNetworkId = optNetworkId => optNetworkId->Option.getWithDefault(defaultNetworkId)

let discordInviteLink = "https://discord.gg/dqDwgrVYcU"

type contractDetails = {
  @as("LongShort") longShort: Ethers.ethAddress,
  @as("Staker") staker: Ethers.ethAddress,
  @as("Dai") dai: Ethers.ethAddress,
  @as("FloatToken") floatToken: Ethers.ethAddress,
}

type allChainContractDetails = Js.Dict.t<contractDetails>

let allContracts: allChainContractDetails = %raw(`require('./contractAddresses.json')`)

let getContractAddressString = (~netIdStr, ~closure) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(CONSTANTS.zeroAddress, closure)
  ->ethAdrToStr
}

// refactor this at some stage to be a single function?
let longShortContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(CONSTANTS.zeroAddress, contracts => contracts.longShort)
}
let useLongShortAddress = () => {
  let netIdStr = RootProvider.useChainId()->Option.mapWithDefault("5", Int.toString)
  longShortContractAddress(~netIdStr)
}

let stakerContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(CONSTANTS.zeroAddress, contracts => contracts.staker)
}
let useStakerAddress = () => {
  let netIdStr = RootProvider.useChainId()->Option.mapWithDefault("5", Int.toString)
  stakerContractAddress(~netIdStr)
}

let daiContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(CONSTANTS.zeroAddress, contracts => contracts.dai)
}

let useDaiAddress = () => {
  let netIdStr = RootProvider.useChainId()->Option.mapWithDefault("5", Int.toString)
  daiContractAddress(~netIdStr)
}

let floatContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(CONSTANTS.zeroAddress, contracts => contracts.floatToken)
}

let useFloatAddress = () => {
  let netIdStr = RootProvider.useChainId()->Option.mapWithDefault("5", Int.toString)
  floatContractAddress(~netIdStr)
}
