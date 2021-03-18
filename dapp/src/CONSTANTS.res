let zeroAddressStr = "0x0000000000000000000000000000000000000000"
let zeroAddress = Ethers.Utils.getAddressUnsafe(zeroAddressStr)

let zeroBN = Ethers.BigNumber.fromInt(0)
let tenToThe6 = Ethers.BigNumber.fromUnsafe("1000000")
let tenToThe9 = Ethers.BigNumber.fromUnsafe("1000000000")
let tenToThe18 = Ethers.BigNumber.fromUnsafe("1000000000000000000")
let tenToThe42 = tenToThe6->Ethers.BigNumber.mul(tenToThe18)->Ethers.BigNumber.mul(tenToThe18)
let oneHundredEth = Ethers.BigNumber.fromUnsafe("100000000000000000000") // 10 ^ 20
