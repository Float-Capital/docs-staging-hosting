const fs = require("fs");
const path = require("path");

let output = {};

const dir = "./contracts/build/contracts";
const files = fs.readdirSync(dir);
files.map((file) => {
  const data = fs.readFileSync(path.join(dir, file));
  const build = JSON.parse(data.toString());
  if (build.contractName == "migrations") {
    return;
  }

  Object.keys(build.networks).forEach((networkId) => {
    output[networkId] = output[networkId] || {};
    output[networkId][build.contractName] = build.networks[networkId].address;
  });
});

console.log(JSON.stringify(output, null, 2));
