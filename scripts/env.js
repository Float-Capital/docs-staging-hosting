module.exports = {
  openZeppelinDir: "./contracts/.openzeppelin",
  openZeppelinToYaml: {
    "dev-97.json": "subgraph.binance-test.yaml",
    "goerli.json": "subgraph.yaml",
    "dev-321.json": "subgraph.ganache.yaml",
  },
  networksToOpenZeppelin: {
    binanceTest: "dev-97.json",
    goerli: "goerli.json",
    ganache: "dev-321.json",
  },
  implementationVarsToProxies: {
    LONGSHORT_IMPLEMENTATION: "float-capital/OracleAgregator",
    ORACLE_MANAGER_IMPLEMENTATION: "float-capital/YieldManager",
    YIELD_MANAGER_IMPLEMENTATION: "float-capital/LongShort",
    STAKER_IMPLEMENTATION: "float-capital/Staker",
  },
};
