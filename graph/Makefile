.PHONY: clear-data
clear-data:
	sudo rm -rf data ganache-data

.PHONY: graph-test
graph-test:
	./start-graph.sh

.PHONY: graph-price-history-test
graph-price-history-test:
	PRICE_HISTORY="TRUE" ./start-graph.sh

.PHONY: setup-binance-test-graph
setup-binance-test-graph:
	docker-compose -f docker-compose.binance-test.yaml up -d
	yarn codegen
	sleep 15
	yarn create-local
	yarn deploy-local-binance
