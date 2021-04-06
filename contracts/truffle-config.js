const path = require("path");
const HDWalletProvider = require("@truffle/hdwallet-provider");
const {
  mnemonic,
  mainnetProviderUrl,
  rinkebyProviderUrl,
  kovanProviderUrl,
  goerliProviderUrl,
  binanceTest,
  bsc,
  etherscanApiKey,
  bscscanApiKey,
} = require("./secretsManager.js");

const blockchainNodeHost = process.env.BLOCKCHAIN_NODE_HOST || "localhost";

const defaultLocalhostNetwork = {
  host: blockchainNodeHost, // Localhost (default: none)
  port: 8545, // Standard Ethereum port (default: none)
  network_id: "*", // Any network (default: none)
  gasPrice: 4000000000, // 40 gwei
  timeoutBlocks: 50000,
  networkCheckTimeout: 1000000,
};

const providerProxyHandler = (rpcUrl, provider) => {
  const get = (_target, property) => {
    if (!provider) {
      provider = new HDWalletProvider(mnemonic, rpcUrl, 0);
    }
    return provider[property];
  };
  return { get };
};

const lazyCreateNetwork = (rpcUrl) => {
  let provider = undefined;
  return new Proxy({}, providerProxyHandler(rpcUrl, provider));
};

module.exports = {
  plugins: ["solidity-coverage", "truffle-plugin-verify"],
  networks: {
    mainnet: {
      network_id: 1,
      provider: lazyCreateNetwork(mainnetProviderUrl),
      // gas: 4700000,
      gasPrice: 45000000000, // 45 gwei
      skipDryRun: true,
    },
    rinkeby: {
      network_id: 4,
      provider: lazyCreateNetwork(rinkebyProviderUrl),
      gas: 4700000,
      gasPrice: 10000000000, // 10 gwe
      skipDryRun: true,
    },
    kovan: {
      network_id: 42,
      provider: lazyCreateNetwork(kovanProviderUrl),
      // gas: 47000000,
      gasPrice: 10000000000, // 10 gwei
      skipDryRun: true,
    },
    goerli: {
      network_id: 5,
      provider: lazyCreateNetwork(goerliProviderUrl),
      gas: 8000000,
      gasPrice: 10000000000, // 10 gwei
      skipDryRun: true,
    },
    binanceTest: {
      network_id: 97,
      provider: lazyCreateNetwork(binanceTest),
      gas: 8000000,
      gasPrice: 40000000000, // see https://testnet.bscscan.com/chart/gasprice
      skipDryRun: true,
    },
    bsc: {
      network_id: 56,
      provider: lazyCreateNetwork(bsc),
      gas: 29000000,
      gasPrice: 12000000000, // 20 gwei
      skipDryRun: true,
      networkCheckTimeout: 1000000,
      timeoutBlocks: 200,
    },
    development: defaultLocalhostNetwork,
    graphTesting: defaultLocalhostNetwork,
    test: defaultLocalhostNetwork,
  },
  mocha: {
    reporter: "eth-gas-reporter",
    reporterOptions: {
      currency: "USD",
      gasPrice: 25, // in gwei
    },
  },
  compilers: {
    solc: {
      version: "0.8.3",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
        evmVersion: "istanbul",
      },
    },
  },
  api_keys: {
    etherscan: etherscanApiKey,
    bscscan: bscscanApiKey,
  },
};
