let files = Node.Fs.readdirSync("../contracts/abis")
Js.log(files)

let _ = files->Array.map(abiFileName => {
  let abiFileContents = `../contracts/abis/${abiFileName}`->Node.Fs.readFileSync(#utf8)

  let abiFileObject = abiFileContents->Js.Json.parseExn->Obj.magic // us some useful polymorphic magic 🙌

  let _processEachItemInAbi = abiFileObject->Array.map(abiItem => {
    let name = abiItem["name"]
    let itemType = abiItem["type"]

    switch itemType {
    | #event => Js.log(`we have an event - ${name}`)
    | #function => Js.log(`we have an FUNCTION - ${name}`)
    | _ => Js.log(`We have an unhandled typ - ${name}`)
    }
  })
})
