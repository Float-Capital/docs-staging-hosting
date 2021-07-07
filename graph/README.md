# Long Short Graph

## Getting Started

`yarn codegen`
`yarn build`
`yarn deploy-local`
`yarn deploy-kovan`
`yarn deploy-mainnet`

### Testing on the mumbai network locally

```bash
docker-compose -f docker-compose.mumbai.yaml down -v # make sure docker doesn't have any stale volumes that could cause errors
docker-compose -f docker-compose.mumbai.yml up -d # start the docker
yarn codegen
yarn create-local
yarn deploy-local-mumbai
```

Then to check the logs of the graph node container run:

```bash
docker logs graph_graph-node_1 -f --tail 100
```

### Local testing requires local graph node

- [Guide to setting up a local node](https://thegraph.com/docs/quick-start#2.-run-a-local-graph-node)

## Self Hosted graph

Checkout the graph code you want to run.
Go in the `scripts` folder, and run `./updateSelfHostedGraph.sh`.

### Development tips

- Add event logging to the graph by setting the `EVENT_LOGGING` variable to true inside the `src/config.ts` file (please avoid comitting this)
