open Contracts
open Ethers
let {mul, fromInt, toString} = module(Ethers.BigNumber)

%raw("require('isomorphic-fetch')")

let {config, secrets} = module(Config)

let oneGweiInWei = fromInt(1000000000)
let defaultGasPriceInGwei: float = 85.0 // 85 gwei should be fast enough in most cases
let maxGasPriceInGwei: int = 250

let getGasPrice = () => {
  Fetch.fetch("https://gasstation-mainnet.matic.network")
  ->JsPromise.then(Fetch.Response.json)
    ->JsPromise.map(response => Obj.magic(response)["fast"])
    ->JsPromise.catch(err => {
      Js.log2("Error fetching gas price, falling back to default gas price. Error:", err)
      Some(defaultGasPriceInGwei)->JsPromise.resolve
    })
    ->JsPromise.map(optGasPriceInGwei =>
                    optGasPriceInGwei
                    ->Option.getWithDefault(defaultGasPriceInGwei)
                    ->Js.Math.ceil_int
                    ->Js.Math.min_int(_, maxGasPriceInGwei)
                    ->fromInt
                    ->mul(oneGweiInWei)
  )
}

let getAggregatorAddresses = (chainlinkOracleAddresses, wallet: Wallet.t) => {
  let signer = wallet->getSigner
  JsPromise.all(
    chainlinkOracleAddresses
    ->Js.Dict.keys
    ->Array.map(addressString => {
      let address = Ethers.Utils.getAddressUnsafe(addressString)
      let oracle = Oracle.make(~address, ~providerOrSigner=signer)

      open Oracle
      oracle->phaseId->JsPromise.then(id => oracle->phaseAggregators(~phase=id))
    }),
  )
}

let mapWalletBalance = (wallet, fn) =>
  wallet->Wallet.getBalance->JsPromise.map(balance => fn(balance))

let getJsonProviders = providerUrls =>
  JsPromise.all(
    providerUrls->Array.map(url =>
      url->Providers.JsonRpcProvider.make(~chainId=config.chainId->Option.getWithDefault(80001))
    ),
  )

let getProvider = urls =>
  urls
  ->getJsonProviders
  ->JsPromise.then(providers => {
    providers->Providers.FallbackProvider.make(~quorum=1)
  })

let wallet: ref<Ethers.Wallet.t> = ref(None->Obj.magic)
let provider: ref<Ethers.Providers.t> = ref(None->Obj.magic)
let updateCounter: ref<int> = ref(0)

let runUpdateSystemStateMulti = (~marketsToUpdate) => {
  updateCounter := updateCounter.contents + 1
  Js.log2("running update", updateCounter.contents)

  let balanceBefore: ref<BigNumber.t> = ref(None->Obj.magic)
  wallet.contents
  ->mapWalletBalance(balance => {
    balanceBefore := balance
    Js.log2("Matic balance pre contract call: ", balance->Utils.formatEther)
  })
  ->JsPromise.then(_ => {
    let contract = LongShort.make(
      ~address=config.longShortContractAddress,
      ~providerOrSigner=wallet.contents->getSigner,
    )

    getGasPrice()->JsPromise.map(gasPrice => {
      let transactionOptions = {gasPrice: gasPrice}

      Js.log2(marketsToUpdate, transactionOptions)

      contract
      ->LongShort.updateSystemStateMulti(
        ~marketIndexes=marketsToUpdate,
        ~gasOptions=transactionOptions,
      )
      ->JsPromise.then(update => {
        Js.log2("submitted transaction", update.hash)
        update.wait(.)
      })
      ->JsPromise.map(_ => {
        Js.log2("Transaction processes")
      })
      ->JsPromise.mapCatch(e => {
        Js.log("ERROR")
        Js.log("-------------------")
        Js.log(e)
      })
    })
  })
  ->JsPromise.then(_ =>
    wallet.contents->mapWalletBalance(balance =>
      Js.log4(
        "Matic balance post contract call:",
        balance->Utils.formatEther,
        "gas used",
        balanceBefore.contents->BigNumber.sub(balance)->Utils.formatEther,
      )
    )
  )
}

let setup = () => {
  JsPromise.all2((secrets.providerUrls->getProvider, secrets.mnemonic->Wallet.fromMnemonic))
  ->JsPromise.then(((_provider, unconnectedWallet)) => {
    Js.log("Got network.")
    provider := _provider
    wallet := unconnectedWallet->Wallet.connect(_provider)

    Js.log("Initial update system state")
    // TODO: only update markets that aren't up-to-date already
    runUpdateSystemStateMulti(~marketsToUpdate=config.defaultMarkets)
  })
  ->JsPromise.then(_ => {
    Js.log("-------------------------")
    Js.log("Getting aggregator addresses")

    config.chainlinkOracleAddresses->getAggregatorAddresses(wallet.contents)
  })
  ->JsPromise.map(aggregatorAddresses => {
    aggregatorAddresses->Array.forEachWithIndex((index, address) => {
      let filter: Providers.filter = {
        address: address,
        topics: [Ethers.Utils.id("AnswerUpdated(int256,uint256,uint256)")],
      }

      provider.contents->Providers.on(filter, _ => {
        let updatedOracleAddress =
          config.chainlinkOracleAddresses->Js.Dict.keys->Array.getUnsafe(index)
        let linkedMarketIds = (
          config.chainlinkOracleAddresses->Js.Dict.unsafeGet(updatedOracleAddress)
        ).linkedMarketIds

        Js.log(`Price updated for oracle ${updatedOracleAddress}`)

        let _ = runUpdateSystemStateMulti(~marketsToUpdate=linkedMarketIds)
      })
    })
    Js.log("Listening for new answers.")
  })
}

let _ = setup()
