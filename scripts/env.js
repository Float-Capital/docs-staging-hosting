module.exports = {
    openZeppelinDir: "./contracts/.openzeppelin",
    openZeppelinToYaml: {
        "dev-97.json" :  "subgraph.binance-test.yaml",
        "goerli.json" :  "subgraph.yaml",
        "dev-321.json": "subgraph.ganache.yaml"
    },
    networksToOpenZeppelin: {
        "binancetest" : "dev-97.json",
        "goerli": "goerli.json",
        "ganache" : "dev-321.json"
    }   
}