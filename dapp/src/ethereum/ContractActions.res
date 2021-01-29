open Ethers

let getProviderOrSigner = (library: Ethers.Providers.t, account: option<Ethers.ethAddress>) =>
  switch account {
  | Some(account) => library->Ethers.Providers.getSigner(account)->Option.mapWithDefault(Provider(library), signer=> Signer(signer))
  | None => Provider(library)
  }

type txHash = string
type tx = {
  hash: txHash,
  wait: (. unit) => JsPromise.t<txResult>,
}
type parsedUnits
type txOptions = {
  @live gasLimit: option<string>,
  @live value: parsedUnits,
}
type tokenIdString = string
type estimateBuy = {
  @live
  buy: // (. string, parsedUnits, txOptions) =>
  (. string, parsedUnits, parsedUnits, txOptions) => JsPromise.t<string>,
}
type stewardContract = {
  @dead("stewardContract.estimate") estimate: estimateBuy,
  buy: (. tokenIdString, parsedUnits, parsedUnits, string, txOptions) => JsPromise.t<tx>,
}

type ethersBnFormat
@send external ethersBnToString: ethersBnFormat => string = "toString"

@module("./abi/loyaltyToken.json")
external loyaltyTokenAbi: Ethers.abi = "loyaltyToken"

@module("ethers") @scope("utils")
external parseUnits: (. string, int) => parsedUnits = "parseUnits"

let getExchangeContract = (stewardAddress, stewardAbi, library, account) =>
  Ethers.Contract.make(stewardAddress, stewardAbi, getProviderOrSigner(library, account))

@dead("+stewardAddressMaticMain")
let stewardAddressMaticMain = "0x6D47CF86F6A490c6410fC082Fd1Ad29CF61492d0"
@dead("+stewardAddressMumbai")
let stewardAddressMumbai = "0x0C00CFE8EbB34fE7C31d4915a43Cde211e9F0F3B"

let getLongShortContractAddress = chainId =>
  switch chainId {
  | 137 => "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063"
  | 80001 => "0xeb37A6dF956F1997085498aDd98b25a2f633d83F"
  | 5
  | _ => "0xba97BeC8d359D73c81D094421803D968A9FBf676"
  }

let useLongShortContract = () => {
  let context = RootProvider.useWeb3React()

  React.useMemo3(() =>
    switch (context.library, context.chainId) {
    | (Some(library), Some(chainId)) =>
      Some(
        getLongShortContractAddress(chainId)->getExchangeContract(
          Config.longshortContractAbi,
          library,
          context.account,
        ),
      )

    | _ => None
    }
  , (context.library, context.account, context.chainId))
}

type transactionState =
  | UnInitialised
  | DaiPermit(BN.t)
  | SignMetaTx
  | Created
  | SubmittedMetaTx
  | SignedAndSubmitted(txHash)
  // TODO: get the error message when it is declined.
  //      4001 - means the transaction was declined by the signer
  //      -32000 - means the transaction is always failing (exceeds gas allowance)
  | Declined(string)
  // | DaiPermitDclined(string)
  // | SignMetaTxDclined(string)
  | ServerError(string)
  | Complete(txResult)
  | Failed

let useChangePrice = animal => {
  let (txState, setTxState) = React.useState(() => UnInitialised)

  let optLongShortContract = useLongShortContract()

  (
    newPrice => {
      let value = parseUnits(. "0", 0)
      let newPriceEncoded = parseUnits(. newPrice, 0)

      setTxState(_ => Created)
      switch optLongShortContract {
      | Some(longShort) => // let updatePricePromise = steward.changePrice(.
        //   animal,
        //   newPriceEncoded,
        //   {
        //     gasLimit: None, //calculateGasMargin(estimatedGasLimit, GAS_MARGIN),
        //     value: value,
        //   },
        // )->Promise.Js.toResult
        // updatePricePromise->Promise.getOk(tx => {
        //   setTxState(_ => SignedAndSubmitted(tx.hash))
        //   let txMinedPromise = tx.wait(.)->Promise.Js.toResult
        //   txMinedPromise->Promise.getOk(txOutcome => {
        //     Js.log(txOutcome)
        //     setTxState(_ => Complete(txOutcome))
        //   })
        //   txMinedPromise->Promise.getError(error => {
        //     setTxState(_ => Failed)
        //     Js.log(error)
        //   })
        //   ()
        // })
        // updatePricePromise->Promise.getError(error => setTxState(_ => Declined(error.message)))
        ()
      | None => ()
      }
    },
    txState,
  )
}
