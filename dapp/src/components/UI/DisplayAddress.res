@ocaml.doc(`
Takes a long string and cuts out the middle.

eg. elipsifyMiddle(~inputString="abcdefghijk", ~maxLength=6, ~trailingCharacters=3) == "abc...ijk"
`)
let elipsifyMiddle = (~inputString, ~maxLength, ~trailingCharacters) => {
  let stringLength = inputString->String.length

  if stringLength > maxLength && trailingCharacters + maxLength < stringLength {
    `${String.sub(inputString, 0, maxLength - 3)}...${String.sub(
        inputString,
        Js.Math.abs_int(stringLength - trailingCharacters),
        trailingCharacters,
      )}`
  } else {
    inputString
  }
}

// Something to look into, css elipsify - then the full text is still copy/pastable: https://developer.mozilla.org/en-US/docs/Web/CSS/text-overflow
@react.component
let make = (~address) => {
  elipsifyMiddle(~inputString=address, ~maxLength=9, ~trailingCharacters=3)->React.string
}
