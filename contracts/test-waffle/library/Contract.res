open ContractHelpers

module PaymentTokenHelpers = {
  let mintAndApprove = (
    t: ERC20PresetMinterPauser.t,
    ~user: Ethers.Wallet.t,
    ~amount: Ethers.BigNumber.t,
    ~spender: Ethers.ethAddress,
  ) =>
    t
    ->ERC20PresetMinterPauser.mint(~amount, ~_to=user.address)
    ->JsPromise.then(_ => {
      t->connect(~address=user)->ERC20PresetMinterPauser.approve(~amount, ~spender)
    })
}

// module YieldManagerMock = {
//   type t = {address: Ethers.ethAddress}
//   let contractName = "YieldManagerMock"

//   let make: (Ethers.ethAddress, Ethers.ethAddress, Ethers.ethAddress) => JsPromise.t<t> = (
//     admin,
//     longShortAddress,
//     fundTokenAddress,
//   ) => deployContract3(contractName, admin, longShortAddress, fundTokenAddress)->Obj.magic
//   let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
//     attachToContract(contractName, ~contractAddress)->Obj.magic
// }

module DataFetchers = {
  let marketIndexOfSynth = (longShort: LongShort.t, ~syntheticToken: SyntheticToken.t): JsPromise.t<
    int,
  > =>
    longShort
    ->LongShort.staker
    ->JsPromise.then(Staker.at)
    ->JsPromise.then(Staker.marketIndexOfToken(_, syntheticToken.address))
}
