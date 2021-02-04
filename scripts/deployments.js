var fs = require("fs");
var path = require("path");

var output = {};

const dir = "./contracts/build/contracts";
var files = fs.readdirSync(dir);
files.map((file) => {
  var data = fs.readFileSync(path.join(dir, file));
  var build = JSON.parse(data.toString());

  Object.keys(build.networks).forEach((nid) => {
    output[nid] = output[nid] || {};
    output[nid][build.contractName] = build.networks[nid].address;
  });
});

console.log(JSON.stringify(output, null, 2));
