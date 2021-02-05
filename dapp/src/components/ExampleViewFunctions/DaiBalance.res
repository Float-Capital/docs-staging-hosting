let useDaiBalance = () => {
  let optChainId = RootProvider.useNetworkId()
  let optUserId = RootProvider.useCurrentUser()
  let optProviderOrSigner = ContractActions.useProviderOrSigner()

  let (daiBalance, setDaiBalance) = React.useState(_ => None)

  React.useEffect2(() => {
    switch (optChainId, optProviderOrSigner, optUserId) {
    | (Some(chainId), Some(providerOrSigner), Some(userId)) =>
      let _ =
        Contracts.Erc20.balanceOf(
          ~contract=Contracts.Erc20.make(
            ~address=Config.daiContractAddress(~netIdStr=chainId->Int.toString),
            ~providerOrSigner,
          ),
          ~owner=userId,
        )->JsPromise.map(balance => setDaiBalance(_ => Some(balance)))
    | _ => ()
    }
    None
  }, (optChainId, optUserId))

  daiBalance
}

@react.component
let make = () => {
  let optBalance = useDaiBalance()
  <>
    {switch optBalance {
    | Some(balance) =>
      <h1> {`dai balance: ${balance->Ethers.Utils.formatEther} DAI`->React.string} </h1>
    | None => <h1> {"Loading dai balance"->React.string} </h1>
    }}
  </>
}
