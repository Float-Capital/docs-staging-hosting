let allStateChangesRaw = Queries.getAllStateChanges()
let filePreRamble = `type address = string

type unclassifiedEvent = {
  name: string,
  data: Js.Dict.t<string>,
}`
let typesString = ref(``)
let variantTypeString = ref(`type stateChanges =
  | Unclassified(unclassifiedEvent)`)

let lowercaseFirstLetter = %raw(`(word) => word.charAt(0).toLowerCase() + word.slice(1)`)

let paramTypeToRescriptType = paramType =>
  switch paramType {
  | "uint32"
  | "uint256" => "BN.t"
  | "string" => "string"
  | "address" => "address"
  | unkownType =>
    Js.log(`Please handle all types - ${unkownType} isn't handled by this script.`)
    "unkownType"
  }

let _ = allStateChangesRaw->JsPromise.map(allStateChanges => {
  let uniqueStateChangeTypes = Js.Dict.empty()
  allStateChanges->Array.forEach(({txEventParamList}) =>
    txEventParamList->Array.forEach(({eventName, params}) => {
      let eventGenerated = uniqueStateChangeTypes->Js.Dict.get(eventName)->Option.isNone

      if eventGenerated {
        uniqueStateChangeTypes->Js.Dict.set(eventName, "set")
        let recordFields = params->Array.reduce(``, (acc, {paramType, paramName}) =>
          acc ++
          `
  ${paramName}: ${paramType->paramTypeToRescriptType},`
        )

        let eventDataTypeName = `${eventName->lowercaseFirstLetter}Data`
        typesString :=
          typesString.contents ++
          `
type ${eventDataTypeName} = {${recordFields}
}`

        variantTypeString :=
          variantTypeString.contents ++
          `
  | ${eventName}(${eventDataTypeName})`
        ()
      }
    })
  )

  Js.log(
    `${filePreRamble}
${typesString.contents}

${variantTypeString.contents}`,
  )
  ()
})
