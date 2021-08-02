open Globals;
open LetOps;
open StakerHelpers;
open Mocha;

let testUnit =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describeUnit("Staker Admin Functions", () => {
    let marketIndex = Helpers.randomJsInteger();
    let randomAddress1 = Helpers.randomAddress();

    describe("changeAdmin", () => {
      it_only("should not allow non-admin to change admin", () => {
        let {staker} = contracts.contents;
        let user1 = (accounts^)->Array.getUnsafe(5);

        let%Await _ =
          Chai.expectRevert(
            ~transaction=
              staker
              ->ContractHelpers.connect(~address=user1)
              ->Staker.changeAdmin(~admin=randomAddress1),
            ~reason="not admin",
          );
      });

      it_only("should allow admin to change admin correctly", () => {
        let {staker} = contracts.contents;
        let newAdmin = Helpers.randomAddress();
        let currentAdmin = (accounts^)->Array.getUnsafe(0);

        let%Await _ =
          staker
          ->ContractHelpers.connect(~address=currentAdmin)
          ->Staker.changeAdmin(~admin=newAdmin);

        let%Await updatedAdmin = staker->Staker.Exposed.admin;

        Chai.addressEqual(
          updatedAdmin,
          ~otherAddress=newAdmin,
          ~message="staker admin is not newAdmin",
        );
      });
    });

    describe("changeFloatPercentage (external)", () => {
      it_only("should not allow non-admin to change float percentage", () => {
        let randomWallet = (accounts^)->Array.getUnsafe(5);

        let%Await _ =
          Chai.expectRevert(
            ~transaction=
              contracts.contents.staker
              ->ContractHelpers.connect(~address=randomWallet)
              ->Staker.changeFloatPercentage(
                  ~newFloatPercentage=bnFromInt(42),
                ),
            ~reason="not admin",
          );
      })
    });

    describe("_changeFloatPercentage (internal)", () => {
      it_only("should revert if !(0 < newFloatPercentage <= 100 percent)", () => {
        let testValueWithinBounds = bnFromInt(42000000000000000);
        let testValueOutOfBounds = bnFromInt(0);

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
                  ~newFloatPercentage=testValueOutOfBounds,
                ),
            ~reason="",
          );
      });
      
      it_only("should update floatPercentage correctly", () => {
        let {staker} = contracts.contents;

        let newFloatPercentage = bnFromInt(42000000000000000);

        let%Await _ =
          staker->Staker.Exposed._changeFloatPercentageExposed(
            ~newFloatPercentage,
          );

        let%Await floatPercAfterCall = staker->Staker.Exposed.floatPercentage;

        Chai.bnEqual(newFloatPercentage, floatPercAfterCall);
      });
    });
    // describe("UNFINISHED changeUnstakeFee (external)", () => {
    //   let marketIndex = 1;
    //   it("UNFINISHED: should not allow non-admin to change unstake fee", () => {
    //     let randomWallet = (accounts^)->Array.getUnsafe(5);
    //     // should revert with a non-admin caller
    //     let%Await _ =
    //       Chai.expectRevert(
    //         ~transaction=
    //           contracts.contents.staker
    //           ->ContractHelpers.connect(~address=randomWallet)
    //           ->Staker.changeUnstakeFee(
    //               ~marketIndex,
    //               ~newMarketUnstakeFeeBasisPoints=bnFromInt(42),
    //             ),
    //         ~reason="not admin",
    //       );
    //     ();
    //   });
    //   it("should call _changeUnstakeFee with correct arguments", () => {
    //     ()
    //   });
    //   it("UNFINISHED: should emit StakeWithdrawalFeeUpdated with correct parameters", () => {
    //     let {staker} = contracts.contents;
    //     let adminWallet = (accounts^)->Array.getUnsafe(5);
    //     contracts.contents.staker
    //     ->ContractHelpers.connect(~address=adminWallet)
    //     ->Staker.changeUnstakeFee(
    //         ~marketIndex,
    //         ~newMarketUnstakeFeeBasisPoints=bnFromInt(42),
    //       );
    //     //Chai.expectEvent(marketIndex, newMarketUnstakeFeeBasisPoints)
    //   });
    // });
    // describe("UNFINISHED: _changeUnstakeFee (internal)", () => {
    //   it("should not allow new fee greater than 5 percent", () => {
    //     let {staker} = contracts.contents;
    //     let adminWallet = (accounts^)->Array.getUnsafe(0);
    //     let marketIndex = 1;
    //     let sixPercent = bnFromInt(700000000000000);
    //     let%Await _ =
    //       Chai.expectRevert(
    //         ~transaction=
    //           staker
    //           ->ContractHelpers.connect(~address=adminWallet)
    //           ->Staker.Exposed._changeUnstakeFeeExposed(
    //               ~marketIndex,
    //               ~newMarketUnstakeFeeBasisPoints=sixPercent,
    //             ),
    //         ~reason="fee must be <= 5 percent",
    //       );
    //     ();
    //   });
    //   it("should update unstake fee correctly", () => {
    //     ()
    //   });
    // });
  });
};
