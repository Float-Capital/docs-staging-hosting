// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Globals = require("./Globals.bs.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");

function startsWith(prim0, prim1) {
  return prim0.startsWith(prim1);
}

var uppercaseFirstLetter = ((someString) => someString.charAt(0).toUpperCase() + someString.slice(1));

function solASTTypeToRescriptType(typeDescrStr) {
  switch (typeDescrStr) {
    case "address[]" :
        return "array<Ethers.ethAddress>";
    case "bool" :
        return "bool";
    case "bytes32" :
    case "bytes4" :
    case "string" :
        return "string";
    case "uint16[]" :
    case "uint32[]" :
        return "array<int>";
    case "int16" :
    case "int32" :
    case "int8" :
    case "uint16" :
    case "uint32" :
    case "uint8" :
        return "int";
    default:
      if (Globals.containsRe(typeDescrStr, /\[/g)) {
        console.warn("Rescript type conversion for array types for type " + typeDescrStr + " currently limited. YOu'll have to put in the correct bindings for this type when you call it");
        return "array<'" + typeDescrStr + ">";
      } else if (typeDescrStr.startsWith("enum")) {
        return "int";
      } else if (typeDescrStr.startsWith("uint") || typeDescrStr.startsWith("int")) {
        return "Ethers.BigNumber.t";
      } else if (typeDescrStr.startsWith("contract") || typeDescrStr === "address") {
        return "Ethers.ethAddress";
      } else {
        console.warn("Rescript type parsing for " + typeDescrStr + " type not implemented yet. E.g. struct parsing. You'll have to put in the correct bindings for this type when you call it.");
        return "'" + typeDescrStr;
      }
  }
}

function defaultParamName(index) {
  return "param" + String(index);
}

function paramName(index, name) {
  if (name !== "") {
    return Globals.lowerCaseFirstLetter(Globals.formatKeywords(name));
  } else {
    return "param" + String(index);
  }
}

function parametersToRecordType(fnType, recordName) {
  return "\n  type " + recordName + " = {\n" + Globals.reduceStrArr(Belt_Array.mapWithIndex(fnType.parameters, (function (i, param) {
                    return "\n     " + paramName(i, param.name) + " : " + solASTTypeToRescriptType(param.type_) + ",\n    ";
                  }))) + "}\n\n  ";
}

function callTypeName(name) {
  return Globals.lowerCaseFirstLetter(name) + "Call";
}

function paramTypeForCalls(def) {
  var typeName = Globals.lowerCaseFirstLetter(def.name) + "Call";
  if (def.parameters.length === 0) {
    return "type " + typeName;
  } else {
    return parametersToRecordType(def, typeName);
  }
}

function solParamsToToRecordWithSameNames(params) {
  return "\n  {\n" + Globals.reduceStrArr(Belt_Array.mapWithIndex(params, (function (i, param) {
                    var name = paramName(i, param.name);
                    return "\n     " + name + " : " + name + ",\n    ";
                  }))) + "}\n\n  ";
}

function identifiersToTuple(arr) {
  return "(" + Globals.commafiy(Belt_Array.mapWithIndex(arr, (function (i, tp) {
                    return paramName(i, tp.name);
                  }))) + ")";
}

function getRescriptParamsForCalls(params) {
  if (params.length === 1) {
    return "_m";
  } else {
    return identifiersToTuple(params);
  }
}

function getCallsHelper(fnType) {
  return [
          Globals.lowerCaseFirstLetter(fnType.name) + "Call",
          Globals.lowerCaseFirstLetter(fnType.name) + "Calls"
        ];
}

function getCallsArrayContent(fnType) {
  var tmp;
  if (fnType.parameters.length === 1) {
    var p = fnType.parameters[0];
    tmp = "let " + paramName(0, p.name) + " = _m->Array.getUnsafe(0)";
  } else {
    tmp = "";
  }
  return "array->Array.map(((" + getRescriptParamsForCalls(fnType.parameters) + ")) => {\n            " + tmp + "\n            " + (
          fnType.parameters.length === 0 ? "()->Obj.magic" : solParamsToToRecordWithSameNames(fnType.parameters)
        ) + "\n          })";
}

function getCallsInternal(fnType) {
  var match = getCallsHelper(fnType);
  return "\n  let " + match[1] + ": unit => array<\n  " + match[0] + "> = () => {\n      checkForExceptions(~functionName=\"" + fnType.name + "\")\n        internalRef.contents\n        ->Option.map(_r => {\n          let array = %raw(\"_r.smocked." + fnType.name + "Mock.calls\")\n          " + getCallsArrayContent(fnType) + "\n        })\n  ->Option.getExn\n  }\n  ";
}

function getCallsExternal(fnType) {
  var match = getCallsHelper(fnType);
  return "\n  let " + match[1] + ": t => array<\n  " + match[0] + "> = _r => {\n        let array = %raw(\"_r.smocked." + fnType.name + ".calls\")\n        " + getCallsArrayContent(fnType) + "\n  }\n  ";
}

function getRescriptParamsForReturn(params) {
  return Globals.commafiy(Belt_Array.mapWithIndex(params, (function (i, _p) {
                    return "_param" + String(i);
                  })));
}

function basicReturn(params) {
  return Globals.commafiy(Belt_Array.map(params, (function (t) {
                    return solASTTypeToRescriptType(t.type_);
                  })));
}

function rescriptReturnAnnotation(params, context) {
  if (context) {
    if (params.length !== 0) {
      return " (" + basicReturn(params) + ") => unit ";
    } else {
      return "unit => unit";
    }
  } else if (params.length !== 0) {
    return " (t, " + basicReturn(params) + ") => unit ";
  } else {
    return "t => unit";
  }
}

function getMockToReturnInternal(fn) {
  var params = getRescriptParamsForReturn(fn.returnValues);
  return "\n  let mock" + uppercaseFirstLetter(fn.name) + "ToReturn: " + rescriptReturnAnnotation(fn.returnValues, /* Internal */1) + " = (" + params + ") => {\n    checkForExceptions(~functionName=\"" + fn.name + "\")\n    let _ = internalRef.contents->Option.map(_r => {\n\n      " + (
          fn.returnValues.length !== 0 ? "let _ = %raw(\n        \"_r.smocked." + fn.name + "Mock.will.return.with([" + params + "])\"\n        )" : "let _ = %raw(\n        \"_r.smocked." + fn.name + "Mock.will.return()\"\n        )"
        ) + "\n    })\n  }\n  ";
}

function getMockToReturnExternal(fn) {
  var params = getRescriptParamsForReturn(fn.returnValues);
  return "\n  let mock" + uppercaseFirstLetter(fn.name) + "ToReturn: " + rescriptReturnAnnotation(fn.returnValues, /* External */0) + " = (_r " + (
          fn.returnValues.length !== 0 ? ", " + params + ")" : ")"
        ) + " => {\n\n      " + (
          fn.returnValues.length !== 0 ? "      let _ = %raw(\n        \"_r.smocked." + fn.name + ".will.return.with([" + params + "])\"\n        )" : "let _ = %raw(\n        \"_r.smocked." + fn.name + ".will.return()\"\n        )"
        ) + "\n  }\n  ";
}

function internalModule(functionsAndModifiers, contractName) {
  return "module InternalMock = {\n  let mockContractName = \"" + contractName + "ForInternalMocking\"\n  type t = {address: Ethers.ethAddress}\n\n  let internalRef: ref<option<t>> = ref(None)\n\n  let functionToNotMock: ref<string> = ref(\"\")\n\n  @module(\"@eth-optimism/smock\") external smock: 'a => Js.Promise.t<t> = \"smockit\"\n\n  let setup: " + contractName + ".t => JsPromise.t<ContractHelpers.transaction> = contract => {\n    ContractHelpers.deployContract0(mockContractName)\n    ->JsPromise.then(a => {\n      smock(a)\n    })\n    ->JsPromise.then(b => {\n      internalRef := Some(b)\n      contract->" + contractName + ".Exposed.setMocker(~mocker=(b->Obj.magic).address)\n    })\n  }\n\n  let setFunctionForUnitTesting = (contract, ~functionName) => {\n    functionToNotMock := functionName\n    contract->" + contractName + ".Exposed.setFunctionToNotMock(~functionToNotMock=functionName)\n  }\n\n  let setupFunctionForUnitTesting = (contract, ~functionName) => {\n    ContractHelpers.deployContract0(mockContractName)\n    ->JsPromise.then(a => {\n      smock(a)\n    })\n    ->JsPromise.then(b => {\n      internalRef := Some(b)\n      [\n        contract->" + contractName + ".Exposed.setMocker(~mocker=(b->Obj.magic).address),\n        contract->" + contractName + ".Exposed.setFunctionToNotMock(~functionToNotMock=functionName),\n      ]->JsPromise.all\n    })\n  }\n\n  exception MockingAFunctionThatYouShouldntBe\n\n  exception HaventSetupInternalMockingFor" + contractName + "\n\n  let checkForExceptions = (~functionName) => {\n    if functionToNotMock.contents == functionName {\n      raise(MockingAFunctionThatYouShouldntBe)\n    }\n    if internalRef.contents == None {\n      raise(HaventSetupInternalMockingFor" + contractName + ")\n    }\n  }\n\n  " + Globals.reduceStrArr(Belt_Array.map(functionsAndModifiers, (function (f) {
                    return getMockToReturnInternal(f) + "\n" + paramTypeForCalls(f) + "\n" + getCallsInternal(f);
                  }))) + "\n  }\n  ";
}

function externalModule(functions, contractName) {
  return "type t = {address: Ethers.ethAddress}\n\n@module(\"@eth-optimism/smock\") external make: " + contractName + ".t => Js.Promise.t<t> = \"smockit\"\n\nlet uninitializedValue: t = None->Obj.magic\n\n  " + Globals.reduceStrArr(Belt_Array.map(functions, (function (f) {
                    return getMockToReturnExternal(f) + "\n" + paramTypeForCalls(f) + "\n" + getCallsExternal(f);
                  }))) + "\n";
}

function entireModule(contractName, allFunctions, publicFunctions) {
  return externalModule(publicFunctions, contractName) + "\n\n" + internalModule(allFunctions, contractName);
}

var reduceStrArr = Globals.reduceStrArr;

var contains = Globals.contains;

var containsRe = Globals.containsRe;

var commafiy = Globals.commafiy;

var lowerCaseFirstLetter = Globals.lowerCaseFirstLetter;

var formatKeywords = Globals.formatKeywords;

exports.startsWith = startsWith;
exports.reduceStrArr = reduceStrArr;
exports.contains = contains;
exports.containsRe = containsRe;
exports.commafiy = commafiy;
exports.lowerCaseFirstLetter = lowerCaseFirstLetter;
exports.formatKeywords = formatKeywords;
exports.uppercaseFirstLetter = uppercaseFirstLetter;
exports.solASTTypeToRescriptType = solASTTypeToRescriptType;
exports.defaultParamName = defaultParamName;
exports.paramName = paramName;
exports.parametersToRecordType = parametersToRecordType;
exports.callTypeName = callTypeName;
exports.paramTypeForCalls = paramTypeForCalls;
exports.solParamsToToRecordWithSameNames = solParamsToToRecordWithSameNames;
exports.identifiersToTuple = identifiersToTuple;
exports.getRescriptParamsForCalls = getRescriptParamsForCalls;
exports.getCallsHelper = getCallsHelper;
exports.getCallsArrayContent = getCallsArrayContent;
exports.getCallsInternal = getCallsInternal;
exports.getCallsExternal = getCallsExternal;
exports.getRescriptParamsForReturn = getRescriptParamsForReturn;
exports.basicReturn = basicReturn;
exports.rescriptReturnAnnotation = rescriptReturnAnnotation;
exports.getMockToReturnInternal = getMockToReturnInternal;
exports.getMockToReturnExternal = getMockToReturnExternal;
exports.internalModule = internalModule;
exports.externalModule = externalModule;
exports.entireModule = entireModule;
/* No side effect */
