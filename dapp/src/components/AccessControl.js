// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Caml_option = require("rescript/lib/js/caml_option.js");
var RootProvider = require("../libraries/RootProvider.js");

function AccessControl$EthNetwork(Props) {
  var children = Props.children;
  var alternateComponentOpt = Props.alternateComponent;
  var alternateComponent = alternateComponentOpt !== undefined ? Caml_option.valFromOption(alternateComponentOpt) : null;
  var optChainID = RootProvider.useChainId(undefined);
  if (optChainID !== undefined) {
    return children;
  } else {
    return alternateComponent;
  }
}

var EthNetwork = {
  make: AccessControl$EthNetwork
};

function AccessControl(Props) {
  var children = Props.children;
  var alternateComponentOpt = Props.alternateComponent;
  var alternateComponent = alternateComponentOpt !== undefined ? Caml_option.valFromOption(alternateComponentOpt) : null;
  var optUser = RootProvider.useCurrentUser(undefined);
  if (optUser !== undefined) {
    return children;
  } else {
    return alternateComponent;
  }
}

var make = AccessControl;

exports.EthNetwork = EthNetwork;
exports.make = make;
/* RootProvider Not a pure module */
