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

output["97"]["Dai"] = "0x8301F2213c0eeD49a7E28Ae4c3e91722919B8B47";

console.log(JSON.stringify(output, null, 2));
