open Globals;
open LetOps;

let testExposed =
    (
      ~contracts: ref(Helpers.coreContracts),
      ~accounts: ref(array(Ethers.Wallet.t)),
    ) =>
  describe("lazyDeposits", () =>
    it("calls the executeOutstandingLazyDeposits modifier", () => {
      ()
    })
  );
