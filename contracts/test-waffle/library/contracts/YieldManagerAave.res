open Contract

type t = {address: Ethers.ethAddress}
let contractName = "YieldManagerAave"

let make: (
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  Ethers.ethAddress,
  int,
) => JsPromise.t<t> = (
  admin,
  longShortAddress,
  treasuryAddress,
  paymentTokenAddress,
  fundTokenAddress,
  lendingPoolAddress,
  aaveReferalCode,
) =>
  deployContract7(
    contractName,
    admin,
    longShortAddress,
    treasuryAddress,
    paymentTokenAddress,
    fundTokenAddress,
    lendingPoolAddress,
    aaveReferalCode,
  )->Obj.magic

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

@send
external withdrawErc20TokenToTreasury: (
  t,
  ~erc20Token: Ethers.ethAddress,
) => JsPromise.t<transaction> = "withdrawErc20TokenToTreasury"
