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
  ->Option.mapWithDefault(
    Ethers.Utils.getAddressUnsafe("0x0000000000000000000000000000000000000000"),
    closure,
  )
  ->Ethers.Utils.toString
}

// refactor this at some stage to be a single function?
let longShortContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(
    Ethers.Utils.getAddressUnsafe("0x0000000000000000000000000000000000000000"),
    contracts => contracts.longShort,
  )
}

let daiContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(
    Ethers.Utils.getAddressUnsafe("0x0000000000000000000000000000000000000000"),
    contracts => contracts.dai,
  )
}
let longTokenContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(
    Ethers.Utils.getAddressUnsafe("0x0000000000000000000000000000000000000000"),
    contracts => contracts.longCoins,
  )
}
let shortTokenContractAddress = (~netIdStr) => {
  allContracts
  ->Js.Dict.get(netIdStr)
  ->Option.mapWithDefault(
    Ethers.Utils.getAddressUnsafe("0x0000000000000000000000000000000000000000"),
    contracts => contracts.shortCoins,
  )
}
