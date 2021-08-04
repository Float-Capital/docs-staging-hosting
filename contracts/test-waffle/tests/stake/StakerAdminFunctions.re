open Globals;
open LetOps;
open StakerHelpers;
open Mocha;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe_only("Staker Admin Functions", () => {
    let marketIndex = Helpers.randomJsInteger();
    let randomAddress1 = Helpers.randomAddress();

    describe("changeAdmin", () => {
      let txPromiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
        ref(()->JsPromise.resolve->Obj.magic);

      before_once'(() => {
        let%Await _ =
          deployAndSetupStakerToUnitTest(
            ~functionName="changeAdmin",
            ~contracts,
            ~accounts,
          );

        txPromiseRef :=
          contracts.contents.staker->Staker.changeAdmin(~admin=randomAddress1);
        txPromiseRef.contents;
      });

      it("should call the onlyAdmin modifier", () => {
        StakerSmocked.InternalMock.onlyAdminModifierLogicCalls()
        ->Array.length
        ->Chai.intEqual(1)
      });

      it("emits ChangeAdmin with correct argument", () => {
        Chai.callEmitEvents(
          ~call=txPromiseRef.contents,
          ~contract=contracts.contents.staker->Obj.magic,
          ~eventName="ChangeAdmin",
        )
        ->Chai.withArgs2(randomAddress1)
      });

      it("should allow admin to change admin correctly", () => {
        let newAdmin = Helpers.randomAddress();
        let currentAdmin = accounts.contents->Array.getUnsafe(0);

        let%Await _ =
          contracts.contents.staker
          ->ContractHelpers.connect(~address=currentAdmin)
          ->Staker.changeAdmin(~admin=newAdmin);

        let%Await updatedAdmin =
          contracts.contents.staker->Staker.Exposed.admin;

        Chai.addressEqual(
          updatedAdmin,
          ~otherAddress=newAdmin,
          ~message="staker admin is not newAdmin",
        );
      });
    });

    describe("changeFloatPercentage", () => {
      let newFloatPerc = bnFromString("42000000000000000");

      let txPromiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
        ref(()->JsPromise.resolve->Obj.magic);

      before_once'(() => {
        let%Await _ =
          deployAndSetupStakerToUnitTest(
            ~functionName="changeFloatPercentage",
            ~contracts,
            ~accounts,
          );

        txPromiseRef :=
          contracts.contents.staker
          ->Staker.Exposed.changeFloatPercentage(
              ~newFloatPercentage=newFloatPerc,
            );
        txPromiseRef.contents;
      });

      it("should call the onlyAdmin modifier", () => {
        StakerSmocked.InternalMock.onlyAdminModifierLogicCalls()
        ->Array.length
        ->Chai.intEqual(1)
      });

      it("should call _changeFloatPercentage with correct argument", () => {
        StakerSmocked.InternalMock._changeFloatPercentageCalls()
        ->Array.getUnsafe(0)
        ->Chai.recordEqualFlat({newFloatPercentage: newFloatPerc})
      });

      it("emits FloatPercentageUpdated with correct argument", () => {
        Chai.callEmitEvents(
          ~call=txPromiseRef.contents,
          ~contract=contracts.contents.staker->Obj.magic,
          ~eventName="FloatPercentageUpdated",
        )
        ->Chai.withArgs2(newFloatPerc)
      });

      it("should revert if !(0 < newFloatPercentage <= 100 percent)", () => {
        let testValueWithinBounds = bnFromString("420000000000000000");
        let testValueOutOfBoundsLowSide = bnFromInt(0);
        let testValueOutOfBoundsHighSide =
          bnFromString("1010000000000000000");

        let%Await _ =
          contracts.contents.staker
          ->Staker.Exposed._changeFloatPercentageExposed(
              ~newFloatPercentage=testValueWithinBounds,
            );

        let%Await _ =
          Chai.expectRevert(
            ~transaction=
              contracts.contents.staker
              ->Staker.Exposed._changeFloatPercentageExposed(
                  ~newFloatPercentage=testValueOutOfBoundsLowSide,
                ),
            ~reason="",
          );

        Chai.expectRevert(
          ~transaction=
            contracts.contents.staker
            ->Staker.Exposed._changeFloatPercentageExposed(
                ~newFloatPercentage=testValueOutOfBoundsHighSide,
              ),
          ~reason="",
        );
      });

      it("should update floatPercentage correctly", () => {
        let randomNewFloatPerc =
          Helpers.randomInteger()->mul(bnFromString("10000000"));

        let%Await _ =
          contracts.contents.staker
          ->Staker.Exposed._changeFloatPercentageExposed(
              ~newFloatPercentage=randomNewFloatPerc,
            );

        let%Await floatPercAfterCall =
          contracts.contents.staker->Staker.Exposed.floatPercentage;

        Chai.bnEqual(randomNewFloatPerc, floatPercAfterCall);
      });
    });

    describe("changeUnstakeFee", () => {
      let unstakeFeeBasisPoints = Helpers.randomInteger();

      let txPromiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
        ref(()->JsPromise.resolve->Obj.magic);

      before_once'(() => {
        let%Await _ =
          deployAndSetupStakerToUnitTest(
            ~functionName="changeUnstakeFee",
            ~contracts,
            ~accounts,
          );

        txPromiseRef :=
          contracts.contents.staker
          ->Staker.Exposed.changeUnstakeFee(
              ~marketIndex,
              ~newMarketUnstakeFee_e18=unstakeFeeBasisPoints,
            );
        txPromiseRef.contents;
      });

      it("should call _changeUnstakeFee with correct arguments", () => {
        StakerSmocked.InternalMock._changeUnstakeFeeCalls()
        ->Array.getUnsafe(0)
        ->Chai.recordEqualFlat({
            marketIndex,
            newMarketUnstakeFee_e18: unstakeFeeBasisPoints,
          })
      });

      it("should emit StakeWithdrawalFeeUpdated with correct arguments", () => {
        Chai.callEmitEvents(
          ~call=txPromiseRef.contents,
          ~contract=contracts.contents.staker->Obj.magic,
          ~eventName="StakeWithdrawalFeeUpdated",
        )
        ->Chai.withArgs2(marketIndex, unstakeFeeBasisPoints)
      });

      it("should not allow new unstake fee greater than 5 percent", () => {
        let adminWallet = accounts.contents->Array.getUnsafe(0);
        let sixPercent = bnFromString("60000000000000000");

        let%Await _ =
          Chai.expectRevert(
            ~transaction=
              contracts.contents.staker
              ->ContractHelpers.connect(~address=adminWallet)
              ->Staker.Exposed._changeUnstakeFeeExposed(
                  ~marketIndex,
                  ~newMarketUnstakeFee_e18=sixPercent,
                ),
            ~reason="",
          );
        ();
      });

      it("should update unstake fee correctly", () => {
        let adminWallet = accounts.contents->Array.getUnsafe(0);
        let newFeePercentageRandom =
          Helpers.randomInteger()->mul(bnFromString("10000000"));

        let%Await _ =
          contracts.contents.staker
          ->ContractHelpers.connect(~address=adminWallet)
          ->Staker.Exposed._changeUnstakeFeeExposed(
              ~marketIndex=1,
              ~newMarketUnstakeFee_e18=newFeePercentageRandom,
            );

        let%Await feeAfterCall =
          contracts.contents.staker->Staker.Exposed.marketUnstakeFee_e18(1);

        Chai.bnEqual(feeAfterCall, newFeePercentageRandom);
      });
    });
  });
};
