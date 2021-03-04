const Migrations = artifacts.require("Migrations");
const { scripts, ConfigManager } = require("@openzeppelin/cli");
const { add, push, create } = scripts;

function sleep(ms) {
  // add ms millisecond timeout before promise resolution
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports = async function(deployer, network, accounts) {
  deployer.deploy(Migrations);

  // This code is only for the sake of deploying proxies to bsc to get rewards early...
  if (network == "bsc") {
    const options = await ConfigManager.initNetworkConfiguration({
      network: network,
      from: accounts[0],
    });

    await add({
      contractsData: [
        {
          name: "LongShortPlaceholder",
          alias: "LongShort",
        },
        {
          name: "FloatTokenPlaceholder",
          alias: "FloatToken",
        },
        {
          name: "StakerPlaceholder",
          alias: "Staker",
        },
        {
          name: "TokenFactoryPlaceholder",
          alias: "TokenFactory",
        },
      ],
    });
    await sleep(1000);
    await push({
      ...options,
    });
    await sleep(1000);

    await create({
      ...options,
      contractAlias: "LongShort",
    });
    await sleep(1000);
    await create({
      ...options,
      contractAlias: "FloatToken",
    });
    await sleep(1000);
    await create({
      ...options,
      contractAlias: "Staker",
    });
    await sleep(1000);
    await create({
      ...options,
      contractAlias: "TokenFactory",
    });
  }
};
