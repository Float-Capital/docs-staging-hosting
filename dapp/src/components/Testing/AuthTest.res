open Globals

@react.component
let make = () => {
  let signer = ContractActions.useSignerExn()
  let userAddress = RootProvider.useCurrentUserExn()

  let (mutate, _mutationResult) = DbQueries.CreateUser.use()

  <>
    {"Auth Test"->React.string}
    <br/>
    <button className="bg-green-500 rounded-lg my-2"
      onClick={_ => {
        let uAS = userAddress->ethAdrToStr
        let _ = Ethers.Wallet.signMessage(
          signer,
          `float.capital-signin-string:${uAS}`,
        )->JsPromise.map(result => {
          Client.setSignInData(~ethAddress=userAddress->ethAdrToLowerStr, ~ethSignature=result->Js.String2.make)
        })
      }}>
      {"Sign In"->React.string}
    </button>
    <br/>
    <button className="bg-green-500 rounded-lg my-2"
      onClick={_ => {
        let uAL = userAddress->ethAdrToStr
        let _ = Ethers.Wallet.signMessage(
          signer,
          `float.capital-signin-string:${uAL}`,
        )->JsPromise.map(result => {
          Client.setSignInData(~ethAddress=userAddress->ethAdrToLowerStr, ~ethSignature=result->Js.String2.make)
          mutate(
            ~context=Client.createContext(Client.DB),
            {userName: None})
        })
      }}>
      {"Sign In And Create Profile"->React.string}
    </button>
  </>
}

