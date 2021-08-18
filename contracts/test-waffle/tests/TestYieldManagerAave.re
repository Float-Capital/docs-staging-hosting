open Globals;
open LetOps;
open Mocha;

describe("Float System", () => {
  let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);
  let contracts: ref(Contract.YieldManagerAaveHelpers.contractsType) =
    ref(None->Obj.magic);

  let setup = () => {
    let%AwaitThen loadedAccounts = Ethers.getSigners();
    accounts := loadedAccounts;

    let treasury = loadedAccounts->Array.getUnsafe(1);

    let longShortAddress = Ethers.Wallet.createRandom().address;

    let%Await paymentTokenMock =
      ERC20Mock.make(~name="Payment Token Mock", ~symbol="PaymentToken");
    let%Await paymentTokenSmocked = ERC20MockSmocked.make(paymentTokenMock);

    let%Await aTokenMock =
      ERC20Mock.make(~name="Test APaymentToken", ~symbol="APaymentToken");
    let%Await aTokenSmocked = ERC20MockSmocked.make(aTokenMock);

    let%Await aaveIncentivesControllerMock =
      AaveIncentivesControllerMock.make();
    let%Await aaveIncentivesControllerSmocked =
      AaveIncentivesControllerMockSmocked.make(aaveIncentivesControllerMock);
    let%Await lendingPoolAddressesProviderMock =
      LendingPoolAddressesProviderMock.make();
    let%Await lendingPoolAddressesProviderSmocked =
      LendingPoolAddressesProviderMockSmocked.make(
        lendingPoolAddressesProviderMock,
      );

    let%Await yieldManagerAave =
      YieldManagerAave.make(
        ~longShort=longShortAddress,
        ~treasury=treasury.address,
        ~paymentToken=paymentTokenSmocked.address,
        ~aToken=aTokenSmocked.address,
        ~lendingPoolAddressesProvider=
          lendingPoolAddressesProviderSmocked.address,
        ~aaveIncentivesController=aaveIncentivesControllerSmocked.address,
        ~aaveReferralCode=6543,
      );

    contracts :=
      {
        "aToken": aTokenSmocked,
        "yieldManagerAave": yieldManagerAave,
        "paymentToken": paymentTokenSmocked,
        "treasury": treasury,
        "aaveIncentivesController": aaveIncentivesControllerSmocked,
      };
  };
  describeUnit("(un-optimised) YieldManagerAave - internals exposed", () => {
    before_each(setup)
  });
  describeUnit("(optimised) YieldManagerAave - internals exposed ", () => {
    before(setup);

    ClaimAaveRewards.testUnit(~contracts);
  });
});
