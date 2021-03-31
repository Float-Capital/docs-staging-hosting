import { InjectedConnector } from "@web3-react/injected-connector";
import { NetworkConnector } from "@web3-react/network-connector";
import { WalletConnectConnector } from "@web3-react/walletconnect-connector";
// import { WalletLinkConnector } from "@web3-react/walletlink-connector";
// import { LedgerConnector } from "@web3-react/ledger-connector";
// import { TrezorConnector } from "@web3-react/trezor-connector";
// import { FrameConnector } from "@web3-react/frame-connector";
import { TorusConnector } from "@web3-react/torus-connector";
// import { AuthereumConnector } from "@web3-react/authereum-connector";

const POLLING_INTERVAL = 8000;
const RPC_URLS = {
  1: "https://mainnet.infura.io/v3/84842078b09946638c03157f83405213",
  5: "https://goerli.infura.io/v3/84842078b09946638c03157f83405213",
};

export const injected = new InjectedConnector({
  // TODO: make this only accept 2 networks , mainnet and testnet. Then display a message when people use the wrong network.
  // QUESTION: should we allow them to connect to matic here (137/80001)? Maybe they should always use our connector?
  supportedChainIds: [1, 3, 4, 5, 42, 97, 137, 1337, 80001],
});

export const sideChainNetwork = (defaultChainId) => {
  return new NetworkConnector({
    urls: {
      137: "https://rpc-mainnet.matic.network",
      // 80001: "https://ztjv2.csb.app",
      80001: "https://rpc-mumbai.matic.today",
      // 1337: "http://localhost:8545",
      // 137: "http://localhost:8545",
      // 80001: "http://localhost:8545",
    },
    defaultChainId,
    pollingInterval: POLLING_INTERVAL,
  });
};

export const walletconnect = new WalletConnectConnector({
  rpc: { 1: RPC_URLS[1] },
  bridge: "https://bridge.walletconnect.org",
  qrcode: true,
  pollingInterval: POLLING_INTERVAL,
});

// export const walletlink = new WalletLinkConnector({
//   url: RPC_URLS[1],
//   appName: "web3-react example"
// });

// export const ledger = new LedgerConnector({
//   chainId: 1,
//   url: RPC_URLS[1],
//   pollingInterval: POLLING_INTERVAL
// });

// export const trezor = new TrezorConnector({
//   chainId: 1,
//   url: RPC_URLS[1],
//   pollingInterval: POLLING_INTERVAL,
//   manifestEmail: "dummy@abc.xyz",
//   manifestAppUrl: "https://8rg3h.csb.app/"
// });

// export const frame = new FrameConnector({ supportedChainIds: [1] });




export const torus = new TorusConnector(
  { chainId: 1 },
  { showTorusButton: false }
);

// export const authereum = new AuthereumConnector({ chainId: 42 });

export default [
  {
    name: "MetaMask",
    connector: injected,
    img: "/img/wallet-icons/metamask.svg",
    connectionPhrase: "Connect via MetaMask",
  },
  {
    name: "WalletConnect",
    connector: walletconnect,
    connectionPhrase: "Connect via WalletConnect",
    img: "/img/wallet-icons/walletConnect.svg",
  },
  {
    name: "Torus",
    connector: torus,
    connectionPhrase: "Connect via Torus",
    img: "/img/wallet-icons/torus.svg",
  },
];
