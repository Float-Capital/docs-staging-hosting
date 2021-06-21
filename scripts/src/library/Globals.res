let {indexOf, match_, substring} = module(Js.String2)

let reduceStrArr = arr => arr->Array.reduce("", (acc, curr) => acc ++ curr)

let contains = (str, subst) => !(str->indexOf(subst) == -1)

let containsRe = (str, re) => {
  str->match_(re)->Option.isSome
}

let commafiy = strings => {
  let mockerParameterCalls = strings->Array.reduce("", (acc, curr) => {
    acc ++ curr ++ ","
  })
  if mockerParameterCalls->String.length > 0 {
    mockerParameterCalls->substring(~from=0, ~to_=mockerParameterCalls->String.length - 1)
  } else {
    mockerParameterCalls
  }
}

type storageLocation = Storage | NotRelevant
type visibility = Public | Private

type typedIdentifier = {
  name: string,
  type_: string,
  storageLocation: storageLocation,
}
type functionType = {
  name: string,
  parameters: array<typedIdentifier>,
  returnValues: array<typedIdentifier>,
  visibility: visibility,
}
