// Script still needs work, will break for constructors e.g.
// Also can't handle an edge case where you implement a an overriden pure
// function. Change the interface if possible.

// Will generate the files in this contract/contracts/testing/generated folder.

// Script is still pretty rough, will refine it as needed.

// It assumes a single contract definition in a file.

// TO ADD A FILE TO THIS: add filepath relative to ../contracts/contracts here. e.g. mocks/YieldManagerMock.sol
open Js.String2

let filesToMockInternally = ["LongShort.sol", "Staker.sol"]

exception ScriptDoesNotSupportReturnValues(string)

let defaultError = "This script currently only supports functions that return or receive as parameters uints, ints, bools, (nonpayable) addresses, contracts, structs, arrays or strings
          // NO MAPPINGS"
let {contains, containsRe, commafiy} = module(Globals)

let abisToMockExternally = [
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
  "OracleManagerMock",
]

let convertASTTypeToSolType = typeDescriptionStr => {
  switch typeDescriptionStr {
  | "bool"
  | "address" => typeDescriptionStr
  | "string" => "string calldata "
  | t if t->Globals.containsRe(%re("/\\[/g")) => t ++ " memory" // PARTIAL IMPLEMENTATION FOR ARRAYS
  | t if t->startsWith("uint") => typeDescriptionStr
  | t if t->startsWith("int") => typeDescriptionStr
  | t if t->startsWith("contract ") => typeDescriptionStr->replaceByRe(%re("/contract\s+/g"), "")
  | t if t->startsWith("enum ") => t->replaceByRe(%re("/enum\s+/g"), "")

  | t if t->startsWith("struct ") =>
    typeDescriptionStr->replaceByRe(%re("/struct\s+/g"), "") ++ " memory "
  | _ => {
      Js.log(typeDescriptionStr)
      raise(ScriptDoesNotSupportReturnValues(defaultError))
    }
  }
}

let nodeToTypedIdentifier: 'a => Globals.typedIdentifier = node => {
  name: node["name"],
  type_: node["typeDescriptions"]["typeString"],
  storageLocation: node["storageLocation"] == "storage" ? Storage : NotRelevant,
}

let functions = nodeStatements => {
  nodeStatements
  ->Array.keep(x => x["nodeType"] == #FunctionDefinition && !(x["name"] == "")) // ignore constructors
  ->Array.map(x => {
    let r: Globals.functionType = {
      name: x["name"],
      parameters: x["parameters"]["parameters"]->Array.map(y => y->nodeToTypedIdentifier),
      returnValues: x["returnParameters"]["parameters"]->Array.map(y => y->nodeToTypedIdentifier),
      visibility: x["visibility"] == "public" || x["visibility"] == "external" ? Public : Private,
    }
    r
  })
}

let modifiers = nodeStatements => {
  nodeStatements
  ->Array.keep(x => x["nodeType"] == #ModifierDefinition)
  ->Array.map(x => {
    let r: Globals.functionType = {
      name: x["name"],
      parameters: x["parameters"]["parameters"]->Array.map(y => y->nodeToTypedIdentifier),
      returnValues: [],
      visibility: x["visibility"] == "public" || x["visibility"] == "external" ? Public : Private,
    }
    r
  })
}

let lineCommentsRe = %re("/\\/\\/[^\\n]*\\n/g")
let blockCommentsRe = %re("/\\/\\*([^*]|[\\r\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+\\//g")
let getArtifact = %raw(`(fileNameWithoutExtension) => require("../../contracts/codegen/truffle/" + fileNameWithoutExtension + ".json")`)

let getAbi = %raw(`(fileNameWithoutExtension) => require("../../contracts/abis/" + fileNameWithoutExtension + ".json")`)

exception BadMatchingBlock
let rec matchingBlockEndIndex = (str, startIndex, count) => {
  let charr = str->charAt(startIndex)
  if charr == "}" && count == 1 {
    startIndex
  } else if charr == "}" && count > 1 {
    matchingBlockEndIndex(str, startIndex + 1, count - 1)
  } else if charr == "{" {
    matchingBlockEndIndex(str, startIndex + 1, count + 1)
  } else if charr != "{" && charr != "}" {
    matchingBlockEndIndex(str, startIndex + 1, count)
  } else {
    raise(BadMatchingBlock)
  }
}

let importRe = %re("/import[^;]+;/g")
let quotesRe = %re(`/"[\S\s]*"/`)

let rec resolveImportLocationRecursive = (array, _import) => {
  switch _import {
  | i if !(i->contains("/")) => array->Array.reduce("", (acc, curr) => acc ++ curr ++ "/") ++ i
  | i if i->startsWith("../") =>
    resolveImportLocationRecursive(
      array->Array.reverse->Array.sliceToEnd(1)->Array.reverse,
      i->substringToEnd(~from=3),
    )
  | i if i->startsWith("./") => resolveImportLocationRecursive(array, i->substringToEnd(~from=2))
  | i => {
      let firstSlashIndex = i->indexOf("/")
      resolveImportLocationRecursive(
        array->Array.concat([i->substring(~from=0, ~to_=firstSlashIndex)]),
        i->substringToEnd(~from=firstSlashIndex + 1),
      )
    }
  }
}

let reduceStrArr = arr => arr->Array.reduce("", (acc, curr) => acc ++ curr)

let parseAbiTypes = types =>
  types->Array.map(i => {
    let r: Globals.typedIdentifier = {
      storageLocation: NotRelevant,
      type_: i["internalType"],
      name: i["name"],
    }
    r
  })

let parseAbi = abi =>
  abi
  ->Array.keep(n => n["type"] == "function")
  ->Array.map(n => {
    let r: Globals.functionType = {
      name: n["name"],
      visibility: Public,
      parameters: n["inputs"]->parseAbiTypes,
      returnValues: n["outputs"]->parseAbiTypes,
    }
    r
  })

let bindingsDict: HashMap.String.t<string> = HashMap.String.make(~hintSize=10)

abisToMockExternally->Array.forEach(contractName => {
  let abi = contractName->getAbi
  let functions = abi->parseAbi
  bindingsDict->HashMap.String.set(
    contractName,
    SmockableGen.externalModule(functions, ~contractName),
  )
})

filesToMockInternally->Array.forEach(filePath => {
  let filePathSplit = filePath->split("/")
  let fileName = filePathSplit->Array.getExn(filePathSplit->Array.length - 1)

  let fileNameSplit = fileName->split(".")

  let fileNameWithoutExtension =
    fileNameSplit
    ->Array.slice(
      ~offset=0,
      ~len=if fileNameSplit->Array.length > 1 {
        fileNameSplit->Array.length - 1
      } else {
        fileNameSplit->Array.length
      },
    )
    ->reduceStrArr

  let typeDefContainsFileName = `\\\s${fileNameWithoutExtension}\\\.`->Js.Re.fromString
  let actionOnFileNameTypeDefs = (action, type_) =>
    if type_->containsRe(typeDefContainsFileName) {
      type_->action
    } else {
      type_
    }

  let replaceFileNameTypeDefsWithMockableTypeDefs = actionOnFileNameTypeDefs(type_ =>
    type_->replace(`${fileNameWithoutExtension}.`, `${fileNameWithoutExtension}Mockable.`)
  )
  let removeFileNameFromTypeDefs = actionOnFileNameTypeDefs(type_ =>
    type_->replaceByRe(typeDefContainsFileName, " ")
  )
  let sol = ref(("../contracts/contracts/" ++ filePath)->Node.Fs.readFileAsUtf8Sync)

  sol := sol.contents->replaceByRe(%re("/\s+pure\s+/g"), " view ")

  let lineCommentsMatch =
    sol.contents
    ->match_(lineCommentsRe)
    ->Option.map(i => i->Array.keep(x => !(x->contains("SPDX-License-Identifier"))))

  let _ = lineCommentsMatch->Option.map(l =>
    l->Array.forEach(i => {
      sol := sol.contents->replace(i, "")
    })
  )

  sol := sol.contents->replaceByRe(blockCommentsRe, "\n")

  let artifact = getArtifact(fileNameWithoutExtension)

  let contractDefinition =
    artifact["ast"]["nodes"]
    ->Array.keep(x => x["nodeType"] == "ContractDefinition")
    ->Array.getExn(0)

  let mockLogger = ref("")

  functions(contractDefinition["nodes"])->Array.forEach(x => {
    let indexOfOldFunctionDec = sol.contents->indexOf("function " ++ x.name ++ "(")

    let indexOfOldFunctionBodyStart = sol.contents->indexOfFrom("{", indexOfOldFunctionDec)

    let solPrefix = sol.contents->substring(~from=0, ~to_=indexOfOldFunctionBodyStart + 1)

    let solSuffix = sol.contents->substringToEnd(~from=indexOfOldFunctionBodyStart + 1)

    let storageParameters = x.parameters->Array.keep(x => x.storageLocation == Storage)

    let mockerParameterCalls =
      x.parameters
      ->Array.map(x => {
        x.storageLocation == Storage ? x.name ++ "_temp1" : x.name
      })
      ->commafiy

    let mockerArguments =
      x.parameters
      ->Array.map(x =>
        x.type_->replaceFileNameTypeDefsWithMockableTypeDefs->convertASTTypeToSolType
      )
      ->commafiy

    sol :=
      solPrefix ++
      `
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("${x.name}"))){
      ${storageParameters
        ->Array.map(x =>
          `
          ${x.type_
            ->removeFileNameFromTypeDefs
            ->convertASTTypeToSolType} ${x.name}_temp1 = ${x.name};
        `
        )
        ->reduceStrArr}
      return mocker.${x.name}Mock(${mockerParameterCalls});
    }
  ` ++
      solSuffix

    mockLogger :=
      mockLogger.contents ++
      ` 
    function ${x.name}Mock(${mockerArguments}) public pure ${switch x.returnValues {
        | arr if arr->Array.length > 0 =>
          `returns (${arr
            ->Array.map(x => x.type_->convertASTTypeToSolType ++ " " ++ x.name)
            ->commafiy})`
        | _ => ""
        }}{
      return (${x.returnValues
        ->Array.map(y => "abi.decode(\"\",(" ++ y.type_->convertASTTypeToSolType ++ "))")
        ->commafiy});
    }
    `
  })

  modifiers(contractDefinition["nodes"])->Array.forEach(x => {
    let indexOfOldFunctionDec = sol.contents->indexOf("modifier " ++ x.name)

    let indexOfOldFunctionBodyStart = sol.contents->indexOfFrom("{", indexOfOldFunctionDec)

    let indexOfOldFunctionBodyEnd =
      sol.contents->matchingBlockEndIndex(indexOfOldFunctionBodyStart + 1, 1)

    let functionBody =
      sol.contents->substring(~from=indexOfOldFunctionBodyStart + 1, ~to_=indexOfOldFunctionBodyEnd)

    let mockerArguments =
      x.parameters
      ->Array.map(x =>
        x.type_->replaceFileNameTypeDefsWithMockableTypeDefs->convertASTTypeToSolType
      )
      ->commafiy

    let storageParameters = x.parameters->Array.keep(x => x.storageLocation == Storage)

    let solPrefix = sol.contents->substring(~from=0, ~to_=indexOfOldFunctionBodyStart + 1)

    let solSuffix = sol.contents->substringToEnd(~from=indexOfOldFunctionBodyEnd)
    let mockerParameterCalls =
      x.parameters
      ->Array.map(x => {
        x.storageLocation == Storage ? x.name ++ "_temp1" : x.name
      })
      ->commafiy
    sol :=
      solPrefix ++
      `
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("${x.name}"))){
        ${storageParameters
        ->Array.map(x =>
          `
          ${x.type_
            ->removeFileNameFromTypeDefs
            ->convertASTTypeToSolType} ${x.name}_temp1 = ${x.name};
        `
        )
        ->reduceStrArr}
      mocker.${x.name}Mock(${mockerParameterCalls});
      _;
    } else {
      ${functionBody}
    }
  ` ++
      solSuffix

    mockLogger :=
      mockLogger.contents ++
      ` 
    function ${x.name}Mock(${mockerArguments}) public pure {
      return; 
    }
    `
  })

  let importsInFile = sol.contents->match_(importRe)

  let importsInFileReplaced = importsInFile->Option.map(i =>
    i->Array.map(x => {
      if !(x->contains("..")) && !(x->contains("./")) {
        x
      } else {
        let impStatement = x->match_(quotesRe)->Option.getExn->Array.getExn(0)
        let impStatement = impStatement->substring(~from=1, ~to_=impStatement->String.length)
        let initialDirStructure = filePath->split("/")
        let initialDirStructure =
          initialDirStructure->Array.slice(~offset=0, ~len=initialDirStructure->Array.length - 1)
        x->replace(
          impStatement,
          "../../" ++ resolveImportLocationRecursive(initialDirStructure, impStatement),
        )
      }
    })
  )

  let _ = importsInFile->Option.map(i =>
    i->Array.forEachWithIndex((index, imp) => {
      sol :=
        sol.contents->replace(imp, importsInFileReplaced->Option.getUnsafe->Array.getUnsafe(index))
    })
  )

  mockLogger :=
    "// SPDX-License-Identifier: BUSL-1.1 \n pragma solidity 0.8.3;\n" ++
    `import "./${fileNameWithoutExtension}Mockable.sol";
` ++
    importsInFileReplaced->Option.mapWithDefault("", i =>
      i->Array.map(z => z ++ "\n")->reduceStrArr
    ) ++
    `contract ${fileNameWithoutExtension}ForInternalMocking {` ++
    mockLogger.contents ++ `}`

  let indexOfContractDef = sol.contents->indexOf("contract ")

  let indexOfContractBlock = sol.contents->indexOfFrom("{", indexOfContractDef)

  let indexOfContractName = sol.contents->indexOfFrom(fileNameWithoutExtension, indexOfContractDef)

  let prefix = sol.contents->substring(~from=0, ~to_=indexOfContractDef)
  let intermediate1 = sol.contents->substring(~from=indexOfContractDef, ~to_=indexOfContractName)
  let intermediate2 =
    sol.contents->substring(
      ~from=indexOfContractName + fileNameWithoutExtension->String.length,
      ~to_=indexOfContractBlock + 1,
    )
  let suffix = sol.contents->substringToEnd(~from=indexOfContractBlock + 1)

  sol :=
    prefix ++
    "\n" ++
    `import "./${fileNameWithoutExtension}ForInternalMocking.sol";` ++
    "\n" ++
    intermediate1 ++
    fileNameWithoutExtension ++
    "Mockable" ++
    intermediate2 ++
    `
  ${fileNameWithoutExtension}ForInternalMocking mocker;
  bool shouldUseMock;
  string functionToNotMock;

  function setMocker(${fileNameWithoutExtension}ForInternalMocking _mocker) external {
    mocker = _mocker;
    shouldUseMock = true;
  }

  function setFunctionToNotMock(string calldata _functionToNotMock) external {
    functionToNotMock = _functionToNotMock;
  }

` ++
    suffix

  Node.Fs.writeFileAsUtf8Sync(
    `../contracts/contracts/testing/generated/${fileNameWithoutExtension}Mockable.sol`,
    sol.contents,
  )
  Node.Fs.writeFileAsUtf8Sync(
    `../contracts/contracts/testing/generated/${fileNameWithoutExtension}ForInternalMocking.sol`,
    mockLogger.contents,
  )

  let existingModuleDef =
    abisToMockExternally->Array.some(x => x == fileNameWithoutExtension)
      ? bindingsDict->HashMap.String.get(fileNameWithoutExtension)->Option.getExn
      : ""

  bindingsDict->HashMap.String.set(
    fileNameWithoutExtension,
    existingModuleDef ++
    "\n\n" ++
    functions(contractDefinition["nodes"])
    ->Array.concat(modifiers(contractDefinition["nodes"]))
    ->SmockableGen.internalModule(~contractName=fileNameWithoutExtension),
  )
})

bindingsDict->HashMap.String.forEach((key, val) => {
  Node.Fs.writeFileAsUtf8Sync(`../contracts/test-waffle/library/smock/${key}Smocked.res`, val)
})
