
@@ocaml.warning("-32")
open SmockGeneral
open ContractHelpers
type t = {address: Ethers.ethAddress}
let contractName = "YieldManagerAave"

let at: Ethers.ethAddress => JsPromise.t<t> = contractAddress =>
  attachToContract(contractName, ~contractAddress)->Obj.magic

let make: unit => JsPromise.t<t> = () => deployContract0(contractName)->Obj.magic
    let makeSmock: unit => JsPromise.t<t> = () => deployMockContract0(contractName)->Obj.magic

    let setVariable: (t, ~name: string, ~value: 'a) => JsPromise.t<unit> = setVariableRaw
    


  type aDMIN_ROLEReturn = bytes32
  @send
  external aDMIN_ROLE: (
    t,
  ) => JsPromise.t<aDMIN_ROLEReturn> = "ADMIN_ROLE"

  type dEFAULT_ADMIN_ROLEReturn = bytes32
  @send
  external dEFAULT_ADMIN_ROLE: (
    t,
  ) => JsPromise.t<dEFAULT_ADMIN_ROLEReturn> = "DEFAULT_ADMIN_ROLE"

  type uPGRADER_ROLEReturn = bytes32
  @send
  external uPGRADER_ROLE: (
    t,
  ) => JsPromise.t<uPGRADER_ROLEReturn> = "UPGRADER_ROLE"

  type aTokenReturn = Ethers.ethAddress
  @send
  external aToken: (
    t,
  ) => JsPromise.t<aTokenReturn> = "aToken"

  type aaveIncentivesControllerReturn = Ethers.ethAddress
  @send
  external aaveIncentivesController: (
    t,
  ) => JsPromise.t<aaveIncentivesControllerReturn> = "aaveIncentivesController"

  type amountReservedInCaseOfInsufficientAaveLiquidityReturn = Ethers.BigNumber.t
  @send
  external amountReservedInCaseOfInsufficientAaveLiquidity: (
    t,
  ) => JsPromise.t<amountReservedInCaseOfInsufficientAaveLiquidityReturn> = "amountReservedInCaseOfInsufficientAaveLiquidity"

  @send
  external claimAaveRewardsToTreasury: (
    t,
  ) => JsPromise.t<transaction> = "claimAaveRewardsToTreasury"

  @send
  external depositPaymentToken: (
    t,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "depositPaymentToken"

  @send
  external distributeYieldForTreasuryAndReturnMarketAllocation: (
    t,~totalValueRealizedForMarket: Ethers.BigNumber.t,~treasuryYieldPercent_e18: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "distributeYieldForTreasuryAndReturnMarketAllocation"

    type distributeYieldForTreasuryAndReturnMarketAllocationReturn = Ethers.BigNumber.t
    @send @scope("callStatic")
    external distributeYieldForTreasuryAndReturnMarketAllocationCall: (
      t,~totalValueRealizedForMarket: Ethers.BigNumber.t,~treasuryYieldPercent_e18: Ethers.BigNumber.t,
    ) => JsPromise.t<distributeYieldForTreasuryAndReturnMarketAllocationReturn> = "distributeYieldForTreasuryAndReturnMarketAllocation"

  type getRoleAdminReturn = bytes32
  @send
  external getRoleAdmin: (
    t,~role: bytes32,
  ) => JsPromise.t<getRoleAdminReturn> = "getRoleAdmin"

  @send
  external grantRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "grantRole"

  type hasRoleReturn = bool
  @send
  external hasRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<hasRoleReturn> = "hasRole"

  @send
  external initialize: (
    t,~longShort: Ethers.ethAddress,~treasury: Ethers.ethAddress,~paymentToken: Ethers.ethAddress,~aToken: Ethers.ethAddress,~lendingPoolAddressesProvider: Ethers.ethAddress,~aaveIncentivesController: Ethers.ethAddress,~aaveReferralCode: int,~admin: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "initialize"

  @send
  external initializeForMarket: (
    t,
  ) => JsPromise.t<transaction> = "initializeForMarket"

  type isInitializedReturn = bool
  @send
  external isInitialized: (
    t,
  ) => JsPromise.t<isInitializedReturn> = "isInitialized"

  type lendingPoolAddressesProviderReturn = Ethers.ethAddress
  @send
  external lendingPoolAddressesProvider: (
    t,
  ) => JsPromise.t<lendingPoolAddressesProviderReturn> = "lendingPoolAddressesProvider"

  type longShortReturn = Ethers.ethAddress
  @send
  external longShort: (
    t,
  ) => JsPromise.t<longShortReturn> = "longShort"

  type paymentTokenReturn = Ethers.ethAddress
  @send
  external paymentToken: (
    t,
  ) => JsPromise.t<paymentTokenReturn> = "paymentToken"

  @send
  external removePaymentTokenFromMarket: (
    t,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "removePaymentTokenFromMarket"

  @send
  external renounceRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "renounceRole"

  @send
  external revokeRole: (
    t,~role: bytes32,~account: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "revokeRole"

  type supportsInterfaceReturn = bool
  @send
  external supportsInterface: (
    t,~interfaceId: bytes4,
  ) => JsPromise.t<supportsInterfaceReturn> = "supportsInterface"

  type totalReservedForTreasuryReturn = Ethers.BigNumber.t
  @send
  external totalReservedForTreasury: (
    t,
  ) => JsPromise.t<totalReservedForTreasuryReturn> = "totalReservedForTreasury"

  @send
  external transferPaymentTokensToUser: (
    t,~user: Ethers.ethAddress,~amount: Ethers.BigNumber.t,
  ) => JsPromise.t<transaction> = "transferPaymentTokensToUser"

  type treasuryReturn = Ethers.ethAddress
  @send
  external treasury: (
    t,
  ) => JsPromise.t<treasuryReturn> = "treasury"

  @send
  external updateLatestLendingPoolAddress: (
    t,
  ) => JsPromise.t<transaction> = "updateLatestLendingPoolAddress"

  @send
  external upgradeTo: (
    t,~newImplementation: Ethers.ethAddress,
  ) => JsPromise.t<transaction> = "upgradeTo"

  @send
  external upgradeToAndCall: (
    t,~newImplementation: Ethers.ethAddress,~data: bytes32,
  ) => JsPromise.t<transaction> = "upgradeToAndCall"

  @send
  external withdrawTreasuryFunds: (
    t,
  ) => JsPromise.t<transaction> = "withdrawTreasuryFunds"



