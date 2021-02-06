SwrPersist.syncWithSessionStorage->Misc.onlyExecuteClientSide

let useDaiBalance = () => {
  let optChainId = RootProvider.useNetworkId()
  let optUserId = RootProvider.useCurrentUser()
  let optProviderOrSigner = ContractActions.useProviderOrSigner()

  let fetchBalanceFunction = (_, chainId, userId) => {
    let providerOrSigner = optProviderOrSigner->Option.getExn // Can safely get the value, since this function can ONLY be called when the signerOrProvider is defined.

    Contracts.Erc20.balanceOf(
      ~contract=Contracts.Erc20.make(
        ~address=Config.daiContractAddress(~netIdStr=chainId->Int.toString),
        ~providerOrSigner,
      ),
      ~owner=userId,
    )
  }

  Swr.useSwrConditonal3(() =>
    switch (optChainId, optProviderOrSigner, optUserId) {
    | (Some(chainId), Some(_), Some(userId)) => Some(("chainBalance", chainId, userId))
    | _ => None
    }
  , fetchBalanceFunction, ~config=None)
}

@react.component
let make = () => {
  let {
    data: optBalance,
    isValidating: _isValidating,
    error: _errorLoadingBalance,
    mutate: _mutate,
  } = useDaiBalance()

  <>
    {switch optBalance {
    | Some(balance) =>
      <h1> {`dai balance: ${balance->Ethers.Utils.formatEther} DAI`->React.string} </h1>
    | None => <h1> {"Loading dai balance"->React.string} </h1>
    }}
  </>
}
