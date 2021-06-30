const { BN } = require("@openzeppelin/test-helpers");
const { current } = require("@openzeppelin/test-helpers/src/balance");
const ether = require("@openzeppelin/test-helpers/src/ether");

const Dai = artifacts.require("Dai");
const LongShort = artifacts.require("LongShort");
const Treasury = artifacts.require("Treasury_v0");
const Staker = artifacts.require("Staker");
const SyntheticToken = artifacts.require("SyntheticToken");
const YieldManagerMock = artifacts.require("YieldManagerMock");
const OracleManagerMock = artifacts.require("OracleManagerMock");
const YieldManagerAave = artifacts.require("YieldManagerAave");
const OracleManagerEthKiller = artifacts.require("OracleManagerEthKiller");

const mumbaiDaiAddress = "0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F";

const aavePoolAddressMumbai = "0x9198F13B08E299d85E096929fA9781A1E3d5d827";
const mumabiADai = "0x639cB7b21ee2161DF9c882483C9D55c90c20Ca3e";

/* See docs:
 *  https://kovan.etherscan.io/address/0xDA7a001b254CD22e46d3eAB04d937489c93174C3#code
 *  https://docs.matic.network/docs/develop/oracles/bandstandarddataset/
 */
const testnetBANDAddress = "0xDA7a001b254CD22e46d3eAB04d937489c93174C3";

const mintAndApprove = async (token, amount, user, approvedAddress) => {
  let bnAmount = new BN(amount);
  await token.mint(user, bnAmount);
  await token.approve(approvedAddress, bnAmount, {
    from: user,
  });
};

const deployTestMarket = async (
  syntheticName,
  syntheticSymbol,
  longShortInstance,
  treasuryInstance,
  fundTokenInstance,
  admin,
  networkName,
  token
) => {
  console.log("Deploying test Market", syntheticName, syntheticSymbol);
  // Default mint/redeem fees.
  const _baseEntryFee = 0;
  const _badLiquidityEntryFee = 50;
  const _baseExitFee = 30;
  const _badLiquidityExitFee = 50;

  // We mock out the oracle manager unless we're on BSC testnet.
  let oracleManager;
  if (networkName == "mumbai") {
    oracleManager = await OracleManagerEthKiller.new(admin, testnetBANDAddress);
  } else {
    oracleManager = await OracleManagerMock.new(admin);
  }

  // We mock out the yield manager unless we're on BSC testnet.
  let yieldManager;
  let fundTokenAddress;
  if (networkName == "mumbai") {
    yieldManager = await YieldManagerAave.new(
      admin,
      longShortInstance.address,
      treasuryInstance.address,
      mumbaiDaiAddress,
      mumabiADai,
      aavePoolAddressMumbai,
      0
    );
    fundTokenAddress = mumbaiDaiAddress;
  } else {
    yieldManager = await YieldManagerMock.new(
      admin,
      longShortInstance.address,
      treasuryInstance.address,
      fundTokenInstance.address
    );

    fundTokenAddress = fundTokenInstance.address;

    var mintRole = await fundTokenInstance.MINTER_ROLE.call();
    await fundTokenInstance.grantRole(mintRole, yieldManager.address);
  }

  await longShortInstance.newSyntheticMarket(
    syntheticName,
    syntheticSymbol,
    fundTokenAddress,
    oracleManager.address,
    yieldManager.address
  );

  const currentMarketIndex = await longShortInstance.latestMarket.call();
  const kInitialMultiplier = new BN("5000000000000000000"); // 5x
  let kPeriod = 864000; // 10 days

  if (networkName != "mumbai") {
    await mintAndApprove(
      token,
      new BN("2000000000000000000"),
      admin,
      longShortInstance.address
    );
  }

  await longShortInstance.initializeMarket(
    currentMarketIndex,
    _baseEntryFee,
    _badLiquidityEntryFee,
    _baseExitFee,
    _badLiquidityExitFee,
    kInitialMultiplier,
    kPeriod,
    new BN("1000000000000000000")
  );
};

const mintShortNextPriceWithSystemUpdate = async (
  amount,
  marketIndex,
  paymentToken,
  longShort,
  user,
  oracleManager,
  network
) => {
  if (network == "mumbai") {
    await paymentToken.approve(longShort.address, amount, {
      from: user,
    });
  } else {
    await mintAndApprove(paymentToken, amount, user, longShort.address);
  }

  await longShort.mintShortNextPrice(marketIndex, new BN(amount), {
    from: user,
  });

  const currentPrice = await oracleManager.getLatestPrice();
  const nextPrice = currentPrice.mul(new BN(101)).div(new BN(100));
  await oracleManager.setPrice(nextPrice);

  await longShort._updateSystemState(marketIndex);
};

const mintLongNextPriceWithSystemUpdate = async (
  amount,
  marketIndex,
  paymentToken,
  longShort,
  user,
  oracleManager,
  network
) => {
  if (network == "mumbai") {
    await paymentToken.approve(longShort.address, amount, {
      from: user,
    });
  } else {
    await mintAndApprove(paymentToken, amount, user, longShort.address);
  }

  console.log("1");

  await longShort.mintLongNextPrice(marketIndex, new BN(amount), {
    from: user,
  });

  if (network != "mumbai") {
    const currentPrice = await oracleManager.getLatestPrice();
    const nextPrice = currentPrice.mul(new BN(101)).div(new BN(100));
    await oracleManager.setPrice(nextPrice);
  }

  await longShort._updateSystemState(marketIndex);
};

const zeroPointZeroTwoEth = new BN("20000000000000000");
const zeroPointZeroFiveEth = new BN("50000000000000000");
const topupBalanceIfLow = async (from, to) => {
  const senderBalance = new BN(await web3.eth.getBalance(from));
  if (zeroPointZeroFiveEth.gt(senderBalance)) {
    throw "The admin account doesn't have enough ETH - need at least 0.05 ETH! (top up to over 1 ETH to be safe)";
  }
  const recieverBalance = new BN(await web3.eth.getBalance(to));
  if (zeroPointZeroTwoEth.gt(recieverBalance)) {
    await web3.eth.sendTransaction({
      from,
      to,
      value: zeroPointZeroTwoEth,
    });
  }
};

module.exports = async function (deployer, network, accounts) {
  const admin = accounts[0];
  const user1 = accounts[1];
  const user2 = accounts[2];
  const user3 = accounts[3];

  const longShort = await LongShort.deployed();
  const treasury = await Treasury.deployed();
  const staker = await Staker.deployed();

  await topupBalanceIfLow(admin, user1);
  await topupBalanceIfLow(admin, user2);
  await topupBalanceIfLow(admin, user3);

  const tenMintAmount = "10000000000000000000";
  const largeApprove = "10000000000000000000000000000000";

  if (network == "mumbai") {
    token = await Dai.at(mumbaiDaiAddress);
    await token.approve(longShort.address, new BN("200000000000000000000"), {
      from: admin,
    });
  } else {
    token = await Dai.deployed();
    await mintAndApprove(token, new BN("20000000000000000000"), user3, admin);
  }

  // console.log("topping up balance");
  // await topupBalanceIfLow(admin, user1);
  // await topupBalanceIfLow(admin, user2);
  // await topupBalanceIfLow(admin, user3);
  // console.log("balance topped up :)");

  // await deployTestMarket(
  //   "ETH Killers",
  //   "ETHK",
  //   longShort,
  //   treasury,
  //   token,
  //   admin,
  //   network,
  //   token
  // );

  // await deployTestMarket(
  //   "The Flippening",
  //   "EBD",
  //   longShort,
  //   treasury,
  //   token,
  //   admin,
  //   network,
  //   token
  // );

  // await deployTestMarket(
  //   "Gold",
  //   "GOLD",
  //   longShort,
  //   treasury,
  //   token,
  //   admin,
  //   network,
  //   token
  // );

  const currentMarketIndex = (await longShort.latestMarket()).toNumber();
  let verifyString = "truffle run verify";
  if (network == "mumbai") {
    for (
      let marketIndex = 1;
      marketIndex <= currentMarketIndex;
      ++marketIndex
    ) {
      verifyString += ` YieldManagerAave@${await longShort.yieldManagers(
        marketIndex
      )} OracleManagerEthKiller@${await longShort.oracleManagers(
        marketIndex
      )} SyntheticToken@${await longShort.syntheticTokens(
        marketIndex, true
      )} SyntheticToken@${await longShort.syntheticTokens(marketIndex, false)}`;
    }

    console.log(`To verify market specific contracts run the following:
    
    \`${verifyString} --network ${network}\``);
  }

  for (let marketIndex = 1; marketIndex <= currentMarketIndex; ++marketIndex) {
    // if (network == "mumbai") return

    console.log(`Simulating transactions for marketIndex: ${marketIndex}`);

    const longAddress = await longShort.syntheticTokens.call(marketIndex, true);
    const shortAddress = await longShort.syntheticTokens.call(
      marketIndex,
      false
    );

    let long = await SyntheticToken.at(longAddress);
    let short = await SyntheticToken.at(shortAddress);

    const oracleManagerAddr = await longShort.oracleManagers.call(marketIndex);
    const oracleManager = await OracleManagerMock.at(oracleManagerAddr);

    console.log("Running update system state");
    await longShort._updateSystemState(marketIndex);

    console.log("Here");
    await mintLongNextPriceWithSystemUpdate(
      tenMintAmount,
      marketIndex,
      token,
      longShort,
      user1,
      oracleManager,
      network
    );
    await mintLongNextPriceWithSystemUpdate(
      tenMintAmount,
      marketIndex,
      token,
      longShort,
      user2,
      oracleManager,
      network
    );
    await mintLongNextPriceWithSystemUpdate(
      tenMintAmount,
      marketIndex,
      token,
      longShort,
      user3,
      oracleManager,
      network
    );

    const halfTokensMinted = new BN(tenMintAmount).div(new BN(2));
    await mintShortNextPriceWithSystemUpdate(
      halfTokensMinted,
      marketIndex,
      token,
      longShort,
      user1,
      oracleManager,
      network
    );
    await mintShortNextPriceWithSystemUpdate(
      halfTokensMinted,
      marketIndex,
      token,
      longShort,
      user2,
      oracleManager,
      network
    );
    await mintShortNextPriceWithSystemUpdate(
      halfTokensMinted,
      marketIndex,
      token,
      longShort,
      user3,
      oracleManager,
      network
    );

    // Increase mock oracle price from 1 (default) to 1.1.
    if (network != "mumbai")
      await oracleManager.setPrice(new BN("1100000000000000000"));

    await longShort._updateSystemState(marketIndex);

    // Simulate user 2 redeeming half his tokens.
    // const halfTokensMinted = new BN(tenMintAmount).div(new BN(2));
    // await short.increaseAllowance(longShort.address, halfTokensMinted, {
    //   from: user2,
    // });
    // await longShort.redeemShort(marketIndex, halfTokensMinted, {
    //   from: user2,
    // });

    // // Simulate user 1 redeeming a third of his tokens.
    // const thirdTokensMinted = new BN(tenMintAmount).div(new BN(3));
    // await long.increaseAllowance(longShort.address, thirdTokensMinted, {
    //   from: user1,
    // });
    // await longShort.redeemLong(marketIndex, thirdTokensMinted, {
    //   from: user1,
    // });

    // if (network != "mumbai") {
    //   await mintAndApprove(token, tenMintAmount, user3, longShort.address);
    // }
    // await longShort.mintLongAndStake(marketIndex, new BN(tenMintAmount), {
    //   from: user3,
    // });

    // if (network != "mumbai") {
    //   await mintAndApprove(token, tenMintAmount, user3, longShort.address);
    // }
    // await longShort.mintShortAndStake(marketIndex, new BN(tenMintAmount), {
    //   from: user3,
    // });

    // // update system state and mint and stake again mint float
    // await longShort._updateSystemState(marketIndex);

    // await staker.claimFloatCustom([marketIndex], {
    //   from: user3,
    // });
  }
};
