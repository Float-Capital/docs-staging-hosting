.PHONY: graph-test
graph-test:
	cd graph && make graph-test

.PHONY: install
install:
	cd graph && yarn && cd ../contracts && yarn

.PHONY: configure-contract-addresses
configure-contract-addresses:
	node scripts/deployments.js > dapp/src/contractAddresses.json
