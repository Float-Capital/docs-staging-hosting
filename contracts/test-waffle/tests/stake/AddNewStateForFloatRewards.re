open Globals;
open LetOps;
open StakerHelpers;
open Mocha;
let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  let promiseRef: ref(JsPromise.t(ContractHelpers.transaction)) =
    ref(None->Obj.magic);
  let timestampRef: ref(Ethers.BigNumber.t) = ref(CONSTANTS.zeroBn);
  let marketIndex = Helpers.randomJsInteger();
  let (longPrice, shortPrice, longValue, shortValue, timeDeltaGreaterThanZero) =
    Helpers.Tuple.make5(Helpers.randomInteger);
  describe("addNewStateForFloatRewards", () => {
    let setup = (~timeDelta) => {
      let longShortAddress = (accounts^)->Array.getUnsafe(5);
      let%AwaitThen _ =
        deployAndSetupStakerToUnitTest(
          ~functionName="addNewStateForFloatRewards",
          ~contracts,
          ~accounts,
        );
      // StakerSmocked.InternalMock.mockOnlyFloatToReturn();
      StakerSmocked.InternalMock.mock_calculateTimeDeltaToReturn(timeDelta);
      StakerSmocked.InternalMock.mock_setRewardObjectsToReturn();
      let%AwaitThen {timestamp} = Helpers.getBlock();
      timestampRef := (timestamp + 1)->Ethers.BigNumber.fromInt; // one second per block

      let%AwaitThen _ =
        contracts^.staker
        ->Staker.Exposed.setAddNewStateForFloatRewardsParams(
            ~longShortAddress=longShortAddress.address,
          );
      promiseRef :=
        contracts^.staker
        ->ContractHelpers.connect(~address=longShortAddress)
        ->Obj.magic
        ->Staker.addNewStateForFloatRewards(
            ~marketIndex,
            ~longPrice,
            ~shortPrice,
            ~longValue,
            ~shortValue,
          );
      let%Await _ = promiseRef^;
      ();
    };

    describe("case timeDelta > 0", () => {
      before_once'(() => setup(~timeDelta=timeDeltaGreaterThanZero));

      it_skip("calls the onlyLongShort modifier", () => {
        // StakerSmocked.InternalMock.onlyFloatCalls()
        // ->Array.length
        // ->Chai.intEqual(1)
        ()
      });

      it("calls calculateTimeDelta with correct arguments", () => {
        StakerSmocked.InternalMock._calculateTimeDeltaCalls()
        ->Array.getExn(0)
        ->Chai.recordEqualFlat({marketIndex: marketIndex})
      });

      it("calls setRewardObjects with correct arguments", () => {
        StakerSmocked.InternalMock._setRewardObjectsCalls()
        ->Array.getExn(0)
        ->Chai.recordEqualFlat({
            marketIndex,
            longPrice,
            shortPrice,
            longValue,
            shortValue,
          })
      });
    });

    describe("case timeDelta == 0", () => {
      // still calls onlyLongShort + calculateTimeDelta but unwieldy to test twice
      it("doesn't call setRewardObjects", () => {
        let%Await _ = setup(~timeDelta=CONSTANTS.zeroBn);
        StakerSmocked.InternalMock._setRewardObjectsCalls()
        ->Array.length
        ->Chai.intEqual(0);
      })
    });
  });
};
