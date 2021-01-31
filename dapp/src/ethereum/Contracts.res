module TestErc20 = {
  type t

  let abi = [
    "function mint(address,uint256)",
    // "event Transfer(address indexed from, address indexed to, uint amount)",
  ]->Ethers.makeAbi

  let make = (~address, ~providerOrSigner): t =>
    Ethers.Contract.make(address, abi, providerOrSigner)->Obj.magic

  @send
  external mint: (t, Ethers.ethAddress, Ethers.BigNumber.t) => JsPromise.t<Ethers.txSubmitted> =
    "mint"
}
