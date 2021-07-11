// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Fs = require("fs");
var Curry = require("rescript/lib/js/curry.js");
var Globals = require("./library/Globals.bs.js");
var Belt_Array = require("rescript/lib/js/belt_Array.js");
var Belt_Option = require("rescript/lib/js/belt_Option.js");
var Caml_option = require("rescript/lib/js/caml_option.js");
var SmockableGen = require("./library/SmockableGen.bs.js");
var Caml_exceptions = require("rescript/lib/js/caml_exceptions.js");
var Belt_HashMapString = require("rescript/lib/js/belt_HashMapString.js");
var MockablesGenTemplates = require("./templates/MockablesGenTemplates.bs.js");

var filesToMockInternally = [
  "LongShort.sol",
  "Staker.sol"
];

var ScriptDoesNotSupportReturnValues = /* @__PURE__ */Caml_exceptions.create("MockablesGen.ScriptDoesNotSupportReturnValues");

var defaultError = "This script currently only supports functions that return or receive as parameters uints, ints, bools, (nonpayable) addresses, contracts, structs, arrays or strings\n          // NO MAPPINGS";

var abisToMockExternally = [
  "ERC20Mock",
  "YieldManagerMock",
  "LongShort",
  "SyntheticToken",
  "YieldManagerAave",
  "FloatCapital_v0",
  "TokenFactory",
  "FloatToken",
  "Staker",
  "Treasury_v0",
  "OracleManagerChainlink",
  "OracleManagerMock"
];

function convertASTTypeToSolType(typeDescriptionStr) {
  switch (typeDescriptionStr) {
    case "address" :
    case "bool" :
        return typeDescriptionStr;
    case "string" :
        return "string calldata ";
    default:
      if (Globals.containsRe(typeDescriptionStr, /\[/g)) {
        return typeDescriptionStr + " memory";
      }
      if (typeDescriptionStr.startsWith("uint")) {
        return typeDescriptionStr;
      }
      if (typeDescriptionStr.startsWith("int")) {
        return typeDescriptionStr;
      }
      if (typeDescriptionStr.startsWith("contract ")) {
        return typeDescriptionStr.replace(/contract\s+/g, "");
      }
      if (typeDescriptionStr.startsWith("enum ")) {
        return typeDescriptionStr.replace(/enum\s+/g, "");
      }
      if (typeDescriptionStr.startsWith("struct ")) {
        return typeDescriptionStr.replace(/struct\s+/g, "") + " memory ";
      }
      throw {
            RE_EXN_ID: ScriptDoesNotSupportReturnValues,
            _1: defaultError,
            Error: new Error()
          };
  }
}

function nodeToTypedIdentifier(node) {
  return {
          name: node.name,
          type_: node.typeDescriptions.typeString,
          storageLocation: node.storageLocation === "storage" ? /* Storage */0 : /* NotRelevant */1
        };
}

function functions(nodeStatements) {
  return Belt_Array.map(Belt_Array.keep(nodeStatements, (function (x) {
                    if (x.nodeType === "FunctionDefinition") {
                      return x.name !== "";
                    } else {
                      return false;
                    }
                  })), (function (x) {
                return {
                        name: x.name,
                        parameters: Belt_Array.map(x.parameters.parameters, nodeToTypedIdentifier),
                        returnValues: Belt_Array.map(x.returnParameters.parameters, nodeToTypedIdentifier),
                        visibility: x.visibility === "public" || x.visibility === "external" ? /* Public */0 : /* Private */1
                      };
              }));
}

function modifiers(nodeStatements) {
  return Belt_Array.map(Belt_Array.keep(nodeStatements, (function (x) {
                    return x.nodeType === "ModifierDefinition";
                  })), (function (x) {
                return {
                        name: x.name,
                        parameters: Belt_Array.map(x.parameters.parameters, nodeToTypedIdentifier),
                        returnValues: [],
                        visibility: x.visibility === "public" || x.visibility === "external" ? /* Public */0 : /* Private */1
                      };
              }));
}

var lineCommentsRe = /\/\/[^\n]*\n/g;

var blockCommentsRe = /\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\//g;

function getContractArtifact(fileNameWithoutExtension) {
  return require("../../contracts/codegen/truffle/" + fileNameWithoutExtension + ".json");
}

var BadMatchingBlock = /* @__PURE__ */Caml_exceptions.create("MockablesGen.BadMatchingBlock");

function matchingBlockEndIndex(str, _startIndex, _count) {
  while(true) {
    var count = _count;
    var startIndex = _startIndex;
    var charr = str.charAt(startIndex);
    if (charr === "}" && count === 1) {
      return startIndex;
    }
    if (charr === "}" && count > 1) {
      _count = count - 1 | 0;
      _startIndex = startIndex + 1 | 0;
      continue ;
    }
    if (charr === "{") {
      _count = count + 1 | 0;
      _startIndex = startIndex + 1 | 0;
      continue ;
    }
    if (charr !== "{" && charr !== "}") {
      _startIndex = startIndex + 1 | 0;
      continue ;
    }
    throw {
          RE_EXN_ID: BadMatchingBlock,
          Error: new Error()
        };
  };
}

var importRe = /import[^;]+;/g;

var quotesRe = /"[\S\s]*"/;

function resolveImportLocationRecursive(_array, __import) {
  while(true) {
    var _import = __import;
    var array = _array;
    if (!Globals.contains(_import, "/")) {
      return Belt_Array.reduce(array, "", (function (acc, curr) {
                    return acc + curr + "/";
                  })) + _import;
    }
    if (_import.startsWith("../")) {
      __import = _import.substring(3);
      _array = Belt_Array.reverse(Belt_Array.sliceToEnd(Belt_Array.reverse(array), 1));
      continue ;
    }
    if (_import.startsWith("./")) {
      __import = _import.substring(2);
      continue ;
    }
    var firstSlashIndex = _import.indexOf("/");
    __import = _import.substring(firstSlashIndex + 1 | 0);
    _array = Belt_Array.concat(array, [_import.substring(0, firstSlashIndex)]);
    continue ;
  };
}

function reduceStrArr(arr) {
  return Belt_Array.reduce(arr, "", (function (acc, curr) {
                return acc + curr;
              }));
}

function parseAbiTypes(types) {
  return Belt_Array.map(types, (function (i) {
                return {
                        name: i.name,
                        type_: i.internalType,
                        storageLocation: /* NotRelevant */1
                      };
              }));
}

function parseAbi(abi) {
  return Belt_Array.map(Belt_Array.keep(abi, (function (n) {
                    return n.type === "function";
                  })), (function (n) {
                return {
                        name: n.name,
                        parameters: parseAbiTypes(n.inputs),
                        returnValues: parseAbiTypes(n.outputs),
                        visibility: /* Public */0
                      };
              }));
}

var bindingsDict = Belt_HashMapString.make(10);

Belt_Array.forEach(abisToMockExternally, (function (contractName) {
        var abi = getContractArtifact(contractName).abi;
        var functions = parseAbi(abi);
        return Belt_HashMapString.set(bindingsDict, contractName, SmockableGen.externalModule(functions, contractName));
      }));

Belt_Array.forEach(filesToMockInternally, (function (filePath) {
        var filePathSplit = filePath.split("/");
        var fileName = Belt_Array.getExn(filePathSplit, filePathSplit.length - 1 | 0);
        var fileNameSplit = fileName.split(".");
        var fileNameWithoutExtension = reduceStrArr(Belt_Array.slice(fileNameSplit, 0, fileNameSplit.length > 1 ? fileNameSplit.length - 1 | 0 : fileNameSplit.length));
        var typeDefContainsFileName = new RegExp("\\s" + fileNameWithoutExtension + "\\.");
        var actionOnFileNameTypeDefs = function (action, type_) {
          if (Globals.containsRe(type_, typeDefContainsFileName)) {
            return Curry._1(action, type_);
          } else {
            return type_;
          }
        };
        var replaceFileNameTypeDefsWithMockableTypeDefs = function (param) {
          return actionOnFileNameTypeDefs((function (type_) {
                        return type_.replace(fileNameWithoutExtension + ".", fileNameWithoutExtension + "Mockable.");
                      }), param);
        };
        var removeFileNameFromTypeDefs = function (param) {
          return actionOnFileNameTypeDefs((function (type_) {
                        return type_.replace(typeDefContainsFileName, " ");
                      }), param);
        };
        var sol = {
          contents: Fs.readFileSync("../contracts/contracts/" + filePath, "utf8")
        };
        sol.contents = sol.contents.replace(/\s+pure\s+/g, " view ");
        var lineCommentsMatch = Belt_Option.map(Caml_option.null_to_opt(sol.contents.match(lineCommentsRe)), (function (i) {
                return Belt_Array.keep(i, (function (x) {
                              return !Globals.contains(x, "SPDX-License-Identifier");
                            }));
              }));
        Belt_Option.map(lineCommentsMatch, (function (l) {
                return Belt_Array.forEach(l, (function (i) {
                              sol.contents = sol.contents.replace(i, "");
                              
                            }));
              }));
        sol.contents = sol.contents.replace(blockCommentsRe, "\n");
        var artifact = getContractArtifact(fileNameWithoutExtension);
        var contractDefinition = Belt_Array.getExn(Belt_Array.keep(artifact.ast.nodes, (function (x) {
                    return x.nodeType === "ContractDefinition";
                  })), 0);
        var mockLogger = {
          contents: ""
        };
        Belt_Array.forEach(functions(contractDefinition.nodes), (function (x) {
                var indexOfOldFunctionDec = sol.contents.indexOf("function " + x.name + "(");
                var indexOfOldFunctionBodyStart = sol.contents.indexOf("{", indexOfOldFunctionDec);
                var solPrefix = sol.contents.substring(0, indexOfOldFunctionBodyStart + 1 | 0);
                var solSuffix = sol.contents.substring(indexOfOldFunctionBodyStart + 1 | 0);
                var storageParameters = Belt_Array.keep(x.parameters, (function (x) {
                        return x.storageLocation === /* Storage */0;
                      }));
                var mockerParameterCalls = Globals.commafiy(Belt_Array.map(x.parameters, (function (x) {
                            if (x.storageLocation === /* Storage */0) {
                              return x.name + "_temp1";
                            } else {
                              return x.name;
                            }
                          })));
                var mockerArguments = Globals.commafiy(Belt_Array.map(x.parameters, (function (x) {
                            return convertASTTypeToSolType(replaceFileNameTypeDefsWithMockableTypeDefs(x.type_));
                          })));
                var storageParametersFormatted = reduceStrArr(Belt_Array.map(storageParameters, (function (x) {
                            return "\n          " + convertASTTypeToSolType(removeFileNameFromTypeDefs(x.type_)) + " " + x.name + "_temp1 = " + x.name + ";\n        ";
                          })));
                sol.contents = solPrefix + MockablesGenTemplates.mockableFunctionBody(x.name, storageParametersFormatted, mockerParameterCalls) + solSuffix;
                var arr = x.returnValues;
                var mockerReturnValues = arr.length !== 0 ? "returns (" + Globals.commafiy(Belt_Array.map(arr, (function (x) {
                              return convertASTTypeToSolType(x.type_) + " " + x.name;
                            }))) + ")" : "";
                var mockerReturn = Globals.commafiy(Belt_Array.map(x.returnValues, (function (y) {
                            return "abi.decode(\"\",(" + convertASTTypeToSolType(y.type_) + "))";
                          })));
                mockLogger.contents = mockLogger.contents + MockablesGenTemplates.externalMockerFunctionBody(x.name, mockerArguments, mockerReturnValues, mockerReturn);
                
              }));
        Belt_Array.forEach(modifiers(contractDefinition.nodes), (function (x) {
                var indexOfOldFunctionDec = sol.contents.indexOf("modifier " + x.name);
                var indexOfOldFunctionBodyStart = sol.contents.indexOf("{", indexOfOldFunctionDec);
                var indexOfOldFunctionBodyEnd = matchingBlockEndIndex(sol.contents, indexOfOldFunctionBodyStart + 1 | 0, 1);
                var functionBody = sol.contents.substring(indexOfOldFunctionBodyStart + 1 | 0, indexOfOldFunctionBodyEnd);
                var mockerArguments = Globals.commafiy(Belt_Array.map(x.parameters, (function (x) {
                            return convertASTTypeToSolType(replaceFileNameTypeDefsWithMockableTypeDefs(x.type_));
                          })));
                var storageParameters = Belt_Array.keep(x.parameters, (function (x) {
                        return x.storageLocation === /* Storage */0;
                      }));
                var solPrefix = sol.contents.substring(0, indexOfOldFunctionBodyStart + 1 | 0);
                var solSuffix = sol.contents.substring(indexOfOldFunctionBodyEnd);
                var mockerParameterCalls = Globals.commafiy(Belt_Array.map(x.parameters, (function (x) {
                            if (x.storageLocation === /* Storage */0) {
                              return x.name + "_temp1";
                            } else {
                              return x.name;
                            }
                          })));
                var storageParameters$1 = reduceStrArr(Belt_Array.map(storageParameters, (function (x) {
                            return "\n            " + convertASTTypeToSolType(removeFileNameFromTypeDefs(x.type_)) + " " + x.name + "_temp1 = " + x.name + ";\n          ";
                          })));
                sol.contents = solPrefix + MockablesGenTemplates.mockableModifierBody(x.name, storageParameters$1, mockerParameterCalls, functionBody) + solSuffix;
                mockLogger.contents = mockLogger.contents + MockablesGenTemplates.externalMockerModifierBody(x.name, mockerArguments);
                
              }));
        var importsInFile = sol.contents.match(importRe);
        var importsInFile$1 = importsInFile === null ? undefined : Caml_option.some(importsInFile);
        var importsInFileReplaced = Belt_Option.map(importsInFile$1, (function (i) {
                return Belt_Array.map(i, (function (x) {
                              if (!Globals.contains(x, "..") && !Globals.contains(x, "./")) {
                                return x;
                              }
                              var impStatement = Belt_Array.getExn(Belt_Option.getExn(Caml_option.null_to_opt(x.match(quotesRe))), 0);
                              var impStatement$1 = impStatement.substring(1, impStatement.length);
                              var initialDirStructure = filePath.split("/");
                              var initialDirStructure$1 = Belt_Array.slice(initialDirStructure, 0, initialDirStructure.length - 1 | 0);
                              return x.replace(impStatement$1, "../../" + resolveImportLocationRecursive(initialDirStructure$1, impStatement$1));
                            }));
              }));
        Belt_Option.map(importsInFile$1, (function (i) {
                return Belt_Array.forEachWithIndex(i, (function (index, imp) {
                              sol.contents = sol.contents.replace(imp, importsInFileReplaced[index]);
                              
                            }));
              }));
        var parentImports = Belt_Option.mapWithDefault(importsInFileReplaced, "", (function (i) {
                return reduceStrArr(Belt_Array.map(i, (function (z) {
                                  return z + "\n";
                                })));
              }));
        mockLogger.contents = MockablesGenTemplates.internalMockingFileTemplate(fileNameWithoutExtension, parentImports, mockLogger.contents);
        var indexOfContractDef = sol.contents.indexOf("contract ");
        var indexOfContractBlock = sol.contents.indexOf("{", indexOfContractDef);
        var indexOfContractName = sol.contents.indexOf(fileNameWithoutExtension, indexOfContractDef);
        var prefix = sol.contents.substring(0, indexOfContractDef);
        var modifiersAndOpener = sol.contents.substring(indexOfContractName + fileNameWithoutExtension.length | 0, indexOfContractBlock + 1 | 0);
        var suffix = sol.contents.substring(indexOfContractBlock + 1 | 0);
        sol.contents = MockablesGenTemplates.mockingFileTemplate(prefix, fileNameWithoutExtension, modifiersAndOpener, suffix);
        Fs.writeFileSync("../contracts/contracts/testing/generated/" + fileNameWithoutExtension + "Mockable.sol", sol.contents, "utf8");
        Fs.writeFileSync("../contracts/contracts/testing/generated/" + fileNameWithoutExtension + "ForInternalMocking.sol", mockLogger.contents, "utf8");
        var existingModuleDef = Belt_Array.some(abisToMockExternally, (function (x) {
                return x === fileNameWithoutExtension;
              })) ? Belt_Option.getExn(Belt_HashMapString.get(bindingsDict, fileNameWithoutExtension)) : "";
        return Belt_HashMapString.set(bindingsDict, fileNameWithoutExtension, existingModuleDef + "\n\n" + SmockableGen.internalModule(Belt_Array.concat(functions(contractDefinition.nodes), modifiers(contractDefinition.nodes)), fileNameWithoutExtension));
      }));

Belt_HashMapString.forEach(bindingsDict, (function (key, val) {
        Fs.writeFileSync("../contracts/test-waffle/library/smock/" + key + "Smocked.res", val, "utf8");
        
      }));

var contains = Globals.contains;

var containsRe = Globals.containsRe;

var commafiy = Globals.commafiy;

exports.filesToMockInternally = filesToMockInternally;
exports.ScriptDoesNotSupportReturnValues = ScriptDoesNotSupportReturnValues;
exports.defaultError = defaultError;
exports.contains = contains;
exports.containsRe = containsRe;
exports.commafiy = commafiy;
exports.abisToMockExternally = abisToMockExternally;
exports.convertASTTypeToSolType = convertASTTypeToSolType;
exports.nodeToTypedIdentifier = nodeToTypedIdentifier;
exports.functions = functions;
exports.modifiers = modifiers;
exports.lineCommentsRe = lineCommentsRe;
exports.blockCommentsRe = blockCommentsRe;
exports.getContractArtifact = getContractArtifact;
exports.BadMatchingBlock = BadMatchingBlock;
exports.matchingBlockEndIndex = matchingBlockEndIndex;
exports.importRe = importRe;
exports.quotesRe = quotesRe;
exports.resolveImportLocationRecursive = resolveImportLocationRecursive;
exports.reduceStrArr = reduceStrArr;
exports.parseAbiTypes = parseAbiTypes;
exports.parseAbi = parseAbi;
exports.bindingsDict = bindingsDict;
/* bindingsDict Not a pure module */
