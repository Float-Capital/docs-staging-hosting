const fs = require("fs");
const path = require("path");
const env = require('./env');
const { exec } = require('child_process');
const env = require("./env");

const prefix = env.openZeppelinDir;

const args = process.argv.splice(2);

let networks;
if(args.length > 0){
    networks = args;
}else{
    networks = Object.keys(env.networksToOpenZeppelin);
}

networks.forEach(network => {
    try{
        input = fs.readFileSync(path.join(prefix, env.networksToOpenZeppelin[network])).toString();
    }catch(e){
        console.log(e)
        return;
    }

    const address = (JSON.parse(input)).proxies["float-capital/LongShort"][0].implementation;

    const variables = {
        NETWORK: network,
        CONTRACT: `LongShort@${address}`
    };

    exec(`cd contracts && yarn verify-non-upgrade-contracts`, variables, (error) => {
        if(error){
            console.log(error);
        }else{
            console.log(`Successfully verified non-upgradeable contracts for  ${network}`);
        }
    });
    exec(`cd contracts && yarn verify-upgradeable-contracts`, variables, (error) => {
        if(error){
            console.log(error);
        }else{
            console.log(`Successfully verified upgradeable contracts for  ${network}`);
        }    
    });
})

