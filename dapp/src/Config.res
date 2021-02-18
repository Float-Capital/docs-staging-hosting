@val
external devMode: option<string> = "process.env.REACT_APP_DEVMODE"
let isDevMode = devMode == Some("true")

let longshortContractAbi = [""]->Ethers.makeAbi

let goerliGraphEndpoint = "https://api.thegraph.com/subgraphs/name/avolabs-io/float-capital-goerli"
let binancTestnetGraphEndpoint = "https://test.graph.float.capital/subgraphs/name/avolabs-io/float-capital"
let localhostGraphEndpoint = "https://localhost:8000/subgraphs/name/avolabs-io/float-capital/graphql"

type contractDetails = {
  @as("LongShort") longShort: Ethers.ethAddress,
  @as("Dai") dai: Ethers.ethAddress,
}

type allChainContractDetails = Js.Dict.t<contractDetails>

let allContracts: allChainContractDetails = %raw(`require('./contractAddresses.json')`)

let getContractAddressString = (~netIdStr, ~closure) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(Constants.zeroAddress, closure)
  ->Ethers.Utils.toString
}

// refactor this at some stage to be a single function?
let longShortContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(Constants.zeroAddress, contracts => contracts.longShort)
}
let useLongShortAddress = () => {
  let netIdStr = RootProvider.useChainId()->Option.mapWithDefault("5", Int.toString)
  longShortContractAddress(~netIdStr)
}

let daiContractAddress = (~netIdStr) => {
  Js.log(netIdStr)
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(Constants.zeroAddress, contracts => contracts.dai)
}

let useDaiAddress = () => {
  let netIdStr = RootProvider.useChainId()->Option.mapWithDefault("5", Int.toString)
  daiContractAddress(~netIdStr)
}
