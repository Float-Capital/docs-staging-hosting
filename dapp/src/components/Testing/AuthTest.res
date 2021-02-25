open Globals

@react.component
let make = () => {
  let signer = ContractActions.useSignerExn()
  let userAddress = RootProvider.useCurrentUserExn()

  let (mutate, _mutationResult) = DbQueries.CreateUser.use()

  <>
    {"Auth Test"->React.string}
    <button
      onClick={_ => {
        let _ = Ethers.Wallet.signMessage(
          signer,
          `float.capital-signin-string:${userAddress->ethAdrToStr}`,
        )->JsPromise.map(result => {
          Js.log(result)
          mutate(
            ~context=App.createContext(App.DB),
            {userAddress: "0x738edd7F6a625C02030DbFca84885b4De5252903", userName: None})
        })
      }}>
      {"Sign something"->React.string}
    </button>
  </>
}

