@ocaml.doc(`Adds a comma between groups of 3 digits to a floating point string`)
let format = Js.String2.replaceByRe(_, %re("/\d(?=(\d{3})+\.)/g"), "$&,")

@ocaml.doc(`Adds a comma between groups of 3 digits to an integer string`)
let formatInt = Js.String2.replaceByRe(_, %re("/\d(?=(\d{3})+$)/g"), "$&,")

@ocaml.doc(`Formats a float to 2 digits precision with groups of 3 decimals separated by a comma`)
let formatFloat = (~digits=2, number) => number->Js.Float.toFixedWithPrecision(~digits)->format

@ocaml.doc(`Formats a string float to 2 digits precision with groups of 3 decimals separated by a comma`)
let toCentsFixedNoRounding = (~digits=2, floatString) =>
  floatString->Js.Float.fromString->formatFloat(~digits)

@ocaml.doc(`Formats a BigNumber (10^18, wei) to 2 digits precision (ether) with groups of 3 decimals separated by a comma`)
let formatEther = (~digits=2, rawNumber) =>
  rawNumber->Ethers.Utils.formatEther->toCentsFixedNoRounding(~digits)
