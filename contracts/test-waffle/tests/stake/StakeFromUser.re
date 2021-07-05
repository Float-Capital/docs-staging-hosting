open Globals;
open LetOps;
open StakerHelpers;
open Mocha;

let test =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) => {
  describe("stakeFromUser", () => {
    let stakerRef: ref(Staker.t) = ref(None->Obj.magic);

    let from = Helpers.randomAddress();
    let amount = Helpers.randomTokenAmount();
    let mockTokenWalletRef: ref(Ethers.Wallet.t) = ref(None->Obj.magic);

    before_once'(() => {
      let%Await _ =
        stakerRef->deployAndSetupStakerToUnitTest(
          ~functionName="stakeFromUser",
          ~contracts,
          ~accounts,
        );

      mockTokenWalletRef := (accounts^)->Array.getExn(6);

      StakerSmocked.InternalMock.mockOnlyValidSyntheticToReturn();
      StakerSmocked.InternalMock.mock_stakeToReturn();

      (stakerRef^)
      ->ContractHelpers.connect(~address=mockTokenWalletRef^)
      ->Staker.stakeFromUser(~from, ~amount);
    });

    it("calls onlyValidSynthetic with correct args", () =>
      StakerSmocked.InternalMock.onlyValidSyntheticCalls()
      ->Array.getExn(0)
      ->Chai.recordEqualFlat({synth: mockTokenWalletRef^.address})
    );

    it("calls _stake with correct args", () =>
      StakerSmocked.InternalMock._stakeCalls()
      ->Array.getExn(0)
      ->Chai.recordEqualFlat({
          token: mockTokenWalletRef^.address,
          amount,
          user: from,
        })
    );
  });
};
