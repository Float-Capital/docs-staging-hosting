let {startsWith} = module(Js.String2)
let {reduceStrArr, contains, containsRe, commafiy, lowerCaseFirstLetter, formatKeywords} = module(
  Globals
)

let uppercaseFirstLetter = %raw(`(someString) => someString.charAt(0).toUpperCase() + someString.slice(1)`)

type parameters = Globals.typedIdentifier

type functionDef = Globals.functionType
type storageLocation = Globals.storageLocation
type typedIdentifier = Globals.typedIdentifier

let solASTTypeToRescriptType = typeDescrStr =>
  switch typeDescrStr {
  | "bool" => "bool"
  | "string" => "string"
  | "bytes32" => "string"
  | "bytes4" => "string"
  | "int8"
  | "int16"
  | "int32"
  | "uint8"
  | "uint16"
  | "uint32" => "int"
  | "uint16[]"
  | "uint32[]" => "array<int>"
  | t if t->containsRe(%re("/\\[/g")) => {
      Js.Console.warn(
        `Rescript type conversion for array types for type ${t} currently limited. YOu'll have to put in the correct bindings for this type when you call it`,
      )
      `array<'${t}>`
    }
  | t if t->startsWith("enum") => "int"
  | t if t->startsWith("uint") || t->startsWith("int") => "Ethers.BigNumber.t"
  | t if t->startsWith("contract") || t == "address" => "Ethers.ethAddress"
  | t =>
    Js.Console.warn(
      `Rescript type parsing for ${typeDescrStr} type not implemented yet. E.g. struct parsing. You'll have to put in the correct bindings for this type when you call it.`,
    )
    "'" ++ t // any type for rescript
  }

let defaultParamName = index => "param" ++ index->Int.toString

let paramName = (index, name) =>
  name != "" ? name->formatKeywords->lowerCaseFirstLetter : index->defaultParamName

let parametersToRecordType: (functionDef, string) => string = (fnType, recordName) =>
  `
  type ${recordName} = {
` ++
  fnType.parameters
  ->Array.mapWithIndex((i, param) => {
    `
     ${paramName(i, param.name)} : ${param.type_->solASTTypeToRescriptType},
    `
  })
  ->reduceStrArr ++ `}

  `

let callTypeName = name => name->lowerCaseFirstLetter ++ "Call"
let paramTypeForCalls: functionDef => string = def => {
  let typeName = def.name->callTypeName
  if def.parameters->Array.length == 0 {
    `type ${typeName}`
  } else {
    parametersToRecordType(def, typeName)
  }
}

let solParamsToToRecordWithSameNames: array<parameters> => string = params =>
  `
  {
` ++
  params
  ->Array.mapWithIndex((i, param) => {
    let name = paramName(i, param.name)
    `
     ${name} : ${name},
    `
  })
  ->reduceStrArr ++ `}

  `

let identifiersToTuple: array<parameters> => string = arr =>
  "(" ++ arr->Array.mapWithIndex((i, tp) => paramName(i, tp.name))->commafiy ++ ")"

let getRescriptParamsForCalls: array<parameters> => string = params =>
  switch params {
  | params if params->Array.length == 1 => "_m"
  | params => params->identifiersToTuple
  }

let getCallsHelper: functionDef => (string, string) = fnType => (
  fnType.name->callTypeName,
  fnType.name->lowerCaseFirstLetter ++ "Calls",
)

let getCallsArrayContent: functionDef => string = fnType => {
  `array->Array.map(((${fnType.parameters->getRescriptParamsForCalls})) => {
            ${if fnType.parameters->Array.length == 1 {
      let p = fnType.parameters->Array.getUnsafe(0)
      `let ${paramName(0, p.name)} = _m->Array.getUnsafe(0)`
    } else {
      ""
    }}
            ${if fnType.parameters->Array.length == 0 {
      "()->Obj.magic"
    } else {
      fnType.parameters->solParamsToToRecordWithSameNames
    }}
          })`
}

let getCallsInternal: functionDef => string = fnType => {
  let (fnCallType, fnName) = getCallsHelper(fnType)

  `
  let ${fnName}: unit => array<
  ${fnCallType}> = () => {
      checkForExceptions(~functionName="${fnType.name}")
        internalRef.contents
        ->Option.map(_r => {
          let array = %raw("_r.smocked.${fnType.name}Mock.calls")
          ${fnType->getCallsArrayContent}
        })
  ->Option.getExn
  }
  `
}

let getCallsExternal: functionDef => string = fnType => {
  let (fnCallType, fnName) = getCallsHelper(fnType)
  `
  let ${fnName}: t => array<
  ${fnCallType}> = _r => {
        let array = %raw("_r.smocked.${fnType.name}.calls")
        ${fnType->getCallsArrayContent}
  }
  `
}

let getRescriptParamsForReturn: array<typedIdentifier> => string = params =>
  params
  ->Array.mapWithIndex((i, _p) => {
    "_" ++ i->defaultParamName
  })
  ->commafiy

let basicReturn = (params: array<typedIdentifier>) =>
  params
  ->Array.map(t => {
    t.type_->solASTTypeToRescriptType
  })
  ->commafiy

type context = External | Internal

let rescriptReturnAnnotation: (array<typedIdentifier>, ~context: context) => string = (
  params,
  ~context,
) =>
  switch context {
  | Internal =>
    if params->Array.length > 0 {
      ` (${basicReturn(params)}) => unit `
    } else {
      "unit => unit"
    }
  | External =>
    if params->Array.length > 0 {
      ` (t, ${basicReturn(params)}) => unit `
    } else {
      "t => unit"
    }
  }

let getMockToReturnInternal: functionDef => string = fn => {
  let params = fn.returnValues->getRescriptParamsForReturn
  `
  let mock${fn.name->uppercaseFirstLetter}ToReturn: ${fn.returnValues->rescriptReturnAnnotation(
      ~context=Internal,
    )} = (${params}) => {
    checkForExceptions(~functionName="${fn.name}")
    let _ = internalRef.contents->Option.map(_r => {

      ${if fn.returnValues->Array.length > 0 {
      `let _ = %raw(
        "_r.smocked.${fn.name}Mock.will.return.with([${params}])"
        )`
    } else {
      `let _ = %raw(
        "_r.smocked.${fn.name}Mock.will.return()"
        )`
    }}
    })
  }
  `
}

let getMockToReturnExternal: functionDef => string = fn => {
  let params = fn.returnValues->getRescriptParamsForReturn
  `
  let mock${fn.name->uppercaseFirstLetter}ToReturn: ${fn.returnValues->rescriptReturnAnnotation(
      ~context=External,
    )} = (_r ${fn.returnValues->Array.length > 0 ? `, ${params})` : `)`} => {

      ${if fn.returnValues->Array.length > 0 {
      `      let _ = %raw(
        "_r.smocked.${fn.name}.will.return.with([${params}])"
        )`
    } else {
      `let _ = %raw(
        "_r.smocked.${fn.name}.will.return()"
        )`
    }}
  }
  `
}

let internalModule = (functionsAndModifiers, ~contractName) =>
  `module InternalMock = {
  let mockContractName = "${contractName}ForInternalMocking"
  type t = {address: Ethers.ethAddress}

  let internalRef: ref<option<t>> = ref(None)

  let functionToNotMock: ref<string> = ref("")

  @module("@eth-optimism/smock") external smock: 'a => Js.Promise.t<t> = "smockit"

  let setup: ${contractName}.t => JsPromise.t<ContractHelpers.transaction> = contract => {
    ContractHelpers.deployContract0(mockContractName)
    ->JsPromise.then(a => {
      smock(a)
    })
    ->JsPromise.then(b => {
      internalRef := Some(b)
      contract->${contractName}.Exposed.setMocker(~mocker=(b->Obj.magic).address)
    })
  }

  let setFunctionForUnitTesting = (contract, ~functionName) => {
    functionToNotMock := functionName
    contract->${contractName}.Exposed.setFunctionToNotMock(~functionToNotMock=functionName)
  }

  let setupFunctionForUnitTesting = (contract, ~functionName) => {
    ContractHelpers.deployContract0(mockContractName)
    ->JsPromise.then(a => {
      smock(a)
    })
    ->JsPromise.then(b => {
      internalRef := Some(b)
      [
        contract->${contractName}.Exposed.setMocker(~mocker=(b->Obj.magic).address),
        contract->${contractName}.Exposed.setFunctionToNotMock(~functionToNotMock=functionName),
      ]->JsPromise.all
    })
  }

  exception MockingAFunctionThatYouShouldntBe

  exception HaventSetupInternalMockingFor${contractName}

  let checkForExceptions = (~functionName) => {
    if functionToNotMock.contents == functionName {
      raise(MockingAFunctionThatYouShouldntBe)
    }
    if internalRef.contents == None {
      raise(HaventSetupInternalMockingFor${contractName})
    }
  }

  ${functionsAndModifiers
    ->Array.map(f => {
      f->getMockToReturnInternal ++ "\n" ++ f->paramTypeForCalls ++ "\n" ++ f->getCallsInternal
    })
    ->reduceStrArr}
  }
  `

let externalModule = (functions, ~contractName) => {
  `type t = {address: Ethers.ethAddress}

@module("@eth-optimism/smock") external make: ${contractName}.t => Js.Promise.t<t> = "smockit"

let uninitializedValue: t = None->Obj.magic

  ${functions
    ->Array.map(f => {
      f->getMockToReturnExternal ++ "\n" ++ f->paramTypeForCalls ++ "\n" ++ f->getCallsExternal
    })
    ->reduceStrArr}
`
}

let entireModule = (~contractName, ~allFunctions, ~publicFunctions) => {
  publicFunctions->externalModule(~contractName) ++
  "\n\n" ++
  allFunctions->internalModule(~contractName)
}
