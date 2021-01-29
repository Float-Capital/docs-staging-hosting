@val
external longshortContractGoerli: option<string> = "process.env.REACT_APP_LONGSHORT_CONTRACT_GOERLI"
@val
external longshortContractBinanceTest: option<string> =
  "process.env.REACT_APP_LONGSHORT_CONTRACT_GOERLI"

let longshortContractAbi = [""]->Web3.makeAbi
