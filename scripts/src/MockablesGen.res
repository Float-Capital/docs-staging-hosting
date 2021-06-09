// Script still needs work, will break for constructors e.g.
// Also can't handle an edge case where you implement a an overriden pure
// function. Change the interface if possible.

// Will generate the files in this contract/contracts/testing/generated folder.

// Script is still pretty rough, will refine it as needed.

// TO ADD A FILE TO THIS: add filepath relative to ../contracts/contracts here. e.g. mocks/YieldManagerMock.sol
let filesToMock = ["LongShort.sol"]

type modifierInvocation = {name: string}

type typedIdentifier = {
  name: string,
  type_: string,
}
type functionType = {
  name: string,
  parameters: array<string>,
  returnValues: array<typedIdentifier>,
}

exception ScriptDoesNotSupportReturnValues(string)

let convertASTTypeToSolType = typeDescriptionStr => {
  switch typeDescriptionStr {
  | "bool"
  | "address"
  | "string" => typeDescriptionStr
  | t if t->Js.String2.startsWith("uint") => typeDescriptionStr
  | t if t->Js.String2.startsWith("int") => typeDescriptionStr
  | t if t->Js.String2.startsWith("contract ") =>
    typeDescriptionStr->Js.String2.replaceByRe(%re("/contract\s+/g"), "")
  | t if t->Js.String2.startsWith("enum") =>
    typeDescriptionStr->Js.String2.replaceByRe(%re("/enum\s+/g"), "")
  | _ => {
      Js.log(typeDescriptionStr)
      raise(
        ScriptDoesNotSupportReturnValues(
          "This script currently only supports functions that return uints, ints, bools, (nonpayable) addresses, contracts, or strings",
        ),
      )
    }
  }
}

let convertSolTypeToReturnsType = type_ => {
  switch type_ {
  | "bool"
  | "address" => type_
  | t if t->Js.String2.startsWith("uint") => type_
  | t if t->Js.String2.startsWith("int") => type_
  | "string" => "string calldata"
  | _ => {
      Js.log(`WARNING: Treating type ${type_} as contract type`)
      type_
    }
  }
}

let functions = nodeStatements => {
  nodeStatements
  ->Array.keep(x => x["nodeType"] == #FunctionDefinition) // ignore constructors
  ->Array.map(x => {
    name: x["name"],
    parameters: x["parameters"]["parameters"]->Array.map(y => y["name"]),
    returnValues: x["returnParameters"]["parameters"]->Array.map(y => {
      name: y["name"],
      type_: y["typeDescriptions"]["typeString"]->convertASTTypeToSolType,
    }),
  })
}

let commafiy = strings => {
  let parameterCalls = strings->Array.reduce("", (acc, curr) => {
    acc ++ curr ++ ","
  })
  if parameterCalls->String.length > 0 {
    parameterCalls->Js.String2.substring(~from=0, ~to_=parameterCalls->String.length - 1)
  } else {
    parameterCalls
  }
}

let modifiers = nodeStatements => {
  nodeStatements
  ->Array.keep(x => x["nodeType"] == #ModifierDefinition)
  ->Array.map(x => {
    name: x["name"],
    parameters: x["parameters"]["parameters"]->Array.map(y => y["name"]),
    returnValues: [],
  })
}

let lineCommentsRe = %re("/\\/\\/[^\\n]*\\n/g")
let blockCommentsRe = %re("/\\/\\*([^*]|[\\r\\n]|(\\*+([^*/]|[\\r\\n])))*\\*+\\//g")
let getArtifact = %raw(`(fileNameWithoutExtension) => require("../../contracts/codegen/truffle/" + fileNameWithoutExtension + ".json")`)

exception BadMatchingBlock
let rec matchingBlockEndIndex = (str, startIndex, count) => {
  let charr = str->Js.String2.charAt(startIndex)
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
  | i if i->Js.String2.indexOf("/") === -1 =>
    array->Array.reduce("", (acc, curr) => acc ++ curr ++ "/") ++ i
  | i if i->Js.String2.startsWith("../") =>
    resolveImportLocationRecursive(
      array->Array.reverse->Array.sliceToEnd(1)->Array.reverse,
      i->Js.String2.substringToEnd(~from=3),
    )
  | i if i->Js.String2.startsWith("./") =>
    resolveImportLocationRecursive(array, i->Js.String2.substringToEnd(~from=2))
  | i => {
      let firstSlashIndex = i->Js.String2.indexOf("/")
      resolveImportLocationRecursive(
        array->Array.concat([i->Js.String2.substring(~from=0, ~to_=firstSlashIndex)]),
        i->Js.String2.substringToEnd(~from=firstSlashIndex + 1),
      )
    }
  }
}

let reduceStrArr = arr => arr->Array.reduce("", (acc, curr) => acc ++ curr)

filesToMock->Array.forEach(filePath => {
  let filePathSplit = filePath->Js.String2.split("/")
  let fileName = filePathSplit->Array.getExn(filePathSplit->Array.length - 1)

  let fileNameSplit = fileName->Js.String2.split(".")

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

  let sol = ref(("../contracts/contracts/" ++ filePath)->Node.Fs.readFileAsUtf8Sync)

  let lineCommentsMatch =
    sol.contents
    ->Js.String2.match_(lineCommentsRe)
    ->Option.map(i => i->Array.keep(x => x->Js.String2.indexOf("SPDX-License-Identifier") == -1))

  let _ = lineCommentsMatch->Option.map(l =>
    l->Array.forEach(i => {
      sol := sol.contents->Js.String2.replace(i, "")
    })
  )

  sol := sol.contents->Js.String2.replaceByRe(blockCommentsRe, "\n")

  let artifact = getArtifact(fileNameWithoutExtension)

  let contractDefinition =
    artifact["ast"]["nodes"]
    ->Array.keep(x => x["nodeType"] == "ContractDefinition")
    ->Array.getExn(0)

  let mockLogger = ref("")

  let constructor = constructorNode => {
    let indexOfOldFunctionDec = sol.contents->Js.String2.indexOf("constructor")

    let indexOfOldFunctionDecParameterOpeningParenethesis =
      indexOfOldFunctionDec + "constructor"->String.length

    let indexOfOldFunctioNDecParameterClosingParenthesis =
      sol.contents->Js.String2.indexOfFrom(")", indexOfOldFunctionDecParameterOpeningParenethesis)

    let functionDefParenthesis =
      sol.contents->Js.String2.substring(
        ~from=indexOfOldFunctionDecParameterOpeningParenethesis,
        ~to_=indexOfOldFunctioNDecParameterClosingParenthesis + 1,
      )
    let parameterCalls = constructorNode.parameters->commafiy
    mockLogger :=
      mockLogger.contents ++
      ` 
    constructor${functionDefParenthesis} ${fileNameWithoutExtension}(${parameterCalls}){}
    `
  }

  functions(contractDefinition["nodes"])->Array.forEach(x => {
    if x.name == "" {
      constructor(x)
    } else {
      let indexOfOldFunctionDec = sol.contents->Js.String2.indexOf("function " ++ x.name ++ "(")

      let indexOfOldFunctionDecParameterOpeningParenethesis =
        indexOfOldFunctionDec + x.name->String.length + "function "->String.length

      let indexOfOldFunctioNDecParameterClosingParenthesis =
        sol.contents->Js.String2.indexOfFrom(")", indexOfOldFunctionDecParameterOpeningParenethesis)

      let functionDefParenthesis =
        sol.contents->Js.String2.substring(
          ~from=indexOfOldFunctionDecParameterOpeningParenethesis,
          ~to_=indexOfOldFunctioNDecParameterClosingParenthesis + 1,
        )
      let indexOfOldFunctionBodyStart =
        sol.contents->Js.String2.indexOfFrom("{", indexOfOldFunctionDec)

      let solPrefix =
        sol.contents->Js.String2.substring(~from=0, ~to_=indexOfOldFunctionBodyStart + 1)

      let solSuffix = sol.contents->Js.String2.substringToEnd(~from=indexOfOldFunctionBodyStart + 1)
      let parameterCalls = x.parameters->commafiy

      sol :=
        solPrefix ++
        `
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("${x.name}"))){
      return mocker.${x.name}Mock(${parameterCalls});
    }
  ` ++
        solSuffix

      mockLogger :=
        mockLogger.contents ++
        ` 
    function ${x.name}Mock${functionDefParenthesis} public pure ${switch x.returnValues {
          | arr if arr->Array.length > 0 =>
            `returns (${arr
              ->Array.map(x => x.type_->convertSolTypeToReturnsType ++ " " ++ x.name)
              ->commafiy})`
          | _ => ""
          }}{
      return (${x.returnValues->Array.map(y => "abi.decode(\"\",(" ++ y.type_ ++ "))")->commafiy});
    }
    `
    }
  })

  modifiers(contractDefinition["nodes"])->Array.forEach(x => {
    let indexOfOldFunctionDec = sol.contents->Js.String2.indexOf("modifier " ++ x.name)

    let optIndexOfOldFunctionDecParameterOpeningParenethesis = {
      let indexIfThere = indexOfOldFunctionDec + x.name->String.length + "modifier "->String.length
      if sol.contents->Js.String2.charAt(indexIfThere) == "(" {
        Some(indexIfThere)
      } else {
        None
      }
    }

    let optIndexOfOldFunctioNDecParameterClosingParenthesis =
      optIndexOfOldFunctionDecParameterOpeningParenethesis->Option.map(x =>
        sol.contents->Js.String2.indexOfFrom(")", x)
      )

    let functionDefParenthesis = switch (
      optIndexOfOldFunctionDecParameterOpeningParenethesis,
      optIndexOfOldFunctioNDecParameterClosingParenthesis,
    ) {
    | (Some(a), Some(b)) => sol.contents->Js.String2.substring(~from=a, ~to_=b + 1)
    | _ => "()"
    }

    let indexOfOldFunctionBodyStart =
      sol.contents->Js.String2.indexOfFrom("{", indexOfOldFunctionDec)

    let indexOfOldFunctionBodyEnd =
      sol.contents->matchingBlockEndIndex(indexOfOldFunctionBodyStart + 1, 1)

    let functionBody =
      sol.contents->Js.String2.substring(
        ~from=indexOfOldFunctionBodyStart + 1,
        ~to_=indexOfOldFunctionBodyEnd,
      )

    let solPrefix =
      sol.contents->Js.String2.substring(~from=0, ~to_=indexOfOldFunctionBodyStart + 1)

    let solSuffix = sol.contents->Js.String2.substringToEnd(~from=indexOfOldFunctionBodyEnd)
    let parameterCalls = x.parameters->commafiy

    sol :=
      solPrefix ++
      `
    if(shouldUseMock && keccak256(abi.encodePacked(functionToNotMock)) != keccak256(abi.encodePacked("${x.name}"))){
      mocker.${x.name}Mock(${parameterCalls});
      _;
    } else {
      ${functionBody}
    }
  ` ++
      solSuffix

    mockLogger :=
      mockLogger.contents ++
      ` 
    function ${x.name}Mock${functionDefParenthesis} public pure {
      return; 
    }
    `
  })

  let importsInFile = sol.contents->Js.String2.match_(importRe)

  let importsInFileReplaced = importsInFile->Option.map(i =>
    i->Array.map(x => {
      if x->Js.String2.indexOf("..") == -1 && x->Js.String2.indexOf("./") == -1 {
        x
      } else {
        let impStatement = x->Js.String2.match_(quotesRe)->Option.getExn->Array.getExn(0)
        let impStatement =
          impStatement->Js.String2.substring(~from=1, ~to_=impStatement->String.length)
        let initialDirStructure = filePath->Js.String2.split("/")
        let initialDirStructure =
          initialDirStructure->Array.slice(~offset=0, ~len=initialDirStructure->Array.length - 1)
        x->Js.String2.replace(
          impStatement,
          "../../" ++ resolveImportLocationRecursive(initialDirStructure, impStatement),
        )
      }
    })
  )

  let _ = importsInFile->Option.map(i =>
    i->Array.forEachWithIndex((index, imp) => {
      sol :=
        sol.contents->Js.String2.replace(
          imp,
          importsInFileReplaced->Option.getUnsafe->Array.getUnsafe(index),
        )
    })
  )

  mockLogger :=
    "// SPDX-License-Identifier: BUSL-1.1 \n pragma solidity 0.8.3;\n" ++
    `import "../../${filePath}";
` ++
    importsInFileReplaced->Option.mapWithDefault("", i =>
      i->Array.map(z => z ++ "\n")->reduceStrArr
    ) ++
    `contract ${fileNameWithoutExtension}ForInternalMocking is ${fileNameWithoutExtension} {` ++
    mockLogger.contents ++ `}`

  let indexOfContractDef = sol.contents->Js.String2.indexOf("contract ")

  let indexOfContractBlock = sol.contents->Js.String2.indexOfFrom("{", indexOfContractDef)

  let indexOfContractName =
    sol.contents->Js.String2.indexOfFrom(fileNameWithoutExtension, indexOfContractDef)

  let prefix = sol.contents->Js.String2.substring(~from=0, ~to_=indexOfContractDef)
  let intermediate1 =
    sol.contents->Js.String2.substring(~from=indexOfContractDef, ~to_=indexOfContractName)
  let intermediate2 =
    sol.contents->Js.String2.substring(
      ~from=indexOfContractName + fileNameWithoutExtension->String.length,
      ~to_=indexOfContractBlock + 1,
    )
  let suffix = sol.contents->Js.String2.substringToEnd(~from=indexOfContractBlock + 1)

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
})
