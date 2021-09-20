open Web3Connectors

let connectors = [
  {
    name: "MetaMask",
    connector: injected,
    img: "/img/wallet-icons/metamask.svg",
    connectionPhrase: "Connect via MetaMask",
  },
  {
    name: "WalletConnect",
    connector: WalletConnectConnector.make({
      rpc: Js.Dict.fromArray([(Config.networkId->Int.toString, Config.rpcEndopint)]),
      bridge: "https://bridge.walletconnect.org",
      qrcode: true,
      pollingInterval: Config.web3PollingInterval,
    }),
    connectionPhrase: "Connect via WalletConnect",
    img: "/img/wallet-icons/walletConnect.svg",
  },
  {
    name: "Torus",
    connector: TorusConnector.make({
      chainId: Config.networkId,
      initOptions: {
        showTorusButton: true,
        network: {
          host: Config.torusName, // mandatory mumbai | matic
          chainId: Config.networkId,
          networkName: Config.networkName,
        },
      },
    }),
    connectionPhrase: "Connect via Torus",
    img: "/img/wallet-icons/torus.svg",
  },
]

let metamaskDefaultChainIds = Set.Int.fromArray([1, 3, 4, 5, 42, 1337])

let metamaskDefaultChainIdsToMetamaskName = chainId =>
  switch chainId {
  | 3 => "Ropsten Test Network"
  | 4 => "Rinkeby Test Network"
  | 5 => "Goerli Test Network"
  | 42 => "Kovan Test Network"
  | 1337 => "Local Network"
  | _ => "Ethereum Mainnet"
  }

let instructionForDropdown = (~metamaskChainId) => {
  switch metamaskChainId {
  | Some(chainId) if metamaskDefaultChainIds->Set.Int.has(chainId) =>
    `Click on the ${metamaskDefaultChainIdsToMetamaskName(chainId)} dropdown`->React.string
  | _ => `Click on the dropdown for the network you're connected to.`->React.string
  }
}

let addNetworkInstructions = () => {
  <>
    {`Enter the following information:`->React.string}
    <br />
    <div className="pl-8">
      {`Network name - ${Config.networkName}`->React.string}
      <br />
      {`New RPC Url - ${Config.rpcEndopint}`->React.string}
      <br />
      {`Chain Id - ${Config.networkId->Int.toString}`->React.string}
      <br />
      {`Currency Symbol - ${Config.networkCurrencySymbol}`->React.string}
      <br />
      {`Block Explorer URL - ${Config.blockExplorer}`->React.string}
    </div>
  </>
}

@react.component
let make = () => {
  let (_connectionStatus, activateConnector) = RootProvider.useActivateConnector()

  let router = Next.Router.useRouter()
  let nextPath = router.query->Js.Dict.get("nextPath")
  let optCurrentUser = RootProvider.useCurrentUser()

  let isMetamask = InjectedEthereum.useIsMetamask()
  let metamaskChainId = InjectedEthereum.useMetamaskChainId()

  let (
    metamaskDoesntSupportSwitchNetworks,
    setMetamaskDoesntSupportSwitchNetworks,
  ) = React.useState(_ => false)

  let onFailureToSwitchNetworksCallback = error => {
    let errorMessage = switch error->Js.Exn.asJsExn {
    | Some(err) => err->Js.Exn.message->Option.mapWithDefault("", x => x)
    | None => ""
    }
    if errorMessage->Js.String2.includes("The method 'wallet_addEthereumChain' does not exist") {
      setMetamaskDoesntSupportSwitchNetworks(_ => true)
    }
  }

  React.useEffect2(() => {
    switch (nextPath, optCurrentUser) {
    | (Some(nextPath), Some(_currentUser)) => router->Next.Router.push(nextPath)
    | _ => ()
    }
    None
  }, (nextPath, optCurrentUser))

  if !isMetamask || metamaskChainId->Option.getWithDefault(-1) == Config.networkId {
    <div className="max-w-5xl w-full mx-auto">
      <p className="mx-2 md:mx-0"> {"Connect with one of the wallets below. "->React.string} </p>
      {if !isMetamask {
        <p className="text-xs">
          {`Please make sure to connect to ${Config.networkName}.`->React.string}
        </p>
      } else {
        React.null
      }}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 items-center my-5">
        {connectors
        ->Array.mapWithIndex((index, connector) =>
          <div
            key={index->string_of_int}
            onClick={e => {
              ReactEvent.Mouse.stopPropagation(e)
              activateConnector(connector.connector)
            }}
            className="mx-2 md:mx-0 p-5 flex flex-col items-center justify-center bg-white bg-opacity-75 hover:bg-gray-200 active:bg-gray-300 rounded ">
            <div className="w-10 h-10">
              <img src=connector.img alt=connector.name className="w-full h-full" />
            </div>
            <div className="text-xl font-bold my-1"> {connector.name->React.string} </div>
            <div className="text-base my-1 text-gray-400	">
              {connector.connectionPhrase->React.string}
            </div>
          </div>
        )
        ->React.array}
      </div>
    </div>
  } else {
    <div className="mx-auto flex justify-center">
      <div className="flex flex-col max-w-3xl bg-opacity-75 bg-white rounded-lg p-10">
        <div>
          <p className="text-lg text-bf mb-8">
            {`To use `->React.string}
            <span className="font-alphbeta text-xl pr-1"> {"FLOAT"->React.string} </span>
            {`, please connect to the ${Config.networkName}`->React.string}
          </p>
          {switch Config.networkId {
          | chainId if !(metamaskDefaultChainIds->Set.Int.has(chainId)) =>
            if !metamaskDoesntSupportSwitchNetworks {
              <div className="flex justify-center">
                <Metamask.AddOrSwitchNetwork
                  onFailureCallback={onFailureToSwitchNetworksCallback}
                />
              </div>
            } else {
              <div className="flex flex-col justify-center">
                <p className="mb-2 -mt-5">
                  {[
                    `Unfortunately your version of`->React.string,
                    <img src="/icons/metamask.svg" className="h-5 mx-1 inline" />,
                    `doesn't support automatic switching of networks.`->React.string,
                  ]->React.array}
                </p>
                <p className="mb-2">
                  {`To connect you'll have to switch to ${Config.networkName} manually.`->React.string}
                </p>
                {`To add ${Config.networkName} to metamask:`->React.string}
                <ul className="list-disc pl-10">
                  <li key={"instructions-1"}> {`Open Metamask.`->React.string} </li>
                  <li key={"instructions-2"}> {instructionForDropdown(~metamaskChainId)} </li>
                  <li key={"instructions-3"}> {`Select Custom RPC`->React.string} </li>
                  <li key={"instructions-4"}> {addNetworkInstructions()} </li>
                  <li key={"instructions-5"}> {`Save the new network`->React.string} </li>
                </ul>
              </div>
            }
          | _ =>
            <div>
              <ul className="list-decimal pl-10">
                <li key={"instructions-1"}> {`Open MetaMask`->React.string} </li>
                <li key={"instructions-2"}> {instructionForDropdown(~metamaskChainId)} </li>
                <li key={"instructions-3"}> {`Select ${Config.networkName}`->React.string} </li>
              </ul>
            </div>
          }}
        </div>
      </div>
    </div>
  }
}

let default = make
