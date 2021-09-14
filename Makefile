.PHONY: graph-test
graph-test:
	cd graph && make graph-test

.PHONY: install
install:
	cd graph && yarn && cd ../contracts && yarn && cd ../dapp && yarn && cd ../scripts && yarn

.PHONY: configure-contract-addresses
configure-contract-addresses:
	cd contracts && yarn hardhat export --network mumbai --export ./deploymentSummary.json && cd .. && node scripts/deployments.js > dapp/src/contractAddresses.json

.PHONY: configure-contract-addresses
configure-contract-addresses-polygon:
	cd contracts && yarn hardhat export --network polygon --export ./deploymentSummary.json && cd .. && node scripts/deployments.js > dapp/src/contractAddresses.json

.PHONY: redeploy-testnet
redeploy-testnet:
	cd contracts && yarn update-testnet-contracts ; cd ../graph && yarn update-testnet-graph ; cd ../dapp && yarn update-testnet-ui
