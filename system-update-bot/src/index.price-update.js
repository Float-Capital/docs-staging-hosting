const secretsManager = require("../secretsManager.js");
const ethers = require("ethers");

const longShortContractAddress = "0x4a23F8368fdF10e9BF90b96184990FED27ED0E6E";
const longShortAbi = [
  "function getMarketSplit(uint32 marketIndex, uint256 amount) view returns (uint256 longAmount, uint256 shortAmount) @100000",
  "function updateSystemState(uint32 marketIndex) external @400000",
  "function updateSystemStateMulti(uint32[] calldata marketIndexes) external @2800000",
];

// chainlink oracles that are used by oracle managers
const chainlinkOracleAddresses = [
  "0x0FCAa9c899EC5A91eBc3D5Dd869De833b06fB046",
  "0x0715A7794a1dc8e42615F059dD6e406A6594651A",
  "0xd0D5e3DB44DE05E9F294BB0a3bEEaF030DE24Ada",
];

const proxyAbi = [
  "function phaseId() external view returns (uint16)",
  "function phaseAggregators(uint16) external view returns (address)",
];

let provider;

let wallet;

let getAggregatorAddresses = (chainlinkOracleAddresses, wallet) =>
  Promise.all(
    chainlinkOracleAddresses.map((a) => {
      let contract = new ethers.Contract(a, proxyAbi, wallet);
      return contract.phaseId().then((id) => contract.phaseAggregators(id));
    })
  );

const setup = async () => {
  let providers = await Promise.all(
    secretsManager.providerUrls.map(
      (provider) => new ethers.providers.JsonRpcProvider(provider, 80001)
    )
  );
  provider = await new ethers.providers.FallbackProvider(providers, 1);

  wallet = await new ethers.Wallet.fromMnemonic(secretsManager.mnemonic);

  wallet = wallet.connect(provider);

  console.log("Getting aggregator addresses");

  // FUTURE WORK: account for changes to these implementation
  // addresses through (potentially) using ens and listeners.
  let aggregatorAddresses = await getAggregatorAddresses(
    chainlinkOracleAddresses,
    wallet
  );

  console.log("-------------------------");
  console.log("Initial update system state");
  await runUpdateSystemStateMulti();
  console.log("-------------------------");

  console.log("Listening for new answers.");
  aggregatorAddresses.forEach((address, index) => {
    let filter = {
      address,
      topics: [ethers.utils.id("AnswerUpdated(int256,uint256,uint256)")],
    };
    provider.on(filter, () => {
      console.log(
        `Price updated for oracle ${chainlinkOracleAddresses[index]}`
      );
      runUpdateSystemStateMulti();
    });
  });
};

let updateCounter = 0;

const defaultOptions = { gasPrice: 1000000000 };

const runUpdateSystemStateMulti = async () => {
  console.log("running update", ++updateCounter);

  let walletBalance = await wallet.getBalance();

  console.log(
    "Matic balance pre contract call: ",
    ethers.utils.formatEther(walletBalance)
  );

  let contract = new ethers.Contract(
    longShortContractAddress,
    longShortAbi,
    wallet
  );

  try {
    let update = await contract.functions.updateSystemStateMulti(
      [1, 2, 3],
      defaultOptions
    );
    console.log("submitted transaction", update.hash);
    let transactionReceipt = await update.wait();
    console.log("Transaction processed");
  } catch (e) {
    console.log("ERROR");
    console.log("-------------------");
    console.log(e);
  }

  let walletBalanceAfter = await wallet.getBalance();

  console.log(
    "Matic balance post contract call:",
    ethers.utils.formatEther(walletBalanceAfter),
    "gas used",
    ethers.utils.formatEther(walletBalance.sub(walletBalanceAfter))
  );
};

setup();
