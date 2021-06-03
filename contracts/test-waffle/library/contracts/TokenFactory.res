@@ocaml.warning("-32")
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "TokenFactory"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: (~admin: Ethers.ethAddress, ~longShort: Ethers.ethAddress) => JsPromise.t<t> = (
  ~admin,
  ~longShort,
) => deployContract2(contractName, admin, longShort)->Obj.magic

type dEFAULT_ADMIN_ROLEReturn = bytes32
@send
external dEFAULT_ADMIN_ROLE: t => JsPromise.t<dEFAULT_ADMIN_ROLEReturn> = "DEFAULT_ADMIN_ROLE"

type mINTER_ROLEReturn = bytes32
@send
external mINTER_ROLE: t => JsPromise.t<mINTER_ROLEReturn> = "MINTER_ROLE"

type pAUSER_ROLEReturn = bytes32
@send
external pAUSER_ROLE: t => JsPromise.t<pAUSER_ROLEReturn> = "PAUSER_ROLE"

type adminReturn = Ethers.ethAddress
@send
external admin: t => JsPromise.t<adminReturn> = "admin"

@send
external changeAdmin: (t, ~admin: Ethers.ethAddress) => JsPromise.t<transaction> = "changeAdmin"

@send
external changeFloatAddress: (t, ~longShort: Ethers.ethAddress) => JsPromise.t<transaction> =
  "changeFloatAddress"

@send
external createTokenLong: (
  t,
  ~syntheticName: string,
  ~syntheticSymbol: string,
  ~staker: Ethers.ethAddress,
  ~marketIndex: int,
) => JsPromise.t<transaction> = "createTokenLong"

type createTokenLongReturn = Ethers.ethAddress
@send @scope("callStatic")
external createTokenLongCall: (
  t,
  ~syntheticName: string,
  ~syntheticSymbol: string,
  ~staker: Ethers.ethAddress,
  ~marketIndex: int,
) => JsPromise.t<createTokenLongReturn> = "createTokenLong"

@send
external createTokenShort: (
  t,
  ~syntheticName: string,
  ~syntheticSymbol: string,
  ~staker: Ethers.ethAddress,
  ~marketIndex: int,
) => JsPromise.t<transaction> = "createTokenShort"

type createTokenShortReturn = Ethers.ethAddress
@send @scope("callStatic")
external createTokenShortCall: (
  t,
  ~syntheticName: string,
  ~syntheticSymbol: string,
  ~staker: Ethers.ethAddress,
  ~marketIndex: int,
) => JsPromise.t<createTokenShortReturn> = "createTokenShort"

type longShortReturn = Ethers.ethAddress
@send
external longShort: t => JsPromise.t<longShortReturn> = "longShort"
