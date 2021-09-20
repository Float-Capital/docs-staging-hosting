module ApolloQueryResult = ApolloClient.Types.ApolloQueryResult

@decco.decode
type discountCodeData = {
  userAddress: string,
  marketIndex: int,
  isWithdrawFromLong: bool,
  withdrawAmount: @decco.codec(Ethers.BigNumber.bnCoder) Ethers.BigNumber.t,
}
@decco.decode
type body_in = {input: discountCodeData}

@decco.encode
type body_out = {
  eligibleForDiscount: bool,
  error: option<string>,
  expiry: string,
  nonce: string,
  discountWithdrawFee: string,
  v: int,
  r: string,
  s: string,
}

Js.log("Jason is here!!")
let checkDiscount = Serbet.endpoint({
  verb: POST,
  path: "/check-discount",
  handler: req =>
    req.requireBody(value => {
      body_in_decode(value)
    })->JsPromise.then(_ => {
      {
        eligibleForDiscount: true,
        error: None,
        expiry: "string",
        nonce: "string",
        discountWithdrawFee: "string",
        v: 213,
        r: "r",
        s: "s",
      }
      ->body_out_encode
      ->Serbet.Endpoint.OkJson
      ->JsPromise.resolve
    }),
})
