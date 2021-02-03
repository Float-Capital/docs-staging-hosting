open Ethers

let getProviderOrSigner = (library: Ethers.Providers.t, account: option<Ethers.ethAddress>) =>
  switch account {
  | Some(account) =>
    library
    ->Ethers.Providers.getSigner(account)
    ->Option.mapWithDefault(Provider(library), signer => Signer(signer))
  | None => Provider(library)
  }

let getLongShortContractAddress = chainId =>
  switch chainId {
  | 137 => "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"
  | 80001 => "0xeb37A6dF956F1997085498aDd98b25a2f633d83F"
  | 5
  | _ => "0xba97BeC8d359D73c81D094421803D968A9FBf676"
  }->Ethers.Utils.getAddressUnsafe

let useProviderOrSigner = () => {
  let context = RootProvider.useWeb3React()

  React.useMemo2(() =>
    switch context.library {
    | Some(library) => Some(getProviderOrSigner(library, context.account))
    | _ => None
    }
  , (context.library, context.account))
}

type transactionState =
  // | SignerUnavailable
  | UnInitialised
  // | DaiPermit(BN.t)
  // | SignMetaTx
  | Created
  // | SubmittedMetaTx
  | SignedAndSubmitted(txHash)
  // TODO: get the error message when it is declined.
  //      4001 - means the transaction was declined by the signer
  //      -32000 - means the transaction is always failing (exceeds gas allowance)
  | Declined(string)
  // | DaiPermitDclined(string)
  // | SignMetaTxDclined(string)
  // | ServerError(string)
  | Complete(txResult)
  | Failed

let useContractFunction = () => {
  let (txState, setTxState) = React.useState(() => UnInitialised)

  let optProviderOrSigner = useProviderOrSigner()
  (
    (~contractAddress, ~contractFunction) => {
      setTxState(_ => Created)
      switch optProviderOrSigner {
      | Some(providerOrSigner) =>
        let erc20Instance = Contracts.TestErc20.make(~address=contractAddress, ~providerOrSigner)
        let mintPromise = contractFunction(~contract=erc20Instance)
        let _ = mintPromise->JsPromise.catch(error => {
          setTxState(_ => Declined(
            switch Js.Exn.message(error->Obj.magic) {
            | Some(msg) => ": " ++ msg
            | None => "unknown error"
            },
          ))->Obj.magic
        })

        let _ = mintPromise
        ->JsPromise.then(tx => {
          setTxState(_ => SignedAndSubmitted(tx.hash))
          tx.wait(.)
        })
        ->JsPromise.map(txOutcome => {
          Js.log(txOutcome)
          setTxState(_ => Complete(txOutcome))
        })
        ->JsPromise.catch(error => {
          setTxState(_ => Failed)
          Js.log(error)
        })

      | None => Js.log("NOooo :( :( !!!")
      }
      ()
    },
    txState,
    setTxState,
  )
}
