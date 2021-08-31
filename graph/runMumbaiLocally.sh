docker-compose -f docker-compose.mumbai.yml down -v # make sure docker doesn't have any stale volumes that could cause errors
docker-compose -f docker-compose.mumbai.yml up -d # start the docker
sleep 20
yarn codegen && yarn create-local && yarn deploy-local-mumbai
