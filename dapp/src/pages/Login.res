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
      initOptions: {showTorusButton: false},
    }),
    connectionPhrase: "Connect via Torus",
    img: "/img/wallet-icons/torus.svg",
  },
]

let metamaskDefaultChainIds = Set.Int.fromArray([1, 3, 4, 5, 42])

let metamaskDefaultChainIdsToMetamaskName = chainId =>
  switch chainId {
  | 3 => "Ropsten Test Network"
  | 4 => "Rinkeby Test Network"
  | 5 => "Goerli Test Network"
  | 42 => "Kovan Test Network"
  | _ => "Ethereum Mainnet"
  }

@react.component
let make = () => {
  let (_connectionStatus, activateConnector) = RootProvider.useActivateConnector()

  let router = Next.Router.useRouter()
  let nextPath = router.query->Js.Dict.get("nextPath")
  let optCurrentUser = RootProvider.useCurrentUser()

  let isMetamask = InjectedEthereum.useIsMetamask()
  let metamaskChainId = InjectedEthereum.useMetamaskChainId()

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
            <div className="flex justify-center"> <Metamask.AddOrSwitchNetwork /> </div>
          | _ =>
            <div>
              <ul className="list-decimal pl-10">
                <li> {`Open MetaMask`->React.string} </li>
                <li>
                  {switch metamaskChainId {
                  | Some(chainId) if metamaskDefaultChainIds->Set.Int.has(chainId) =>
                    `Click on the ${metamaskDefaultChainIdsToMetamaskName(
                        chainId,
                      )} dropdown`->React.string
                  | _ => `Click on the dropdown for the network you're connected to.`->React.string
                  }}
                </li>
                <li> {`Select ${Config.networkName}`->React.string} </li>
              </ul>
            </div>
          }}
        </div>
      </div>
    </div>
  }
}

let default = make
