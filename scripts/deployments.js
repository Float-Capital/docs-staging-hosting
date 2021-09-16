const fs = require("fs");
const path = require("path");

let output = {
  uiContracts: {},
  otherContracts: {}
};

const dir = "./contracts";

const data = fs.readFileSync(path.join(dir, 'deploymentSummary.json'));
const build = JSON.parse(data.toString());

let uiContracts = [
  "FloatCapital_v0",
  "FloatToken",
  "LongShort",
  "Migrations",
  "Staker",
  "TokenFactory",
  "Treasury_v0",
  "Dai",
  "GEMS"
]

let renames = {
  "AlphaTestFLT": "FloatToken",
  "TreasuryAlpha": "Treasury_v0"
}

Object.keys(build.contracts).forEach((contractName) => {
  let label = !!renames[contractName] ? renames[contractName] : contractName;

  if (uiContracts.indexOf(label) != -1) {
    output.uiContracts[label] = build.contracts[contractName].address;
  } else {
    output.otherContracts[label] = build.contracts[contractName].address;
  }
});


if (build.name == "mumbai") {
  output.uiContracts["Dai"] = "0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F";
} else if (build.name == "polygon") {
  output.uiContracts["Dai"] = "0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063";
}
console.log(JSON.stringify(output, null, 2));
