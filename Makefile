.PHONY: graph-test
graph-test:
	cd graph && make graph-test

.PHONY: install
install:
	cd graph && yarn && cd ../contracts && yarn

.PHONY: configure-contract-addresses
configure-contract-addresses:
	node scripts/deployments.js > dapp/src/contractAddresses.json

.PHONY: redeploy-testnet
redeploy-testnet:
	cd contracts && yarn update-testnet-contracts ; cd ../graph && yarn update-testnet-graph ; cd ../dapp && yarn update-testnet-ui
