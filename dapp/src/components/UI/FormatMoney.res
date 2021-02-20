let formatMoney = (~number) => {
  let decimals = (number *. 100.)->Belt.Int.fromFloat->mod(100)->Js.Math.abs_int->Belt.Int.toString
  let reverseArrayToString = arr => arr->Belt.Array.reverse->Js.Array.toString
  let removeCommas = str => str->Js.String2.replaceByRe(%re("/[,]/g"), "")
  let convertStringToArray = str => str->Js.String2.split("")
  let numberWithoutDecimals = number->Js.Math.floor_int
  // eg number = 1234567
  // Reverse number then seperate every 3 characters eg: 765 432 1
  let reversedSeperatedNumber =
    numberWithoutDecimals
    ->Belt.Int.toString
    ->Js.String2.split("")
    ->reverseArrayToString
    ->removeCommas
    ->Js.String2.match_(%re("/.{1,3}/g"))
  let formattedMoney = switch reversedSeperatedNumber {
  | Some(arr) =>
    arr
    // reverse each substring of the array to original eg. 567 234 1
    ->Array.map(part => part->convertStringToArray->reverseArrayToString->removeCommas)
    // reverse seperated portions
    ->reverseArrayToString
  | None => ""
  }

  `${formattedMoney}.${decimals}`
}
@react.component
let make = (~number) => {
  let formattedMoney = formatMoney(~number)
  <span> {formattedMoney->React.string} </span>
}
