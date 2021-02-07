@val
external longshortContractGoerli: option<string> = "process.env.REACT_APP_LONGSHORT_CONTRACT_GOERLI"
@val
external longshortContractBinanceTest: option<string> =
  "process.env.REACT_APP_LONGSHORT_CONTRACT_GOERLI"

let longshortContractAbi = [""]->Ethers.makeAbi

type contractDetails = {
  @as("ADai") aDai: Ethers.ethAddress,
  @as("AaveLendingPool") aaveLendingPool: Ethers.ethAddress,
  @as("Dai") dai: Ethers.ethAddress,
  @as("LendingPoolAddressesProvider") lendingPoolAddressesProvider: Ethers.ethAddress,
  @as("LongCoins") longCoins: Ethers.ethAddress,
  @as("LongShort") longShort: Ethers.ethAddress,
  @as("Migrations") migrations: Ethers.ethAddress,
  @as("PriceOracle") priceOracle: Ethers.ethAddress,
  @as("ShortCoins") shortCoins: Ethers.ethAddress,
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
  let netIdStr = RootProvider.useNetworkId()->Option.mapWithDefault("5", Int.toString)
  longShortContractAddress(~netIdStr)
}

let daiContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(Constants.zeroAddress, contracts => contracts.dai)
}
let useDaiAddress = () => {
  let netIdStr = RootProvider.useNetworkId()->Option.mapWithDefault("5", Int.toString)
  daiContractAddress(~netIdStr)
}
let longTokenContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(Constants.zeroAddress, contracts => contracts.longCoins)
}
let useLongContractAddress = () => {
  let netIdStr = RootProvider.useNetworkId()->Option.mapWithDefault("5", Int.toString)
  longShortContractAddress(~netIdStr)
}
let shortTokenContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(Constants.zeroAddress, contracts => contracts.shortCoins)
}
