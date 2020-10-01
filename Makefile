.PHONY: graph-test
graph-test:
	cd graph && make graph-test

.PHONY: install
install:
	cd graph && yarn && cd ../contracts && yarn
