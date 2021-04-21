type t
@val @scope("window") external ethObj: option<t> = "ethereum"

@get external getIsMetamask: t => option<bool> = "isMetaMask"

let isMetamask = () => {
  ethObj->Option.flatMap(e => e->getIsMetamask)->Option.getWithDefault(false)
}
