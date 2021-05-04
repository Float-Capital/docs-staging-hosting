type injectedType = {isAuthorized: unit => JsPromise.t<bool>}

type connectorObj = {
  name: string,
  connector: injectedType,
  img: string,
  connectionPhrase: string,
}

module InjectedConnector = {
  type connectorOptions = {supportedChainIds: array<int>}
  @module("@web3-react/injected-connector") @new
  external make: connectorOptions => injectedType = "InjectedConnector"
}
module WalletConnectConnector = {
  type connectorOptions = {
    rpc: Js.Dict.t<string>,
    bridge: string,
    qrcode: bool,
    pollingInterval: int,
  }
  @module("@web3-react/walletconnect-connector") @new
  external make: connectorOptions => injectedType = "WalletConnectConnector"
}
module TorusConnector = {
  type initializationOptions = {showTorusButton: bool}
  type connectorOptions = {chainId: int, initOptions: initializationOptions}
  @module("@web3-react/torus-connector") @new
  external make: (connectorOptions) => injectedType = "TorusConnector"
}

let injected = InjectedConnector.make({supportedChainIds: [Config.networkId]})
