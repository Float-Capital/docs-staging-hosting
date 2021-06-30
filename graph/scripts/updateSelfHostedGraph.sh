cd ../../contracts
yarn
yarn compile

cp -r abis/* ../graph/abis-copy

cd ../graph/scripts

docker-compose -f docker-compose.mumbai.selfhosted.yaml up --build -d
docker image prune -f

# Give it time start everything...
sleep 120

docker exec -ti graph-deployer sh -c "yarn graph-command create float-capital/float-capital --node http://graph-node:8020"
docker exec -ti graph-deployer sh -c "yarn graph-command create float-capital/float-oracle-prices --node http://graph-node:8020"

docker exec -ti graph-deployer sh -c "yarn graph-command deploy float-capital/float-capital --ipfs http://ipfs:5001 --node http://graph-node:8020 ./subgraph.mumbai.yaml"
docker exec -ti graph-deployer sh -c "yarn graph-command deploy float-capital/float-oracle-prices --ipfs http://ipfs:5001 --node http://graph-node:8020 ./subgraph.priceHistory.mumbai.yaml"
