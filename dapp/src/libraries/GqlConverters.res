open Globals

module BigInt = {
  type t = Ethers.BigNumber.t
  let parse = json =>
    switch json->Js.Json.decodeString {
    | Some(str) => Ethers.BigNumber.fromUnsafe(str)
    | None =>
      // In theory graphql should never allow this to not be a correct string
      Js.log("CRITICAL - should never happen!")
      Ethers.BigNumber.fromUnsafe("0")
    }
  let serialize = bn => bn->Ethers.BigNumber.toString->Js.Json.string
}

module Bytes = {
  type t = string
  let parse = json =>
    switch json->Js.Json.decodeString {
    | Some(str) => str
    | None =>
      // In theory graphql should never allow this to not be a correct string
      Js.log("CRITICAL - should never happen!")
      "couldn't decode bytes"
    }
  let serialize = bytesString => bytesString->Js.Json.string
}

module Address = {
  type t = Ethers.ethAddress
  let parse = json =>
    switch json->Js.Json.decodeString->Option.flatMap(Ethers.Utils.getAddress) {
    | Some(address) => address
    | None =>
      // In theory graphql should never allow this to not be a correct string
      Js.log("CRITICAL - couldn't decode eth address from graph, should never happen!")
      CONSTANTS.zeroAddress
    }
  let serialize = bytesString => bytesString->ethAdrToStr->Js.Json.string
}
