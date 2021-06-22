var secretsManager = require("../secretsManager.js");
var ethers = require("ethers");

const longShortContractAddress = "0x3Fe666e021714eaF51e061D8efFCc6fA4b390DC0";
const longShortAbi = [
  "function getMarketSplit(uint32 marketIndex, uint256 amount) view returns (uint256 longAmount, uint256 shortAmount) @100000",
  "function _updateSystemState(uint32 marketIndex) external @400000", //TODO: Optimise the gas here
  "function _updateSystemStateMulti(uint32[] calldata marketIndexes) external @1800000", // TODO: remove _ in latest version of contracts
];


let provider;

let wallet;

const setup = async () => {
  console.log({ secretsManager })
  provider = await new ethers.providers.JsonRpcProvider(
    secretsManager.providerUrl
  );

  wallet = await new ethers.Wallet.fromMnemonic(secretsManager.mnemonic);

  wallet = wallet.connect(provider);
}

let updateCounter = 0;

const defaultOptions = { gasPrice: 1000000000 };

const runUpdateSystemStateMulti = async () => {
  console.log("running update", ++updateCounter)

  let walletBalance = await wallet.getBalance();

  console.log("Matic balance pre contract call: ", walletBalance.toString());

  let contract = new ethers.Contract(
    longShortContractAddress,
    longShortAbi,
    wallet
  );

  try {
    let update = await contract.functions._updateSystemStateMulti([1, 2, 3], defaultOptions);
    console.log(JSON.stringify(update));
  } catch (e) {
    console.log("ERROR");
    console.log("-------------------");
    console.log(e);
  }

  walletBalance = await wallet.getBalance();

  console.log("Matic balance post contract call: ", walletBalance.toString());
}

setup().then(() => {
  runUpdateSystemStateMulti()
  setInterval(runUpdateSystemStateMulti, 15000)
})
