docker-compose -f docker-compose.mumbai.yml down -v # make sure docker doesn't have any stale volumes that could cause errors
docker-compose -f docker-compose.mumbai.yml up -d # start the docker
<<<<<<< HEAD
sleep 20
yarn codegen && yarn create-local && yarn deploy-local-mumbai
=======
yarn generate-all
sleep 5 # Pause (sleep) for 5 seconds to allow the docker images/services to finish setting up 
yarn codegen && yarn create-local && yarn deploy-local-mumbai
>>>>>>> dev
