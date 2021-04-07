const { BN } = require("@openzeppelin/test-helpers");

const Dai = artifacts.require("Dai");
const LongShort = artifacts.require("LongShort");
const Staker = artifacts.require("Staker");
const SyntheticToken = artifacts.require("SyntheticToken");
const YieldManagerMock = artifacts.require("YieldManagerMock");
const OracleManagerMock = artifacts.require("OracleManagerMock");
const YieldManagerVenus = artifacts.require("YieldManagerVenus");
const YieldManagerAave = artifacts.require("YieldManagerAave");
const OracleManagerEthKiller = artifacts.require("OracleManagerEthKiller");

// BSC testnet BUSD and vBUSD token addresses (for venus).
const bscTestBUSDAddress = "0x8301F2213c0eeD49a7E28Ae4c3e91722919B8B47";
const bscTestVBUSDAddress = "0x08e0A5575De71037aE36AbfAfb516595fE68e5e4";

const kovanDaiAddress = "0xff795577d9ac8bd7d90ee22b6c1703490b6512fd";

const aavePoolAddressKovan = "0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe";

// BSC testnet BAND oracle address. - (the same address is used for both kovan and bsc testnet - convenient)
const testnetBANDAddress = "0xDA7a001b254CD22e46d3eAB04d937489c93174C3";

const mintAndApprove = async (token, amount, user, approvedAddress) => {
  let bnAmount = new BN(amount);
  await token.mint(user, bnAmount);
  await token.approve(approvedAddress, bnAmount, {
    from: user,
  });
};

const deployTestMarket = async (
  syntheticSymbol,
  syntheticName,
  longShortInstance,
  fundTokenInstance,
  admin,
  networkName
) => {
  // Default mint/redeem fees.
  const _baseEntryFee = 0;
  const _badLiquidityEntryFee = 50;
  const _baseExitFee = 30;
  const _badLiquidityExitFee = 50;

  // We mock out the oracle manager unless we're on BSC testnet.
  let oracleManager;
  if (networkName == "binanceTest" || networkName == "kovan") {
    oracleManager = await OracleManagerEthKiller.new();
    await oracleManager.setup(admin, testnetBANDAddress);
  } else {
    oracleManager = await OracleManagerMock.new();
    await oracleManager.setup(admin);
  }

  // We mock out the yield manager unless we're on BSC testnet.
  let yieldManager;
  let fundTokenAddress;
  if (networkName == "binanceTest") {
    yieldManager = await YieldManagerVenus.new();
    fundTokenAddress = bscTestBUSDAddress;

    await yieldManager.setup(
      admin,
      longShortInstance.address,
      bscTestBUSDAddress,
      bscTestVBUSDAddress
    );
  } else if (networkName == "kovan") {
    yieldManager = await YieldManagerAave.new();
    fundTokenAddress = bscTestBUSDAddress;

    await yieldManager.setup(
      admin,
      longShortInstance.address,
      bscTestBUSDAddress,
      bscTestVBUSDAddress,
      aavePoolAddressKovan,
      0
    );
  } else {
    yieldManager = await YieldManagerMock.new();
    fundTokenAddress = fundTokenInstance.address;

    await yieldManager.setup(
      admin,
      longShortInstance.address,
      fundTokenInstance.address
    );

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

  await longShortInstance.initializeMarket(
    currentMarketIndex,
    _baseEntryFee,
    _baseExitFee,
    _badLiquidityEntryFee,
    _badLiquidityExitFee,
    kInitialMultiplier,
    kPeriod
  );
};

const zeroPointTwoEth = new BN("200000000000000000");
const zeroPointFiveEth = new BN("500000000000000000");
const topupBalanceIfLow = async (from, to) => {
  const senderBalance = new BN(await web3.eth.getBalance(from));
  if (zeroPointFiveEth.gt(senderBalance)) {
    throw "The admin account doesn't have enough ETH - need at least 0.5 ETH! (top up to over 1 ETH to be safe)";
  }
  const recieverBalance = new BN(await web3.eth.getBalance(to));
  if (zeroPointTwoEth.gt(recieverBalance)) {
    await web3.eth.sendTransaction({
      from,
      to,
      value: zeroPointTwoEth,
    });
  }
};

module.exports = async function (deployer, network, accounts) {
  const admin = accounts[0];
  const user1 = accounts[1];
  const user2 = accounts[2];
  const user3 = accounts[3];

  await topupBalanceIfLow(admin, user1);
  await topupBalanceIfLow(admin, user2);
  await topupBalanceIfLow(admin, user3);

  const oneHundredMintAmount = "100000000000000000000";
  const largeApprove = "10000000000000000000000000000000";

  // We use fake DAI if we're not on BSC testnet.
  let token;
  if (network == "kovan") {
    token = await Dai.at(kovanDaiAddress);
  } else if (network != "binanceTest") {
    token = await Dai.deployed();
  }

  const longShort = await LongShort.deployed();
  const staker = await Staker.deployed();
  await deployTestMarket("FTSE100", "FTSE", longShort, token, admin, network);
  await deployTestMarket("GOLD", "GOLD", longShort, token, admin, network);
  await deployTestMarket("SP", "S&P500", longShort, token, admin, network);

  // Don't try to mint tokens and fake transactions on BSC testnet.
  if (network == "binanceTest") {
    return;
  }

  const currentMarketIndex = (await longShort.latestMarket()).toNumber();
  for (let marketIndex = 1; marketIndex <= currentMarketIndex; ++marketIndex) {
    console.log(`Simulating transactions for marketIndex: ${marketIndex}`);

    const longAddress = await longShort.longTokens.call(marketIndex);
    const shortAddress = await longShort.shortTokens.call(marketIndex);

    let long = await SyntheticToken.at(longAddress);
    let short = await SyntheticToken.at(shortAddress);

    if (network == "kovan") {
      await token.approve(longShort.address, largeApprove, {
        from: user1,
      })
    } else {
      await mintAndApprove(token, oneHundredMintAmount, user1, longShort.address);
    }
    await longShort.mintLong(marketIndex, new BN(oneHundredMintAmount), {
      from: user1,
    });

    if (network == "kovan") {
      await token.approve(longShort.address, largeApprove, {
        from: user2,
      })
    } else {
      await mintAndApprove(token, oneHundredMintAmount, user2, longShort.address);
    }
    await longShort.mintShort(marketIndex, new BN(oneHundredMintAmount), {
      from: user2,
    });

    if (network == "kovan") {
      await token.approve(longShort.address, largeApprove, {
        from: user3,
      })
    } else {
      await mintAndApprove(token, oneHundredMintAmount, user3, longShort.address);
    }
    await longShort.mintShort(marketIndex, new BN(oneHundredMintAmount), {
      from: user3,
    });

    // Increase mock oracle price from 1 (default) to 1.1.
    const onePointOne = new BN("1100000000000000000");
    const oracleManagerAddr = await longShort.oracleManagers.call(marketIndex);
    const oracleManager = await OracleManagerMock.at(oracleManagerAddr);
    await oracleManager.setPrice(onePointOne);
    await longShort._updateSystemState(marketIndex);

    // Simulate user 2 redeeming half his tokens.
    const halfTokensMinted = new BN(oneHundredMintAmount).div(new BN(2));
    await short.increaseAllowance(longShort.address, halfTokensMinted, {
      from: user2,
    });
    await longShort.redeemShort(marketIndex, halfTokensMinted, {
      from: user2,
    });

    // Simulate user 1 redeeming a third of his tokens.
    const thirdTokensMinted = new BN(oneHundredMintAmount).div(new BN(3));
    await long.increaseAllowance(longShort.address, thirdTokensMinted, {
      from: user1,
    });
    await longShort.redeemLong(marketIndex, thirdTokensMinted, {
      from: user1,
    });

    if (network != "kovan") {
      await mintAndApprove(token, oneHundredMintAmount, user3, longShort.address);
    }
    await longShort.mintLongAndStake(
      marketIndex,
      new BN(oneHundredMintAmount),
      {
        from: user3,
      }
    );

    if (network != "kovan") {
      await mintAndApprove(token, oneHundredMintAmount, user3, longShort.address);
    }
    await longShort.mintShortAndStake(
      marketIndex,
      new BN(oneHundredMintAmount),
      {
        from: user3,
      }
    );

    // update system state and mint and stake again mint float
    await longShort._updateSystemState(marketIndex);

    await staker.claimFloat([longAddress, shortAddress], { from: user3 });
  }
};
