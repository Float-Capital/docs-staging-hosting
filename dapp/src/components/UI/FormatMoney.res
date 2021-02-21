let toCentsFixedNoRounding = floatString =>
  floatString
  ->Js.String2.match_(%re("/^\d+[.]\d\d/g"))
  ->Option.getWithDefault(["0.00"])
  ->Array.getUnsafe(0)

let format = Js.String2.replaceByRe(_, %re("/\d(?=(\d{3})+\.)/g"), "$&,")

let formatFloat = number => {
  number->Js.Float.toFixedWithPrecision(~digits=2)->format
}

let formatEther = rawNumber => rawNumber->Ethers.Utils.formatEther->format

let formatEtherRound = rawNumber =>
  rawNumber->Ethers.Utils.formatEther->Js.Float.fromString->formatFloat
