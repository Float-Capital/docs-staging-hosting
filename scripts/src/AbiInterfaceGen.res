let files = Node.Fs.readdirSync("../contracts/abis")

let getMmoduleName = fileName => fileName->Js.String2.split(".")->Array.getUnsafe(0)
let getRescriptType = typeString =>
  switch typeString {
  | #uint32 => "int"
  | #uint256 => "bn"
  | #string => "string"
  | #address => "address"
  | unknownType =>
    Js.log(`Please handle all types - ${unknownType->Obj.magic} isn't handled by this script.`)
    "unkownType"
  }
let typeInputs = inputs => {
  let paramsString = ref("")
  let _ = inputs->Array.map(input => {
    let paramType = input["type"]
    let paramName = input["name"]

    let rescriptType = getRescriptType(paramType)

    paramsString :=
      paramsString.contents ++
      `
~${paramName}: ${rescriptType},`
  })

  paramsString.contents
}
let typeOutputs = (outputs, functionName) => {
  let paramsString = ref("")
  if outputs->Array.length > 1 {
    let _types = outputs->Array.mapWithIndex((index, output) => {
      let paramType = output["type"]
      let paramName = output["name"]->Option.getWithDefault(`param${index->Int.toString}`)
      if paramName == "" {
        Js.log("name is zero")
      }

      let rescriptType = getRescriptType(paramType)

      paramsString :=
        paramsString.contents ++
        `
${paramName}: ${rescriptType},`
    })
    `type ${functionName}Return = {${paramsString.contents}
    }`
  } else {
    Js.log("IN THE ELSE!!!!!")
    let rescriptType = getRescriptType((outputs->Array.getUnsafe(0))["type"])
    `type ${functionName}Return = ${rescriptType}`
  }
}

let moduleDictionary = Js.Dict.empty()
let _ = files->Array.map(abiFileName => {
  let abiFileContents = `../contracts/abis/${abiFileName}`->Node.Fs.readFileAsUtf8Sync

  let abiFileObject = abiFileContents->Js.Json.parseExn->Obj.magic // us some useful polymorphic magic 🙌

  let moduleContents = ref(``)
  let moduleName = getMmoduleName(abiFileName)
  let _processEachItemInAbi = abiFileObject->Array.map(abiItem => {
    let name = abiItem["name"]
    let itemType = abiItem["type"]

    switch itemType {
    | #event => Js.log(`we have an event - ${name}`)
    | #function =>
      Js.log(`we have an FUNCTION - ${name}`)
      let inputs = abiItem["inputs"]
      let outputs = abiItem["outputs"]
      let stateMutability = abiItem["stateMutability"]
      let typeNames = typeInputs(inputs)
      switch stateMutability {
      | #view | #pure =>
        let returnType = `${name}Return`
        let returnTypeDefinition = typeOutputs(outputs, name)
        moduleContents :=
          moduleContents.contents ++
          `
  ${returnTypeDefinition}
  @send
  external userLazyActions: (
    t,${typeNames}
  ) => JsPromise.t<${returnType}> = "${name}"
`
      | _ =>
        moduleContents :=
          moduleContents.contents ++
          `
  @send
  external userLazyActions: (
    t,${typeNames}
  ) => JsPromise.t<transaction> = "${name}"
`
      }
    | #constructor => Js.log(`We have a CONSTRUCTOR - `)
    | _ => Js.log2(`We have an unhandled type - ${name} ${itemType->Obj.magic}`, abiItem)
    }
  })
  moduleDictionary->Js.Dict.set(moduleName, moduleContents.contents)
})

let _writeFiles =
  moduleDictionary
  ->Js.Dict.entries
  ->Array.map(((moduleName, contents)) => {
    if !(moduleName->Js.String2.endsWith("Exposed")) {
      Node.Fs.writeFileAsUtf8Sync(
        `../contracts/test-waffle/library/contracts/${moduleName}.res`,
        `module ${moduleName} = {
` ++
        contents ++ `
}`,
      )
    }
  })
