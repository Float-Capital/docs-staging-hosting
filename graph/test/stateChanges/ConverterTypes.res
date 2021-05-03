@decco type address = string
// let thing = Decco.dictFromJson
let bnDeccoCodex = (
  bn => bn->BN.toString->Js.Json.string,
  json =>
    json
    ->Js.Json.decodeString
    ->Option.mapWithDefault(
      Error({
        {
          Decco.path: "",
          message: "Unable to decode BN",
          value: json,
        }
      }),
      numberStr => numberStr->BN.new_->Ok,
    ),
)

@decco
type bn = @decco.codec(bnDeccoCodex) BN.t

type unclassifiedEvent = {
  name: string,
  data: Js.Dict.t<Js.Json.t>,
}
