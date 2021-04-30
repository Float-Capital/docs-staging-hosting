let zeroAddressStr = "0x0000000000000000000000000000000000000000"
let zeroAddress = Ethers.Utils.getAddressUnsafe(zeroAddressStr)

let zeroBN = Ethers.BigNumber.fromInt(0)
let tenToThe5 = Ethers.BigNumber.fromUnsafe("100000")
let tenToThe6 = Ethers.BigNumber.fromUnsafe("1000000")
let tenToThe9 = Ethers.BigNumber.fromUnsafe("1000000000")
let tenToThe18 = Ethers.BigNumber.fromUnsafe("1000000000000000000")
let oneHundredThousandInWei = tenToThe18->Ethers.BigNumber.mul(tenToThe5)
let oneMillionInWei = tenToThe18->Ethers.BigNumber.mul(tenToThe6)
let tenToThe42 = tenToThe6->Ethers.BigNumber.mul(tenToThe18)->Ethers.BigNumber.mul(tenToThe18)
let oneHundredEth = Ethers.BigNumber.fromUnsafe("100000000000000000000") // 10 ^ 20

/* Used for time in the graph */
let fiveMinutesInSeconds = 300
let oneHourInSeconds = 3600
let halfDayInSeconds = 43200
let oneDayInSeconds = 86400
let threeDaysInSeconds = 259200
let oneWeekInSeconds = 604800
let twoWeeksInSeconds = 1209600
let oneMonthInSeconds = 2628029

/* Used as intervals for the price history chart */
let threeMonthsInSeconds = 7884087
let oneYearInSeconds = 31536000
