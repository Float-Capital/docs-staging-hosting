// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Js_dict = require("rescript/lib/js/js_dict.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");

var files = Fs.readdirSync("../contracts/abis");

function getMmoduleName(fileName) {
  return fileName.split(".")[0];
}

function getRescriptType(typeString) {
  if (typeString === "uint32") {
    return "int";
  } else if (typeString === "string") {
    return "string";
  } else if (typeString === "address") {
    return "address";
  } else if (typeString === "uint256") {
    return "bn";
  } else {
    console.log("Please handle all types - " + typeString + " isn't handled by this script.");
    return "unkownType";
  }
}

function typeInputs(inputs) {
  var paramsString = {
    contents: ""
  };
  Belt_Array.map(inputs, (function (input) {
          var paramType = input.type;
          var paramName = input.name;
          var rescriptType = getRescriptType(paramType);
          paramsString.contents = paramsString.contents + ("\n~" + paramName + ": " + rescriptType + ",");
          
        }));
  return paramsString.contents;
}

function typeOutputs(outputs, functionName) {
  var paramsString = {
    contents: ""
  };
  if (outputs.length > 1) {
    Belt_Array.mapWithIndex(outputs, (function (index, output) {
            var paramType = output.type;
            var paramName = Belt_Option.getWithDefault(output.name, "param" + String(index));
            if (paramName === "") {
              console.log("name is zero");
            }
            var rescriptType = getRescriptType(paramType);
            paramsString.contents = paramsString.contents + ("\n" + paramName + ": " + rescriptType + ",");
            
          }));
    return "type " + functionName + "Return = {" + paramsString.contents + "\n    }";
  }
  console.log("IN THE ELSE!!!!!");
  var rescriptType = getRescriptType(outputs[0].type);
  return "type " + functionName + "Return = " + rescriptType;
}

var moduleDictionary = {};

Belt_Array.map(files, (function (abiFileName) {
        var abiFileContents = Fs.readFileSync("../contracts/abis/" + abiFileName, "utf8");
        var abiFileObject = JSON.parse(abiFileContents);
        var moduleContents = {
          contents: ""
        };
        var moduleName = getMmoduleName(abiFileName);
        Belt_Array.map(abiFileObject, (function (abiItem) {
                var name = abiItem.name;
                var itemType = abiItem.type;
                if (itemType === "event") {
                  console.log("we have an event - " + name);
                  return ;
                }
                if (itemType !== "function") {
                  if (itemType === "constructor") {
                    console.log("We have a CONSTRUCTOR - ");
                  } else {
                    console.log("We have an unhandled type - " + name + " " + itemType, abiItem);
                  }
                  return ;
                }
                console.log("we have an FUNCTION - " + name);
                var inputs = abiItem.inputs;
                var outputs = abiItem.outputs;
                var stateMutability = abiItem.stateMutability;
                var typeNames = typeInputs(inputs);
                if (!(stateMutability === "view" || stateMutability === "pure")) {
                  moduleContents.contents = moduleContents.contents + ("\n  @send\n  external userLazyActions: (\n    t," + typeNames + "\n  ) => JsPromise.t<transaction> = \"" + name + "\"\n");
                  return ;
                }
                var returnType = name + "Return";
                var returnTypeDefinition = typeOutputs(outputs, name);
                moduleContents.contents = moduleContents.contents + ("\n  " + returnTypeDefinition + "\n  @send\n  external userLazyActions: (\n    t," + typeNames + "\n  ) => JsPromise.t<" + returnType + "> = \"" + name + "\"\n");
                
              }));
        moduleDictionary[moduleName] = moduleContents.contents;
        
      }));

var _writeFiles = Belt_Array.map(Js_dict.entries(moduleDictionary), (function (param) {
        var moduleName = param[0];
        if (!moduleName.endsWith("Exposed")) {
          Fs.writeFileSync("../contracts/test-waffle/library/contracts/" + moduleName + ".res", "module " + moduleName + " = {\n" + param[1] + "\n}", "utf8");
          return ;
        }
        
      }));

exports.files = files;
exports.getMmoduleName = getMmoduleName;
exports.getRescriptType = getRescriptType;
exports.typeInputs = typeInputs;
exports.typeOutputs = typeOutputs;
exports.moduleDictionary = moduleDictionary;
exports._writeFiles = _writeFiles;
/* files Not a pure module */
