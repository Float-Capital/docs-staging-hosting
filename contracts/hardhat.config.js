require("hardhat-spdx-license-identifier");
require("@tenderly/hardhat-tenderly"); // https://hardhat.org/plugins/tenderly-hardhat-tenderly.html
require("@float-capital/solidity-coverage");
require("@openzeppelin/hardhat-upgrades");
require("./hardhat-plugins/codegen");
require("hardhat-deploy");
require("@nomiclabs/hardhat-ethers");

require("hardhat-docgen");

const {
  mnemonic,
  mainnetProviderUrl,
  rinkebyProviderUrl,
  kovanProviderUrl,
  goerliProviderUrl,
  etherscanApiKey,
  polygonscanApiKey,
  mumbaiProviderUrl,
} = require("./secretsManager.js");

let runCoverage =
  !process.env.DONT_RUN_REPORT_SUMMARY ||
  process.env.DONT_RUN_REPORT_SUMMARY.toUpperCase() != "TRUE";
if (runCoverage) {
  require("hardhat-abi-exporter");
  require("hardhat-gas-reporter");
}
let isWaffleTest =
  !!process.env.WAFFLE_TEST && process.env.WAFFLE_TEST.toUpperCase() == "TRUE";
if (isWaffleTest) {
  require("./test-waffle/Setup.js").mochaSetup();
  require("@nomiclabs/hardhat-waffle");
} else {
  require("@nomiclabs/hardhat-truffle5");
}

// This is a sample Buidler task. To learn how to create your own go to
// https://buidler.dev/guides/create-task.html
task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(await account.getAddress());
  }
});

// You have to export an object to set up your config
// This object can have the following optional entries:
// defaultNetwork, networks, solc, and paths.
// Go to https://buidler.dev/config/ to learn more
module.exports = {
  // This is a sample solc configuration that specifies which version of solc to use
  solidity: {
    version: "0.8.3",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
    },
    mumbai: {
      chainId: 80001,
      url: mumbaiProviderUrl || "https://rpc-mumbai.maticvigil.com/v1",
    },
  },
  paths: {
    tests: isWaffleTest ? "./test-waffle" : "./test",
  },
  namedAccounts: {
    deployer: {
      default: 0, // here this will by default take the first account as deployer
      1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
    },
    admin: {
      default: 1,
    },
  },
  gasReporter: {
    // Disabled by default for faster running of tests
    enabled: true,
    currency: "USD",
    gasPrice: 80,
    coinmarketcap: "9aacee3e-7c04-4978-8f93-63198c0fbfef",
  },
  spdxLicenseIdentifier: {
    // Set these to true if you ever want to change the licence on all of the contracts (by changing it in package.json)
    overwrite: false,
    runOnCompile: false,
  },
  abiExporter: {
    path: "./abis",
    clear: true,
    flat: true,
    only: [
      ":ERC20Mock$",
      ":YieldManagerMock$",
      ":LongShort$",
      ":SyntheticToken$",
      ":YieldManagerAave$",
      ":FloatCapital_v0$",
      ":Migrations$",
      ":TokenFactory$",
      ":FloatToken$",
      ":Staker$",
      ":Treasury_v0$",
      ":OracleManager$",
      ":OracleManagerChainlink$",
      ":OracleManagerMock$",
      ":LendingPoolAaveMock$",
      ":AaveIncentivesControllerMock$",
      "Mockable$",
    ],
    spacing: 2,
  },
  docgen: {
    path: "./contract-docs",
    only: [
      "^contracts/LongShort",
      "^contracts/Staker",
      "^contracts/FloatToken",
      "^contracts/SyntheticToken",
      "^contracts/TokenFactory",
      "^contracts/YieldManagerAave",
    ],
  },
};
