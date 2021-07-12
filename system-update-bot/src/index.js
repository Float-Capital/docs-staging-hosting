var secretsManager = require("../secretsManager.js");
var ethers = require("ethers");

const longShortContractAddress = "0xa9d25B772f5AA249DA6bAee7Ea1F05524b0f0973";
const longShortAbi = [
  "function getMarketSplit(uint32 marketIndex, uint256 amount) view returns (uint256 longAmount, uint256 shortAmount) @100000",
  "function updateSystemState(uint32 marketIndex) external @400000", //TODO: Optimise the gas here
  "function updateSystemStateMulti(uint32[] calldata marketIndexes) external @2800000", // TODO: remove _ in latest version of contracts
];

let provider;

let wallet;

const setup = async () => {
  provider = await new ethers.providers.JsonRpcProvider(
    secretsManager.providerUrl
  );

  wallet = await new ethers.Wallet.fromMnemonic(secretsManager.mnemonic);

  wallet = wallet.connect(provider);
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

const sleep = (timeMs) => new Promise((res, rej) => setTimeout(res, timeMs));
const runUpdateSystemStateMultiContinuous = async () => {
  try {
    await runUpdateSystemStateMulti();
  } catch (e) {
    console.log("Fail safe try catch");
    console.log(e);
  }
  // Run every 63 seconds (max update time is 60 seconds so give some leway for network latency etc etc)
  await sleep(63000);

  // recursive call
  runUpdateSystemStateMultiContinuous();
};
setup().then(() => {
  runUpdateSystemStateMultiContinuous();
});
