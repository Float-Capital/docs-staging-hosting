let zeroAddressStr = "0x0000000000000000000000000000000000000000"
let zeroAddress = Ethers.Utils.getAddressUnsafe(zeroAddressStr)

let zeroBN = Ethers.BigNumber.fromInt(0)
let twoBN = Ethers.BigNumber.fromInt(2)
let eightBN = Ethers.BigNumber.fromInt(8)
let tenToThe5 = Ethers.BigNumber.fromUnsafe("100000")
let tenToThe6 = Ethers.BigNumber.fromUnsafe("1000000")
let tenToThe9 = Ethers.BigNumber.fromUnsafe("1000000000")
let tenToThe18 = Ethers.BigNumber.fromUnsafe("1000000000000000000")
let oneHundredThousandInWei = tenToThe18->Ethers.BigNumber.mul(tenToThe5)
let fiveHundredThousandInWei =
  tenToThe18->Ethers.BigNumber.mul(tenToThe6)->Ethers.BigNumber.div(twoBN)
let oneMillionInWei = tenToThe18->Ethers.BigNumber.mul(tenToThe6)
let tenToThe42 = tenToThe6->Ethers.BigNumber.mul(tenToThe18)->Ethers.BigNumber.mul(tenToThe18)
let oneHundredEth = Ethers.BigNumber.fromUnsafe("100000000000000000000") // 10 ^ 20
let oneThousandInWei = Ethers.BigNumber.fromUnsafe("1000000000000000000000") // 10 ^ 21

let stakeDivisorForSafeExponentiation = twoBN->Ethers.BigNumber.pow(Ethers.BigNumber.fromInt(52))
let stakeDivisorForSafeExponentiationDiv2 =
  stakeDivisorForSafeExponentiation->Ethers.BigNumber.div(twoBN)
let tenToThe18Div2 = tenToThe18->Ethers.BigNumber.div(twoBN)

/* Used for time in the graph */
let fiveMinutesInSeconds = 300
let oneHourInSeconds = 3600
let halfDayInSeconds = 43200
let oneDayInSeconds = 86400
let threeDaysInSeconds = 259200
let oneWeekInSeconds = 604800
let twoWeeksInSeconds = 1209600
let oneMonthInSeconds = 2628029

/* price graph time periods */
module PriceGraphLabels = {
  let max = "MAX"
  let day = "1D"
  let week = "1W"
  let month = "1M"
  let threeMonth = "3M"
  let year = "1Y"
}

/* Used as intervals for the price history chart */
let threeMonthsInSeconds = 7884087
let oneYearInSeconds = 31536000

let hotAPYThreshold = 0.15

// TODO: Pull the hardcoded values in from graph / sushiswap
let kperiodHardcode = Ethers.BigNumber.fromUnsafe("1664000") // ~20 days
let kmultiplierHardcode = Ethers.BigNumber.fromUnsafe("5000000000000000000")
let equilibriumOffsetHardcode = zeroBN
let balanceIncentiveExponentHardcode = twoBN
let floatTokenDollarWorthHardcode = tenToThe18->Ethers.BigNumber.div(eightBN)
// ^ thumbsuck to make apy not too ridiculous = 0.125 dollars

let oneYearInSecondsMulTenToThe18 =
  oneYearInSeconds->Ethers.BigNumber.fromInt->Ethers.BigNumber.mul(tenToThe18)

/* Currencies */
type displayToken = {name: string, iconUrl: string}

let daiDisplayToken: displayToken = {name: "DAI", iconUrl: "/icons/dai.svg"}
let polygonDisplayToken: displayToken = {name: "Polygon", iconUrl: "/icons/polygon.png"}

/* Chains */
type chainData = {name: string, chainId: int}
let mumbai: chainData = {name: "mumbai", chainId: 80001}
let polygon: chainData = {name: "polygon", chainId: 137}
