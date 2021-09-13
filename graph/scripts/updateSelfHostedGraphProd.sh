cd ../../contracts
yarn
yarn compile

mkdir -p ../graph/abis-copy

cp -r abis/* ../graph/abis-copy

cd ../graph

yarn generate-all

cd scripts

docker-compose -f docker-compose.polygon.selfhosted.yaml up --build -d
docker image prune -f

# Give it time start everything...
sleep 60

docker exec -ti graph-deployer-prod sh -c "yarn graph-command create float-capital/float-capital-alpha${GRAPH_POSTFIX} --node http://graph-node-prod:8020"

docker exec -ti graph-deployer-prod sh -c "yarn graph-command deploy float-capital/float-capital-alpha${GRAPH_POSTFIX} --ipfs http://ipfs-prod:5001 --node http://graph-node-prod:8020"
