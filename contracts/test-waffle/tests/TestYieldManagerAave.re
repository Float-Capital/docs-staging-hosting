open Globals;
open LetOps;
open Mocha;

describe("Float System", () => {
  describeUnit("YieldManagerAave - internals exposed", () => {
    let accounts: ref(array(Ethers.Wallet.t)) = ref(None->Obj.magic);
    let contracts: ref(Contract.YieldManagerAaveHelpers.contractsType) =
      ref(None->Obj.magic);

    before_each(() => {
      let%AwaitThen loadedAccounts = Ethers.getSigners();
      accounts := loadedAccounts;

      let admin = loadedAccounts->Array.getUnsafe(0);
      let treasury = loadedAccounts->Array.getUnsafe(1);

      let longShortAddress = Ethers.Wallet.createRandom().address;
      let fundTokenAddress = Ethers.Wallet.createRandom().address;

      let%Await lendingPoolMock = LendingPoolAaveMock.make();
      let%Await lendingPoolSmocked =
        LendingPoolAaveMockSmocked.make(lendingPoolMock);

      let%Await paymentTokenMock =
        ERC20Mock.make(~name="Payment Token Mock", ~symbol="PaymentToken");
      let%Await paymentTokenSmocked = ERC20MockSmocked.make(paymentTokenMock);

      let%Await erc20Mock =
        ERC20Mock.make(~name="Test APaymentToken", ~symbol="APaymentToken");

      let%Await yieldManagerAave =
        YieldManagerAave.make(
          ~admin=admin.address,
          ~longShort=longShortAddress,
          ~treasury=treasury.address,
          ~paymentToken=paymentTokenSmocked.address,
          ~aToken=fundTokenAddress,
          ~lendingPool=lendingPoolSmocked.address,
          ~aaveReferalCode=6543,
        );

      contracts :=
        {
          "erc20Mock": erc20Mock,
          "yieldManagerAave": yieldManagerAave,
          "paymentToken": paymentTokenSmocked,
        };
    });

    WithdrawTokens.testUnit(~contracts, ~accounts);
  })
});
