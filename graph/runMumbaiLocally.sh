docker-compose -f docker-compose.mumbai.yml down -v # make sure docker doesn't have any stale volumes that could cause errors
docker-compose -f docker-compose.mumbai.yml up -d # start the docker
yarn generate-all
yarn codegen && yarn create-local && yarn deploy-local-mumbai
