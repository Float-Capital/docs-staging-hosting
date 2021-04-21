type injectedType = {isAuthorized: unit => JsPromise.t<bool>}

type connectorObj = {
  name: string,
  connector: injectedType,
  img: string,
  connectionPhrase: string,
}

// TODO: move this config to a global file

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
  type connectorOptions = {chainId: int}
  @module("@web3-react/torus-connector") @new
  external make: connectorOptions => injectedType = "TorusConnector"
}

let injected = InjectedConnector.make({supportedChainIds: [Config.networkId]})
