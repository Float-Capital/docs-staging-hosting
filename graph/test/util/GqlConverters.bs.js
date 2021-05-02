// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var BnJs = require("bn.js");
var Js_json = require("rescript/lib/js/js_json.js");

function parse(json) {
  var str = Js_json.decodeString(json);
  if (str !== undefined) {
    return new BnJs(str);
  } else {
    console.log("CRITICAL - should never happen!");
    return new BnJs(0);
  }
}

function serialize(bn) {
  return bn.toString();
}

var $$BigInt = {
  parse: parse,
  serialize: serialize
};

function parse$1(json) {
  var address = Js_json.decodeString(json);
  if (address !== undefined) {
    return address;
  } else {
    console.log("CRITICAL - couldn't decode eth address from graph, should never happen!");
    return "";
  }
}

function serialize$1(bytesString) {
  return bytesString;
}

var Address = {
  parse: parse$1,
  serialize: serialize$1
};

exports.$$BigInt = $$BigInt;
exports.Address = Address;
/* bn.js Not a pure module */
