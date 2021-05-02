module BigInt = {
  type t = BN.t
  let parse = json =>
    switch json->Js.Json.decodeString {
    | Some(str) => BN.new_(str)
    | None =>
      // In theory graphql should never allow this to not be a correct string
      Js.log("CRITICAL - should never happen!")
      BN.newInt_(0)
    }
  let serialize = bn => bn->BN.toString->Js.Json.string
}

module Address = {
  type t = string
  let parse = json =>
    switch json->Js.Json.decodeString {
    | Some(address) => address
    | None =>
      // In theory graphql should never allow this to not be a correct string
      Js.log("CRITICAL - couldn't decode eth address from graph, should never happen!")
      ""
    }
  let serialize = bytesString => bytesString->Js.Json.string
}
