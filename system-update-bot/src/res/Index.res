open Contracts
open Ethers

let {config, secrets} = module(Config)

let getAggregatorAddresses = (chainlinkOracleAddresses: array<ethAddress>, wallet: Wallet.t) => {
  let signer = wallet->getSigner
  JsPromise.all(
    chainlinkOracleAddresses->Array.map(address => {
      let oracle = Oracle.make(~address, ~providerOrSigner=signer)

      open Oracle
      oracle->phaseId->JsPromise.then(id => oracle->phaseAggregators(~phase=id))
    }),
  )
}

let mapWalletBalance = (wallet, fn) =>
  wallet->Wallet.getBalance->JsPromise.map(balance => fn(balance))

let getJsonProviders = providerUrls =>
  JsPromise.all(providerUrls->Array.map(url => url->Providers.JsonRpcProvider.make(~chainId=80001)))

let getProvider = urls =>
  urls
  ->getJsonProviders
  ->JsPromise.then(providers => {
    providers->Providers.FallbackProvider.make(~quorum=1)
  })

let defaultOptions: Contracts.txOptions = {gasPrice: 1000000000}

let wallet: ref<Ethers.Wallet.t> = ref(None->Obj.magic)
let provider: ref<Ethers.Providers.t> = ref(None->Obj.magic)
let updateCounter: ref<int> = ref(0)

let runUpdateSystemStateMulti = () => {
  updateCounter := updateCounter.contents + 1
  Js.log2("running update", updateCounter.contents)

  let balanceBefore: ref<Ethers.BigNumber.t> = ref(None->Obj.magic)
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

    contract
    ->LongShort.updateSystemStateMulti(~marketIndexes=[1, 2, 3], ~gasOptions=defaultOptions)
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
    provider := _provider
    wallet := unconnectedWallet->Wallet.connect(_provider)

    Js.log("Initial update system state")
    runUpdateSystemStateMulti()
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
        Js.log(
          `Price updated for oracle ${config.chainlinkOracleAddresses
            ->Array.getUnsafe(index)
            ->ethAdrToStr}`,
        )
        let _ = runUpdateSystemStateMulti()
      })
    })
    Js.log("Listening for new answers.")
  })
}

let _ = setup()
