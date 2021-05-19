open Ethers

let getProviderOrSigner = (library: Ethers.Providers.t, account: option<Ethers.ethAddress>) =>
  switch account {
  | Some(account) =>
    library
    ->Ethers.Providers.getSigner(account)
    ->Option.mapWithDefault(Provider(library), signer => Signer(signer))
  | None => Provider(library)
  }
let getSigner = (library: Ethers.Providers.t, account: option<Ethers.ethAddress>) =>
  switch account {
  | Some(account) =>
    library
    ->Ethers.Providers.getSigner(account)
    ->Option.mapWithDefault(None, signer => Some(signer))
  | None => None
  }

let useProviderOrSigner = () => {
  let context = RootProvider.useWeb3React()

  React.useMemo2(() =>
    switch context.library {
    | Some(library) => Some(getProviderOrSigner(library, context.account))
    | _ => None
    }
  , (context.library, context.account))
}
let useProviderOrSignerExn = () => useProviderOrSigner()->Option.getExn
@ocaml.doc(`
Get the signer for the current user if they exist
`)
let useSigner: unit => option<Ethers.Wallet.t> = () => {
  switch useProviderOrSigner() {
  | Some(Ethers.Provider(_))
  | None =>
    None
  | Some(Ethers.Signer(signer)) => Some(signer)
  }
}
@ocaml.doc(`
Get the signer for the current user and throw an exception if it doesn't exist
`)
let useSignerExn = () => useSigner()->Option.getExn

type transactionState =
  | UnInitialised
  | Created
  | SignedAndSubmitted(txHash)
  | Declined(string)
  | Complete(txResult)
  | Failed(string)

let useContractFunction = (~signer: Ethers.Wallet.t) => {
  let (txState, setTxState) = React.useState(() => UnInitialised)

  (
    (
      ~makeContractInstance,
      ~contractFunction: (~contract: 'a) => JsPromise.t<Ethers.txSubmitted>,
    ) => {
      setTxState(_ => Created)

      let contractInstance = makeContractInstance(~providerOrSigner=Ethers.Signer(signer))
      let mintPromise = contractFunction(~contract=contractInstance)
      let _ = mintPromise->JsPromise.catch(error => {
        setTxState(_ => Declined(
          switch Js.Exn.message(error->Obj.magic) {
          | Some(msg) => ": " ++ msg
          | None => "unknown error"
          },
        ))->Obj.magic
      })

      let _ =
        mintPromise
        ->JsPromise.then(tx => {
          setTxState(_ => SignedAndSubmitted(tx.hash))
          tx.wait(.)
        })
        ->JsPromise.map(txOutcome => {
          setTxState(_ => Complete(txOutcome))
        })
        ->JsPromise.catch(error => {
          let txHash = switch error->Js.Exn.asJsExn {
          | Some(err) => {
              let exceptionMessage = err->Js.Exn.message->Option.getWithDefault("")

              let txHashRegex = %re(`/transactionHash="(.{66})/`)

              let txHashOpt = txHashRegex->Js.Re.exec_(exceptionMessage)

              let txHashNullable = switch txHashOpt {
              | Some(hash) => Js.Re.captures(hash)[1]->Option.getWithDefault(Js.Nullable.return(""))
              | None => Js.Nullable.return("")
              }

              let txHash: string = switch Js.Nullable.toOption(txHashNullable) {
              | Some(hash) => hash
              | None => ""
              }
              txHash
            }
          | None => ""
          }

          setTxState(_ => Failed(txHash))
          Js.log(error)->JsPromise.resolve
        })
    },
    txState,
    setTxState,
  )
}
