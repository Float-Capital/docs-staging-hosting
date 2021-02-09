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

let useERC20Approved = (~erc20Address, ~spender) => {
  let optChainId = RootProvider.useNetworkId()
  let optUserId = RootProvider.useCurrentUser()
  let optProviderOrSigner = ContractActions.useProviderOrSigner()

  let fetchBalanceFunction = (_, _, _, _, userId) => {
    let providerOrSigner = optProviderOrSigner->Option.getExn // Can safely get the value, since this function can ONLY be called when the signerOrProvider is defined.

    Contracts.Erc20.allowance(
      ~contract=Contracts.Erc20.make(~address=erc20Address, ~providerOrSigner),
      ~owner=userId,
      ~spender,
    )
  }

  Swr.useSwrConditonal5(() =>
    switch (optChainId, optProviderOrSigner, optUserId) {
    | (Some(chainId), Some(_), Some(userId)) =>
      Some(("allowance", erc20Address, spender, chainId, userId))
    | _ => None
    }
  , fetchBalanceFunction, ~config=None)
}
